Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF49C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACAA464DDB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhA1GDE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229513AbhA1GC6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:02:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 552B664DDB;
        Thu, 28 Jan 2021 06:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813736;
        bh=1RWp9UFde5601P72EgJ2ojUDbX4edsDZso/Jv1lcxNA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=R19OTOMNRzSLkMJ4RsTGTAlVBSwqMYpHwOcHfb34O16AwPgqxH6dSVtlIKeAMB4UK
         qGahL6LTyVCOYRlwNGjfXS23psZjUPBiWNNFzygRhmHTrjpni8oC+BbBbBDg0Vld4/
         Snqx5fKUegxv9BRcDwO1i8no7BVy6Q1QPhYoHOI65zrz/QwsfwpsrTCDlJxPkqNima
         lYwp6puP7KK5KV6m78zdaSNVIjrlrfSS1+skWSHUd8WmKl8QmL4YSnuQEaZvOaf+bg
         WLlzJe9H1UzVQuxnFhgHyfeG9KpF5lJNAaH6hqrDCME84+EuGal/TmGKdElOp4AvHO
         TK16hApJrNDfA==
Subject: [PATCH 12/13] xfs: move xfs_qm_vop_chown_reserve to xfs_trans_dquot.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:02:12 -0800
Message-ID: <161181373258.1523592.242724679476042204.stgit@magnolia>
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

Move xfs_qm_vop_chown_reserve to xfs_trans_dquot.c and rename it
xfs_trans_reserve_quota_chown.  This will enable us to share code with
the other quota reservation helpers, which will be very useful in the
next patchset when we implement retry loops.  No functional changes
here, we're just moving code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c       |    2 -
 fs/xfs/xfs_iops.c        |    6 +--
 fs/xfs/xfs_qm.c          |   93 ----------------------------------------------
 fs/xfs/xfs_quota.h       |   14 +++++--
 fs/xfs/xfs_trans_dquot.c |   93 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 101 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3fbd98f61ea5..e299fbd9ef13 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1470,7 +1470,7 @@ xfs_ioctl_setattr(
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    ip->i_d.di_projid != fa->fsx_projid) {
-		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
+		code = xfs_trans_reserve_quota_chown(tp, ip, NULL, NULL, pdqp,
 				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
 		if (code)	/* out of quota */
 			goto error_trans_cancel;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f1e21b6cfa48..cb68be87e0a4 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -730,9 +730,9 @@ xfs_setattr_nonsize(
 		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
 		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
 			ASSERT(tp);
-			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						NULL, capable(CAP_FOWNER) ?
-						XFS_QMOPT_FORCE_RES : 0);
+			error = xfs_trans_reserve_quota_chown(tp, ip, udqp,
+					gdqp, NULL, capable(CAP_FOWNER) ?
+					XFS_QMOPT_FORCE_RES : 0);
 			if (error)	/* out of quota */
 				goto out_cancel;
 		}
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c134eb4aeaa8..6c2a9fa78e7c 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1794,99 +1794,6 @@ xfs_qm_vop_chown(
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
-	uint64_t		delblks;
-	unsigned int		blkflags;
-	struct xfs_dquot	*udq_unres = NULL;
-	struct xfs_dquot	*gdq_unres = NULL;
-	struct xfs_dquot	*pdq_unres = NULL;
-	struct xfs_dquot	*udq_delblks = NULL;
-	struct xfs_dquot	*gdq_delblks = NULL;
-	struct xfs_dquot	*pdq_delblks = NULL;
-	int			error;
-
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
-
-	delblks = ip->i_delayed_blks;
-	blkflags = XFS_IS_REALTIME_INODE(ip) ?
-			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
-
-	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
-		udq_delblks = udqp;
-		/*
-		 * If there are delayed allocation blocks, then we have to
-		 * unreserve those from the old dquot, and add them to the
-		 * new dquot.
-		 */
-		if (delblks) {
-			ASSERT(ip->i_udquot);
-			udq_unres = ip->i_udquot;
-		}
-	}
-	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
-		gdq_delblks = gdqp;
-		if (delblks) {
-			ASSERT(ip->i_gdquot);
-			gdq_unres = ip->i_gdquot;
-		}
-	}
-
-	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    ip->i_d.di_projid != pdqp->q_id) {
-		pdq_delblks = pdqp;
-		if (delblks) {
-			ASSERT(ip->i_pdquot);
-			pdq_unres = ip->i_pdquot;
-		}
-	}
-
-	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
-				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1, flags | blkflags);
-	if (error)
-		return error;
-
-	/*
-	 * Do the delayed blks reservations/unreservations now. Since, these
-	 * are done without the help of a transaction, if a reservation fails
-	 * its previous reservations won't be automatically undone by trans
-	 * code. So, we have to do it manually here.
-	 */
-	if (delblks) {
-		/*
-		 * Do the reservations first. Unreservation can't fail.
-		 */
-		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
-		ASSERT(udq_unres || gdq_unres || pdq_unres);
-		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-			    udq_delblks, gdq_delblks, pdq_delblks,
-			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
-		if (error)
-			return error;
-		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
-				udq_unres, gdq_unres, pdq_unres,
-				-((xfs_qcnt_t)delblks), 0, blkflags);
-	}
-
-	return 0;
-}
-
 int
 xfs_qm_vop_rename_dqattach(
 	struct xfs_inode	**i_tab)
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index efd04f84d9b4..d3876c71be8f 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -98,9 +98,9 @@ extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
 extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
 extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
-extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
-		struct xfs_dquot *, struct xfs_dquot *,
-		struct xfs_dquot *, uint);
+int xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int flags);
 extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
@@ -162,7 +162,13 @@ xfs_trans_reserve_quota_icreate(struct xfs_trans *tp, struct xfs_dquot *udqp,
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
-#define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
+static inline int
+xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int flags)
+{
+	return 0;
+}
 #define xfs_qm_dqattach(ip)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index a1a72b7900c5..88146280a177 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -836,6 +836,99 @@ xfs_trans_reserve_quota_icreate(
 			dblocks, 1, XFS_QMOPT_RES_REGBLKS);
 }
 
+/*
+ * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).
+ */
+int
+xfs_trans_reserve_quota_chown(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
+	unsigned int		flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	uint64_t		delblks;
+	unsigned int		blkflags;
+	struct xfs_dquot	*udq_unres = NULL;
+	struct xfs_dquot	*gdq_unres = NULL;
+	struct xfs_dquot	*pdq_unres = NULL;
+	struct xfs_dquot	*udq_delblks = NULL;
+	struct xfs_dquot	*gdq_delblks = NULL;
+	struct xfs_dquot	*pdq_delblks = NULL;
+	int			error;
+
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
+
+	delblks = ip->i_delayed_blks;
+	blkflags = XFS_IS_REALTIME_INODE(ip) ?
+			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
+
+	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
+	    i_uid_read(VFS_I(ip)) != udqp->q_id) {
+		udq_delblks = udqp;
+		/*
+		 * If there are delayed allocation blocks, then we have to
+		 * unreserve those from the old dquot, and add them to the
+		 * new dquot.
+		 */
+		if (delblks) {
+			ASSERT(ip->i_udquot);
+			udq_unres = ip->i_udquot;
+		}
+	}
+	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
+	    i_gid_read(VFS_I(ip)) != gdqp->q_id) {
+		gdq_delblks = gdqp;
+		if (delblks) {
+			ASSERT(ip->i_gdquot);
+			gdq_unres = ip->i_gdquot;
+		}
+	}
+
+	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
+	    ip->i_d.di_projid != pdqp->q_id) {
+		pdq_delblks = pdqp;
+		if (delblks) {
+			ASSERT(ip->i_pdquot);
+			pdq_unres = ip->i_pdquot;
+		}
+	}
+
+	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
+				udq_delblks, gdq_delblks, pdq_delblks,
+				ip->i_d.di_nblocks, 1, flags | blkflags);
+	if (error)
+		return error;
+
+	/*
+	 * Do the delayed blks reservations/unreservations now. Since, these
+	 * are done without the help of a transaction, if a reservation fails
+	 * its previous reservations won't be automatically undone by trans
+	 * code. So, we have to do it manually here.
+	 */
+	if (delblks) {
+		/*
+		 * Do the reservations first. Unreservation can't fail.
+		 */
+		ASSERT(udq_delblks || gdq_delblks || pdq_delblks);
+		ASSERT(udq_unres || gdq_unres || pdq_unres);
+		error = xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
+			    udq_delblks, gdq_delblks, pdq_delblks,
+			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
+		if (error)
+			return error;
+		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
+				udq_unres, gdq_unres, pdq_unres,
+				-((xfs_qcnt_t)delblks), 0, blkflags);
+	}
+
+	return 0;
+}
+
 /*
  * This routine is called to allocate a quotaoff log item.
  */

