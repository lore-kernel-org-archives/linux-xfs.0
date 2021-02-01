Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E96C43332
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7614D64E2B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhBACGI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:06:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231268AbhBACFt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:05:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DBA264E28;
        Mon,  1 Feb 2021 02:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145107;
        bh=Q0hKMEwVL8yHhnoz9D/KDLcndYAIKFclXKlrvYUZ/i8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=UyGlbXdfvxEJPOe2+Qq5UkWsNgHdod5XVjIyzIETDbpcpS16J/PvMKMsLTZB+Eqij
         9EdSj12qbUMrPamAZ20IPlQkRIsC5vGOHjZrrOWXCW+kRrnVTq8JSonwmITvndQi5z
         9OYyLyol/DuvoFo24VO5HWDHTi5qH3f50rUNbhTwxhhk03+5VUg9vYI1LESxzlP1PJ
         SzZinm6/5YE2JrUAQUU25MNaxNUD+ToQ25uWYXs/jo7r+AznMstPKuh301l/oXMgMG
         XIZCZe0Bqd9/0MaiA0HuiA04Ot8hF6CP6uLtpJuCOg4fhbhE21AvwlssgGp9cWlEH8
         JXcjYukC0M3+g==
Subject: [PATCH 14/17] xfs: clean up xfs_trans_reserve_quota_chown a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:05:07 -0800
Message-ID: <161214510730.139387.4000977461727812094.stgit@magnolia>
In-Reply-To: <161214502818.139387.7678025647736002500.stgit@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clean up the calling conventions of xfs_trans_reserve_quota_chown a
little bit -- we can pass in a boolean force parameter since that's the
only qmopt that caller care about, and make the obvious deficiencies
more obvious for anyone who someday wants to clean up rt quota.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c       |    2 +-
 fs/xfs/xfs_iops.c        |    3 +--
 fs/xfs/xfs_quota.h       |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   37 ++++++++++++++++++++-----------------
 4 files changed, 24 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index e299fbd9ef13..73cfee8007a8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1471,7 +1471,7 @@ xfs_ioctl_setattr(
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    ip->i_d.di_projid != fa->fsx_projid) {
 		code = xfs_trans_reserve_quota_chown(tp, ip, NULL, NULL, pdqp,
-				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
+				capable(CAP_FOWNER));
 		if (code)	/* out of quota */
 			goto error_trans_cancel;
 	}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index cb68be87e0a4..51c877ce90bc 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -731,8 +731,7 @@ xfs_setattr_nonsize(
 		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
 			ASSERT(tp);
 			error = xfs_trans_reserve_quota_chown(tp, ip, udqp,
-					gdqp, NULL, capable(CAP_FOWNER) ?
-					XFS_QMOPT_FORCE_RES : 0);
+					gdqp, NULL, capable(CAP_FOWNER));
 			if (error)	/* out of quota */
 				goto out_cancel;
 		}
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 02f88670c2d9..f95a92d7ceaf 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -100,7 +100,7 @@ extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
 int xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, uint flags);
+		struct xfs_dquot *pdqp, bool force);
 extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
@@ -165,7 +165,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 static inline int
 xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, uint flags)
+		struct xfs_dquot *pdqp, bool force)
 {
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 3595c779f5d3..a02311e8be25 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -836,9 +836,7 @@ xfs_trans_reserve_quota_icreate(
 			dblocks, 1, XFS_QMOPT_RES_REGBLKS);
 }
 
-/*
- * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).
- */
+/* Change quota reservations for a change in user, group, or project id. */
 int
 xfs_trans_reserve_quota_chown(
 	struct xfs_trans	*tp,
@@ -846,31 +844,36 @@ xfs_trans_reserve_quota_chown(
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	uint			flags)
+	bool			force)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	unsigned int		blkflags;
-	struct xfs_dquot	*udq_delblks = NULL;
-	struct xfs_dquot	*gdq_delblks = NULL;
-	struct xfs_dquot	*pdq_delblks = NULL;
+	struct xfs_dquot	*new_udqp = NULL;
+	struct xfs_dquot	*new_gdqp = NULL;
+	struct xfs_dquot	*new_pdqp = NULL;
+	unsigned int		qflags = XFS_QMOPT_RES_REGBLKS;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	/*
+	 * XXX: This function doesn't handle rt quota counts correctly.  We
+	 * don't support mounting with rt+quota so leave this breadcrumb.
+	 */
+	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
-	blkflags = XFS_IS_REALTIME_INODE(ip) ?
-			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
+	if (force)
+		qflags |= XFS_QMOPT_FORCE_RES;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
 	    i_uid_read(VFS_I(ip)) != udqp->q_id)
-		udq_delblks = udqp;
+		new_udqp = udqp;
 
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
 	    i_gid_read(VFS_I(ip)) != gdqp->q_id)
-		gdq_delblks = gdqp;
+		new_gdqp = gdqp;
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
 	    ip->i_d.di_projid != pdqp->q_id)
-		pdq_delblks = pdqp;
+		new_pdqp = pdqp;
 
 	/*
 	 * Reserve enough quota to handle blocks on disk and reserved for a
@@ -878,10 +881,10 @@ xfs_trans_reserve_quota_chown(
 	 * reservation between dquots at chown time, even though that part is
 	 * only semi-transactional.
 	 */
-	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
-			gdq_delblks, pdq_delblks,
+	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, new_udqp,
+			new_gdqp, new_pdqp,
 			ip->i_d.di_nblocks + ip->i_delayed_blks,
-			1, blkflags | flags);
+			1, qflags);
 }
 
 /*

