Return-Path: <SRS0=T9vs=ZR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3A8C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 18:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D244A20748
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 18:55:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XJI0QeTj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfKYSz0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Nov 2019 13:55:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26835 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725862AbfKYSz0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Nov 2019 13:55:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574708124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6fdvRT/T3OPctytI8835JiMImc9HnLMlSaVbctkLGKw=;
        b=XJI0QeTjs9nlpAPOX107wygxek19ZVnlL2oUEr19CWfZFFKSUeoo2XfN0MWxQi8D+jOtpZ
        ToTRftRQwdGfaCRln+GlgcIOjZ7Xq8bHXcZZv55GY7E5uqxpOsZc46dEX7+K7CXIr4wGdf
        DckacoefsESwa3nZ6360xJB/pnKqXdI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-DTyAhtBsPgeWuMYk6dv1sA-1; Mon, 25 Nov 2019 13:55:23 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D291FDBA5
        for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2019 18:55:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C5D3608B8
        for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2019 18:55:22 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v3 PATCH] xfs: automatic relogging experiment
Date:   Mon, 25 Nov 2019 13:55:23 -0500
Message-Id: <20191125185523.47556-1-bfoster@redhat.com>
In-Reply-To: <20191122181927.32870-1-bfoster@redhat.com>
References: <20191122181927.32870-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: DTyAhtBsPgeWuMYk6dv1sA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

POC to automatically relog the quotaoff start intent. This approach
involves no reservation stealing nor transaction rolling, so
deadlock avoidance is not guaranteed. The tradeoff is simplicity and
an approach that might be effective enough in practice.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Here's a quickly hacked up version of what I was rambling about in the
cover letter. I wanted to post this for comparison. As noted above, this
doesn't necessarily guarantee deadlock avoidance with transaction
rolling, etc., but might be good enough in practice for the current use
cases (particularly with CIL context size fixes). Even if not, there's a
clear enough path to tracking relog reservation with a ticket in the CIL
context in a manner that is more conducive to batching. We also may be
able to union ->li_cb() with a ->li_relog() variant to relog intent
items as dfops currently does for things like EFIs that don't currently
support direct relogging of the same object.

Thoughts about using something like this as an intermediate solution,
provided it holds up against some stress testing?

Brian

 fs/xfs/xfs_log.c         |  1 +
 fs/xfs/xfs_log_cil.c     | 50 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_log_priv.h    |  2 ++
 fs/xfs/xfs_qm_syscalls.c |  6 +++++
 fs/xfs/xfs_trans.h       |  5 +++-
 5 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6a147c63a8a6..4fb3c3156ea2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1086,6 +1086,7 @@ xfs_log_item_init(
 =09INIT_LIST_HEAD(&item->li_cil);
 =09INIT_LIST_HEAD(&item->li_bio_list);
 =09INIT_LIST_HEAD(&item->li_trans);
+=09INIT_LIST_HEAD(&item->li_ril);
 }
=20
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 48435cf2aa16..c16ebc448a40 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -19,6 +19,44 @@
=20
 struct workqueue_struct *xfs_discard_wq;
=20
+static void
+xfs_relog_worker(
+=09struct work_struct=09*work)
+{
+=09struct xfs_cil_ctx=09*ctx =3D container_of(work, struct xfs_cil_ctx, re=
log_work);
+=09struct xfs_mount=09*mp =3D ctx->cil->xc_log->l_mp;
+=09struct xfs_trans=09*tp;
+=09struct xfs_log_item=09*lip, *lipp;
+=09int=09=09=09error;
+
+=09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp)=
;
+=09ASSERT(!error);
+
+=09list_for_each_entry_safe(lip, lipp, &ctx->relog_list, li_ril) {
+=09=09list_del_init(&lip->li_ril);
+
+=09=09if (!test_bit(XFS_LI_RELOG, &lip->li_flags))
+=09=09=09continue;
+
+=09=09xfs_trans_add_item(tp, lip);
+=09=09set_bit(XFS_LI_DIRTY, &lip->li_flags);
+=09=09tp->t_flags |=3D XFS_TRANS_DIRTY;
+=09}
+
+=09error =3D xfs_trans_commit(tp);
+=09ASSERT(!error);
+
+=09/* XXX */
+=09kmem_free(ctx);
+}
+
+static void
+xfs_relog_queue(
+=09struct xfs_cil_ctx=09*ctx)
+{
+=09queue_work(xfs_discard_wq, &ctx->relog_work);
+}
+
 /*
  * Allocate a new ticket. Failing to get a new ticket makes it really hard=
 to
  * recover, so we don't allow failure here. Also, we allocate in a context=
 that
@@ -476,6 +514,9 @@ xlog_cil_insert_items(
 =09=09 */
 =09=09if (!list_is_last(&lip->li_cil, &cil->xc_cil))
 =09=09=09list_move_tail(&lip->li_cil, &cil->xc_cil);
