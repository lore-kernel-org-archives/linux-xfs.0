Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36714 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729712AbfHGBe3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 21:34:29 -0400
From: john.hubbard@gmail.com
Subject: [PATCH v3 27/41] mm/frame_vector.c: convert put_page() to put_user_page*()
Date: Tue,  6 Aug 2019 18:33:26 -0700
Message-Id: <20190807013340.9706-28-jhubbard@nvidia.com>
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/frame_vector.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index c64dca6e27c2..f590badac776 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -120,7 +120,6 @@ EXPORT_SYMBOL(get_vaddr_frames);
  */
 void put_vaddr_frames(struct frame_vector *vec)
 {
-	int i;
 	struct page **pages;
 
 	if (!vec->got_ref)
@@ -133,8 +132,7 @@ void put_vaddr_frames(struct frame_vector *vec)
 	 */
 	if (WARN_ON(IS_ERR(pages)))
 		goto out;
-	for (i = 0; i < vec->nr_frames; i++)
-		put_page(pages[i]);
+	put_user_pages(pages, vec->nr_frames);
 	vec->got_ref = false;
 out:
 	vec->nr_frames = 0;
-- 
2.22.0
