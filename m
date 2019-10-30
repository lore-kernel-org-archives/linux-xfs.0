Return-Path: <SRS0=aCB+=YX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A5CCA9EC5
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99E922087E
	for <linux-xfs@archiver.kernel.org>; Wed, 30 Oct 2019 18:04:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l4Sao9yJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfJ3SEd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Oct 2019 14:04:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38362 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfJ3SEc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 14:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=B4sydpH9g1a1OSmE7w6rMjvVqhgV8JIPioe6jMil820=; b=l4Sao9yJYhf6f0O83ebFYE6qtb
        TLHK4gpAynKdIbt7z8GLQkJXOn7YnTGfqfy+q/Axn4uCWU9kjMgc8tPbjXg12zKHon+d6P5XoXFZK
        FFBBE/ERDuqnDKWbz62mypBzSduj6Jwe75EzHYxotti4hwFDC350THGzFUf9kG/bzRIsOM+DkfAek
        zVHmfYmmWal2+7F/vS9nYtqW/QfPQcROWJfp6r0wm/q585j5oLDCHZ1cLx/0qNPfBd4tItrae2yOF
        zym7PQSodf/CQkcBat5A+IGlCujTLRv5jxI5U0mp8YFEHn2ezpOdy2g35VwXCPDmeaoJ3NHrRJJzr
        3FeCZoJg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPsKe-0005e2-D9; Wed, 30 Oct 2019 18:04:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/9] xfs: simplify xfs_iomap_eof_align_last_fsb
Date:   Wed, 30 Oct 2019 11:04:11 -0700
Message-Id: <20191030180419.13045-2-hch@lst.de>
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

By open coding xfs_bmap_last_extent instead of calling it through a
double indirection we don't need to handle an error return that
can't happen given that we are guaranteed to have the extent list in
memory already.  Also simplify the calling conventions a little and
move the extent list assert from the only caller into the function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 23 ---------------------
 fs/xfs/xfs_bmap_util.h |  2 --
 fs/xfs/xfs_iomap.c     | 47 ++++++++++++++++++++----------------------
 3 files changed, 22 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index fb31d7d6701e..be606f4e3a74 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -179,29 +179,6 @@ xfs_bmap_rtalloc(
 }
 #endif /* CONFIG_XFS_RT */
 
-/*
- * Check if the endoff is outside the last extent. If so the caller will grow
- * the allocation to a stripe unit boundary.  All offsets are considered outside
- * the end of file for an empty fork, so 1 is returned in *eof in that case.
- */
-int
-xfs_bmap_eof(
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		endoff,
-	int			whichfork,
-	int			*eof)
-{
-	struct xfs_bmbt_irec	rec;
-	int			error;
-
-	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, eof);
-	if (error || *eof)
-		return error;
-
-	*eof = endoff >= rec.br_startoff + rec.br_blockcount;
-	return 0;
-}
-
 /*
  * Extent tree block counting routines.
  */
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index 3e0fa0d363d1..9f993168b55b 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -30,8 +30,6 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
 }
 #endif /* CONFIG_XFS_RT */
 
-int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
-		     int whichfork, int *eof);
 int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
 		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 8317b936d3c1..4209c32db96d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -156,25 +156,33 @@ xfs_eof_alignment(
 	return align;
 }
 
-STATIC int
+/*
+ * Check if last_fsb is outside the last extent, and if so grow it to the next
+ * stripe unit boundary.
+ */
+static xfs_fileoff_t
 xfs_iomap_eof_align_last_fsb(
 	struct xfs_inode	*ip,
-	xfs_extlen_t		extsize,
-	xfs_fileoff_t		*last_fsb)
+	xfs_fileoff_t		end_fsb)
 {
-	xfs_extlen_t		align = xfs_eof_alignment(ip, extsize);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	xfs_extlen_t		extsz = xfs_get_extsz_hint(ip);
+	xfs_extlen_t		align = xfs_eof_alignment(ip, extsz);
+	struct xfs_bmbt_irec	irec;
+	struct xfs_iext_cursor	icur;
+
+	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 
 	if (align) {
-		xfs_fileoff_t	new_last_fsb = roundup_64(*last_fsb, align);
-		int		eof, error;
+		xfs_fileoff_t	aligned_end_fsb = roundup_64(end_fsb, align);
 
-		error = xfs_bmap_eof(ip, new_last_fsb, XFS_DATA_FORK, &eof);
-		if (error)
-			return error;
-		if (eof)
-			*last_fsb = new_last_fsb;
+		xfs_iext_last(ifp, &icur);
+		if (!xfs_iext_get_extent(ifp, &icur, &irec) ||
+		    aligned_end_fsb >= irec.br_startoff + irec.br_blockcount)
+			return aligned_end_fsb;
 	}
-	return 0;
+
+	return end_fsb;
 }
 
 int
@@ -206,19 +214,8 @@ xfs_iomap_write_direct(
 
 	ASSERT(xfs_isilocked(ip, lockmode));
 
-	if ((offset + count) > XFS_ISIZE(ip)) {
-		/*
-		 * Assert that the in-core extent list is present since this can
-		 * call xfs_iread_extents() and we only have the ilock shared.
-		 * This should be safe because the lock was held around a bmapi
-		 * call in the caller and we only need it to access the in-core
-		 * list.
-		 */
-		ASSERT(XFS_IFORK_PTR(ip, XFS_DATA_FORK)->if_flags &
-								XFS_IFEXTENTS);
-		error = xfs_iomap_eof_align_last_fsb(ip, extsz, &last_fsb);
-		if (error)
-			goto out_unlock;
+	if (offset + count > XFS_ISIZE(ip)) {
+		last_fsb = xfs_iomap_eof_align_last_fsb(ip, last_fsb);
 	} else {
 		if (nmaps && (imap->br_startblock == HOLESTARTBLOCK))
 			last_fsb = min(last_fsb, (xfs_fileoff_t)
-- 
2.20.1

