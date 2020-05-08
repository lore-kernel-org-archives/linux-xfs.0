Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA8FC54E7E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C5BE20870
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QDZL/5Zs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgEHGey (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727768AbgEHGey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F95C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=sDwXDTLufmWpa/ZSfyKKEd+1LRDyaH1VUuMhBDBwN1o=; b=QDZL/5ZsYnxuwDYk7FUnbvQ/X8
        G120lHhJiuSLsF1fX3DGnSCGKuCucqp9K6+sdJCgk0MkH1tR1M3gK5HJyEp/MxNZ8MW7WagBnGse7
        O8xGWIG8x++/j34a1lL0tS9sm3Z/BwABsD2tHIOSD9oGGcVJM7rtnMrllAl8SdMQvg2+QXSXuodkd
        dNxGi78IMzJGbNN2dLr0/h81Uezx9SMSBtMzMEldEro9tOfYuJQZnGa7Cqt4+TiHPGcnafpeiAqOD
        /3kxapzC3oVRTOfzQHfzBUGiQXHhXieDFit461CBXWgS96cwW5cRQIYfUjqkJ2bvwyboX0OqBp5F0
        G7z6kE3Q==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwaz-0002wz-SD
        for linux-xfs@vger.kernel.org; Fri, 08 May 2020 06:34:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/12] xfs: remove the NULL fork handling in xfs_bmapi_read
Date:   Fri,  8 May 2020 08:34:23 +0200
Message-Id: <20200508063423.482370-13-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that we fully verify the inode forks before they are added to the
inode cache, the crash reported in

  https://bugzilla.kernel.org/show_bug.cgi?id=204031

can't happen anymore, as we'll never let an inode that has inconsistent
nextents counts vs the presence of an in-core attr fork leak into the
inactivate code path.  So remove the work around to try to handle the
case, and just return an error and warn if the fork is not present.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 76be1a18e2442..34518a6dc7376 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3891,7 +3891,8 @@ xfs_bmapi_read(
 	int			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp;
+	int			whichfork = xfs_bmapi_whichfork(flags);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_bmbt_irec	got;
 	xfs_fileoff_t		obno;
 	xfs_fileoff_t		end;
@@ -3899,12 +3900,14 @@ xfs_bmapi_read(
 	int			error;
 	bool			eof = false;
 	int			n = 0;
-	int			whichfork = xfs_bmapi_whichfork(flags);
 
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
+	if (WARN_ON_ONCE(!ifp))
+		return -EFSCORRUPTED;
+
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
@@ -3915,21 +3918,6 @@ xfs_bmapi_read(
 
 	XFS_STATS_INC(mp, xs_blk_mapr);
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (!ifp) {
-		/*
-		 * A missing attr ifork implies that the inode says we're in
-		 * extents or btree format but failed to pass the inode fork
-		 * verifier while trying to load it.  Treat that as a file
-		 * corruption too.
-		 */
-#ifdef DEBUG
-		xfs_alert(mp, "%s: inode %llu missing fork %d",
-				__func__, ip->i_ino, whichfork);
-#endif /* DEBUG */
-		return -EFSCORRUPTED;
-	}
-
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, ip, whichfork);
 		if (error)
-- 
2.26.2

