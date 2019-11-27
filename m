Return-Path: <SRS0=zxI9=ZT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42610C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CCAD206F0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Nov 2019 15:12:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FDhSsOlS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK0PMX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:12:23 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21551 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726514AbfK0PMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Nov 2019 10:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574867541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8nbUjFvNvUgIUF6xjaGqfBD+SQekIIS0dB1jE0O6ifQ=;
        b=FDhSsOlS7Uhxa+3bXKV8UYqtolMCdSykzlOKDjxYiDJNltzG6pTJSrKgyWcv6zqnETSF7C
        QWh1FFbYV8Zwsy4MqqytDxt/UrjGgqUz9V1JHwSzYemcc8Kfxbe2334PUVmAdXQ8iem45w
        nOay9Hv0ZzpqqWdipdcjTKMy3DQ9KOU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-BkQUj5-POd6vXAAO9me0wA-1; Wed, 27 Nov 2019 10:12:20 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50E34100551D
        for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2019 15:12:19 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF6A060BEC
        for <linux-xfs@vger.kernel.org>; Wed, 27 Nov 2019 15:12:18 +0000 (UTC)
Date:   Wed, 27 Nov 2019 10:12:18 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [RFC v3 PATCH] xfs: automatic relogging experiment
Message-ID: <20191127151218.GB56266@bfoster>
References: <20191122181927.32870-1-bfoster@redhat.com>
 <20191125185523.47556-1-bfoster@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191125185523.47556-1-bfoster@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: BkQUj5-POd6vXAAO9me0wA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 25, 2019 at 01:55:23PM -0500, Brian Foster wrote:
> POC to automatically relog the quotaoff start intent. This approach
> involves no reservation stealing nor transaction rolling, so
> deadlock avoidance is not guaranteed. The tradeoff is simplicity and
> an approach that might be effective enough in practice.
>=20
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>=20
> Here's a quickly hacked up version of what I was rambling about in the
> cover letter. I wanted to post this for comparison. As noted above, this
> doesn't necessarily guarantee deadlock avoidance with transaction
> rolling, etc., but might be good enough in practice for the current use
> cases (particularly with CIL context size fixes). Even if not, there's a
> clear enough path to tracking relog reservation with a ticket in the CIL
> context in a manner that is more conducive to batching. We also may be
> able to union ->li_cb() with a ->li_relog() variant to relog intent
> items as dfops currently does for things like EFIs that don't currently
> support direct relogging of the same object.
>=20
> Thoughts about using something like this as an intermediate solution,
> provided it holds up against some stress testing?
>=20

In thinking about this a bit more, it occurs to me that there might be
an elegant way to provide simplicity and flexibility by incorporating
automatic relogging into xfsaild rather than tieing it into the CIL or
having it completely independent (as the past couple of RFCs have done).
From the simplicity standpoint, xfsaild already tracks logged+committed
items for us, so that eliminates the need for independent "RIL"
tracking. xfsaild already issues log item callbacks that could translate
the new log item LI_RELOG state bit to a corresponding XFS_ITEM_RELOG
return code that triggers a relog of the item. We also know the lsn of
the item at this point and can further compare to the tail lsn to only
relog such items when they sit at the log tail. This is more efficient
than the current proposal to automatically relog on every CIL
checkpoint.

From the flexibility standpoint, xfsaild already knows how to safely
access all types of log items via the log ops vector. IOW, it knows how
to exclusively access a log item for writeback, so it would just need
generic/mechanical bits to relog a particular item instead. The caveat
to this is that the task that requests auto relog must relenquish locks
for relogging to actually take place. For example, the sequence for a
traditional (non-intent) log item would be something like::

=09- lock object
=09- dirty in transaction
=09- set lip relog bit
=09- commit transaction
=09- unlock object (background relogging now enabled)

At this point the log item is essentially pinned in-core without pinning
the tail of the log. It is free to be modified by any unrelated
transaction without conflict to either task, but xfsaild will not write
it back. Sometime later the original task would have to lock the item
and clear the relog state to cancel the sequence. The task could simply
release the item to allow writeback or join it to a final transaction
with the relog bit cleared.

There's still room for a custom ->iop_relog() callback or some such for
any items that require special relog handling. If releasing locks is
ever a concern for a particular operation, that callback could overload
the generic relog mechanism and serve as a notification to the lock
holder to roll its own transaction without ever unlocking the item. TBH
I'm still not sure there's a use case for this kind of non-intent
relogging, but ISTM this design model accommodates it reasonably enough
with minimal complexity.

