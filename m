Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F20EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiL3XgN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiL3XgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:36:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF115F88
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:36:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCEEC61C2C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FF7C433D2;
        Fri, 30 Dec 2022 23:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443369;
        bh=lriIZG42MKlVRMsdkHbtmax7I6FkiTIMcB+gE1IXHqg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jo1r4DhBJ+lhPII3+NA2dppsDGWo8KjhZ4aqf026k9LlpkSAFDbbPekOnNQBxHYDG
         0Ed4XUj+Lo1qTZP1urAAk8poxnJN3EqKI2XLyKsJkBh9wgfuyny/DASM+MrZZLPnuc
         tFoGbjTEGhnLYH/mdNVFABrgS3PusFl8GkzQ6zRmo9N5OUeWpMt0EBQkAL4CJWNYgU
         B7B2d1l8IchX71ftJJQDzgh817jEs4jUxxl4BpOeuGVsACHJc5hYbRgS3+k3YU282P
         ZooP67QTSKzM82Wi8axAfi3GX6SQulqtmQ1cyxaj1TTFeGePuT3cW6hI7wodNki7Af
         1NvRdMyrZpG8g==
Subject: [PATCH 3/5] xfs: teach scrub to check file nlinks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:11 -0800
Message-ID: <167243839111.695835.11672205276225685633.stgit@magnolia>
In-Reply-To: <167243839062.695835.16105316950703126803.stgit@magnolia>
References: <167243839062.695835.16105316950703126803.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create the necessary scrub code to walk the filesystem's directory tree
so that we can compute file link counts.  Similar to quotacheck, we
create an incore shadow array of link count information and then we walk
the filesystem a second time to compare the link counts.  We need live
updates to keep the information up to date during the lengthy scan, so
this scrubber remains disabled until the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile               |    3 
 fs/xfs/libxfs/xfs_da_format.h |   11 +
 fs/xfs/libxfs/xfs_dir2.c      |    6 
 fs/xfs/libxfs/xfs_dir2.h      |    1 
 fs/xfs/libxfs/xfs_fs.h        |    3 
 fs/xfs/scrub/common.h         |    1 
 fs/xfs/scrub/health.c         |    1 
 fs/xfs/scrub/nlinks.c         |  811 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.h         |   90 +++++
 fs/xfs/scrub/scrub.c          |    6 
 fs/xfs/scrub/scrub.h          |    1 
 fs/xfs/scrub/trace.c          |    2 
 fs/xfs/scrub/trace.h          |  147 +++++++
 13 files changed, 1080 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/nlinks.c
 create mode 100644 fs/xfs/scrub/nlinks.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index a762ee3cc454..ea9eda20a11d 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -158,6 +158,8 @@ xfs-y				+= $(addprefix scrub/, \
 				   health.o \
 				   ialloc.o \
 				   inode.o \
+				   iscan.o \
+				   nlinks.o \
 				   parent.o \
 				   readdir.o \
 				   refcount.o \
@@ -174,7 +176,6 @@ xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   )
 
 xfs-$(CONFIG_XFS_QUOTA)		+= $(addprefix scrub/, \
-				   iscan.o \
 				   quota.o \
 				   quotacheck.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 25e2841084e1..9d332415e0b6 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -159,6 +159,17 @@ struct xfs_da3_intnode {
 
 #define XFS_DIR3_FT_MAX			9
 
+#define XFS_DIR3_FTYPE_STR \
+	{ XFS_DIR3_FT_UNKNOWN,	"unknown" }, \
+	{ XFS_DIR3_FT_REG_FILE,	"file" }, \
+	{ XFS_DIR3_FT_DIR,	"directory" }, \
+	{ XFS_DIR3_FT_CHRDEV,	"char" }, \
+	{ XFS_DIR3_FT_BLKDEV,	"block" }, \
+	{ XFS_DIR3_FT_FIFO,	"fifo" }, \
+	{ XFS_DIR3_FT_SOCK,	"sock" }, \
+	{ XFS_DIR3_FT_SYMLINK,	"symlink" }, \
+	{ XFS_DIR3_FT_WHT,	"whiteout" }
+
 /*
  * Byte offset in data block and shortform entry.
  */
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92bac3373f1f..ee30044af39d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -25,6 +25,12 @@ const struct xfs_name xfs_name_dotdot = {
 	.type	= XFS_DIR3_FT_DIR,
 };
 
+const struct xfs_name xfs_name_dot = {
+	.name	= (unsigned char *)".",
+	.len	= 1,
+	.type	= XFS_DIR3_FT_DIR,
+};
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index dd39f17dd9a9..15a36cf7ae87 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -22,6 +22,7 @@ struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
 extern const struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dot;
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2f9f13ba75b8..3885c56078f5 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -710,9 +710,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_PQUOTA	23	/* project quotas */
 #define XFS_SCRUB_TYPE_FSCOUNTERS 24	/* fs summary counters */
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
+#define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	26
+#define XFS_SCRUB_TYPE_NR	27
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 2c33814e0b69..45318bd5678d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -129,6 +129,7 @@ xchk_setup_quotacheck(struct xfs_scrub *sc)
 }
 #endif
 int xchk_setup_fscounters(struct xfs_scrub *sc);
+int xchk_setup_nlinks(struct xfs_scrub *sc);
 
 void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
 int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/health.c b/fs/xfs/scrub/health.c
index 5e28fa1ab6aa..6749930b50a2 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -108,6 +108,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_PQUOTA]		= { XHG_FS,  XFS_SICK_FS_PQUOTA },
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
+	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
new file mode 100644
index 000000000000..f97c46bdd06c
--- /dev/null
+++ b/fs/xfs/scrub/nlinks.c
@@ -0,0 +1,811 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_iwalk.h"
+#include "xfs_ialloc.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_ag.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/repair.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/iscan.h"
+#include "scrub/nlinks.h"
+#include "scrub/trace.h"
+#include "scrub/readdir.h"
+
+/*
+ * Live Inode Link Count Checking
+ * ==============================
+ *
+ * Inode link counts are "summary" metadata, in the sense that they are
+ * computed as the number of directory entries referencing each file on the
+ * filesystem.  Therefore, we compute the correct link counts by creating a
+ * shadow link count structure and walking every inode.
+ */
+
+/* Set us up to scrub inode link counts. */
+int
+xchk_setup_nlinks(
+	struct xfs_scrub	*sc)
+{
+	/* Not ready for general consumption yet. */
+	return -EOPNOTSUPP;
+
+	sc->buf = kzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	return xchk_setup_fs(sc);
+}
+
+/*
+ * Part 1: Collecting file link counts.  For each file, we create a shadow link
+ * counting structure, then walk the entire directory tree, incrementing parent
+ * and child link counts for each directory entry seen.
+ *
+ * To avoid false corruption reports in part 2, any failure in this part must
+ * set the INCOMPLETE flag even when a negative errno is returned.  This care
+ * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
+ * ECANCELED) that are absorbed into a scrub state flag update by
+ * xchk_*_process_error.
+ */
+
+/* Update incore link count information.  Caller must hold the nlinks lock. */
+STATIC int
+xchk_nlinks_update_incore(
+	struct xchk_nlink_ctrs	*xnc,
+	xfs_ino_t		ino,
+	int			parents_delta,
+	int			backrefs_delta,
+	int			children_delta)
+{
+	struct xchk_nlink	nl;
+	int			error;
+
+	if (!xnc->nlinks)
+		return 0;
+
+	error = xfarray_load_sparse(xnc->nlinks, ino, &nl);
+	if (error)
+		return error;
+
+	trace_xchk_nlinks_update_incore(xnc->sc->mp, ino, &nl, parents_delta,
+			backrefs_delta, children_delta);
+
+	nl.flags |= XCHK_NLINK_WRITTEN;
+	nl.parents += parents_delta;
+	nl.backrefs += backrefs_delta;
+	nl.children += children_delta;
+
+	error = xfarray_store(xnc->nlinks, ino, &nl);
+	if (error == -EFBIG) {
+		/*
+		 * EFBIG means we tried to store data at too high a byte offset
+		 * in the sparse array.  IOWs, we cannot complete the check and
+		 * must notify userspace that the check was incomplete.
+		 */
+		error = -ECANCELED;
+	}
+	return error;
+}
+
+/* Bump the observed link count for the inode referenced by this entry. */
+STATIC int
+xchk_nlinks_collect_dirent(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	void			*priv)
+{
+	struct xchk_nlink_ctrs	*xnc = priv;
+	bool			dot = false, dotdot = false;
+	int			error;
+
+	/* Does this name make sense? */
+	if (name->len == 0 || !xfs_dir2_namecheck(name->name, name->len)) {
+		error = -ECANCELED;
+		goto out_abort;
+	}
+
+	if (name->len == 1 && name->name[0] == '.')
+		dot = true;
+	else if (name->len == 2 && name->name[0] == '.' &&
+				   name->name[1] == '.')
+		dotdot = true;
+
+	/* Don't accept a '.' entry that points somewhere else. */
+	if (dot && ino != dp->i_ino) {
+		error = -ECANCELED;
+		goto out_abort;
+	}
+
+	/* Don't accept an invalid inode number. */
+	if (!xfs_verify_ino(sc->mp, ino)) {
+		error = -ECANCELED;
+		goto out_abort;
+	}
+
+	/* Update the shadow link counts if we haven't already failed. */
+
+	if (xchk_iscan_aborted(&xnc->collect_iscan)) {
+		error = -ECANCELED;
+		goto out_incomplete;
+	}
+
+	trace_xchk_nlinks_collect_dirent(sc->mp, dp, ino, name);
+
+	mutex_lock(&xnc->lock);
+
+	/*
+	 * If this is a dotdot entry, it is a back link from dp to ino.  How
+	 * we handle this depends on whether or not dp is the root directory.
+	 *
+	 * The root directory is its own parent, so we pretend the dotdot entry
+	 * establishes the "parent" of the root directory.  Increment the
+	 * number of parents of the root directory.
+	 *
+	 * Otherwise, increment the number of backrefs pointing back to ino.
+	 */
+	if (dotdot) {
+		if (dp == sc->mp->m_rootip)
+			error = xchk_nlinks_update_incore(xnc, ino, 1, 0, 0);
+		else
+			error = xchk_nlinks_update_incore(xnc, ino, 0, 1, 0);
+		if (error)
+			goto out_unlock;
+	}
+
+	/*
+	 * If this dirent is a forward link from dp to ino, increment the
+	 * number of parents linking into ino.
+	 */
+	if (!dot && !dotdot) {
+		error = xchk_nlinks_update_incore(xnc, ino, 1, 0, 0);
+		if (error)
+			goto out_unlock;
+	}
+
+	/*
+	 * If this dirent is a forward link to a subdirectory or the dot entry,
+	 * increment the number of child links of dp.
+	 */
+	if (!dotdot && name->type == XFS_DIR3_FT_DIR) {
+		error = xchk_nlinks_update_incore(xnc, dp->i_ino, 0, 0,
+				1);
+		if (error)
+			goto out_unlock;
+	}
+
+	mutex_unlock(&xnc->lock);
+	return 0;
+
+out_unlock:
+	mutex_unlock(&xnc->lock);
+out_abort:
+	xchk_iscan_abort(&xnc->collect_iscan);
+out_incomplete:
+	xchk_set_incomplete(sc);
+	return error;
+}
+
+/* Walk a directory to bump the observed link counts of the children. */
+STATIC int
+xchk_nlinks_collect_dir(
+	struct xchk_nlink_ctrs	*xnc,
+	struct xfs_inode	*dp)
+{
+	struct xfs_scrub	*sc = xnc->sc;
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	/* Prevent anyone from changing this directory while we walk it. */
+	xfs_ilock(dp, XFS_IOLOCK_SHARED);
+	lock_mode = xfs_ilock_data_map_shared(dp);
+
+	/*
+	 * The dotdot entry of an unlinked directory still points to the last
+	 * parent, but the parent no longer links to this directory.  Skip the
+	 * directory to avoid overcounting.
+	 */
+	if (VFS_I(dp)->i_nlink == 0)
+		goto out_unlock;
+
+	/*
+	 * We cannot count file links if the directory looks as though it has
+	 * been zapped by the inode record repair code.
+	 */
+	if (xchk_dir_looks_zapped(dp))
+		goto out_abort;
+
+	error = xchk_dir_walk(sc, dp, xchk_nlinks_collect_dirent, xnc);
+	if (error == -ECANCELED) {
+		error = 0;
+		goto out_unlock;
+	}
+	if (error)
+		goto out_abort;
+
+	xchk_iscan_mark_visited(&xnc->collect_iscan, dp);
+	goto out_unlock;
+
+out_abort:
+	xchk_set_incomplete(sc);
+	xchk_iscan_abort(&xnc->collect_iscan);
+out_unlock:
+	xfs_iunlock(dp, lock_mode);
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+	return error;
+}
+
+/* If this looks like a valid pointer, count it. */
+static inline int
+xchk_nlinks_collect_metafile(
+	struct xchk_nlink_ctrs	*xnc,
+	xfs_ino_t		ino)
+{
+	if (!xfs_verify_ino(xnc->sc->mp, ino))
+		return 0;
+
+	trace_xchk_nlinks_collect_metafile(xnc->sc->mp, ino);
+	return xchk_nlinks_update_incore(xnc, ino, 1, 0, 0);
+}
+
+/* Bump the link counts of metadata files rooted in the superblock. */
+STATIC int
+xchk_nlinks_collect_metafiles(
+	struct xchk_nlink_ctrs	*xnc)
+{
+	struct xfs_mount	*mp = xnc->sc->mp;
+	int			error = -ECANCELED;
+
+
+	if (xchk_iscan_aborted(&xnc->collect_iscan))
+		goto out_incomplete;
+
+	mutex_lock(&xnc->lock);
+	error = xchk_nlinks_collect_metafile(xnc, mp->m_sb.sb_rbmino);
+	if (error)
+		goto out_abort;
+
+	error = xchk_nlinks_collect_metafile(xnc, mp->m_sb.sb_rsumino);
+	if (error)
+		goto out_abort;
+
+	error = xchk_nlinks_collect_metafile(xnc, mp->m_sb.sb_uquotino);
+	if (error)
+		goto out_abort;
+
+	error = xchk_nlinks_collect_metafile(xnc, mp->m_sb.sb_gquotino);
+	if (error)
+		goto out_abort;
+
+	error = xchk_nlinks_collect_metafile(xnc, mp->m_sb.sb_pquotino);
+	if (error)
+		goto out_abort;
+	mutex_unlock(&xnc->lock);
+
+	return 0;
+
+out_abort:
+	mutex_unlock(&xnc->lock);
+	xchk_iscan_abort(&xnc->collect_iscan);
+out_incomplete:
+	xchk_set_incomplete(xnc->sc);
+	return error;
+}
+
+/* Advance the collection scan cursor for this non-directory file. */
+static inline int
+xchk_nlinks_collect_file(
+	struct xchk_nlink_ctrs	*xnc,
+	struct xfs_inode	*ip)
+{
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	xchk_iscan_mark_visited(&xnc->collect_iscan, ip);
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+	return 0;
+}
+
+/* Walk all directories and count inode links. */
+STATIC int
+xchk_nlinks_collect(
+	struct xchk_nlink_ctrs	*xnc)
+{
+	struct xfs_scrub	*sc = xnc->sc;
+	struct xfs_inode	*ip;
+	int			error;
+
+	/* Count the rt and quota files that are rooted in the superblock. */
+	error = xchk_nlinks_collect_metafiles(xnc);
+	if (error)
+		return error;
+
+	/*
+	 * Set up for a potentially lengthy filesystem scan by reducing our
+	 * transaction resource usage for the duration.  Specifically:
+	 *
+	 * Cancel the transaction to release the log grant space while we scan
+	 * the filesystem.
+	 *
+	 * Create a new empty transaction to eliminate the possibility of the
+	 * inode scan deadlocking on cyclical metadata.
+	 *
+	 * We pass the empty transaction to the file scanning function to avoid
+	 * repeatedly cycling empty transactions.  This can be done even though
+	 * we take the IOLOCK to quiesce the file because empty transactions
+	 * do not take sb_internal.
+	 */
+	xchk_trans_cancel(sc);
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	while ((error = xchk_iscan_iter(sc, &xnc->collect_iscan, &ip)) == 1) {
+		if (S_ISDIR(VFS_I(ip)->i_mode))
+			error = xchk_nlinks_collect_dir(xnc, ip);
+		else
+			error = xchk_nlinks_collect_file(xnc, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		if (xchk_should_terminate(sc, &error))
+			break;
+	}
+	if (error) {
+		xchk_set_incomplete(sc);
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
+	/*
+	 * Switch out for a real transaction in preparation for building a new
+	 * tree.
+	 */
+	xchk_trans_cancel(sc);
+	return xchk_setup_fs(sc);
+}
+
+/*
+ * Part 2: Comparing file link counters.  Walk each inode and compare the link
+ * counts against our shadow information; and then walk each shadow link count
+ * structure (that wasn't covered in the first part), comparing it against the
+ * file.
+ */
+
+/* Read the observed link count for comparison with the actual inode. */
+STATIC int
+xchk_nlinks_comparison_read(
+	struct xchk_nlink_ctrs	*xnc,
+	xfs_ino_t		ino,
+	struct xchk_nlink	*obs)
+{
+	struct xchk_nlink	nl;
+	int			error;
+
+	error = xfarray_load_sparse(xnc->nlinks, ino, &nl);
+	if (error)
+		return error;
+
+	nl.flags |= (XCHK_NLINK_COMPARE_SCANNED | XCHK_NLINK_WRITTEN);
+
+	error = xfarray_store(xnc->nlinks, ino, &nl);
+	if (error == -EFBIG) {
+		/*
+		 * EFBIG means we tried to store data at too high a byte offset
+		 * in the sparse array.  IOWs, we cannot complete the check and
+		 * must notify userspace that the check was incomplete.  This
+		 * shouldn't really happen outside of the collection phase.
+		 */
+		xchk_set_incomplete(xnc->sc);
+		return -ECANCELED;
+	}
+	if (error)
+		return error;
+
+	/* Copy the counters, but do not expose the internal state. */
+	obs->parents = nl.parents;
+	obs->backrefs = nl.backrefs;
+	obs->children = nl.children;
+	obs->flags = 0;
+	return 0;
+}
+
+/* Check our link count against an inode. */
+STATIC int
+xchk_nlinks_compare_inode(
+	struct xchk_nlink_ctrs	*xnc,
+	struct xfs_inode	*ip)
+{
+	struct xchk_nlink	obs;
+	struct xfs_scrub	*sc = xnc->sc;
+	uint64_t		total_links;
+	unsigned int		actual_nlink;
+	int			error;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	mutex_lock(&xnc->lock);
+
+	if (xchk_iscan_aborted(&xnc->collect_iscan)) {
+		xchk_set_incomplete(xnc->sc);
+		error = -ECANCELED;
+		goto out_scanlock;
+	}
+
+	error = xchk_nlinks_comparison_read(xnc, ip->i_ino, &obs);
+	if (error)
+		goto out_scanlock;
+
+	/*
+	 * If we don't have ftype to get an accurate count of the subdirectory
+	 * entries in this directory, take advantage of the fact that on a
+	 * consistent ftype=0 filesystem, the number of subdirectory
+	 * backreferences (dotdot entries) pointing towards this directory
+	 * should be one less than the number of subdirectory entries in the
+	 * directory.
+	 */
+	if (!xfs_has_ftype(sc->mp) && S_ISDIR(VFS_I(ip)->i_mode))
+		obs.children = obs.backrefs + 1;
+
+	total_links = xchk_nlink_total(&obs);
+	actual_nlink = VFS_I(ip)->i_nlink;
+
+	trace_xchk_nlinks_compare_inode(sc->mp, ip, &obs);
+
+	/* We found more than the maxiumum possible link count. */
+	if (total_links > U32_MAX)
+		xchk_ino_set_corrupt(sc, ip->i_ino);
+
+	/* Link counts should match. */
+	if (total_links != actual_nlink)
+		xchk_ino_set_corrupt(sc, ip->i_ino);
+
+	if (S_ISDIR(VFS_I(ip)->i_mode) && actual_nlink > 0) {
+		/*
+		 * The collection phase ignores directories with zero link
+		 * count, so we ignore them here too.
+		 *
+		 * Linked directories must have at least one child (dot entry).
+		 */
+		if (obs.children < 1)
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+		/*
+		 * The number of subdirectory backreferences (dotdot entries)
+		 * pointing towards this directory should be one less than the
+		 * number of subdirectory entries in the directory.
+		 */
+		if (obs.children != obs.backrefs + 1)
+			xchk_ino_xref_set_corrupt(sc, ip->i_ino);
+	} else {
+		/*
+		 * Non-directories and unlinked directories should not have
+		 * back references.
+		 */
+		if (obs.backrefs != 0)
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+
+		/*
+		 * Non-directories and unlinked directories should not have
+		 * children.
+		 */
+		if (obs.children != 0)
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+	}
+
+	if (ip == sc->mp->m_rootip) {
+		/*
+		 * For the root of a directory tree, both the '.' and '..'
+		 * entries should point to the root directory.  The dot entry
+		 * is counted as a child subdirectory (like any directory).
+		 * The dotdot entry is counted as a parent of the root /and/
+		 * a backref of the root directory.
+		 */
+		if (obs.parents != 1)
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+		if (obs.children < 1)
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+	} else if (actual_nlink > 0) {
+		/*
+		 * Linked files that are not the root directory should have at
+		 * least one parent.
+		 */
+		if (obs.parents == 0)
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+	}
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		error = -ECANCELED;
+
+out_scanlock:
+	mutex_unlock(&xnc->lock);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return error;
+}
+
+/*
+ * Check our link count against an inode that wasn't checked previously.  This
+ * is intended to catch directories with dangling links, though we could be
+ * racing with inode allocation in other threads.
+ */
+STATIC int
+xchk_nlinks_compare_inum(
+	struct xchk_nlink_ctrs	*xnc,
+	xfs_ino_t		ino)
+{
+	struct xchk_nlink	obs;
+	struct xfs_mount	*mp = xnc->sc->mp;
+	struct xfs_trans	*tp = xnc->sc->tp;
+	struct xfs_buf		*agi_bp;
+	struct xfs_inode	*ip;
+	int			error;
+
+	/*
+	 * The first iget failed, so try again with the variant that returns
+	 * either an incore inode or the AGI buffer.  If the function returns
+	 * EINVAL/ENOENT, it should have passed us the AGI buffer so that we
+	 * can guarantee that the inode won't be allocated while we check for
+	 * a zero link count in the observed link count data.
+	 */
+	error = xchk_iget_agi(xnc->sc, ino, &agi_bp, &ip);
+	if (!error) {
+		/* Actually got an inode, so use the inode compare. */
+		error = xchk_nlinks_compare_inode(xnc, ip);
+		xchk_irele(xnc->sc, ip);
+		return error;
+	}
+	if (error == -ENOENT || error == -EINVAL) {
+		/* No inode was found.  Check for zero link count below. */
+		error = 0;
+	}
+	if (error)
+		goto out_agi;
+
+	/* Ensure that we have protected against inode allocation/freeing. */
+	if (agi_bp == NULL) {
+		ASSERT(agi_bp != NULL);
+		xchk_set_incomplete(xnc->sc);
+		return -ECANCELED;
+	}
+
+	if (xchk_iscan_aborted(&xnc->collect_iscan)) {
+		xchk_set_incomplete(xnc->sc);
+		error = -ECANCELED;
+		goto out_agi;
+	}
+
+	mutex_lock(&xnc->lock);
+	error = xchk_nlinks_comparison_read(xnc, ino, &obs);
+	if (error)
+		goto out_scanlock;
+
+	trace_xchk_nlinks_check_zero(mp, ino, &obs);
+
+	/*
+	 * If we can't grab the inode, the link count had better be zero.  We
+	 * still hold the AGI to prevent inode allocation/freeing.
+	 */
+	if (xchk_nlink_total(&obs) != 0) {
+		xchk_ino_set_corrupt(xnc->sc, ino);
+		error = -ECANCELED;
+	}
+
+out_scanlock:
+	mutex_unlock(&xnc->lock);
+out_agi:
+	if (agi_bp)
+		xfs_trans_brelse(tp, agi_bp);
+	return error;
+}
+
+/*
+ * Try to visit every inode in the filesystem to compare the link count.  Move
+ * on if we can't grab an inode, since we'll revisit unchecked nlink records in
+ * the second part.
+ */
+static int
+xchk_nlinks_compare_iter(
+	struct xchk_nlink_ctrs	*xnc,
+	struct xfs_inode	**ipp)
+{
+	int			error;
+
+	do {
+		error = xchk_iscan_iter(xnc->sc, &xnc->compare_iscan, ipp);
+	} while (error == -EBUSY);
+
+	return error;
+}
+
+/* Compare the link counts we observed against the live information. */
+STATIC int
+xchk_nlinks_compare(
+	struct xchk_nlink_ctrs	*xnc)
+{
+	struct xchk_nlink	nl;
+	struct xfs_scrub	*sc = xnc->sc;
+	struct xfs_inode	*ip;
+	xfarray_idx_t		cur = XFARRAY_CURSOR_INIT;
+	int			error;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
+	/*
+	 * Create a new empty transaction so that we can advance the iscan
+	 * cursor without deadlocking if the inobt has a cycle and push on the
+	 * inactivation workqueue.
+	 */
+	xchk_trans_cancel(sc);
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Use the inobt to walk all allocated inodes to compare the link
+	 * counts.  Inodes skipped by _compare_iter will be tried again in the
+	 * next phase of the scan.
+	 */
+	xchk_iscan_start(&xnc->compare_iscan, 0, 0);
+	while ((error = xchk_nlinks_compare_iter(xnc, &ip)) == 1) {
+		error = xchk_nlinks_compare_inode(xnc, ip);
+		xchk_iscan_mark_visited(&xnc->compare_iscan, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		if (xchk_should_terminate(sc, &error))
+			break;
+	}
+	xchk_iscan_finish(&xnc->compare_iscan);
+	if (error)
+		return error;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
+	/*
+	 * Walk all the non-null nlink observations that weren't checked in the
+	 * previous step.
+	 */
+	mutex_lock(&xnc->lock);
+	while ((error = xfarray_iter(xnc->nlinks, &cur, &nl)) == 1) {
+		xfs_ino_t	ino = cur - 1;
+
+		if (nl.flags & XCHK_NLINK_COMPARE_SCANNED)
+			continue;
+
+		mutex_unlock(&xnc->lock);
+
+		error = xchk_nlinks_compare_inum(xnc, ino);
+		if (error)
+			return error;
+
+		if (xchk_should_terminate(xnc->sc, &error))
+			return error;
+
+		mutex_lock(&xnc->lock);
+	}
+	mutex_unlock(&xnc->lock);
+
+	return error;
+}
+
+/* Tear down everything associated with a nlinks check. */
+static void
+xchk_nlinks_teardown_scan(
+	void			*priv)
+{
+	struct xchk_nlink_ctrs	*xnc = priv;
+
+	xfarray_destroy(xnc->nlinks);
+	xnc->nlinks = NULL;
+
+	xchk_iscan_finish(&xnc->collect_iscan);
+	mutex_destroy(&xnc->lock);
+	xnc->sc = NULL;
+}
+
+/*
+ * Scan all inodes in the entire filesystem to generate link count data.  If
+ * the scan is successful, the counts will be left alive for a repair.  If any
+ * error occurs, we'll tear everything down.
+ */
+STATIC int
+xchk_nlinks_setup_scan(
+	struct xfs_scrub	*sc,
+	struct xchk_nlink_ctrs	*xnc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned long long	max_inos;
+	xfs_agnumber_t		last_agno = mp->m_sb.sb_agcount - 1;
+	xfs_agino_t		first_agino, last_agino;
+	int			error;
+
+	ASSERT(xnc->sc == NULL);
+	xnc->sc = sc;
+
+	mutex_init(&xnc->lock);
+
+	/* Retry iget every tenth of a second for up to 30 seconds. */
+	xchk_iscan_start(&xnc->collect_iscan, 30000, 100);
+
+	/*
+	 * Set up enough space to store an nlink record for the highest
+	 * possible inode number in this system.
+	 */
+	xfs_agino_range(mp, last_agno, &first_agino, &last_agino);
+	max_inos = XFS_AGINO_TO_INO(mp, last_agno, last_agino) + 1;
+
+	error = xfarray_create(mp, "file link counts",
+			min(XFS_MAXINUMBER + 1, max_inos),
+			sizeof(struct xchk_nlink), &xnc->nlinks);
+	if (error)
+		goto out_teardown;
+
+	/* Use deferred cleanup to pass the inode link count data to repair. */
+	sc->buf_cleanup = xchk_nlinks_teardown_scan;
+	return 0;
+
+out_teardown:
+	xchk_nlinks_teardown_scan(xnc);
+	return error;
+}
+
+/* Scrub the link count of all inodes on the filesystem. */
+int
+xchk_nlinks(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_nlink_ctrs	*xnc = sc->buf;
+	int			error = 0;
+
+	/* Set ourselves up to check link counts on the live filesystem. */
+	error = xchk_nlinks_setup_scan(sc, xnc);
+	if (error)
+		return error;
+
+	/* Walk all inodes, picking up link count information. */
+	error = xchk_nlinks_collect(xnc);
+	if (!xchk_xref_process_error(sc, 0, 0, &error))
+		return error;
+
+	/* Fail fast if we're not playing with a full dataset. */
+	if (xchk_iscan_aborted(&xnc->collect_iscan))
+		xchk_set_incomplete(sc);
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+		return 0;
+
+	/* Compare link counts. */
+	error = xchk_nlinks_compare(xnc);
+	if (!xchk_xref_process_error(sc, 0, 0, &error))
+		return error;
+
+	/* Check one last time for an incomplete dataset. */
+	if (xchk_iscan_aborted(&xnc->collect_iscan))
+		xchk_set_incomplete(sc);
+
+	return 0;
+}
diff --git a/fs/xfs/scrub/nlinks.h b/fs/xfs/scrub/nlinks.h
new file mode 100644
index 000000000000..30fa7dd93029
--- /dev/null
+++ b/fs/xfs/scrub/nlinks.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_NLINKS_H__
+#define __XFS_SCRUB_NLINKS_H__
+
+/* Live link count control structure. */
+struct xchk_nlink_ctrs {
+	struct xfs_scrub	*sc;
+
+	/* Shadow link count data and its mutex. */
+	struct xfarray		*nlinks;
+	struct mutex		lock;
+
+	/*
+	 * The collection step uses a separate iscan context from the compare
+	 * step because the collection iscan coordinates live updates to the
+	 * observation data while this scanner is running.  The compare iscan
+	 * is secondary and can be reinitialized as needed.
+	 */
+	struct xchk_iscan	collect_iscan;
+	struct xchk_iscan	compare_iscan;
+};
+
+/*
+ * In-core link counts for a given inode in the filesystem.
+ *
+ * For an empty rootdir, the directory entries and the field to which they are
+ * accounted are as follows:
+ *
+ * Root directory:
+ *
+ * . points to self		(root.child)
+ * .. points to self		(root.parent)
+ * f1 points to a child file	(f1.parent)
+ * d1 points to a child dir	(d1.parent, root.child)
+ *
+ * Subdirectory d1:
+ *
+ * . points to self		(d1.child)
+ * .. points to root dir	(root.backref)
+ * f2 points to child file	(f2.parent)
+ * f3 points to root.f1		(f1.parent)
+ *
+ * root.nlink == 3 (root.dot, root.dotdot, root.d1)
+ * d1.nlink == 2 (root.d1, d1.dot)
+ * f1.nlink == 2 (root.f1, d1.f3)
+ * f2.nlink == 1 (d1.f2)
+ */
+struct xchk_nlink {
+	/* Count of forward links from parent directories to this file. */
+	xfs_nlink_t		parents;
+
+	/*
+	 * Count of back links to this parent directory from child
+	 * subdirectories.
+	 */
+	xfs_nlink_t		backrefs;
+
+	/*
+	 * Count of forward links from this directory to all child files and
+	 * the number of dot entries.  Should be zero for non-directories.
+	 */
+	xfs_nlink_t		children;
+
+	/* Record state flags */
+	unsigned int		flags;
+};
+
+/*
+ * This incore link count has been written at least once.  We never want to
+ * store an xchk_nlink that looks uninitialized.
+ */
+#define XCHK_NLINK_WRITTEN		(1U << 0)
+
+/* This data item was seen by the check-time compare function. */
+#define XCHK_NLINK_COMPARE_SCANNED	(1U << 1)
+
+/* Compute total link count, using large enough variables to detect overflow. */
+static inline uint64_t
+xchk_nlink_total(const struct xchk_nlink *live)
+{
+	uint64_t	ret = live->parents;
+
+	return ret + live->children;
+}
+
+#endif /* __XFS_SCRUB_NLINKS_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 60c6665b6277..8fdd38dbb9f4 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -372,6 +372,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_quotacheck,
 		.repair	= xrep_quotacheck,
 	},
+	[XFS_SCRUB_TYPE_NLINKS] = {	/* inode link counts */
+		.type	= ST_FS,
+		.setup	= xchk_setup_nlinks,
+		.scrub	= xchk_nlinks,
+		.repair	= xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index de09b709992b..d39b2b95352a 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -179,6 +179,7 @@ xchk_quotacheck(struct xfs_scrub *sc)
 }
 #endif
 int xchk_fscounters(struct xfs_scrub *sc);
+int xchk_nlinks(struct xfs_scrub *sc);
 
 /* cross-referencing helpers */
 void xchk_xref_is_used_space(struct xfs_scrub *sc, xfs_agblock_t agbno,
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 6a9835d9779f..82edcc830fb8 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -14,10 +14,12 @@
 #include "xfs_btree.h"
 #include "xfs_ag.h"
 #include "xfs_quota_defs.h"
+#include "xfs_dir2.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
+#include "scrub/nlinks.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 2a025eb356fc..508698d356d2 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -22,6 +22,7 @@ struct xfile;
 struct xfarray;
 struct xfarray_sortinfo;
 struct xchk_iscan;
+struct xchk_nlink;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -66,6 +67,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -93,7 +95,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
 	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
 	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
-	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }
+	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }, \
+	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
@@ -1127,6 +1130,148 @@ TRACE_EVENT(xchk_iscan_iget_retry_wait,
 		  __entry->retry_delay)
 );
 
