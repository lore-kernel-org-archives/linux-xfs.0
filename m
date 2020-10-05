Return-Path: <SRS0=eQWr=DM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABA5C4363A
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 15:21:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46F05207BC
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Oct 2020 15:21:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MpgbUFxA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgJEPVH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Oct 2020 11:21:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51195 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725960AbgJEPVH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Oct 2020 11:21:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601911265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hnW4zQ5CZEz0tnuomz7d5q0aSypy1kjZEOXZe9vGNgo=;
        b=MpgbUFxAWjoEfIEXIqS1oOIQg/ylyKsMsUO+lQHnLyuA54+7wvy2483bH4BeYoBtFYghoR
        A/z/nECD67pHdvC885xMbDTSf2D+rGuQ0xQ6xq1iUt3sjn+Gi4Q5EvAlsaEhjL1s4Xf6ye
        /nYFgJfCizl71woXZKlZyDiujNkS4H0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-8HSL-yvDOwSdMR8iD516nw-1; Mon, 05 Oct 2020 11:21:04 -0400
X-MC-Unique: 8HSL-yvDOwSdMR8iD516nw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F3CE1DDEF;
        Mon,  5 Oct 2020 15:21:03 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0A5310001B3;
        Mon,  5 Oct 2020 15:21:02 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/2] xfs: kick extra large ioends to completion workqueue
Date:   Mon,  5 Oct 2020 11:21:02 -0400
Message-Id: <20201005152102.15797-1-bfoster@redhat.com>
In-Reply-To: <20201002153357.56409-3-bfoster@redhat.com>
References: <20201002153357.56409-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We've had reports of soft lockup warnings in the iomap ioend
completion path due to very large bios and/or bio chains. Divert any
ioends with 256k or more pages to process to the workqueue so
completion occurs in non-atomic context and can reschedule to avoid
soft lockup warnings.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Fix type in macro.

 fs/xfs/xfs_aops.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3e061ea99922..c00cc0624986 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -30,6 +30,13 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
 	return container_of(ctx, struct xfs_writepage_ctx, ctx);
 }
 
+/*
+ * Kick extra large ioends off to the workqueue. Completion will process a lot
+ * of pages for a large bio or bio chain and a non-atomic context is required to
+ * reschedule and avoid soft lockup warnings.
+ */
+#define XFS_LARGE_IOEND	(262144ULL << PAGE_SHIFT)
+
 /*
  * Fast and loose check if this write could update the on-disk inode size.
  */
@@ -239,7 +246,8 @@ static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
 {
 	return ioend->io_private ||
 		ioend->io_type == IOMAP_UNWRITTEN ||
-		(ioend->io_flags & IOMAP_F_SHARED);
+		(ioend->io_flags & IOMAP_F_SHARED) ||
+		(ioend->io_size >= XFS_LARGE_IOEND);
 }
 
 STATIC void
-- 
2.25.4

