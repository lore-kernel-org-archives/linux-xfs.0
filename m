Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:33775 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdBJG6b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Feb 2017 01:58:31 -0500
Date: Fri, 10 Feb 2017 17:57:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the akpm-current tree with the xfs tree
Message-ID: <20170210175743.2a872558@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Jiang <dave.jiang@intel.com>

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in:

  include/linux/dax.h

between commit:

  8ff6daa17b6a ("omap: constify struct iomap_ops")

from the xfs tree and commits:

  d6fb008f420c ("mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf")
  db09ccff3e4e ("mm: replace FAULT_FLAG_SIZE with parameter to huge_fault")

from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc include/linux/dax.h
index 2983e52efd07,df63730e86d2..000000000000
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@@ -37,9 -37,9 +37,9 @@@ static inline void *dax_radix_locked_en
  }
  
  ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 -		struct iomap_ops *ops);
 +		const struct iomap_ops *ops);
- int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
- 			const struct iomap_ops *ops);
+ int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 -		struct iomap_ops *ops);
++		const struct iomap_ops *ops);
  int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
  int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index);
  int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
