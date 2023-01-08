Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DBFC54EBD
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Jan 2023 19:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbjAHTnH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Jan 2023 14:43:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbjAHTnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 14:43:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242B6DF0F
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 11:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673206863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L5KMkMa80rm5HNuuSM+y6bmm81BxzRO2A8GEgrR4WVI=;
        b=cuLHjkmRznkUyneLE5HIXTJnTsmwdjO/IGEqM/OWSjShHkiB4+kLw72gRa2oza7q0Z9Vih
        DHKsEsIEycAyQdE8yekJMKIh30vszWWPHFWfB10VWg4zMTQ5qc9Sb3Hke5lh9nqEytSond
        9ndmFeh6kizYJDOuC1Ena4RRXG4BnxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-uXliOmo7OXSdWbLqDzjl8A-1; Sun, 08 Jan 2023 14:40:58 -0500
X-MC-Unique: uXliOmo7OXSdWbLqDzjl8A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 420FC1875041;
        Sun,  8 Jan 2023 19:40:58 +0000 (UTC)
Received: from pasta.redhat.com (ovpn-192-3.brq.redhat.com [10.40.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E49DA492B06;
        Sun,  8 Jan 2023 19:40:55 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com,
        Christoph Hellwig <hch@lst.de>
Subject: [RFC v6 07/10] iomap: Rename page_prepare handler to get_folio
Date:   Sun,  8 Jan 2023 20:40:31 +0100
Message-Id: <20230108194034.1444764-8-agruenba@redhat.com>
In-Reply-To: <20230108194034.1444764-1-agruenba@redhat.com>
References: <20230108194034.1444764-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The ->page_prepare() handler in struct iomap_page_ops is now somewhat
misnamed, so rename it to ->get_folio().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/gfs2/bmap.c         | 6 +++---
 fs/iomap/buffered-io.c | 4 ++--
 include/linux/iomap.h  | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 41349e09558b..d3adb715ac8c 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -957,7 +957,7 @@ static int __gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 }
 
 static struct folio *
-gfs2_iomap_page_prepare(struct iomap_iter *iter, loff_t pos, unsigned len)
+gfs2_iomap_get_folio(struct iomap_iter *iter, loff_t pos, unsigned len)
 {
 	struct inode *inode = iter->inode;
 	unsigned int blockmask = i_blocksize(inode) - 1;
@@ -998,7 +998,7 @@ static void gfs2_iomap_put_folio(struct inode *inode, loff_t pos,
 }
 
 static const struct iomap_page_ops gfs2_iomap_page_ops = {
-	.page_prepare = gfs2_iomap_page_prepare,
+	.get_folio = gfs2_iomap_get_folio,
 	.put_folio = gfs2_iomap_put_folio,
 };
 
@@ -1291,7 +1291,7 @@ int gfs2_alloc_extent(struct inode *inode, u64 lblock, u64 *dblock,
 /*
  * NOTE: Never call gfs2_block_zero_range with an open transaction because it
  * uses iomap write to perform its actions, which begin their own transactions
- * (iomap_begin, page_prepare, etc.)
+ * (iomap_begin, get_folio, etc.)
  */
 static int gfs2_block_zero_range(struct inode *inode, loff_t from,
 				 unsigned int length)
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 666107c3a385..006ddf933948 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -607,8 +607,8 @@ static struct folio *__iomap_get_folio(struct iomap_iter *iter, loff_t pos,
 {
 	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
 
-	if (page_ops && page_ops->page_prepare)
-		return page_ops->page_prepare(iter, pos, len);
+	if (page_ops && page_ops->get_folio)
+		return page_ops->get_folio(iter, pos, len);
 	else
 		return iomap_get_folio(iter, pos);
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index d50501781856..da226032aedc 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -126,17 +126,17 @@ static inline bool iomap_inline_data_valid(const struct iomap *iomap)
 }
 
 /*
- * When a filesystem sets page_ops in an iomap mapping it returns, page_prepare
+ * When a filesystem sets page_ops in an iomap mapping it returns, get_folio
  * and put_folio will be called for each folio written to.  This only applies
  * to buffered writes as unbuffered writes will not typically have folios
  * associated with them.
  *
- * When page_prepare succeeds, put_folio will always be called to do any
+ * When get_folio succeeds, put_folio will always be called to do any
  * cleanup work necessary.  put_folio is responsible for unlocking and putting
  * @folio.
  */
 struct iomap_page_ops {
-	struct folio *(*page_prepare)(struct iomap_iter *iter, loff_t pos,
+	struct folio *(*get_folio)(struct iomap_iter *iter, loff_t pos,
 			unsigned len);
 	void (*put_folio)(struct inode *inode, loff_t pos, unsigned copied,
 			struct folio *folio);
-- 
2.38.1

