Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89522C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEZCPJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEZCPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:15:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9DA135
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA524614A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CFFC4339B;
        Fri, 26 May 2023 02:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067306;
        bh=/JXNaE8t4FCqldPDakHp3nlXrZZ8U72FV9MqADCxOok=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ZuiIf5EF1KKUIJxhKeEkr6s8f/y56R/tCNmcXyMpxj84bX+M44rD3R81YN2cC/Fhw
         vc4ArGh4lelVQTDr1nAQwwSbtSU8M8dxkRbZV8ijgz3wPw9XPfILQB40RV+GcrMzB2
         MLqbOeuh2HkQg3x2w3cBHDVSsZ5LBqcSVSpYnhdCLKBxZK9P8/omA67OlfaDBom9t2
         yPU5AxSYxbzrbtwwux9abyrIbdZ8vVX29MefMPL+63c1bypO03VAbZ5sSWcV0/fw6d
         /qR+LbvsgWEXEa+Lo+FfcPqTW4laZzGxapy4dRFYfZrX+TFnTBMWvQtG+uyIK2F8tv
         +lU+B/EwdqizQ==
Date:   Thu, 25 May 2023 19:15:05 -0700
Subject: [PATCH 02/17] xfs: deferred scrub of dirents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073324.3745075.11598495890056456087.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the trylock-based parent pointer check fails, retain those dirents
and check them at the end.  This may involve dropping the locks on the
file being scanned, so yay.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir.c   |  228 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h |   33 +++++++
 2 files changed, 259 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index a0e16ab3419a..0d4aaea271a2 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -22,6 +22,10 @@
 #include "scrub/dabtree.h"
 #include "scrub/readdir.h"
 #include "scrub/repair.h"
+#include "scrub/trace.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
 
 /* Set us up to scrub directories. */
 int
