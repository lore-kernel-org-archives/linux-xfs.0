Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 177C1C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 14:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7FAE613B4
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Apr 2021 14:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237939AbhDEO70 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:59:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237824AbhDEO70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Apr 2021 10:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617634759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QSZJYMRl0cc8uSZVv9D/u6LNlYKgsw8IAXiaOJefo6Y=;
        b=A/F/jKztLLPrfZ1UtqA1KDR2Vbe2nkdQSS6uO3SSa6Cb/Vtc458SmoYeL6cCzmN+FqjfEy
        imTYG3rNpUXEhj4MhgQmCjJLNfObWt+zA5pemO5A6WuoMVY/IEpX529rnjCSHenTVtnTMQ
        8snMgmjlDX4Clk9mMtp6RMKic3Bd6Wo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-Zy4swGu1OJG4mrICidhrdw-1; Mon, 05 Apr 2021 10:59:14 -0400
X-MC-Unique: Zy4swGu1OJG4mrICidhrdw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21A06100A916
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 14:59:05 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D78825D749
        for <linux-xfs@vger.kernel.org>; Mon,  5 Apr 2021 14:59:04 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: open code ioend needs workqueue helper
Date:   Mon,  5 Apr 2021 10:59:01 -0400
Message-Id: <20210405145903.629152-3-bfoster@redhat.com>
In-Reply-To: <20210405145903.629152-1-bfoster@redhat.com>
References: <20210405145903.629152-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Open code xfs_ioend_needs_workqueue() into the only remaining
caller.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index c1951975bd6a..63ecc04de64f 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -206,13 +206,6 @@ xfs_end_io(
 	}
 }
 
-static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
-{
-	return xfs_ioend_is_append(ioend) ||
-		ioend->io_type == IOMAP_UNWRITTEN ||
-		(ioend->io_flags & IOMAP_F_SHARED);
-}
-
 STATIC void
 xfs_end_bio(
 	struct bio		*bio)
@@ -472,7 +465,9 @@ xfs_prepare_ioend(
 
 	memalloc_nofs_restore(nofs_flag);
 
-	if (xfs_ioend_needs_workqueue(ioend))
+	/* send ioends that might require a transaction to the completion wq */
+	if (xfs_ioend_is_append(ioend) || ioend->io_type == IOMAP_UNWRITTEN ||
+	    (ioend->io_flags & IOMAP_F_SHARED))
 		ioend->io_bio->bi_end_io = xfs_end_bio;
 	return status;
 }
-- 
2.26.3

