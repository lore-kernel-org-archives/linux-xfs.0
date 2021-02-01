Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80616C4332E
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F71164E2A
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhBACGF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231277AbhBACFn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:05:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F98B64E2A;
        Mon,  1 Feb 2021 02:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145102;
        bh=7iXdiQUKhO29sBF5A65QpMlyuY6qRIE+wfBxgUxs1jk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QfpvOFJz6+qc2FSUSqh4yX/sW5xeKlacuTtQ/iW8nYYQs+SjLxo8WvhCC37SMNkE+
         7NauDuI2w9XxzoekWLjLy9MdTyZr8GbXAuFm9OjfbjGxA3vm1jd9a2r/u8pjIDKykS
         91HUf9seQsE3/2MhjXG8qXiH4ShvyL5yPBFFZ6JTll5eJauHLzjIC2n8Kgg6oye5hl
         slRYs5RDsXC29rs7KSZR2KpKUzIwJ818GE+/Msj10/Fq1+9B9DhK/9UMIg0xcPSBIY
         T37hppnewQ0aI4RPjQxCa5ntB+0s9t1D4RHmmNMNwoW3OVZXTrKJYRObb8EzR90jk3
         0haptuS2kNVVQ==
Subject: [PATCH 13/17] xfs: move xfs_qm_vop_chown_reserve to xfs_trans_dquot.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:05:01 -0800
Message-ID: <161214510164.139387.1578453347437699937.stgit@magnolia>
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

Move xfs_qm_vop_chown_reserve to xfs_trans_dquot.c and rename it
xfs_trans_reserve_quota_chown.  This will enable us to share code with
the other quota reservation helpers, which will be very useful in the
next patchset when we implement retry loops.  No functional changes
here, we're just moving code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c       |    2 +-
 fs/xfs/xfs_iops.c        |    6 +++---
 fs/xfs/xfs_qm.c          |   48 ----------------------------------------------
 fs/xfs/xfs_quota.h       |   14 ++++++++++---
 fs/xfs/xfs_trans_dquot.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 62 insertions(+), 56 deletions(-)


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
index 6ddc4b358ede..02f88670c2d9 100644
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
+		struct xfs_dquot *pdqp, uint flags);
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
+		struct xfs_dquot *pdqp, uint flags)
+{
+	return 0;
+}
 #define xfs_qm_dqattach(ip)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index a1a72b7900c5..3595c779f5d3 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -836,6 +836,54 @@ xfs_trans_reserve_quota_icreate(
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
+	uint			flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		blkflags;
+	struct xfs_dquot	*udq_delblks = NULL;
+	struct xfs_dquot	*gdq_delblks = NULL;
+	struct xfs_dquot	*pdq_delblks = NULL;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
+	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
+
+	blkflags = XFS_IS_REALTIME_INODE(ip) ?
+			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
+
+	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
+	    i_uid_read(VFS_I(ip)) != udqp->q_id)
+		udq_delblks = udqp;
+
+	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
+	    i_gid_read(VFS_I(ip)) != gdqp->q_id)
+		gdq_delblks = gdqp;
+
+	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
+	    ip->i_d.di_projid != pdqp->q_id)
+		pdq_delblks = pdqp;
+
+	/*
+	 * Reserve enough quota to handle blocks on disk and reserved for a
+	 * delayed allocation.  We'll actually transfer the delalloc
+	 * reservation between dquots at chown time, even though that part is
+	 * only semi-transactional.
+	 */
+	return xfs_trans_reserve_quota_bydquots(tp, ip->i_mount, udq_delblks,
+			gdq_delblks, pdq_delblks,
+			ip->i_d.di_nblocks + ip->i_delayed_blks,
+			1, blkflags | flags);
+}
+
 /*
  * This routine is called to allocate a quotaoff log item.
  */

