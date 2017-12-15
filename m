Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38411 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756506AbdLOWFU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Dec 2017 17:05:20 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v5 30/78] page cache: Remove stray radix comment
Date: Fri, 15 Dec 2017 14:04:02 -0800
Message-Id: <20171215220450.7899-31-willy@infradead.org>
In-Reply-To: <20171215220450.7899-1-willy@infradead.org>
References: <20171215220450.7899-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Howells <dhowells@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, Rehas Sachdeva <aquannie@gmail.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, linux-raid@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 92ddee25f19b..75d1b32080a4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2603,7 +2603,7 @@ static struct page *do_read_cache_page(struct address_space *mapping,
 			put_page(page);
 			if (err == -EEXIST)
 				goto repeat;
-			/* Presumably ENOMEM for radix tree node */
+			/* Presumably ENOMEM for xarray node */
 			return ERR_PTR(err);
 		}
 
-- 
2.15.1

