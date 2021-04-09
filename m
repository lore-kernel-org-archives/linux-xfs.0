Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42FD7C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20288610F9
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhDIOMa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:12:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232642AbhDIOM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 10:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617977534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QthF0murI2vZyrzVwBAFro69TkhhQ8LzdG/TYp/JWww=;
        b=GWN2c1T3icDBd9oNanRXfMP5JGZql+qIsuYkq1Hi5GrBlRzfifh5Q1OgWE7/8fZyk7VGse
        LXTr801AdTpgG1ZoiWAoalMzqxElrXSz4nKjdFbPcKipDUfdsPh0bYfKR70R+dLvQYb7hb
        dgVQ6A/+90ebr4OFu3WUrvtVR6Ao19c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-300-sY15Y3xXPfCCx9GUl4bvgQ-1; Fri, 09 Apr 2021 10:12:12 -0400
X-MC-Unique: sY15Y3xXPfCCx9GUl4bvgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8A2A8030A1
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:12:11 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BCD92C01F
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:12:11 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 2/5] xfs: open code ioend needs workqueue helper
Date:   Fri,  9 Apr 2021 10:12:07 -0400
Message-Id: <20210409141210.1000155-3-bfoster@redhat.com>
In-Reply-To: <20210409141210.1000155-1-bfoster@redhat.com>
References: <20210409141210.1000155-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Open code xfs_ioend_needs_workqueue() into the only remaining
caller.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index ccb1a9119d4f..9d149fc5ec15 100644
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

