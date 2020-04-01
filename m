Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395FBC2D0F3
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 15:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E68A20B1F
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 15:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EQ8tkaKN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732504AbgDAPZ2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 11:25:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33778 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732742AbgDAPZ2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Apr 2020 11:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HPLjHLQGO8HhdcJF5uQET4ryRs12dglYKf2jvAP7O+w=; b=EQ8tkaKNIpNhPV0XAh5LBd+jZr
        aJsmvoYzse+6QzBHabveVGmnemDd9Bw1ZyBO31AvYQABdz/s/OL6TnOAY4qG92C3a9l3VJRqDdbvI
        7Ee/et9pfdTKZL3OwQ8eEYIv7sIFIaDi5Kp378f0EoHNbj9LutBV7GLi99iM1UG/faJ7Ld2KkAc/D
        RhTeHwaWaMz7apDvCC434wDIuP3NhO9wcwYpXdfgmWXbsETrDxU8L/UWOgRU3reOwvn0tihCi3gAW
        lA2iyblTMslzOoi9iTmf+361v2hCn7xWyya7gejBclwTWXIyjMwQJ5XdBgQi7Uj2nj1fk5w45aeT/
        O5yAZNVQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jJfF9-0005Pk-Vz; Wed, 01 Apr 2020 15:25:27 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     hch@infradead.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] iomap: Convert page_mkwrite to iter API
Date:   Wed,  1 Apr 2020 08:25:22 -0700
Message-Id: <20200401152522.20737-3-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200401152522.20737-1-willy@infradead.org>
References: <20200401152522.20737-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c | 51 ++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 7c84c4c027c4..d91d1d5a0f84 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1051,50 +1051,37 @@ iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 }
 EXPORT_SYMBOL_GPL(iomap_truncate_page);
 
-static loff_t
-iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap, struct iomap *srcmap)
-{
-	struct page *page = data;
-	int ret;
-
-	if (iomap->flags & IOMAP_F_BUFFER_HEAD) {
-		ret = __block_write_begin_int(page, pos, length, NULL, iomap);
-		if (ret)
-			return ret;
-		block_commit_write(page, 0, length);
-	} else {
-		WARN_ON_ONCE(!PageUptodate(page));
-		iomap_page_create(inode, page);
-		set_page_dirty(page);
-	}
-
-	return length;
-}
-
 vm_fault_t iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
 {
 	struct page *page = vmf->page;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
-	unsigned long length;
-	loff_t offset;
-	ssize_t ret;
+	DEFINE_IOMAP_ITER(iter, inode, page_offset(page), 0,
+			IOMAP_WRITE | IOMAP_FAULT, ops);
+	loff_t ret, len = IOMAP_FIRST_CALL;
 
 	lock_page(page);
 	ret = page_mkwrite_check_truncate(page, inode);
 	if (ret < 0)
 		goto out_unlock;
-	length = ret;
+	iter.len = ret;
 
-	offset = page_offset(page);
-	while (length > 0) {
-		ret = iomap_apply(inode, offset, length,
-				IOMAP_WRITE | IOMAP_FAULT, ops, page,
-				iomap_page_mkwrite_actor);
+	for (;;) {
+		ret = iomap_iter(&iter, len);
 		if (unlikely(ret <= 0))
 			goto out_unlock;
-		offset += ret;
-		length -= ret;
+		len = ret;
+
+		if (iter.iomap.flags & IOMAP_F_BUFFER_HEAD) {
+			ret = __block_write_begin_int(page, iter.pos, len,
+					NULL, &iter.iomap);
+			if (ret)
+				goto out_unlock;
+			block_commit_write(page, 0, len);
+		} else {
+			WARN_ON_ONCE(!PageUptodate(page));
+			iomap_page_create(inode, page);
+			set_page_dirty(page);
+		}
 	}
 
 	wait_for_stable_page(page);
-- 
2.25.1

