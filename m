Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:23658 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730266AbfHIW7G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Aug 2019 18:59:06 -0400
From: ira.weiny@intel.com
Subject: [RFC PATCH v2 16/19] RDMA/uverbs: Add back pointer to system file object
Date: Fri,  9 Aug 2019 15:58:30 -0700
Message-Id: <20190809225833.6657-17-ira.weiny@intel.com>
In-Reply-To: <20190809225833.6657-1-ira.weiny@intel.com>
References: <20190809225833.6657-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-ext4@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>

From: Ira Weiny <ira.weiny@intel.com>

In order for MRs to be tracked against the open verbs context the ufile
needs to have a pointer to hand to the GUP code.

No references need to be taken as this should be valid for the lifetime
of the context.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/infiniband/core/uverbs.h      | 1 +
 drivers/infiniband/core/uverbs_main.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 1e5aeb39f774..e802ba8c67d6 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -163,6 +163,7 @@ struct ib_uverbs_file {
 	struct page *disassociate_page;
 
 	struct xarray		idr;
+	struct file             *sys_file; /* backpointer to system file object */
 };
 
 struct ib_uverbs_event {
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 11c13c1381cf..002c24e0d4db 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -1092,6 +1092,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	INIT_LIST_HEAD(&file->umaps);
 
 	filp->private_data = file;
+	file->sys_file = filp;
 	list_add_tail(&file->list, &dev->uverbs_file_list);
 	mutex_unlock(&dev->lists_mutex);
 	srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
-- 
2.20.1
