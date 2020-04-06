Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25336C2BA80
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2CE221D94
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1OV/sEq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgDFMgk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26064 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727982AbgDFMgj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xqoa2BOZfE5IyDOoGdc3Y5li6iMDuFdv/q7/FB8ATb4=;
        b=a1OV/sEqGD9Q2ENa2FvuXIndFIYlP/PW7jM//HrKPxhTh1pWgqMN/p+aK/cPY0yebWVOoe
        +5T+/b/sQiKbKwbCzM2C4dZB2eTBqdAXcRGIzwFaSjVKOe80zfAM8Kx50WiEHTHMHeKbQH
        eRVjWp5VXnxjt0YYWbua9k85gI5wuRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-Fh35_43lOCeOtQmGwO6pIw-1; Mon, 06 Apr 2020 08:36:36 -0400
X-MC-Unique: Fh35_43lOCeOtQmGwO6pIw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70AE1107ACC9
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:35 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24A7860BFB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:35 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 04/10] xfs: relog log reservation stealing and accounting
Date:   Mon,  6 Apr 2020 08:36:26 -0400
Message-Id: <20200406123632.20873-5-bfoster@redhat.com>
In-Reply-To: <20200406123632.20873-1-bfoster@redhat.com>
References: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
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
- Each current transaction reservation includes extra space for
  various overheads, such as for the CIL ticket, etc. Since items
  can be relogged in arbitrary combinations, this reservation
  overhead must be included for each relogged item.
- Relog reservation must be based on the worst case log requirement
  for the lifetime of an item. This is not a concern for fixed size
  log items, such as most intents. More granular log items like
  buffers can have additional ranges dirtied after relogging has
  been enabled for the item and the relog subsystem must have
  enough reservation to accommodate.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c        |  3 +++
 fs/xfs/xfs_trans.c      | 20 ++++++++++++++++++++
 fs/xfs/xfs_trans.h      | 17 +++++++++++++++++
 fs/xfs/xfs_trans_ail.c  |  2 ++
 fs/xfs/xfs_trans_priv.h | 14 ++++++++++++++
 5 files changed, 56 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b55abde6c142..940e5bb9786c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -983,6 +983,9 @@ xfs_log_item_init(
 	item->li_type =3D type;
 	item->li_ops =3D ops;
 	item->li_lv =3D NULL;
+#ifdef DEBUG
+	atomic64_set(&item->li_relog_res, 0);
+#endif
=20
 	INIT_LIST_HEAD(&item->li_ail);
 	INIT_LIST_HEAD(&item->li_cil);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 1b25980315bd..6fc81c3b8500 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -20,6 +20,7 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_defer.h"
+#include "xfs_log_priv.h"
=20
 kmem_zone_t	*xfs_trans_zone;
=20
@@ -776,9 +777,19 @@ xfs_trans_relog_item(
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
+	nbytes =3D xfs_relog_calc_res(lip);
+
+	tp->t_ticket->t_curr_res -=3D nbytes;
+	xfs_relog_res_account(lip, nbytes);
+	tp->t_flags |=3D XFS_TRANS_DIRTY;
 }
=20
 void
@@ -786,9 +797,18 @@ xfs_trans_relog_item_cancel(
 	struct xfs_trans	*tp,
 	struct xfs_log_item	*lip)
 {
+	int			res;
+
 	if (!test_and_clear_bit(XFS_LI_RELOG, &lip->li_flags))
 		return;
 	trace_xfs_relog_item_cancel(lip);
+
+	res =3D xfs_relog_calc_res(lip);
+	if (tp)
+		tp->t_ticket->t_curr_res +=3D res;
+	else
+		xfs_log_ungrant_bytes(lip->li_mountp, res);
+	xfs_relog_res_account(lip, -res);
 }
=20
 /* Detach and unlock all of the items in a transaction */
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9ea0f415e5ca..b4bb2a6c5251 100644
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
=20
 /*
@@ -212,6 +215,20 @@ xfs_trans_read_buf(
 				      flags, bpp, ops);
 }
=20
+static inline int
+xfs_relog_calc_res(
+	struct xfs_log_item	*lip)
+{
+	int			niovecs =3D 0;
+	int			nbytes =3D 0;
+
+	lip->li_ops->iop_size(lip, &niovecs, &nbytes);
+	ASSERT(niovecs =3D=3D 1);
+	nbytes =3D xfs_log_calc_unit_res(lip->li_mountp, nbytes);
+
+	return nbytes;
+}
+
 struct xfs_buf	*xfs_trans_getsb(xfs_trans_t *, struct xfs_mount *);
=20
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 564253550b75..0b4b1c3cc4de 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -861,6 +861,7 @@ xfs_trans_ail_init(
 	spin_lock_init(&ailp->ail_lock);
 	INIT_LIST_HEAD(&ailp->ail_buf_list);
 	init_waitqueue_head(&ailp->ail_empty);
+	atomic64_set(&ailp->ail_relog_res, 0);
=20
 	ailp->ail_task =3D kthread_run(xfsaild, ailp, "xfsaild/%s",
 			ailp->ail_mount->m_super->s_id);
@@ -881,6 +882,7 @@ xfs_trans_ail_destroy(
 {
 	struct xfs_ail	*ailp =3D mp->m_ail;
=20
+	ASSERT(atomic64_read(&ailp->ail_relog_res) =3D=3D 0);
 	kthread_stop(ailp->ail_task);
 	kmem_free(ailp);
 }
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index c890794314a6..926bafdf6cd7 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -63,6 +63,7 @@ struct xfs_ail {
 	int			ail_log_flush;
 	struct list_head	ail_buf_list;
 	wait_queue_head_t	ail_empty;
+	atomic64_t		ail_relog_res;
 };
=20
 /*
@@ -182,4 +183,17 @@ xfs_set_li_failed(
 	}
 }
=20
+static inline int64_t
+xfs_relog_res_account(
+	struct xfs_log_item	*lip,
+	int64_t			bytes)
+{
+#ifdef DEBUG
+	int64_t			res;
+
+	res =3D atomic64_add_return(bytes, &lip->li_relog_res);
+	ASSERT(res =3D=3D bytes || (bytes < 0 && res =3D=3D 0));
+#endif
+	return atomic64_add_return(bytes, &lip->li_ailp->ail_relog_res);
+}
 #endif	/* __XFS_TRANS_PRIV_H__ */
--=20
2.21.1

