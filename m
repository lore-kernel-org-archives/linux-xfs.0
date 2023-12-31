Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708DEC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VJXObHYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F06C433C8;
	Sun, 31 Dec 2023 22:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060169;
	bh=1qlARPRFBOoGaPcPjNnMRZxkXxpOJspCesn0GB86cWs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VJXObHYFPcCOsJrEIJBTKc9TAkthtvClz2eJpksOKWAcmr4xhC4BRfuXin4y0il14
	 qy5K4n66bxetcsdtiu7T/+BDSPp9FxlldCGAISWCjslj+2GeD5XR6UtY31meZszajU
	 3OM5LuzIe4j9wOZMZIto3QMx4raQhA3UuxP4rsuxmRIbrWEsT4SicIWlHt7giHs0jk
	 M97izjh1paYtQqfJLVgm0HvCivV+NfJW8um2iFFIa2klENVlt6syinkNCMhnu0iJvR
	 2ZWIJnSw/UDPjoZMfIb6w7SftGeXfPeE9ySnS3ISIu77yIwMMKzxJ5HHgeLAvVbSfA
	 el1j+B5NrKr7g==
Date: Sun, 31 Dec 2023 14:02:49 -0800
Subject: [PATCH 2/2] xfs: add an ioctl to map free space into a file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404855545.1769925.5189669409442600487.stgit@frogsfrogsfrogs>
In-Reply-To: <170404855508.1769925.12296060252141719128.stgit@frogsfrogsfrogs>
References: <170404855508.1769925.12296060252141719128.stgit@frogsfrogsfrogs>
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

Add a new ioctl to map free physical space into a file, at the same file
offset as if the file were a sparse image of the physical device backing
the filesystem.  The intent here is to use this to prototype a free
space defragmentation tool.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c      |   88 +++++++++++
 fs/xfs/libxfs/xfs_alloc.h      |    3 
 fs/xfs/libxfs/xfs_bmap.c       |  150 +++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h       |    3 
 fs/xfs/libxfs/xfs_fs.h         |    1 
 fs/xfs/libxfs/xfs_fs_staging.h |   15 ++
 fs/xfs/xfs_bmap_util.c         |  311 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h         |    3 
 fs/xfs/xfs_file.c              |   77 ++++++++++
 fs/xfs/xfs_file.h              |    2 
 fs/xfs/xfs_ioctl.c             |   68 +++++++++
 fs/xfs/xfs_rtalloc.c           |   52 +++++++
 fs/xfs/xfs_rtalloc.h           |   12 +-
 fs/xfs/xfs_trace.h             |   62 ++++++++
 14 files changed, 846 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index cf56784aabbbc..dec07573b307e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -4096,3 +4096,91 @@ xfs_extfree_intent_destroy_cache(void)
 	kmem_cache_destroy(xfs_extfree_item_cache);
 	xfs_extfree_item_cache = NULL;
 }
