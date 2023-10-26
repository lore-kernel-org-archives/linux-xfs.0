Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C31C25B67
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Oct 2023 14:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbjJZOIs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Oct 2023 10:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234902AbjJZOIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2023 10:08:47 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC68F1B6;
        Thu, 26 Oct 2023 07:08:44 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4SGSMC5Gj0z9sWp;
        Thu, 26 Oct 2023 16:08:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
        s=MBO0001; t=1698329319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5R4EGfShOD0w/jE9kidAs7NQbrorkJlAAUpuwmTA4wg=;
        b=QKW4VmSPz3yGmbngc15+Gg3LaoO684U1RfeUaYWkeDhU/B9grB/oC7Z4ukq6wcF0tc4Znc
        tR11V9zazJ5gON7GIh8HE6XrzPLWUyrlp+DfhL5/LbInCUav9+XaeUuviApBaqJSAr0QUx
        wDXYyfmUKGXMCrDvysrboc4NkVSnAIlI4joZBsCyruAhvT3iQ/LM9vBBPk/1N4WpqneY3i
        9vE6Cq+SOVg/XTKX7Lv+NEx59lX1fT6JsCrvqUuuu1yetQbXLfFqVyXroUiRbX0jDluXsJ
        BBgvL45EUNdxilXjiQY718Xo6ygT/OVtpEImmq4GxVn9U54OIOL3AEVHaTKgMw==
From:   Pankaj Raghav <kernel@pankajraghav.com>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     willy@infradead.org, djwong@kernel.org, mcgrof@kernel.org,
        hch@lst.de, da.gomez@samsung.com, gost.dev@samsung.com,
        david@fromorbit.com, Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] iomap: fix iomap_dio_zero() for fs bs > system page size
Date:   Thu, 26 Oct 2023 16:08:32 +0200
Message-Id: <20231026140832.1089824-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Pankaj Raghav <p.raghav@samsung.com>

iomap_dio_zero() will pad a fs block with zeroes if the direct IO size
< fs block size. iomap_dio_zero() has an implicit assumption that fs block
size < page_size. This is true for most filesystems at the moment.

If the block size > page size (Large block sizes)[1], this will send the
contents of the page next to zero page(as len > PAGE_SIZE) to the
underlying block device, causing FS corruption.

iomap is a generic infrastructure and it should not make any assumptions
about the fs block size and the page size of the system.

Fixes: db074436f421 ("iomap: move the direct IO code into a separate file")
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

[1] https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
---
I had initially planned on sending this as a part of LBS patches but I                                                                                                                                                                                                                                                  
think this can go as a standalone patch as it is a generic fix to iomap.                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                        
@Dave chinner This fixes the corruption issue you were seeing in                                                                                                                                                                                                                                                        
generic/091 for bs=64k in [2]                                                                                                                                                                                                                                                                                           
                                                                                                                                                                                                                                                                                                                        
[2] https://lore.kernel.org/lkml/ZQfbHloBUpDh+zCg@dread.disaster.area/

 fs/iomap/direct-io.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index bcd3f8cf5ea4..04f6c5548136 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -239,14 +239,23 @@ static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 	struct page *page = ZERO_PAGE(0);
 	struct bio *bio;
 
-	bio = iomap_dio_alloc_bio(iter, dio, 1, REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
+	WARN_ON_ONCE(len > (BIO_MAX_VECS * PAGE_SIZE));
+
+	bio = iomap_dio_alloc_bio(iter, dio, BIO_MAX_VECS,
+				  REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
 	fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
 				  GFP_KERNEL);
+
 	bio->bi_iter.bi_sector = iomap_sector(&iter->iomap, pos);
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
-	__bio_add_page(bio, page, len, 0);
+	while (len) {
+		unsigned int io_len = min_t(unsigned int, len, PAGE_SIZE);
+
+		__bio_add_page(bio, page, io_len, 0);
+		len -= io_len;
+	}
 	iomap_dio_submit_bio(iter, dio, bio, pos);
 }
 

base-commit: 05d3ef8bba77c1b5f98d941d8b2d4aeab8118ef1
-- 
2.40.1

