Return-Path: <SRS0=C9JY=4P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07948C35677
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8C17246A9
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Feb 2020 14:48:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ehGvLIII"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731701AbgB0OsQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:48:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54557 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729970AbgB0Nn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 08:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582811006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AoQqqY3wn4EHZR/Bdqhd1nQQjld+kUALV2aa+N73378=;
        b=ehGvLIIIoXVv75ahgvLP/Uw+pQiaIFwn3JH7I+oZ/GvYBRuH5VUw9ArQuMem2fEZL6wwBN
        w0+Gq1luiarBD0Qv4wpNmImIYpRc1WUgViyOXlInkjcbc4gXl0hSiXaVEFYfrK2U9RiSjL
        wuAJT17rYH2tkgjdAfDhK6W/efoWTzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-sKeIUis6NL6ckMWEjn1IwA-1; Thu, 27 Feb 2020 08:43:24 -0500
X-MC-Unique: sKeIUis6NL6ckMWEjn1IwA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 472931005512
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:23 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DBB65DA7C
        for <linux-xfs@vger.kernel.org>; Thu, 27 Feb 2020 13:43:22 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC v5 PATCH 4/9] xfs: automatic relogging item management
Date:   Thu, 27 Feb 2020 08:43:16 -0500
Message-Id: <20200227134321.7238-5-bfoster@redhat.com>
In-Reply-To: <20200227134321.7238-1-bfoster@redhat.com>
References: <20200227134321.7238-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

As implemented by the previous patch, relogging can be enabled on
any item via a relog enabled transaction (which holds a reference to
an active relog ticket). Add a couple log item flags to track relog
state of an arbitrary log item. The item holds a reference to the
global relog ticket when relogging is enabled and releases the
reference when relogging is disabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trace.h      |  2 ++
 fs/xfs/xfs_trans.c      | 36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h      |  6 +++++-
 fs/xfs/xfs_trans_priv.h |  2 ++
 4 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a86be7f807ee..a066617ec54d 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1063,6 +1063,8 @@ DEFINE_LOG_ITEM_EVENT(xfs_ail_push);
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
index 8ac05ed8deda..f7f2411ead4e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -778,6 +778,41 @@ xfs_trans_del_item(
 	list_del_init(&lip->li_trans);
 }
=20
+void
+xfs_trans_relog_item(
+	struct xfs_log_item	*lip)
+{
+	if (!test_and_set_bit(XFS_LI_RELOG, &lip->li_flags)) {
+		xfs_trans_ail_relog_get(lip->li_mountp);
+		trace_xfs_relog_item(lip);
+	}
+}
+
+void
+xfs_trans_relog_item_cancel(
+	struct xfs_log_item	*lip,
+	bool			drain) /* wait for relogging to cease */
+{
+	struct xfs_mount	*mp =3D lip->li_mountp;
+
+	if (!test_and_clear_bit(XFS_LI_RELOG, &lip->li_flags))
+		return;
+	xfs_trans_ail_relog_put(lip->li_mountp);
+	trace_xfs_relog_item_cancel(lip);
+
+	if (!drain)
+		return;
+
+	/*
+	 * Some operations might require relog activity to cease before they ca=
n
+	 * proceed. For example, an operation must wait before including a
+	 * non-lockable log item (i.e. intent) in another transaction.
+	 */
+	while (wait_on_bit_timeout(&lip->li_flags, XFS_LI_RELOGGED,
+				   TASK_UNINTERRUPTIBLE, HZ))
+		xfs_log_force(mp, XFS_LOG_SYNC);
+}
+
 /* Detach and unlock all of the items in a transaction */
 static void
 xfs_trans_free_items(
@@ -863,6 +898,7 @@ xfs_trans_committed_bulk(
=20
 		if (aborted)
 			set_bit(XFS_LI_ABORTED, &lip->li_flags);
+		clear_and_wake_up_bit(XFS_LI_RELOGGED, &lip->li_flags);
=20
 		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
 			lip->li_ops->iop_release(lip);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index a032989943bd..fc4c25b6eee4 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -59,12 +59,16 @@ struct xfs_log_item {
 #define	XFS_LI_ABORTED	1
 #define	XFS_LI_FAILED	2
 #define	XFS_LI_DIRTY	3	/* log item dirty in transaction */
+#define	XFS_LI_RELOG	4	/* automatically relog item */
+#define	XFS_LI_RELOGGED	5	/* item relogged (not committed) */
=20
 #define XFS_LI_FLAGS \
 	{ (1 << XFS_LI_IN_AIL),		"IN_AIL" }, \
 	{ (1 << XFS_LI_ABORTED),	"ABORTED" }, \
 	{ (1 << XFS_LI_FAILED),		"FAILED" }, \
-	{ (1 << XFS_LI_DIRTY),		"DIRTY" }
+	{ (1 << XFS_LI_DIRTY),		"DIRTY" }, \
+	{ (1 << XFS_LI_RELOG),		"RELOG" }, \
+	{ (1 << XFS_LI_RELOGGED),	"RELOGGED" }
=20
 struct xfs_item_ops {
 	unsigned flags;
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 839df6559b9f..d1edec1cb8ad 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -16,6 +16,8 @@ struct xfs_log_vec;
 void	xfs_trans_init(struct xfs_mount *);
 void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
+void	xfs_trans_relog_item(struct xfs_log_item *);
+void	xfs_trans_relog_item_cancel(struct xfs_log_item *, bool);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
=20
 void	xfs_trans_committed_bulk(struct xfs_ail *ailp, struct xfs_log_vec *=
lv,
--=20
2.21.1

