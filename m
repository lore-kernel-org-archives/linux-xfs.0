Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC823C35677
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C31E524691
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ST9uf92K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730045AbgB0OsL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:48:11 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60316 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729625AbgB0Nn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 08:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582811005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zduSw/vTwQ1eQ28xjb7bdY9grDz0T9BLLBNqRiw/sY0=;
        b=ST9uf92KJI5PGs0SHO2P7LmgqRu9RLwl6rhJ+RF+Dq2kHVZu2SDV3xrJQmoWE7YdWWYbhB
        FpbuWQFJrozTez0O82eD9UhlmzlJkKosPZR+iCnJxmsRnhivCfIN06Q/fehn7POgp2xq2i
        h+2ft2jIu6ysOYgk7n8+Gqj7BeS63pY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-5oeBigucMCaKiVMkLhOAaA-1; Thu, 27 Feb 2020 08:43:24 -0500
X-MC-Unique: 5oeBigucMCaKiVMkLhOAaA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99DBE1408
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:23 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 617915DA7C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:23 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v5 PATCH 5/9] xfs: automatic log item relog mechanism
Date:   Thu, 27 Feb 2020 08:43:17 -0500
Message-Id: <20200227134321.7238-6-bfoster@redhat.com>
In-Reply-To: <20200227134321.7238-1-bfoster@redhat.com>
References: <20200227134321.7238-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that relog reservation is available and relog state tracking is
in place, all that remains to automatically relog items is the relog
mechanism itself. An item with relogging enabled is basically pinned
from writeback until relog is disabled. Instead of being written
back, the item must instead be periodically committed in a new
transaction to move it in the physical log. The purpose of moving
the item is to avoid long term tail pinning and thus avoid log
deadlocks for long running operations.

The ideal time to relog an item is in response to tail pushing
pressure. This accommodates the current workload at any given time
as opposed to a fixed time interval or log reservation heuristic,
which risks performance regression. This is essentially the same
heuristic that drives metadata writeback. XFS already implements
various log tail pushing heuristics that attempt to keep the log
progressing on an active fileystem under various workloads.

The act of relogging an item simply requires to add it to a
transaction and commit. This pushes the already dirty item into a
subsequent log checkpoint and frees up its previous location in the
on-disk log. Joining an item to a transaction of course requires
locking the item first, which means we have to be aware of
type-specific locks and lock ordering wherever the relog takes
place.

Fundamentally, this points to xfsaild as the ideal location to
process relog enabled items. xfsaild already processes log resident
items, is driven by log tail pushing pressure, processes arbitrary
log item types through callbacks, and is sensitive to type-specific
locking rules by design. The fact that automatic relogging
essentially diverts items between writeback or relog also suggests
xfsaild as an ideal location to process items one way or the other.

Of course, we don't want xfsaild to process transactions as it is a
critical component of the log subsystem for driving metadata
writeback and freeing up log space. Therefore, similar to how
xfsaild builds up a writeback queue of dirty items and queues writes
asynchronously, make xfsaild responsible only for directing pending
relog items into an appropriate queue and create an async
(workqueue) context for processing the queue. The workqueue context
utilizes the pre-reserved relog ticket to drain the queue by rolling
a permanent transaction.

Update the AIL pushing infrastructure to support a new RELOG item
state. If a log item push returns the relog state, queue the item
for relog instead of writeback. On completion of a push cycle,
schedule the relog task at the same point metadata buffer I/O is
submitted. This allows items to be relogged automatically under the
same locking rules and pressure heuristics that govern metadata
writeback.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trace.h      |   1 +
 fs/xfs/xfs_trans.h      |   1 +
 fs/xfs/xfs_trans_ail.c  | 103 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans_priv.h |   3 ++
 4 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a066617ec54d..df0114ec66f1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1063,6 +1063,7 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
+DEFINE_LOG_ITEM_EVENT(xfs_ail_relog);
 DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
 DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
=20
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index fc4c25b6eee4..1637df32c64c 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -99,6 +99,7 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs=
_log_item *item,
 #define XFS_ITEM_PINNED		1
 #define XFS_ITEM_LOCKED		2
 #define XFS_ITEM_FLUSHING	3
