Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE9D13FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688316; cv=none; b=GLV1h24z8xVvE36ke8qrP9nCA1FpBaeuyAyqIJiEAKB2jxva8gUeT0nXiTiYHMbnHZs1xvKZuduY3pFO3nVYsfwESbC18RQEh5phcoGcBYqnNJ5D4ZM/h45e3vSmDPvyXSHtE6T96OFQESEeQ7/3GAiT7IzD+OFj10o4Rgyrc2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688316; c=relaxed/simple;
	bh=f1LSdOf2k5INgZr3CvP8U+Rs+5Tii23dw/73eMXMqa8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=odUHa7QcobNLNi3yzHXuX9rw2neTYVj4+MzlxFHHfpujORLv3umTR3W8LeXPaqCOU1F4ym3U7ajMZ8FowsEh+syfrtzFMP6bWxMwNP19Ee4uyz5PdByPbmk0rLLXEpWMKR7TeUtTtWw1fEqg6FAmjyEGKm9/+oJ3RsfBhAeT7Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QPJunkyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QPJunkyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29672C4CED2;
	Tue, 31 Dec 2024 23:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688316;
	bh=f1LSdOf2k5INgZr3CvP8U+Rs+5Tii23dw/73eMXMqa8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QPJunkyrLcyLt4iD5/B4KEFAzBbKSp1xy8UI7IYJDzFedwHCj+Nz02VTUSnlWFT1j
	 ILy6IBRy+cFq2Z4jKznPLEyGl8O/fkZjMK/XcnKi6Z7UKyuETVKnia5ocf+TUysOhs
	 HNQ5x0LiwA2nNBMPErM1DsP388QYUccjopfJzda4gdHMrIUOh11FJ27t196I693/dQ
	 sWYXvKbClgeJW+xqyFFGy4RZ1houOrC0Ah9PuB5d/t4ZdRTyvHro+yCbIf35FaNh1N
	 J547PhnnIQ5wBUmz5Q/DuhR7X8KVODx0h7MW8IkSVjmK9brlDUPn7J/bdty6HkN0FR
	 N6ekwekDlwslQ==
