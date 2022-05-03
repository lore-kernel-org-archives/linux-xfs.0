Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5474BC433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  3 May 2022 21:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiECVkw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 May 2022 17:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242965AbiECVkv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 May 2022 17:40:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6E51326F4
        for <linux-xfs@vger.kernel.org>; Tue,  3 May 2022 14:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651613837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aStIUsv3bUno6wgnE6p+ahkgDftecN0R+3tSGZd7L94=;
        b=DcLMlQTyGPwGv01XlFshDdWXX15it/MByFdVchnCdhp0hiZZuP+C6HxUPqK1veJ71ZQlPv
        BtlgZdaePnhOpTV6wnbPDKegQlx/6tFv9XfZzbQ8K0iix577hHlvYx5SqzPHPM9Oo3Yvjd
        tN2GgzmwY9cmGolmnKVl1KSwj2XXdL4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-347-wXiZ68ZPOoa8tNLWueJUVA-1; Tue, 03 May 2022 17:36:49 -0400
X-MC-Unique: wXiZ68ZPOoa8tNLWueJUVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B82F94A2B5;
        Tue,  3 May 2022 21:36:48 +0000 (UTC)
Received: from max.localdomain (unknown [10.40.194.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C14CF1546E0B;
        Tue,  3 May 2022 21:36:46 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] iomap: iomap_write_failed fix
Date:   Tue,  3 May 2022 23:36:45 +0200
Message-Id: <20220503213645.3273828-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The @lend parameter of truncate_pagecache_range() should be the offset
of the last byte of the hole, not the first byte beyond it.

Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure")
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8ce8720093b9..358ee1fb6f0d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -531,7 +531,8 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 	 * write started inside the existing inode size.
 	 */
 	if (pos + len > i_size)
-		truncate_pagecache_range(inode, max(pos, i_size), pos + len);
+		truncate_pagecache_range(inode, max(pos, i_size),
+					 pos + len - 1);
 }
 
 static int iomap_read_folio_sync(loff_t block_start, struct folio *folio,
-- 
2.35.1

