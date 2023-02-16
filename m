Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B099DC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjBPUuN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjBPUuN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:50:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5244C3C3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8BBCB82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CDEC433D2;
        Thu, 16 Feb 2023 20:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580608;
        bh=Xl3AYVRwiF4XhTBdsM73BDTXAAxCb06LL2ae0jFxmgA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qE/nbqbx2Qc0fmQWNG0i8WNouZdqm1X5CQZQQnsYdiNKVG8Ju29BiFNowrR2tKHSt
         9JnXBGH2givcYH2od9+aDmQLWZ9ZqI1wh6OmaSidciS/qXulTw34mm7RCnjpT72ksK
         8d1xoAbAqWl+1sI7bIO4sGYlrsmbALmzk7VJVdG8uFAVv4h39ZK8oPwidzy/LAawxN
         SNKVwPedmpaBd9mKUheON44bbogQ2R6ZOFo5uuwmgDt01mEPwy0hD1OT/Q6c5Wppab
         kXadDfMemPle2a7JabGqPnAvN5fGiGFubBBiGSKIKHoxcJVpHUzzENdCo8WyG5MoWn
         dX8sDChtqAqIw==
Date:   Thu, 16 Feb 2023 12:50:07 -0800
Subject: [PATCH 2/2] xfs: deferred scrub of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874893.3475106.7328116715501034300.stgit@magnolia>
In-Reply-To: <167657874864.3475106.13930268587808485264.stgit@magnolia>
References: <167657874864.3475106.13930268587808485264.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the trylock-based dirent check fails, retain those parent pointers
and check them at the end.  This may involve dropping the locks on the
file being scanned, so yay.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile            |    2 
 fs/xfs/libxfs/xfs_parent.c |   38 +++++++
 fs/xfs/libxfs/xfs_parent.h |   10 ++
 fs/xfs/scrub/parent.c      |  246 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h       |   33 ++++++
 5 files changed, 324 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a32f6da27a86..0a908382d033 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -168,6 +168,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   scrub.o \
 				   symlink.o \
 				   xfarray.o \
+				   xfblob.o \
 				   xfile.o \
 				   )
 
@@ -181,7 +182,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   dir_repair.o \
 				   repair.o \
 				   tempfile.o \
-				   xfblob.o \
 				   )
 endif
 endif
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index fe6d4d1a7d57..36e1968337d5 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -298,3 +298,41 @@ xfs_pptr_calc_space_res(
 	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
 }
 
