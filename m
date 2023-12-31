Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBCABA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZBi1fo3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99AFCC433C7;
	Sun, 31 Dec 2023 20:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054489;
	bh=YdwjWS/Y3RVXH+xMVDTCED0y3Pb2rKTMzxo/jGxoS6Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZBi1fo3VClYyBhyLV10vhO2PfSXDwmb0UEINM7ouGCdAyShLmowgPppLFwmXQ1Y7j
	 DUafes+BKx31kDyHjWQgtyBZ64O2S96LhNK0T0EnLbeUha4j3b0+chOXwEWyGUh55v
	 iPLFbNE/I3ZyIw604aOJ0ZW8JF3DEYBBs1TDBHn1+CDLwL9p02Jobj0Liry69ZsuJ9
	 yMEHXtWVGBxeipXSuhYxwcyK0k/eX3W/ehYSXBTFtDLmioxLoZB//xj+sj7zht3HsO
	 ZA0DLLa5An2nSjjLxiQqUMsCLgQtgWxmuwfQ333EiXbFYZ9C9s1fqCNZeFW9tNV7he
	 ZIseT+tEYJ1GQ==
Date: Sun, 31 Dec 2023 12:28:09 -0800
Subject: [PATCH 15/25] xfs: port xfs_swap_extents_rmap to our new code
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404833382.1750288.15498760912612963151.stgit@frogsfrogsfrogs>
In-Reply-To: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
References: <170404833081.1750288.16964477956002067164.stgit@frogsfrogsfrogs>
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

The inner loop of xfs_swap_extents_rmap does the same work as
xfs_swapext_finish_one, so adapt it to use that.  Doing so has the side
benefit that the older code path no longer wastes its time remapping
shared extents.

This forms the basis of the non-atomic swaprange implementation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |  151 +++++-------------------------------------------
 fs/xfs/xfs_trace.h     |    5 --
 2 files changed, 16 insertions(+), 140 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 87ac9777c1eaf..8ca681d78bbcb 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1354,138 +1354,6 @@ xfs_swap_extent_flush(
 	return 0;
 }
 
