Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B46CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F9C064EDB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 02:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhBBCFV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Feb 2021 21:05:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230009AbhBBCFS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 21:05:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE6EE64EE2;
        Tue,  2 Feb 2021 02:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612231477;
        bh=Ct/HP0ReCZgD++YZysi6ij2P55VpJVJAyihAqfpT4VU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t1CcenZbG1NiqlfodRNFjMRTSu2gfYMsOfng6xmZr2y4sQ1f6eipVCXbfpRsifOmg
         dhiGtEDef/0CDlczzKj7ZSq0/rtP29LmmZSvqEJDoKdEJttRSEWHhorehkGqBFtgXp
         7MWwDZICUQ/ywKdDMG2qCt+r91Ldq1q2wCarL5bg6Cvjr0CtqO4gvBUadbT6CdzKQX
         exb/YhSenpP5D4ND6sYElVHkWxB93snFmLm1sAmckdHXD7po5hjauCmjpovb7FsN4S
         pUOvp2WggqDtXJoABl3T7PYUK+xTrmoOfJWz6CaN3aDFKnsGYu/h1vPUUL62gNRK7N
         1SHlKmA3S3HQg==
Subject: [PATCH 14/16] xfs: remove xfs_qm_vop_chown_reserve
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Mon, 01 Feb 2021 18:04:37 -0800
Message-ID: <161223147738.491593.3959130426904738389.stgit@magnolia>
In-Reply-To: <161223139756.491593.10895138838199018804.stgit@magnolia>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that the only caller of this function is xfs_trans_alloc_ichange,
just open-code the meat of _chown_reserve in that caller.  Drop the
(redundant) [ugp]id checks because xfs has a 1:1 relationship between
quota ids and incore dquots.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c    |   48 ------------------------------------------------
 fs/xfs/xfs_quota.h |    4 ----
 fs/xfs/xfs_trans.c |   16 ++++++++++++++--
 3 files changed, 14 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 322d337b5dca..275cf5d7a178 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1816,54 +1816,6 @@ xfs_qm_vop_chown(
 	return prevdq;
 }
 
-/*
- * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).
- */
-int
-xfs_qm_vop_chown_reserve(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	struct xfs_dquot	*udqp,
-	struct xfs_dquot	*gdqp,
-	struct xfs_dquot	*pdqp,
-	uint			flags)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	unsigned int		blkflags;
-	struct xfs_dquot	*udq_delblks = NULL;
-	struct xfs_dquot	*gdq_delblks = NULL;
-	struct xfs_dquot	*pdq_delblks = NULL;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
-
-	blkflags = XFS_IS_REALTIME_INODE(ip) ?
-			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
-
-	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    i_uid_read(VFS_I(ip)) != udqp->q_id)
-		udq_delblks = udqp;
-
-	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    i_gid_read(VFS_I(ip)) != gdqp->q_id)
-		gdq_delblks = gdqp;
-
-	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    ip->i_d.di_projid != pdqp->q_id)
-		pdq_delblks = pdqp;
-
-	/*
-	 * Reserve enough quota to handle blocks on disk and reserved for a
-	 * delayed allocation.  We'll actually transfer the delalloc
-	 * reservation between dquots at chown time, even though that part is
-	 * only semi-transactional.
-	 */
-	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
-			gdq_delblks, pdq_delblks,
-			ip->i_d.di_nblocks + ip->i_delayed_blks,
-			1, blkflags | flags);
-}
-
 int
 xfs_qm_vop_rename_dqattach(
 	struct xfs_inode	**i_tab)
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 6ddc4b358ede..d00d01302545 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -98,9 +98,6 @@ extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
 extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
 extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
-extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
-		struct xfs_dquot *, struct xfs_dquot *,
-		struct xfs_dquot *, uint);
 extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
@@ -162,7 +159,6 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
-#define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
 #define xfs_qm_dqattach(ip)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 60672b5545c9..29dca1bc4c1a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1156,8 +1156,20 @@ xfs_trans_alloc_ichange(
 	if (pdqp == ip->i_pdquot)
 		pdqp = NULL;
 	if (udqp || gdqp || pdqp) {
-		error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp, pdqp,
-				force ? XFS_QMOPT_FORCE_RES : 0);
+		unsigned int	qflags = XFS_QMOPT_RES_REGBLKS;
+
+		if (force)
+			qflags |= XFS_QMOPT_FORCE_RES;
+
+		/*
+		 * Reserve enough quota to handle blocks on disk and reserved
+		 * for a delayed allocation.  We'll actually transfer the
+		 * delalloc reservation between dquots at chown time, even
+		 * though that part is only semi-transactional.
+		 */
+		error = xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp,
+				pdqp, ip->i_d.di_nblocks + ip->i_delayed_blks,
+				1, qflags);
 		if (error)
 			goto out_cancel;
 	}