+/*
+ * Look up the @name associated with the parent pointer (@pptr) of @ip.  Caller
+ * must hold at least ILOCK_SHARED.  Returns the length of the dirent name, or
+ * a negative errno.  The scratchpad need not be initialized.
+ */
+int
+xfs_parent_lookup(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	unsigned char			*name,
+	unsigned int			namelen,
+	struct xfs_parent_scratch	*scr)
+{
+	int				error;
+
+	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+
+	memset(&scr->args, 0, sizeof(struct xfs_da_args));
+	scr->args.attr_filter	= XFS_ATTR_PARENT;
+	scr->args.dp		= ip;
+	scr->args.geo		= ip->i_mount->m_attr_geo;
+	scr->args.name		= (const unsigned char *)&scr->rec;
+	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.op_flags	= XFS_DA_OP_OKNOENT;
+	scr->args.trans		= tp;
+	scr->args.valuelen	= namelen;
+	scr->args.value		= name;
+	scr->args.whichfork	= XFS_ATTR_FORK;
+
+	scr->args.hashval = xfs_da_hashname(scr->args.name, scr->args.namelen);
+
+	error = xfs_attr_get_ilocked(&scr->args);
+	if (error)
+		return error;
+
+	return scr->args.valuelen;
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 4eb92fb4b11b..cd1b135195a2 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -103,4 +103,14 @@ xfs_parent_finish(
 unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 				     unsigned int namelen);
 
+/* Scratchpad memory so that raw parent operations don't burn stack space. */
+struct xfs_parent_scratch {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr, unsigned char *name,
+		unsigned int namelen, struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 1bb196f2c1b2..056e11337cec 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -20,6 +20,9 @@
 #include "scrub/common.h"
 #include "scrub/readdir.h"
 #include "scrub/listxattr.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
 #include "scrub/trace.h"
 
 /* Set us up to scrub parents. */
@@ -302,14 +305,43 @@ xchk_parent(
  * to the child file.
  */
 
+/* Deferred parent pointer entry that we saved for later. */
+struct xchk_pptr {
+	/* Cookie for retrieval of the pptr name. */
+	xfblob_cookie			name_cookie;
+
+	/* Parent pointer attr key. */
+	xfs_ino_t			p_ino;
+	uint32_t			p_gen;
+	xfs_dir2_dataptr_t		p_diroffset;
+
+	/* Length of the pptr name. */
+	uint8_t				namelen;
+};
+
 struct xchk_pptrs {
 	struct xfs_scrub	*sc;
 
 	/* Scratch buffer for scanning pptr xattrs */
 	struct xfs_parent_name_irec pptr;
 
+	/* Fixed-size array of xchk_pptr structures. */
+	struct xfarray		*pptr_entries;
+
+	/* Blobs containing parent pointer names. */
+	struct xfblob		*pptr_names;
+
 	/* Parent of this directory. */
 	xfs_ino_t		parent_ino;
+
+	/* If we've cycled the ILOCK, we must revalidate all deferred pptrs. */
+	bool			need_revalidate;
+
+	/* xattr key and da args for parent pointer revalidation. */
+	struct xfs_parent_scratch pptr_scratch;
+
+	/* Name buffer for revalidation. */
+	uint8_t			namebuf[MAXNAMELEN];
 };
 
 /* Look up the dotdot entry so that we can check it as we walk the pptrs. */
@@ -528,8 +560,26 @@ xchk_parent_scan_attr(
 	/* Try to lock the inode. */
 	lockmode = xchk_parent_lock_dir(sc, dp);
 	if (!lockmode) {
-		xchk_set_incomplete(sc);
-		error = -ECANCELED;
+		struct xchk_pptr	save_pp = {
+			.p_ino		= pp->pptr.p_ino,
+			.p_gen		= pp->pptr.p_gen,
+			.p_diroffset	= pp->pptr.p_diroffset,
+			.namelen	= pp->pptr.p_namelen,
+		};
+
+		/* Couldn't lock the inode, so save the pptr for later. */
+		trace_xchk_parent_defer(sc->ip, pp->pptr.p_name,
+				pp->pptr.p_namelen, dp->i_ino);
+
+		error = xfblob_store(pp->pptr_names, &save_pp.name_cookie,
+				pp->pptr.p_name, pp->pptr.p_namelen);
+		if (xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
+			goto out_rele;
+
+		error = xfarray_append(pp->pptr_entries, &save_pp);
+		if (xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
+			goto out_rele;
+
 		goto out_rele;
 	}
 
@@ -544,6 +594,173 @@ xchk_parent_scan_attr(
 	return error;
 }
 
+/*
+ * Revalidate a parent pointer that we collected in the past but couldn't check
+ * because of lock contention.  Returns 0 if the parent pointer is still valid,
+ * -ENOENT if it has gone away on us, or a negative errno.
+ */
+STATIC int
+xchk_parent_revalidate_pptr(
+	struct xchk_pptrs	*pp)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	int			namelen;
+
+	namelen = xfs_parent_lookup(sc->tp, sc->ip, &pp->pptr, pp->namebuf,
+			MAXNAMELEN, &pp->pptr_scratch);
+	if (namelen == -ENOATTR) {
+		/*  Parent pointer went away, nothing to revalidate. */
+		return -ENOENT;
+	}
+	if (namelen < 0 && namelen != -EEXIST)
+		return namelen;
+
+	/*
+	 * The dirent name changed length while we were unlocked.  No need
+	 * to revalidate this.
+	 */
+	if (namelen != pp->pptr.p_namelen)
+		return -ENOENT;
+
+	/* The dirent name itself changed; there's nothing to revalidate. */
+	if (memcmp(pp->namebuf, pp->pptr.p_name, pp->pptr.p_namelen))
+		return -ENOENT;
+	return 0;
+}
+
+/*
+ * Check a parent pointer the slow way, which means we cycle locks a bunch
+ * and put up with revalidation until we get it done.
+ */
+STATIC int
+xchk_parent_slow_pptr(
+	struct xchk_pptrs	*pp,
+	struct xchk_pptr	*pptr)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	struct xfs_inode	*dp = NULL;
+	unsigned int		lockmode;
+	int			error;
+
+	/* Restore the saved parent pointer into the irec. */
+	pp->pptr.p_ino = pptr->p_ino;
+	pp->pptr.p_gen = pptr->p_gen;
+	pp->pptr.p_diroffset = pptr->p_diroffset;
+
+	error = xfblob_load(pp->pptr_names, pptr->name_cookie, pp->pptr.p_name,
+			pptr->namelen);
+	if (error)
+		return error;
+	pp->pptr.p_name[MAXNAMELEN - 1] = 0;
+	pp->pptr.p_namelen = pptr->namelen;
+
+	/* Check that the deferred parent pointer still exists. */
+	if (pp->need_revalidate) {
+		error = xchk_parent_revalidate_pptr(pp);
+		if (error == -ENOENT)
+			return 0;
+		if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0,
+					&error))
+			return error;
+	}
+
+	error = xchk_parent_iget(pp, &dp);
+	if (error)
+		return error;
+	if (!dp)
+		return 0;
+
+	/*
+	 * If we can grab both IOLOCK and ILOCK of the alleged parent, we
+	 * can proceed with the validation.
+	 */
+	lockmode = xchk_parent_lock_dir(sc, dp);
+	if (lockmode)
+		goto check_dirent;
+
+	/*
+	 * We couldn't lock the parent dir.  Drop all the locks and try to
+	 * get them again, one at a time.
+	 */
+	xchk_iunlock(sc, sc->ilock_flags);
+	pp->need_revalidate = true;
+
+	trace_xchk_parent_slowpath(sc->ip, pp->namebuf, pptr->namelen,
+			dp->i_ino);
+
+	while (true) {
+		xchk_ilock(sc, XFS_IOLOCK_EXCL);
+		if (xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
+			xchk_ilock(sc, XFS_ILOCK_EXCL);
+			if (xfs_ilock_nowait(dp, XFS_ILOCK_EXCL)) {
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
+	/*
+	 * If we didn't already find a parent pointer matching the dotdot
+	 * entry, re-query the dotdot entry so that we can validate it.
+	 */
+	if (pp->parent_ino != NULLFSINO) {
+		error = xchk_parent_dotdot(pp);
+		if (error)
+			goto out_unlock;
+	}
+
+	/* Revalidate the parent pointer now that we cycled locks. */
+	error = xchk_parent_revalidate_pptr(pp);
+	if (error == -ENOENT)
+		goto out_unlock;
+	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		goto out_unlock;
+
+check_dirent:
+	error = xchk_parent_dirent(pp, dp);
+out_unlock:
+	xfs_iunlock(dp, lockmode);
+out_rele:
+	xchk_irele(sc, dp);
+	return error;
+}
+
+/* Check all the parent pointers that we deferred the first time around. */
+STATIC int
+xchk_parent_finish_slow_pptrs(
+	struct xchk_pptrs	*pp)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	foreach_xfarray_idx(pp->pptr_entries, array_cur) {
+		struct xchk_pptr	pptr;
+
+		if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+			return 0;
+
+		error = xfarray_load(pp->pptr_entries, array_cur, &pptr);
+		if (error)
+			return error;
+
+		error = xchk_parent_slow_pptr(pp, &pptr);
+		if (error)
+			return error;
+	}
+
+	/* Empty out both xfiles now that we've checked everything. */
+	xfarray_truncate(pp->pptr_entries);
+	xfblob_truncate(pp->pptr_names);
+	return 0;
+}
+
 /* Check parent pointers of a file. */
 STATIC int
 xchk_parent_pptr(
@@ -561,14 +778,35 @@ xchk_parent_pptr(
 	if (error)
 		goto out_pp;
 
+	/*
+	 * Set up some staging memory for parent pointers that we can't check
+	 * due to locking contention.
+	 */
+	error = xfarray_create(sc->mp, "pptr entries", 0,
+			sizeof(struct xchk_pptr), &pp->pptr_entries);
+	if (error)
+		goto out_pp;
+
+	error = xfblob_create(sc->mp, "pptr names", &pp->pptr_names);
+	if (error)
+		goto out_entries;
+
 	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, pp);
 	if (error == -ECANCELED) {
 		error = 0;
-		goto out_pp;
+		goto out_names;
 	}
 	if (error)
-		goto out_pp;
+		goto out_names;
 
+	error = xchk_parent_finish_slow_pptrs(pp);
+	if (error)
+		goto out_names;
+
+out_names:
+	xfblob_destroy(pp->pptr_names);
+out_entries:
+	xfarray_destroy(pp->pptr_entries);
 out_pp:
 	kvfree(pp);
 	return error;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index ac21759fc3e1..61f18632cb6f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -929,6 +929,39 @@ TRACE_EVENT(xchk_parent_bad_dapos,
 		  __get_str(name))
 );
 
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
+DEFINE_XCHK_PPTR_CLASS(xchk_parent_defer);
+DEFINE_XCHK_PPTR_CLASS(xchk_parent_slowpath);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 

