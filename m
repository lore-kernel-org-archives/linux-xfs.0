Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF44C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF1BF64DDB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhA1GD1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:03:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhA1GD0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:03:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1024F64DD9;
        Thu, 28 Jan 2021 06:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813790;
        bh=PJlk3qxzrnwoA9J9lm7//PGCAxhTKvM0I/wEcnbGbKE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jmj8l7Y+IxhST0vUlfARyyzwP6xRiwGzlKhE+/ooAmVAXiivGNdNwFBplb5W05U6V
         7Smq2KLrA2sqHh8p/94jOVW2I1aQEcSGG+90Nu6nZMxUGlI9EM16ErgODUnCOEo/v2
         xGLQowll8AME6vXa/j4QXoip9d9SY2Anln7xXTqDc7QSgIYLEh2pSxAlLnEvDgv/Dz
         OHN1p1mlWVWJQBDjfstLnEpfwsqFSUraotovHlfPRysVqiaZLpaJ8CNyWEAOWmA8bX
         A2fHVjRaw2+vWjfpqf6s4jRZz9VCwOXHAe76pgtwKVaUPngO8iIHbgGEoGs7wZbHeR
         5ScLZl9TqKWUQ==
Subject: [PATCH 08/11] xfs: flush eof/cowblocks if we can't reserve quota for
 chown
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:06 -0800
Message-ID: <161181378627.1525026.5498292649869722057.stgit@magnolia>
In-Reply-To: <161181374062.1525026.14717838769921652940.stgit@magnolia>
References: <161181374062.1525026.14717838769921652940.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Note that the retry loop is open-coded here because there are only two
places in the codebase where we ever change [ugp]id; and the setattr and
setxattr code is already tricky enough.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c       |    9 ++++++++-
 fs/xfs/xfs_iops.c        |   10 +++++++++-
 fs/xfs/xfs_quota.h       |   18 ++++++++++++++++--
 fs/xfs/xfs_trans_dquot.c |   46 ++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 75 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 73cfee8007a8..6adfc8541d61 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1436,6 +1436,7 @@ xfs_ioctl_setattr(
 	struct xfs_trans	*tp;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
+	unsigned int		quota_retry = 0;
 	int			code;
 
 	trace_xfs_ioctl_setattr(ip);
@@ -1462,6 +1463,7 @@ xfs_ioctl_setattr(
 
 	xfs_ioctl_setattr_prepare_dax(ip, fa);
 
+retry:
 	tp = xfs_ioctl_setattr_get_trans(ip);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);
@@ -1471,9 +1473,14 @@ xfs_ioctl_setattr(
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    ip->i_d.di_projid != fa->fsx_projid) {
 		code = xfs_trans_reserve_quota_chown(tp, ip, NULL, NULL, pdqp,
-				capable(CAP_FOWNER));
+				capable(CAP_FOWNER), &quota_retry);
 		if (code)	/* out of quota */
 			goto error_trans_cancel;
+		if (quota_retry) {
+			xfs_trans_cancel_qretry_chown(tp, ip, NULL, NULL,
+					pdqp);
+			goto retry;
+		}
 	}
 
 	xfs_fill_fsxattr(ip, false, &old_fa);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 51c877ce90bc..9453c984d715 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -660,6 +660,7 @@ xfs_setattr_nonsize(
 	kgid_t			gid = GLOBAL_ROOT_GID, igid = GLOBAL_ROOT_GID;
 	struct xfs_dquot	*udqp = NULL, *gdqp = NULL;
 	struct xfs_dquot	*olddquot1 = NULL, *olddquot2 = NULL;
+	unsigned int		quota_retry = 0;
 
 	ASSERT((mask & ATTR_SIZE) == 0);
 
@@ -700,6 +701,7 @@ xfs_setattr_nonsize(
 			return error;
 	}
 
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
 		goto out_dqrele;
@@ -731,9 +733,15 @@ xfs_setattr_nonsize(
 		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
 			ASSERT(tp);
 			error = xfs_trans_reserve_quota_chown(tp, ip, udqp,
-					gdqp, NULL, capable(CAP_FOWNER));
+					gdqp, NULL, capable(CAP_FOWNER),
+					&quota_retry);
 			if (error)	/* out of quota */
 				goto out_cancel;
+			if (quota_retry) {
+				xfs_trans_cancel_qretry_chown(tp, ip, udqp,
+						gdqp, NULL);
+				goto retry;
+			}
 		}
 
 		/*
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 7d87a1244256..4f45e7feb841 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -105,7 +105,10 @@ extern struct xfs_dquot *xfs_qm_vop_chown(struct xfs_trans *,
 		struct xfs_inode *, struct xfs_dquot **, struct xfs_dquot *);
 int xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, bool force);
+		struct xfs_dquot *pdqp, bool force, unsigned int *retry);
+void xfs_trans_cancel_qretry_chown(struct xfs_trans *tp, struct xfs_inode *ip,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp);
 extern int xfs_qm_dqattach(struct xfs_inode *);
 extern int xfs_qm_dqattach_locked(struct xfs_inode *ip, bool doalloc);
 extern void xfs_qm_dqdetach(struct xfs_inode *);
@@ -182,13 +185,24 @@ xfs_trans_cancel_qretry_icreate(
 	ASSERT(0);
 }
 
+static inline void
+xfs_trans_cancel_qretry_chown(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp)
+{
+	ASSERT(0);
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
 static inline int
 xfs_trans_reserve_quota_chown(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
-		struct xfs_dquot *pdqp, bool force)
+		struct xfs_dquot *pdqp, bool force, unsigned int *retry)
 {
 	return 0;
 }
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2358c9e35be8..7518424ee8b4 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -942,7 +942,15 @@ xfs_trans_cancel_qretry_icreate(
 }
 
 /*
- * Quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).
+ * Chagnge quota reservations for setattr(AT_UID|AT_GID|AT_PROJID).  This
+ * doesn't change the actual usage, just the reservation.  The caller must hold
+ * ILOCK_EXCL on the inode.  If @retry is not a NULL pointer, the caller must
+ * ensure that *retry is set to zero before the first time this function is
+ * called.
+ *
+ * If the quota reservation fails because we hit a quota limit (and retry is
+ * not a NULL pointer, and *retry is zero), this function will set *retry to
+ * nonzero and return zero.
  */
 int
 xfs_trans_reserve_quota_chown(
@@ -951,7 +959,8 @@ xfs_trans_reserve_quota_chown(
 	struct xfs_dquot	*udqp,
 	struct xfs_dquot	*gdqp,
 	struct xfs_dquot	*pdqp,
-	bool			force)
+	bool			force,
+	unsigned int		*retry)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_dquot	*udq_unres = NULL;	/* old dquots */
@@ -1011,7 +1020,7 @@ xfs_trans_reserve_quota_chown(
 			gdq_delblks, pdq_delblks, ip->i_d.di_nblocks, 1,
 			qflags);
 	if (error)
