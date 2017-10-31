Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:10542 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932449AbdJaX2i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 19:28:38 -0400
Subject: [PATCH 07/15] dax: stop requiring a live device for dax_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 31 Oct 2017 16:22:13 -0700
Message-ID: <150949213329.24061.13836721890938350458.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de

Now that dax_flush() is no longer a driver callback (commit c3ca015fab6d
"dax: remove the pmem_dax_ops->flush abstraction"), stop requiring the
dax_read_lock() to be held and the device to be alive.  This is in
preparation for switching filesystem-dax to store pfns instead of
sectors in the radix.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 66bcdf42c413..abfd4e92d669 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -283,9 +283,6 @@ EXPORT_SYMBOL_GPL(dax_copy_from_iter);
 void arch_wb_cache_pmem(void *addr, size_t size);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
 {
-	if (unlikely(!dax_alive(dax_dev)))
-		return;
-
 	if (unlikely(!test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags)))
 		return;
 