+
+/*
+ * Find the next chunk of free space in @pag starting at @agbno and going no
+ * higher than @end_agbno.  Set @agbno and @len to whatever free space we find,
+ * or to @end_agbno if we find no space.
+ */
+int
+xfs_alloc_find_freesp(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	xfs_agblock_t		*agbno,
+	xfs_agblock_t		end_agbno,
+	xfs_extlen_t		*len)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agf_bp = NULL;
+	xfs_agblock_t		found_agbno;
+	xfs_extlen_t		found_len;
+	int			found;
+	int			error;
+
+	trace_xfs_alloc_find_freesp(mp, pag->pag_agno, *agbno,
+			end_agbno - *agbno);
+
+	error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+	if (error)
+		return error;
+
+	cur = xfs_allocbt_init_cursor(mp, tp, agf_bp, pag, XFS_BTNUM_BNO);
+
+	/* Try to find a free extent that starts before here. */
+	error = xfs_alloc_lookup_le(cur, *agbno, 0, &found);
+	if (error)
+		goto out_cur;
+	if (found) {
+		error = xfs_alloc_get_rec(cur, &found_agbno, &found_len,
+				&found);
+		if (error)
+			goto out_cur;
+		if (XFS_IS_CORRUPT(mp, !found)) {
+			xfs_btree_mark_sick(cur);
+			error = -EFSCORRUPTED;
+			goto out_cur;
+		}
+
+		if (found_agbno + found_len > *agbno)
+			goto found;
+	}
+
+	/* Examine the next record if free extent not in range. */
+	error = xfs_btree_increment(cur, 0, &found);
+	if (error)
+		goto out_cur;
+	if (!found)
+		goto next_ag;
+
+	error = xfs_alloc_get_rec(cur, &found_agbno, &found_len, &found);
+	if (error)
+		goto out_cur;
+	if (XFS_IS_CORRUPT(mp, !found)) {
+		xfs_btree_mark_sick(cur);
+		error = -EFSCORRUPTED;
+		goto out_cur;
+	}
+
+	if (found_agbno >= end_agbno)
+		goto next_ag;
+
+found:
+	/* Found something, so update the mapping. */
+	trace_xfs_alloc_find_freesp_done(mp, pag->pag_agno, found_agbno,
+			found_len);
+	if (found_agbno < *agbno) {
+		found_len -= *agbno - found_agbno;
+		found_agbno = *agbno;
+	}
+	*len = found_len;
+	*agbno = found_agbno;
+	goto out_cur;
+next_ag:
+	/* Found nothing, so advance the cursor beyond the end of the range. */
+	*agbno = end_agbno;
+	*len = 0;
+out_cur:
+	xfs_btree_del_cursor(cur, error);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 130026e981ea2..fedb6dc0443e5 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -290,5 +290,8 @@ void xfs_extfree_intent_destroy_cache(void);
 
 xfs_failaddr_t xfs_validate_ag_length(struct xfs_buf *bp, uint32_t seqno,
 		uint32_t length);
+int xfs_alloc_find_freesp(struct xfs_trans *tp, struct xfs_perag *pag,
+		xfs_agblock_t *agbno, xfs_agblock_t end_agbno,
+		xfs_extlen_t *len);
 
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c6ab6a38bc7cd..7d0d82353a745 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -40,6 +40,7 @@
 #include "xfs_bmap_item.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
+#include "xfs_rtalloc.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -6442,3 +6443,152 @@ xfs_get_cowextsz_hint(
 		return XFS_DEFAULT_COWEXTSZ_HINT;
 	return a;
 }
