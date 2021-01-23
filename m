Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4F6C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF19B23340
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbhAWSws (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbhAWSwg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:52:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AACC122DBF;
        Sat, 23 Jan 2021 18:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427915;
        bh=leG9vUxipS1mLBwulMHto+l1Qe/GZyBl2RVx6RkehIQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jC0YlG7Mk6+uROJ03jxrH7m4VmDDABcf/HOlP9PoVV3P7Ces/j8SabEMNL+hS1JiE
         Ozd81+yzeXxaUny4l0sPrNSNgTHRX8wH1ww3c+TTrIwlQ/Fs68jVc1yO193P9olCgy
         4b4ttwngGazdgyOxgjWyfDVkgFLiXSQhpIGO3384zhSHCXAegPDSqMwNbwSM7bsopC
         3OcVIjdcPU6GOIAlviG/VMR5AKaWDJMBZlF38rE1cqqS7DmhTswa7DAY828UA8f+hF
         UCuZ+U7MSZ1MbplreZvTlSe494r3g05FLFWPPH/K28IrqQmqJvoE/RFdbvD0bYtPcA
         kdM0pbbDy9j5g==
Subject: [PATCH 4/4] xfs: clean up icreate quota reservation calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:51:57 -0800
Message-ID: <161142791730.2170981.16295389347749875438.stgit@magnolia>
In-Reply-To: <161142789504.2170981.1372317837643770452.stgit@magnolia>
References: <161142789504.2170981.1372317837643770452.stgit@magnolia>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c       |    8 ++++----
 fs/xfs/xfs_quota.h       |   15 +++++++++++----
 fs/xfs/xfs_symlink.c     |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   21 +++++++++++++++++++++
 4 files changed, 38 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e2a1db4cee43..e909da05cd28 100644
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
 
@@ -1169,8 +1169,8 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_inode;
 
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
-						pdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota_icreate(tp, dp, udqp, gdqp, pdqp,
+			resblks);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index a25e3ce04c60..16a2e7adf4da 100644
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
@@ -149,6 +152,14 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
 	return 0;
 }
 
+static inline int
+xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_inode *dp,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, int64_t nblks)
+{
+	return 0;
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -171,10 +182,6 @@ xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
 	return xfs_trans_reserve_quota_nblks(tp, ip, -nblks, -ninos, flags);
 }
 
-#define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
-	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
-				f | XFS_QMOPT_RES_REGBLKS)
-
 static inline int
 xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
 {
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 7f96649e918a..f8bfa51bdeef 100644
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

