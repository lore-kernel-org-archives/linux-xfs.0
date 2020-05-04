Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E55C4725F
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01C6D20705
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="flSXOJ75"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgEDOMH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 10:12:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56382 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729008AbgEDOMG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 10:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588601524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hifscyCk2JNucqMWnXfQmQAvC/2OfdhyhRO48RC6eJE=;
        b=flSXOJ754Gu9upTFiRHVDy2KedwGlqaLFNZ7kdZWZnbBRMGkQX2BK4oAK0rGxTJQ/d7rWq
        /aPB9/X8EOlT6FBIRSzgwozL2hRC0lxBD7sZHTJbSszv+phUgIS6X1ayp2T2y5siyxFl+w
        DSGEoG+qne7+M5L1YSIi/njICMF+bfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-NCxVlLpxONqKGilhyHJOgA-1; Mon, 04 May 2020 10:12:02 -0400
X-MC-Unique: NCxVlLpxONqKGilhyHJOgA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20FD1107ACCD
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:12:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD7AC2C259
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:12:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 14/17] xfs: remove unused iflush stale parameter
Date:   Mon,  4 May 2020 10:11:51 -0400
Message-Id: <20200504141154.55887-15-bfoster@redhat.com>
In-Reply-To: <20200504141154.55887-1-bfoster@redhat.com>
References: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The stale parameter was used to control the now unused shutdown
parameter of xfs_trans_ail_remove().

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c     | 2 +-
 fs/xfs/xfs_inode.c      | 2 +-
 fs/xfs/xfs_inode_item.c | 7 +++----
 fs/xfs/xfs_inode_item.h | 2 +-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8bf1d15be3f6..7032efcb6814 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1128,7 +1128,7 @@ xfs_reclaim_inode(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
 		/* xfs_iflush_abort() drops the flush lock */
-		xfs_iflush_abort(ip, false);
+		xfs_iflush_abort(ip);
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip)) {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6fb3e26afa8b..e0d9a5bf7507 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3702,7 +3702,7 @@ xfs_iflush(
 	return 0;
=20
 abort:
-	xfs_iflush_abort(ip, false);
+	xfs_iflush_abort(ip);
 shutdown:
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	return error;
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 1a02058178d1..cefa2484f0db 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -762,10 +762,9 @@ xfs_iflush_done(
  */
 void
 xfs_iflush_abort(
-	xfs_inode_t		*ip,
-	bool			stale)
+	struct xfs_inode		*ip)
 {
-	xfs_inode_log_item_t	*iip =3D ip->i_itemp;
+	struct xfs_inode_log_item	*iip =3D ip->i_itemp;
=20
 	if (iip) {
 		xfs_trans_ail_delete(&iip->ili_item, 0);
@@ -793,7 +792,7 @@ xfs_istale_done(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
-	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode, true);
+	xfs_iflush_abort(INODE_ITEM(lip)->ili_inode);
 }
=20
 /*
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 07a60e74c39c..a68c114b79a0 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -34,7 +34,7 @@ extern void xfs_inode_item_init(struct xfs_inode *, str=
uct xfs_mount *);
 extern void xfs_inode_item_destroy(struct xfs_inode *);
 extern void xfs_iflush_done(struct xfs_buf *, struct xfs_log_item *);
 extern void xfs_istale_done(struct xfs_buf *, struct xfs_log_item *);
-extern void xfs_iflush_abort(struct xfs_inode *, bool);
+extern void xfs_iflush_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
=20
--=20
2.21.1

