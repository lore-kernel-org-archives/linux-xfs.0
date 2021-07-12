Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B8FC07E99
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C321760FF1
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jul 2021 11:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbhGLLSl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jul 2021 07:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbhGLLRx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jul 2021 07:17:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CEAC0613E5
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jul 2021 04:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        Content-Type:Content-ID:Content-Description;
        bh=lqQfrBNIGbTq82AbxfSYLuNu+kdyL5stX6BtgLmWcU4=; b=p6fvnVFImB7MA2+wkJnw5q2Lr5
        Z7kSPlSds1Q8iMouwFND6OAhV8YUaIDDRZCeFdiFFKN+4TgTtmxFpEgm4RW9w+RGGU8OUA9ijr2+y
        2HyPIkq5kQZZgRtaPX9a6kyWOWEu1e1V+Qh+mvdeWgflG5EC+rbQXiAbMLYQ5ObhgAVkR6xepIOAm
        eelxKe8rmDawILkCK3WilVCFSddDa4nDz0ndpzur7Tk5hTbjfiVpFTw+pfbuxn9+MrGFy3cGJJWx8
        97MZK51Gs3VjtoXDCq2aixMwVDSm6UBjWVRd2NlYo1/l+RovVO6ZE8gY7WLH4wnNnA9QJl1tUsPm0
        qDYq7Tvg==;
Received: from [2001:4bb8:184:8b7c:bd9:61b8:39ba:d78a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2tte-00HXON-FY
        for linux-xfs@vger.kernel.org; Mon, 12 Jul 2021 11:14:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: remove support for disabling quota accounting on a mounted file system
Date:   Mon, 12 Jul 2021 13:14:24 +0200
Message-Id: <20210712111426.83004-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210712111426.83004-1-hch@lst.de>
References: <20210712111426.83004-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Disabling quota accounting is hairy, racy code with all kinds of pitfalls.
And it has a very strange mind set, as quota accounting (unlike
enforcement) really is a propery of the on-disk format.  There is no good
use case for supporting this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_trans_resv.c |  30 ----
 fs/xfs/libxfs/xfs_trans_resv.h |   2 -
 fs/xfs/xfs_dquot_item.c        | 134 ------------------
 fs/xfs/xfs_dquot_item.h        |  17 ---
 fs/xfs/xfs_qm.c                |   2 +-
 fs/xfs/xfs_qm.h                |   3 -
 fs/xfs/xfs_qm_syscalls.c       | 241 ++-------------------------------
 fs/xfs/xfs_trans_dquot.c       |  38 ------
 8 files changed, 13 insertions(+), 454 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d1a0848cb52eca..ce12c8142bd18e 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -798,29 +798,6 @@ xfs_calc_qm_dqalloc_reservation(
 			XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB) - 1);
 }
 
-/*
- * Turning off quotas.
- *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
- *    the superblock for the quota flags: sector size
- */
-STATIC uint
-xfs_calc_qm_quotaoff_reservation(
-	struct xfs_mount	*mp)
-{
-	return sizeof(struct xfs_qoff_logitem) * 2 +
-		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
-}
-
-/*
- * End of turning off quotas.
- *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
- */
-STATIC uint
-xfs_calc_qm_quotaoff_end_reservation(void)
-{
-	return sizeof(struct xfs_qoff_logitem) * 2;
-}
-
 /*
  * Syncing the incore super block changes to disk.
  *     the super block to reflect the changes: sector size
@@ -923,13 +900,6 @@ xfs_trans_resv_calc(
 	resp->tr_qm_setqlim.tr_logres = xfs_calc_qm_setqlim_reservation();
 	resp->tr_qm_setqlim.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
-	resp->tr_qm_quotaoff.tr_logres = xfs_calc_qm_quotaoff_reservation(mp);
-	resp->tr_qm_quotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
-
-	resp->tr_qm_equotaoff.tr_logres =
-		xfs_calc_qm_quotaoff_end_reservation();
-	resp->tr_qm_equotaoff.tr_logcount = XFS_DEFAULT_LOG_COUNT;
-
 	resp->tr_sb.tr_logres = xfs_calc_sb_reservation(mp);
 	resp->tr_sb.tr_logcount = XFS_DEFAULT_LOG_COUNT;
 
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 7241ab28cf84fe..fc4e9b369a3ae6 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -46,8 +46,6 @@ struct xfs_trans_resv {
 	struct xfs_trans_res	tr_growrtfree;	/* grow realtime freeing */
 	struct xfs_trans_res	tr_qm_setqlim;	/* adjust quota limits */
 	struct xfs_trans_res	tr_qm_dqalloc;	/* allocate quota on disk */
-	struct xfs_trans_res	tr_qm_quotaoff;	/* turn quota off */
-	struct xfs_trans_res	tr_qm_equotaoff;/* end of turn quota off */
 	struct xfs_trans_res	tr_sb;		/* modify superblock */
 	struct xfs_trans_res	tr_fsyncts;	/* update timestamps on fsync */
 };
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 8ed47b739b6ccc..6a1aae799cf16d 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -218,137 +218,3 @@ xfs_qm_dquot_logitem_init(
 					&xfs_dquot_item_ops);
 	lp->qli_dquot = dqp;
 }
-
-/*------------------  QUOTAOFF LOG ITEMS  -------------------*/
-
-static inline struct xfs_qoff_logitem *QOFF_ITEM(struct xfs_log_item *lip)
-{
-	return container_of(lip, struct xfs_qoff_logitem, qql_item);
-}
-
-
-/*
- * This returns the number of iovecs needed to log the given quotaoff item.
- * We only need 1 iovec for an quotaoff item.  It just logs the
- * quotaoff_log_format structure.
- */
-STATIC void
-xfs_qm_qoff_logitem_size(
-	struct xfs_log_item	*lip,
-	int			*nvecs,
-	int			*nbytes)
-{
-	*nvecs += 1;
-	*nbytes += sizeof(struct xfs_qoff_logitem);
-}
-
-STATIC void
-xfs_qm_qoff_logitem_format(
-	struct xfs_log_item	*lip,
-	struct xfs_log_vec	*lv)
-{
-	struct xfs_qoff_logitem	*qflip = QOFF_ITEM(lip);
-	struct xfs_log_iovec	*vecp = NULL;
-	struct xfs_qoff_logformat *qlf;
-
-	qlf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_QUOTAOFF);
-	qlf->qf_type = XFS_LI_QUOTAOFF;
-	qlf->qf_size = 1;
-	qlf->qf_flags = qflip->qql_flags;
-	xlog_finish_iovec(lv, vecp, sizeof(struct xfs_qoff_logitem));
-}
-
-/*
- * There isn't much you can do to push a quotaoff item.  It is simply
- * stuck waiting for the log to be flushed to disk.
- */
-STATIC uint
-xfs_qm_qoff_logitem_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	return XFS_ITEM_LOCKED;
-}
-
-STATIC xfs_lsn_t
-xfs_qm_qoffend_logitem_committed(
-	struct xfs_log_item	*lip,
-	xfs_lsn_t		lsn)
-{
-	struct xfs_qoff_logitem	*qfe = QOFF_ITEM(lip);
-	struct xfs_qoff_logitem	*qfs = qfe->qql_start_lip;
-
-	xfs_qm_qoff_logitem_relse(qfs);
-
-	kmem_free(lip->li_lv_shadow);
-	kmem_free(qfe);
-	return (xfs_lsn_t)-1;
-}
-
-STATIC void
-xfs_qm_qoff_logitem_release(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_qoff_logitem	*qoff = QOFF_ITEM(lip);
-
-	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
-		if (qoff->qql_start_lip)
-			xfs_qm_qoff_logitem_relse(qoff->qql_start_lip);
-		xfs_qm_qoff_logitem_relse(qoff);
-	}
-}
-
-static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
-	.iop_size	= xfs_qm_qoff_logitem_size,
-	.iop_format	= xfs_qm_qoff_logitem_format,
-	.iop_committed	= xfs_qm_qoffend_logitem_committed,
-	.iop_push	= xfs_qm_qoff_logitem_push,
-	.iop_release	= xfs_qm_qoff_logitem_release,
-};
-
-static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
-	.iop_size	= xfs_qm_qoff_logitem_size,
-	.iop_format	= xfs_qm_qoff_logitem_format,
-	.iop_push	= xfs_qm_qoff_logitem_push,
-	.iop_release	= xfs_qm_qoff_logitem_release,
-};
-
-/*
- * Delete the quotaoff intent from the AIL and free it. On success,
- * this should only be called for the start item. It can be used for
- * either on shutdown or abort.
- */
-void
-xfs_qm_qoff_logitem_relse(
-	struct xfs_qoff_logitem	*qoff)
-{
-	struct xfs_log_item	*lip = &qoff->qql_item;
-
-	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
-	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
-	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
-	xfs_trans_ail_delete(lip, 0);
-	kmem_free(lip->li_lv_shadow);
-	kmem_free(qoff);
-}
-
-/*
- * Allocate and initialize an quotaoff item of the correct quota type(s).
- */
-struct xfs_qoff_logitem *
-xfs_qm_qoff_logitem_init(
-	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	*start,
-	uint			flags)
-{
-	struct xfs_qoff_logitem	*qf;
-
-	qf = kmem_zalloc(sizeof(struct xfs_qoff_logitem), 0);
-
-	xfs_log_item_init(mp, &qf->qql_item, XFS_LI_QUOTAOFF, start ?
-			&xfs_qm_qoffend_logitem_ops : &xfs_qm_qoff_logitem_ops);
-	qf->qql_item.li_mountp = mp;
-	qf->qql_start_lip = start;
-	qf->qql_flags = flags;
-	return qf;
-}
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 2b86a43d7ce2ec..794710c2447493 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -9,7 +9,6 @@
 struct xfs_dquot;
 struct xfs_trans;
 struct xfs_mount;
