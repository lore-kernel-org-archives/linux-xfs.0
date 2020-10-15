Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E18C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0225D22269
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 07:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgJOHWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 03:22:01 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60061 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728671AbgJOHWA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 03:22:00 -0400
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 17F703AB13B
        for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2020 18:21:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-000hv9-D6
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1kSxaG-006qLR-5T
        for linux-xfs@vger.kernel.org; Thu, 15 Oct 2020 18:21:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/27] xfsprogs: remove unused IO_DEBUG functionality
Date:   Thu, 15 Oct 2020 18:21:30 +1100
Message-Id: <20201015072155.1631135-3-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015072155.1631135-1-david@fromorbit.com>
References: <20201015072155.1631135-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=afefHYAZSVUA:10 a=20KFwNOVAAAA:8 a=tkpNF_jWTK5usc8N39sA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Similar to the XFS_BUF_TRACING code, this is largely unused and not
hugely helpfule for tracing buffer IO. Remove it to simplify the
conversion process to the kernel buffer cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/Makefile |  1 -
 libxfs/rdwr.c   | 45 ---------------------------------------------
 2 files changed, 46 deletions(-)

diff --git a/libxfs/Makefile b/libxfs/Makefile
index 44b23816e20b..de595b7cd49f 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -102,7 +102,6 @@ CFILES = cache.c \
 
 #
 # Tracing flags:
-# -DIO_DEBUG		reads and writes of buffers
 # -DMEM_DEBUG		all zone memory use
 # -DLI_DEBUG		log item (ino/buf) manipulation
 # -DXACT_DEBUG		transaction state changes
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 51494f71fcfa..11ff7f44b32a 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -340,12 +340,6 @@ libxfs_getbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen)
 	bp =__libxfs_getbufr(blen);
 	if (bp)
 		libxfs_initbuf(bp, btp, blkno, blen);
-#ifdef IO_DEBUG
-	printf("%lx: %s: allocated %u bytes buffer, key=0x%llx(0x%llx), %p\n",
-		pthread_self(), __FUNCTION__, blen,
-		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
-#endif
-
 	return bp;
 }
 
@@ -374,12 +368,6 @@ libxfs_getbufr_map(struct xfs_buftarg *btp, xfs_daddr_t blkno, int bblen,
 	bp =__libxfs_getbufr(blen);
 	if (bp)
 		libxfs_initbuf_map(bp, btp, map, nmaps);
-#ifdef IO_DEBUG
-	printf("%lx: %s: allocated %u bytes buffer, key=0x%llx(0x%llx), %p\n",
-		pthread_self(), __FUNCTION__, blen,
-		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
-#endif
-
 	return bp;
 }
 
@@ -427,12 +415,6 @@ __cache_lookup(
 
 	cache_node_set_priority(libxfs_bcache, cn,
 			cache_node_get_priority(cn) - CACHE_PREFETCH_PRIORITY);
-#ifdef IO_DEBUG
-	printf("%lx %s: hit buffer %p for bno = 0x%llx/0x%llx\n",
-		pthread_self(), __FUNCTION__,
-		bp, bp->b_bn, (long long)LIBXFS_BBTOOFF64(key->blkno));
-#endif
-
 	*bpp = bp;
 	return 0;
 }
@@ -607,11 +589,6 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, xfs_buf_t *bp,
 	    bp->b_bn == blkno &&
 	    bp->b_bcount == bytes)
 		bp->b_flags |= LIBXFS_B_UPTODATE;
-#ifdef IO_DEBUG
-	printf("%lx: %s: read %u bytes, error %d, blkno=0x%llx(0x%llx), %p\n",
-		pthread_self(), __FUNCTION__, bytes, error,
-		(long long)LIBXFS_BBTOOFF64(blkno), (long long)blkno, bp);
-#endif
 	bp->b_error = error;
 	return error;
 }
@@ -654,11 +631,6 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 
 	if (!error)
 		bp->b_flags |= LIBXFS_B_UPTODATE;
-#ifdef IO_DEBUG
-	printf("%lx: %s: read %lu bytes, error %d, blkno=%llu(%llu), %p\n",
-		pthread_self(), __FUNCTION__, buf - (char *)bp->b_addr, error,
-		(long long)LIBXFS_BBTOOFF64(bp->b_bn), (long long)bp->b_bn, bp);
-#endif
 	return error;
 }
 
@@ -728,11 +700,6 @@ libxfs_buf_read_map(
 		goto err;
 
 ok:
-#ifdef IO_DEBUGX
-	printf("%lx: %s: read %lu bytes, error %d, blkno=%llu(%llu), %p\n",
-		pthread_self(), __FUNCTION__, buf - (char *)bp->b_addr, error,
-		(long long)LIBXFS_BBTOOFF64(bp->b_bn), (long long)bp->b_bn, bp);
-#endif
 	*bpp = bp;
 	return 0;
 err:
@@ -881,12 +848,6 @@ libxfs_bwrite(
 		}
 	}
 
-#ifdef IO_DEBUG
-	printf("%lx: %s: wrote %u bytes, blkno=%llu(%llu), %p, error %d\n",
-			pthread_self(), __FUNCTION__, bp->b_bcount,
-			(long long)LIBXFS_BBTOOFF64(bp->b_bn),
-			(long long)bp->b_bn, bp, bp->b_error);
-#endif
 	if (bp->b_error) {
 		fprintf(stderr,
 	_("%s: write failed on %s bno 0x%llx/0x%x, err=%d\n"),
@@ -907,12 +868,6 @@ void
 libxfs_buf_mark_dirty(
 	struct xfs_buf	*bp)
 {
-#ifdef IO_DEBUG
-	printf("%lx: %s: dirty blkno=%llu(%llu)\n",
-			pthread_self(), __FUNCTION__,
-			(long long)LIBXFS_BBTOOFF64(bp->b_bn),
-			(long long)bp->b_bn);
-#endif
 	/*
 	 * Clear any error hanging over from reading the buffer. This prevents
 	 * subsequent reads after this write from seeing stale errors.
-- 
2.28.0

