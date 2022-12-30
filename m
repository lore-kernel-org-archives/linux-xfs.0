Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD26C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiLaDY4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236427AbiLaDYt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:24:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D80E812A80
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:24:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6502B61D64
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB429C433D2;
        Sat, 31 Dec 2022 03:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457086;
        bh=q/9Xw2yus2AxMeGe8LX0SY6GBEDz0ZmA3LTKiK9g7Tg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OGR9zyj8xO7U/zrFF1AxX/8uCYByHi+6HWT6xfXXvYWD+/zksFe9ZE2GnVL1mSKao
         mxr8gUuFoWHSxzzAUqp3SyA0FFBQpR5BmjrJmLnNmgywaZlCwRT4cyPj0pMgtm99bN
         AemJvkY0QYG0D35GRSJ8chI1d/v9vA22RATrHZ+vW1psxUt3ofE6kt5vAmqOBYgG8R
         4sibpjobtmuzE1lCQKhMCCzDMjoYX7yENdOKYuKByiDh6JfUKkMmTk0zmjR4eZIA0t
         oHaSWZQqEZRW10/PcEiCW9Dq9aEble5tj2efq7HelvQY2HE12i9PTK0t/SHBIsDqb5
         s+/8IoquWg/2Q==
Subject: [PATCH 2/2] xfs: fallocate free space into a file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:30 -0800
Message-ID: <167243877036.727784.2555609124571979086.stgit@magnolia>
In-Reply-To: <167243877005.727784.16278955284134985550.stgit@magnolia>
References: <167243877005.727784.16278955284134985550.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add a new fallocate mode to map free physical space into a file, at the
same file offset as if the file were a sparse image of the physical
device backing the filesystem.  The intent here is to use this to
prototype a free space defragmentation tool.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/open.c                   |    5 +
 fs/xfs/libxfs/xfs_alloc.c   |   88 ++++++++++++
 fs/xfs/libxfs/xfs_alloc.h   |    4 +
 fs/xfs/libxfs/xfs_bmap.c    |  150 +++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h    |    3 
 fs/xfs/xfs_bmap_util.c      |  307 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h      |    7 +
 fs/xfs/xfs_file.c           |   37 +++++
 fs/xfs/xfs_rtalloc.c        |   49 +++++++
 fs/xfs/xfs_rtalloc.h        |   12 ++
 fs/xfs/xfs_trace.h          |   62 +++++++++
 include/linux/falloc.h      |    3 
 include/uapi/linux/falloc.h |    8 +
 13 files changed, 732 insertions(+), 3 deletions(-)


diff --git a/fs/open.c b/fs/open.c
index 82c1a28b3308..d9ae216c7f75 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -277,6 +277,11 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	    (mode & ~(FALLOC_FL_UNSHARE_RANGE | FALLOC_FL_KEEP_SIZE)))
 		return -EINVAL;
 
+	/* Mapping free space should only be used by itself. */
+	if ((mode & FALLOC_FL_MAP_FREE_SPACE) &&
+	    (mode & ~FALLOC_FL_MAP_FREE_SPACE))
+		return -EINVAL;
+
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5d091789ff74..2e37212ad163 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3705,3 +3705,91 @@ xfs_extfree_intent_destroy_cache(void)
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
index cd7b26568a33..327c66f55780 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -268,4 +268,8 @@ extern struct kmem_cache	*xfs_extfree_item_cache;
 int __init xfs_extfree_intent_init_cache(void);
 void xfs_extfree_intent_destroy_cache(void);
 
+int xfs_alloc_find_freesp(struct xfs_trans *tp, struct xfs_perag *pag,
+		xfs_agblock_t *agbno, xfs_agblock_t end_agbno,
+		xfs_extlen_t *len);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 053d72063999..73a9a586b05d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -39,6 +39,7 @@
 #include "xfs_health.h"
 #include "xfs_symlink_remote.h"
 #include "xfs_inode_util.h"
+#include "xfs_rtalloc.h"
 
 struct kmem_cache		*xfs_bmap_intent_cache;
 
