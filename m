Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:49660 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752092AbdJTCp1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 22:45:27 -0400
Subject: [PATCH v3 01/13] dax: quiet bdev_dax_supported()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 19 Oct 2017 19:39:02 -0700
Message-ID: <150846714231.24336.100401563090934098.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, hch@lst.de

Before we add another failure reason, quiet the existing log messages.
Leave it to the caller to decide if bdev_dax_supported() failures are
errors worth emitting to the log.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 557b93703532..b0cc8117eebe 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -92,21 +92,21 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	long len;
 
 	if (blocksize != PAGE_SIZE) {
-		pr_err("VFS (%s): error: unsupported blocksize for dax\n",
+		pr_debug("VFS (%s): error: unsupported blocksize for dax\n",
 				sb->s_id);
 		return -EINVAL;
 	}
 
 	err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
 	if (err) {
-		pr_err("VFS (%s): error: unaligned partition for dax\n",
+		pr_debug("VFS (%s): error: unaligned partition for dax\n",
 				sb->s_id);
 		return err;
 	}
 
 	dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
 	if (!dax_dev) {
-		pr_err("VFS (%s): error: device does not support dax\n",
+		pr_debug("VFS (%s): error: device does not support dax\n",
 				sb->s_id);
 		return -EOPNOTSUPP;
 	}
@@ -118,7 +118,7 @@ int __bdev_dax_supported(struct super_block *sb, int blocksize)
 	put_dax(dax_dev);
 
 	if (len < 1) {
-		pr_err("VFS (%s): error: dax access failed (%ld)",
+		pr_debug("VFS (%s): error: dax access failed (%ld)\n",
 				sb->s_id, len);
 		return len < 0 ? len : -EIO;
 	}

