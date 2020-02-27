Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4113C34022
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B38624691
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EOLhtC7P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbgB0OsK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:48:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46035 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729967AbgB0Nn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 08:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582811006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nmadNi8II9xm8yPBRY4OKlzh72r86cmU3sWMkDVLnJg=;
        b=EOLhtC7PuV+Q39NLcV2aVvOtKvjeGjEOsQu74dYjr0Qz7lIVPLGLpE+OoCd+F2hcue3wOB
        O1Ry4lj41wov4A4yi3CCSyNNu6vitin95He1X/bXJwJ4gQ/wpTPyWNm7j9J3JA8FcAGDe4
        2v2ptmV2WzF990lhqeBU8K8kER6gRQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-zVWA0JNEMoWxJBXNs1-AuQ-1; Thu, 27 Feb 2020 08:43:25 -0500
X-MC-Unique: zVWA0JNEMoWxJBXNs1-AuQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CE561005513
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:24 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14B295D9CD
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:24 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v5 PATCH 7/9] xfs: buffer relogging support prototype
Date:   Thu, 27 Feb 2020 08:43:19 -0500
Message-Id: <20200227134321.7238-8-bfoster@redhat.com>
In-Reply-To: <20200227134321.7238-1-bfoster@redhat.com>
References: <20200227134321.7238-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a quick and dirty implementation of buffer relogging support.
There is currently no use case for buffer relogging. This is for
experimental use only and serves as an example to demonstrate the
ability to relog arbitrary items in the future, if necessary.

Add a hook to enable relogging a buffer in a transaction, update the
buffer log item handlers to support relogged BLIs and update the
relog handler to join the relogged buffer to the relog transaction.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c  |  5 +++++
 fs/xfs/xfs_trans.h     |  1 +
 fs/xfs/xfs_trans_ail.c | 19 ++++++++++++++++---
 fs/xfs/xfs_trans_buf.c | 22 ++++++++++++++++++++++
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 663810e6cd59..4ef2725fa8ce 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -463,6 +463,7 @@ xfs_buf_item_unpin(
 			list_del_init(&bp->b_li_list);
 			bp->b_iodone =3D NULL;
 		} else {
+			xfs_trans_relog_item_cancel(lip, false);
 			spin_lock(&ailp->ail_lock);
 			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
@@ -528,6 +529,9 @@ xfs_buf_item_push(
 		return XFS_ITEM_LOCKED;
 	}
=20
+	if (test_bit(XFS_LI_RELOG, &lip->li_flags))
+		return XFS_ITEM_RELOG;
+
 	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
=20
 	trace_xfs_buf_item_push(bip);
@@ -956,6 +960,7 @@ STATIC void
 xfs_buf_item_free(
 	struct xfs_buf_log_item	*bip)
 {
+	ASSERT(!test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags));
 	xfs_buf_item_free_format(bip);
 	kmem_free(bip->bli_item.li_lv_shadow);
 	kmem_cache_free(xfs_buf_item_zone, bip);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 1637df32c64c..81cb42f552d9 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -226,6 +226,7 @@ void		xfs_trans_inode_buf(xfs_trans_t *, struct xfs_b=
uf *);
 void		xfs_trans_stale_inode_buf(xfs_trans_t *, struct xfs_buf *);
 bool		xfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_dquot_buf(xfs_trans_t *, struct xfs_buf *, uint);
+bool		xfs_trans_relog_buf(struct xfs_trans *, struct xfs_buf *);
 void		xfs_trans_inode_alloc_buf(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_ichgtime(struct xfs_trans *, struct xfs_inode *, int);
 void		xfs_trans_ijoin(struct xfs_trans *, struct xfs_inode *, uint);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 71a47faeaae8..103ab62e61be 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -18,6 +18,7 @@
 #include "xfs_error.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
+#include "xfs_buf_item.h"
=20
 #ifdef DEBUG
 /*
@@ -187,9 +188,21 @@ xfs_ail_relog(
 			xfs_log_ticket_put(ailp->ail_relog_tic);
 		spin_unlock(&ailp->ail_lock);
=20
-		xfs_trans_add_item(tp, lip);
-		set_bit(XFS_LI_DIRTY, &lip->li_flags);
-		tp->t_flags |=3D XFS_TRANS_DIRTY;
+		/*
+		 * TODO: Ideally, relog transaction management would be pushed
+		 * down into the ->iop_push() callbacks rather than playing
+		 * games with ->li_trans and looking at log item types here.
+		 */
+		if (lip->li_type =3D=3D XFS_LI_BUF) {
+			struct xfs_buf_log_item	*bli =3D (struct xfs_buf_log_item *) lip;
+			xfs_buf_hold(bli->bli_buf);
+			xfs_trans_bjoin(tp, bli->bli_buf);
+			xfs_trans_dirty_buf(tp, bli->bli_buf);
+		} else {
+			xfs_trans_add_item(tp, lip);
+			set_bit(XFS_LI_DIRTY, &lip->li_flags);
+			tp->t_flags |=3D XFS_TRANS_DIRTY;
+		}
 		/* XXX: include ticket owner task fix */
 		error =3D xfs_trans_roll(&tp);
 		ASSERT(!error);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 08174ffa2118..e17715ac23fc 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -787,3 +787,25 @@ xfs_trans_dquot_buf(
=20
 	xfs_trans_buf_set_type(tp, bp, type);
 }
+
+/*
+ * Enable automatic relogging on a buffer. This essentially pins a dirty=
 buffer
+ * in-core until relogging is disabled. Note that the buffer must not al=
ready be
+ * queued for writeback.
+ */
+bool
+xfs_trans_relog_buf(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip =3D bp->b_log_item;
+
+	ASSERT(tp->t_flags & XFS_TRANS_RELOG);
+	ASSERT(xfs_buf_islocked(bp));
+
+	if (bp->b_flags & _XBF_DELWRI_Q)
+		return false;
+
+	xfs_trans_relog_item(&bip->bli_item);
+	return true;
+}
--=20
2.21.1

