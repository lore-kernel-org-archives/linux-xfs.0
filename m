Return-Path: <SRS0=ELsP=5W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC036C2BA2B
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2BD721D90
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Apr 2020 12:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NPNgIPxG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgDFMgj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 08:36:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:34961 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727652AbgDFMgi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Apr 2020 08:36:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586176597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hFaHcyKUQI57qhzsYp+uXg4rgeMkWYVn5dmwWJjFxrU=;
        b=NPNgIPxGqRvH1IabCfvB4B+Z61QbS0R3NUcoZ+zoL8vmPcN3R13I0AFkSGZltC+Qi9QZmf
        B/b6mmUWJ5EDI2se1JCmkSbUHhT6ynsDXyAyKKMAc0eVNe7UCZb3QSrku41ayv/bIaFyEZ
        KkLwRnCeb+RwqWdRK9wzABSKyhXJhko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-JBPlytlJO8Gi12pD3h7x_g-1; Mon, 06 Apr 2020 08:36:35 -0400
X-MC-Unique: JBPlytlJO8Gi12pD3h7x_g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AEB9DBB2
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:34 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C37FF60BFB
        for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2020 12:36:33 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v6 PATCH 01/10] xfs: automatic relogging item management
Date:   Mon,  6 Apr 2020 08:36:23 -0400
Message-Id: <20200406123632.20873-2-bfoster@redhat.com>
In-Reply-To: <20200406123632.20873-1-bfoster@redhat.com>
References: <20200406123632.20873-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
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
index a4323a63438d..b683c94556a3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1068,6 +1068,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_pinned);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_locked);
 DEFINE_LOG_ITEM_EVENT(xfs_ail_flushing);
+DEFINE_LOG_ITEM_EVENT(xfs_relog_item);
+DEFINE_LOG_ITEM_EVENT(xfs_relog_item_cancel);
=20
 DECLARE_EVENT_CLASS(xfs_ail_class,
 	TP_PROTO(struct xfs_log_item *lip, xfs_lsn_t old_lsn, xfs_lsn_t new_lsn=
),
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 28b983ff8b11..4fbe11485bbb 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -770,6 +770,26 @@ xfs_trans_del_item(
 	list_del_init(&lip->li_trans);
 }
=20
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
index 752c7fef9de7..9ea0f415e5ca 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -59,12 +59,14 @@ struct xfs_log_item {
 #define	XFS_LI_ABORTED	1
 #define	XFS_LI_FAILED	2
 #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
+#define	XFS_LI_RELOG	4	/* automatically relog item */
=20
 #define XFS_LI_FLAGS \
 	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
 	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
 	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
-	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
+	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
+	{ (1 << XFS_LI_RELOG),		"RELOG" }
=20
 struct xfs_item_ops {
 	unsigned flags;
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 35655eac01a6..c890794314a6 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -16,6 +16,8 @@ struct xfs_log_vec;
 void	xfs_trans_init(struct xfs_mount *);
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
+void	xfs_trans_relog_item(struct xfs_trans *, struct xfs_log_item *);
+void	xfs_trans_relog_item_cancel(struct xfs_trans *, struct xfs_log_item=
 *);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
=20
 void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *=
lv,
--=20
2.21.1

