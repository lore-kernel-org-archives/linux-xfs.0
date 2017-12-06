Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753347AbdLFAmN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Dec 2017 19:42:13 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 28/73] page cache: Remove stray radix comment
Date: Tue,  5 Dec 2017 16:41:14 -0800
Message-Id: <20171206004159.3755-29-willy@infradead.org>
In-Reply-To: <20171206004159.3755-1-willy@infradead.org>
References: <20171206004159.3755-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 9e6158cfbaeb..79d0731b8762 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2601,7 +2601,7 @@ static struct page *do_read_cache_page(struct address_space *mapping,
 			put_page(page);
 			if (err == -EEXIST)
 				goto repeat;
-			/* Presumably ENOMEM for radix tree node */
+			/* Presumably ENOMEM for xarray node */
 			return ERR_PTR(err);
 		}
 
-- 
2.15.0

