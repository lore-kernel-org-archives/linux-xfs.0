Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CADDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 14:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D9566112E
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Nov 2021 14:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhKKOLL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Nov 2021 09:11:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231739AbhKKOLK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Nov 2021 09:11:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636639701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bs6l8BRCwMtsoM2Wdbgw5at/O+nPht7nUCbKrMdH2m8=;
        b=ARBsbJQ8kBcegBYh28KonHtv8fZI69MVJPkoUdrnj3vxRTuhKPEpypKgv7CJScv53K+5fm
        mtdXpBmehNwuv5kLdFQ7fFnO+JkZVq7AK8osLuSTLCerWLaGS3L14B6aoDoGz4U5Esa3OU
        Ny7Kldqqk6LQkd+Z0oiID6ZkpIffkFM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-AQw5-xHqOgSogN255HGVbA-1; Thu, 11 Nov 2021 09:08:17 -0500
X-MC-Unique: AQw5-xHqOgSogN255HGVbA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0F391882FB3;
        Thu, 11 Nov 2021 14:08:16 +0000 (UTC)
Received: from max.localdomain (unknown [10.40.195.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A2815D6B1;
        Thu, 11 Nov 2021 14:08:02 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] iomap: Fix iomap_readahead_iter error handling
Date:   Thu, 11 Nov 2021 15:08:02 +0100
Message-Id: <20211111140802.577144-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In iomap_readahead_iter, deal with potential iomap_readpage_iter errors.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 1753c26c8e76..9f1e329e8b2c 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -370,6 +370,8 @@ static loff_t iomap_readahead_iter(const struct iomap_iter *iter,
 			ctx->cur_page_in_bio = false;
 		}
 		ret = iomap_readpage_iter(iter, ctx, done);
+		if (ret < 0)
+			return ret;
 	}
 
 	return done;
-- 
2.31.1

