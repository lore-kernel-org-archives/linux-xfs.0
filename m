Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42534 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbfHDWth (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Aug 2019 18:49:37 -0400
From: john.hubbard@gmail.com
Subject: [PATCH v2 11/34] scif: convert put_page() to put_user_page*()
Date: Sun,  4 Aug 2019 15:48:52 -0700
Message-Id: <20190804224915.28669-12-jhubbard@nvidia.com>
In-Reply-To: <20190804224915.28669-1-jhubbard@nvidia.com>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, LKML <linux-kernel@vger.kernel.org>, amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org, devel@lists.orangefs.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, netdev@vger.kernel.org, rds-devel@oss.oracle.com, sparclinux@vger.kernel.org, x86@kernel.org, xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>, Sudeep Dutt <sudeep.dutt@intel.com>, Ashutosh Dixit <ashutosh.dixit@intel.com>, Arnd Bergmann <arnd@arndb.de>, Joerg Roedel <jroedel@suse.de>, Robin Murphy <robin.murphy@arm.com>, Zhen Lei <thunder.leizhen@huawei.com>

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Cc: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/misc/mic/scif/scif_rma.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/misc/mic/scif/scif_rma.c b/drivers/misc/mic/scif/scif_rma.c
index 01e27682ea30..d84ed9466920 100644
--- a/drivers/misc/mic/scif/scif_rma.c
+++ b/drivers/misc/mic/scif/scif_rma.c
@@ -113,13 +113,14 @@ static int scif_destroy_pinned_pages(struct scif_pinned_pages *pin)
 	int writeable = pin->prot & SCIF_PROT_WRITE;
 	int kernel = SCIF_MAP_KERNEL & pin->map_flags;
 
-	for (j = 0; j < pin->nr_pages; j++) {
-		if (pin->pages[j] && !kernel) {
+	if (kernel) {
+		for (j = 0; j < pin->nr_pages; j++) {
 			if (writeable)
-				SetPageDirty(pin->pages[j]);
+				set_page_dirty_lock(pin->pages[j]);
 			put_page(pin->pages[j]);
 		}
-	}
+	} else
+		put_user_pages_dirty_lock(pin->pages, pin->nr_pages, writeable);
 
 	scif_free(pin->pages,
 		  pin->nr_pages * sizeof(*pin->pages));
@@ -1385,11 +1386,9 @@ int __scif_pin_pages(void *addr, size_t len, int *out_prot,
 				if (ulimit)
 					__scif_dec_pinned_vm_lock(mm, nr_pages);
 				/* Roll back any pinned pages */
-				for (i = 0; i < pinned_pages->nr_pages; i++) {
-					if (pinned_pages->pages[i])
-						put_page(
-						pinned_pages->pages[i]);
-				}
+				put_user_pages(pinned_pages->pages,
+					       pinned_pages->nr_pages);
+
 				prot &= ~SCIF_PROT_WRITE;
 				try_upgrade = false;
 				goto retry;
-- 
2.22.0
