Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBFBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiLaCBi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCBf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:01:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217A02AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:01:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2701B81DED
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58390C433D2;
        Sat, 31 Dec 2022 02:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452091;
        bh=Nhg9XnIxbRcOazeLPGim7QUcEXhTxz6E+QMjsiPw1Pk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MIYt3MoY+nPrjZ8YgZTVMS2DG2vwv3Vd5aMIA1BE9jInMLtOHaTe/QvgKfyZ1tIGs
         H8deF2ouwWm1PqxZVlV2hTa6aJUeTLqUsmIcj9V11UpSywgavm9qKcd4FdypVpvQ23
         7LdDmZcF+/Wv77EAdUj3W8siQgScv/SyqhVcpUNCeO68IBlGw6Spti0KWAKkXKqHjF
         1RuIY7m3uNu6aVnpVwdrcnVk9Vmzxk7gBeOigd6UsmnqVqrbftNCJVczAYz5uCGWFB
         X8EPOiCkSSiS17tmzKfstWETBfZBfdyc+vndIJfYzsvdsTbFrMMJWk1vArrlLNLfJ7
         fxcUIL9jX70Lg==
Subject: [PATCH 1/3] xfs: fix chown with rt quota
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:42 -0800
Message-ID: <167243872241.719004.9109959626867199625.stgit@magnolia>
In-Reply-To: <167243872224.719004.160021889997830176.stgit@magnolia>
References: <167243872224.719004.160021889997830176.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make chown's quota adjustments work with realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c    |   44 +++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_trans.c |   31 +++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 63085d8b5ec1..7a69857c4e49 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1214,8 +1214,8 @@ xfs_qm_dqusage_adjust(
 	void			*data)
 {
 	struct xfs_inode	*ip;
-	xfs_qcnt_t		nblks;
-	xfs_filblks_t		rtblks = 0;	/* total rt blks */
+	xfs_filblks_t		nblks, rtblks;
+	unsigned int		lock_mode;
 	int			error;
 
 	ASSERT(XFS_IS_QUOTA_ON(mp));
@@ -1239,17 +1239,16 @@ xfs_qm_dqusage_adjust(
 
 	ASSERT(ip->i_delayed_blks == 0);
 
+	lock_mode = xfs_ilock_data_map_shared(ip);
 	if (XFS_IS_REALTIME_INODE(ip)) {
-		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
-
 		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
-		if (error)
+		if (error) {
+			xfs_iunlock(ip, lock_mode);
 			goto error0;
-
-		xfs_bmap_count_leaves(ifp, &rtblks);
+		}
 	}
-
-	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
+	xfs_inode_count_blocks(tp, ip, &nblks, &rtblks);
+	xfs_iunlock(ip, lock_mode);
 
 	/*
 	 * Add the (disk blocks and inode) resources occupied by this
@@ -1870,9 +1869,8 @@ xfs_qm_vop_chown(
 	struct xfs_dquot	*newdq)
 {
 	struct xfs_dquot	*prevdq;
-	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
-				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
-
+	xfs_filblks_t		dblocks, rblocks;
+	bool			isrt = XFS_IS_REALTIME_INODE(ip);
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_ON(ip->i_mount));
@@ -1882,11 +1880,17 @@ xfs_qm_vop_chown(
 	ASSERT(prevdq);
 	ASSERT(prevdq != newdq);
 
-	xfs_trans_mod_ino_dquot(tp, ip, prevdq, bfield, -(ip->i_nblocks));
+	xfs_inode_count_blocks(tp, ip, &dblocks, &rblocks);
+
+	xfs_trans_mod_ino_dquot(tp, ip, prevdq, XFS_TRANS_DQ_BCOUNT,
+			-(xfs_qcnt_t)dblocks);
+	xfs_trans_mod_ino_dquot(tp, ip, prevdq, XFS_TRANS_DQ_RTBCOUNT,
+			-(xfs_qcnt_t)rblocks);
 	xfs_trans_mod_ino_dquot(tp, ip, prevdq, XFS_TRANS_DQ_ICOUNT, -1);
 
 	/* the sparkling new dquot */
-	xfs_trans_mod_ino_dquot(tp, ip, newdq, bfield, ip->i_nblocks);
+	xfs_trans_mod_ino_dquot(tp, ip, newdq, XFS_TRANS_DQ_BCOUNT, dblocks);
+	xfs_trans_mod_ino_dquot(tp, ip, newdq, XFS_TRANS_DQ_RTBCOUNT, rblocks);
 	xfs_trans_mod_ino_dquot(tp, ip, newdq, XFS_TRANS_DQ_ICOUNT, 1);
 
 	/*
@@ -1896,7 +1900,8 @@ xfs_qm_vop_chown(
 	 * (having already bumped up the real counter) so that we don't have
 	 * any reservation to give back when we commit.
 	 */
-	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
+	xfs_trans_mod_dquot(tp, newdq,
+			isrt ? XFS_TRANS_DQ_RES_RTBLKS : XFS_TRANS_DQ_RES_BLKS,
 			-ip->i_delayed_blks);
 
 	/*
@@ -1908,8 +1913,13 @@ xfs_qm_vop_chown(
 	 */
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	xfs_dqlock(prevdq);
-	ASSERT(prevdq->q_blk.reserved >= ip->i_delayed_blks);
-	prevdq->q_blk.reserved -= ip->i_delayed_blks;
+	if (isrt) {
+		ASSERT(prevdq->q_rtb.reserved >= ip->i_delayed_blks);
+		prevdq->q_rtb.reserved -= ip->i_delayed_blks;
+	} else {
+		ASSERT(prevdq->q_blk.reserved >= ip->i_delayed_blks);
+		prevdq->q_blk.reserved -= ip->i_delayed_blks;
+	}
 	xfs_dqunlock(prevdq);
 
 	/*
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 05e93af190df..fd389a8582fd 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1446,11 +1446,26 @@ xfs_trans_alloc_ichange(
 	gdqp = (new_gdqp != ip->i_gdquot) ? new_gdqp : NULL;
 	pdqp = (new_pdqp != ip->i_pdquot) ? new_pdqp : NULL;
 	if (udqp || gdqp || pdqp) {
+		xfs_filblks_t	dblocks, rblocks;
 		unsigned int	qflags = XFS_QMOPT_RES_REGBLKS;
+		bool		isrt = XFS_IS_REALTIME_INODE(ip);
 
 		if (force)
 			qflags |= XFS_QMOPT_FORCE_RES;
 
+		if (isrt) {
+			error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
+			if (error)
+				goto out_cancel;
+		}
+
+		xfs_inode_count_blocks(tp, ip, &dblocks, &rblocks);
+
+		if (isrt)
+			rblocks += ip->i_delayed_blks;
+		else
+			dblocks += ip->i_delayed_blks;
+
 		/*
 		 * Reserve enough quota to handle blocks on disk and reserved
 		 * for a delayed allocation.  We'll actually transfer the
@@ -1458,8 +1473,20 @@ xfs_trans_alloc_ichange(
 		 * though that part is only semi-transactional.
 		 */
 		error = xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp,
-				pdqp, ip->i_nblocks + ip->i_delayed_blks,
-				1, qflags);
+				pdqp, dblocks, 1, qflags);
+		if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
+			xfs_trans_cancel(tp);
+			xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);
+			retried = true;
+			goto retry;
+		}
+		if (error)
+			goto out_cancel;
+
+		/* Do the same for realtime. */
+		qflags = XFS_QMOPT_RES_RTBLKS | (qflags & XFS_QMOPT_FORCE_RES);
+		error = xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp,
+				pdqp, rblocks, 0, qflags);
 		if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
 			xfs_trans_cancel(tp);
 			xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);

