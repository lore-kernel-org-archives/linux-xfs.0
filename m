Return-Path: <SRS0=Pn/S=YS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC767CA9EBC
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C260120684
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Oct 2019 15:03:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ReXwIdWI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfJYPD5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Oct 2019 11:03:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408186AbfJYPD4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 11:03:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I8CJLAeKYopFd8ew9uKctDcOxN/4V1AYtyqbUaTSBdw=; b=ReXwIdWIZD/LIkO9xOfdLu18O
        0JbdSCynra64yCpZlbxel/7pHc1WZ5OFSPbHVUqR/wKov70lv6vRTKe0ByR5Sk2nyb+69ytTzRgHZ
        R/AslVM8v/F+zmkM71CbYzDe20SUJ7vjdFJ/MOLCzWKEq7V6mKxpKAJ0rkCNCayhWS76jRXSrzMi8
        2+9YC2KFYub5wp50OwXRsk0NI4L763kml3nd71vJOELTFwjlqkghALUnmmc+K21SUE052yQ58a4l/
        sH3hZ1mZAgTfgWmP7DmCrf9Z0M8Y29XdcdMe/ozicyI/VMbioFL0rrjylnzWZaNYmAUisAmfiGhWe
        XXRBcYC6g==;
Received: from [46.189.28.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iO186-0006TH-Q7
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 15:03:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfs: simplify xfs_iomap_eof_align_last_fsb
Date:   Fri, 25 Oct 2019 17:03:29 +0200
Message-Id: <20191025150336.19411-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025150336.19411-1-hch@lst.de>
References: <20191025150336.19411-1-hch@lst.de>
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
---
 fs/xfs/xfs_bmap_util.c | 23 ---------------------
 fs/xfs/xfs_bmap_util.h |  2 --
 fs/xfs/xfs_iomap.c     | 47 ++++++++++++++++++++----------------------
 3 files changed, 22 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 11658da40640..44d6b6469303 100644
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
index c1063507e5fd..49fbc99c18ff 100644
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