+
+static inline xfs_fileoff_t
+xfs_fsblock_to_fileoff(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsbno)
+{
+	xfs_daddr_t		daddr = XFS_FSB_TO_DADDR(mp, fsbno);
+
+	return XFS_B_TO_FSB(mp, BBTOB(daddr));
+}
+
+/*
+ * Given a file and a free physical extent, map it into the file at the same
+ * offset if the file were a sparse image of the physical device.  Set @mval to
+ * whatever mapping we added to the file.
+ */
+int
+xfs_bmapi_freesp(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_fsblock_t		fsbno,
+	xfs_extlen_t		len,
+	struct xfs_bmbt_irec	*mval)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		startoff;
+	bool			isrt = XFS_IS_REALTIME_INODE(ip);
+	int			nimaps;
+	int			error;
+
+	trace_xfs_bmapi_freesp(ip, fsbno, len);
+
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		return error;
+
+	if (isrt)
+		startoff = fsbno;
+	else
+		startoff = xfs_fsblock_to_fileoff(mp, fsbno);
+
+	/* Make sure the entire range is a hole. */
+	nimaps = 1;
+	error = xfs_bmapi_read(ip, startoff, len, &irec, &nimaps, 0);
+	if (error)
+		return error;
+
+	if (irec.br_startoff != startoff ||
+	    irec.br_startblock != HOLESTARTBLOCK ||
+	    irec.br_blockcount < len)
+		return -EINVAL;
+
+	/*
+	 * Allocate the physical extent.  We should not have dropped the lock
+	 * since the scan of the free space metadata, so this should work,
+	 * though the length may be adjusted to play nicely with metadata space
+	 * reservations.
+	 */
+	if (isrt) {
+		xfs_rtxnum_t	rtx_in, rtx_out;
+		xfs_extlen_t	rtxlen_in, rtxlen_out;
+		uint32_t	mod;
+
+		rtx_in = xfs_rtb_to_rtxrem(mp, fsbno, &mod);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EFSCORRUPTED;
+		}
+
+		rtxlen_in = xfs_rtb_to_rtxrem(mp, len, &mod);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EFSCORRUPTED;
+		}
+
+		error = xfs_rtallocate_extent(tp, rtx_in, 1, rtxlen_in,
+				&rtxlen_out, 0, 1, &rtx_out);
+		if (error)
+			return error;
+		if (rtx_out == NULLRTEXTNO) {
+			/*
+			 * We were promised the space!  In theory there aren't
+			 * any reserve lists that would prevent us from getting
+			 * the space.
+			 */
+			return -ENOSPC;
+		}
+		if (rtx_out != rtx_in) {
+			ASSERT(0);
+			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
+			return -EFSCORRUPTED;
+		}
+		mval->br_blockcount = rtxlen_out * mp->m_sb.sb_rextsize;
+	} else {
+		struct xfs_alloc_arg	args = {
+			.mp		= mp,
+			.tp		= tp,
+			.oinfo		= XFS_RMAP_OINFO_SKIP_UPDATE,
+			.resv		= XFS_AG_RESV_NONE,
+			.prod		= 1,
+			.datatype	= XFS_ALLOC_USERDATA,
+			.maxlen		= len,
+			.minlen		= 1,
+		};
+		args.pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsbno));
+		error = xfs_alloc_vextent_exact_bno(&args, fsbno);
+		xfs_perag_put(args.pag);
+		if (error)
+			return error;
+		if (args.fsbno == NULLFSBLOCK) {
+			/*
+			 * We were promised the space, but failed to get it.
+			 * This could be because the space is reserved for
+			 * metadata expansion, or it could be because the AGFL
+			 * fixup grabbed the first block we wanted.  Either
+			 * way, if the transaction is dirty we must commit it
+			 * and tell the caller to try again.
+			 */
+			if (tp->t_flags & XFS_TRANS_DIRTY)
+				return -EAGAIN;
+			return -ENOSPC;
+		}
+		if (args.fsbno != fsbno) {
+			ASSERT(0);
+			xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
+			return -EFSCORRUPTED;
+		}
+		mval->br_blockcount = args.len;
+	}
+
+	/* Map extent into file, update quota. */
+	mval->br_startblock = fsbno;
+	mval->br_startoff = startoff;
+	mval->br_state = XFS_EXT_UNWRITTEN;
+
+	trace_xfs_bmapi_freesp_done(ip, mval);
+
+	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, mval);
+	if (isrt)
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_RTBCOUNT,
+				mval->br_blockcount);
+	else
+		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
+				mval->br_blockcount);
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 61c195198db43..afb54a517f1ad 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -197,6 +197,9 @@ int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extlen_t total, struct xfs_bmbt_irec *mval, int *nmap);
+int	xfs_bmapi_freesp(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fsblock_t fsbno, xfs_extlen_t len,
+		struct xfs_bmbt_irec *mval);
 int	xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extnum_t nexts, int *done);
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 96688f9301e08..922e9acfdc3c7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -864,6 +864,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 /*	XFS_IOC_GETPARENTS ---- staging 62         */
 /*	XFS_IOC_RTGROUP_GEOMETRY - staging 63	   */
+/*	XFS_IOC_MAP_FREESP ---- staging 64	   */
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
index f7d872f8a8837..2a9effb7a846c 100644
--- a/fs/xfs/libxfs/xfs_fs_staging.h
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
@@ -303,4 +303,19 @@ xfs_getfsrefs_advance(
 /* XXX stealing XFS_IOC_GETBIOSIZE */
 #define XFS_IOC_GETFSREFCOUNTS		_IOWR('X', 47, struct xfs_getfsrefs_head)
 
+/* map free space to file */
+
+struct xfs_map_freesp {
+	__s64	offset;		/* disk address to map, in bytes */
+	__s64	len;		/* length in bytes */
+	__u64	flags;		/* must be zero */
+	__u64	pad;		/* must be zero */
+};
+
+/*
+ * XFS_IOC_MAP_FREESP maps all the free physical space in the filesystem into
+ * the file at the same offsets.  This ioctl requires CAP_SYS_ADMIN.
+ */
+#define XFS_IOC_MAP_FREESP	_IOWR('X', 64, struct xfs_map_freesp)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 72abd62d40607..911838fbecbfb 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -30,6 +30,12 @@
 #include "xfs_reflink.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_swapext.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
+#include "xfs_health.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_ag.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1457,3 +1463,308 @@ xfs_convert_bigalloc_file_space(
 	return 0;
 }
 #endif /* CONFIG_XFS_RT */
