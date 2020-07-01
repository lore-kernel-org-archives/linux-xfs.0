Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C881C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CCA320748
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 16:51:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HD5zBQeR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732525AbgGAQvZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 12:51:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34213 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732478AbgGAQvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 12:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593622280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6nNKVfkrxEo76ohioy+lNdoFYj8qB6zn7Ff6r3Fwc4A=;
        b=HD5zBQeR5iofLNU145JkV6eGLtJA+i1Rltk5GtFXMuaqpCB5zenTdBycTCLJWaH3xBtRg6
        hd9/DV97Htxzfw2SwuvIODoI1mX7O97iQ2X2co79OfS9rdsydfSLTpCNBpEYNv7TUMGGIF
        YOQzam87A4HzL6YdAhSRwdpmeDB1KnQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-uEA4CsYPPduqHNC9T-851w-1; Wed, 01 Jul 2020 12:51:18 -0400
X-MC-Unique: uEA4CsYPPduqHNC9T-851w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A6C6804002
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:17 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-120-48.rdu2.redhat.com [10.10.120.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36FB95C3FD
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 16:51:17 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/10] xfs: automatic relogging item management
Date:   Wed,  1 Jul 2020 12:51:07 -0400
Message-Id: <20200701165116.47344-2-bfoster@redhat.com>
In-Reply-To: <20200701165116.47344-1-bfoster@redhat.com>
References: <20200701165116.47344-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a log item flag to track relog state and a couple helpers to set
and clear the flag. The flag will be set on any log item that is to
be automatically relogged by log tail pressure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_trace.h      |  2 ++
 fs/xfs/xfs_trans.c      | 20 ++++++++++++++++++++
 fs/xfs/xfs_trans.h      |  4 +++-
 fs/xfs/xfs_trans_priv.h |  2 ++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 460136628a79..f6fd598c3912 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1068,6 +1068,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
+DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
+DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
 
 DECLARE_EVENT_CLASS(xfs_ail_class,
 	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3c94e5ff4316..5190b792cc68 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -651,6 +651,26 @@ xfs_trans_del_item(
 	list_del_init(&lip->li_trans);
 }
 
+void
+xfs_trans_relog_item(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	if (test_and_set_bit(XFS_LI_RELOG, &lip->li_flags))
+		return;
+	trace_xfs_relog_item(lip);
+}
+
+void
+xfs_trans_relog_item_cancel(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	if (!test_and_clear_bit(XFS_LI_RELOG, &lip->li_flags))
+		return;
+	trace_xfs_relog_item_cancel(lip);
+}
+
 /* Detach and unlock all of the items in a transaction */
 static void
 xfs_trans_free_items(
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 8308bf6d7e40..6349e78af002 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -60,13 +60,15 @@ struct xfs_log_item {
 #define	XFS_LI_FAILED	2
 #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
 #define	XFS_LI_RECOVERED 4	/* log intent item has been recovered */
+#define	XFS_LI_RELOG	5	/* automatically relog item */
 
 #define XFS_LI_FLAGS \
 	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
 	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
 	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
 	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
-	{ (1 << XFS_LI_RECOVERED),	"RECOVERED" }
+	{ (1 << XFS_LI_RECOVERED),	"RECOVERED" }, \
+	{ (1 << XFS_LI_RELOG),		"RELOG" }
 
 struct xfs_item_ops {
 	unsigned flags;
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 3004aeac9110..64965a861346 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -16,6 +16,8 @@ struct xfs_log_vec;
 void	xfs_trans_init(struct xfs_mount *);
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
+void	xfs_trans_relog_item(struct xfs_trans *, struct xfs_log_item *);
+void	xfs_trans_relog_item_cancel(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
 void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *lv,
-- 
2.21.3