+TRACE_EVENT(xchk_nlinks_collect_dirent,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_inode *dp,
+		 xfs_ino_t ino, const struct xfs_name *name),
+	TP_ARGS(mp, dp, ino, name),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir)
+		__field(xfs_ino_t, ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->dir = dp->i_ino;
+		__entry->ino = ino;
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
+	),
+	TP_printk("dev %d:%d dir 0x%llx -> ino 0x%llx name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir,
+		  __entry->ino,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
+TRACE_EVENT(xchk_nlinks_collect_metafile,
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino),
+	TP_ARGS(mp, ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = ino;
+	),
+	TP_printk("dev %d:%d ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino)
+);
+
+TRACE_EVENT(xchk_nlinks_check_zero,
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,
+		 const struct xchk_nlink *live),
+	TP_ARGS(mp, ino, live),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_nlink_t, parents)
+		__field(xfs_nlink_t, backrefs)
+		__field(xfs_nlink_t, children)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = ino;
+		__entry->parents = live->parents;
+		__entry->backrefs = live->backrefs;
+		__entry->children = live->children;
+	),
+	TP_printk("dev %d:%d ino 0x%llx parents %u backrefs %u children %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parents,
+		  __entry->backrefs,
+		  __entry->children)
+);
+
+TRACE_EVENT(xchk_nlinks_update_incore,
+	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,
+		 const struct xchk_nlink *live, int parents_delta,
+		 int backrefs_delta, int children_delta),
+	TP_ARGS(mp, ino, live, parents_delta, backrefs_delta, children_delta),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_nlink_t, parents)
+		__field(xfs_nlink_t, backrefs)
+		__field(xfs_nlink_t, children)
+		__field(int, parents_delta)
+		__field(int, backrefs_delta)
+		__field(int, children_delta)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = ino;
+		__entry->parents = live->parents;
+		__entry->backrefs = live->backrefs;
+		__entry->children = live->children;
+		__entry->parents_delta = parents_delta;
+		__entry->backrefs_delta = backrefs_delta;
+		__entry->children_delta = children_delta;
+	),
+	TP_printk("dev %d:%d ino 0x%llx parents %d:%u backrefs %d:%u children %d:%u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parents_delta,
+		  __entry->parents,
+		  __entry->backrefs_delta,
+		  __entry->backrefs,
+		  __entry->children_delta,
+		  __entry->children)
+);
+
+DECLARE_EVENT_CLASS(xchk_nlinks_diff_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_inode *ip,
+		 const struct xchk_nlink *live),
+	TP_ARGS(mp, ip, live),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(uint8_t, ftype)
+		__field(xfs_nlink_t, nlink)
+		__field(xfs_nlink_t, parents)
+		__field(xfs_nlink_t, backrefs)
+		__field(xfs_nlink_t, children)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->ftype = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
+		__entry->nlink = VFS_I(ip)->i_nlink;
+		__entry->parents = live->parents;
+		__entry->backrefs = live->backrefs;
+		__entry->children = live->children;
+	),
+	TP_printk("dev %d:%d ino 0x%llx ftype %s nlink %u parents %u backrefs %u children %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->ftype, XFS_DIR3_FTYPE_STR),
+		  __entry->nlink,
+		  __entry->parents,
+		  __entry->backrefs,
+		  __entry->children)
+);
+#define DEFINE_SCRUB_NLINKS_DIFF_EVENT(name) \
+DEFINE_EVENT(xchk_nlinks_diff_class, name, \
+	TP_PROTO(struct xfs_mount *mp, struct xfs_inode *ip, \
+		 const struct xchk_nlink *live), \
+	TP_ARGS(mp, ip, live))
+DEFINE_SCRUB_NLINKS_DIFF_EVENT(xchk_nlinks_compare_inode);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 

