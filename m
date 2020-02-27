Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A25C3F350
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 13:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F39C20578
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 13:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXHXDqyK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbgB0Nn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 08:43:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35180 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729418AbgB0Nn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 08:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582811005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3I3mQXlpOH2b9q8pkq7O1JUql4UD1YL8DZFlRy16KhU=;
        b=YXHXDqyKZOiYJT5PCAT78CAmgCRI9twadUmSSLsTpfQCgCDLzni9I/nQDSOMRKnwW9tNLV
        RbNMY/EMBfg6GvYYpTSkPkeFbPMoqGmzp1L9SeDEn5JU2CJYxuF3WLDgkNDQSqY92jdGaz
        YM5YZDrmGp+3NXoQOGxzQsladGcZjwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-C-FXy86zMsiXoZWGjAoIZQ-1; Thu, 27 Feb 2020 08:43:23 -0500
X-MC-Unique: C-FXy86zMsiXoZWGjAoIZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E83EA18A8C98
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:22 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE7415DA7C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:22 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v5 PATCH 3/9] xfs: automatic relogging reservation management
Date:   Thu, 27 Feb 2020 08:43:15 -0500
Message-Id: <20200227134321.7238-4-bfoster@redhat.com>
In-Reply-To: <20200227134321.7238-1-bfoster@redhat.com>
References: <20200227134321.7238-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Automatic item relogging will occur from xfsaild context. xfsaild
cannot acquire log reservation itself because it is also responsible
for writeback and thus making used log reservation available again.
Since there is no guarantee log reservation is available by the time
a relogged item reaches the AIL, this is prone to deadlock.

To guarantee log reservation for automatic relogging, implement a
reservation management scheme where a transaction that is capable of
enabling relogging of an item must contribute the necessary
reservation to the relog mechanism up front. Use reference counting
to associate the lifetime of pending relog reservation to the
lifetime of in-core log items with relogging enabled.

The basic log reservation sequence for a relog enabled transaction
is as follows:

- A transaction that uses relogging specifies XFS_TRANS_RELOG at
  allocation time.
- Once initialized, RELOG transactions check for the existence of
  the global relog log ticket. If it exists, grab a reference and
  return. If not, allocate an empty ticket and install into the relog
  subsystem. Seed the relog ticket from reservation of the current
  transaction. Roll the current transaction to replenish its
  reservation and return to the caller.
- The transaction is used as normal. If an item is relogged in the
  transaction, that item acquires a reference on the global relog
  ticket currently held open by the transaction. The item's reference
  persists until relogging is disabled on the item.
- The RELOG transaction commits and releases its reference to the
  global relog ticket. The global relog ticket is released once its
  reference count drops to zero.

This provides a central relog log ticket that guarantees reservation
availability for relogged items, avoids log reservation deadlocks
and is allocated and released on demand.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_shared.h |  1 +
 fs/xfs/xfs_trans.c         | 37 +++++++++++++---
 fs/xfs/xfs_trans.h         |  3 ++
 fs/xfs/xfs_trans_ail.c     | 89 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans_priv.h    |  1 +
 5 files changed, 126 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c45acbd3add9..0a10ca0853ab 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -77,6 +77,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
  * made then this algorithm will eventually find all the space it needs.
  */
 #define XFS_TRANS_LOWMODE	0x100	/* allocate in low space mode */
+#define XFS_TRANS_RELOG		0x200	/* enable automatic relogging */
=20
 /*
  * Field values for xfs_trans_mod_sb.
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3b208f9a865c..8ac05ed8deda 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -107,9 +107,14 @@ xfs_trans_dup(
=20
 	ntp->t_flags =3D XFS_TRANS_PERM_LOG_RES |
 		       (tp->t_flags & XFS_TRANS_RESERVE) |
-		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
-	/* We gave our writer reference to the new transaction */
+		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
+		       (tp->t_flags & XFS_TRANS_RELOG);
+	/*
+	 * The writer reference and relog reference transfer to the new
+	 * transaction.
+	 */
 	tp->t_flags |=3D XFS_TRANS_NO_WRITECOUNT;
