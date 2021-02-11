Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21174C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAEBC64E8B
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 14:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhBKOtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 09:49:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229879AbhBKOkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Feb 2021 09:40:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613054355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=brwTVKwC27kBrbOCR9ZehGaZTm2TDB/2XjwNcyYznsk=;
        b=Bbg8w16meulKox8INKJwtKlfIrnsuBq9UdaTjpso8WcFxMP/KjkwKVrEpZjW99E+sKTqGS
        F+CLJL40TTj4wK8Y4h/R+HQuV3v1dEQ+KV84PV8J705ke6bCIzMLO3ExakET7MZvXYj2Pq
        bfuN0+5i4OM7EVBdUvmlT/YBY0g4r+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-SR2Ju4nNPMa8GO23JmUxKQ-1; Thu, 11 Feb 2021 09:39:12 -0500
X-MC-Unique: SR2Ju4nNPMa8GO23JmUxKQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F355E80197D
        for <linux-xfs@vger.kernel.org>; Thu, 11 Feb 2021 14:39:11 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A34155D76F
        for <linux-xfs@vger.kernel.org>; Thu, 11 Feb 2021 14:39:11 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: consider shutdown in bmapbt cursor delete assert
Date:   Thu, 11 Feb 2021 09:39:11 -0500
Message-Id: <20210211143911.289537-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The assert in xfs_btree_del_cursor() checks that the bmapbt block
allocation field has been handled correctly before the cursor is
freed. This field is used for accurate calculation of indirect block
reservation requirements (for delayed allocations), for example.
generic/019 reproduces a scenario where this assert fails because
the filesystem has shutdown while in the middle of a bmbt record
insertion. This occurs after a bmbt block has been allocated via the
cursor but before the higher level bmap function (i.e.
xfs_bmap_add_extent_hole_real()) completes and resets the field.

Update the assert to accommodate the transient state if the
filesystem has shutdown. While here, clean up the indentation and
comments in the function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c4d7a9241dc3..b56ff451adce 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -353,20 +353,17 @@ xfs_btree_free_block(
  */
 void
 xfs_btree_del_cursor(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		error)		/* del because of error */
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			error)		/* del because of error */
 {
-	int		i;		/* btree level */
+	int			i;		/* btree level */
 
 	/*
-	 * Clear the buffer pointers, and release the buffers.
-	 * If we're doing this in the face of an error, we
-	 * need to make sure to inspect all of the entries
-	 * in the bc_bufs array for buffers to be unlocked.
-	 * This is because some of the btree code works from
-	 * level n down to 0, and if we get an error along
-	 * the way we won't have initialized all the entries
-	 * down to 0.
+	 * Clear the buffer pointers and release the buffers. If we're doing
+	 * this because of an error, inspect all of the entries in the bc_bufs
+	 * array for buffers to be unlocked. This is because some of the btree
+	 * code works from level n down to 0, and if we get an error along the
+	 * way we won't have initialized all the entries down to 0.
 	 */
 	for (i = 0; i < cur->bc_nlevels; i++) {
 		if (cur->bc_bufs[i])
@@ -374,17 +371,11 @@ xfs_btree_del_cursor(
 		else if (!error)
 			break;
 	}
-	/*
-	 * Can't free a bmap cursor without having dealt with the
-	 * allocated indirect blocks' accounting.
-	 */
-	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP ||
-	       cur->bc_ino.allocated == 0);
-	/*
-	 * Free the cursor.
-	 */
+
+	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
+	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
-		kmem_free((void *)cur->bc_ops);
+		kmem_free(cur->bc_ops);
 	kmem_cache_free(xfs_btree_cur_zone, cur);
 }
 
-- 
2.26.2

