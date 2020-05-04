Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF18DC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF252075A
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NbjLe+Dp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgEDOMR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 10:12:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33914 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729032AbgEDOMR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 10:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588601535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CviHaV2KBxppL0JNJx/PRgyDM45Z5huS2DRdJq8knZQ=;
        b=NbjLe+DpSQ/pf8NusrE4Z9DoBoYKPDzbWK/kj+kde46GZDE1+CxXPcV9bBVTCrSgvT1w7+
        eDQcwqbobbh3h8cozKdb8YRBQMkaby/UFf8ydvmn6Lz+XPTu8N/hdpLwTSBGzqX3Cyvv1V
        SjJsSzbA2qO/jsSzqaKL/6K1FVfATw8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-sPMaUKMMNLasuKjU4OUZmA-1; Mon, 04 May 2020 10:11:58 -0400
X-MC-Unique: sPMaUKMMNLasuKjU4OUZmA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91811107ACF6
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:57 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B6A319C4F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:57 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 06/17] xfs: refactor ratelimited buffer error messages into helper
Date:   Mon,  4 May 2020 10:11:43 -0400
Message-Id: <20200504141154.55887-7-bfoster@redhat.com>
In-Reply-To: <20200504141154.55887-1-bfoster@redhat.com>
References: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS has some inconsistent log message rate limiting with respect to
buffer alerts. The metadata I/O error notification uses the generic
ratelimited alert, the buffer push code uses a custom rate limit and
the similar quiesce time failure checks are not rate limited at all
(when they should be).

The custom rate limit defined in the buf item code is specifically
crafted for buffer alerts. It is more aggressive than generic rate
limiting code because it must accommodate a high frequency of I/O
error events in a relative short timeframe.

Factor out the custom rate limit state from the buf item code into a
per-buftarg rate limit so various alerts are limited based on the
target. Define a buffer alert helper function and use it for the
buffer alerts that are already ratelimited.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c      | 15 +++++++++++----
 fs/xfs/xfs_buf.h      |  1 +
 fs/xfs/xfs_buf_item.c | 17 ++++-------------
 fs/xfs/xfs_message.c  | 22 ++++++++++++++++++++++
 fs/xfs/xfs_message.h  |  3 +++
 5 files changed, 41 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index fd76a84cefdd..594d5e1df6f8 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1244,10 +1244,10 @@ xfs_buf_ioerror_alert(
 	struct xfs_buf		*bp,
 	xfs_failaddr_t		func)
 {
-	xfs_alert_ratelimited(bp->b_mount,
-"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
-			func, (uint64_t)XFS_BUF_ADDR(bp), bp->b_length,
-			-bp->b_error);
+	xfs_buf_alert_ratelimited(bp, "XFS: metadata IO error",
+		"metadata I/O error in \"%pS\" at daddr 0x%llx len %d error %d",
+				  func, (uint64_t)XFS_BUF_ADDR(bp),
+				  bp->b_length, -bp->b_error);
 }
=20
 /*
@@ -1828,6 +1828,13 @@ xfs_alloc_buftarg(
 	btp->bt_bdev =3D bdev;
 	btp->bt_daxdev =3D dax_dev;
=20
+	/*
+	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
+	 * per 30 seconds so as to not spam logs too much on repeated errors.
+	 */
+	ratelimit_state_init(&btp->bt_ioerror_rl, 30 * HZ,
+			     DEFAULT_RATELIMIT_BURST);
+
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error_free;
=20
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 06ea3eef866e..050c53b739e2 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -91,6 +91,7 @@ typedef struct xfs_buftarg {
 	struct list_lru		bt_lru;
=20
 	struct percpu_counter	bt_io_count;
+	struct ratelimit_state	bt_ioerror_rl;
 } xfs_buftarg_t;
=20
 struct xfs_buf;
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b452a399a441..1f7acffc99ba 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -481,14 +481,6 @@ xfs_buf_item_unpin(
 	}
 }
=20
-/*
- * Buffer IO error rate limiting. Limit it to no more than 10 messages p=
er 30
- * seconds so as to not spam logs too much on repeated detection of the =
same
- * buffer being bad..
- */
-
-static DEFINE_RATELIMIT_STATE(xfs_buf_write_fail_rl_state, 30 * HZ, 10);
-
 STATIC uint
 xfs_buf_item_push(
 	struct xfs_log_item	*lip,
@@ -518,11 +510,10 @@ xfs_buf_item_push(
 	trace_xfs_buf_item_push(bip);
=20
 	/* has a previous flush failed due to IO errors? */
-	if ((bp->b_flags & XBF_WRITE_FAIL) &&
-	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS: Failing async writ=
e")) {
-		xfs_warn(bp->b_mount,
-"Failing async write on buffer block 0x%llx. Retrying async write.",
-			 (long long)bp->b_bn);
+	if (bp->b_flags & XBF_WRITE_FAIL) {
+		xfs_buf_alert_ratelimited(bp, "XFS: Failing async write",
+	    "Failing async write on buffer block 0x%llx. Retrying async write."=
,
+					  (long long)bp->b_bn);
 	}
=20
 	if (!xfs_buf_delwri_queue(bp, buffer_list))
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index e0f9d3b6abe9..bc66d95c8d4c 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -117,3 +117,25 @@ xfs_hex_dump(const void *p, int length)
 {
 	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1)=
;
 }
+
+void
+xfs_buf_alert_ratelimited(
+	struct xfs_buf		*bp,
+	const char		*rlmsg,
+	const char		*fmt,
+	...)
+{
+	struct xfs_mount	*mp =3D bp->b_mount;
+	struct va_format	vaf;
+	va_list			args;
+
+	/* use the more aggressive per-target rate limit for buffers */
+	if (!___ratelimit(&bp->b_target->bt_ioerror_rl, rlmsg))
+		return;
+
+	va_start(args, fmt);
+	vaf.fmt =3D fmt;
+	vaf.va =3D &args;
+	__xfs_printk(KERN_ALERT, mp, &vaf);
+	va_end(args);
+}
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 0b05e10995a0..6be2ebe3a7b9 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -62,4 +62,7 @@ void asswarn(struct xfs_mount *mp, char *expr, char *f,=
 int l);
=20
 extern void xfs_hex_dump(const void *p, int length);
=20
+void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
+			       const char *fmt, ...);
+
 #endif	/* __XFS_MESSAGE_H */
--=20
2.21.1

