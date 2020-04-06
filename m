Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE0BC2BB85
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50BFA21D82
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GvZtS2yy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgDFMgl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57150 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727999AbgDFMgk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VhtMJtn8hD7IWJPnjN7ZZO5JZphTWKxXL3urFidfSZ4=;
        b=GvZtS2yy+XaT8zc0sRVBYPFESKSUoNzNqZFkRldsgLJhBQElGdkZHJpdqVr4KKo9ond+Hq
        shLc6nFsKJzb1gLwzzVh0HlKcImbVZIcSGi9Wm9FsaIUpB+MlkCu+Lt3sDd28V9ijVzm7Q
        fnJbxagys8pBWgqn6xAOOpJ9ADWkm8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-7xwF0aj4OKOEFKZwYkpfvQ-1; Mon, 06 Apr 2020 08:36:38 -0400
X-MC-Unique: 7xwF0aj4OKOEFKZwYkpfvQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35D7B8010F0
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2BA060C63
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:36 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 08/10] xfs: buffer relogging support prototype
Date:   Mon,  6 Apr 2020 08:36:30 -0400
Message-Id: <20200406123632.20873-9-bfoster@redhat.com>
In-Reply-To: <20200406123632.20873-1-bfoster@redhat.com>
References: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a quick and dirty implementation of buffer relogging support.
There is currently no use case for buffer relogging. This is for
experimental use only and serves as an example to demonstrate the
ability to relog arbitrary items in the future, if necessary.

Add helpers to manage relogged buffers, update the buffer log item
push handler to support relogged BLIs and add a log item relog
callback to properly join buffers to the relog transaction. Note
that buffers associated with higher level log items (i.e., inodes
and dquots) are skipped.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c       |  4 +++
 fs/xfs/xfs_buf_item.c  | 51 +++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_trans.h     |  9 ++++++-
 fs/xfs/xfs_trans_buf.c | 59 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9ec3eaf1c618..2d16c7d6dee0 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -16,6 +16,8 @@
 #include "xfs_log.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_trans.h"
+#include "xfs_buf_item.h"
=20
 static kmem_zone_t *xfs_buf_zone;
