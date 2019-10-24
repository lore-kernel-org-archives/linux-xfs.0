Return-Path: <SRS0=feM8=YR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D2BCA9EAF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 17:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B422720659
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Oct 2019 17:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nm9wzC4T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394032AbfJXR25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Oct 2019 13:28:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60165 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2394031AbfJXR24 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 13:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571938134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=kC8ZEQUjaeFONMGe5QMeXnRAt0ehDsqTBvupQ2+jIzE=;
        b=Nm9wzC4TVDWF/08/qZZ5k077vaaSB6U/l3tGUz+sEmPbkcsA33TnRpOm7wJEtDSTBqGudI
        9rR70OmgmzkfYsmTMeFY+FOQ+bHixW3ZuxKKfGd9JcfdsIsZqQJSgcJw6XErVGAbtTfoiO
        ZWJw1xOCh9Tiiv++Phn8iN05zLzHdHM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-150-i6KZ8rg9NPWjUHccOghDZg-1; Thu, 24 Oct 2019 13:28:52 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D0F7107AD31
        for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2019 17:28:51 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38E8660BE0
        for <linux-xfs@vger.kernel.org>; Thu, 24 Oct 2019 17:28:51 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC] xfs: automatic log item relogging experiment
Date:   Thu, 24 Oct 2019 13:28:50 -0400
Message-Id: <20191024172850.7698-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: i6KZ8rg9NPWjUHccOghDZg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

An experimental mechanism to automatically relog specified log
items.  This is useful for long running operations, like quotaoff,
that otherwise risk deadlocking on log space usage.

Not-signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This is an experiment that came out of a discussion with Darrick[1] on
some design bits of the latest online btree repair work. Specifically,
it logs free intents in the same transaction as block allocation to
guard against inconsistency in the event of a crash during the repair
sequence. These intents happen pin the log tail for an indeterminate
amount of time. Darrick was looking for some form of auto relog
mechanism to facilitate this general approach. It occurred to us that
this is the same problem we've had with quotaoff for some time, so I
figured it might be worth prototyping something against that to try and
prove the concept.

Note that this is RFC because the code and interfaces are a complete
mess and this is broken in certain ways. This occasionally triggers log
reservation overrun shutdowns because transaction reservation checking
has not yet been added, the cancellation path is overkill, etc. IOW, the
purpose of this patch is purely to test a concept.

The concept is essentially to flag a log item for relogging on first
transaction commit such that once it commits to the AIL, the next
transaction that happens to commit with sufficient unused reservation
opportunistically relogs the item to the current CIL context. For the
log intent case, the transaction that commits the done item is required
to cancel the relog state of the original intent to prevent further
relogging.

In practice, this allows a log item to automatically roll through CIL
checkpoints and not pin the tail of the log while something like a
quotaoff is running for a potentially long period of time. This is
applied to quotaoff and focused testing shows that it avoids the
associated deadlock.

Thoughts, reviews, flames appreciated.

[1] https://lore.kernel.org/linux-xfs/20191018143856.GA25763@bfoster/

 fs/xfs/xfs_log_cil.c     | 69 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_priv.h    |  6 ++++
 fs/xfs/xfs_qm_syscalls.c | 13 ++++++++
 fs/xfs/xfs_trace.h       |  2 ++
 fs/xfs/xfs_trans.c       |  4 +++
 fs/xfs/xfs_trans.h       |  4 ++-
 6 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index a1204424a938..b2d8b2d54df6 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -75,6 +75,33 @@ xlog_cil_iovec_space(
 =09=09=09sizeof(uint64_t));
 }
