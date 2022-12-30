Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD05C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiLaD2M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236392AbiLaD2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:28:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFE0164AE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:28:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D198612E3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ACDC433D2;
        Sat, 31 Dec 2022 03:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457289;
        bh=1xG7rFoQUX+jObBqWqF54F/24K9Vh9XnBq65HWDcTsU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=muIUzvRRF0k02kGGnLBSRBhFikulwXhLCwShzDNckKGOSPduhwKvrU0aOuZCH5cgJ
         QOfaNnERZWhb1WFkfGH78NvQNXotRuOvncMob821C7TGFiE/L+aE+0/l8seLaqJrt0
         N6TPUIfH7COb8+3zuQSZTz3wRImp6NsLR6Zvq1HlBlaWh8zH5PouKLHflNlbi/FLY9
         RozS/k224fG87wGfOrCSLfOr7CG5EB5w9eARxM39W706wjEaQ29h8LwbYpvOzGe2dB
         wT7LecBSO62+7DCRFchPnJxzvLT2/IgaoN+9cHHZi7xV8aCMeo8uLxv37CfWs0E3zU
         wVyr7LY/vK67w==
Subject: [PATCH 1/5] xfs: fallocate free space into a file
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:47 -0800
Message-ID: <167243884778.740087.18075037866302425342.stgit@magnolia>
In-Reply-To: <167243884763.740087.13414287212519500865.stgit@magnolia>
References: <167243884763.740087.13414287212519500865.stgit@magnolia>
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
 include/xfs_trace.h  |    4 +
 libxfs/libxfs_priv.h |   10 +++
 libxfs/xfs_alloc.c   |   88 ++++++++++++++++++++++++++++++
 libxfs/xfs_alloc.h   |    4 +
 libxfs/xfs_bmap.c    |  149 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h    |    3 +
 6 files changed, 258 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 3b305e4d16a..aa000fad856 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -26,6 +26,8 @@
 #define trace_xfs_alloc_exact_done(a)		((void) 0)
 #define trace_xfs_alloc_exact_notfound(a)	((void) 0)
 #define trace_xfs_alloc_exact_error(a)		((void) 0)
+#define trace_xfs_alloc_find_freesp(...)	((void) 0)
+#define trace_xfs_alloc_find_freesp_done(...)	((void) 0)
 #define trace_xfs_alloc_near_first(a)		((void) 0)
 #define trace_xfs_alloc_near_greater(a)		((void) 0)
 #define trace_xfs_alloc_near_lesser(a)		((void) 0)
@@ -189,6 +191,8 @@
 
 #define trace_xfs_bmap_pre_update(a,b,c,d)	((void) 0)
 #define trace_xfs_bmap_post_update(a,b,c,d)	((void) 0)
+#define trace_xfs_bmapi_freesp(...)		((void) 0)
+#define trace_xfs_bmapi_freesp_done(...)	((void) 0)
 #define trace_xfs_bunmap(a,b,c,d,e)		((void) 0)
 #define trace_xfs_read_extent(a,b,c,d)		((void) 0)
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index b5b956dea11..fa8ddd5b1aa 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -502,6 +502,16 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_filestream_lookup_ag(ip)		(0)
 #define xfs_filestream_new_ag(ip,ag)		(0)
 
+struct xfs_trans;
+
+static inline int
+xfs_rtallocate_extent(struct xfs_trans *tp, xfs_rtblock_t bno,
+		xfs_extlen_t minlen, xfs_extlen_t maxlen, xfs_extlen_t *len,
+		int wasdel, xfs_extlen_t prod, xfs_rtblock_t *rtblock)
+{
+	return -EOPNOTSUPP;
+}
+
 #define xfs_trans_inode_buf(tp, bp)		((void) 0)
 
 /* quota bits */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 43b63462374..6099054046a 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3701,3 +3701,91 @@ xfs_extfree_intent_destroy_cache(void)
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
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index cd7b26568a3..327c66f5578 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -268,4 +268,8 @@ extern struct kmem_cache	*xfs_extfree_item_cache;
 int __init xfs_extfree_intent_init_cache(void);
 void xfs_extfree_intent_destroy_cache(void);
 
+int xfs_alloc_find_freesp(struct xfs_trans *tp, struct xfs_perag *pag,
+		xfs_agblock_t *agbno, xfs_agblock_t end_agbno,
+		xfs_extlen_t *len);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index b8fe093f0f3..b0f19bae120 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6479,3 +6479,152 @@ xfs_get_cowextsz_hint(
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
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 05097b1d5c7..ef20a625762 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
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

