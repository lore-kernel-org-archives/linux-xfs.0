Return-Path: <SRS0=ByWF=4N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 251B8C4BA02
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA49321927
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Feb 2020 21:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A+ugosl7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgBYVsm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Feb 2020 16:48:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43526 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729056AbgBYVsm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 16:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0gMh1yamRVaNETPSTUEglHum9p/xixoA+LVU7RwCI34=; b=A+ugosl7XCuWZ0DZM060VhasbF
        LlgbO5ELIQJ449viGm0I1EI7L0UglVYvyBriRpH8pBN+Rmj714EtqvFrMaosZr24PrysRfLaHRbus
        QPSl3wzAaCuxS8hDzpCGhTD8X6bOOyCQ1vFuSYSN48wlEYAR2dKQnRt3n1ww8iX1t3NhnDsNxW/D+
        8NQfScKs2JhrTJV3TmYoXBX9y+9NBU0TzMuU3vu3FcLiH3QoiWjmtt4tk2jxf2c4WgVjtlmOna6E+
        uGFSvdXtlaqgrmld7J0hqWFeqCKw0sMvK4sLrLFjwM5dcgtCPADXi0SCBPNZo+JeJ6/L85qK3eqe+
        YVIWitkw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6i4H-0007rL-OM; Tue, 25 Feb 2020 21:48:41 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH v8 23/25] f2fs: Pass the inode to f2fs_mpage_readpages
Date:   Tue, 25 Feb 2020 13:48:36 -0800
Message-Id: <20200225214838.30017-24-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200225214838.30017-1-willy@infradead.org>
References: <20200225214838.30017-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

This function now only uses the mapping argument to look up the inode,
and both callers already have the inode, so just pass the inode instead
of the mapping.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/f2fs/data.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 237dff36fe73..c8b042979fc4 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2159,12 +2159,11 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
  * use ->readpage() or do the necessary surgery to decouple ->readpages()
  * from read-ahead.
  */
-static int f2fs_mpage_readpages(struct address_space *mapping,
+static int f2fs_mpage_readpages(struct inode *inode,
 		struct readahead_control *rac, struct page *page)
 {
 	struct bio *bio = NULL;
 	sector_t last_block_in_bio = 0;
-	struct inode *inode = mapping->host;
 	struct f2fs_map_blocks map;
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 	struct compress_ctx cc = {
@@ -2276,7 +2275,7 @@ static int f2fs_read_data_page(struct file *file, struct page *page)
 	if (f2fs_has_inline_data(inode))
 		ret = f2fs_read_inline_data(inode, page);
 	if (ret == -EAGAIN)
-		ret = f2fs_mpage_readpages(page_file_mapping(page), NULL, page);
+		ret = f2fs_mpage_readpages(inode, NULL, page);
 	return ret;
 }
 
@@ -2293,7 +2292,7 @@ static void f2fs_readahead(struct readahead_control *rac)
 	if (f2fs_has_inline_data(inode))
 		return;
 
-	f2fs_mpage_readpages(rac->mapping, rac, NULL);
+	f2fs_mpage_readpages(inode, rac, NULL);
 }
 
 int f2fs_encrypt_one_page(struct f2fs_io_info *fio)
-- 
2.25.0

