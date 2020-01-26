Return-Path: <SRS0=svvY=3P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FD6C2D0DB
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 11:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84FD720700
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jan 2020 11:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h22qdLw5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbgAZLgZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jan 2020 06:36:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47272 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387416AbgAZLgZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jan 2020 06:36:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=V/lFF5hrEvAdEMq1he1DmotMHfWBcCLI8jmu0Yihs4E=; b=h22qdLw5L7b8dWgaZSifc50m7
        C0bsCYVxQ2bf75NGRbd9N9DJ88sJKYS5MRDSXWiHxZKx+DyuHh1fDqumUtzQpii6Oq9Itnd1yJBDg
        Qnq2ZpeeN62ozuM+48SpY4aYPdTprFO2Yid7d4vdeukRDqToc4jAN6tIt8gJJsTpQXS/7U76gRZgT
        PN6jXJ7RiE7qFyWM6F1Dy3AWCbb6PddBdbAggeSmIMfCk7o3hd8A6uHoKP/Y877xiuK4+fdJ+SnT1
        9UIQYaPic3bo943UfpqgI8AAcefE/uFTy+BNsWRZWyYn22IeKB6frOVnmPbmYkQdRZ3p0gBCTSb1O
        vygXuTYRQ==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivgDH-0008Aq-SV
        for linux-xfs@vger.kernel.org; Sun, 26 Jan 2020 11:36:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] repair: remove BITS_PER_LONG cpp checks in bmap.[ch]
Date:   Sun, 26 Jan 2020 12:35:39 +0100
Message-Id: <20200126113541.787884-4-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200126113541.787884-1-hch@lst.de>
References: <20200126113541.787884-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add a little helper to validate the nex count so that we can use compile
time magic checks for sizeof long directly.  Also don't print the max
in case of an overflow as the value will always be the same.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/bmap.c | 29 +++++++++++++++++++++--------
 repair/bmap.h | 13 -------------
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/repair/bmap.c b/repair/bmap.c
index 44e43ab4..0d717cd3 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -22,6 +22,22 @@
 pthread_key_t	dblkmap_key;
 pthread_key_t	ablkmap_key;
 
+/*
+ * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
+ * limits the number of extents in an inode we can check. If we don't limit the
+ * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
+ * memory than we think we needed, and hence walk off the end of the array and
+ * corrupt memory.
+ */
+static inline bool
+blkmap_nex_valid(
+	xfs_extnum_t	nex)
+{
+	if (sizeof(long) < 64 && nex >= INT_MAX / sizeof(bmap_ext_t))
+		return false;
+	return true;
+}
+
 blkmap_t *
 blkmap_alloc(
 	xfs_extnum_t	nex,
@@ -35,8 +51,7 @@ blkmap_alloc(
 	if (nex < 1)
 		nex = 1;
 
-#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
-	if (nex > BLKMAP_NEXTS_MAX) {
+	if (!blkmap_nex_valid(nex)) {
 		do_warn(
 	_("Number of extents requested in blkmap_alloc (%d) overflows 32 bits.\n"
 	  "If this is not a corruption, then you will need a 64 bit system\n"
@@ -44,7 +59,6 @@ blkmap_alloc(
 			nex);
 		return NULL;
 	}
-#endif
 
 	key = whichfork ? ablkmap_key : dblkmap_key;
 	blkmap = pthread_getspecific(key);
@@ -278,20 +292,19 @@ blkmap_grow(
 		ASSERT(pthread_getspecific(key) == blkmap);
 	}
 
-#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
-	if (new_naexts > BLKMAP_NEXTS_MAX) {
+	if (!blkmap_nex_valid(new_naexts)) {
 		do_error(
 	_("Number of extents requested in blkmap_grow (%d) overflows 32 bits.\n"
 	  "You need a 64 bit system to repair this filesystem.\n"),
 			new_naexts);
 		return NULL;
 	}
-#endif
+
 	if (new_naexts <= 0) {
 		do_error(
 	_("Number of extents requested in blkmap_grow (%d) overflowed the\n"
-	  "maximum number of supported extents (%d).\n"),
-			new_naexts, BLKMAP_NEXTS_MAX);
+	  "maximum number of supported extents.\n"),
+			new_naexts);
 		return NULL;
 	}
 
diff --git a/repair/bmap.h b/repair/bmap.h
index 4b588df8..df9602b3 100644
--- a/repair/bmap.h
+++ b/repair/bmap.h
@@ -28,19 +28,6 @@ typedef	struct blkmap {
 #define	BLKMAP_SIZE(n)	\
 	(offsetof(blkmap_t, exts) + (sizeof(bmap_ext_t) * (n)))
 
-/*
- * For 32 bit platforms, we are limited to extent arrays of 2^31 bytes, which
- * limits the number of extents in an inode we can check. If we don't limit the
- * valid range, we can overflow the BLKMAP_SIZE() calculation and allocate less
- * memory than we think we needed, and hence walk off the end of the array and
- * corrupt memory.
- */
-#if BITS_PER_LONG == 32
-#define BLKMAP_NEXTS_MAX	((INT_MAX / sizeof(bmap_ext_t)) - 1)
-#else
-#define BLKMAP_NEXTS_MAX	INT_MAX
-#endif
-
 extern pthread_key_t dblkmap_key;
 extern pthread_key_t ablkmap_key;
 
-- 
2.24.1

