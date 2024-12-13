Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290EB186607
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 08:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734078544; cv=none; b=rxMgR9jgJSvkUnuoOKgCApbwnzj23HTeKpfpKPzuA7VQmmCTKbMxKAK+yvrtYApQ7d9WiTdsPFMUyTwPSj5girHcHn9H/v4oxVkp9WuQpln8fEtYZk7dqRLvJM0ruk0LHXhNTW/vyiNS2zzNbLlY6VfVm+47EhREAlwgZirb6A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734078544; c=relaxed/simple;
	bh=ZPP+oZJHPo3f8pI8fAYqfME0sQig6rD5+09JbvAX8fY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i5AJh6QLHOEWj3y9n0lptfij+1zZVnxTGPgmIZSF5IKalVYBAlevish/MrBRTJP+5pLqUGGK8BqkeOknSaCkax9h67aLJ6sDCmHGI6CeprQcvI+thPK9/sCvRnEfni5Q/y2EX5y4ftSB6+kmCchgCV7GxYYEUtwpxREqsTUYmjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TCaJ0Lzk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TCaJ0Lzk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TMrqTEDjIdOoO7jbW34z+JV3vLGEXn36Ufc0tYjoyFg=; b=TCaJ0LzkZ64W9YVw8CzpH48zvi
	kYRYzWc95380esZb68SCIAUfvGdPLOJTMTY5ZwH3HOZQPkTnMtMLCuAVpD2m829NDpeI7p4FOW+f4
	T9dBlRRyMw4tuTcVPkojdqt7J4HlSYXX8d5zhRgESre9hbK3Jh6BrqDU9iZXinB9yld5CgS4u/qgF
	b5isTA9jk/Ob4573MDyg3aod4swOAZsGvUQfX2JuJc76hAMLuu/Kr5biWxF0ATVf3DKq/X+8R0edD
	Ce2PgD2aJg0e0W0G+wEdouzfDRac0Jz0lXkHvFhMRo+1wwtuUhlT0yi0BnxBGFFRYWQSvSovTU3SA
	E1NoghwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM12j-000000035SW-2ZH3;
	Fri, 13 Dec 2024 08:29:01 +0000
Date: Fri, 13 Dec 2024 00:29:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/37] xfs: react to fsdax failure notifications on the
 rt device
Message-ID: <Z1vwTZm_EqCJmwp0@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123935.1181370.7404101961471776856.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123935.1181370.7404101961471776856.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:09:59PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have reverse mapping for the realtime device, use the
> information to kill processes that have mappings to bad pmem.

