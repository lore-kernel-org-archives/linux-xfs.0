Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05D3C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjBPUua (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjBPUu3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:50:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83294BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:50:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38900B826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA5CC433D2;
        Thu, 16 Feb 2023 20:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580624;
        bh=qURxpKBe7mtWVS/XrAf1EIj6BEU+CnxYItbR/BgMp7Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=X9zbwMxz5GrFbKKTFESg8EnPuKK2X8J9vM/qEYShV0rNxy3wsVyOPeccbwKpV+FXw
         X/Zugfvn68XXpAPVkvqGegdizyZxwccfb29Iu6CKfOIVyvoIb0AbpmFQFgU0pAWtzl
         7T1b9S5c1enTwn4eRUFBTA24GN/51HwBw3DAaytoFcNaMpY4hJgXFBWgrPkpbh5M0U
         3GuOXeQlcwKyOdojraXR+YAfIHELYCsG3zm4yd/hKqV6U/NtaGrkR/Uv5EFkfjfWiP
         CsZARCQcDaz0FAPWDca/Rf6AxANm59r84mMS0pSjYE2/L2IL3vPMvUHbqq8bSotiKC
         KwQxPopK4w/qg==
Date:   Thu, 16 Feb 2023 12:50:23 -0800
Subject: [PATCH 1/3] xfs: repair parent pointers by scanning directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875211.3475204.10253924370008014376.stgit@magnolia>
In-Reply-To: <167657875195.3475204.16384027586557102765.stgit@magnolia>
References: <167657875195.3475204.16384027586557102765.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Walk the filesystem to rebuild parent pointer information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/libxfs/xfs_parent.c   |   31 ++
 fs/xfs/libxfs/xfs_parent.h   |    4 
 fs/xfs/scrub/parent.c        |   10 +
 fs/xfs/scrub/parent_repair.c |  583 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |    4 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.c         |    2 
 fs/xfs/scrub/trace.h         |   77 ++++++
 fs/xfs/xfs_inode.h           |    6 
 10 files changed, 717 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/parent_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0a908382d033..f0d5a517ca00 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -180,6 +180,7 @@ ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
 				   dir_repair.o \
+				   parent_repair.o \
 				   repair.o \
 				   tempfile.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 36e1968337d5..5f07bd3debee 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -94,11 +94,11 @@ xfs_parent_valuecheck(
 static inline void
 xfs_init_parent_name_rec(
 	struct xfs_parent_name_rec	*rec,
-	struct xfs_inode		*ip,
+	const struct xfs_inode		*ip,
 	uint32_t			p_diroffset)
 {
 	xfs_ino_t			p_ino = ip->i_ino;
-	uint32_t			p_gen = VFS_I(ip)->i_generation;
+	uint32_t			p_gen = VFS_IC(ip)->i_generation;
 
 	rec->p_ino = cpu_to_be64(p_ino);
 	rec->p_gen = cpu_to_be32(p_gen);
@@ -336,3 +336,30 @@ xfs_parent_lookup(
 
 	return scr->args.valuelen;
 }
+
+/*
+ * Attach the parent pointer (@pptr -> @name) to @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  The update will not use logged
+ * xattrs.  This is for specialized repair functions only.  The scratchpad need
+ * not be initialized.
+ */
+int
+xfs_parent_set(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+
+	memset(&scr->args, 0, sizeof(struct xfs_da_args));
+	scr->args.attr_filter	= XFS_ATTR_PARENT;
+	scr->args.dp		= ip;
+	scr->args.geo		= ip->i_mount->m_attr_geo;
+	scr->args.name		= (const unsigned char *)&scr->rec;
+	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.valuelen	= pptr->p_namelen;
+	scr->args.value		= (void *)pptr->p_name;
+	scr->args.whichfork	= XFS_ATTR_FORK;
+
+	return xfs_attr_set(&scr->args);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index cd1b135195a2..effbccdf6b0e 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -113,4 +113,8 @@ int xfs_parent_lookup(struct xfs_trans *tp, struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr, unsigned char *name,
 		unsigned int namelen, struct xfs_parent_scratch *scratch);
 
+int xfs_parent_set(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 056e11337cec..14f16fefd1b0 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -10,6 +10,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
+#include "xfs_trans.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "xfs_dir2.h"
@@ -24,12 +25,21 @@
 #include "scrub/xfarray.h"
 #include "scrub/xfblob.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
 
 /* Set us up to scrub parents. */
 int
 xchk_setup_parent(
 	struct xfs_scrub	*sc)
 {
+	int			error;
+
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_parent(sc);
+		if (error)
+			return error;
+	}
+
 	return xchk_setup_inode_contents(sc, 0);
 }
 
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
new file mode 100644
index 000000000000..d80d1a466c02
--- /dev/null
+++ b/fs/xfs/scrub/parent_repair.c
@@ -0,0 +1,583 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_bmap_util.h"
+#include "xfs_attr.h"
+#include "xfs_parent.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/iscan.h"
+#include "scrub/readdir.h"
+#include "scrub/listxattr.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
+
+/*
+ * Parent Pointer Repairs
+ * ======================
+ *
+ * Reconstruct a file's parent pointers by visiting each dirent of each
+ * directory in the filesystem and translating the relevant dirents into parent
+ * pointers.  Translation occurs by adding new parent pointers to a temporary
+ * file, which formats the ondisk extended attribute blocks.  In the final
+ * version of this code, we'll use the atomic extent swap code to exchange the
+ * entire xattr structure of the file being repaired and the temporary file,
+ * but for this PoC we omit the commit to reduce the amount of code that has to
+ * be ported.
+ *
+ * Because we have to scan the entire filesystem, the next patch introduces the
+ * inode scan and live update hooks so that the rebuilder can be kept aware of
+ * filesystem updates being made to this file's parents by other threads.
+ * Parent pointer translation therefore requires two steps to avoid problems
+ * with lock contention and to keep ondisk tempdir updates out of the hook
+ * path.
+ *
+ * Every time the filesystem scanner or the live update hook code encounter a
+ * directory operation relevant to this rebuilder, they will write a record of
+ * the createpptr/removepptr operation to an xfarray.  Parent pointer names are
+ * stored in an xfblob structure.  At opportune times, these stashed updates
+ * will be read from the xfarray and committed (individually) to the temporary
+ * file's parent pointers.
+ *
+ * When the filesystem scan is complete, we relock both the file and the
+ * tempfile, and finish any stashed operations.  At that point, had we copied
+ * the extended attributes, we would be ready to exchange the attribute data
+ * fork mappings.  This cannot happen until two patchsets get merged: the first
+ * allows callers to specify the owning inode number explicitly; and the second
+ * is the atomic extent swap series.
+ *
+ * For now we'll simply compare the two files parent pointers and complain
+ * about discrepancies.
+ */
+
+/* Maximum memory usage for the tempfile log, in bytes. */
+#define MAX_PPTR_STASH_SIZE	(32ULL << 10)
+
+/* Create a parent pointer in the tempfile. */
+#define XREP_PPTR_ADD		(1)
+
+/* Remove a parent pointer from the tempfile. */
+#define XREP_PPTR_REMOVE	(2)
+
+/* A stashed parent pointer update. */
+struct xrep_pptr {
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
+
+	/* XREP_PPTR_{ADD,REMOVE} */
+	uint8_t				action;
+};
+
+struct xrep_pptrs {
+	struct xfs_scrub	*sc;
+
+	/* Inode scan cursor. */
+	struct xchk_iscan	iscan;
+
+	/* Scratch buffer for scanning dirents to create pptr xattrs */
+	struct xfs_parent_name_irec pptr;
+
+	/* xattr key and da args for parent pointer replay. */
+	struct xfs_parent_scratch pptr_scratch;
+
+	/* Mutex protecting parent_ptrs, pptr_names. */
+	struct mutex		lock;
+
+	/* Stashed parent pointer updates. */
+	struct xfarray		*parent_ptrs;
+
+	/* Parent pointer names. */
+	struct xfblob		*pptr_names;
+};
+
+/* Tear down all the incore stuff we created. */
+static void
+xrep_pptr_teardown(
+	struct xrep_pptrs	*rp)
+{
+	xchk_iscan_finish(&rp->iscan);
+	mutex_destroy(&rp->lock);
+	xfblob_destroy(rp->pptr_names);
+	xfarray_destroy(rp->parent_ptrs);
+}
+
+/* Set up for a parent pointer repair. */
+int
+xrep_setup_parent(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_pptrs	*rp;
+	int			error;
+
+	error = xrep_tempfile_create(sc, S_IFREG);
+	if (error)
+		return error;
+
+	rp = kvzalloc(sizeof(struct xrep_pptrs), XCHK_GFP_FLAGS);
+	if (!rp)
+		return -ENOMEM;
+
+	sc->buf = rp;
+	rp->sc = sc;
+	return 0;
+}
+
+/* Are these two parent pointer names the same? */
+static inline bool
+xrep_pptr_samename(
+	const struct xfs_name	*n1,
+	const struct xfs_name	*n2)
+{
+	return n1->len == n2->len && !memcmp(n1->name, n2->name, n1->len);
+}
+
+/* Update the temporary file's parent pointers with a stashed update. */
+STATIC int
+xrep_pptr_replay_update(
+	struct xrep_pptrs	*rp,
+	const struct xrep_pptr	*pptr)
+{
+	struct xfs_scrub	*sc = rp->sc;
+
+	rp->pptr.p_ino = pptr->p_ino;
+	rp->pptr.p_gen = pptr->p_gen;
+	rp->pptr.p_diroffset = pptr->p_diroffset;
+	rp->pptr.p_namelen = pptr->namelen;
+
+	if (pptr->action == XREP_PPTR_ADD) {
+		/* Create parent pointer. */
+		trace_xrep_pptr_createname(sc->tempip, &rp->pptr);
+
+		return xfs_parent_set(sc->tempip, &rp->pptr, &rp->pptr_scratch);
+	}
+
+	ASSERT(0);
+	return -EOPNOTSUPP;
+}
+
+/*
+ * Flush stashed parent pointer updates that have been recorded by the scanner.
+ * This is done to reduce the memory requirements of the parent pointer
+ * rebuild, since files can have a lot of hardlinks and the fs can be busy.
+ *
+ * Caller must not hold transactions or ILOCKs.  Caller must hold the tempfile
+ * IOLOCK.
+ */
+STATIC int
+xrep_pptr_replay_updates(
+	struct xrep_pptrs	*rp)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	mutex_lock(&rp->lock);
+	foreach_xfarray_idx(rp->parent_ptrs, array_cur) {
+		struct xrep_pptr	pptr;
+
+		error = xfarray_load(rp->parent_ptrs, array_cur, &pptr);
+		if (error)
+			goto out_unlock;
+
+		error = xfblob_load(rp->pptr_names, pptr.name_cookie,
+				rp->pptr.p_name, pptr.namelen);
+		if (error)
+			goto out_unlock;
+		rp->pptr.p_name[MAXNAMELEN - 1] = 0;
+		mutex_unlock(&rp->lock);
+
+		error = xrep_pptr_replay_update(rp, &pptr);
+		if (error)
+			return error;
+
+		mutex_lock(&rp->lock);
+	}
+
+	/* Empty out both arrays now that we've added the entries. */
+	xfarray_truncate(rp->parent_ptrs);
+	xfblob_truncate(rp->pptr_names);
+	mutex_unlock(&rp->lock);
+	return 0;
+out_unlock:
+	mutex_unlock(&rp->lock);
+	return error;
+}
+
+/*
+ * Remember that we want to create a parent pointer in the tempfile.  These
+ * stashed actions will be replayed later.
+ */
+STATIC int
+xrep_pptr_add_pointer(
+	struct xrep_pptrs	*rp,
+	const struct xfs_name	*name,
+	const struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xrep_pptr	pptr = {
+		.action		= XREP_PPTR_ADD,
+		.namelen	= name->len,
+		.p_ino		= dp->i_ino,
+		.p_gen		= VFS_IC(dp)->i_generation,
+		.p_diroffset	= diroffset,
+	};
+	int			error;
+
+	trace_xrep_pptr_add_pointer(rp->sc->tempip, dp, diroffset, name);
+
+	error = xfblob_store(rp->pptr_names, &pptr.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rp->parent_ptrs, &pptr);
+}
+
+/*
+ * Examine an entry of a directory.  If this dirent leads us back to the file
+ * whose parent pointers we're rebuilding, add a pptr to the temporary
+ * directory.
+ */
+STATIC int
+xrep_pptr_scan_dirent(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	void			*priv)
+{
+	struct xrep_pptrs	*rp = priv;
+	int			error;
+
+	/* Dirent doesn't point to this directory. */
+	if (ino != rp->sc->ip->i_ino)
+		return 0;
+
+	/* No weird looking names. */
+	if (!xfs_dir2_namecheck(name->name, name->len))
+		return -EFSCORRUPTED;
+
+	/* No mismatching ftypes. */
+	if (name->type != xfs_mode_to_ftype(VFS_I(sc->ip)->i_mode))
+		return -EFSCORRUPTED;
+
+	/* Don't pick up dot or dotdot entries; we only want child dirents. */
+	if (xrep_pptr_samename(name, &xfs_name_dotdot) ||
+	    xrep_pptr_samename(name, &xfs_name_dot))
+		return 0;
+
+	/*
+	 * Transform this dirent into a parent pointer and queue it for later
+	 * addition to the temporary file.
+	 */
+	mutex_lock(&rp->lock);
+	error = xrep_pptr_add_pointer(rp, name, dp, dapos);
+	mutex_unlock(&rp->lock);
+	return error;
+}
+
+/*
+ * Decide if we want to look for dirents in this directory.  Skip the file
+ * being repaired and any files being used to stage repairs.
+ */
+static inline bool
+xrep_pptr_want_scan(
+	struct xrep_pptrs	*rp,
+	const struct xfs_inode	*ip)
+{
+	return ip != rp->sc->ip && !xrep_is_tempfile(ip);
+}
+
+/*
+ * Take ILOCK on a file that we want to scan.
+ *
+ * Select ILOCK_EXCL if the file is a directory with an unloaded data bmbt.
+ * Otherwise, take ILOCK_SHARED.
+ */
+static inline unsigned int
+xrep_pptr_scan_ilock(
+	struct xrep_pptrs	*rp,
+	struct xfs_inode	*ip)
+{
+	uint			lock_mode = XFS_ILOCK_SHARED;
+
+	/* Still need to take the shared ILOCK to advance the iscan cursor. */
+	if (!xrep_pptr_want_scan(rp, ip))
+		goto lock;
+
+	if (S_ISDIR(VFS_I(ip)->i_mode) && xfs_need_iread_extents(&ip->i_df)) {
+		lock_mode = XFS_ILOCK_EXCL;
+		goto lock;
+	}
+
+lock:
+	xfs_ilock(ip, lock_mode);
+	return lock_mode;
+}
+
+/*
+ * Scan this file for relevant child dirents that point to the file whose
+ * parent pointers we're rebuilding.
+ */
+STATIC int
+xrep_pptr_scan_file(
+	struct xrep_pptrs	*rp,
+	struct xfs_inode	*ip)
+{
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	lock_mode = xrep_pptr_scan_ilock(rp, ip);
+
+	if (!xrep_pptr_want_scan(rp, ip))
+		goto scan_done;
+
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		error = xchk_dir_walk(rp->sc, ip, xrep_pptr_scan_dirent, rp);
+		if (error)
+			goto scan_done;
+	}
+
+scan_done:
+	xchk_iscan_mark_visited(&rp->iscan, ip);
+	xfs_iunlock(ip, lock_mode);
+	return error;
+}
+
+/* Scan all files in the filesystem for parent pointers. */
+STATIC int
+xrep_pptr_scan_dirtree(
+	struct xrep_pptrs	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	struct xfs_inode	*ip;
+	int			error;
+
+	/*
+	 * Filesystem scans are time consuming.  Drop the file ILOCK and all
+	 * other resources for the duration of the scan and hope for the best.
+	 */
+	xchk_trans_cancel(sc);
+	if (sc->ilock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL))
+		xchk_iunlock(sc, sc->ilock_flags & (XFS_ILOCK_SHARED |
+						    XFS_ILOCK_EXCL));
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	while ((error = xchk_iscan_iter(sc, &rp->iscan, &ip)) == 1) {
+		uint64_t	mem_usage;
+
+		error = xrep_pptr_scan_file(rp, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		/* Flush stashed pptr updates to constrain memory usage. */
+		mutex_lock(&rp->lock);
+		mem_usage = xfarray_bytes(rp->parent_ptrs) +
+			     xfblob_bytes(rp->pptr_names);
+		mutex_unlock(&rp->lock);
+		if (mem_usage >= MAX_PPTR_STASH_SIZE) {
+			xchk_trans_cancel(sc);
+
+			error = xrep_tempfile_iolock_polled(sc);
+			if (error)
+				break;
+
+			error = xrep_pptr_replay_updates(rp);
+			xrep_tempfile_iounlock(sc);
+			if (error)
+				break;
+
+			error = xchk_trans_alloc_empty(sc);
+			if (error)
+				break;
+		}
+
+		if (xchk_should_terminate(sc, &error))
+			break;
+	}
+	if (error) {
+		/*
+		 * If we couldn't grab an inode that was busy with a state
+		 * change, change the error code so that we exit to userspace
+		 * as quickly as possible.
+		 */
+		if (error == -EBUSY)
+			return -ECANCELED;
+		return error;
+	}
+
+	return 0;
+}
+
+/* Dump a parent pointer from the temporary file. */
+STATIC int
+xrep_pptr_dump_tempptr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xrep_pptrs	*rp = priv;
+	const struct xfs_parent_name_rec *rec = (const void *)name;
+
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	xfs_parent_irec_from_disk(&rp->pptr, rec, value, valuelen);
+
+	trace_xrep_pptr_dumpname(sc->tempip, &rp->pptr);
+	return 0;
+}
+
+/*
+ * "Commit" the new parent pointer (aka extended attribute) structure to the
+ * file that we're repairing.
+ *
+ * In the final version, we'd copy the existing xattrs from the file being
+ * repaired to the temporary file and swap the new xattr contents (which we
+ * created in the tempfile) into the file being repaired.  For now we just lock
+ * the temporary file and dump what we found.
+ */
+STATIC int
+xrep_pptr_rebuild_tree(
+	struct xrep_pptrs	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	int			error = 0;
+
+	/*
+	 * Replay the last of the stashed dirent updates after retaking
+	 * IOLOCK_EXCL of the directory that we're repairing and the temporary
+	 * directory.
+	 */
+	xchk_trans_cancel(sc);
+
+	ASSERT(sc->ilock_flags & XFS_IOLOCK_EXCL);
+	error = xrep_tempfile_iolock_polled(sc);
+	if (error)
+		return error;
+
+	error = xrep_pptr_replay_updates(rp);
+	if (error)
+		return error;
+
+	/*
+	 * At this point, we've quiesced both files and should be ready
+	 * to commit the new contents.
+	 *
+	 * We don't have atomic swapext here, so all we do is dump the pptrs
+	 * that we found to the ftrace buffer.  Inactivation of the tempfile
+	 * will erase the attr fork for us.
+	 */
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	trace_xrep_pptr_rebuild_tree(sc->ip, 0);
+
+	xrep_tempfile_ilock(sc);
+	return xchk_xattr_walk(sc, sc->tempip, xrep_pptr_dump_tempptr, rp);
+}
+
+/* Set up the filesystem scan so we can look for pptrs. */
+STATIC int
+xrep_pptr_setup_scan(
+	struct xrep_pptrs	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	int			error;
+
+	/* Set up some staging memory for logging parent pointers. */
+	error = xfarray_create(sc->mp, "parent pointers", 0,
+			sizeof(struct xrep_pptr), &rp->parent_ptrs);
+	if (error)
+		return error;
+
+	error = xfblob_create(sc->mp, "pptr names", &rp->pptr_names);
+	if (error)
+		goto out_entries;
+
+	mutex_init(&rp->lock);
+
+	/* Retry iget every tenth of a second for up to 30 seconds. */
+	xchk_iscan_start(&rp->iscan, 30000, 100);
+
+	return 0;
+
+out_entries:
+	xfarray_destroy(rp->parent_ptrs);
+	return error;
+}
+
+/* Repair the parent pointers. */
+int
+xrep_parent(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_pptrs	*rp = sc->buf;
+	int			error = 0;
+
+	/* We require directory parent pointers to rebuild anything. */
+	if (!xfs_has_parent(sc->mp))
+		return -EOPNOTSUPP;
+
+	error = xrep_pptr_setup_scan(rp);
+	if (error)
+		goto out;
+
+	error = xrep_pptr_scan_dirtree(rp);
+	if (error)
+		goto out_finish_scan;
+
+	error = xrep_pptr_rebuild_tree(rp);
+	if (error)
+		goto out_finish_scan;
+
+out_finish_scan:
+	xrep_pptr_teardown(rp);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index ff254ff9b86d..cc42cf65ac92 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -68,6 +68,7 @@ void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
 
 int xrep_setup_directory(struct xfs_scrub *sc);
+int xrep_setup_parent(struct xfs_scrub *sc);
 
 /* Metadata repairers */
 
@@ -77,6 +78,7 @@ int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
 int xrep_directory(struct xfs_scrub *sc);
+int xrep_parent(struct xfs_scrub *sc);
 
 #else
 
@@ -97,6 +99,7 @@ xrep_calc_ag_resblks(
 }
 
 #define xrep_setup_directory(sc)	(0)
+#define xrep_setup_parent(sc)		(0)
 
 #define xrep_probe			xrep_notsupported
 #define xrep_superblock			xrep_notsupported
@@ -104,6 +107,7 @@ xrep_calc_ag_resblks(
 #define xrep_agfl			xrep_notsupported
 #define xrep_agi			xrep_notsupported
 #define xrep_directory			xrep_notsupported
+#define xrep_parent			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b2a8de449d11..5ddb4dcff978 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -317,7 +317,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_parent,
 		.scrub	= xchk_parent,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_parent,
 	},
 	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
 		.type	= ST_FS,
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 61b51617fbb4..30946b6a16dd 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -18,6 +18,8 @@
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
 #include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_parent.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 61f18632cb6f..1fb9832a113a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -19,6 +19,7 @@
 struct xfile;
 struct xfarray;
 struct xchk_iscan;
+struct xfs_parent_name_irec;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -1316,6 +1317,82 @@ DEFINE_EVENT(xrep_dir_class, name, \
 	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino), \
 	TP_ARGS(dp, parent_ino))
 DEFINE_XREP_DIR_CLASS(xrep_dir_rebuild_tree);
+DEFINE_XREP_DIR_CLASS(xrep_pptr_rebuild_tree);
+
+DECLARE_EVENT_CLASS(xrep_pptr_class,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_parent_name_irec *pptr),
+	TP_ARGS(ip, pptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, parent_diroffset)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, pptr->p_namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->parent_ino = pptr->p_ino;
+		__entry->parent_gen = pptr->p_gen;
+		__entry->parent_diroffset = pptr->p_diroffset;
+		__entry->namelen = pptr->p_namelen;
+		memcpy(__get_str(name), pptr->p_name, pptr->p_namelen);
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x parent_dapos 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->parent_diroffset,
+		  __entry->namelen,
+		  __get_str(name))
+)
+#define DEFINE_XREP_PPTR_CLASS(name) \
+DEFINE_EVENT(xrep_pptr_class, name, \
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_parent_name_irec *pptr), \
+	TP_ARGS(ip, pptr))
+DEFINE_XREP_PPTR_CLASS(xrep_pptr_createname);
+DEFINE_XREP_PPTR_CLASS(xrep_pptr_dumpname);
+
+DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp,
+		 unsigned int diroffset, const struct xfs_name *name),
+	TP_ARGS(ip, dp, diroffset, name),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, parent_diroffset)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->parent_ino = dp->i_ino;
+		__entry->parent_gen = VFS_IC(dp)->i_generation;
+		__entry->parent_diroffset = diroffset;
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x parent_dapos 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->parent_diroffset,
+		  __entry->namelen,
+		  __get_str(name))
+)
+#define DEFINE_XREP_PPTR_SCAN_CLASS(name) \
+DEFINE_EVENT(xrep_pptr_scan_class, name, \
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp, \
+		 unsigned int diroffset, const struct xfs_name *name), \
+	TP_ARGS(ip, dp, diroffset, name))
+DEFINE_XREP_PPTR_SCAN_CLASS(xrep_pptr_add_pointer);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 403b0f4cb5c0..32efd4cb6507 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -153,6 +153,12 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 	return &ip->i_vnode;
 }
 
+/* convert from const xfs inode to vfs inode */
+static inline const struct inode *VFS_IC(const struct xfs_inode *ip)
+{
+	return &ip->i_vnode;
+}
+
 /*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode

