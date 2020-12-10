Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95D5C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 15:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C48123BE5
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Dec 2020 15:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbgLJPKR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Dec 2020 10:10:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46462 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391659AbgLJOrm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Dec 2020 09:47:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607611574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fKNomnAFTTOKrWab3r7X/KDNNbCd6qD9rsgGVqV2YyM=;
        b=Ru3g/DV+oDGSLEZCNtt6vKZf3IQFXEi7wy1HWP2UnOVheX42RbnVLdDTOF6ifTe6y+/JLp
        3ZkYKtlW8tN0jLtp+wgM8IaTRlwWjHzrL+u8IYwCZg85GasKPtlZRrV453jqkFgwCgYkdO
        HgXYPPqu8iXzxcISI+HyEpSnaU8/XFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-smY8caPMPyG6Pr2cE1JfWA-1; Thu, 10 Dec 2020 09:46:12 -0500
X-MC-Unique: smY8caPMPyG6Pr2cE1JfWA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69DE1802EA6
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 14:46:11 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-184.rdu2.redhat.com [10.10.112.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E4B719714
        for <linux-xfs@vger.kernel.org>; Thu, 10 Dec 2020 14:46:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: rename xfs_wait_buftarg() to xfs_buftarg_drain()
Date:   Thu, 10 Dec 2020 09:46:06 -0500
Message-Id: <20201210144607.1922026-2-bfoster@redhat.com>
In-Reply-To: <20201210144607.1922026-1-bfoster@redhat.com>
References: <20201210144607.1922026-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_wait_buftarg() is vaguely named and somewhat overloaded. Its
primary purpose is to reclaim all buffers from the provided buffer
target LRU. In preparation to refactor xfs_wait_buftarg() into
serialization and LRU draining components, rename the function and
associated helpers to something more descriptive. This patch has no
functional changes with the minor exception of renaming a
tracepoint.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c   | 12 ++++++------
 fs/xfs/xfs_buf.h   | 10 +++++-----
 fs/xfs/xfs_log.c   |  6 +++---
 fs/xfs/xfs_mount.c |  4 ++--
 fs/xfs/xfs_trace.h |  2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4e4cf91f4f9f..db918ed20c40 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -43,7 +43,7 @@ static kmem_zone_t *xfs_buf_zone;
  *	  pag_buf_lock
  *	    lru_lock
  *
- * xfs_buftarg_wait_rele
+ * xfs_buftarg_drain_rele
  *	lru_lock
  *	  b_lock (trylock due to inversion)
  *
@@ -88,7 +88,7 @@ xfs_buf_vmap_len(
  * because the corresponding decrement is deferred to buffer release. Buffers
  * can undergo I/O multiple times in a hold-release cycle and per buffer I/O
  * tracking adds unnecessary overhead. This is used for sychronization purposes
- * with unmount (see xfs_wait_buftarg()), so all we really need is a count of
+ * with unmount (see xfs_buftarg_drain()), so all we really need is a count of
  * in-flight buffers.
  *
  * Buffers that are never released (e.g., superblock, iclog buffers) must set
@@ -1786,7 +1786,7 @@ __xfs_buf_mark_corrupt(
  * while freeing all the buffers only held by the LRU.
  */
 static enum lru_status
-xfs_buftarg_wait_rele(
+xfs_buftarg_drain_rele(
 	struct list_head	*item,
 	struct list_lru_one	*lru,
 	spinlock_t		*lru_lock,
@@ -1798,7 +1798,7 @@ xfs_buftarg_wait_rele(
 
 	if (atomic_read(&bp->b_hold) > 1) {
 		/* need to wait, so skip it this pass */
-		trace_xfs_buf_wait_buftarg(bp, _RET_IP_);
+		trace_xfs_buf_drain_buftarg(bp, _RET_IP_);
 		return LRU_SKIP;
 	}
 	if (!spin_trylock(&bp->b_lock))
@@ -1816,7 +1816,7 @@ xfs_buftarg_wait_rele(
 }
 
 void
-xfs_wait_buftarg(
+xfs_buftarg_drain(
 	struct xfs_buftarg	*btp)
 {
 	LIST_HEAD(dispose);
@@ -1841,7 +1841,7 @@ xfs_wait_buftarg(
 
 	/* loop until there is nothing left on the lru list. */
 	while (list_lru_count(&btp->bt_lru)) {
-		list_lru_walk(&btp->bt_lru, xfs_buftarg_wait_rele,
+		list_lru_walk(&btp->bt_lru, xfs_buftarg_drain_rele,
 			      &dispose, LONG_MAX);
 
 		while (!list_empty(&dispose)) {
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index bfd2907e7bc4..ea32369f8f77 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -152,7 +152,7 @@ typedef struct xfs_buf {
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
 	struct xfs_mount	*b_mount;
-	xfs_buftarg_t		*b_target;	/* buffer target (device) */
+	struct xfs_buftarg	*b_target;	/* buffer target (device) */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_ioend_work;
 	struct completion	b_iowait;	/* queue for I/O waiters */
@@ -344,11 +344,11 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 /*
  *	Handling of buftargs.
  */
-extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
-			struct block_device *, struct dax_device *);
+extern struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *,
+		struct block_device *, struct dax_device *);
 extern void xfs_free_buftarg(struct xfs_buftarg *);
-extern void xfs_wait_buftarg(xfs_buftarg_t *);
-extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
+extern void xfs_buftarg_drain(struct xfs_buftarg *);
+extern int xfs_setsize_buftarg(struct xfs_buftarg *, unsigned int);
 
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index fa2d05e65ff1..5ad4d5e78019 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -741,7 +741,7 @@ xfs_log_mount_finish(
 		xfs_log_force(mp, XFS_LOG_SYNC);
 		xfs_ail_push_all_sync(mp->m_ail);
 	}
-	xfs_wait_buftarg(mp->m_ddev_targp);
+	xfs_buftarg_drain(mp->m_ddev_targp);
 
 	if (readonly)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
@@ -936,13 +936,13 @@ xfs_log_quiesce(
 
 	/*
 	 * The superblock buffer is uncached and while xfs_ail_push_all_sync()
-	 * will push it, xfs_wait_buftarg() will not wait for it. Further,
+	 * will push it, xfs_buftarg_drain() will not wait for it. Further,
 	 * xfs_buf_iowait() cannot be used because it was pushed with the
 	 * XBF_ASYNC flag set, so we need to use a lock/unlock pair to wait for
 	 * the IO to complete.
 	 */
 	xfs_ail_push_all_sync(mp->m_ail);
-	xfs_wait_buftarg(mp->m_ddev_targp);
+	xfs_buftarg_drain(mp->m_ddev_targp);
 	xfs_buf_lock(mp->m_sb_bp);
 	xfs_buf_unlock(mp->m_sb_bp);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7110507a2b6b..29a553f0877d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1023,8 +1023,8 @@ xfs_mountfs(
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
-		xfs_wait_buftarg(mp->m_logdev_targp);
-	xfs_wait_buftarg(mp->m_ddev_targp);
+		xfs_buftarg_drain(mp->m_logdev_targp);
+	xfs_buftarg_drain(mp->m_ddev_targp);
  out_free_perag:
 	xfs_free_perag(mp);
  out_free_dir:
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 86951652d3ed..7b4d8a5f2a49 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -340,7 +340,7 @@ DEFINE_BUF_EVENT(xfs_buf_get_uncached);
 DEFINE_BUF_EVENT(xfs_buf_item_relse);
 DEFINE_BUF_EVENT(xfs_buf_iodone_async);
 DEFINE_BUF_EVENT(xfs_buf_error_relse);
-DEFINE_BUF_EVENT(xfs_buf_wait_buftarg);
+DEFINE_BUF_EVENT(xfs_buf_drain_buftarg);
 DEFINE_BUF_EVENT(xfs_trans_read_buf_shut);
 
 /* not really buffer traces, but the buf provides useful information */
-- 
2.26.2

