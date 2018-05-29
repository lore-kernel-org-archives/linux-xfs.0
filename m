Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:7359 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966529AbeE2TvR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 15:51:17 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 7/7] dm-error: remove unnecessary direct_access() stub
Date: Tue, 29 May 2018 13:51:06 -0600
Message-Id: <20180529195106.14268-8-ross.zwisler@linux.intel.com>
In-Reply-To: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

This stub was added so that we could use dm-error with
DM_TYPE_DAX_BIO_BASED mode devices.  That mode and the transition issues
associated with it no longer exist, so we can remove this dead code.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-target.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 314d17ca6466..c4dbc15f7862 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -140,12 +140,6 @@ static void io_err_release_clone_rq(struct request *clone)
 {
 }
 
-static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
-		long nr_pages, void **kaddr, pfn_t *pfn)
-{
-	return -EIO;
-}
-
 static struct target_type error_target = {
 	.name = "error",
 	.version = {1, 5, 0},
@@ -155,7 +149,6 @@ static struct target_type error_target = {
 	.map  = io_err_map,
 	.clone_and_map_rq = io_err_clone_and_map_rq,
 	.release_clone_rq = io_err_release_clone_rq,
-	.direct_access = io_err_dax_direct_access,
 };
 
 int __init dm_target_init(void)
-- 
2.14.3