There are still some open implementation questions around managing the
relog transaction(s), determining how much reservation is needed, how to
acquire it, etc. We most likely do not want to block the xfsaild task on
acquiring reservation, but it might be able to regrant a permanent
ticket or simply kick off the task of replenishing relog reservation to
a workqueue.

Thoughts?

Brian

> Brian
>=20
>  fs/xfs/xfs_log.c         |  1 +
>  fs/xfs/xfs_log_cil.c     | 50 +++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_log_priv.h    |  2 ++
>  fs/xfs/xfs_qm_syscalls.c |  6 +++++
>  fs/xfs/xfs_trans.h       |  5 +++-
>  5 files changed, 62 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6a147c63a8a6..4fb3c3156ea2 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1086,6 +1086,7 @@ xfs_log_item_init(
>  =09INIT_LIST_HEAD(&item->li_cil);
>  =09INIT_LIST_HEAD(&item->li_bio_list);
>  =09INIT_LIST_HEAD(&item->li_trans);
> +=09INIT_LIST_HEAD(&item->li_ril);
>  }
> =20
>  /*
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 48435cf2aa16..c16ebc448a40 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -19,6 +19,44 @@
> =20
>  struct workqueue_struct *xfs_discard_wq;
> =20
> +static void
> +xfs_relog_worker(
> +=09struct work_struct=09*work)
> +{
> +=09struct xfs_cil_ctx=09*ctx =3D container_of(work, struct xfs_cil_ctx, =
relog_work);
> +=09struct xfs_mount=09*mp =3D ctx->cil->xc_log->l_mp;
> +=09struct xfs_trans=09*tp;
> +=09struct xfs_log_item=09*lip, *lipp;
> +=09int=09=09=09error;
> +
> +=09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &t=
p);
> +=09ASSERT(!error);
> +
> +=09list_for_each_entry_safe(lip, lipp, &ctx->relog_list, li_ril) {
> +=09=09list_del_init(&lip->li_ril);
> +
> +=09=09if (!test_bit(XFS_LI_RELOG, &lip->li_flags))
> +=09=09=09continue;
> +
> +=09=09xfs_trans_add_item(tp, lip);
> +=09=09set_bit(XFS_LI_DIRTY, &lip->li_flags);
> +=09=09tp->t_flags |=3D XFS_TRANS_DIRTY;
> +=09}
> +
> +=09error =3D xfs_trans_commit(tp);
> +=09ASSERT(!error);
> +
> +=09/* XXX */
> +=09kmem_free(ctx);
> +}
> +
> +static void
> +xfs_relog_queue(
> +=09struct xfs_cil_ctx=09*ctx)
> +{
> +=09queue_work(xfs_discard_wq, &ctx->relog_work);
> +}
> +
>  /*
>   * Allocate a new ticket. Failing to get a new ticket makes it really ha=
rd to
>   * recover, so we don't allow failure here. Also, we allocate in a conte=
xt that
> @@ -476,6 +514,9 @@ xlog_cil_insert_items(
>  =09=09 */
>  =09=09if (!list_is_last(&lip->li_cil, &cil->xc_cil))
>  =09=09=09list_move_tail(&lip->li_cil, &cil->xc_cil);
> +
> +=09=09if (test_bit(XFS_LI_RELOG, &lip->li_flags))
> +=09=09=09list_move_tail(&lip->li_ril, &ctx->relog_list);
>  =09}
> =20
>  =09spin_unlock(&cil->xc_cil_lock);
> @@ -605,7 +646,10 @@ xlog_cil_committed(
> =20
>  =09xlog_cil_free_logvec(ctx->lv_chain);
> =20
> -=09if (!list_empty(&ctx->busy_extents))
> +=09/* XXX: mutually exclusive w/ discard for POC to handle ctx freeing *=
/
> +=09if (!list_empty(&ctx->relog_list))
> +=09=09xfs_relog_queue(ctx);
> +=09else if (!list_empty(&ctx->busy_extents))
>  =09=09xlog_discard_busy_extents(mp, ctx);
>  =09else
>  =09=09kmem_free(ctx);
> @@ -746,8 +790,10 @@ xlog_cil_push(
>  =09 */
>  =09INIT_LIST_HEAD(&new_ctx->committing);
>  =09INIT_LIST_HEAD(&new_ctx->busy_extents);
> +=09INIT_LIST_HEAD(&new_ctx->relog_list);
>  =09new_ctx->sequence =3D ctx->sequence + 1;
>  =09new_ctx->cil =3D cil;
> +=09INIT_WORK(&new_ctx->relog_work, xfs_relog_worker);
>  =09cil->xc_ctx =3D new_ctx;
> =20
>  =09/*
> @@ -1199,6 +1245,8 @@ xlog_cil_init(
> =20
>  =09INIT_LIST_HEAD(&ctx->committing);
>  =09INIT_LIST_HEAD(&ctx->busy_extents);
> +=09INIT_LIST_HEAD(&ctx->relog_list);
> +=09INIT_WORK(&ctx->relog_work, xfs_relog_worker);
>  =09ctx->sequence =3D 1;
>  =09ctx->cil =3D cil;
>  =09cil->xc_ctx =3D ctx;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index b192c5a9f9fd..6fd7b7297bd3 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -243,6 +243,8 @@ struct xfs_cil_ctx {
>  =09struct list_head=09iclog_entry;
>  =09struct list_head=09committing;=09/* ctx committing list */
>  =09struct work_struct=09discard_endio_work;
> +=09struct list_head=09relog_list;
> +=09struct work_struct=09relog_work;
>  };
> =20
>  /*
> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> index 1ea82764bf89..08b6180cb5a3 100644
> --- a/fs/xfs/xfs_qm_syscalls.c
> +++ b/fs/xfs/xfs_qm_syscalls.c
> @@ -18,6 +18,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_qm.h"
>  #include "xfs_icache.h"
> +#include "xfs_log.h"
> =20
>  STATIC int
>  xfs_qm_log_quotaoff(
> @@ -37,6 +38,7 @@ xfs_qm_log_quotaoff(
> =20
>  =09qoffi =3D xfs_trans_get_qoff_item(tp, NULL, flags & XFS_ALL_QUOTA_ACC=
T);
>  =09xfs_trans_log_quotaoff_item(tp, qoffi);
> +=09set_bit(XFS_LI_RELOG, &qoffi->qql_item.li_flags);
> =20
>  =09spin_lock(&mp->m_sb_lock);
>  =09mp->m_sb.sb_qflags =3D (mp->m_qflags & ~(flags)) & XFS_MOUNT_QUOTA_AL=
L;
> @@ -69,6 +71,10 @@ xfs_qm_log_quotaoff_end(
>  =09int=09=09=09error;
>  =09struct xfs_qoff_logitem=09*qoffi;
> =20
> +=09clear_bit(XFS_LI_RELOG, &startqoff->qql_item.li_flags);
> +=09xfs_log_force(mp, XFS_LOG_SYNC);
> +=09flush_workqueue(xfs_discard_wq);
> +
>  =09error =3D xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &=
tp);
>  =09if (error)
>  =09=09return error;
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 64d7f171ebd3..e04033c29f0d 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -48,6 +48,7 @@ struct xfs_log_item {
>  =09struct xfs_log_vec=09=09*li_lv;=09=09/* active log vector */
>  =09struct xfs_log_vec=09=09*li_lv_shadow;=09/* standby vector */
>  =09xfs_lsn_t=09=09=09li_seq;=09=09/* CIL commit seq */
> +=09struct list_head=09=09li_ril;
>  };
> =20
>  /*
> @@ -59,12 +60,14 @@ struct xfs_log_item {
>  #define=09XFS_LI_ABORTED=091
>  #define=09XFS_LI_FAILED=092
>  #define=09XFS_LI_DIRTY=093=09/* log item dirty in transaction */
> +#define=09XFS_LI_RELOG=094=09/* automatic relogging */
> =20
>  #define XFS_LI_FLAGS \
>  =09{ (1 << XFS_LI_IN_AIL),=09=09"IN_AIL" }, \
>  =09{ (1 << XFS_LI_ABORTED),=09"ABORTED" }, \
>  =09{ (1 << XFS_LI_FAILED),=09=09"FAILED" }, \
> -=09{ (1 << XFS_LI_DIRTY),=09=09"DIRTY" }
> +=09{ (1 << XFS_LI_DIRTY),=09=09"DIRTY" }, \
> +=09{ (1 << XFS_LI_RELOG),=09=09"RELOG" }
> =20
>  struct xfs_item_ops {
>  =09unsigned flags;
> --=20
> 2.20.1
>=20