@@ -6485,3 +6486,152 @@ xfs_get_cowextsz_hint(
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
+		rtx_in = xfs_rtb_to_rtx(mp, fsbno, &mod);
+		if (mod) {
+			ASSERT(mod == 0);
+			return -EFSCORRUPTED;
+		}
+
+		rtxlen_in = xfs_rtb_to_rtx(mp, len, &mod);
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
+			 * We were promised the space!  In theory the aren't
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
+			.mp = ip->i_mount,
+			.type = XFS_ALLOCTYPE_THIS_BNO,
+			.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE,
+			.resv = XFS_AG_RESV_NONE,
+			.prod = 1,
+			.datatype = XFS_ALLOC_USERDATA,
+			.tp = tp,
+			.maxlen = len,
+			.minlen = 1,
+			.fsbno = fsbno,
+		};
+		error = xfs_alloc_vextent(&args);
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
index 05097b1d5c7d..ef20a625762d 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -193,6 +193,9 @@ int	xfs_bmapi_read(struct xfs_inode *ip, xfs_fileoff_t bno,
 int	xfs_bmapi_write(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t len, uint32_t flags,
 		xfs_extlen_t total, struct xfs_bmbt_irec *mval, int *nmap);
+int	xfs_bmapi_freesp(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fsblock_t fsbno, xfs_extlen_t len,
+		struct xfs_bmbt_irec *mval);
 int	__xfs_bunmapi(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t bno, xfs_filblks_t *rlen, uint32_t flags,
 		xfs_extnum_t nexts);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 8515190d2bc6..6b2ad693ecc6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -30,6 +30,13 @@
 #include "xfs_reflink.h"
 #include "xfs_swapext.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
+#include "xfs_health.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_ag.h"
+#include "xfs_rtbitmap.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -1274,3 +1281,303 @@ xfs_insert_file_space(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
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
+	error = xfs_alloc_find_freesp(tp, pag, cursor, end_agbno, &len);
+	if (error)
+		goto out_cancel;
+
+	/* Bail out if the cursor is beyond what we asked for. */
+	if (*cursor >= end_agbno)
+		goto out_cancel;
+
+	error = xfs_map_free_reserve_more(tp, ip, &len);
+	if (error)
+		goto out_cancel;
+
+	fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, *cursor);
+	do {
+		error = xfs_bmapi_freesp(tp, ip, fsbno, len, &irec);
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
+		 * reservation limits...
+		 */
+		len >>= 1;
+	} while (len > 0);
+	if (error == -ENOSPC && *last_enospc_agbno != *cursor) {
+		/*
+		 * ...but even that might not work if an AGFL fixup allocated
+		 * the block at *cursor.  The first time this happens, remember
+		 * that we ran out of space here, and try again.
+		 */
+		*last_enospc_agbno = *cursor;
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
+		xfs_perag_put(pag);
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
+	xfs_rtxnum_t		add;
+	xfs_rtxlen_t		len_rtx;
+	xfs_extlen_t		len;
+	uint32_t		mod;
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
+	add = xfs_rtb_to_rtx(mp, irec.br_blockcount, &mod);
+	if (mod)
+		return -EFSCORRUPTED;
+
+	*cursor += add;
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
+	uint32_t		mod;
+	int			error = 0;
+
+	/* Compute rt extents from the input parameters. */
+	off_rtx = xfs_rtb_to_rtx(mp, off_rtb, &mod);
+	if (mod)
+		off_rtx++;
+	end_rtx = xfs_rtb_to_rtxt(mp, end_rtb);
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
index 8eb7166aa9d4..4e11f0def12b 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -76,4 +76,11 @@ int xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_flush_unmap_range(struct xfs_inode *ip, xfs_off_t offset,
 			      xfs_off_t len);
 
+int xfs_map_free_space(struct xfs_inode *ip, xfs_off_t off, xfs_off_t len);
+#ifdef CONFIG_XFS_RT
+int xfs_map_free_rt_space(struct xfs_inode *ip, xfs_off_t off, xfs_off_t len);
+#else
+# define xfs_map_free_rt_space(ip, off, len)	(-EOPNOTSUPP)
+#endif
+
 #endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 449146f9af41..ec90900eeacd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -960,7 +960,8 @@ static inline bool xfs_file_sync_writes(struct file *filp)
 #define	XFS_FALLOC_FL_SUPPORTED						\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
 		 FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE |	\
-		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE)
+		 FALLOC_FL_INSERT_RANGE | FALLOC_FL_UNSHARE_RANGE |	\
+		 FALLOC_FL_MAP_FREE_SPACE)
 
 STATIC long
 xfs_file_fallocate(
@@ -1075,6 +1076,40 @@ xfs_file_fallocate(
 			goto out_unlock;
 		}
 		do_file_insert = true;
+	} else if (mode & FALLOC_FL_MAP_FREE_SPACE) {
+		struct xfs_mount	*mp = ip->i_mount;
+		xfs_off_t		device_size;
+
+		if (!capable(CAP_SYS_ADMIN)) {
+			error = -EPERM;
+			goto out_unlock;
+		}
+
+		if (XFS_IS_REALTIME_INODE(ip))
+			device_size = XFS_FSB_TO_B(mp, mp->m_sb.sb_rblocks);
+		else
+			device_size = XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks);
+
+		/*
+		 * Bail out now if we aren't allowed to make the file size the
+		 * same length as the device.
+		 */
+		if (device_size > i_size_read(inode)) {
+			new_size = device_size;
+			error = inode_newsize_ok(inode, new_size);
+			if (error)
+				goto out_unlock;
+		}
+
+		if (XFS_IS_REALTIME_INODE(ip))
+			error = xfs_map_free_rt_space(ip, offset, len);
+		else
+			error = xfs_map_free_space(ip, offset, len);
+		if (error) {
+			if (error == -ECANCELED)
+				error = 0;
+			goto out_unlock;
+		}
 	} else {
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4165899cdc96..ca78b274cf57 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -2290,3 +2290,52 @@ xfs_rtfile_convert_unwritten(
 	xfs_trans_cancel(tp);
 	return ret;
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
+	unsigned int		max_rt_extlen;
+	int			error;
+
+	trace_xfs_rtalloc_find_freesp(mp, *rtx, end_rtx - *rtx);
+
+	max_rt_extlen = xfs_rtb_to_rtxt(mp, XFS_MAX_BMBT_EXTLEN);
+
+	while (*rtx < end_rtx) {
+		xfs_rtblock_t	range_end_rtx;
+		int		is_free = 0;
+
+		/* Is the first block in the range free? */
+		error = xfs_rtcheck_range(mp, tp, *rtx, 1, 1, &range_end_rtx,
+				&is_free);
+		if (error)
+			return error;
+
+		/* Free or not, how many more rtx have the same status? */
+		error = xfs_rtfind_forw(mp, tp, *rtx, end_rtx,
+				&range_end_rtx);
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
index 35737a09cdb9..3189e3b42012 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -89,8 +89,17 @@ int xfs_growfs_check_rtgeom(const struct xfs_mount *mp, xfs_rfsblock_t dblocks,
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
@@ -113,6 +122,7 @@ xfs_rtmount_init(
 # define xfs_rt_resv_init(mp)				(0)
 # define xfs_rtmount_dqattach(mp)			(0)
 # define xfs_growfs_check_rtgeom(mp, d, r, rs, rx, rb, rl)	(0)
+# define xfs_rtalloc_find_freesp(tp, rtx, end_rtx, len_rtx)	(-ENOSYS)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8a7d08228586..f6130b85d305 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1610,6 +1610,10 @@ DEFINE_SIMPLE_IO_EVENT(xfs_free_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_zero_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_collapse_file_space);
 DEFINE_SIMPLE_IO_EVENT(xfs_insert_file_space);
+#ifdef CONFIG_XFS_RT
+DEFINE_SIMPLE_IO_EVENT(xfs_map_free_rt_space);
+#endif /* CONFIG_XFS_RT */
+DEFINE_SIMPLE_IO_EVENT(xfs_map_free_space);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
@@ -1699,6 +1703,31 @@ TRACE_EVENT(xfs_bunmap,
 
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
@@ -1731,6 +1760,8 @@ DEFINE_BUSY_EVENT(xfs_extent_busy_enomem);
 DEFINE_BUSY_EVENT(xfs_extent_busy_force);
 DEFINE_BUSY_EVENT(xfs_extent_busy_reuse);
 DEFINE_BUSY_EVENT(xfs_extent_busy_clear);
+DEFINE_BUSY_EVENT(xfs_alloc_find_freesp);
+DEFINE_BUSY_EVENT(xfs_alloc_find_freesp_done);
 
 TRACE_EVENT(xfs_extent_busy_trim,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -1762,6 +1793,35 @@ TRACE_EVENT(xfs_extent_busy_trim,
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
@@ -3744,6 +3804,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
 DEFINE_EVENT(xfs_inode_irec_class, name, \
 	TP_PROTO(struct xfs_inode *ip, struct xfs_bmbt_irec *irec), \
 	TP_ARGS(ip, irec))
+DEFINE_INODE_IREC_EVENT(xfs_bmapi_freesp_done);
 
 /* inode iomap invalidation events */
 DECLARE_EVENT_CLASS(xfs_wb_invalid_class,
@@ -3878,6 +3939,7 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_src);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
+DEFINE_INODE_ERROR_EVENT(xfs_map_free_reserve_more_fail);
 
 /* dedupe tracepoints */
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index f3f0b97b1675..b47aae9e487a 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -30,7 +30,8 @@ struct space_resv {
 					 FALLOC_FL_COLLAPSE_RANGE |	\
 					 FALLOC_FL_ZERO_RANGE |		\
 					 FALLOC_FL_INSERT_RANGE |	\
-					 FALLOC_FL_UNSHARE_RANGE)
+					 FALLOC_FL_UNSHARE_RANGE |	\
+					 FALLOC_FL_MAP_FREE_SPACE)
 
 /* on ia32 l_start is on a 32-bit boundary */
 #if defined(CONFIG_X86_64)
diff --git a/include/uapi/linux/falloc.h b/include/uapi/linux/falloc.h
index 51398fa57f6c..89bfbb02bc16 100644
--- a/include/uapi/linux/falloc.h
+++ b/include/uapi/linux/falloc.h
@@ -2,6 +2,14 @@
 #ifndef _UAPI_FALLOC_H_
 #define _UAPI_FALLOC_H_
 
+/*
+ * FALLOC_FL_MAP_FREE_SPACE maps all the free physical space in the
+ * filesystem into the file at the same offsets.  This flag requires
+ * CAP_SYS_ADMIN, and cannot be used with any other flags.  It probably
+ * only works on filesystems that are backed by physical media.
+ */
+#define FALLOC_FL_MAP_FREE_SPACE	(1U << 30)
+
 #define FALLOC_FL_KEEP_SIZE	0x01 /* default is extend size */
 #define FALLOC_FL_PUNCH_HOLE	0x02 /* de-allocates range */
 #define FALLOC_FL_NO_HIDE_STALE	0x04 /* reserved codepoint */

