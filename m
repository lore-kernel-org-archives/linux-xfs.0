Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411E9C43470
	for <linux-xfs@archiver.kernel.org>; Mon, 17 May 2021 17:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1101F61285
	for <linux-xfs@archiver.kernel.org>; Mon, 17 May 2021 17:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235935AbhEQRSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 May 2021 13:18:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41847 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238081AbhEQRSq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 May 2021 13:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621271849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=70Iujgi8tr5ydV9GYZf9R2r74TCsQCw8vsdPBpWGMdU=;
        b=aq5a3Pz5wDshjk8eo1y1hOdKrKShYB3vXeFabCdmKBp+Zr5g/idUPaHtoe8LIgpzIH98DR
        URfqfTYhqiB946RT18xheKA/nOQwtiMr9sE9qer1/ruX89ST9W85h9V6VwBncCW+stJEXq
        nnf5bERuQvjmQTL9SY6spdB4hWQA1yM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-q6uAKs3sPiqOyp-F_oLCBA-1; Mon, 17 May 2021 13:17:25 -0400
X-MC-Unique: q6uAKs3sPiqOyp-F_oLCBA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C17B5803620;
        Mon, 17 May 2021 17:17:24 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-80.rdu2.redhat.com [10.10.113.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68EA55D9F2;
        Mon, 17 May 2021 17:17:24 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 2/3] xfs: kick large ioends to completion workqueue
Date:   Mon, 17 May 2021 13:17:21 -0400
Message-Id: <20210517171722.1266878-3-bfoster@redhat.com>
In-Reply-To: <20210517171722.1266878-1-bfoster@redhat.com>
References: <20210517171722.1266878-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We've had reports of soft lockup warnings in the iomap ioend
completion path due to very large bios and/or bio chains. This
occurs because ioend completion touches every page associated with
the ioend. It generally requires exceedingly large (i.e. multi-GB)
bios or bio chains to reproduce a soft lockup warning, but even with
smaller ioends there's really no good reason to incur the cost of
potential cacheline misses in bio completion context. Divert ioends
larger than 1MB to the workqueue so completion occurs in non-atomic
context and can reschedule to avoid soft lockup warnings.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 84cd6cf46b12..05b1bb146f17 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -30,6 +30,13 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
 	return container_of(ctx, struct xfs_writepage_ctx, ctx);
 }
 
+/*
+ * Completion touches every page associated with the ioend. Send anything
+ * larger than 1MB (based on 4k pages) or so to the completion workqueue to
+ * avoid this work in bio completion context.
+ */
+#define XFS_LARGE_IOEND	(256ULL << PAGE_SHIFT)
+
 /*
  * Fast and loose check if this write could update the on-disk inode size.
  */
@@ -409,9 +416,14 @@ xfs_prepare_ioend(
 
 	memalloc_nofs_restore(nofs_flag);
 
-	/* send ioends that might require a transaction to the completion wq */
+	/*
+	 * Send ioends that might require a transaction or are large enough that
+	 * we don't want to do page processing in bio completion context to the
+	 * wq.
+	 */
 	if (xfs_ioend_is_append(ioend) || ioend->io_type == IOMAP_UNWRITTEN ||
-	    (ioend->io_flags & IOMAP_F_SHARED))
+	    (ioend->io_flags & IOMAP_F_SHARED) ||
+	    ioend->io_size >= XFS_LARGE_IOEND)
 		ioend->io_bio->bi_end_io = xfs_end_bio;
 	return status;
 }
-- 
2.26.3

