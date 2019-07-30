Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39958 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbfG3U5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Jul 2019 16:57:13 -0400
From: john.hubbard@gmail.com
Subject: [PATCH v4 3/3] net/xdp: convert put_page() to put_user_page*()
Date: Tue, 30 Jul 2019 13:57:05 -0700
Message-Id: <20190730205705.9018-4-jhubbard@nvidia.com>
In-Reply-To: <20190730205705.9018-1-jhubbard@nvidia.com>
References: <20190730205705.9018-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Benvenuti <benve@cisco.com>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>, Jerome Glisse <jglisse@redhat.com>, "Kirill A . Shutemov" <kirill@shutemov.name>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Mike Rapoport <rppt@linux.ibm.com>, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>, Magnus Karlsson <magnus.karlsson@intel.com>, "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Cc: Björn Töpel <bjorn.topel@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/xdp/xdp_umem.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 83de74ca729a..17c4b3d3dc34 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -166,14 +166,7 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
 
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
-	unsigned int i;
-
-	for (i = 0; i < umem->npgs; i++) {
-		struct page *page = umem->pgs[i];
-
-		set_page_dirty_lock(page);
-		put_page(page);
-	}
+	put_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
 
 	kfree(umem->pgs);
 	umem->pgs = NULL;
-- 
2.22.0