+
+/*
+ * Reserve space and quota to this transaction to map in as much free space
+ * as we can.  Callers should set @len to the amount of space desired; this
+ * function will shorten that quantity if it can't get space.
+ */
+STATIC int
+xfs_map_free_reserve_more(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_extlen_t		*len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		dblocks;
+	unsigned int		rblocks;
+	unsigned int		min_len;
+	bool			isrt = XFS_IS_REALTIME_INODE(ip);
+	int			error;
+
+	if (*len > XFS_MAX_BMBT_EXTLEN)
+		*len = XFS_MAX_BMBT_EXTLEN;
+	min_len = isrt ? mp->m_sb.sb_rextsize : 1;
+
+again:
+	if (isrt) {
+		dblocks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+		rblocks = *len;
+	} else {
+		dblocks = XFS_DIOSTRAT_SPACE_RES(mp, *len);
+		rblocks = 0;
+	}
+	error = xfs_trans_reserve_more_inode(tp, ip, dblocks, rblocks, false);
+	if (error == -ENOSPC && *len > min_len) {
+		*len >>= 1;
+		goto again;
+	}
+	if (error) {
+		trace_xfs_map_free_reserve_more_fail(ip, error, _RET_IP_);
+		return error;
+	}
+
+	return 0;
+}
+
+/* Find a free extent in this AG and map it into the file. */
+STATIC int
+xfs_map_free_extent(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	xfs_agblock_t		*cursor,
+	xfs_agblock_t		end_agbno,
+	xfs_agblock_t		*last_enospc_agbno)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	xfs_off_t		endpos;
+	xfs_fsblock_t		fsbno;
+	xfs_extlen_t		free_len, map_len;
+	int			error;
+
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, 0, 0, false,
+			&tp);
+	if (error)
+		return error;
+
+	error = xfs_alloc_find_freesp(tp, pag, cursor, end_agbno, &free_len);
+	if (error)
+		goto out_cancel;
+
+	/* Bail out if the cursor is beyond what we asked for. */
+	if (*cursor >= end_agbno)
+		goto out_cancel;
+
+	error = xfs_map_free_reserve_more(tp, ip, &free_len);
+	if (error)
+		goto out_cancel;
+
+	fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, *cursor);
+	map_len = free_len;
+	do {
+		error = xfs_bmapi_freesp(tp, ip, fsbno, map_len, &irec);
+		if (error == -EAGAIN) {
+			/* Failed to map space but were told to try again. */
+			error = xfs_trans_commit(tp);
+			goto out;
+		}
+		if (error != -ENOSPC)
+			break;
+		/*
+		 * If we can't get the space, try asking for successively less
+		 * space in case we're bumping up against per-AG metadata
+		 * reservation limits.
+		 */
+		map_len >>= 1;
+	} while (map_len > 0);
+	if (error == -ENOSPC) {
+		if (*last_enospc_agbno != *cursor) {
+			/*
+			 * However, backing off on the size of the mapping
+			 * request might not work if an AGFL fixup allocated
+			 * the block at *cursor.  The first time this happens,
+			 * remember that we ran out of space here, and try
+			 * again.
+			 */
+			*last_enospc_agbno = *cursor;
+		} else {
+			/*
+			 * If we hit this a second time on the same extent,
+			 * then it's likely that we're bumping up against
+			 * per-AG space reservation limits.  Skip to the next
+			 * extent.
+			 */
+			*cursor += free_len;
+		}
+		error = 0;
+		goto out_cancel;
+	}
+	if (error)
+		goto out_cancel;
+
+	/* Update isize if needed. */
+	endpos = XFS_FSB_TO_B(mp, irec.br_startoff + irec.br_blockcount);
+	if (endpos > i_size_read(VFS_I(ip))) {
+		i_size_write(VFS_I(ip), endpos);
+		ip->i_disk_size = endpos;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	}
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	*cursor += irec.br_blockcount;
+	return 0;
+out_cancel:
+	xfs_trans_cancel(tp);
+out:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/*
+ * Allocate all free physical space between off and len and map it to this
+ * regular non-realtime file.
+ */
+int
+xfs_map_free_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		off,
+	xfs_off_t		len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag = NULL;
+	xfs_daddr_t		off_daddr = BTOBB(off);
+	xfs_daddr_t		end_daddr = BTOBBT(off + len);
+	xfs_fsblock_t		off_fsb = XFS_DADDR_TO_FSB(mp, off_daddr);
+	xfs_fsblock_t		end_fsb = XFS_DADDR_TO_FSB(mp, end_daddr);
+	xfs_agnumber_t		off_agno = XFS_FSB_TO_AGNO(mp, off_fsb);
+	xfs_agnumber_t		end_agno = XFS_FSB_TO_AGNO(mp, end_fsb);
+	xfs_agnumber_t		agno;
+	int			error = 0;
+
+	trace_xfs_map_free_space(ip, off, len);
+
+	agno = off_agno;
+	for_each_perag_range(mp, agno, end_agno, pag) {
+		xfs_agblock_t	off_agbno = 0;
+		xfs_agblock_t	end_agbno;
+		xfs_agblock_t	last_enospc_agbno = NULLAGBLOCK;
+
+		end_agbno = xfs_ag_block_count(mp, pag->pag_agno);
+
+		if (pag->pag_agno == off_agno)
+			off_agbno = XFS_FSB_TO_AGBNO(mp, off_fsb);
+		if (pag->pag_agno == end_agno)
+			end_agbno = XFS_FSB_TO_AGBNO(mp, end_fsb);
+
+		while (off_agbno < end_agbno) {
+			error = xfs_map_free_extent(ip, pag, &off_agbno,
+					end_agbno, &last_enospc_agbno);
+			if (error)
+				goto out;
+		}
+	}
+
+out:
+	if (pag)
+		xfs_perag_rele(pag);
+	if (error == -ENOSPC)
+		return 0;
+	return error;
+}
+
+#ifdef CONFIG_XFS_RT
+STATIC int
+xfs_map_free_rt_extent(
+	struct xfs_inode	*ip,
+	xfs_rtxnum_t		*cursor,
+	xfs_rtxnum_t		end_rtx)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	xfs_off_t		endpos;
+	xfs_rtblock_t		rtbno;
+	xfs_rtxlen_t		len_rtx;
+	xfs_extlen_t		len;
+	int			error;
+
+	if (fatal_signal_pending(current))
+		return -EINTR;
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, 0, 0, false,
+			&tp);
+	if (error)
+		return error;
+
+	xfs_rtbitmap_lock(tp, mp);
+	error = xfs_rtalloc_find_freesp(tp, cursor, end_rtx, &len_rtx);
+	if (error)
+		goto out_cancel;
+
+	/*
+	 * If off_rtx is beyond the end of the rt device or is past what the
+	 * user asked for, bail out.
+	 */
+	if (*cursor >= end_rtx)
+		goto out_cancel;
+
+	len = xfs_rtx_to_rtb(mp, len_rtx);
+	error = xfs_map_free_reserve_more(tp, ip, &len);
+	if (error)
+		goto out_cancel;
+
+	rtbno = xfs_rtx_to_rtb(mp, *cursor);
+	error = xfs_bmapi_freesp(tp, ip, rtbno, len, &irec);
+	if (error)
+		goto out_cancel;
+
+	/* Update isize if needed. */
+	endpos = XFS_FSB_TO_B(mp, irec.br_startoff + irec.br_blockcount);
+	if (endpos > i_size_read(VFS_I(ip))) {
+		i_size_write(VFS_I(ip), endpos);
+		ip->i_disk_size = endpos;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	}
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	ASSERT(xfs_rtb_to_rtxoff(mp, irec.br_blockcount) == 0);
+	*cursor += xfs_rtb_to_rtx(mp, irec.br_blockcount);
+	return 0;
+out_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
+/*
+ * Allocate all free physical space between off and len and map it to this
+ * regular non-realtime file.
+ */
+int
+xfs_map_free_rt_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		off,
+	xfs_off_t		len)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_rtblock_t		off_rtb = XFS_B_TO_FSB(mp, off);
+	xfs_rtblock_t		end_rtb = XFS_B_TO_FSBT(mp, off + len);
+	xfs_rtxnum_t		off_rtx;
+	xfs_rtxnum_t		end_rtx;
+	int			error = 0;
+
+	/* Compute rt extents from the input parameters. */
+	off_rtx = xfs_rtb_to_rtxup(mp, off_rtb);
+	end_rtx = xfs_rtb_to_rtx(mp, end_rtb);
+
+	if (off_rtx >= mp->m_sb.sb_rextents)
+		return 0;
+	if (end_rtx >= mp->m_sb.sb_rextents)
+		end_rtx = mp->m_sb.sb_rextents - 1;
+
+	trace_xfs_map_free_rt_space(ip, off, len);
+
+	while (off_rtx < end_rtx) {
+		error = xfs_map_free_rt_extent(ip, &off_rtx, end_rtx);
+		if (error)
+			break;
+	}
+
+	if (error == -ENOSPC)
+		return 0;
+	return error;
+}
+#endif
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 231c4f1629c66..75d16202e2d34 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -61,6 +61,7 @@ int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
 int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 				xfs_off_t len);
