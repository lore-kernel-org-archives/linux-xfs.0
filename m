Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961A8CA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:05:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A93A2087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:05:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H0vWsCCi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfJ3SFK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 14:05:10 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbfJ3SFJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 14:05:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Zq4HncUFoGURlO/eq+DEVNSYPEL81D1r1XNRLT/dWuw=; b=H0vWsCCi3WZbstPV4HGPdlvSB0
        rICIWERaHMLHJCkft+GSjwlVPXTCXOLTbFDyYmGeD5yJJfWwAi6VNq4OriaKckewa6GcS+zq3JMuD
        LvTlE2D/GZkOJCBqilPRrwQtxYPZuRh6pWCS31Um95JFy6h/H8VAGlnGijAgvJOc6MEq32q0SVn4t
        Pmc4ejdzS3WFvn90j3azzMEfPKUh51fvTMeXl9GJ2fhUIy6zzkRMTSdNBH9LoTX/YDAqGxQQD9dcb
        krggXqU9x4BjXcnqSfYoeIxhCS3o+Z0x5M3XdLWJV7zVJEKcqoQVLeYlayibwcyNfpEZfF+wmt28u
        fXoZkM1g==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPsLF-0006t5-NM; Wed, 30 Oct 2019 18:05:09 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 8/9] xfs: move extent zeroing to xfs_bmapi_allocate
Date:   Wed, 30 Oct 2019 11:04:18 -0700
Message-Id: <20191030180419.13045-9-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030180419.13045-1-hch@lst.de>
References: <20191030180419.13045-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move the extent zeroing case there for the XFS_BMAPI_ZERO flag outside
the low-level allocator and into xfs_bmapi_allocate, where is still
is in transaction context, but outside the very lowlevel code where
it doesn't belong.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  7 -------
 fs/xfs/libxfs/xfs_alloc.h |  4 +---
 fs/xfs/libxfs/xfs_bmap.c  | 10 ++++++----
 fs/xfs/xfs_bmap_util.c    |  7 -------
 4 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 84866c195bfc..0539d61ff12c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3084,13 +3084,6 @@ xfs_alloc_vextent(
 			args->len);
 #endif
 
-		/* Zero the extent if we were asked to do so */
-		if (args->datatype & XFS_ALLOC_USERDATA_ZERO) {
-			error = xfs_zero_extent(args->ip, args->fsbno, args->len);
-			if (error)
-				goto error0;
-		}
-
 	}
 	xfs_perag_put(args->pag);
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d6ed5d2c07c2..626384d75c9c 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -54,7 +54,6 @@ typedef struct xfs_alloc_arg {
 	struct xfs_mount *mp;		/* file system mount point */
 	struct xfs_buf	*agbp;		/* buffer for a.g. freelist header */
 	struct xfs_perag *pag;		/* per-ag struct for this agno */
-	struct xfs_inode *ip;		/* for userdata zeroing method */
 	xfs_fsblock_t	fsbno;		/* file system block number */
 	xfs_agnumber_t	agno;		/* allocation group number */
 	xfs_agblock_t	agbno;		/* allocation group-relative block # */
@@ -83,8 +82,7 @@ typedef struct xfs_alloc_arg {
  */
 #define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
 #define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
-#define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
-#define XFS_ALLOC_NOBUSY		(1 << 3)/* Busy extents not allowed */
+#define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
 
 static inline bool
 xfs_alloc_is_userdata(int datatype)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1e319a4830be..ec8ecfd46a48 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3555,8 +3555,6 @@ xfs_bmap_btalloc(
 	args.wasdel = ap->wasdel;
 	args.resv = XFS_AG_RESV_NONE;
 	args.datatype = ap->datatype;
-	if (ap->datatype & XFS_ALLOC_USERDATA_ZERO)
-		args.ip = ap->ip;
 
 	error = xfs_alloc_vextent(&args);
 	if (error)
@@ -4011,8 +4009,6 @@ xfs_bmap_alloc_userdata(
 	 * the busy list.
 	 */
 	bma->datatype = XFS_ALLOC_NOBUSY;
-	if (bma->flags & XFS_BMAPI_ZERO)
-		bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
 	if (whichfork == XFS_DATA_FORK) {
 		if (bma->offset == 0)
 			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
@@ -4071,6 +4067,12 @@ xfs_bmapi_allocate(
 	if (error || bma->blkno == NULLFSBLOCK)
 		return error;
 
+	if (bma->flags & XFS_BMAPI_ZERO) {
+		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
+		if (error)
+			return error;
+	}
+
 	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur)
 		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
 	/*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index be606f4e3a74..e953e7bda712 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -165,13 +165,6 @@ xfs_bmap_rtalloc(
 		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
 			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
 					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
-
-		/* Zero the extent if we were asked to do so */
-		if (ap->datatype & XFS_ALLOC_USERDATA_ZERO) {
-			error = xfs_zero_extent(ap->ip, ap->blkno, ap->length);
-			if (error)
-				return error;
-		}
 	} else {
 		ap->length = 0;
 	}
-- 
2.20.1

