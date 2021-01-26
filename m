Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E108DC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 993E22065E
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729394AbhAZXCs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:02:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727016AbhAZE4d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 23:56:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 738FC22D58;
        Tue, 26 Jan 2021 04:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611636952;
        bh=UKoEVwc3wHv+Touk9EMwiwY3LFryYMt8X1bECD+V4/Y=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=PPwUpBbyHebnBZi4Fq1XoLLaaGn1P7M7d2z8d3ymyVj3QxuOmJpd2pJJlTL6FDPsx
         lLCmjHYV2nB5y3kb/AeB2+wB0A1AGK3BHM6qIiUrYN61aY2TjqsV2yTzb1Op0bOGfi
         HZB5ZD0QTyBIt0pM4FfN7rpX1JnGasaPJPguNsDNqjsM0Haf2WtC9twah8JMJY6KWN
         momcwq3V/njyLKnjGY/wDQAFCBIMGK0jSGnje1XHBzqm1K9OgA1VJ65gwGbYm2wEob
         enJov8aqWpuMLyGQtOYLUuf8NtQT5pVDVeTyAe54zDKVhrfka0ihSjZLsC9W8b4CFX
         gHg3bOH4Nx0HQ==
Date:   Mon, 25 Jan 2021 20:55:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4.1 08/11] xfs: flush eof/cowblocks if we can't reserve
 quota for chown
Message-ID: <20210126045551.GP7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142796398.2171939.8342732885181707528.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142796398.2171939.8342732885181707528.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a file user, group, or project change is unable to reserve enough
quota to handle the modification, try clearing whatever space the
filesystem might have been hanging onto in the hopes of speeding up the
filesystem.  The flushing behavior will become particularly important
when we add deferred inode inactivation because that will increase the
amount of space that isn't actively tied to user data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v4.1: fix the unconventional return conventions here too
---
 fs/xfs/xfs_ioctl.c |   13 ++++++++++++-
 fs/xfs/xfs_iops.c  |   14 ++++++++++++--
 fs/xfs/xfs_qm.c    |   23 +++++++++++++++++------
 fs/xfs/xfs_quota.h |    8 ++++----
 4 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3fbd98f61ea5..dab525c2437c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1436,6 +1436,7 @@ xfs_ioctl_setattr(
 	struct xfs_trans	*tp;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
+	bool			quota_retry = false;
 	int			code;
 
 	trace_xfs_ioctl_setattr(ip);
@@ -1462,6 +1463,7 @@ xfs_ioctl_setattr(
 
 	xfs_ioctl_setattr_prepare_dax(ip, fa);
 
+retry:
 	tp = xfs_ioctl_setattr_get_trans(ip);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);
@@ -1470,10 +1472,19 @@ xfs_ioctl_setattr(
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    ip->i_d.di_projid != fa->fsx_projid) {
+		unsigned int	flags = 0;
+
+		if (capable(CAP_FOWNER))
+			flags |= XFS_QMOPT_FORCE_RES;
 		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
-				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
+				flags, &quota_retry);
 		if (code)	/* out of quota */
 			goto error_trans_cancel;
+		if (quota_retry) {
+			xfs_trans_cancel_qretry_dquots(tp, ip, NULL, NULL,
+					pdqp);
+			goto retry;
+		}
 	}
 
 	xfs_fill_fsxattr(ip, false, &old_fa);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f1e21b6cfa48..907952009c2d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -660,6 +660,7 @@ xfs_setattr_nonsize(
 	kgid_t			gid = GLOBAL_ROOT_GID, igid = GLOBAL_ROOT_GID;
 	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
 	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
+	bool			quota_retry = false;
 
 	ASSERT((mask & ATTR_SIZE) == 0);
 
@@ -700,6 +701,7 @@ xfs_setattr_nonsize(
 			return error;
 	}
 
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
 		goto out_dqrele;
@@ -729,12 +731,20 @@ xfs_setattr_nonsize(
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
 		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
+			unsigned int	flags = 0;
+
+			if (capable(CAP_FOWNER))
+				flags |= XFS_QMOPT_FORCE_RES;
 			ASSERT(tp);
 			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						NULL, capable(CAP_FOWNER) ?
-						XFS_QMOPT_FORCE_RES : 0);
+					NULL, flags, &quota_retry);
 			if (error)	/* out of quota */
 				goto out_cancel;
+			if (quota_retry) {
+				xfs_trans_cancel_qretry_dquots(tp, ip, udqp,
+						gdqp, NULL);
+				goto retry;
+			}
 		}
 
 		/*
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c134eb4aeaa8..4e02609c063d 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1795,7 +1795,8 @@ xfs_qm_vop_chown(
 }
 
 /*
- * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).
+ * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).  This function has
+ * the same return behavior as xfs_trans_reserve_quota_nblks.
  */
 int
 xfs_qm_vop_chown_reserve(
@@ -1804,15 +1805,16 @@ xfs_qm_vop_chown_reserve(
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	uint			flags)
+	unsigned int		flags,
+	bool			*retry)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	uint64_t		delblks;
 	unsigned int		blkflags;
-	struct xfs_dquot	*udq_unres = NULL;
+	struct xfs_dquot	*udq_unres = NULL; /* old dquots */
 	struct xfs_dquot	*gdq_unres = NULL;
 	struct xfs_dquot	*pdq_unres = NULL;
-	struct xfs_dquot	*udq_delblks = NULL;
+	struct xfs_dquot	*udq_delblks = NULL; /* new dquots */
 	struct xfs_dquot	*gdq_delblks = NULL;
 	struct xfs_dquot	*pdq_delblks = NULL;
 	int			error;
@@ -1860,7 +1862,7 @@ xfs_qm_vop_chown_reserve(
 				udq_delblks, gdq_delblks, pdq_delblks,
 				ip->i_d.di_nblocks, 1, flags | blkflags);
 	if (error)
-		return error;
+		goto err;
 
 	/*
 	 * Do the delayed blks reservations/unreservations now. Since, these
@@ -1878,12 +1880,21 @@ xfs_qm_vop_chown_reserve(
 			    udq_delblks, gdq_delblks, pdq_delblks,
 			    (xfs_qcnt_t)delblks, 0, flags | blkflags);
 		if (error)
-			return error;
+			goto err;
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount,
 				udq_unres, gdq_unres, pdq_unres,
 				-((xfs_qcnt_t)delblks), 0, blkflags);
 	}
 
+	return 0;
+err:
+	/* We only allow one retry for EDQUOT/ENOSPC. */
+	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
+		*retry = false;
+		return error;
+	}
+
+	*retry = true;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index c5bbe7e3e259..42b79d0829f7 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -103,9 +103,9 @@ extern void xfs_qm_vop_create_dqattach(struct xfs_trans *, struct xfs_inode *,
 extern int xfs_qm_vop_rename_dqattach(struct xfs_inode **);
 extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
-extern int xfs_qm_vop_chown_reserve(struct xfs_trans *, struct xfs_inode *,
-		struct xfs_dquot *, struct xfs_dquot *,
-		struct xfs_dquot *, uint);
+int xfs_qm_vop_chown_reserve(struct xfs_trans *tp, struct xfs_inode *ip,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int flags, bool *retry);
 extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
@@ -189,7 +189,7 @@ xfs_trans_cancel_qretry_dquots(
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
-#define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl)			(0)
+#define xfs_qm_vop_chown_reserve(tp, ip, u, g, p, fl, retry)		(0)
 #define xfs_qm_dqattach(ip)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
