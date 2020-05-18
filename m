Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D49C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D02620758
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nahELTat"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgERREu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERREu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 13:04:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A940AC061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 10:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=og+HZA99lyMYFqQ2mYARlGEklpPTyQGE97h838sZk4g=; b=nahELTatNm+F5eSYsG6umiGyuL
        TIgCuTKJAtc2oJQAYdjjXzeI+TxJt5fVpPDlILnVlIYiib2A+oJK8J/gurGuZCmc2jwa+OTqOQ/xv
        olMKqLZCZ/qPmF3BhC2e3INIKjdRw4pjcliea3PBQcLqb/ngsbBeOCZpjMw0lt71gfa1O5bBOqmno
        3ShY7hKqwlP6eectcckZfihY4oq9wQkgO3qMsIQFJHOZR+61Na7mttO7dx8pLcB6daVUp9MURpC+O
        B0Q4gFdUgqf+AT7vYKZ1J3lPrIhrtE0+ctxV6UozBGZCjRrSu/uiJGLNsUxWjmMWLyTomfdTN2rkC
        iFv7YnlQ==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jajC6-0001wn-7K
        for linux-xfs@vger.kernel.org; Mon, 18 May 2020 17:04:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/6] xfs: merge xfs_inode_free_quota_{eof,cow}blocks
Date:   Mon, 18 May 2020 19:04:35 +0200
Message-Id: <20200518170437.1218883-5-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518170437.1218883-1-hch@lst.de>
References: <20200518170437.1218883-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These two are always called together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c   |  5 +----
 fs/xfs/xfs_icache.c | 28 +++++++---------------------
 fs/xfs/xfs_icache.h |  3 +--
 3 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4b8bdecc38635..a1a62647f3935 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -650,10 +650,7 @@ xfs_file_buffered_aio_write(
 	 */
 	if (ret == -EDQUOT && !enospc) {
 		xfs_iunlock(ip, iolock);
-		enospc = xfs_inode_free_quota_eofblocks(ip);
-		if (enospc)
-			goto write_retry;
-		enospc = xfs_inode_free_quota_cowblocks(ip);
+		enospc = xfs_inode_free_quota_blocks(ip);
 		if (enospc)
 			goto write_retry;
 		iolock = 0;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index b638d12fb56a2..aa664be49fd50 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1523,11 +1523,9 @@ xfs_icache_free_eofblocks(
  * failure. We make a best effort by including each quota under low free space
  * conditions (less than 1% free space) in the scan.
  */
-static int
-__xfs_inode_free_quota_eofblocks(
-	struct xfs_inode	*ip,
-	int			(*execute)(struct xfs_mount *mp,
-					   struct xfs_eofblocks	*eofb))
+int
+xfs_inode_free_quota_blocks(
+	struct xfs_inode	*ip)
 {
 	int scan = 0;
 	struct xfs_eofblocks eofb = {0};
@@ -1557,19 +1555,14 @@ __xfs_inode_free_quota_eofblocks(
 		}
 	}
 
-	if (scan)
-		execute(ip->i_mount, &eofb);
+	if (scan) {
+		xfs_icache_free_eofblocks(ip->i_mount, &eofb);
+		xfs_icache_free_cowblocks(ip->i_mount, &eofb);
+	}
 
 	return scan;
 }
 
-int
-xfs_inode_free_quota_eofblocks(
-	struct xfs_inode *ip)
-{
-	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_eofblocks);
-}
-
 static inline unsigned long
 xfs_iflag_for_tag(
 	int		tag)
@@ -1784,13 +1777,6 @@ xfs_icache_free_cowblocks(
 					 eofb, XFS_ICI_COWBLOCKS_TAG);
 }
 
-int
-xfs_inode_free_quota_cowblocks(
-	struct xfs_inode *ip)
-{
-	return __xfs_inode_free_quota_eofblocks(ip, xfs_icache_free_cowblocks);
-}
-
 void
 xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 11fd6d877e112..3e4a8b3913f51 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -60,14 +60,13 @@ void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
-int xfs_inode_free_quota_eofblocks(struct xfs_inode *ip);
+int xfs_inode_free_quota_blocks(struct xfs_inode *ip);
 void xfs_eofblocks_worker(struct work_struct *);
 void xfs_queue_eofblocks(struct xfs_mount *);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 int xfs_icache_free_cowblocks(struct xfs_mount *, struct xfs_eofblocks *);
-int xfs_inode_free_quota_cowblocks(struct xfs_inode *ip);
 void xfs_cowblocks_worker(struct work_struct *);
 void xfs_queue_cowblocks(struct xfs_mount *);
 
-- 
2.26.2