+	tp->t_flags &=3D ~XFS_TRANS_RELOG;
 	ntp->t_ticket =3D xfs_log_ticket_get(tp->t_ticket);
=20
 	ASSERT(tp->t_blk_res >=3D tp->t_blk_res_used);
@@ -284,15 +289,25 @@ xfs_trans_alloc(
 	tp->t_firstblock =3D NULLFSBLOCK;
=20
 	error =3D xfs_trans_reserve(tp, resp, blocks, rtextents);
-	if (error) {
-		xfs_trans_cancel(tp);
-		return error;
+	if (error)
+		goto error;
+
+	if (flags & XFS_TRANS_RELOG) {
+		error =3D xfs_trans_ail_relog_reserve(&tp);
+		if (error)
+			goto error;
 	}
=20
 	trace_xfs_trans_alloc(tp, _RET_IP_);
=20
 	*tpp =3D tp;
 	return 0;
+
+error:
+	/* clear relog flag if we haven't acquired a ref */
+	tp->t_flags &=3D ~XFS_TRANS_RELOG;
+	xfs_trans_cancel(tp);
+	return error;
 }
=20
 /*
@@ -973,6 +988,10 @@ __xfs_trans_commit(
=20
 	xfs_log_commit_cil(mp, tp, &commit_lsn, regrant);
=20
+	/* release the relog ticket reference if this transaction holds one */
+	if (tp->t_flags & XFS_TRANS_RELOG)
+		xfs_trans_ail_relog_put(mp);
+
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free(tp);
=20
@@ -1004,6 +1023,10 @@ __xfs_trans_commit(
 			error =3D -EIO;
 		tp->t_ticket =3D NULL;
 	}
+	/* release the relog ticket reference if this transaction holds one */
+	/* XXX: handle RELOG items on transaction abort */
+	if (tp->t_flags & XFS_TRANS_RELOG)
+		xfs_trans_ail_relog_put(mp);
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
 	xfs_trans_free_items(tp, !!error);
 	xfs_trans_free(tp);
@@ -1064,6 +1087,10 @@ xfs_trans_cancel(
 		tp->t_ticket =3D NULL;
 	}
=20
+	/* release the relog ticket reference if this transaction holds one */
+	if (tp->t_flags & XFS_TRANS_RELOG)
+		xfs_trans_ail_relog_put(mp);
+
 	/* mark this thread as no longer being in a transaction */
 	current_restore_flags_nested(&tp->t_pflags, PF_MEMALLOC_NOFS);
=20
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 752c7fef9de7..a032989943bd 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -236,6 +236,9 @@ int		xfs_trans_roll_inode(struct xfs_trans **, struct=
 xfs_inode *);
 void		xfs_trans_cancel(xfs_trans_t *);
 int		xfs_trans_ail_init(struct xfs_mount *);
 void		xfs_trans_ail_destroy(struct xfs_mount *);
+int		xfs_trans_ail_relog_reserve(struct xfs_trans **);
+bool		xfs_trans_ail_relog_get(struct xfs_mount *);
+int		xfs_trans_ail_relog_put(struct xfs_mount *);
=20
 void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
 				       enum xfs_blft);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 00cc5b8734be..a3fb64275baa 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -17,6 +17,7 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_log.h"
