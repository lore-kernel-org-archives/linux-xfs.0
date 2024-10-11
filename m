Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DD71373
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609142; cv=none; b=PmsVI2kQBLn3sD0CtKO8qJVxg1nuf6fSBuGYlg5tfMnT//qeZavs0qpcE4ulqImeLVriBI2Kjb5gPb8E7hqSj7EjLI29M+RQ1QB3tWT/tIv4+KDXjJOT551Ev5q/yzEQK5Swy9Iov8avlrFdAGI9v+jRAiQFZwVV4ABu8lhhfEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609142; c=relaxed/simple;
	bh=tWIUGxgdrz9sLxdR8yxWSZQQsfv6ZadL41EI/zxf270=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bR++BS8bInZottbLIlYG64Crp1e31K2ROy3X0nFXwrW+VxwzjfRhCuayxdFiwBbZbzzfZ1xx18/H6Q2cv746pMSeZaUMlMpi0P7pwwhgq78KIbVhSa9YS0O2Y8x3ga59awhOoK+MSE1qYoaI4WFmMjtt42+JKm+bA4HefZ64ZcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X7kz68E8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X7kz68E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9292BC4CEC5;
	Fri, 11 Oct 2024 01:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609141;
	bh=tWIUGxgdrz9sLxdR8yxWSZQQsfv6ZadL41EI/zxf270=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X7kz68E8Hgd96zyE2c/WcVe4fpS+mHwNLOp41DzumUg6aXpbo5XZvBv/z2PWYxUBy
	 Kb1iJcOxbMR+x5heO2TKDqv07bqLp3m9kDgWvPNcIftB5dabOqyOx3OCN1Lu2+5K8H
	 IgeK117KnF4JpRNKhI9hTZ5BUyXuUwcYQo4OdykoP72zKwjiQ0UCsTHYlA1MUOaEPm
	 SGPoo8qDjYtnXvBMWMDQoNd8sN46X/jQsan9DU0AEu1NFdIdIsfxrmVtD6XEFgWzvC
	 bn2i91KuG3+C2Z+RwUZuBIRp4pbX0E9ZWl35k8OS/aNv3BBkwU7HktJV30rOZ4m1Xc
	 OJBJl3PWpRG7Q==
Date: Thu, 10 Oct 2024 18:12:21 -0700
Subject: [PATCH 1/6] xfs: fix chown with rt quota
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645695.4180109.15774707176031680844.stgit@frogsfrogsfrogs>
In-Reply-To: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
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

Make chown's quota adjustments work with realtime files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

