Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E35376EA
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591323; cv=none; b=dy3n4vn/ifTq1Sb0Fdhx+uKcyoF4dF8AU4N0NnkkpbDp2bAtKNFvZB2c0Wvj382AzZulVTxDf9CI3ijRSzoNHkwwnnpvPbIonQfES8RsfVYX12j39FmJPC3x8q6ppnGsMKbqtXyEkcH6QvGlADFtVrqBGxFWNmgm+ZGFeQDjRTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591323; c=relaxed/simple;
	bh=IFVOpN24GU8PE5R91+yvPzIl21h5Oq1GOC5s2EZoDpU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U1HlLg1BdXWV/s5f11eC3vulwYqUs/a5+Zf8SCPlZDUpK1VT0mhVdEcuoYCA6BWW+yEz3nCd9iyF/9+GwS/8wgHfujKpNZspjxUrV8DN4MmMUjzZqpwv8a2uWXY/LEMO8qxPXFurSPXWuYIUbI35hftfUzXq2iWlllak2LDQu2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gT1RLljk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gT1RLljk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC855C433C7;
	Tue, 30 Jan 2024 05:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591322;
	bh=IFVOpN24GU8PE5R91+yvPzIl21h5Oq1GOC5s2EZoDpU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gT1RLljkl8BJRxznx4GEEv02pluXEFlN6l78C0tJWVYK6eT1vR+hp5TdJLhEYwwrB
	 OFjKP6RkoGV5yNFYps/FWfWiqlbFkwzNIeDPE2KPfgsHtY/ILPc/rwoQilnE2xxZ21
	 eBuesHxaDvr48cuzdYSJV0xQb6Fm1U+9rl0OHYK7KyUSLEEEyGwkMkRX+eRjihuDPo
	 n/4UAWqI3QsYH8850RcniW4X4jUrB9k0GxVvaOUUqmSvdWV7YpirgmCFTyjTElpmZW
	 V+Y+MfheKaQDMzzJbObjmKUlqlkrf+dvZGKwzm501W1Vq3sBNkv70z649E7Ad/IWf8
	 +Zx91/+GbBwRQ==
Date: Mon, 29 Jan 2024 21:08:42 -0800
Subject: [PATCH 2/4] xfs: teach scrub to check file nlinks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063291.3353617.4827075069995433952.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063247.3353617.664642117268018311.stgit@frogsfrogsfrogs>
References: <170659063247.3353617.664642117268018311.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create the necessary scrub code to walk the filesystem's directory tree
so that we can compute file link counts.  Similar to quotacheck, we
create an incore shadow array of link count information and then we walk
the filesystem a second time to compare the link counts.  We need live
updates to keep the information up to date during the lengthy scan, so
this scrubber remains disabled until the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 
 fs/xfs/scrub/common.h  |    1 
 fs/xfs/scrub/health.c  |    1 
 fs/xfs/scrub/nlinks.c  |  839 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.h  |   93 +++++
 fs/xfs/scrub/scrub.c   |    6 
 fs/xfs/scrub/scrub.h   |    1 
 fs/xfs/scrub/stats.c   |    1 
 fs/xfs/scrub/trace.c   |    2 
 fs/xfs/scrub/trace.h   |  147 ++++++++
 11 files changed, 1093 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/nlinks.c
 create mode 100644 fs/xfs/scrub/nlinks.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 563178216393f..cabf1dd341adc 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -161,6 +161,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc.o \
 				   inode.o \
 				   iscan.o \