-		return error;
+		goto err;
 
 	/*
 	 * Do the delayed blks reservations/unreservations now. Since, these
@@ -1029,13 +1038,42 @@ xfs_trans_reserve_quota_chown(
 				udq_delblks, gdq_delblks, pdq_delblks,
 				(xfs_qcnt_t)delblks, 0, qflags);
 		if (error)
-			return error;
+			goto err;
 		xfs_trans_reserve_quota_bydquots(NULL, ip->i_mount, udq_unres,
 				gdq_unres, pdq_unres, -((xfs_qcnt_t)delblks),
 				0, qflags);
 	}
 
 	return 0;
+err:
+	/*
+	 * Handle all quota reservation failures in the same place because we
+	 * don't want the success predicate to clear REGBLKS from the retry
+	 * flags after we _reserve_quota for the ondisk blocks but before we
+	 * _reserve_quota for the delalloc blocks.  If we were called with a
+	 * nonzero *retry, that means we failed to get the quota reservation
+	 * once before and do not want to schedule a retry on a second error.
+	 */
+	reservation_success(XFS_QMOPT_RES_REGBLKS, retry, &error);
+	return error;
+}
+
+/*
+ * Cancel a transaction and try to clear some space so that we can reserve some
+ * quota.  When this function returns, the transaction will be cancelled and
+ * ILOCK_EXCL will no longer be held.
+ */
+void
+xfs_trans_cancel_qretry_chown(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp)
+{
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_blockgc_free_dquots(udqp, gdqp, pdqp, 0);
 }
 
 /*