Date: Tue, 31 Dec 2024 15:38:35 -0800
Subject: [PATCH 3/4] xfs: add an ioctl to map free space into a file
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754266.2704719.15632107218632778714.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754204.2704719.1892779733633851572.stgit@frogsfrogsfrogs>
References: <173568754204.2704719.1892779733633851572.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   88 +++++++++++++
 fs/xfs/libxfs/xfs_alloc.h |    3 
 fs/xfs/libxfs/xfs_bmap.c  |    1 
 fs/xfs/libxfs/xfs_fs.h    |   14 ++
 fs/xfs/xfs_bmap_util.c    |  303 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h    |    1 
 fs/xfs/xfs_file.c         |  139 +++++++++++++++++++++
 fs/xfs/xfs_file.h         |    2 
 fs/xfs/xfs_ioctl.c        |    5 +
 fs/xfs/xfs_trace.h        |   35 +++++
 10 files changed, 591 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3d33e17f2e5ce0..e689ec5cbccd7e 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -4168,3 +4168,91 @@ xfs_extfree_intent_destroy_cache(void)
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
+	struct xfs_mount	*mp = pag_mount(pag);
+	struct xfs_btree_cur	*cur;
+	struct xfs_buf		*agf_bp = NULL;
+	xfs_agblock_t		found_agbno;
+	xfs_extlen_t		found_len;
+	int			found;
+	int			error;
+
+	trace_xfs_alloc_find_freesp(pag_group(pag), *agbno,
+			end_agbno - *agbno);
+
+	error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+	if (error)
+		return error;
+
+	cur = xfs_bnobt_init_cursor(mp, tp, agf_bp, pag);
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
+	trace_xfs_alloc_find_freesp_done(pag_group(pag), found_agbno,
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
index 50ef79a1ed41a1..069077d9ad2f8c 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -286,5 +286,8 @@ void xfs_extfree_intent_destroy_cache(void);
 
 xfs_failaddr_t xfs_validate_ag_length(struct xfs_buf *bp, uint32_t seqno,
 		uint32_t length);
+int xfs_alloc_find_freesp(struct xfs_trans *tp, struct xfs_perag *pag,
+		xfs_agblock_t *agbno, xfs_agblock_t end_agbno,
+		xfs_extlen_t *len);
 
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8c9d540c3ba91a..11dab550ca0fb6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -41,6 +41,7 @@
 #include "xfs_inode_util.h"
 #include "xfs_rtgroup.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_rtalloc.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 936f719236944f..f4128dbdf3b9a2 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -1087,6 +1087,19 @@ xfs_getfsrefs_advance(
 /* fcr_flags values - returned for each non-header segment */
 #define FCR_OF_LAST		(1U << 0) /* last record in the dataset */
 
+/* map free space to file */
+
+/*
+ * XFS_IOC_MAP_FREESP maps all the free physical space in the filesystem into
+ * the file at the same offsets.  This ioctl requires CAP_SYS_ADMIN.
+ */
+struct xfs_map_freesp {
+	__s64	offset;		/* disk address to map, in bytes */
+	__s64	len;		/* length in bytes */
+	__u64	flags;		/* must be zero */
+	__u64	pad;		/* must be zero */
+};
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1127,6 +1140,7 @@ xfs_getfsrefs_advance(
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
 #define XFS_IOC_GETFSREFCOUNTS	_IOWR('X', 66, struct xfs_getfsrefs_head)
+#define XFS_IOC_MAP_FREESP	_IOW ('X', 67, struct xfs_map_freesp)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c9e60fb2693c9b..8d5c2072bcd533 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -31,6 +31,10 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_health.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_ag.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1916,3 +1920,302 @@ xfs_convert_rtbigalloc_file_space(
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
+STATIC int
+xfs_map_free_ag_extent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	struct xfs_bmbt_irec	*mval)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_alloc_arg	args = {
+		.mp		= mp,
+		.tp		= tp,
+		.pag		= pag,
+		.oinfo		= XFS_RMAP_OINFO_SKIP_UPDATE,
+		.resv		= XFS_AG_RESV_NONE,
+		.prod		= 1,
+		.datatype	= XFS_ALLOC_USERDATA,
+		.maxlen		= len,
+		.minlen		= 1,
+	};
+	struct xfs_bmbt_irec	irec;
+	xfs_fsblock_t		fsbno = xfs_gbno_to_fsb(pag_group(pag), agbno);
+	xfs_fileoff_t		startoff = xfs_fsblock_to_fileoff(mp, fsbno);
+	int			nimaps;
+	int			error;
+
+	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+
+	trace_xfs_map_free_ag_extent(ip, fsbno, len);
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
+	error = xfs_iext_count_extend(tp, ip, XFS_DATA_FORK,
+			XFS_IEXT_ADD_NOSPLIT_CNT);
+	if (error)
+		return error;
+
+	/*
+	 * Allocate the physical extent.  We should not have dropped the lock
+	 * since the scan of the free space metadata, so this should work,
+	 * though the length may be adjusted to play nicely with metadata space
+	 * reservations.
+	 */
+	error = xfs_alloc_vextent_exact_bno(&args, fsbno);
+	if (error)
+		return error;
+	if (args.fsbno == NULLFSBLOCK) {
+		/*
+		 * We were promised the space, but failed to get it.  This
+		 * could be because the space is reserved for metadata
+		 * expansion, or it could be because the AGFL fixup grabbed the
+		 * first block we wanted.  Either way, if the transaction is
+		 * dirty we must commit it and tell the caller to try again.
+		 */
+		if (tp->t_flags & XFS_TRANS_DIRTY)
+			return -EAGAIN;
+		return -ENOSPC;
+	}
+	if (args.fsbno != fsbno) {
+		ASSERT(0);
+		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
+		return -EFSCORRUPTED;
+	}
+
+	/* Map extent into file, update quota. */
+	mval->br_blockcount = args.len;
+	mval->br_startblock = fsbno;
+	mval->br_startoff = startoff;
+	mval->br_state = XFS_EXT_UNWRITTEN;
+
+	trace_xfs_map_free_ag_extent_done(ip, mval);
+
+	xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, mval);
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
+			mval->br_blockcount);
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
+	loff_t			endpos;
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
+	map_len = free_len;
+	do {
+		error = xfs_map_free_ag_extent(tp, ip, pag, *cursor, map_len,
+				&irec);
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
+	int			error = 0;
+
+	trace_xfs_map_free_space(ip, off, len);
+
+	while ((pag = xfs_perag_next_range(mp, pag, off_agno,
+					   mp->m_sb.sb_agcount - 1))) {
+		xfs_agblock_t	off_agbno = 0;
+		xfs_agblock_t	end_agbno;
+		xfs_agblock_t	last_enospc_agbno = NULLAGBLOCK;
+
+		end_agbno = xfs_ag_block_count(mp, pag_agno(pag));
+
+		if (pag_agno(pag) == off_agno)
+			off_agbno = XFS_FSB_TO_AGBNO(mp, off_fsb);
+		if (pag_agno(pag) == end_agno)
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
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index c39cce66829e26..5d84b702b16326 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -63,6 +63,7 @@ int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
 		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
 		xfs_off_t len);
+int	xfs_map_free_space(struct xfs_inode *ip, xfs_off_t off, xfs_off_t len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index b8f0b9a2998b9c..8bf1e96ab57a5b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -34,6 +34,7 @@
 #include <linux/mman.h>
 #include <linux/fadvise.h>
 #include <linux/mount.h>
+#include <linux/fsnotify.h>
 
 static const struct vm_operations_struct xfs_file_vm_ops;
 
@@ -1548,6 +1549,144 @@ xfs_file_fallocate(
 	return error;
 }
 
+STATIC int
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
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		error = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+	device_size = XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks);
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
+	error = xfs_map_free_space(ip, mf->offset, mf->len);
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
+long
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
 STATIC int
 xfs_file_fadvise(
 	struct file	*file,
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
index 24490ea49e16c6..c9d50699baba85 100644
--- a/fs/xfs/xfs_file.h
+++ b/fs/xfs/xfs_file.h
@@ -15,4 +15,6 @@ bool xfs_is_falloc_aligned(struct xfs_inode *ip, loff_t pos,
 bool xfs_truncate_needs_cow_around(struct xfs_inode *ip, loff_t pos);
 int xfs_file_unshare_at(struct xfs_inode *ip, loff_t pos);
 
+long xfs_ioc_map_freesp(struct file *file, struct xfs_map_freesp __user	*argp);
+
 #endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 20f013bd4ce653..092a3699ff9e75 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -45,6 +45,8 @@
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
+#include <linux/security.h>
+#include <linux/fsnotify.h>
 
 /* Return 0 on success or positive error */
 int
@@ -1429,6 +1431,9 @@ xfs_file_ioctl(
 	case XFS_IOC_COMMIT_RANGE:
 		return xfs_ioc_commit_range(filp, arg);
 
+	case XFS_IOC_MAP_FREESP:
+		return xfs_ioc_map_freesp(filp, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e81247b3024e53..ebbc832db8fa1e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1732,6 +1732,7 @@ DEFINE_SIMPLE_IO_EVENT(xfs_free_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_zero_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_collapse_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_insert_file_space);
+DEFINE_SIMPLE_IO_EVENT(xfs_map_free_space);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
@@ -1821,6 +1822,36 @@ TRACE_EVENT(xfs_bunmap,
 
 );
 
+DECLARE_EVENT_CLASS(xfs_map_free_extent_class,
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
+#define DEFINE_MAP_FREE_EXTENT_EVENT(name) \
+DEFINE_EVENT(xfs_map_free_extent_class, name, \
+	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t bno, xfs_extlen_t len), \
+	TP_ARGS(ip, bno, len))
+DEFINE_MAP_FREE_EXTENT_EVENT(xfs_map_free_ag_extent);
+
 DECLARE_EVENT_CLASS(xfs_extent_busy_class,
 	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
 		 xfs_extlen_t len),
@@ -1856,6 +1887,8 @@ DEFINE_BUSY_EVENT(xfs_extent_busy);
 DEFINE_BUSY_EVENT(xfs_extent_busy_force);
 DEFINE_BUSY_EVENT(xfs_extent_busy_reuse);
 DEFINE_BUSY_EVENT(xfs_extent_busy_clear);
+DEFINE_BUSY_EVENT(xfs_alloc_find_freesp);
+DEFINE_BUSY_EVENT(xfs_alloc_find_freesp_done);
 
 TRACE_EVENT(xfs_extent_busy_trim,
 	TP_PROTO(const struct xfs_group *xg, xfs_agblock_t agbno,
@@ -3962,6 +3995,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
 DEFINE_EVENT(xfs_inode_irec_class, name, \
 	TP_PROTO(struct xfs_inode *ip, struct xfs_bmbt_irec *irec), \
 	TP_ARGS(ip, irec))
+DEFINE_INODE_IREC_EVENT(xfs_map_free_ag_extent_done);
 
 /* inode iomap invalidation events */
 DECLARE_EVENT_CLASS(xfs_wb_invalid_class,
@@ -4096,6 +4130,7 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_src);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
+DEFINE_INODE_ERROR_EVENT(xfs_map_free_reserve_more_fail);
 
 /* dedupe tracepoints */
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);