+#define XFS_ITEM_RELOG		4
=20
 /*
  * Deferred operation item relogging limits.
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index a3fb64275baa..71a47faeaae8 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -144,6 +144,75 @@ xfs_ail_max_lsn(
 	return lsn;
 }
=20
+/*
+ * Relog log items on the AIL relog queue.
+ */
+static void
+xfs_ail_relog(
+	struct work_struct	*work)
+{
+	struct xfs_ail		*ailp =3D container_of(work, struct xfs_ail,
+						     ail_relog_work);
+	struct xfs_mount	*mp =3D ailp->ail_mount;
+	struct xfs_trans_res	tres =3D {};
+	struct xfs_trans	*tp;
+	struct xfs_log_item	*lip;
+	int			error;
+
+	/*
+	 * The first transaction to submit a relog item contributed relog
+	 * reservation to the relog ticket before committing. Create an empty
+	 * transaction and manually associate the relog ticket.
+	 */
+	error =3D xfs_trans_alloc(mp, &tres, 0, 0, 0, &tp);
+	ASSERT(!error);
+	if (error)
+		return;
+	tp->t_log_res =3D M_RES(mp)->tr_relog.tr_logres;
+	tp->t_log_count =3D M_RES(mp)->tr_relog.tr_logcount;
+	tp->t_flags |=3D M_RES(mp)->tr_relog.tr_logflags;
+	tp->t_ticket =3D xfs_log_ticket_get(ailp->ail_relog_tic);
+
+	spin_lock(&ailp->ail_lock);
+	while ((lip =3D list_first_entry_or_null(&ailp->ail_relog_list,
+					       struct xfs_log_item,
+					       li_trans)) !=3D NULL) {
+		/*
+		 * Drop the AIL processing ticket reference once the relog list
+		 * is emptied. At this point it's possible for our transaction
+		 * to hold the only reference.
+		 */
+		list_del_init(&lip->li_trans);
+		if (list_empty(&ailp->ail_relog_list))
+			xfs_log_ticket_put(ailp->ail_relog_tic);
+		spin_unlock(&ailp->ail_lock);
+
+		xfs_trans_add_item(tp, lip);
+		set_bit(XFS_LI_DIRTY, &lip->li_flags);
+		tp->t_flags |=3D XFS_TRANS_DIRTY;
+		/* XXX: include ticket owner task fix */
+		error =3D xfs_trans_roll(&tp);
+		ASSERT(!error);
+		if (error)
+			goto out;
+		spin_lock(&ailp->ail_lock);
+	}
+	spin_unlock(&ailp->ail_lock);
+
+out:
+	/* XXX: handle shutdown scenario */
+	/*
+	 * Drop the relog reference owned by the transaction separately because
+	 * we don't want the cancel to release reservation if this isn't the
+	 * final reference. The relog ticket and associated reservation needs
+	 * to persist so long as relog items are active in the log subsystem.
+	 */
+	xfs_trans_ail_relog_put(mp);
+
+	tp->t_ticket =3D NULL;
+	xfs_trans_cancel(tp);
+}
+
 /*
  * The cursor keeps track of where our current traversal is up to by tra=
cking
  * the next item in the list for us. However, for this to be safe, remov=
ing an
@@ -364,7 +433,7 @@ static long
 xfsaild_push(
 	struct xfs_ail		*ailp)
 {
-	xfs_mount_t		*mp =3D ailp->ail_mount;
+	struct xfs_mount	*mp =3D ailp->ail_mount;
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	xfs_lsn_t		lsn;
@@ -426,6 +495,23 @@ xfsaild_push(
 			ailp->ail_last_pushed_lsn =3D lsn;
 			break;
=20
+		case XFS_ITEM_RELOG:
+			/*
+			 * The item requires a relog. Add to the pending relog
+			 * list and set the relogged bit to prevent further
+			 * relog requests. The relog bit and ticket reference
+			 * can be dropped from the item at any point, so hold a
+			 * relog ticket reference for the pending relog list to
+			 * ensure the ticket stays around.
+			 */
+			trace_xfs_ail_relog(lip);
+			ASSERT(list_empty(&lip->li_trans));
+			if (list_empty(&ailp->ail_relog_list))
+				xfs_log_ticket_get(ailp->ail_relog_tic);
+			list_add_tail(&lip->li_trans, &ailp->ail_relog_list);
+			set_bit(XFS_LI_RELOGGED, &lip->li_flags);
+			break;
+
 		case XFS_ITEM_FLUSHING:
 			/*
 			 * The item or its backing buffer is already being
@@ -492,6 +578,9 @@ xfsaild_push(
 	if (xfs_buf_delwri_submit_nowait(&ailp->ail_buf_list))
 		ailp->ail_log_flush++;
=20
+	if (!list_empty(&ailp->ail_relog_list))
+		queue_work(ailp->ail_relog_wq, &ailp->ail_relog_work);
+
 	if (!count || XFS_LSN_CMP(lsn, target) >=3D 0) {
 out_done:
 		/*
@@ -922,15 +1011,24 @@ xfs_trans_ail_init(
 	spin_lock_init(&ailp->ail_lock);
 	INIT_LIST_HEAD(&ailp->ail_buf_list);
 	init_waitqueue_head(&ailp->ail_empty);
+	INIT_LIST_HEAD(&ailp->ail_relog_list);
+	INIT_WORK(&ailp->ail_relog_work, xfs_ail_relog);
+
+	ailp->ail_relog_wq =3D alloc_workqueue("xfs-relog/%s", WQ_FREEZABLE, 0,
+					     mp->m_super->s_id);
+	if (!ailp->ail_relog_wq)
+		goto out_free_ailp;
=20
 	ailp->ail_task =3D kthread_run(xfsaild, ailp, "xfsaild/%s",
 			ailp->ail_mount->m_super->s_id);
 	if (IS_ERR(ailp->ail_task))
-		goto out_free_ailp;
+		goto out_destroy_wq;
=20
 	mp->m_ail =3D ailp;
 	return 0;
=20
+out_destroy_wq:
+	destroy_workqueue(ailp->ail_relog_wq);
 out_free_ailp:
 	kmem_free(ailp);
 	return -ENOMEM;
@@ -944,5 +1042,6 @@ xfs_trans_ail_destroy(
=20
 	ASSERT(ailp->ail_relog_tic =3D=3D NULL);
 	kthread_stop(ailp->ail_task);
+	destroy_workqueue(ailp->ail_relog_wq);
 	kmem_free(ailp);
 }
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index d1edec1cb8ad..33a724534869 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -63,6 +63,9 @@ struct xfs_ail {
 	int			ail_log_flush;
 	struct list_head	ail_buf_list;
 	wait_queue_head_t	ail_empty;
+	struct work_struct	ail_relog_work;
+	struct list_head	ail_relog_list;
+	struct workqueue_struct	*ail_relog_wq;
 	struct xlog_ticket	*ail_relog_tic;
 };
=20
--=20
2.21.1

