Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33017 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751708AbdJTCpt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 22:45:49 -0400
Subject: [PATCH v3 05/13] dax: stop requiring a live device for dax_flush()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 19:39:24 -0700
Message-ID: <150846716412.24336.5216410632309453014.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, hch@lst.de

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
index 26c324a5aef4..be65430b4483 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -280,9 +280,6 @@ EXPORT_SYMBOL_GPL(dax_copy_from_iter);
 void arch_wb_cache_pmem(void *addr, size_t size);
 void dax_flush(struct dax_device *dax_dev, void *addr, size_t size)
 {
-	if (unlikely(!dax_alive(dax_dev)))
-		return;
-
 	if (unlikely(!test_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags)))
 		return;
 