+int	xfs_map_free_space(struct xfs_inode *ip, xfs_off_t off, xfs_off_t len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip, bool force);
@@ -79,8 +80,10 @@ int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
 #ifdef CONFIG_XFS_RT
 int xfs_convert_bigalloc_file_space(struct xfs_inode *ip, loff_t pos,
 		uint64_t len);
+int xfs_map_free_rt_space(struct xfs_inode *ip, xfs_off_t off, xfs_off_t len);
 #else
 # define xfs_convert_bigalloc_file_space(ip, pos, len)	(-EOPNOTSUPP)
+# define xfs_map_free_rt_space(ip, off, len)		(-EOPNOTSUPP)
 #endif
 
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 36ccec461e2a4..78e53e4eafa58 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1240,6 +1240,83 @@ xfs_file_fallocate(
 	return error;
 }
 
+int
+xfs_file_map_freesp(
+	struct file		*file,
+	const struct xfs_map_freesp *mf)
+{
+	struct inode		*inode = file_inode(file);
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_off_t		device_size;
+	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	loff_t			new_size = 0;
+	int			error;
+
+	xfs_ilock(ip, iolock);
+	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
+	if (error)
+		goto out_unlock;
+
+	/*
+	 * Must wait for all AIO to complete before we continue as AIO can
+	 * change the file size on completion without holding any locks we
+	 * currently hold. We must do this first because AIO can update both
+	 * the on disk and in memory inode sizes, and the operations that follow
+	 * require the in-memory size to be fully up-to-date.
+	 */
+	inode_dio_wait(inode);
+
+	error = file_modified(file);
+	if (error)
+		goto out_unlock;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		device_size = XFS_FSB_TO_B(mp, mp->m_sb.sb_rblocks);
+	else
+		device_size = XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks);
+
+	/*
+	 * Bail out now if we aren't allowed to make the file size the
+	 * same length as the device.
+	 */
+	if (device_size > i_size_read(inode)) {
+		new_size = device_size;
+		error = inode_newsize_ok(inode, new_size);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		error = xfs_map_free_rt_space(ip, mf->offset, mf->len);
+	else
+		error = xfs_map_free_space(ip, mf->offset, mf->len);
+	if (error) {
+		if (error == -ECANCELED)
+			error = 0;
+		goto out_unlock;
+	}
+
+	/* Change file size if needed */
+	if (new_size) {
+		struct iattr iattr;
+
+		iattr.ia_valid = ATTR_SIZE;
+		iattr.ia_size = new_size;
+		error = xfs_vn_setattr_size(file_mnt_idmap(file),
+					    file_dentry(file), &iattr);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (xfs_file_sync_writes(file))
+		error = xfs_log_force_inode(ip);
+
+out_unlock:
+	xfs_iunlock(ip, iolock);
+	return error;
+}
+
 STATIC int
 xfs_file_fadvise(
 	struct file	*file,
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
index 24490ea49e16c..41d8e17d29c18 100644
--- a/fs/xfs/xfs_file.h
+++ b/fs/xfs/xfs_file.h
@@ -15,4 +15,6 @@ bool xfs_is_falloc_aligned(struct xfs_inode *ip, loff_t pos,
 bool xfs_truncate_needs_cow_around(struct xfs_inode *ip, loff_t pos);
 int xfs_file_unshare_at(struct xfs_inode *ip, loff_t pos);
 
+int xfs_file_map_freesp(struct file *file, const struct xfs_map_freesp *mf);
+
 #endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 718cab5125883..ad289d37145e8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -48,6 +48,8 @@
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/fileattr.h>
+#include <linux/security.h>
+#include <linux/fsnotify.h>
 
 /*
  * xfs_find_handle maps from userspace xfs_fsop_handlereq structure to
@@ -2179,6 +2181,69 @@ xfs_ioc_exchange_range(
 	return error;
 }
 
+static int
+xfs_ioc_map_freesp(
+	struct file			*file,
+	struct xfs_map_freesp __user	*argp)
+{
+	struct xfs_map_freesp		args;
+	struct inode			*inode = file_inode(file);
+	int				error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&args, argp, sizeof(args)))
+		return -EFAULT;
+
+	if (args.flags || args.pad)
+		return -EINVAL;
+
+	if (args.offset < 0 || args.len <= 0)
+		return -EINVAL;
+
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+
+	/*
+	 * We can only allow pure fallocate on append only files
+	 */
+	if (IS_APPEND(inode))
+		return -EPERM;
+
+	if (IS_IMMUTABLE(inode))
+		return -EPERM;
+
+	/*
+	 * We cannot allow any fallocate operation on an active swapfile
+	 */
+	if (IS_SWAPFILE(inode))
+		return -ETXTBSY;
+
+	if (S_ISFIFO(inode->i_mode))
+		return -ESPIPE;
+
+	if (S_ISDIR(inode->i_mode))
+		return -EISDIR;
+
+	if (!S_ISREG(inode->i_mode))
+		return -ENODEV;
+
+	/* Check for wrap through zero too */
+	if (args.offset + args.len > inode->i_sb->s_maxbytes)
+		return -EFBIG;
+	if (args.offset + args.len < 0)
+		return -EFBIG;
+
+	file_start_write(file);
+	error = xfs_file_map_freesp(file, &args);
+	if (!error)
+		fsnotify_modify(file);
+
+	file_end_write(file);
+	return error;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -2474,6 +2539,9 @@ xfs_file_ioctl(
 	case XFS_IOC_EXCHANGE_RANGE:
 		return xfs_ioc_exchange_range(filp, arg);
 
+	case XFS_IOC_MAP_FREESP:
+		return xfs_ioc_map_freesp(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0af834897fad4..e59189e84943c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2134,3 +2134,55 @@ xfs_rtpick_extent(
 	*pick = b;
 	return 0;
 }
+
+/*
+ * Find the next free realtime extent starting at @rtx and going no higher than
+ * @end_rtx.  Set @rtx and @len_rtx to whatever free extents we find, or to
+ * @end_rtx if we find no space.
+ */
+int
+xfs_rtalloc_find_freesp(
+	struct xfs_trans	*tp,
+	xfs_rtxnum_t		*rtx,
+	xfs_rtxnum_t		end_rtx,
+	xfs_rtxlen_t		*len_rtx)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rtalloc_args	args = {
+		.mp		= mp,
+		.tp		= tp,
+	};
+	unsigned int		max_rt_extlen;
+	int			error;
+
+	trace_xfs_rtalloc_find_freesp(mp, *rtx, end_rtx - *rtx);
+
+	max_rt_extlen = xfs_rtb_to_rtx(mp, XFS_MAX_BMBT_EXTLEN);
+
+	while (*rtx < end_rtx) {
+		xfs_rtblock_t	range_end_rtx;
+		int		is_free = 0;
+
+		/* Is the first block in the range free? */
+		error = xfs_rtcheck_range(&args, *rtx, 1, 1, &range_end_rtx,
+				&is_free);
+		if (error)
+			return error;
+
+		/* Free or not, how many more rtx have the same status? */
+		error = xfs_rtfind_forw(&args, *rtx, end_rtx, &range_end_rtx);
+		if (error)
+			return error;
+
+		if (is_free) {
+			trace_xfs_rtalloc_find_freesp_done(mp, *rtx, *len_rtx);
+			*len_rtx = min_t(xfs_rtblock_t, max_rt_extlen,
+					 range_end_rtx - *rtx + 1);
+			return 0;
+		}
+
+		*rtx = range_end_rtx + 1;
+	}
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index a03796ea90eaf..aea99b44a66ee 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -86,8 +86,17 @@ int xfs_growfs_check_rtgeom(const struct xfs_mount *mp, xfs_rfsblock_t dblocks,
 		xfs_rfsblock_t rblocks, xfs_agblock_t rextsize,
 		xfs_rtblock_t rextents, xfs_extlen_t rbmblocks,
 		uint8_t rextslog);
+
+int xfs_rtalloc_find_freesp(struct xfs_trans *tp, xfs_rtxnum_t *rtx,
+		xfs_rtxnum_t end_rtx, xfs_rtxlen_t *len_rtx);
 #else
-# define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
+static inline int
+xfs_rtallocate_extent(struct xfs_trans *tp, xfs_rtxnum_t start,
+		xfs_rtxlen_t minlen, xfs_rtxlen_t maxlen, xfs_rtxlen_t *len,
+		int wasdel, xfs_rtxlen_t prod, xfs_rtxnum_t *rtblock)
+{
+	return -ENOSYS;
+}
 # define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
@@ -109,6 +118,7 @@ xfs_rtmount_init(
 # define xfs_rt_resv_init(mp)				(0)
 # define xfs_growfs_check_rtgeom(mp, d, r, rs, rx, rb, rl)	(0)
 # define xfs_rtmount_dqattach(mp)			(0)
+# define xfs_rtalloc_find_freesp(tp, rtx, end_rtx, len_rtx)	(-ENOSYS)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7b3abcabbafb6..db463d39649b9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1629,6 +1629,10 @@ DEFINE_SIMPLE_IO_EVENT(xfs_free_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_zero_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_collapse_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_insert_file_space);
+#ifdef CONFIG_XFS_RT
+DEFINE_SIMPLE_IO_EVENT(xfs_map_free_rt_space);
+#endif /* CONFIG_XFS_RT */
+DEFINE_SIMPLE_IO_EVENT(xfs_map_free_space);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
@@ -1718,6 +1722,31 @@ TRACE_EVENT(xfs_bunmap,
 
 );
 
+TRACE_EVENT(xfs_bmapi_freesp,
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_extlen_t len),
+	TP_ARGS(ip, bno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_fsize_t, size)
+		__field(xfs_fileoff_t, bno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->size = ip->i_disk_size;
+		__entry->bno = bno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d ino 0x%llx disize 0x%llx fileoff 0x%llx fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->size,
+		  __entry->bno,
+		  __entry->len)
+);
+
 DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len),
@@ -1750,6 +1779,8 @@ DEFINE_BUSY_EVENT(xfs_extent_busy_enomem);
 DEFINE_BUSY_EVENT(xfs_extent_busy_force);
 DEFINE_BUSY_EVENT(xfs_extent_busy_reuse);
 DEFINE_BUSY_EVENT(xfs_extent_busy_clear);
+DEFINE_BUSY_EVENT(xfs_alloc_find_freesp);
+DEFINE_BUSY_EVENT(xfs_alloc_find_freesp_done);
 
 TRACE_EVENT(xfs_extent_busy_trim,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -1781,6 +1812,35 @@ TRACE_EVENT(xfs_extent_busy_trim,
 		  __entry->tlen)
 );
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xfs_rtextent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t off_rtx,
+		 xfs_rtxnum_t len_rtx),
+	TP_ARGS(mp, off_rtx, len_rtx),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rtxnum_t, off_rtx)
+		__field(xfs_rtxnum_t, len_rtx)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->off_rtx = off_rtx;
+		__entry->len_rtx = len_rtx;
+	),
+	TP_printk("dev %d:%d rtx 0x%llx rtxcount 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->off_rtx,
+		  __entry->len_rtx)
+);
+#define DEFINE_RTEXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_rtextent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_rtxnum_t off_rtx, \
+		 xfs_rtxnum_t len_rtx), \
+	TP_ARGS(mp, off_rtx, len_rtx))
+DEFINE_RTEXTENT_EVENT(xfs_rtalloc_find_freesp);
+DEFINE_RTEXTENT_EVENT(xfs_rtalloc_find_freesp_done);
+#endif /* CONFIG_XFS_RT */
+
 DECLARE_EVENT_CLASS(xfs_agf_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_agf *agf, int flags,
 		 unsigned long caller_ip),
@@ -3783,6 +3843,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
 DEFINE_EVENT(xfs_inode_irec_class, name, \
 	TP_PROTO(struct xfs_inode *ip, struct xfs_bmbt_irec *irec), \
 	TP_ARGS(ip, irec))
+DEFINE_INODE_IREC_EVENT(xfs_bmapi_freesp_done);
 
 /* inode iomap invalidation events */
 DECLARE_EVENT_CLASS(xfs_wb_invalid_class,
@@ -3917,6 +3978,7 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_src);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
+DEFINE_INODE_ERROR_EVENT(xfs_map_free_reserve_more_fail);
 
 /* dedupe tracepoints */
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);

