Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A02C5518E
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 705442082E
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B7yRmQq0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDVRyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 13:54:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42254 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726116AbgDVRyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 13:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587578075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwN86eiQLeLWIzHje4NoJJ/KI0nDURYGcSgUyC/ugUg=;
        b=B7yRmQq0eQ24bKhuzFyvU2UIFRsVaUf1HTr5N/66s6AA85qkBibSm7ttE1DLJQXW6hJKc/
        LflV2kFkrpgyvgc7ChDmdC9HBh5aRaITKOTR2CWN8pF93IrwRGzd1A4FjCZAuXsVWTeFyG
        emRrlyAhl19IHr1CzRHP1cfx2IVh3tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-Pzj5KKotPs67RFP5bGy4Pw-1; Wed, 22 Apr 2020 13:54:33 -0400
X-MC-Unique: Pzj5KKotPs67RFP5bGy4Pw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7B9C100CCC1
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:32 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 631886084A
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:32 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 05/13] xfs: ratelimit unmount time per-buffer I/O error message
Date:   Wed, 22 Apr 2020 13:54:21 -0400
Message-Id: <20200422175429.38957-6-bfoster@redhat.com>
In-Reply-To: <20200422175429.38957-1-bfoster@redhat.com>
References: <20200422175429.38957-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

At unmount time, XFS emits a warning for every in-core buffer that
might have undergone a write error. In practice this behavior is
probably reasonable given that the filesystem is likely short lived
once I/O errors begin to occur consistently. Under certain test or
otherwise expected error conditions, this can spam the logs and slow
down the unmount.

We already have a ratelimit state defined for buffers failing
writeback. Fold this state into the buftarg and reuse it for the
unmount time errors.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c      | 13 +++++++++++--
 fs/xfs/xfs_buf.h      |  1 +
 fs/xfs/xfs_buf_item.c | 10 +---------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7a6bc617f0a9..c28a93d2fd8c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1684,10 +1684,12 @@ xfs_wait_buftarg(
 			struct xfs_buf *bp;
 			bp =3D list_first_entry(&dispose, struct xfs_buf, b_lru);
 			list_del_init(&bp->b_lru);
-			if (bp->b_flags & XBF_WRITE_FAIL) {
+			if (bp->b_flags & XBF_WRITE_FAIL &&
+			    ___ratelimit(&bp->b_target->bt_ioerror_rl,
+					 "XFS: Corruption Alert")) {
 				xfs_alert(btp->bt_mount,
 "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!"=
,
-					(long long)bp->b_bn);
+					  (long long)bp->b_bn);
 				xfs_alert(btp->bt_mount,
 "Please run xfs_repair to determine the extent of the problem.");
 			}
@@ -1828,6 +1830,13 @@ xfs_alloc_buftarg(
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
index 598b93b17d95..10492f68fd4b 100644
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
index e34298227f87..23cbfeb82183 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -480,14 +480,6 @@ xfs_buf_item_unpin(
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
@@ -518,7 +510,7 @@ xfs_buf_item_push(
=20
 	/* has a previous flush failed due to IO errors? */
 	if ((bp->b_flags & XBF_WRITE_FAIL) &&
-	    ___ratelimit(&xfs_buf_write_fail_rl_state, "XFS: Failing async writ=
e")) {
+	    ___ratelimit(&bp->b_target->bt_ioerror_rl, "XFS: Failing async writ=
e")) {
 		xfs_warn(bp->b_mount,
 "Failing async write on buffer block 0x%llx. Retrying async write.",
 			 (long long)bp->b_bn);
--=20
2.21.1