=20
+static void
+xlog_cil_relog_items(
+=09struct xlog=09=09*log,
+=09struct xfs_trans=09*tp)
+{
+=09struct xfs_cil=09=09*cil =3D log->l_cilp;
+=09struct xfs_log_item=09*lip;
+
+=09ASSERT(tp->t_flags & XFS_TRANS_DIRTY);
+
+=09if (list_empty(&cil->xc_relog))
+=09=09return;
+
+=09/* XXX: need to check trans reservation, process multiple items, etc. *=
/
+=09spin_lock(&cil->xc_relog_lock);
+=09lip =3D list_first_entry_or_null(&cil->xc_relog, struct xfs_log_item, l=
i_cil);
+=09if (lip)
+=09=09list_del_init(&lip->li_cil);
+=09spin_unlock(&cil->xc_relog_lock);
+
+=09if (lip) {
+=09=09xfs_trans_add_item(tp, lip);
+=09=09set_bit(XFS_LI_DIRTY, &lip->li_flags);
+=09=09trace_xfs_cil_relog(lip);
+=09}
+}
+
 /*
  * Allocate or pin log vector buffers for CIL insertion.
  *
@@ -1001,6 +1028,8 @@ xfs_log_commit_cil(
 =09struct xfs_log_item=09*lip, *next;
 =09xfs_lsn_t=09=09xc_commit_lsn;
=20
+=09xlog_cil_relog_items(log, tp);
+
 =09/*
 =09 * Do all necessary memory allocation before we lock the CIL.
 =09 * This ensures the allocation does not deadlock with a CIL
@@ -1196,6 +1225,8 @@ xlog_cil_init(
 =09spin_lock_init(&cil->xc_push_lock);
 =09init_rwsem(&cil->xc_ctx_lock);
 =09init_waitqueue_head(&cil->xc_commit_wait);
+=09INIT_LIST_HEAD(&cil->xc_relog);
+=09spin_lock_init(&cil->xc_relog_lock);
=20
 =09INIT_LIST_HEAD(&ctx->committing);
 =09INIT_LIST_HEAD(&ctx->busy_extents);
@@ -1223,3 +1254,41 @@ xlog_cil_destroy(
 =09kmem_free(log->l_cilp);
 }
=20
+void
+xfs_cil_relog_item(
+=09struct xlog=09=09*log,
+=09struct xfs_log_item=09*lip)
+{
+=09struct xfs_cil=09=09*cil =3D log->l_cilp;
+
+=09ASSERT(test_bit(XFS_LI_RELOG, &lip->li_flags));
+=09ASSERT(list_empty(&lip->li_cil));
+
+=09spin_lock(&cil->xc_relog_lock);
+=09list_add_tail(&lip->li_cil, &cil->xc_relog);
+=09spin_unlock(&cil->xc_relog_lock);
+
+=09trace_xfs_cil_relog_queue(lip);
+}
+
+bool
+xfs_cil_relog_steal(
+=09struct xlog=09=09*log,
+=09struct xfs_log_item=09*lip)
+{
+=09struct xfs_cil=09=09*cil =3D log->l_cilp;
+=09struct xfs_log_item=09*pos, *ppos;
+=09bool=09=09=09ret =3D false;
+
+=09spin_lock(&cil->xc_relog_lock);
+=09list_for_each_entry_safe(pos, ppos, &cil->xc_relog, li_cil) {
+=09=09if (pos =3D=3D lip) {
+=09=09=09list_del_init(&pos->li_cil);
+=09=09=09ret =3D true;
+=09=09=09break;
+=09=09}
+=09}
+=09spin_unlock(&cil->xc_relog_lock);
+
+=09return ret;
+}
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 4f19375f6592..f75a0a9f6984 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -10,6 +10,7 @@ struct xfs_buf;
 struct xlog;
 struct xlog_ticket;
 struct xfs_mount;
+struct xfs_log_item;
=20
 /*
  * Flags for log structure
@@ -275,6 +276,9 @@ struct xfs_cil {
 =09wait_queue_head_t=09xc_commit_wait;
 =09xfs_lsn_t=09=09xc_current_sequence;
 =09struct work_struct=09xc_push_work;
+
+=09struct list_head=09xc_relog;
+=09spinlock_t=09=09xc_relog_lock;
 } ____cacheline_aligned_in_smp;
=20
 /*
@@ -511,6 +515,8 @@ int=09xlog_cil_init(struct xlog *log);
 void=09xlog_cil_init_post_recovery(struct xlog *log);
 void=09xlog_cil_destroy(struct xlog *log);
 bool=09xlog_cil_empty(struct xlog *log);
+void=09xfs_cil_relog_item(struct xlog *log, struct xfs_log_item *lip);
+bool=09xfs_cil_relog_steal(struct xlog *log, struct xfs_log_item *lip);
=20
 /*
  * CIL force routines
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index da7ad0383037..5e529190029d 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -18,6 +18,8 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_icache.h"
+#include "xfs_log_priv.h"
+#include "xfs_trans_priv.h"
=20
 STATIC int=09xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uin=
t);
 STATIC int=09xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
@@ -556,6 +558,16 @@ xfs_qm_log_quotaoff_end(
 =09=09=09=09=09flags & XFS_ALL_QUOTA_ACCT);
 =09xfs_trans_log_quotaoff_item(tp, qoffi);
=20
+=09/*
+=09 * XXX: partly open coded relog of the start item to ensure no reloggin=
g
+=09 * after this point.
+=09 */
+=09clear_bit(XFS_LI_RELOG, &startqoff->qql_item.li_flags);
+=09if (xfs_cil_relog_steal(mp->m_log, &startqoff->qql_item)) {
+=09=09xfs_trans_add_item(tp, &startqoff->qql_item);
+=09=09xfs_trans_log_quotaoff_item(tp, startqoff);
+=09}
+
 =09/*
 =09 * We have to make sure that the transaction is secure on disk before w=
e
 =09 * return and actually stop quota accounting. So, make it synchronous.
@@ -583,6 +595,7 @@ xfs_qm_log_quotaoff(
 =09=09goto out;
=20
 =09qoffi =3D xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT)=
;
+=09set_bit(XFS_LI_RELOG, &qoffi->qql_item.li_flags);
 =09xfs_trans_log_quotaoff_item(tp, qoffi);
=20
 =09spin_lock(&mp->m_sb_lock);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 926f4d10dc02..6fe31a00e362 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1063,6 +1063,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
+DEFINE_LOG_ITEM_EVENT(xfs_cil_relog);
+DEFINE_LOG_ITEM_EVENT(xfs_cil_relog_queue);
=20
 DECLARE_EVENT_CLASS(xfs_ail_class,
 =09TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn=
),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f4795fdb7389..95c74c6de4e2 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -19,6 +19,7 @@
 #include "xfs_trace.h"
 #include "xfs_error.h"
 #include "xfs_defer.h"
+#include "xfs_log_priv.h"
=20
 kmem_zone_t=09*xfs_trans_zone;
=20
@@ -863,6 +864,9 @@ xfs_trans_committed_bulk(
 =09=09if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) =3D=3D 0)
 =09=09=09continue;
=20
+=09=09if (test_bit(XFS_LI_RELOG, &lip->li_flags))
+=09=09=09xfs_cil_relog_item(lip->li_mountp->m_log, lip);
+
 =09=09/*
 =09=09 * if we are aborting the operation, no point in inserting the
 =09=09 * object into the AIL as we are in a shutdown situation.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..596102405acf 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -59,12 +59,14 @@ struct xfs_log_item {
 #define=09XFS_LI_ABORTED=091
 #define=09XFS_LI_FAILED=092
 #define=09XFS_LI_DIRTY=093=09/* log item dirty in transaction */
+#define XFS_LI_RELOG=094=09/* relog item on checkpoint commit */
=20
 #define XFS_LI_FLAGS \
 =09{ (1 << XFS_LI_IN_AIL),=09=09"IN_AIL" }, \
 =09{ (1 << XFS_LI_ABORTED),=09"ABORTED" }, \
 =09{ (1 << XFS_LI_FAILED),=09=09"FAILED" }, \
-=09{ (1 << XFS_LI_DIRTY),=09=09"DIRTY" }
+=09{ (1 << XFS_LI_DIRTY),=09=09"DIRTY" }, \
+=09{ (1 << XFS_LI_RELOG),=09=09"RELOG" }
=20
 struct xfs_item_ops {
 =09unsigned flags;
--=20
2.20.1

