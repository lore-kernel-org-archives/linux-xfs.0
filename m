Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1498 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754320AbcKATyh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Nov 2016 15:54:37 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v9 16/16] dax: remove "depends on BROKEN" from FS_DAX_PMD
Date: Tue,  1 Nov 2016 13:54:18 -0600
Message-Id: <1478030058-1422-17-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1478030058-1422-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1478030058-1422-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Now that DAX PMD faults are once again working and are now participating in
DAX's radix tree locking scheme, allow their config option to be enabled.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 4bd03a2..8e9e5f41 100644
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