-struct xfs_qoff_logitem;
 
 struct xfs_dq_logitem {
 	struct xfs_log_item	qli_item;	/* common portion */
@@ -17,22 +16,6 @@ struct xfs_dq_logitem {
 	xfs_lsn_t		qli_flush_lsn;	/* lsn at last flush */
 };
 
-struct xfs_qoff_logitem {
-	struct xfs_log_item	qql_item;	/* common portion */
-	struct xfs_qoff_logitem *qql_start_lip;	/* qoff-start logitem, if any */
-	unsigned int		qql_flags;
-};
-
-
 void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
-struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
-		struct xfs_qoff_logitem *start,
-		uint flags);
-void xfs_qm_qoff_logitem_relse(struct xfs_qoff_logitem *);
-struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
-		struct xfs_qoff_logitem *startqoff,
-		uint flags);
-void xfs_trans_log_quotaoff_item(struct xfs_trans *tp,
-		struct xfs_qoff_logitem *qlp);
 
 #endif	/* __XFS_DQUOT_ITEM_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index fe341f3fd41901..580b9dba21122b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -185,7 +185,7 @@ xfs_qm_dqpurge(
 /*
  * Purge the dquot cache.
  */
-void
+static void
 xfs_qm_dqpurge_all(
 	struct xfs_mount	*mp,
 	uint			flags)
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index ebbb484c49dc7e..442a0f97a9d439 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -140,9 +140,6 @@ struct xfs_dquot_acct {
 
 extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
 
-/* dquot stuff */
-extern void		xfs_qm_dqpurge_all(struct xfs_mount *, uint);
-
 /* quota ops */
 extern int		xfs_qm_scall_trunc_qfiles(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_getquota(struct xfs_mount *mp,
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 13a56e1ea15ce1..e00067a142a094 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,91 +19,11 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
 
-STATIC int
-xfs_qm_log_quotaoff(
-	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	**qoffstartp,
-	uint			flags)
-{
-	struct xfs_trans	*tp;
-	int			error;
-	struct xfs_qoff_logitem	*qoffi;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
-	if (error)
-		goto out;
-
-	qoffi = xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT);
-	xfs_trans_log_quotaoff_item(tp, qoffi);
-
-	spin_lock(&mp->m_sb_lock);
-	mp->m_sb.sb_qflags = (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
-	spin_unlock(&mp->m_sb_lock);
-
-	xfs_log_sb(tp);
-
-	/*
-	 * We have to make sure that the transaction is secure on disk before we
-	 * return and actually stop quota accounting. So, make it synchronous.
-	 * We don't care about quotoff's performance.
-	 */
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp);
-	if (error)
-		goto out;
-
-	*qoffstartp = qoffi;
-out:
-	return error;
-}
-
-STATIC int
-xfs_qm_log_quotaoff_end(
-	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	**startqoff,
-	uint			flags)
-{
-	struct xfs_trans	*tp;
-	int			error;
-	struct xfs_qoff_logitem	*qoffi;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
-	if (error)
-		return error;
-
-	qoffi = xfs_trans_get_qoff_item(tp, *startqoff,
-					flags & XFS_ALL_QUOTA_ACCT);
-	xfs_trans_log_quotaoff_item(tp, qoffi);
-	*startqoff = NULL;
-
-	/*
-	 * We have to make sure that the transaction is secure on disk before we
-	 * return and actually stop quota accounting. So, make it synchronous.
-	 * We don't care about quotoff's performance.
-	 */
-	xfs_trans_set_sync(tp);
-	return xfs_trans_commit(tp);
-}
-
-/*
- * Turn off quota accounting and/or enforcement for all udquots and/or
- * gdquots. Called only at unmount time.
- *
- * This assumes that there are no dquots of this file system cached
- * incore, and modifies the ondisk dquot directly. Therefore, for example,
- * it is an error to call this twice, without purging the cache.
- */
 int
 xfs_qm_scall_quotaoff(
 	xfs_mount_t		*mp,
 	uint			flags)
 {
-	struct xfs_quotainfo	*q = mp->m_quotainfo;
-	uint			dqtype;
-	int			error;
-	uint			inactivate_flags;
-	struct xfs_qoff_logitem	*qoffstart = NULL;
-
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
 	 * Note that quota utilities (like quotaoff) _expect_
@@ -111,160 +31,23 @@ xfs_qm_scall_quotaoff(
 	 */
 	if ((mp->m_qflags & flags) == 0)
 		return -EEXIST;
-	error = 0;
-
-	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
 
 	/*
-	 * We don't want to deal with two quotaoffs messing up each other,
-	 * so we're going to serialize it. quotaoff isn't exactly a performance
-	 * critical thing.
-	 * If quotaoff, then we must be dealing with the root filesystem.
+	 * We do not support actually turning off quota accounting any more.
+	 * Just log a warning and ignored the accounting related flags.
 	 */
-	ASSERT(q);
-	mutex_lock(&q->qi_quotaofflock);
+	if (flags & XFS_ALL_QUOTA_ACCT)
+		xfs_info(mp, "disabling of quota accounting not supported.");
 
-	/*
-	 * If we're just turning off quota enforcement, change mp and go.
-	 */
-	if ((flags & XFS_ALL_QUOTA_ACCT) == 0) {
-		mp->m_qflags &= ~(flags);
-
-		spin_lock(&mp->m_sb_lock);
-		mp->m_sb.sb_qflags = mp->m_qflags;
-		spin_unlock(&mp->m_sb_lock);
-		mutex_unlock(&q->qi_quotaofflock);
-
-		/* XXX what to do if error ? Revert back to old vals incore ? */
-		return xfs_sync_sb(mp, false);
-	}
-
-	dqtype = 0;
-	inactivate_flags = 0;
-	/*
-	 * If accounting is off, we must turn enforcement off, clear the
-	 * quota 'CHKD' certificate to make it known that we have to
-	 * do a quotacheck the next time this quota is turned on.
-	 */
-	if (flags & XFS_UQUOTA_ACCT) {
-		dqtype |= XFS_QMOPT_UQUOTA;
-		flags |= (XFS_UQUOTA_CHKD | XFS_UQUOTA_ENFD);
-		inactivate_flags |= XFS_UQUOTA_ACTIVE;
-	}
-	if (flags & XFS_GQUOTA_ACCT) {
-		dqtype |= XFS_QMOPT_GQUOTA;
-		flags |= (XFS_GQUOTA_CHKD | XFS_GQUOTA_ENFD);
-		inactivate_flags |= XFS_GQUOTA_ACTIVE;
-	}
-	if (flags & XFS_PQUOTA_ACCT) {
-		dqtype |= XFS_QMOPT_PQUOTA;
-		flags |= (XFS_PQUOTA_CHKD | XFS_PQUOTA_ENFD);
-		inactivate_flags |= XFS_PQUOTA_ACTIVE;
-	}
-
-	/*
-	 * Nothing to do?  Don't complain. This happens when we're just
-	 * turning off quota enforcement.
-	 */
-	if ((mp->m_qflags & flags) == 0)
-		goto out_unlock;
-
-	/*
-	 * Write the LI_QUOTAOFF log record, and do SB changes atomically,
-	 * and synchronously. If we fail to write, we should abort the
-	 * operation as it cannot be recovered safely if we crash.
-	 */
-	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
-	if (error)
-		goto out_unlock;
-
-	/*
-	 * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
-	 * to take care of the race between dqget and quotaoff. We don't take
-	 * any special locks to reset these bits. All processes need to check
-	 * these bits *after* taking inode lock(s) to see if the particular
-	 * quota type is in the process of being turned off. If *ACTIVE, it is
-	 * guaranteed that all dquot structures and all quotainode ptrs will all
-	 * stay valid as long as that inode is kept locked.
-	 *
-	 * There is no turning back after this.
-	 */
-	mp->m_qflags &= ~inactivate_flags;
-
-	/*
-	 * Give back all the dquot reference(s) held by inodes.
-	 * Here we go thru every single incore inode in this file system, and
-	 * do a dqrele on the i_udquot/i_gdquot that it may have.
-	 * Essentially, as long as somebody has an inode locked, this guarantees
-	 * that quotas will not be turned off. This is handy because in a
-	 * transaction once we lock the inode(s) and check for quotaon, we can
-	 * depend on the quota inodes (and other things) being valid as long as
-	 * we keep the lock(s).
-	 */
-	error = xfs_dqrele_all_inodes(mp, flags);
-	ASSERT(!error);
-
-	/*
-	 * Next we make the changes in the quota flag in the mount struct.
-	 * This isn't protected by a particular lock directly, because we
-	 * don't want to take a mrlock every time we depend on quotas being on.
-	 */
-	mp->m_qflags &= ~flags;
-
-	/*
-	 * Go through all the dquots of this file system and purge them,
-	 * according to what was turned off.
-	 */
-	xfs_qm_dqpurge_all(mp, dqtype);
-
-	/*
-	 * Transactions that had started before ACTIVE state bit was cleared
-	 * could have logged many dquots, so they'd have higher LSNs than
-	 * the first QUOTAOFF log record does. If we happen to crash when
-	 * the tail of the log has gone past the QUOTAOFF record, but
-	 * before the last dquot modification, those dquots __will__
-	 * recover, and that's not good.
-	 *
-	 * So, we have QUOTAOFF start and end logitems; the start
-	 * logitem won't get overwritten until the end logitem appears...
-	 */
-	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
-	if (error) {
-		/* We're screwed now. Shutdown is the only option. */
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		goto out_unlock;
-	}
-
-	/*
-	 * If all quotas are completely turned off, close shop.
-	 */
-	if (mp->m_qflags == 0) {
-		mutex_unlock(&q->qi_quotaofflock);
-		xfs_qm_destroy_quotainfo(mp);
-		return 0;
-	}
-
-	/*
-	 * Release our quotainode references if we don't need them anymore.
-	 */
-	if ((dqtype & XFS_QMOPT_UQUOTA) && q->qi_uquotaip) {
-		xfs_irele(q->qi_uquotaip);
-		q->qi_uquotaip = NULL;
-	}
-	if ((dqtype & XFS_QMOPT_GQUOTA) && q->qi_gquotaip) {
-		xfs_irele(q->qi_gquotaip);
-		q->qi_gquotaip = NULL;
-	}
-	if ((dqtype & XFS_QMOPT_PQUOTA) && q->qi_pquotaip) {
-		xfs_irele(q->qi_pquotaip);
-		q->qi_pquotaip = NULL;
-	}
+	mutex_lock(&mp->m_quotainfo->qi_quotaofflock);
+	mp->m_qflags &= ~(flags & XFS_ALL_QUOTA_ENFD);
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_qflags = mp->m_qflags;
+	spin_unlock(&mp->m_sb_lock);
+	mutex_unlock(&mp->m_quotainfo->qi_quotaofflock);
 
-out_unlock:
-	if (error && qoffstart)
-		xfs_qm_qoff_logitem_relse(qoffstart);
-	mutex_unlock(&q->qi_quotaofflock);
-	return error;
+	/* XXX what to do if error ? Revert back to old vals incore ? */
+	return xfs_sync_sb(mp, false);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 48e09ea30ee539..b7e4b05a559bdb 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -843,44 +843,6 @@ xfs_trans_reserve_quota_icreate(
 			dblocks, 1, XFS_QMOPT_RES_REGBLKS);
 }
 
-/*
- * This routine is called to allocate a quotaoff log item.
- */
-struct xfs_qoff_logitem *
-xfs_trans_get_qoff_item(
-	struct xfs_trans	*tp,
-	struct xfs_qoff_logitem	*startqoff,
-	uint			flags)
-{
-	struct xfs_qoff_logitem	*q;
-
-	ASSERT(tp != NULL);
-
-	q = xfs_qm_qoff_logitem_init(tp->t_mountp, startqoff, flags);
-	ASSERT(q != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &q->qql_item);
-	return q;
-}
-
-
-/*
- * This is called to mark the quotaoff logitem as needing
- * to be logged when the transaction is committed.  The logitem must
- * already be associated with the given transaction.
- */
-void
-xfs_trans_log_quotaoff_item(
-	struct xfs_trans	*tp,
-	struct xfs_qoff_logitem	*qlp)
-{
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
-}
-
 STATIC void
 xfs_trans_alloc_dqinfo(
 	xfs_trans_t	*tp)
-- 
2.30.2