This actually duplicates a lot of the code due to not taking advantage
of the xfs_group structure.  Something like the patch below unifies
the code more which also obsoletes some of the work from the previous
patch:

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 96d39e475d5a..ae5b9890e511 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -27,12 +27,6 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 
-enum xfs_failed_device {
-	XFS_FAILED_DATADEV,
-	XFS_FAILED_LOGDEV,
-	XFS_FAILED_RTDEV,
-};
-
 struct xfs_failure_info {
 	xfs_agblock_t		startblock;
 	xfs_extlen_t		blockcount;
@@ -163,126 +157,81 @@ xfs_dax_notify_failure_thaw(
 }
 
 static int
-xfs_dax_notify_ddev_failure(
-	struct xfs_mount	*mp,
-	xfs_daddr_t		daddr,
-	xfs_daddr_t		bblen,
-	int			mf_flags)
+xfs_dax_translate_range(
+	struct xfs_buftarg	*btp,
+	u64			offset,
+	u64			len,
+	xfs_daddr_t		*daddr,
+	uint64_t		*bblen)
 {
-	struct xfs_failure_info	notify = { .mf_flags = mf_flags };
-	struct xfs_trans	*tp = NULL;
-	struct xfs_btree_cur	*cur = NULL;
-	struct xfs_buf		*agf_bp = NULL;
-	int			error = 0;
-	bool			kernel_frozen = false;
-	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, daddr);
-	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
-	xfs_fsblock_t		end_fsbno = XFS_DADDR_TO_FSB(mp,
-							     daddr + bblen - 1);
-	xfs_agnumber_t		end_agno = XFS_FSB_TO_AGNO(mp, end_fsbno);
-
-	if (mf_flags & MF_MEM_PRE_REMOVE) {
-		xfs_info(mp, "Device is about to be removed!");
-		/*
-		 * Freeze fs to prevent new mappings from being created.
-		 * - Keep going on if others already hold the kernel forzen.
-		 * - Keep going on if other errors too because this device is
-		 *   starting to fail.
-		 * - If kernel frozen state is hold successfully here, thaw it
-		 *   here as well at the end.
-		 */
-		kernel_frozen = xfs_dax_notify_failure_freeze(mp) == 0;
-	}
-
-	error = xfs_trans_alloc_empty(mp, &tp);
-	if (error)
-		goto out;
-
-	for (; agno <= end_agno; agno++) {
-		struct xfs_rmap_irec	ri_low = { };
-		struct xfs_rmap_irec	ri_high;
-		struct xfs_agf		*agf;
-		struct xfs_perag	*pag;
-		xfs_agblock_t		range_agend;
-
-		pag = xfs_perag_get(mp, agno);
-		error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
-		if (error) {
-			xfs_perag_put(pag);
-			break;
-		}
-
-		cur = xfs_rmapbt_init_cursor(mp, tp, agf_bp, pag);
-
-		/*
-		 * Set the rmap range from ri_low to ri_high, which represents
-		 * a [start, end] where we looking for the files or metadata.
-		 */
-		memset(&ri_high, 0xFF, sizeof(ri_high));
-		ri_low.rm_startblock = XFS_FSB_TO_AGBNO(mp, fsbno);
-		if (agno == end_agno)
-			ri_high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsbno);
-
-		agf = agf_bp->b_addr;
-		range_agend = min(be32_to_cpu(agf->agf_length) - 1,
-				ri_high.rm_startblock);
-		notify.startblock = ri_low.rm_startblock;
-		notify.blockcount = range_agend + 1 - ri_low.rm_startblock;
+	u64			dev_start = btp->bt_dax_part_off;
+	u64			dev_len = bdev_nr_bytes(btp->bt_bdev);
+	u64			dev_end = dev_start + dev_len - 1;
 
-		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
-				xfs_dax_failure_fn, &notify);
-		xfs_btree_del_cursor(cur, error);
-		xfs_trans_brelse(tp, agf_bp);
-		xfs_perag_put(pag);
-		if (error)
-			break;
-
-		fsbno = XFS_AGB_TO_FSB(mp, agno + 1, 0);
+	/* Notify failure on the whole device. */
+	if (offset == 0 && len == U64_MAX) {
+		offset = dev_start;
+		len = dev_len;
 	}
 
-	xfs_trans_cancel(tp);
+	/* Ignore the range out of filesystem area */
+	if (offset + len - 1 < dev_start)
+		return -ENXIO;
+	if (offset > dev_end)
+		return -ENXIO;
 
-	/*
-	 * Shutdown fs from a force umount in pre-remove case which won't fail,
-	 * so errors can be ignored.  Otherwise, shutdown the filesystem with
-	 * CORRUPT flag if error occured or notify.want_shutdown was set during
-	 * RMAP querying.
-	 */
-	if (mf_flags & MF_MEM_PRE_REMOVE)
-		xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
-	else if (error || notify.want_shutdown) {
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_ONDISK);
-		if (!error)
-			error = -EFSCORRUPTED;
+	/* Calculate the real range when it touches the boundary */
+	if (offset > dev_start)
+		offset -= dev_start;
+	else {
+		len -= dev_start - offset;
+		offset = 0;
 	}
+	if (offset + len - 1 > dev_end)
+		len = dev_end - offset + 1;
 
-out:
-	/* Thaw the fs if it has been frozen before. */
-	if (mf_flags & MF_MEM_PRE_REMOVE)
-		xfs_dax_notify_failure_thaw(mp, kernel_frozen);
-
-	return error;
+	*daddr = BTOBB(offset);
+	*bblen = BTOBB(len);
+	return 0;
 }
 
-#ifdef CONFIG_XFS_RT
 static int
