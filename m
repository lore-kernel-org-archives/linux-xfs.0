Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93A1C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95BCD22DFB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732787AbhARWMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:12:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729183AbhARWMb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:12:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B20DC22DFB;
        Mon, 18 Jan 2021 22:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007910;
        bh=sCTTwbX1LQHi2a7za4lvOYEMn4y6Q6A16UQgg233kwo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y+Vn3WIhd1mTZ26I7SK0PZZA4AIaRDlw6Cd2k8qvqOVYMhvqVvYvv3xqa4KFlnGJe
         jjQErE6KUdyDQbba3UFF8kXrAItY4VIc0gNauAqNTd4ZZstza5RSXElKc2TzBJdj8B
         2A40Khong0VXmx5x6Va5sKzt1RoHqBwZkkztVVLLFkKEsghg6n2fk/T5O4cJIfSnkn
         3T1Nj9dnM8XJ0LHz1TuJWMc5rsnKqefUrnYTh645EciKpe8aX+ykV4b3oYVtqAdVhV
         Q3r9mZuCLWMC+NXURNlJK98jfi2q2wfPxthuP0RnV6AqdqmdE16g0/JrmdQtT1+1VU
         BZGGiMQdj+BIg==
Subject: [PATCH 3/4] xfs: create convenience wrappers for incore quota block
 reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:11:50 -0800
Message-ID: <161100791039.88678.6897577495997060048.stgit@magnolia>
In-Reply-To: <161100789347.88678.17195697099723545426.stgit@magnolia>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a couple of convenience wrappers for creating and deleting quota
block reservations against future changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    8 +++-----
 fs/xfs/xfs_quota.h       |   19 +++++++++++++++++++
 fs/xfs/xfs_reflink.c     |    3 +--
 3 files changed, 23 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 21076ac2485a..fa6b442eb75f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4001,8 +4001,7 @@ xfs_bmapi_reserve_delalloc(
 	 * blocks.  This number gets adjusted later.  We return if we haven't
 	 * allocated blocks already inside this loop.
 	 */
-	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+	error = xfs_quota_reserve_blkres(ip, alen, XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		return error;
 
@@ -4048,8 +4047,7 @@ xfs_bmapi_reserve_delalloc(
 	xfs_mod_fdblocks(mp, alen, false);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
-		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+		xfs_quota_unreserve_blkres(ip, alen, XFS_QMOPT_RES_REGBLKS);
 	return error;
 }
 
@@ -4826,7 +4824,7 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	error = xfs_trans_unreserve_quota_nblks(NULL, ip, del->br_blockcount, 0,
+	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount,
 			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index bd28d17941e7..b1411d25c9e5 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -136,6 +136,11 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 {
 	return 0;
 }
+static inline int xfs_quota_reserve_blkres(struct xfs_inode *ip,
+		int64_t nblks, unsigned int flags)
+{
+	return 0;
+}
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -162,6 +167,20 @@ xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
 	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
+static inline int
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks,
+		unsigned int flags)
+{
+	return xfs_trans_reserve_quota_nblks(NULL, ip, nblks, 0, flags);
+}
+
+static inline int
+xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t nblks,
+		unsigned int flags)
+{
+	return xfs_quota_reserve_blkres(ip, -nblks, flags);
+}
+
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 20321d03e31c..1f3270ffaea5 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -508,8 +508,7 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 			/* Remove the quota reservation */
-			error = xfs_trans_unreserve_quota_nblks(NULL, ip,
-					del.br_blockcount, 0,
+			error = xfs_quota_unreserve_blkres(ip, del.br_blockcount,
 					XFS_QMOPT_RES_REGBLKS);
 			if (error)
 				break;

