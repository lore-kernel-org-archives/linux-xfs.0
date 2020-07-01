Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A683DC433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F58520771
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Delhqv14"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732561AbgGAQv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:51:27 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49275 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732560AbgGAQvZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593622283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HdL0BFoz9++pln5KOWvrdUCVFVSfI7MbxyzXTOdrUBs=;
        b=Delhqv14L8lQbTY4/OKV//PXdSapvfHEfb7YnSdHUMirRpwqFL6VT5I9tH6nANMpJhFqMm
        kIEuHtOCDcN4qf7G982+Fe5NFk+mvbbQdzeePScMZ0AX5ukRdOdacDwFlfIqkBmck9RI99
        CFzSjPvV4cCch8YLi+SYXOUD7o1rQyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-v3bFQFxoOPeDMDjZXFj75A-1; Wed, 01 Jul 2020 12:51:19 -0400
X-MC-Unique: v3bFQFxoOPeDMDjZXFj75A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC117804003
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:18 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 886255C3FD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:18 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/10] xfs: relog log reservation stealing and accounting
Date:   Wed,  1 Jul 2020 12:51:10 -0400
Message-Id: <20200701165116.47344-5-bfoster@redhat.com>
In-Reply-To: <20200701165116.47344-1-bfoster@redhat.com>
References: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The transaction that eventually commits relog enabled log items
requires log reservation like any other transaction. It is not safe
to acquire reservation on-demand because relogged items aren't
processed until they are likely at the tail of the log and require
movement in order to free up space in the log. As such, a relog
transaction that blocks on log reservation is a likely deadlock
vector.

To address this problem, implement a model where relog reservation
is contributed by the transaction that enables relogging on a
particular item. Update the relog helper to transfer reservation
from the transaction to the relog pool. The relog pool holds
outstanding reservation such that it can be used to commit the item
in an otherwise empty transaction. The upcoming relog mechanism is
responsible to replenish the relog reservation as items are
relogged. When relog is cancelled on a log item, transfer the
outstanding relog reservation to the current transaction (if
provided) for eventual release or otherwise release it directly to
the grant heads.

Note that this approach has several caveats:

- Log reservation calculations for transactions that relog items
  must be increased accordingly.
- The currently per-transaction overhead reservation (i.e. for
  things like the CIL ticket) must be included for each reloggable
  item because said items can be relogged in arbitrary combinations.
- Relog reservation must be based on the worst case requirement for
  a log item. This is not a concern for fixed size log items, such
  as most intents. Items with more granular logging capability, such
  as buffers, can have additional ranges dirtied after relogging has
  been enabled and the relog subsystem must have enough reservation
  to accommodate.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c        |  3 +++
 fs/xfs/xfs_trans.c      | 20 ++++++++++++++++++++
 fs/xfs/xfs_trans.h      | 31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans_ail.c  |  2 ++
 fs/xfs/xfs_trans_priv.h | 14 ++++++++++++++
 5 files changed, 70 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b55abde6c142..940e5bb9786c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -983,6 +983,9 @@ xfs_log_item_init(
 	item->li_type = type;
 	item->li_ops = ops;
 	item->li_lv = NULL;
+#ifdef DEBUG
+	atomic64_set(&item->li_relog_res, 0);
+#endif
 
 	INIT_LIST_HEAD(&item->li_ail);
 	INIT_LIST_HEAD(&item->li_cil);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index cfa9915523e1..ba2540d8a6c9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -20,6 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_defer.h"
+#include "xfs_log_priv.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -657,9 +658,19 @@ xfs_trans_relog_item(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
+	int			nbytes;
+
+	ASSERT(tp->t_flags & XFS_TRANS_RELOG);
+
 	if (test_and_set_bit(XFS_LI_RELOG, &lip->li_flags))
 		return;
 	trace_xfs_relog_item(lip);
+
+	nbytes = xfs_relog_calc_res(lip);
+
+	tp->t_ticket->t_curr_res -= nbytes;
+	xfs_relog_res_account(lip, nbytes);
+	tp->t_flags |= XFS_TRANS_DIRTY;
 }
 
 void
