Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34025 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbdJSNIn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 09:08:43 -0400
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 09/17] dax: Fix comment describing dax_iomap_fault()
Date: Thu, 19 Oct 2017 14:58:08 +0200
Message-Id: <20171019125817.11580-10-jack@suse.cz>
In-Reply-To: <20171019125817.11580-1-jack@suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, Jan Kara <jack@suse.cz>

Add missing argument description.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 675fab8ec41f..5214ed9ba508 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1435,7 +1435,8 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 /**
  * dax_iomap_fault - handle a page fault on a DAX file
  * @vmf: The description of the fault
- * @ops: iomap ops passed from the file system
+ * @pe_size: Size of the page to fault in
+ * @ops: Iomap ops passed from the file system
  *
  * When a page fault occurs, filesystems may call this helper in
  * their fault handler for DAX files. dax_iomap_fault() assumes the caller
-- 
2.12.3

