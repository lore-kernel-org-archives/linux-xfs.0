Return-Path: <SRS0=6LQP=Z3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5C7C2BD09
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF738224F8
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Dec 2019 17:50:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Iu1S648C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbfLERul (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Dec 2019 12:50:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55870 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730003AbfLERul (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Dec 2019 12:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575568239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pn59hpzLZ0CWZm0yivPD4N4smj7t8srx56HV+b6BHYA=;
        b=Iu1S648CzKuab0HyxooMuHV2JUSajzc8AzHBEvHVoDvSbrwEzI4zZr2wIRZKQWmntgMOyK
        cWf1KLXgLZJOQmoUWZ6ln/KQSp7v7vNKojenUpRM9vbQSMPbgeEyj35Ji4lX5kbyutk8Rd
        cVaRl50t1RuH/Nj69NVM9c2hSDSNR5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430--m6_tQM4MIuZ78aKJDxQ8Q-1; Thu, 05 Dec 2019 12:50:37 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2014FDBA3
        for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2019 17:50:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C092910013D9
        for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2019 17:50:36 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v4 1/2] xfs: automatic log item relog mechanism
Date:   Thu,  5 Dec 2019 12:50:36 -0500
Message-Id: <20191205175037.52529-2-bfoster@redhat.com>
In-Reply-To: <20191205175037.52529-1-bfoster@redhat.com>
References: <20191205175037.52529-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: -m6_tQM4MIuZ78aKJDxQ8Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is an AIL based mechanism to enable automatic relogging of
selected log items. The use case is for particular operations that
commit an item known to pin the tail of the log for a potentially
long period of time and otherwise cannot use a rolling transaction.
While this does not provide the deadlock avoidance guarantees of a
rolling transaction, it ties the relog transaction into AIL pushing
pressure such that we should expect the transaction to reserve the
necessary log space long before deadlock becomes a problem.

To enable relogging, a bit is set on the log item before it is first
committed to the log subsystem. Once the item commits to the on-disk
log and inserts to the AIL, AIL pushing dictates when the item is
ready for a relog. When that occurs, the item relogs in an
independent transaction to ensure the log tail keeps moving without
intervention from the original committer.  To disable relogging, the
original committer clears the log item bit and optionally waits on
relogging activity to cease if it needs to reuse the item before the
operation completes.

While the current use case for automatic relogging is limited, the
mechanism is AIL based because it 1.) provides existing callbacks
into all possible log item types for future support and 2.) has
applicable context to determine when to relog particular items (such
as when an item pins the log tail). This provides enough flexibility
to support various log item types and future workloads without
introducing complexity up front for currently unknown use cases.
Further complexity, such as preallocated or regranted relog
transaction reservation or custom relog handlers can be considered
as the need arises.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trace.h      |  1 +
 fs/xfs/xfs_trans.c      | 30 ++++++++++++++++++++++
 fs/xfs/xfs_trans.h      |  7 +++++-
 fs/xfs/xfs_trans_ail.c  | 56 +++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_trans_priv.h |  5 ++++
 5 files changed, 96 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c13bb3655e48..6c2a9cdadd03 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1063,6 +1063,7 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
+DEFINE_LOG_ITEM_EVENT(xfs_ail_relog);
=20
 DECLARE_EVENT_CLASS(xfs_ail_class,
 =09TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn=
),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865c..f2c06cdd1074 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -763,6 +763,35 @@ xfs_trans_del_item(
 =09list_del_init(&lip->li_trans);
 }