+				   nlinks.o \
 				   parent.o \
 				   readdir.o \
 				   refcount.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index f10d0aa0e337f..515cd27d3b3a8 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -712,9 +712,10 @@ struct xfs_scrub_metadata {
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
index eb51037cd0d2f..529a510dc76f5 100644
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
index 3c9eac0707962..34519fbc2d40b 100644
--- a/fs/xfs/scrub/health.c
+++ b/fs/xfs/scrub/health.c
@@ -106,6 +106,7 @@ static const struct xchk_health_map type_to_health_flag[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_PQUOTA]		= { XHG_FS,  XFS_SICK_FS_PQUOTA },
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= { XHG_FS,  XFS_SICK_FS_COUNTERS },
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= { XHG_FS,  XFS_SICK_FS_QUOTACHECK },
+	[XFS_SCRUB_TYPE_NLINKS]		= { XHG_FS,  XFS_SICK_FS_NLINKS },
 };
 
 /* Return the health status mask for this scrub type. */
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
new file mode 100644
index 0000000000000..c899a50a83daf
--- /dev/null
+++ b/fs/xfs/scrub/nlinks.c
@@ -0,0 +1,839 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
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
+/*
+ * Add a delta to an nlink counter, clamping the value to U32_MAX.  Because
+ * XFS_MAXLINK < U32_MAX, the checking code will produce the correct results
+ * even if we lose some precision.
+ */
+static inline void
+careful_add(
+	xfs_nlink_t	*nlinkp,
+	int		delta)
+{
+	uint64_t	new_value = (uint64_t)(*nlinkp) + delta;
+
+	BUILD_BUG_ON(XFS_MAXLINK > U32_MAX);
+	*nlinkp = min_t(uint64_t, new_value, U32_MAX);
+}
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
+	careful_add(&nl.parents, parents_delta);
+	careful_add(&nl.backrefs, backrefs_delta);
+	careful_add(&nl.children, children_delta);
+
+	nl.flags |= XCHK_NLINK_WRITTEN;
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
+	if (!xfs_verify_dir_ino(sc->mp, ino)) {
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
+	 * If this dirent is a forward link to a subdirectory, increment the
+	 * number of child links of dp.
+	 */
+	if (!dot && !dotdot && name->type == XFS_DIR3_FT_DIR) {
+		error = xchk_nlinks_update_incore(xnc, dp->i_ino, 0, 0, 1);
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
+	if (xchk_dir_looks_zapped(dp)) {
+		error = -EBUSY;
+		goto out_abort;
+	}
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
+	while ((error = xchk_iscan_iter(&xnc->collect_iscan, &ip)) == 1) {
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
+	xchk_iscan_iter_finish(&xnc->collect_iscan);
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
+	 * should be equal to the number of subdirectory entries in the
+	 * directory.
+	 */
+	if (!xfs_has_ftype(sc->mp) && S_ISDIR(VFS_I(ip)->i_mode))
+		obs.children = obs.backrefs;
+
+	total_links = xchk_nlink_total(ip, &obs);
+	actual_nlink = VFS_I(ip)->i_nlink;
+
+	trace_xchk_nlinks_compare_inode(sc->mp, ip, &obs);
+
+	/*
+	 * If we found so many parents that we'd overflow i_nlink, we must flag
+	 * this as a corruption.  The VFS won't let users increase the link
+	 * count, but it will let them decrease it.
+	 */
+	if (total_links > XFS_MAXLINK) {
+		xchk_ino_set_corrupt(sc, ip->i_ino);
+		goto out_corrupt;
+	}
+
+	/* Link counts should match. */
+	if (total_links != actual_nlink) {
+		xchk_ino_set_corrupt(sc, ip->i_ino);
+		goto out_corrupt;
+	}
+
+	if (S_ISDIR(VFS_I(ip)->i_mode) && actual_nlink > 0) {
+		/*
+		 * The collection phase ignores directories with zero link
+		 * count, so we ignore them here too.
+		 *
+		 * The number of subdirectory backreferences (dotdot entries)
+		 * pointing towards this directory should be equal to the
+		 * number of subdirectory entries in the directory.
+		 */
+		if (obs.children != obs.backrefs)
+			xchk_ino_xref_set_corrupt(sc, ip->i_ino);
+	} else {
+		/*
+		 * Non-directories and unlinked directories should not have
+		 * back references.
+		 */
+		if (obs.backrefs != 0) {
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+			goto out_corrupt;
+		}
+
+		/*
+		 * Non-directories and unlinked directories should not have
+		 * children.
+		 */
+		if (obs.children != 0) {
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+			goto out_corrupt;
+		}
+	}
+
+	if (ip == sc->mp->m_rootip) {
+		/*
+		 * For the root of a directory tree, both the '.' and '..'
+		 * entries should point to the root directory.  The dotdot
+		 * entry is counted as a parent of the root /and/ a backref of
+		 * the root directory.
+		 */
+		if (obs.parents != 1) {
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+			goto out_corrupt;
+		}
+	} else if (actual_nlink > 0) {
+		/*
+		 * Linked files that are not the root directory should have at
+		 * least one parent.
+		 */
+		if (obs.parents == 0) {
+			xchk_ino_set_corrupt(sc, ip->i_ino);
+			goto out_corrupt;
+		}
+	}
+
+out_corrupt:
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		error = -ECANCELED;
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
+	if (xchk_nlink_total(NULL, &obs) != 0) {
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
+		error = xchk_iscan_iter(&xnc->compare_iscan, ipp);
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
+	xchk_iscan_start(sc, 0, 0, &xnc->compare_iscan);
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
+	xchk_iscan_iter_finish(&xnc->compare_iscan);
+	xchk_iscan_teardown(&xnc->compare_iscan);
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
+	xchk_iscan_teardown(&xnc->collect_iscan);
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
+	char			*descr;
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
+	xchk_iscan_start(sc, 30000, 100, &xnc->collect_iscan);
+
+	/*
+	 * Set up enough space to store an nlink record for the highest
+	 * possible inode number in this system.
+	 */
+	xfs_agino_range(mp, last_agno, &first_agino, &last_agino);
+	max_inos = XFS_AGINO_TO_INO(mp, last_agno, last_agino) + 1;
+	descr = xchk_xfile_descr(sc, "file link counts");
+	error = xfarray_create(descr, min(XFS_MAXINUMBER + 1, max_inos),
+			sizeof(struct xchk_nlink), &xnc->nlinks);
+	kfree(descr);
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
index 0000000000000..69a3460c5e52f
--- /dev/null
+++ b/fs/xfs/scrub/nlinks.h
@@ -0,0 +1,93 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2021-2024 Oracle.  All Rights Reserved.
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
+xchk_nlink_total(struct xfs_inode *ip, const struct xchk_nlink *live)
+{
+	uint64_t	ret = live->parents;
+
+	/* Add one link count for the dot entry of any linked directory. */
+	if (ip && S_ISDIR(VFS_I(ip)->i_mode) && VFS_I(ip)->i_nlink)
+		ret++;
+	return ret + live->children;
+}
+
+#endif /* __XFS_SCRUB_NLINKS_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9112c0985c62b..8c60774d5f345 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -369,6 +369,12 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
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
index 5cd4550155f23..de6b45f99dd5f 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -183,6 +183,7 @@ xchk_quotacheck(struct xfs_scrub *sc)
 }
 #endif
 int xchk_fscounters(struct xfs_scrub *sc);
+int xchk_nlinks(struct xfs_scrub *sc);
 
 /* cross-referencing helpers */
 void xchk_xref_is_used_space(struct xfs_scrub *sc, xfs_agblock_t agbno,
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index d716a432227b0..b4ef1ebe28ab8 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -78,6 +78,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_PQUOTA]		= "prjquota",
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= "fscounters",
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= "quotacheck",
+	[XFS_SCRUB_TYPE_NLINKS]		= "nlinks",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 5ed75cc33b928..2d5a330afe10c 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -17,11 +17,13 @@
 #include "xfs_quota.h"
 #include "xfs_quota_defs.h"
 #include "xfs_da_format.h"
+#include "xfs_dir2.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/quota.h"
 #include "scrub/iscan.h"
+#include "scrub/nlinks.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index fedcebf90a420..0deea8f18a30b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -23,6 +23,7 @@ struct xfarray;
 struct xfarray_sortinfo;
 struct xchk_dqiter;
 struct xchk_iscan;
+struct xchk_nlink;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -67,6 +68,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_GQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PQUOTA);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -94,7 +96,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 	{ XFS_SCRUB_TYPE_GQUOTA,	"grpquota" }, \
 	{ XFS_SCRUB_TYPE_PQUOTA,	"prjquota" }, \
 	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
-	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }
+	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }, \
+	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
@@ -1318,6 +1321,148 @@ TRACE_EVENT(xchk_iscan_iget_retry_wait,
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
 

