Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A430C2BB86
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08F2C21D7F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LJOvlUD2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgDFMgm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36315 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727989AbgDFMgm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s9Z9InYqlywD36FBHxvBkfw04gVhFHh0TeKUFxyvwnQ=;
        b=LJOvlUD2CzFZpxiGzg50Wet3c/XOGbUiKBgz0iiGHlU8tJ9CAo7bN5Vfc/EsJZw0oO8iSS
        WOqc8IHeueoIWeHUW1AKySSIJZ6QAO9nj44GoCoXUer4XRGwuwMdRKpA26hI4ZUsPaks/c
        3u220BL/YX7aVEqkMjkaRKhZaX6yaMU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-yEFvHJmXNXuGt3m5UVthbQ-1; Mon, 06 Apr 2020 08:36:38 -0400
X-MC-Unique: yEFvHJmXNXuGt3m5UVthbQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2888D800597
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:38 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C749660BFB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:37 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 10/10] xfs: relog random buffers based on errortag
Date:   Mon,  6 Apr 2020 08:36:32 -0400
Message-Id: <20200406123632.20873-11-bfoster@redhat.com>
In-Reply-To: <20200406123632.20873-1-bfoster@redhat.com>
References: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since there is currently no specific use case for buffer relogging,
add some hacky and experimental code to relog random buffers when
the associated errortag is enabled. Use fixed termination logic
regardless of the user-specified error rate to help ensure that the
relog queue doesn't grow indefinitely.

Note that this patch was useful in causing log reservation deadlocks
on an fsstress workload if the relog mechanism code is modified to
acquire its own log reservation rather than rely on the
pre-reservation mechanism. In other words, this helps prove that the
relog reservation management code effectively avoids log reservation
deadlocks.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c  |  1 +
 fs/xfs/xfs_trans.h     |  4 +++-
 fs/xfs/xfs_trans_ail.c | 33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans_buf.c | 14 ++++++++++++++
 4 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 762359e6ab65..ed91de33278b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -467,6 +467,7 @@ xfs_buf_item_unpin(
 			ASSERT(!test_bit(XFS_LI_RELOG_QUEUED, &lip->li_flags));
 			if (test_bit(XFS_LI_RELOG, &lip->li_flags)) {
 				atomic_dec(&bp->b_pin_count);
+				clear_bit(XFS_LI_RELOG_RAND, &bip->bli_item.li_flags);
 				xfs_trans_relog_item_cancel(NULL, lip, true);
 			}
=20
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a7a70430b8b2..0f40ce784367 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -64,6 +64,7 @@ struct xfs_log_item {
 #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
 #define	XFS_LI_RELOG	4	/* automatically relog item */
 #define XFS_LI_RELOG_QUEUED 5	/* queued for relog */
+#define XFS_LI_RELOG_RAND   6
=20
 #define XFS_LI_FLAGS \
 	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
@@ -71,7 +72,8 @@ struct xfs_log_item {
 	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
 	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
 	{ (1 << XFS_LI_RELOG),		"RELOG" }, \
-	{ (1 << XFS_LI_RELOG_QUEUED),	"RELOG_QUEUED" }
+	{ (1 << XFS_LI_RELOG_QUEUED),	"RELOG_QUEUED" }, \
+	{ (1 << XFS_LI_RELOG_RAND),	"RELOG_RAND" }
=20
 struct xfs_item_ops {
 	unsigned flags;
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index b78d026d6564..a34a5e73427e 100644
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
@@ -176,6 +177,7 @@ xfs_ail_relog(
 	struct xfs_trans_res	tres =3D {};
 	struct xfs_trans	*tp;
 	struct xfs_log_item	*lip, *lipp;
+	int			cancelres;
 	int			error;
 	LIST_HEAD(relog_list);
=20
@@ -209,6 +211,37 @@ xfs_ail_relog(
 			ASSERT(lip->li_ops->iop_relog);
 			if (lip->li_ops->iop_relog)
 				lip->li_ops->iop_relog(lip, tp);
+
+			/*
+			 * Cancel random buffer relogs at a fixed rate to
+			 * prevent too much buildup.
+			 */
+			if (test_bit(XFS_LI_RELOG_RAND, &lip->li_flags) &&
+			    ((prandom_u32() & 1) ||
+			     (mp->m_flags & XFS_MOUNT_UNMOUNTING))) {
+				struct xfs_buf_log_item	*bli;
+				bli =3D container_of(lip, struct xfs_buf_log_item,
+						   bli_item);
+				xfs_trans_relog_buf_cancel(tp, bli->bli_buf);
+			}
+		}
+
+		/*
+		 * Cancelling relog reservation in the same transaction as
+		 * consuming it means the current transaction over releases
+		 * reservation on commit and the next transaction reservation
+		 * restores the grant heads to even. To avoid this behavior,
+		 * remove surplus reservation (->t_curr_res) from the committing
+		 * transaction and replace it with a reduction in the
+		 * reservation requirement (->t_unit_res) for the next. This has
+		 * no net effect on reservation accounting, but ensures we don't
+		 * cause problems elsewhere with odd reservation behavior.
+		 */
+		cancelres =3D tp->t_ticket->t_curr_res - tp->t_ticket->t_unit_res;
+		if (cancelres) {
+			tp->t_ticket->t_curr_res -=3D cancelres;
+			tp->t_ticket->t_unit_res -=3D cancelres;
+			tp->t_log_res -=3D cancelres;
 		}
=20
 		error =3D xfs_trans_roll(&tp);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 2bed5d615541..9dadf39a40bb 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -14,6 +14,8 @@
 #include "xfs_buf_item.h"
 #include "xfs_trans_priv.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
+#include "xfs_errortag.h"
=20
 /*
  * Check to see if a buffer matching the given parameters is already
@@ -527,6 +529,17 @@ xfs_trans_log_buf(
=20
 	trace_xfs_trans_log_buf(bip);
 	xfs_buf_item_log(bip, first, last);
+
+	/*
+	 * Relog random buffers so long as the transaction is relog enabled and
+	 * the buffer wasn't already relogged explicitly.
+	 */
+	if (XFS_TEST_ERROR(false, tp->t_mountp, XFS_ERRTAG_RELOG) &&
+	    (tp->t_flags & XFS_TRANS_RELOG) &&
+	    !test_bit(XFS_LI_RELOG, &bip->bli_item.li_flags)) {
+		if (xfs_trans_relog_buf(tp, bp))
+			set_bit(XFS_LI_RELOG_RAND, &bip->bli_item.li_flags);
+	}
 }
=20
=20
@@ -845,4 +858,5 @@ xfs_trans_relog_buf_cancel(
=20
 	atomic_dec(&bp->b_pin_count);
 	xfs_trans_relog_item_cancel(tp, &bip->bli_item, false);
+	clear_bit(XFS_LI_RELOG_RAND, &bip->bli_item.li_flags);
 }
--=20
2.21.1