@@ -667,9 +678,18 @@ xfs_trans_relog_item_cancel(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
+	int			res;
+
 	if (!test_and_clear_bit(XFS_LI_RELOG, &lip->li_flags))
 		return;
 	trace_xfs_relog_item_cancel(lip);
+
+	res = xfs_relog_calc_res(lip);
+	if (tp)
+		tp->t_ticket->t_curr_res += res;
+	else
+		xfs_log_ungrant_bytes(lip->li_mountp, res);
+	xfs_relog_res_account(lip, -res);
 }
 
 /* Detach and unlock all of the items in a transaction */
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 6349e78af002..70373e2b8f6d 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -48,6 +48,9 @@ struct xfs_log_item {
 	struct xfs_log_vec		*li_lv;		/* active log vector */
 	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
 	xfs_lsn_t			li_seq;		/* CIL commit seq */
+#ifdef DEBUG
+	atomic64_t			li_relog_res;	/* automatic relog log res */
+#endif
 };
 
 /*
@@ -216,6 +219,34 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
 
+/*
+ * Calculate the log reservation required to enable relogging of a log item.
+ */
+static inline int
+xfs_relog_calc_res(
+	struct xfs_log_item	*lip)
+{
+	int			niovecs = 0;
+	int			nbytes = 0;
+
+	/*
+	 * The reservation consumed by a transaction at commit time consists of
+	 * the total size of the formatted log vectors of the items dirtied by
+	 * the transaction, an op header for each iovec in the log vectors, the
+	 * unit reservation of the CIL context ticket, and extra iclog and op
+	 * headers if the CIL context spans multiple iclogs (i.e. split
+	 * reservation). The CIL ticket and split reservation are included by
+	 * xfs_log_calc_unit_res().
+	 */
+	lip->li_ops->iop_size(lip, &niovecs, &nbytes);
+	ASSERT(niovecs == 1);
+
+	nbytes += niovecs * sizeof(xlog_op_header_t);
+	nbytes = xfs_log_calc_unit_res(lip->li_mountp, nbytes);
+
+	return nbytes;
+}
+
 struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index ac5019361a13..5c862821171f 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -894,6 +894,7 @@ xfs_trans_ail_init(
 	spin_lock_init(&ailp->ail_lock);
 	INIT_LIST_HEAD(&ailp->ail_buf_list);
 	init_waitqueue_head(&ailp->ail_empty);
+	atomic64_set(&ailp->ail_relog_res, 0);
 
 	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
 			ailp->ail_mount->m_super->s_id);
@@ -914,6 +915,7 @@ xfs_trans_ail_destroy(
 {
 	struct xfs_ail	*ailp = mp->m_ail;
 
+	ASSERT(atomic64_read(&ailp->ail_relog_res) == 0);
 	kthread_stop(ailp->ail_task);
 	kmem_free(ailp);
 }
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 64965a861346..d923e79676af 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -63,6 +63,7 @@ struct xfs_ail {
 	int			ail_log_flush;
 	struct list_head	ail_buf_list;
 	wait_queue_head_t	ail_empty;
+	atomic64_t		ail_relog_res;
 };
 
 /*
@@ -169,4 +170,17 @@ xfs_set_li_failed(
 	}
 }
 
+static inline int64_t
+xfs_relog_res_account(
+	struct xfs_log_item	*lip,
+	int64_t			bytes)
+{
+#ifdef DEBUG
+	int64_t			res;
+
+	res = atomic64_add_return(bytes, &lip->li_relog_res);
+	ASSERT(res == bytes || (bytes < 0 && res == 0));
+#endif
+	return atomic64_add_return(bytes, &lip->li_ailp->ail_relog_res);
+}
 #endif	/* __XFS_TRANS_PRIV_H__ */
-- 
2.21.3

