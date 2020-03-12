Return-Path: <SRS0=K4IM=45=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D306C1975A
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6078D20716
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Mar 2020 14:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OoJ1wZsq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgCLORb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Mar 2020 10:17:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44838 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgCLORa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:17:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=vS12AWsf58janhk9iuGhjFBnb85sVIiPIxLyc8eJkuY=; b=OoJ1wZsq08bzCzqNDnM5KBFUkI
        k7llXq7tLwjsN+LBkv8eigfaZB0bgJb43aWYzyDnuPfr333WJja0Lgv2qoWMA7fs2wcNKLrXeza9R
        4eH3d4XkQ78YEpsXRZBQLz9zFKJQIdNb7Fobd5bgrwgLESg1QK/H96OVnC1KoCLXLT0HbWyKwotUD
        z3C/hETpLG6uJQ/FNV0YhLZROUmims0VPOCX7bQXh0Mb5utO6x7AOG8QJtpCPHhGSgMYI6lWoACZe
        3hgmTEAMHJCs9Apktz4l3d4R1hPAP7k0T7SQxO/Q2XGmtWbiIh2jW8/vlVn/WfRyy/qTsMznfh4bH
        VimsX5Kg==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOeQ-0001zp-81
        for linux-xfs@vger.kernel.org; Thu, 12 Mar 2020 14:17:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] libxfs: remove libxfs_iomove
Date:   Thu, 12 Mar 2020 15:17:15 +0100
Message-Id: <20200312141715.550387-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312141715.550387-1-hch@lst.de>
References: <20200312141715.550387-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This function has been removed in the kernel already.  Replace the only
user that want to zero buffers with a straight call to memset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_io.h   |  6 ------
 libxfs/libxfs_priv.h |  5 ++---
 libxfs/rdwr.c        | 24 ------------------------
 3 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index a0605882..0f682305 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -213,12 +213,6 @@ extern int	libxfs_device_zero(struct xfs_buftarg *, xfs_daddr_t, uint);
 
 extern int libxfs_bhash_size;
 
-#define LIBXFS_BREAD	0x1
-#define LIBXFS_BWRITE	0x2
-#define LIBXFS_BZERO	0x4
-
-extern void	libxfs_iomove (xfs_buf_t *, uint, int, void *, int);
-
 static inline int
 xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 {
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index d07d8f32..b5677a22 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -374,9 +374,8 @@ static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
 	return NULL;
 }
 
-#define XBRW_READ			LIBXFS_BREAD
-#define XBRW_WRITE			LIBXFS_BWRITE
-#define xfs_buf_zero(bp,off,len)     libxfs_iomove(bp,off,len,NULL,LIBXFS_BZERO)
+#define xfs_buf_zero(bp, off, len) \
+	memset((bp)->b_addr + off, 0, len);
 
 /* mount stuff */
 #define XFS_MOUNT_32BITINODES		LIBXFS_MOUNT_32BITINODES
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7430ff09..6a9895f1 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1009,30 +1009,6 @@ libxfs_buf_mark_dirty(
 	bp->b_flags |= LIBXFS_B_DIRTY;
 }
 
-void
-libxfs_iomove(xfs_buf_t *bp, uint boff, int len, void *data, int flags)
-{
-#ifdef IO_DEBUG
-	if (boff + len > bp->b_bcount) {
-		printf("Badness, iomove out of range!\n"
-			"bp=(bno 0x%llx, bytes %u) range=(boff %u, bytes %u)\n",
-			(long long)bp->b_bn, bp->b_bcount, boff, len);
-		abort();
-	}
-#endif
-	switch (flags) {
-	case LIBXFS_BZERO:
-		memset(bp->b_addr + boff, 0, len);
-		break;
-	case LIBXFS_BREAD:
-		memcpy(data, bp->b_addr + boff, len);
-		break;
-	case LIBXFS_BWRITE:
-		memcpy(bp->b_addr + boff, data, len);
-		break;
-	}
-}
-
 /* Complain about (and remember) dropping dirty buffers. */
 static void
 libxfs_whine_dirty_buf(
-- 
2.24.1

