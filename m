Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C707F20D51E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846403; cv=none; b=hXQcRfyPw2P4h4MjGKpsxdjIQ5KjKrdvjsgVC8xV7uFDJhwaf6xfVllkYUnGs6aE82Qm3FlSMlk8WrO1KYeyQ4p7CUMpbUxUB92WkemFbQmgV4YAxw/pdISCF4qrqr+Z2+rYSx2CMORW6omjbeYbQD9UTgyhU5vWI36cAPMLwQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846403; c=relaxed/simple;
	bh=MuVt0g2/DTHoiVaud7kOp0RIW7jHbo/hJf8g0oFWEbM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aeT62NYUQS26pJceP6xAUyLmMCHvzy/vPua0X99luDxpqxQ2pzmuTALlf4ikfQzRGS7eHjdGzApgCXxwhslszlbyTS/JqBEVm946dztkAgoKMdLIk70nFYuWUSWsmDs2Gae7n8VgH4a/pCsnZ3P3Msk731MSXWwUG4bZjwNbXxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kg0wTatu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kg0wTatu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D50BC4CECF;
	Tue,  5 Nov 2024 22:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846403;
	bh=MuVt0g2/DTHoiVaud7kOp0RIW7jHbo/hJf8g0oFWEbM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Kg0wTatuWMM4VOJ4TdqHuhD8xClfY9VBSsuZDTjTAL48gyCD3PUykhAIPkYAYnoOl
	 KZTxlZbmwNbNKmO3NIKLyaWinIj8RRZxz1ybdGw/nZUkIziiRQ986NYOH8ZlL2FGUA
	 VLVgHszrDxYhPBaGtAOyCcKAIGYDdKIxPT6JvJmZzmR1Uu3WbvZygQabY6BdLFlgzj
	 Wtri5PusSvwepDy+PSFPIA7qlrCAzoCnOoPPfuQGGirm4akhRGUIM9RxUtHWl7kCo+
	 Vp389Lpa+RkeSapgs/byrkVVXvsfuEsMwDtEU79FxHUtHq46R4hlLWfmwUXJXI1IXN
	 sCZFY8Rua0SQA==
Date: Tue, 05 Nov 2024 14:40:03 -0800
Subject: [PATCH 1/6] xfs: fix chown with rt quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399580.1873230.12328173862811234009.stgit@frogsfrogsfrogs>
In-Reply-To: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
References: <173084399548.1873230.14221538780736772304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make chown's quota adjustments work with realtime files.  This is mostly
a matter of calling xfs_inode_count_blocks on a given file to figure out
the number of blocks allocated to the data device and to the realtime
device, and using those quantities to update the quota accounting when
the id changes.  Delayed allocation reservations are moved from the old
dquot's incore reservation to the new dquot's incore reservation.

Note that there was a missing ILOCK bug in xfs_qm_dqusage_adjust that we
must fix before calling xfs_iread_extents.  Prior to 2.6.37 the locking
was correct, but then someone removed the ILOCK as part of a cleanup.
Nobody noticed because nowhere in the git history have we ever supported
rt+quota so nobody can use this.

I'm leaving git breadcrumbs in case anyone is desperate enough to try to
backport the rtquota code to old kernels.

Not-Cc: <stable@vger.kernel.org> # v2.6.37
Fixes: 52fda114249578 ("xfs: simplify xfs_qm_dqusage_adjust")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_qm.c    |   44 +++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_trans.c |   31 +++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d9d09195eabb0d..1c7d861dfbeceb 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1351,8 +1351,8 @@ xfs_qm_dqusage_adjust(
 	void			*data)
 {
 	struct xfs_inode	*ip;
-	xfs_qcnt_t		nblks;
-	xfs_filblks_t		rtblks = 0;	/* total rt blks */
+	xfs_filblks_t		nblks, rtblks;
+	unsigned int		lock_mode;
 	int			error;
 
 	ASSERT(XFS_IS_QUOTA_ON(mp));
@@ -1393,18 +1393,17 @@ xfs_qm_dqusage_adjust(
 
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
 	xfs_iflags_clear(ip, XFS_IQUOTAUNCHECKED);
+	xfs_iunlock(ip, lock_mode);
 
 	/*
 	 * Add the (disk blocks and inode) resources occupied by this
@@ -2043,9 +2042,8 @@ xfs_qm_vop_chown(
 	struct xfs_dquot	*newdq)
 {
 	struct xfs_dquot	*prevdq;
-	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
-				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
-
+	xfs_filblks_t		dblocks, rblocks;
+	bool			isrt = XFS_IS_REALTIME_INODE(ip);
 
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(XFS_IS_QUOTA_ON(ip->i_mount));
@@ -2056,11 +2054,17 @@ xfs_qm_vop_chown(
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
@@ -2070,7 +2074,8 @@ xfs_qm_vop_chown(
 	 * (having already bumped up the real counter) so that we don't have
 	 * any reservation to give back when we commit.
 	 */
-	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_RES_BLKS,
+	xfs_trans_mod_dquot(tp, newdq,
+			isrt ? XFS_TRANS_DQ_RES_RTBLKS : XFS_TRANS_DQ_RES_BLKS,
 			-ip->i_delayed_blks);
 
 	/*
@@ -2082,8 +2087,13 @@ xfs_qm_vop_chown(
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
index 4db022c189e134..30fbed27cf05cc 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1288,11 +1288,26 @@ xfs_trans_alloc_ichange(
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
@@ -1300,8 +1315,20 @@ xfs_trans_alloc_ichange(
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