=20
@@ -1477,6 +1479,8 @@ __xfs_buf_submit(
 	trace_xfs_buf_submit(bp, _RET_IP_);
=20
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
+	ASSERT(!bp->b_log_item ||
+	       !test_bit(XFS_LI_RELOG, &bp->b_log_item->bli_item.li_flags));
=20
 	/* on shutdown we stale and complete the buffer immediately */
 	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1545657c3ca0..762359e6ab65 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -16,7 +16,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
-
+#include "xfs_log_priv.h"
=20
 kmem_zone_t	*xfs_buf_item_zone;
=20
@@ -157,7 +157,7 @@ xfs_buf_item_size(
 		return;
 	}
=20
-	ASSERT(bip->bli_flags & XFS_BLI_LOGGED);
+	ASSERT(bip->bli_flags & XFS_BLI_DIRTY);
=20
 	if (bip->bli_flags & XFS_BLI_ORDERED) {
 		/*
@@ -463,6 +463,13 @@ xfs_buf_item_unpin(
 			list_del_init(&bp->b_li_list);
 			bp->b_iodone =3D NULL;
 		} else {
+			/* racy */
+			ASSERT(!test_bit(XFS_LI_RELOG_QUEUED, &lip->li_flags));
+			if (test_bit(XFS_LI_RELOG, &lip->li_flags)) {
+				atomic_dec(&bp->b_pin_count);
+				xfs_trans_relog_item_cancel(NULL, lip, true);
+			}
+
 			spin_lock(&ailp->ail_lock);
 			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
@@ -513,8 +520,6 @@ xfs_buf_item_push(
 	struct xfs_buf		*bp =3D bip->bli_buf;
 	uint			rval =3D XFS_ITEM_SUCCESS;
=20
-	if (xfs_buf_ispinned(bp))
-		return XFS_ITEM_PINNED;
 	if (!xfs_buf_trylock(bp)) {
 		/*
 		 * If we have just raced with a buffer being pinned and it has
@@ -528,6 +533,16 @@ xfs_buf_item_push(
 		return XFS_ITEM_LOCKED;
 	}
=20
+	/* relog bufs are pinned so check relog state first */
+	if (test_bit(XFS_LI_RELOG, &lip->li_flags) &&
+	    !test_bit(XFS_LI_RELOG_QUEUED, &lip->li_flags))
+		return XFS_ITEM_RELOG;
+
+	if (xfs_buf_ispinned(bp)) {
+		xfs_buf_unlock(bp);
+		return XFS_ITEM_PINNED;
+	}
+
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
=20
 	trace_xfs_buf_item_push(bip);
@@ -694,6 +709,28 @@ xfs_buf_item_committed(
 	return lsn;
 }
=20
+STATIC void
+xfs_buf_item_relog(
+	struct xfs_log_item	*lip,
+	struct xfs_trans	*tp)
+{
+	struct xfs_buf_log_item	*bip =3D BUF_ITEM(lip);
+	int			res;
+
+	/*
+	 * Grab a reference to the buffer for the transaction before we join
+	 * and dirty it.
+	 */
+	xfs_buf_hold(bip->bli_buf);
+	xfs_trans_bjoin(tp, bip->bli_buf);
+	xfs_trans_dirty_buf(tp, bip->bli_buf);
+
+	res =3D xfs_relog_calc_res(lip);
+	tp->t_ticket->t_curr_res +=3D res;
+	tp->t_ticket->t_unit_res +=3D res;
+	tp->t_log_res +=3D res;
+}
+
 static const struct xfs_item_ops xfs_buf_item_ops =3D {
 	.iop_size	=3D xfs_buf_item_size,
 	.iop_format	=3D xfs_buf_item_format,
@@ -703,6 +740,7 @@ static const struct xfs_item_ops xfs_buf_item_ops =3D=
 {
 	.iop_committing	=3D xfs_buf_item_committing,
 	.iop_committed	=3D xfs_buf_item_committed,
 	.iop_push	=3D xfs_buf_item_push,
+	.iop_relog	=3D xfs_buf_item_relog,
 };
=20
 STATIC void
@@ -956,6 +994,11 @@ STATIC void
 xfs_buf_item_free(
 	struct xfs_buf_log_item	*bip)
 {
+	ASSERT(!test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags));
+#ifdef DEBUG
+	ASSERT(!atomic64_read(&bip->bli_item.li_relog_res));
+#endif
+
 	xfs_buf_item_free_format(bip);
 	kmem_free(bip->bli_item.li_lv_shadow);
 	kmem_cache_free(xfs_buf_item_zone, bip);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 51f7c92a4ffb..a7a70430b8b2 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -227,7 +227,11 @@ xfs_relog_calc_res(
 	int			nbytes =3D 0;
=20
 	lip->li_ops->iop_size(lip, &niovecs, &nbytes);
-	ASSERT(niovecs =3D=3D 1);
+	ASSERT(niovecs =3D=3D 1 || lip->li_type =3D=3D XFS_LI_BUF);
+	/* ideally this is somewhere buffer specific.. */
+	if (lip->li_type =3D=3D XFS_LI_BUF)
+		nbytes +=3D round_up(sizeof(struct xlog_op_header) +
+				   sizeof(struct xfs_buf_log_format), 128);
 	nbytes =3D xfs_log_calc_unit_res(lip->li_mountp, nbytes);
=20
 	return nbytes;
@@ -244,6 +248,9 @@ void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_b=
uf *);
 void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
 bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
+bool		xfs_trans_relog_buf(struct xfs_trans *, struct xfs_buf *);
+void		xfs_trans_relog_buf_cancel(struct xfs_trans *,
+					   struct xfs_buf *);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 08174ffa2118..2bed5d615541 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -588,6 +588,8 @@ xfs_trans_binval(
 		return;
 	}
=20
+	/* return relog res before we reset dirty state */
+	xfs_trans_relog_buf_cancel(tp, bp);
 	xfs_buf_stale(bp);
=20
 	bip->bli_flags |=3D XFS_BLI_STALE;
@@ -787,3 +789,60 @@ xfs_trans_dquot_buf(
=20
 	xfs_trans_buf_set_type(tp, bp, type);
 }
+
+/*
+ * Enable automatic relogging on a buffer. This essentially pins a dirty=
 buffer
+ * in-core until relogging is disabled.
+ */
+bool
+xfs_trans_relog_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip =3D bp->b_log_item;
+	enum xfs_blft		blft;
+
+	ASSERT(xfs_buf_islocked(bp));
+
+	if (bip->bli_flags & (XFS_BLI_ORDERED|XFS_BLI_STALE))
+		return false;
+
+	/*
+	 * Skip buffers with higher level log items. Those items must be
+	 * relogged directly to move in the log.
+	 */
+	blft =3D xfs_blft_from_flags(&bip->__bli_format);
+	switch (blft) {
+	case XFS_BLFT_DINO_BUF:
+	case XFS_BLFT_UDQUOT_BUF:
+	case XFS_BLFT_PDQUOT_BUF:
+	case XFS_BLFT_GDQUOT_BUF:
+		return false;
+	default:
+		break;
+	}
+
+	/*
+	 * Relog expects a worst case reservation from ->iop_size. Hack that in
+	 * here by logging the entire buffer in this transaction. Also grab a
+	 * buffer pin to prevent it from being written out.
+	 */
+	xfs_buf_item_log(bip, 0, BBTOB(bp->b_length) - 1);
+	atomic_inc(&bp->b_pin_count);
+	xfs_trans_relog_item(tp, &bip->bli_item);
+	return true;
+}
+
+void
+xfs_trans_relog_buf_cancel(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip =3D bp->b_log_item;
+
+	if (!test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags))
+		return;
+
+	atomic_dec(&bp->b_pin_count);
+	xfs_trans_relog_item_cancel(tp, &bip->bli_item, false);
+}
--=20
2.21.1