+
+=09=09if (test_bit(XFS_LI_RELOG, &lip->li_flags))
+=09=09=09list_move_tail(&lip->li_ril, &ctx->relog_list);
 =09}
=20
 =09spin_unlock(&cil->xc_cil_lock);
@@ -605,7 +646,10 @@ xlog_cil_committed(
=20
 =09xlog_cil_free_logvec(ctx->lv_chain);
=20
-=09if (!list_empty(&ctx->busy_extents))
+=09/* XXX: mutually exclusive w/ discard for POC to handle ctx freeing */
+=09if (!list_empty(&ctx->relog_list))
+=09=09xfs_relog_queue(ctx);
+=09else if (!list_empty(&ctx->busy_extents))
 =09=09xlog_discard_busy_extents(mp, ctx);
 =09else
 =09=09kmem_free(ctx);
@@ -746,8 +790,10 @@ xlog_cil_push(
 =09 */
 =09INIT_LIST_HEAD(&new_ctx->committing);
 =09INIT_LIST_HEAD(&new_ctx->busy_extents);
+=09INIT_LIST_HEAD(&new_ctx->relog_list);
 =09new_ctx->sequence =3D ctx->sequence + 1;
 =09new_ctx->cil =3D cil;
+=09INIT_WORK(&new_ctx->relog_work, xfs_relog_worker);
 =09cil->xc_ctx =3D new_ctx;
=20
 =09/*
@@ -1199,6 +1245,8 @@ xlog_cil_init(
=20
 =09INIT_LIST_HEAD(&ctx->committing);
 =09INIT_LIST_HEAD(&ctx->busy_extents);
+=09INIT_LIST_HEAD(&ctx->relog_list);
+=09INIT_WORK(&ctx->relog_work, xfs_relog_worker);
 =09ctx->sequence =3D 1;
 =09ctx->cil =3D cil;
 =09cil->xc_ctx =3D ctx;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b192c5a9f9fd..6fd7b7297bd3 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -243,6 +243,8 @@ struct xfs_cil_ctx {
 =09struct list_head=09iclog_entry;
 =09struct list_head=09committing;=09/* ctx committing list */
 =09struct work_struct=09discard_endio_work;
+=09struct list_head=09relog_list;
+=09struct work_struct=09relog_work;
 };
=20
 /*
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1ea82764bf89..08b6180cb5a3 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -18,6 +18,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_icache.h"
+#include "xfs_log.h"
=20
 STATIC int
 xfs_qm_log_quotaoff(
@@ -37,6 +38,7 @@ xfs_qm_log_quotaoff(
=20
 =09qoffi =3D xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACCT)=
;
 =09xfs_trans_log_quotaoff_item(tp, qoffi);
+=09set_bit(XFS_LI_RELOG, &qoffi->qql_item.li_flags);
=20
 =09spin_lock(&mp->m_sb_lock);
 =09mp->m_sb.sb_qflags =3D (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_ALL;
@@ -69,6 +71,10 @@ xfs_qm_log_quotaoff_end(
 =09int=09=09=09error;
 =09struct xfs_qoff_logitem=09*qoffi;
=20
+=09clear_bit(XFS_LI_RELOG, &startqoff->qql_item.li_flags);
+=09xfs_log_force(mp, XFS_LOG_SYNC);
+=09flush_workqueue(xfs_discard_wq);
+
 =09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp=
);
 =09if (error)
 =09=09return error;
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 64d7f171ebd3..e04033c29f0d 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -48,6 +48,7 @@ struct xfs_log_item {
 =09struct xfs_log_vec=09=09*li_lv;=09=09/* active log vector */
 =09struct xfs_log_vec=09=09*li_lv_shadow;=09/* standby vector */
 =09xfs_lsn_t=09=09=09li_seq;=09=09/* CIL commit seq */
+=09struct list_head=09=09li_ril;
 };
=20
 /*
@@ -59,12 +60,14 @@ struct xfs_log_item {
 #define=09XFS_LI_ABORTED=091
 #define=09XFS_LI_FAILED=092
 #define=09XFS_LI_DIRTY=093=09/* log item dirty in transaction */
+#define=09XFS_LI_RELOG=094=09/* automatic relogging */
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