+#include "xfs_log_priv.h"
=20
 #ifdef DEBUG
 /*
@@ -818,6 +819,93 @@ xfs_trans_ail_delete(
 		xfs_log_space_wake(ailp->ail_mount);
 }
=20
+bool
+xfs_trans_ail_relog_get(
+	struct xfs_mount	*mp)
+{
+	struct xfs_ail		*ailp =3D mp->m_ail;
+	bool			ret =3D false;
+
+	spin_lock(&ailp->ail_lock);
+	if (ailp->ail_relog_tic) {
+		xfs_log_ticket_get(ailp->ail_relog_tic);
+		ret =3D true;
+	}
+	spin_unlock(&ailp->ail_lock);
+	return ret;
+}
+
+/*
+ * Reserve log space for the automatic relogging ->tr_relog ticket. This
+ * requires a clean, permanent transaction from the caller. Pull reserva=
tion
+ * for the relog ticket and roll the caller's transaction back to its fu=
lly
+ * reserved state. If the AIL relog ticket is already initialized, grab =
a
+ * reference and return.
+ */
+int
+xfs_trans_ail_relog_reserve(
+	struct xfs_trans	**tpp)
+{
+	struct xfs_trans	*tp =3D *tpp;
+	struct xfs_mount	*mp =3D tp->t_mountp;
+	struct xfs_ail		*ailp =3D mp->m_ail;
+	struct xlog_ticket	*tic;
+	uint32_t		logres =3D M_RES(mp)->tr_relog.tr_logres;
+
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+	ASSERT(!(tp->t_flags & XFS_TRANS_DIRTY));
+
+	if (xfs_trans_ail_relog_get(mp))
+		return 0;
+
+	/* no active ticket, fall into slow path to allocate one.. */
+	tic =3D xlog_ticket_alloc(mp->m_log, logres, 1, XFS_TRANSACTION, true, =
0);
+	if (!tic)
+		return -ENOMEM;
+	ASSERT(tp->t_ticket->t_curr_res >=3D tic->t_curr_res);
+
+	/* check again since we dropped the lock for the allocation */
+	spin_lock(&ailp->ail_lock);
+	if (ailp->ail_relog_tic) {
+		xfs_log_ticket_get(ailp->ail_relog_tic);
+		spin_unlock(&ailp->ail_lock);
+		xfs_log_ticket_put(tic);
+		return 0;
+	}
+
+	/* attach and reserve space for the ->tr_relog ticket */
+	ailp->ail_relog_tic =3D tic;
+	tp->t_ticket->t_curr_res -=3D tic->t_curr_res;
+	spin_unlock(&ailp->ail_lock);
+
+	return xfs_trans_roll(tpp);
+}
+
+/*
+ * Release a reference to the relog ticket.
+ */
+int
+xfs_trans_ail_relog_put(
+	struct xfs_mount	*mp)
+{
+	struct xfs_ail		*ailp =3D mp->m_ail;
+	struct xlog_ticket	*tic;
+
+	spin_lock(&ailp->ail_lock);
+	if (atomic_add_unless(&ailp->ail_relog_tic->t_ref, -1, 1)) {
+		spin_unlock(&ailp->ail_lock);
+		return 0;
+	}
+
+	ASSERT(atomic_read(&ailp->ail_relog_tic->t_ref) =3D=3D 1);
+	tic =3D ailp->ail_relog_tic;
+	ailp->ail_relog_tic =3D NULL;
+	spin_unlock(&ailp->ail_lock);
+
+	xfs_log_done(mp, tic, NULL, false);
+	return 0;
+}
+
 int
 xfs_trans_ail_init(
 	xfs_mount_t	*mp)
@@ -854,6 +942,7 @@ xfs_trans_ail_destroy(
 {
 	struct xfs_ail	*ailp =3D mp->m_ail;
=20
+	ASSERT(ailp->ail_relog_tic =3D=3D NULL);
 	kthread_stop(ailp->ail_task);
 	kmem_free(ailp);
 }
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 2e073c1c4614..839df6559b9f 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -61,6 +61,7 @@ struct xfs_ail {
 	int			ail_log_flush;
 	struct list_head	ail_buf_list;
 	wait_queue_head_t	ail_empty;
+	struct xlog_ticket	*ail_relog_tic;
 };
=20
 /*
--=20
2.21.1

