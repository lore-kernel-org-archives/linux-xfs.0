Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0485C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE1864DDA
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbhA1GDF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229709AbhA1GDD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:03:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C90A64DD9;
        Thu, 28 Jan 2021 06:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813742;
        bh=pau6kM/myxlI//KQhLjCEb+HI/+0G7FIhGYo+TQ0y9c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dTRE6L9uIIROebgsH+NBL9qckUgzpvn1Mbyk3jRt5BvcXrOsA4m4sRTwD7pfJ0pkG
         uXCh4Q/mkKr+oAOCntEHGkyK+WNos2eiAKT7tminkSUk3ycaUkg0i1slz33Avcc2Qb
         ur/GZKu+RV7gqJxccp78PoFqrlGwrdODVhZNS8f2hZThR3AH+DAohQO9PxKqUQmm5n
         sTq9nCDZzHVnMDTIEZEbVKcB/UYupmNJpMeqpzk+q6MziBScDT5nlSNdvzyks8iHV7
         L41Toq2BY+tcipx1qehfcmX+hC1Gnrfjsz36f/lX3oivMU7wQclgM2Pyv2/9KxNRwM
         CXNIinA89t23A==
Subject: [PATCH 13/13] xfs: clean up xfs_trans_reserve_quota_chown a bit
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:02:18 -0800
Message-ID: <161181373829.1523592.77926677559106032.stgit@magnolia>
In-Reply-To: <161181366379.1523592.9213241916555622577.stgit@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clean up the calling conventions of xfs_trans_reserve_quota_chown a
littel bit -- we can pass in a boolean force parameter since that's the
only qmopt that caller care about, and make the obvious deficiencies
more obvious for anyone who someday wants to clean up rt quota.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c       |    2 +-
 fs/xfs/xfs_iops.c        |    3 +--
 fs/xfs/xfs_quota.h       |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   38 +++++++++++++++++++++-----------------
 4 files changed, 25 insertions(+), 22 deletions(-)


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
index d3876c71be8f..c3a5b48f5860 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -100,7 +100,7 @@ extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
 int xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, unsigned int flags);
+		struct xfs_dquot *pdqp, bool force);
 extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
@@ -165,7 +165,7 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 static inline int
 xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, unsigned int flags)
+		struct xfs_dquot *pdqp, bool force)
 {
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 88146280a177..73ef5994d09d 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -846,26 +846,30 @@ xfs_trans_reserve_quota_chown(
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	unsigned int		flags)
+	bool			force)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		delblks;
-	unsigned int		blkflags;
-	struct xfs_dquot	*udq_unres = NULL;
+	struct xfs_dquot	*udq_unres = NULL;	/* old dquots */
 	struct xfs_dquot	*gdq_unres = NULL;
 	struct xfs_dquot	*pdq_unres = NULL;
-	struct xfs_dquot	*udq_delblks = NULL;
+	struct xfs_dquot	*udq_delblks = NULL;	/* new dquots */
 	struct xfs_dquot	*gdq_delblks = NULL;
 	struct xfs_dquot	*pdq_delblks = NULL;
+	uint64_t		delblks;
+	unsigned int		qflags = XFS_QMOPT_RES_REGBLKS;
 	int			error;
 
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	/*
+	 * XXX: This function doesn't handle rt quota counts correctly.  We
+	 * don't support mounting with rt+quota so leave this breadcrumb.
+	 */
+	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	delblks = ip->i_delayed_blks;
-	blkflags = XFS_IS_REALTIME_INODE(ip) ?
-			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
+	if (force)
+		qflags |= XFS_QMOPT_FORCE_RES;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
 	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
@@ -898,9 +902,9 @@ xfs_trans_reserve_quota_chown(
 		}
 	}
 
-	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1, flags | blkflags);
+	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
+			gdq_delblks, pdq_delblks, ip->i_d.di_nblocks, 1,
+			qflags);
 	if (error)
 		return error;
 
@@ -917,13 +921,13 @@ xfs_trans_reserve_quota_chown(
 		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
 		ASSERT(udq_unres || gdq_unres || pdq_unres);
 		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
+				udq_delblks, gdq_delblks, pdq_delblks,
+				(xfs_qcnt_t)delblks, 0, qflags);
 		if (error)
 			return error;
-		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				udq_unres, gdq_unres, pdq_unres,
-				-((xfs_qcnt_t)delblks), 0, blkflags);
+		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount, udq_unres,
+				gdq_unres, pdq_unres, -((xfs_qcnt_t)delblks),
+				0, qflags);
 	}
 
 	return 0;

