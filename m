Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129B8C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjDFT1o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDFT1o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:27:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD035FC8
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFB8460F1D
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D10C433D2;
        Thu,  6 Apr 2023 19:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809261;
        bh=mxj+0/Icd59yQId22c/w6Q6e+LVkoNoS3x01oAy88QA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Mfi8KTar0gs6Zs5CoUuTYDybjSnkNtaBcwr0tdVvNqkPEDiFhjkD1dvDqdMRB24kh
         Ng8Q18vl3VttfbWt2P6pz6yQXJZck6Wn3u+b5sexsLDLXSBUodJ1TvOYMJ8fWjHbF7
         m4lmZz6t90wWHWu8a5bBpdC9JNMYkmds7yXcp2qVDxoNfOJ0EHIf/i4Rr0UTjMQ3hk
         BqYfpJ/yKdy9btfhRZBqS7lr/Fiz/HesondVDUlU5tngMBodJCt66m9Q4eIR94SzEJ
         sp3TEwPenrOxjXwjMJcanrFnlwvS78KSbRoP2hAxXs915EHDvi8MRYjNosV5vEjdVj
         xg5+DP92A3lRQ==
Date:   Thu, 06 Apr 2023 12:27:40 -0700
Subject: [PATCH 2/2] xfs: deferred scrub of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080825651.615905.17698309739602785684.stgit@frogsfrogsfrogs>
In-Reply-To: <168080825622.615905.7017300233071761636.stgit@frogsfrogsfrogs>
References: <168080825622.615905.7017300233071761636.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_parent.c |   42 ++++++++
 fs/xfs/libxfs/xfs_parent.h |   10 ++
 fs/xfs/scrub/parent.c      |  229 +++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h       |   33 ++++++
 5 files changed, 311 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0a83cd9585d1..bd9b65dcc802 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -169,6 +169,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   scrub.o \
 				   symlink.o \
 				   xfarray.o \
+				   xfblob.o \
 				   xfile.o \
 				   )
 
@@ -182,7 +183,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   dir_repair.o \
 				   repair.o \
 				   tempfile.o \
-				   xfblob.o \
 				   )
 endif
 endif
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 37a3e73049d9..1f3d50fb424d 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -315,3 +315,45 @@ xfs_parent_irec_hashname(
 
 	irec->p_namehash = xfs_dir2_hashname(mp, &dname);
 }
+
+static inline void
+xfs_parent_scratch_init(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	memset(&scr->args, 0, sizeof(struct xfs_da_args));
+	scr->args.attr_filter	= XFS_ATTR_PARENT;
+	scr->args.dp		= ip;
+	scr->args.geo		= ip->i_mount->m_attr_geo;
+	scr->args.name		= (const unsigned char *)&scr->rec;
+	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.op_flags	= XFS_DA_OP_NVLOOKUP;
+	scr->args.trans		= tp;
+	scr->args.value		= (void *)pptr->p_name;
+	scr->args.valuelen	= pptr->p_namelen;
+	scr->args.whichfork	= XFS_ATTR_FORK;
+	scr->args.hashval	= xfs_da_hashname((const void *)&scr->rec,
+					sizeof(struct xfs_parent_name_rec));
+}
+
+/*
+ * Look up the @name associated with the parent pointer (@pptr) of @ip.
+ * Caller must hold at least ILOCK_SHARED.  Returns 0 if the pointer is found,
+ * -ENOATTR if there is no match, or a negative errno.  The scratchpad need not
+ *  be initialized.
+ */
+int
+xfs_parent_lookup(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(tp, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_OKNOENT;
+
+	return xfs_attr_get_ilocked(&scr->args);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 1cc4778968df..a7eea91960cd 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -101,4 +101,14 @@ void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec,
 void xfs_parent_irec_hashname(struct xfs_mount *mp,
 		struct xfs_parent_name_irec *irec);
 
+/* Scratchpad memory so that raw parent operations don't burn stack space. */
+struct xfs_parent_scratch {
+	struct xfs_parent_name_rec	rec;
+	struct xfs_da_args		args;
+};
+
+int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 02938a1fcd47..efdd4cac89e6 100644
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
@@ -302,14 +305,39 @@ xchk_parent(
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
 };
 
 /* Look up the dotdot entry so that we can check it as we walk the pptrs. */
@@ -517,8 +545,25 @@ xchk_parent_scan_attr(
 	/* Try to lock the inode. */
 	lockmode = xchk_parent_lock_dir(sc, dp);
 	if (!lockmode) {
-		xchk_set_incomplete(sc);
-		error = -ECANCELED;
+		struct xchk_pptr	save_pp = {
+			.p_ino		= pp->pptr.p_ino,
+			.p_gen		= pp->pptr.p_gen,
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
 
@@ -533,6 +578,161 @@ xchk_parent_scan_attr(
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
+	int			error;
+
+	error = xfs_parent_lookup(sc->tp, sc->ip, &pp->pptr,
+			&pp->pptr_scratch);
+	if (error == -ENOATTR) {
+		/* Parent pointer went away, nothing to revalidate. */
+		return -ENOENT;
+	}
+
+	return error;
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
+
+	error = xfblob_load(pp->pptr_names, pptr->name_cookie, pp->pptr.p_name,
+			pptr->namelen);
+	if (error)
+		return error;
+	pp->pptr.p_name[MAXNAMELEN - 1] = 0;
+	pp->pptr.p_namelen = pptr->namelen;
+	xfs_parent_irec_hashname(sc->mp, &pp->pptr);
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
+	trace_xchk_parent_slowpath(sc->ip, pp->pptr.p_name, pptr->namelen,
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
@@ -550,14 +750,35 @@ xchk_parent_pptr(
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
index d97a6bab9a4a..7eb6dcb3aa49 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -954,6 +954,39 @@ TRACE_EVENT(xchk_nlinks_live_update,
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
 

