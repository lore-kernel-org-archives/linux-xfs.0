Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6BDEC3DA7A
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 15:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiLaPKQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 31 Dec 2022 10:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbiLaPKO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 31 Dec 2022 10:10:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D632A18F
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 07:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672499371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Ygc7yO7wRnJEDhfkoYktIJkM0VZCJqLxpPKzS46mK4=;
        b=F1PzNwjuXMLnkcuV1IBCBPPQR7vPKGMtCugjKbhWScjeFJGIdByeur2d51IJ9IEp7DhaO5
        jLsyE+BUAWwBdovBx1hLlbFOcX4BhANS9TpIFFK0d8xxd/gpRw7vm3XuA97+wFnv8z8xA2
        1qWYLnH9tkO2aU9E/ZILCs3FogOBTgA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-4TMU-ONqNDiQUilpRPG4uQ-1; Sat, 31 Dec 2022 10:09:26 -0500
X-MC-Unique: 4TMU-ONqNDiQUilpRPG4uQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96E9A811E9C;
        Sat, 31 Dec 2022 15:09:25 +0000 (UTC)
Received: from pasta.redhat.com (ovpn-192-3.brq.redhat.com [10.40.192.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 552D7492B00;
        Sat, 31 Dec 2022 15:09:23 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, cluster-devel@redhat.com
Subject: [PATCH v5 1/9] iomap: Add iomap_put_folio helper
Date:   Sat, 31 Dec 2022 16:09:11 +0100
Message-Id: <20221231150919.659533-2-agruenba@redhat.com>
In-Reply-To: <20221231150919.659533-1-agruenba@redhat.com>
References: <20221231150919.659533-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add an iomap_put_folio() helper to encapsulate unlocking the folio,
calling ->page_done(), and putting the folio.  Use the new helper in
iomap_write_begin() and iomap_write_end().

This effectively doesn't change the way the code works, but prepares for
successive improvements.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 356193e44cf0..c30d150a9303 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -575,6 +575,19 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 	return 0;
 }
 
+static void iomap_put_folio(struct iomap_iter *iter, loff_t pos, size_t ret,
+		struct folio *folio)
+{
+	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
+
+	if (folio)
+		folio_unlock(folio);
+	if (page_ops && page_ops->page_done)
+		page_ops->page_done(iter->inode, pos, ret, &folio->page);
+	if (folio)
+		folio_put(folio);
+}
+
 static int iomap_write_begin_inline(const struct iomap_iter *iter,
 		struct folio *folio)
 {
@@ -616,7 +629,8 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 			fgp, mapping_gfp_mask(iter->inode->i_mapping));
 	if (!folio) {
 		status = (iter->flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOMEM;
-		goto out_no_page;
+		iomap_put_folio(iter, pos, 0, NULL);
+		return status;
 	}
 
 	/*
@@ -656,13 +670,9 @@ static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 	return 0;
 
 out_unlock:
-	folio_unlock(folio);
-	folio_put(folio);
+	iomap_put_folio(iter, pos, 0, folio);
 	iomap_write_failed(iter->inode, pos, len);
 
-out_no_page:
-	if (page_ops && page_ops->page_done)
-		page_ops->page_done(iter->inode, pos, 0, NULL);
 	return status;
 }
 
@@ -712,7 +722,6 @@ static size_t iomap_write_end_inline(const struct iomap_iter *iter,
 static size_t iomap_write_end(struct iomap_iter *iter, loff_t pos, size_t len,
 		size_t copied, struct folio *folio)
 {
-	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	loff_t old_size = iter->inode->i_size;
 	size_t ret;
@@ -735,14 +744,10 @@ static size_t iomap_write_end(struct iomap_iter *iter, loff_t pos, size_t len,
 		i_size_write(iter->inode, pos + ret);
 		iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 	}
-	folio_unlock(folio);
+	iomap_put_folio(iter, pos, ret, folio);
 
 	if (old_size < pos)
 		pagecache_isize_extended(iter->inode, old_size, pos);
-	if (page_ops && page_ops->page_done)
-		page_ops->page_done(iter->inode, pos, ret, &folio->page);
-	folio_put(folio);
-
 	if (ret < len)
 		iomap_write_failed(iter->inode, pos + ret, len - ret);
 	return ret;
-- 
2.38.1

