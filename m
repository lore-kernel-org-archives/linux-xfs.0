Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:58506 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757249AbcJGVJ2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Oct 2016 17:09:28 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v5 17/17] dax: remove "depends on BROKEN" from FS_DAX_PMD
Date: Fri,  7 Oct 2016 15:09:04 -0600
Message-Id: <1475874544-24842-18-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Now that DAX PMD faults are once again working and are now participating in
DAX's radix tree locking scheme, allow their config option to be enabled.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 2bc7ad7..b6f0fce 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -55,7 +55,6 @@ config FS_DAX_PMD
 	depends on FS_DAX
 	depends on ZONE_DEVICE
 	depends on TRANSPARENT_HUGEPAGE
-	depends on BROKEN
 
 endif # BLOCK
 
-- 
2.7.4

