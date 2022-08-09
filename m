Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E880C25B07
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 11:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239078AbiHILRW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 07:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbiHILRV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 07:17:21 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC67192A8;
        Tue,  9 Aug 2022 04:17:19 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v5so6174916wmj.0;
        Tue, 09 Aug 2022 04:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=wqu91t20S23kbYPCbfrCuB5xGg3ldmbMM60Sol5+oDM=;
        b=VLO2J1W96dfFetQFqgq8EVEyeJ2mD3yFX9xDZJ3+nyuV7NwnipS98+0JRoBSqQ6e/k
         BFgttMlVlpJuWp22z54teoERabcJpw+HzU6NhFiBpTHxgQ/aC+rh9dLdlqPP4LvYJWgk
         N6bi+SYPBwfmMJFngB3PmKXLTtEeKCBrNOjwUWo7pWIsP+chRC6sietKVg188E0WOaCs
         Vq92XTh2PHDnDhiSaSbOUonFG/8ISsiaxW3eYNuhLim8WwlEUzXxCcEsWH6CSYAwRp2c
         jY2+jxWa3uzF6rQAZyjfwRfg5rYO6kL5l9l9+eR3XowLZZ4luALF/5NRGb6HJ2bN0ywa
         l7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=wqu91t20S23kbYPCbfrCuB5xGg3ldmbMM60Sol5+oDM=;
        b=YGr5i0g8TZVKXkll4mm6YJJGsYrVCaeuN9rYFWyyrsxeOv9FgEbmS+4Grnjpydzgha
         opYLX00FH6AXJAeulLvz+dy15h0SlGIwBlCwbcnjHnWypSYk64qfOjPQ2qrwlMGBeYNX
         r2NbeOO9WUZ8YlhytaRqEEMLLWs9C1eE6SwvaUGX2uhAt6JPB0yevXWTWZasH4OVIN+k
         FYMwC2RpNGF0lEoHB0k3roYgDdKDnzGbN8JfyN6e4c3WdY9kUcOXsIxgR21QhRHpxw5q
         h6qDXwM/aoYQSAUYKmsvUKCpZ0DZs3y+1CH+ebrYN9YrzTVbJj8C6tFzM/6i8gqEjD5u
         A8Tg==
X-Gm-Message-State: ACgBeo2vyI6yLbLdADBf68CUNIcfbYp5nLTz2Pwq+0arX3cosjVY9jTw
        4ZhCbOxiivY/dOBJ+yXvo5AkatpwS04=
X-Google-Smtp-Source: AA6agR47S8tGsvLx2oxiZ+4qAHdvH3bFbmTjD1Bdnv0+NmaL2mAeYBGCUcS1nauxXwq4u5Dp45NTXQ==
X-Received: by 2002:a7b:c852:0:b0:3a5:407a:76df with SMTP id c18-20020a7bc852000000b003a5407a76dfmr5590966wml.101.1660043838240;
        Tue, 09 Aug 2022 04:17:18 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id l2-20020a1ced02000000b003a3170a7af9sm15906169wmh.4.2022.08.09.04.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 04:17:17 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 1/4] xfs: remove support for disabling quota accounting on a mounted file system
Date:   Tue,  9 Aug 2022 13:17:05 +0200
Message-Id: <20220809111708.92768-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809111708.92768-1-amir73il@gmail.com>
References: <20220809111708.92768-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 40b52225e58cd3adf9358146b4b39dccfbfe5892 upstream.

Disabling quota accounting is hairy, racy code with all kinds of pitfalls.
And it has a very strange mind set, as quota accounting (unlike
enforcement) really is a propery of the on-disk format.  There is no good
use case for supporting this.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |  30 -----
 fs/xfs/libxfs/xfs_trans_resv.h |   2 -
 fs/xfs/xfs_dquot_item.c        | 134 ------------------
 fs/xfs/xfs_dquot_item.h        |  17 ---
 fs/xfs/xfs_qm.c                |   2 +-
 fs/xfs/xfs_qm.h                |   1 -
 fs/xfs/xfs_qm_syscalls.c       | 240 ++-------------------------------
 fs/xfs/xfs_trans_dquot.c       |  38 ------
 8 files changed, 13 insertions(+), 451 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d1a0848cb52e..ce12c8142bd1 100644
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
index 7241ab28cf84..fc4e9b369a3a 100644
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
index 8ed47b739b6c..6a1aae799cf1 100644
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
index 2b86a43d7ce2..794710c24474 100644
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
index 64e5da33733b..4fbf97b37bb9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -183,7 +183,7 @@ xfs_qm_dqpurge(
 /*
  * Purge the dquot cache.
  */
-void
+static void
 xfs_qm_dqpurge_all(
 	struct xfs_mount	*mp,
 	uint			flags)
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index e3dabab44097..bf21f31e6482 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -141,7 +141,6 @@ struct xfs_dquot_acct {
 extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
 
 /* dquot stuff */
-extern void		xfs_qm_dqpurge_all(struct xfs_mount *, uint);
 extern void		xfs_qm_dqrele_all_inodes(struct xfs_mount *, uint);
 
 /* quota ops */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index ca1b57d291dc..b02ca6a5483c 100644
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
@@ -111,159 +31,23 @@ xfs_qm_scall_quotaoff(
 	 */
 	if ((mp->m_qflags & flags) == 0)
 		return -EEXIST;
-	error = 0;
-
-	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
-
-	/*
-	 * We don't want to deal with two quotaoffs messing up each other,
-	 * so we're going to serialize it. quotaoff isn't exactly a performance
-	 * critical thing.
-	 * If quotaoff, then we must be dealing with the root filesystem.
-	 */
-	ASSERT(q);
-	mutex_lock(&q->qi_quotaofflock);
-
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
-	xfs_qm_dqrele_all_inodes(mp, flags);
-
-	/*
-	 * Next we make the changes in the quota flag in the mount struct.
-	 * This isn't protected by a particular lock directly, because we
-	 * don't want to take a mrlock every time we depend on quotas being on.
-	 */
-	mp->m_qflags &= ~flags;
 
 	/*
-	 * Go through all the dquots of this file system and purge them,
-	 * according to what was turned off.
+	 * We do not support actually turning off quota accounting any more.
+	 * Just log a warning and ignore the accounting related flags.
 	 */
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
+	if (flags & XFS_ALL_QUOTA_ACCT)
+		xfs_info(mp, "disabling of quota accounting not supported.");
 
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
index fe45b0c3970c..482e27786da8 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -825,44 +825,6 @@ xfs_trans_reserve_quota_nblks(
 						nblks, ninos, flags);
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
2.25.1

