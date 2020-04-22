Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97927C54FCB
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A3C92075A
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0Yr+pe/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDVRyg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 13:54:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46176 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726057AbgDVRyf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 13:54:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587578073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x6KCFOqnUtdiZ1Du+dhY5RG7or6dhsWQJQJpxzsdH4k=;
        b=i0Yr+pe/w5DGBip5intHoKDBko1BVhZKXZ4VdtAvmAshtEzxTFBu8JqwI8fde+Ai8wN8GJ
        SM9i4hSTRE76RoCMLqiDnKlyGLN/Pu7D/Y1ECivG12Uu4KsdhYxf0LvxD/Jk2Gq9J0Kust
        Hgt1xxFBDqqOIbaKnXXrMmIe3zHl6Bk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-262-gg2gfcSXPoqqe059z-EGwA-1; Wed, 22 Apr 2020 13:54:32 -0400
X-MC-Unique: gg2gfcSXPoqqe059z-EGwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BD4018538B2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:31 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16E116084C
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:31 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 02/13] xfs: factor out buffer I/O failure simulation code
Date:   Wed, 22 Apr 2020 13:54:18 -0400
Message-Id: <20200422175429.38957-3-bfoster@redhat.com>
In-Reply-To: <20200422175429.38957-1-bfoster@redhat.com>
References: <20200422175429.38957-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We use the same buffer I/O failure simulation code in a few
different places. It's not much code, but it's not necessarily
self-explanatory. Factor it into a helper and document it in one
place.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_buf.c      | 23 +++++++++++++++++++----
 fs/xfs/xfs_buf.h      |  1 +
 fs/xfs/xfs_buf_item.c | 22 +++-------------------
 fs/xfs/xfs_inode.c    |  7 +------
 4 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9ec3eaf1c618..7a6bc617f0a9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1248,6 +1248,24 @@ xfs_buf_ioerror_alert(
 			-bp->b_error);
 }
=20
+/*
+ * To simulate an I/O failure, the buffer must be locked and held with a=
t least
+ * three references. The LRU reference is dropped by the stale call. The=
 buf
+ * item reference is dropped via ioend processing. The third reference i=
s owned
+ * by the caller and is dropped on I/O completion if the buffer is XBF_A=
SYNC.
+ */
+void
+xfs_buf_ioend_fail(
+	struct xfs_buf	*bp,
+	int		flags)
+{
+	bp->b_flags |=3D flags;
+	bp->b_flags &=3D ~XBF_DONE;
+	xfs_buf_stale(bp);
+	xfs_buf_ioerror(bp, -EIO);
+	xfs_buf_ioend(bp);
+}
+
 int
 xfs_bwrite(
 	struct xfs_buf		*bp)
@@ -1480,10 +1498,7 @@ __xfs_buf_submit(
=20
 	/* on shutdown we stale and complete the buffer immediately */
 	if (XFS_FORCED_SHUTDOWN(bp->b_mount)) {
-		xfs_buf_ioerror(bp, -EIO);
-		bp->b_flags &=3D ~XBF_DONE;
-		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp);
+		xfs_buf_ioend_fail(bp, 0);
 		return -EIO;
 	}
=20
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 9a04c53c2488..598b93b17d95 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -263,6 +263,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int=
 error,
 		xfs_failaddr_t failaddr);
 #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_a=
ddress)
 extern void xfs_buf_ioerror_alert(struct xfs_buf *bp, xfs_failaddr_t fa)=
;
+void xfs_buf_ioend_fail(struct xfs_buf *, int);
=20
 extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
 static inline int xfs_buf_submit(struct xfs_buf *bp)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8796adde2d12..e34298227f87 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -471,28 +471,12 @@ xfs_buf_item_unpin(
 		xfs_buf_relse(bp);
 	} else if (freed && remove) {
 		/*
-		 * There are currently two references to the buffer - the active
-		 * LRU reference and the buf log item. What we are about to do
-		 * here - simulate a failed IO completion - requires 3
-		 * references.
-		 *
-		 * The LRU reference is removed by the xfs_buf_stale() call. The
-		 * buf item reference is removed by the xfs_buf_iodone()
-		 * callback that is run by xfs_buf_do_callbacks() during ioend
-		 * processing (via the bp->b_iodone callback), and then finally
-		 * the ioend processing will drop the IO reference if the buffer
-		 * is marked XBF_ASYNC.
-		 *
-		 * Hence we need to take an additional reference here so that IO
-		 * completion processing doesn't free the buffer prematurely.
+		 * The buffer must be locked and held by the caller to simulate
+		 * an async I/O failure.
 		 */
 		xfs_buf_lock(bp);
 		xfs_buf_hold(bp);
-		bp->b_flags |=3D XBF_ASYNC;
-		xfs_buf_ioerror(bp, -EIO);
-		bp->b_flags &=3D ~XBF_DONE;
-		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp);
+		xfs_buf_ioend_fail(bp, XBF_ASYNC);
 	}
 }
=20
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d1772786af29..1aea19ca6601 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3629,12 +3629,7 @@ xfs_iflush_cluster(
 	 * xfs_buf_submit().
 	 */
 	ASSERT(bp->b_iodone);
-	bp->b_flags |=3D XBF_ASYNC;
-	bp->b_flags &=3D ~XBF_DONE;
-	xfs_buf_stale(bp);
-	xfs_buf_ioerror(bp, -EIO);
-	xfs_buf_ioend(bp);
-
+	xfs_buf_ioend_fail(bp, XBF_ASYNC);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
=20
 	/* abort the corrupt inode, as it was not attached to the buffer */
--=20
2.21.1