-/*
- * Move extents from one file to another, when rmap is enabled.
- */
-STATIC int
-xfs_swap_extent_rmap(
-	struct xfs_trans		**tpp,
-	struct xfs_inode		*ip,
-	struct xfs_inode		*tip)
-{
-	struct xfs_trans		*tp = *tpp;
-	struct xfs_bmbt_irec		irec;
-	struct xfs_bmbt_irec		uirec;
-	struct xfs_bmbt_irec		tirec;
-	xfs_fileoff_t			offset_fsb;
-	xfs_fileoff_t			end_fsb;
-	xfs_filblks_t			count_fsb;
-	int				error;
-	xfs_filblks_t			ilen;
-	xfs_filblks_t			rlen;
-	int				nimaps;
-	uint64_t			tip_flags2;
-
-	/*
-	 * If the source file has shared blocks, we must flag the donor
-	 * file as having shared blocks so that we get the shared-block
-	 * rmap functions when we go to fix up the rmaps.  The flags
-	 * will be switch for reals later.
-	 */
-	tip_flags2 = tip->i_diflags2;
-	if (ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
-		tip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
-
-	offset_fsb = 0;
-	end_fsb = XFS_B_TO_FSB(ip->i_mount, i_size_read(VFS_I(ip)));
-	count_fsb = (xfs_filblks_t)(end_fsb - offset_fsb);
-
-	while (count_fsb) {
-		/* Read extent from the donor file */
-		nimaps = 1;
-		error = xfs_bmapi_read(tip, offset_fsb, count_fsb, &tirec,
-				&nimaps, 0);
-		if (error)
-			goto out;
-		ASSERT(nimaps == 1);
-		ASSERT(tirec.br_startblock != DELAYSTARTBLOCK);
-
-		trace_xfs_swap_extent_rmap_remap(tip, &tirec);
-		ilen = tirec.br_blockcount;
-
-		/* Unmap the old blocks in the source file. */
-		while (tirec.br_blockcount) {
-			ASSERT(tp->t_highest_agno == NULLAGNUMBER);
-			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
-
-			/* Read extent from the source file */
-			nimaps = 1;
-			error = xfs_bmapi_read(ip, tirec.br_startoff,
-					tirec.br_blockcount, &irec,
-					&nimaps, 0);
-			if (error)
-				goto out;
-			ASSERT(nimaps == 1);
-			ASSERT(tirec.br_startoff == irec.br_startoff);
-			trace_xfs_swap_extent_rmap_remap_piece(ip, &irec);
-
-			/* Trim the extent. */
-			uirec = tirec;
-			uirec.br_blockcount = rlen = min_t(xfs_filblks_t,
-					tirec.br_blockcount,
-					irec.br_blockcount);
-			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
-
-			if (xfs_bmap_is_real_extent(&uirec)) {
-				error = xfs_iext_count_may_overflow(ip,
-						XFS_DATA_FORK,
-						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
-				if (error)
-					goto out;
-			}
-
-			if (xfs_bmap_is_real_extent(&irec)) {
-				error = xfs_iext_count_may_overflow(tip,
-						XFS_DATA_FORK,
-						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
-				if (error)
-					goto out;
-			}
-
-			/* Remove the mapping from the donor file. */
-			xfs_bmap_unmap_extent(tp, tip, XFS_DATA_FORK, &uirec);
-
-			/* Remove the mapping from the source file. */
-			xfs_bmap_unmap_extent(tp, ip, XFS_DATA_FORK, &irec);
-
-			/* Map the donor file's blocks into the source file. */
-			xfs_bmap_map_extent(tp, ip, XFS_DATA_FORK, &uirec);
-
-			/* Map the source file's blocks into the donor file. */
-			xfs_bmap_map_extent(tp, tip, XFS_DATA_FORK, &irec);
-
-			error = xfs_defer_finish(tpp);
-			tp = *tpp;
-			if (error)
-				goto out;
-
-			tirec.br_startoff += rlen;
-			if (tirec.br_startblock != HOLESTARTBLOCK &&
-			    tirec.br_startblock != DELAYSTARTBLOCK)
-				tirec.br_startblock += rlen;
-			tirec.br_blockcount -= rlen;
-		}
-
-		/* Roll on... */
-		count_fsb -= ilen;
-		offset_fsb += ilen;
-	}
-
-	tip->i_diflags2 = tip_flags2;
-	return 0;
-
-out:
-	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
-	tip->i_diflags2 = tip_flags2;
-	return error;
-}
-
 /* Swap the extents of two files by swapping data forks. */
 STATIC int
 xfs_swap_extent_forks(
@@ -1772,13 +1640,24 @@ xfs_swap_extents(
 	src_log_flags = XFS_ILOG_CORE;
 	target_log_flags = XFS_ILOG_CORE;
 
-	if (xfs_has_rmapbt(mp))
-		error = xfs_swap_extent_rmap(&tp, ip, tip);
-	else
+	if (xfs_has_rmapbt(mp)) {
+		struct xfs_swapext_req	req = {
+			.ip1		= tip,
+			.ip2		= ip,
+			.whichfork	= XFS_DATA_FORK,
+			.blockcount	= XFS_B_TO_FSB(ip->i_mount,
+						       i_size_read(VFS_I(ip))),
+		};
+
+		xfs_swapext(tp, &req);
+		error = xfs_defer_finish(&tp);
+	} else
 		error = xfs_swap_extent_forks(tp, ip, tip, &src_log_flags,
 				&target_log_flags);
-	if (error)
+	if (error) {
+		trace_xfs_swap_extent_error(ip, error, _THIS_IP_);
 		goto out_trans_cancel;
+	}
 
 	/* Do we have to swap reflink flags? */
 	if ((ip->i_diflags2 & XFS_DIFLAG2_REFLINK) ^
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 53a6122d307ff..47c30d8093289 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3746,13 +3746,10 @@ DEFINE_INODE_ERROR_EVENT(xfs_reflink_end_cow_error);
 
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cancel_cow);
 
-/* rmap swapext tracepoints */
-DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap);
-DEFINE_INODE_IREC_EVENT(xfs_swap_extent_rmap_remap_piece);
-DEFINE_INODE_ERROR_EVENT(xfs_swap_extent_rmap_error);
 
 /* swapext tracepoints */
 DEFINE_INODE_ERROR_EVENT(xfs_file_xchg_range_error);
+DEFINE_INODE_ERROR_EVENT(xfs_swap_extent_error);
 DEFINE_INODE_IREC_EVENT(xfs_swapext_extent1_skip);
 DEFINE_INODE_IREC_EVENT(xfs_swapext_extent1);
 DEFINE_INODE_IREC_EVENT(xfs_swapext_extent2);

