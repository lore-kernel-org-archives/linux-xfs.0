Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EA4C433E6
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A95264E01
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhA2CRg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:17:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:57378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhA2CRf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:17:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8585564E00;
        Fri, 29 Jan 2021 02:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886612;
        bh=TG6K7SIyMrih+S3Jfcco/SknYZOZJjuXELeL7eSjNd4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QICfU8okBqqFsn42GBzgnk96xABkUXmnWFkPZpWsGddEaxv+osFYatS0pSrHXs0qa
         hn4zzQuHCrdQmtqzbkptfhwdDhMYd/+mCqzJJmE39nShQTAF7wmj5eUgtQF83s8x2i
         NUwPTZ2/xRrYHLDVuGObhJtm52dl3N4PlZDpp/BTmT2Zznkqvc8int1YTatWddrzA/
         88UgcX8MTDXbzCkIVk+6Zt1Z7Kxf0eQ2RLbJLhVJbj3r0Q+52MLHZgYG/09cnAoh2e
         6zeVxP7WbnMPkoTRh12eoT38QNZ3OishGQFbkcWjrWoCFYNpjRkudnCoz/cdRtF3Xh
         ihFNkbSRKmURQ==
Subject: [PATCH 04/13] xfs: clean up icreate quota reservation calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:16:52 -0800
Message-ID: <161188661213.1943645.3946136460317265199.stgit@magnolia>
In-Reply-To: <161188658869.1943645.4527151504893870676.stgit@magnolia>
References: <161188658869.1943645.4527151504893870676.stgit@magnolia>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c       |    6 ++----
 fs/xfs/xfs_quota.h       |   14 ++++++++++----
 fs/xfs/xfs_symlink.c     |    3 +--
 fs/xfs/xfs_trans_dquot.c |   18 ++++++++++++++++++
 4 files changed, 31 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e2a1db4cee43..4bbd2fb628f7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1037,8 +1037,7 @@ xfs_create(
 	/*
 	 * Reserve disk quota and the inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
-						pdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, resblks);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1169,8 +1168,7 @@ xfs_create_tmpfile(
 	if (error)
 		goto out_release_inode;
 
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
-						pdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, resblks);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 31d0de899cc4..919c3a924821 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -86,6 +86,9 @@ extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
 extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
 		struct xfs_mount *, struct xfs_dquot *,
 		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
+int xfs_trans_reserve_quota_icreate(struct xfs_trans *tp,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, int64_t dblocks);
 
 extern int xfs_qm_vop_dqalloc(struct xfs_inode *, kuid_t, kgid_t,
 		prid_t, uint, struct xfs_dquot **, struct xfs_dquot **,
@@ -149,6 +152,13 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
 	return 0;
 }
 
+static inline int
+xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
+		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, int64_t dblocks)
+{
+	return 0;
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -164,10 +174,6 @@ xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
 #define xfs_qm_unmount_quotas(mp)
 #endif /* CONFIG_XFS_QUOTA */
 
-#define xfs_trans_reserve_quota(tp, mp, ud, gd, pd, nb, ni, f) \
-	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
-				f | XFS_QMOPT_RES_REGBLKS)
-
 static inline int
 xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
 {
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 7f96649e918a..d5dee8f409b2 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -215,8 +215,7 @@ xfs_symlink(
 	/*
 	 * Reserve disk quota : blocks and inode.
 	 */
-	error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
-						pdqp, resblks, 1, 0);
+	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, resblks);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 28b8ac701919..22aa875b84f7 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -804,6 +804,24 @@ xfs_trans_reserve_quota_nblks(
 						nblks, ninos, flags);
 }
 
+/* Change the quota reservations for an inode creation activity. */
+int
+xfs_trans_reserve_quota_icreate(
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
+	int64_t			dblocks)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+
+	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
+		return 0;
+
+	return xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp, pdqp,
+			dblocks, 1, XFS_QMOPT_RES_REGBLKS);
+}
+
 /*
  * This routine is called to allocate a quotaoff log item.
  */

