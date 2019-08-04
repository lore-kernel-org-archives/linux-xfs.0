Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42541 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbfHDWtr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 18:49:47 -0400
From: john.hubbard@gmail.com
Subject: [PATCH v2 17/34] vfio: convert put_page() to put_user_page*()
Date: Sun,  4 Aug 2019 15:48:58 -0700
Message-Id: <20190804224915.28669-18-jhubbard@nvidia.com>
In-Reply-To: <20190804224915.28669-1-jhubbard@nvidia.com>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Note that this effectively changes the code's behavior in
qp_release_pages(): it now ultimately calls set_page_dirty_lock(),
instead of set_page_dirty(). This is probably more accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 054391f30fa8..5a5461a14299 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -320,9 +320,9 @@ static int put_pfn(unsigned long pfn, int prot)
 {
 	if (!is_invalid_reserved_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
-		if (prot & IOMMU_WRITE)
-			SetPageDirty(page);
-		put_page(page);
+		bool dirty = prot & IOMMU_WRITE;
+
+		put_user_pages_dirty_lock(&page, 1, dirty);
 		return 1;
 	}
 	return 0;
@@ -356,7 +356,7 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 		 */
 		if (ret > 0 && vma_is_fsdax(vmas[0])) {
 			ret = -EOPNOTSUPP;
-			put_page(page[0]);
+			put_user_page(page[0]);
 		}
 	}
 	up_read(&mm->mmap_sem);
-- 
2.22.0