@@ -41,6 +45,18 @@ xchk_setup_directory(
 
 /* Directories */
 
+/* Deferred directory entry that we saved for later. */
+struct xchk_dirent {
+	/* Cookie for retrieval of the dirent name. */
+	xfblob_cookie			name_cookie;
+
+	/* Child inode number. */
+	xfs_ino_t			ino;
+
+	/* Length of the pptr name. */
+	uint8_t				namelen;
+};
+
 struct xchk_dir {
 	struct xfs_scrub	*sc;
 
@@ -50,6 +66,15 @@ struct xchk_dir {
 	/* xattr key and da args for parent pointer validation. */
 	struct xfs_parent_scratch pptr_scratch;
 
+	/* Fixed-size array of xchk_dirent structures. */
+	struct xfarray		*dir_entries;
+
+	/* Blobs containing dirent names. */
+	struct xfblob		*dir_names;
+
+	/* If we've cycled the ILOCK, we must revalidate deferred dirents. */
+	bool			need_revalidate;
+
 	/* Name buffer for dirent revalidation. */
 	uint8_t			namebuf[MAXNAMELEN];
 
@@ -150,8 +175,26 @@ xchk_dir_check_pptr_fast(
 	/* Try to lock the inode. */
 	lockmode = xchk_dir_lock_child(sc, ip);
 	if (!lockmode) {
-		xchk_set_incomplete(sc);
-		return -ECANCELED;
+		struct xchk_dirent	save_de = {
+			.namelen	= name->len,
+			.ino		= ip->i_ino,
+		};
+
+		/* Couldn't lock the inode, so save the dirent for later. */
+		trace_xchk_dir_defer(sc->ip, name->name, name->len, ip->i_ino);
+
+		error = xfblob_store(sd->dir_names, &save_de.name_cookie,
+				name->name, name->len);
+		if (xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+					&error))
+			return error;
+
+		error = xfarray_append(sd->dir_entries, &save_de);
+		if (xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+					&error))
+			return error;
+
+		return 0;
 	}
 
 	error = xchk_dir_parent_pointer(sd, name, ip);
@@ -867,6 +910,156 @@ xchk_directory_blocks(
 	return error;
 }
 
+/*
+ * Revalidate a dirent that we collected in the past but couldn't check because
+ * of lock contention.  Returns 0 if the dirent is still valid, -ENOENT if it
+ * has gone away on us, or a negative errno.
+ */
+STATIC int
+xchk_dir_revalidate_dirent(
+	struct xchk_dir		*sd,
+	const struct xfs_name	*xname,
+	xfs_ino_t		ino)
+{
+	struct xfs_scrub	*sc = sd->sc;
+	xfs_ino_t		child_ino;
+	int			error;
+
+	/*
+	 * Look up the directory entry.  If we get -ENOENT, the directory entry
+	 * went away and there's nothing to revalidate.  Return any other
+	 * error.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, xname, &child_ino);
+	if (error)
+		return error;
+
+	/* The inode number changed, nothing to revalidate. */
+	if (ino != child_ino)
+		return -ENOENT;
+
+	return 0;
+}
+
+/*
+ * Check a directory entry's parent pointers the slow way, which means we cycle
+ * locks a bunch and put up with revalidation until we get it done.
+ */
+STATIC int
+xchk_dir_slow_dirent(
+	struct xchk_dir		*sd,
+	struct xchk_dirent	*dirent)
+{
+	struct xfs_name		xname = {
+		.name		= sd->namebuf,
+		.len		= dirent->namelen,
+	};
+	struct xfs_scrub	*sc = sd->sc;
+	struct xfs_inode	*ip;
+	unsigned int		lockmode;
+	int			error;
+
+	/* Check that the deferred dirent still exists. */
+	if (sd->need_revalidate) {
+		error = xchk_dir_revalidate_dirent(sd, &xname, dirent->ino);
+		if (error == -ENOENT)
+			return 0;
+		if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0,
+					&error))
+			return error;
+	}
+
+	error = xchk_iget(sc, dirent->ino, &ip);
+	if (error == -EINVAL || error == -ENOENT) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+		return error;
+
+	/*
+	 * If we can grab both IOLOCK and ILOCK of the alleged child, we can
+	 * proceed with the validation.
+	 */
+	lockmode = xchk_dir_lock_child(sc, ip);
+	if (lockmode)
+		goto check_pptr;
+
+	/*
+	 * We couldn't lock the child file.  Drop all the locks and try to
+	 * get them again, one at a time.
+	 */
+	xchk_iunlock(sc, sc->ilock_flags);
+	sd->need_revalidate = true;
+
+	trace_xchk_dir_slowpath(sc->ip, xname.name, xname.len, ip->i_ino);
+
+	while (true) {
+		xchk_ilock(sc, XFS_IOLOCK_EXCL);
+		if (xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
+			xchk_ilock(sc, XFS_ILOCK_EXCL);
+			if (xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+				break;
+			}
+			xchk_iunlock(sc, XFS_ILOCK_EXCL);
+		}
+		xchk_iunlock(sc, XFS_IOLOCK_EXCL);
+
+		if (xchk_should_terminate(sc, &error))
+			goto out_rele;
+
+		delay(1);
+	}
+	lockmode = XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL;
+
+	/* Revalidate, since we just cycled the locks. */
+	error = xchk_dir_revalidate_dirent(sd, &xname, dirent->ino);
+	if (error == -ENOENT)
+		goto out_unlock;
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+		goto out_unlock;
+
+check_pptr:
+	error = xchk_dir_parent_pointer(sd, &xname, ip);
+out_unlock:
+	xfs_iunlock(ip, lockmode);
+out_rele:
+	xchk_irele(sc, ip);
+	return error;
+}
+
+/* Check all the dirents that we deferred the first time around. */
+STATIC int
+xchk_dir_finish_slow_dirents(
+	struct xchk_dir		*sd)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	foreach_xfarray_idx(sd->dir_entries, array_cur) {
+		struct xchk_dirent	dirent;
+
+		if (sd->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			return 0;
+
+		error = xfarray_load(sd->dir_entries, array_cur, &dirent);
+		if (error)
+			return error;
+
+		error = xfblob_load(sd->dir_names, dirent.name_cookie,
+				sd->namebuf, dirent.namelen);
+		if (error)
+			return error;
+		sd->namebuf[MAXNAMELEN - 1] = 0;
+
+		error = xchk_dir_slow_dirent(sd, &dirent);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
 /* Scrub a whole directory. */
 int
 xchk_directory(
@@ -905,11 +1098,42 @@ xchk_directory(
 		return -ENOMEM;
 	sd->sc = sc;
 
+	if (xfs_has_parent(sc->mp)) {
+		/*
+		 * Set up some staging memory for dirents that we can't check
+		 * due to locking contention.
+		 */
+		error = xfarray_create(sc->mp, "slow directory entries", 0,
+				sizeof(struct xchk_dirent), &sd->dir_entries);
+		if (error)
+			goto out_sd;
+
+		error = xfblob_create(sc->mp, "slow directory entry names",
+				&sd->dir_names);
+		if (error)
+			goto out_entries;
+	}
+
 	/* Look up every name in this directory by hash. */
 	error = xchk_dir_walk(sc, sc->ip, xchk_dir_actor, sd);
 	if (error == -ECANCELED)
 		error = 0;
+	if (error)
+		goto out_names;
 
+	if (xfs_has_parent(sc->mp)) {
+		error = xchk_dir_finish_slow_dirents(sd);
+		if (error)
+			goto out_names;
+	}
+
+out_names:
+	if (sd->dir_names)
+		xfblob_destroy(sd->dir_names);
+out_entries:
+	if (sd->dir_entries)
+		xfarray_destroy(sd->dir_entries);
+out_sd:
 	kvfree(sd);
 	return error;
 }
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index e1544c044a60..539c51545bcd 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1417,6 +1417,39 @@ DEFINE_EVENT(xchk_nlinks_diff_class, name, \
 	TP_ARGS(mp, ip, live))
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xchk_nlinks_compare_inode);
 
+DECLARE_EVENT_CLASS(xchk_pptr_class,
+	TP_PROTO(struct xfs_inode *ip, const unsigned char *name,
+		 unsigned int namelen, xfs_ino_t parent_ino),
+	TP_ARGS(ip, name, namelen, parent_ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, namelen)
+		__field(xfs_ino_t, parent_ino)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->namelen = namelen;
+		memcpy(__get_str(name), name, namelen);
+		__entry->parent_ino = parent_ino;
+	),
+	TP_printk("dev %d:%d ino 0x%llx name '%.*s' parent_ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->parent_ino)
+)
+#define DEFINE_XCHK_PPTR_CLASS(name) \
+DEFINE_EVENT(xchk_pptr_class, name, \
+	TP_PROTO(struct xfs_inode *ip, const unsigned char *name, \
+		 unsigned int namelen, xfs_ino_t parent_ino), \
+	TP_ARGS(ip, name, namelen, parent_ino))
+DEFINE_XCHK_PPTR_CLASS(xchk_dir_defer);
+DEFINE_XCHK_PPTR_CLASS(xchk_dir_slowpath);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 

