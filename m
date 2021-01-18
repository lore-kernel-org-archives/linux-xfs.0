Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520A5C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2787D22E00
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbhARWMh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:12:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbhARWMg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:12:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37C0722E00;
        Mon, 18 Jan 2021 22:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007916;
        bh=Fdpgrg5xZTJNj2MOT+d4BsSmzJNMnzEVa67ntpHk3y0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i2qVHJprKAQgszYhjBWYUmc1H0KIjUnQWEWpcxu4gLm3LeCZ/+qoB6yqEJU6O46mp
         EKCL/aymEEIGR5x4enup6EBtFeAJVpURqw0DTnjb/ffluTELoWd4PwcFsRIckB482j
         jedqTAoIIXA5sLPdpx4mv5h4eL2kw9FueoGOOc6ArHZkLBn/T2QdGGm6iB9SaFoviI
         FrBMmiFb1Dj4wEKm4uL+RR2MSLBrFVXmKcf6AsXucBQlw1G7CFlyDnZ9h226wx2I6S
         wdQcY8sDKwEgp8wEOLHliKUnpDcBZzEOOrUFLeneQkBSCPFJRrCKkcFj3ZSlRsZlPW
         BkdBAtoZOn8ew==
Subject: [PATCH 4/4] xfs: clean up icreate quota reservation calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:11:55 -0800
Message-ID: <161100791592.88678.7280544229099188181.stgit@magnolia>
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

Create a proper helper so that inode creation calls can reserve quota
with a dedicated function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c       |    8 ++++----
 fs/xfs/xfs_quota.h       |   14 ++++++++++----
 fs/xfs/xfs_symlink.c     |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   21 +++++++++++++++++++++
 4 files changed, 37 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e5dc41b10ebb..43cff78c20c4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1037,8 +1037,8 @@ xfs_create(
 	/*
 	 * Reserve disk quota and the inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
-						pdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota_icreate(tp, dp, udqp, gdqp, pdqp,
+			resblks);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1164,8 +1164,8 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_inode;
 
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
-						pdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota_icreate(tp, dp, udqp, gdqp, pdqp,
+			resblks);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index b1411d25c9e5..1c37b5be60c3 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -86,6 +86,9 @@ extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
+int xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_inode *dp,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, int64_t nblks);
 
 extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
@@ -141,6 +144,13 @@ static inline int xfs_quota_reserve_blkres(struct xfs_inode *ip,
 {
 	return 0;
 }
+static inline int
+xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_inode *dp,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, int64_t nblks)
+{
+	return 0;
+}
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -163,10 +173,6 @@ xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
 	return xfs_trans_reserve_quota_nblks(tp, ip, -nblks, -ninos, flags);
 }
 
-#define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
-	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
-				f | XFS_QMOPT_RES_REGBLKS)
-
 static inline int
 xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks,
 		unsigned int flags)
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 1f43fd7f3209..e53f7bc2b820 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -215,8 +215,8 @@ xfs_symlink(
 	/*
 	 * Reserve disk quota : blocks and inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
-						pdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota_icreate(tp, dp, udqp, gdqp, pdqp,
+			resblks);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 28b8ac701919..3315498a6fa1 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -804,6 +804,27 @@ xfs_trans_reserve_quota_nblks(
 						nblks, ninos, flags);
 }
 
+/* Change the quota reservations for an inode creation activity. */
+int
+xfs_trans_reserve_quota_icreate(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
+	int64_t			nblks)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+
+	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+		return 0;
+
+	ASSERT(!xfs_is_quota_inode(&mp->m_sb, dp->i_ino));
+
+	return xfs_trans_reserve_quota_bydquots(tp, dp->i_mount, udqp, gdqp,
+			pdqp, nblks, 1, XFS_QMOPT_RES_REGBLKS);
+}
+
 /*
  * This routine is called to allocate a quotaoff log item.
  */