=20
+void
+xfs_trans_enable_relog(
+=09struct xfs_log_item=09*lip)
+{
+=09set_bit(XFS_LI_RELOG, &lip->li_flags);
+}
+
+void
+xfs_trans_disable_relog(
+=09struct xfs_log_item=09*lip,
+=09bool=09=09=09drain) /* wait for relogging to cease */
+{
+=09struct xfs_mount=09*mp =3D lip->li_mountp;
+
+=09clear_bit(XFS_LI_RELOG, &lip->li_flags);
+
+=09if (!drain)
+=09=09return;
+
+=09/*
+=09 * Some operations might require relog activity to cease before they ca=
n
+=09 * proceed. For example, an operation must wait before including a
+=09 * non-lockable log item (i.e. intent) in another transaction.
+=09 */
+=09while (wait_on_bit_timeout(&lip->li_flags, XFS_LI_RELOGGED,
+=09=09=09=09   TASK_UNINTERRUPTIBLE, HZ))
+=09=09xfs_log_force(mp, XFS_LOG_SYNC);
+}
+
 /* Detach and unlock all of the items in a transaction */
 static void
 xfs_trans_free_items(
@@ -848,6 +877,7 @@ xfs_trans_committed_bulk(
=20
 =09=09if (aborted)
 =09=09=09set_bit(XFS_LI_ABORTED, &lip->li_flags);
+=09=09clear_and_wake_up_bit(XFS_LI_RELOGGED, &lip->li_flags);
=20
 =09=09if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
 =09=09=09lip->li_ops->iop_release(lip);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..6d4311d82c4c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -59,12 +59,16 @@ struct xfs_log_item {
 #define=09XFS_LI_ABORTED=091
 #define=09XFS_LI_FAILED=092
 #define=09XFS_LI_DIRTY=093=09/* log item dirty in transaction */
+#define=09XFS_LI_RELOG=094=09/* automatic relogging */
+#define=09XFS_LI_RELOGGED=095=09/* relogged by xfsaild */
=20
 #define XFS_LI_FLAGS \
 =09{ (1 << XFS_LI_IN_AIL),=09=09"IN_AIL" }, \
 =09{ (1 << XFS_LI_ABORTED),=09"ABORTED" }, \
 =09{ (1 << XFS_LI_FAILED),=09=09"FAILED" }, \
-=09{ (1 << XFS_LI_DIRTY),=09=09"DIRTY" }
+=09{ (1 << XFS_LI_DIRTY),=09=09"DIRTY" }, \
+=09{ (1 << XFS_LI_RELOG),=09=09"RELOG" }, \
+=09{ (1 << XFS_LI_RELOGGED),=09"RELOGGED" }
=20
 struct xfs_item_ops {
 =09unsigned flags;
@@ -95,6 +99,7 @@ void=09xfs_log_item_init(struct xfs_mount *mp, struct xfs=
_log_item *item,
 #define XFS_ITEM_PINNED=09=091
 #define XFS_ITEM_LOCKED=09=092
 #define XFS_ITEM_FLUSHING=093
+#define XFS_ITEM_RELOG=09=094
=20
 /*
  * Deferred operation item relogging limits.
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 00cc5b8734be..bb54d00ae095 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -143,6 +143,38 @@ xfs_ail_max_lsn(
 =09return lsn;
 }
=20
+/*
+ * Relog log items on the AIL relog queue.
+ */
+static void
+xfs_ail_relog(
+=09struct work_struct=09*work)
+{
+=09struct xfs_ail=09=09*ailp =3D container_of(work, struct xfs_ail,
+=09=09=09=09=09=09     ail_relog_work);
+=09struct xfs_mount=09*mp =3D ailp->ail_mount;
+=09struct xfs_trans=09*tp;
+=09struct xfs_log_item=09*lip, *lipp;
+=09int=09=09=09error;
+
+=09/* XXX: define a ->tr_relog reservation */
+=09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp)=
;
+=09if (error)
+=09=09return;
+
+=09spin_lock(&ailp->ail_lock);
+=09list_for_each_entry_safe(lip, lipp, &ailp->ail_relog_list, li_trans) {
+=09=09list_del_init(&lip->li_trans);
+=09=09xfs_trans_add_item(tp, lip);
+=09=09set_bit(XFS_LI_DIRTY, &lip->li_flags);
+=09=09tp->t_flags |=3D XFS_TRANS_DIRTY;
+=09}
+=09spin_unlock(&ailp->ail_lock);
+
+=09error =3D xfs_trans_commit(tp);
+=09ASSERT(!error);
+}
+
 /*
  * The cursor keeps track of where our current traversal is up to by track=
ing
  * the next item in the list for us. However, for this to be safe, removin=
g an
@@ -363,7 +395,7 @@ static long
 xfsaild_push(
 =09struct xfs_ail=09=09*ailp)
 {
-=09xfs_mount_t=09=09*mp =3D ailp->ail_mount;
+=09struct xfs_mount=09*mp =3D ailp->ail_mount;
 =09struct xfs_ail_cursor=09cur;
 =09struct xfs_log_item=09*lip;
 =09xfs_lsn_t=09=09lsn;
@@ -425,6 +457,13 @@ xfsaild_push(
 =09=09=09ailp->ail_last_pushed_lsn =3D lsn;
 =09=09=09break;
=20
+=09=09case XFS_ITEM_RELOG:
+=09=09=09trace_xfs_ail_relog(lip);
+=09=09=09ASSERT(list_empty(&lip->li_trans));
+=09=09=09list_add_tail(&lip->li_trans, &ailp->ail_relog_list);
+=09=09=09set_bit(XFS_LI_RELOGGED, &lip->li_flags);
+=09=09=09break;
+
 =09=09case XFS_ITEM_FLUSHING:
 =09=09=09/*
 =09=09=09 * The item or its backing buffer is already being
@@ -491,6 +530,9 @@ xfsaild_push(
 =09if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
 =09=09ailp->ail_log_flush++;
=20
+=09if (!list_empty(&ailp->ail_relog_list))
+=09=09queue_work(ailp->ail_relog_wq, &ailp->ail_relog_work);
+
 =09if (!count || XFS_LSN_CMP(lsn, target) >=3D 0) {
 out_done:
 =09=09/*
@@ -834,15 +876,24 @@ xfs_trans_ail_init(
 =09spin_lock_init(&ailp->ail_lock);
 =09INIT_LIST_HEAD(&ailp->ail_buf_list);
 =09init_waitqueue_head(&ailp->ail_empty);
+=09INIT_LIST_HEAD(&ailp->ail_relog_list);
+=09INIT_WORK(&ailp->ail_relog_work, xfs_ail_relog);
+
+=09ailp->ail_relog_wq =3D alloc_workqueue("xfs-relog/%s", WQ_FREEZABLE, 0,
+=09=09=09=09=09     mp->m_super->s_id);
+=09if (!ailp->ail_relog_wq)
+=09=09goto out_free_ailp;
=20
 =09ailp->ail_task =3D kthread_run(xfsaild, ailp, "xfsaild/%s",
 =09=09=09ailp->ail_mount->m_super->s_id);
 =09if (IS_ERR(ailp->ail_task))
-=09=09goto out_free_ailp;
+=09=09goto out_destroy_wq;
=20
 =09mp->m_ail =3D ailp;
 =09return 0;
=20
+out_destroy_wq:
+=09destroy_workqueue(ailp->ail_relog_wq);
 out_free_ailp:
 =09kmem_free(ailp);
 =09return -ENOMEM;
@@ -855,5 +906,6 @@ xfs_trans_ail_destroy(
 =09struct xfs_ail=09*ailp =3D mp->m_ail;
=20
 =09kthread_stop(ailp->ail_task);
+=09destroy_workqueue(ailp->ail_relog_wq);
 =09kmem_free(ailp);
 }
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 2e073c1c4614..3cefc821350e 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -16,6 +16,8 @@ struct xfs_log_vec;
 void=09xfs_trans_init(struct xfs_mount *);
 void=09xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void=09xfs_trans_del_item(struct xfs_log_item *);
+void=09xfs_trans_enable_relog(struct xfs_log_item *);
+void=09xfs_trans_disable_relog(struct xfs_log_item *, bool);
 void=09xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
=20
 void=09xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *=
lv,
@@ -61,6 +63,9 @@ struct xfs_ail {
 =09int=09=09=09ail_log_flush;
 =09struct list_head=09ail_buf_list;
 =09wait_queue_head_t=09ail_empty;
+=09struct work_struct=09ail_relog_work;
+=09struct list_head=09ail_relog_list;
+=09struct workqueue_struct=09*ail_relog_wq;
 };
=20
 /*
--=20
2.20.1