-xfs_dax_notify_rtdev_failure(
+xfs_dax_notify_dev_failure(
 	struct xfs_mount	*mp,
-	xfs_daddr_t		daddr,
-	xfs_daddr_t		bblen,
-	int			mf_flags)
+	u64			offset,
+	u64			len,
+	int			mf_flags,
+	enum xfs_group_type	type)
 {
 	struct xfs_failure_info	notify = { .mf_flags = mf_flags };
 	struct xfs_trans	*tp = NULL;
 	struct xfs_btree_cur	*cur = NULL;
 	int			error = 0;
 	bool			kernel_frozen = false;
-	xfs_rtblock_t		rtbno = xfs_daddr_to_rtb(mp, daddr);
-	xfs_rtblock_t		end_rtbno = xfs_daddr_to_rtb(mp,
-							     daddr + bblen - 1);
-	xfs_rgnumber_t		rgno = xfs_rtb_to_rgno(mp, rtbno);
-	xfs_rgnumber_t		end_rgno = xfs_rtb_to_rgno(mp, end_rtbno);
-	xfs_rgblock_t		start_rgbno = xfs_rtb_to_rgbno(mp, rtbno);
+	uint32_t		start_gno, end_gno;
+	xfs_fsblock_t		start_bno, end_bno;
+	xfs_daddr_t		daddr;
+	uint64_t		bblen;
+	struct xfs_group	*xg;
+
+	if (!xfs_has_rmapbt(mp)) {
+		xfs_debug(mp, "notify_failure() needs rmapbt enabled!");
+		return -EOPNOTSUPP;
+	}
+
+	error = xfs_dax_translate_range(type == XG_TYPE_RTG ?
+			mp->m_rtdev_targp : mp->m_ddev_targp,
+			offset, len, &start_bno, &end_bno);
+	if (error)
+		return error;
+
+	if (type == XG_TYPE_RTG) {
+		start_bno = xfs_daddr_to_rtb(mp, daddr);
+		end_bno = xfs_daddr_to_rtb(mp, daddr + bblen - 1);
+	} else {
+		start_bno = XFS_DADDR_TO_FSB(mp, daddr);
+		end_bno = XFS_DADDR_TO_FSB(mp, daddr + bblen - 1);
+	}
 
 	if (mf_flags & MF_MEM_PRE_REMOVE) {
 		xfs_info(mp, "Device is about to be removed!");
@@ -301,43 +250,58 @@ xfs_dax_notify_rtdev_failure(
 	if (error)
 		goto out;
 
-	for (; rgno <= end_rgno; rgno++) {
-		struct xfs_rmap_irec	ri_low = {
-			.rm_startblock	= start_rgbno,
-		};
+	start_gno = xfs_fsb_to_gno(mp, start_bno, type);
+	end_gno = xfs_fsb_to_gno(mp, end_bno, type);
+	while ((xg = xfs_group_next_range(mp, xg, start_gno, end_gno, type))) {
+		struct xfs_buf		*agf_bp = NULL;
+		struct xfs_rtgroup	*rtg = NULL;
+		struct xfs_rmap_irec	ri_low = { };
 		struct xfs_rmap_irec	ri_high;
-		struct xfs_rtgroup	*rtg;
-		xfs_rgblock_t		range_rgend;
 
-		rtg = xfs_rtgroup_get(mp, rgno);
-		if (!rtg)
-			break;
+		if (type == XG_TYPE_AG) {
+			struct xfs_perag	*pag = to_perag(xg);
+
+			error = xfs_alloc_read_agf(pag, tp, 0, &agf_bp);
+			if (error) {
+				xfs_perag_put(pag);
+				break;
+			}
 
-		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
-		cur = xfs_rtrmapbt_init_cursor(tp, rtg);
+			cur = xfs_rmapbt_init_cursor(mp, tp, agf_bp, pag);
+		} else {
+			rtg = to_rtg(xg);
+			xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+			cur = xfs_rtrmapbt_init_cursor(tp, rtg);
+		}
 
 		/*
 		 * Set the rmap range from ri_low to ri_high, which represents
 		 * a [start, end] where we looking for the files or metadata.
 		 */
 		memset(&ri_high, 0xFF, sizeof(ri_high));
-		if (rgno == end_rgno)
-			ri_high.rm_startblock = xfs_rtb_to_rgbno(mp, end_rtbno);
+		if (xg->xg_gno == start_gno)
+			ri_low.rm_startblock =
+				xfs_fsb_to_gbno(mp, start_bno, type);
+		if (xg->xg_gno == end_gno)
+			ri_high.rm_startblock =
+				xfs_fsb_to_gbno(mp, end_bno, type);
 
-		range_rgend = min(rtg->rtg_group.xg_block_count - 1,
-				ri_high.rm_startblock);
 		notify.startblock = ri_low.rm_startblock;
-		notify.blockcount = range_rgend + 1 - ri_low.rm_startblock;
+		notify.blockcount = min(xg->xg_block_count,
+					ri_high.rm_startblock + 1) -
+					ri_low.rm_startblock;
 
 		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
 				xfs_dax_failure_fn, &notify);
 		xfs_btree_del_cursor(cur, error);
-		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
-		xfs_rtgroup_put(rtg);
-		if (error)
+		if (agf_bp)
+			xfs_trans_brelse(tp, agf_bp);
+		if (rtg)
+			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_RMAP);
+		if (error) {
+			xfs_group_put(xg);
 			break;
-
-		start_rgbno = 0;
+		}
 	}
 
 	xfs_trans_cancel(tp);
@@ -363,65 +327,6 @@ xfs_dax_notify_rtdev_failure(
 
 	return error;
 }
-#else
-# define xfs_dax_notify_rtdev_failure(...)	(-ENOSYS)
-#endif
-
-static int
-xfs_dax_translate_range(
-	struct xfs_mount	*mp,
-	struct dax_device	*dax_dev,
-	u64			offset,
-	u64			len,
-	enum xfs_failed_device	*fdev,
-	xfs_daddr_t		*daddr,
-	uint64_t		*bbcount)
-{
-	struct xfs_buftarg	*btp;
-	u64			ddev_start;
-	u64			ddev_end;
-
-	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) {
-		*fdev = XFS_FAILED_RTDEV;
-		btp = mp->m_rtdev_targp;
-	} else if (mp->m_logdev_targp != mp->m_ddev_targp &&
-		   mp->m_logdev_targp->bt_daxdev == dax_dev) {
-		*fdev = XFS_FAILED_LOGDEV;
-		btp = mp->m_logdev_targp;
-	} else {
-		*fdev = XFS_FAILED_DATADEV;
-		btp = mp->m_ddev_targp;
-	}
-
-	ddev_start = btp->bt_dax_part_off;
-	ddev_end = ddev_start + bdev_nr_bytes(btp->bt_bdev) - 1;
-
-	/* Notify failure on the whole device. */
-	if (offset == 0 && len == U64_MAX) {
-		offset = ddev_start;
-		len = bdev_nr_bytes(btp->bt_bdev);
-	}
-
-	/* Ignore the range out of filesystem area */
-	if (offset + len - 1 < ddev_start)
-		return -ENXIO;
-	if (offset > ddev_end)
-		return -ENXIO;
-
-	/* Calculate the real range when it touches the boundary */
-	if (offset > ddev_start)
-		offset -= ddev_start;
-	else {
-		len -= ddev_start - offset;
-		offset = 0;
-	}
-	if (offset + len - 1 > ddev_end)
-		len = ddev_end - offset + 1;
-
-	*daddr = BTOBB(offset);
-	*bbcount = BTOBB(len);
-	return 0;
-}
 
 static int
 xfs_dax_notify_failure(
@@ -431,22 +336,14 @@ xfs_dax_notify_failure(
 	int			mf_flags)
 {
 	struct xfs_mount	*mp = dax_holder(dax_dev);
-	enum xfs_failed_device	fdev;
-	xfs_daddr_t		daddr;
-	uint64_t		bbcount;
-	int			error;
 
 	if (!(mp->m_super->s_flags & SB_BORN)) {
 		xfs_warn(mp, "filesystem is not ready for notify_failure()!");
 		return -EIO;
 	}
 
-	error = xfs_dax_translate_range(mp, dax_dev, offset, len, &fdev,
-			&daddr, &bbcount);
-	if (error)
-		return error;
-
-	if (fdev == XFS_FAILED_LOGDEV) {
+	if (mp->m_logdev_targp != mp->m_ddev_targp &&
+	    mp->m_logdev_targp->bt_daxdev == dax_dev) {
 		/*
 		 * In the pre-remove case the failure notification is attempting
 		 * to trigger a force unmount.  The expectation is that the
@@ -460,15 +357,9 @@ xfs_dax_notify_failure(
 		return -EFSCORRUPTED;
 	}
 
-	if (!xfs_has_rmapbt(mp)) {
-		xfs_debug(mp, "notify_failure() needs rmapbt enabled!");
-		return -EOPNOTSUPP;
-	}
-
-	if (fdev == XFS_FAILED_RTDEV)
-		return xfs_dax_notify_rtdev_failure(mp, daddr, bbcount,
-				mf_flags);
-	return xfs_dax_notify_ddev_failure(mp, daddr, bbcount, mf_flags);
+	return xfs_dax_notify_dev_failure(mp, offset, len, mf_flags,
+		(mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) ?
+				XG_TYPE_RTG : XG_TYPE_AG);
 }
 
 const struct dax_holder_operations xfs_dax_holder_operations = {
