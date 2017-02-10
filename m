Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:57247 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751026AbdBJGp1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Feb 2017 01:45:27 -0500
Date: Fri, 10 Feb 2017 17:45:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the akpm-current tree with the xfs tree
Message-ID: <20170210174505.03a1aacc@canb.auug.org.au>
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

  fs/iomap.c

between commit:

  8ff6daa17b6a ("iomap: constify struct iomap_ops")

from the xfs tree and commit:

  d6fb008f420c ("mm, fs: reduce fault, page_mkwrite, and pfn_mkwrite to take only vmf")

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

diff --cc fs/iomap.c
index d89f70bbb952,ccba165bed49..000000000000
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@@ -445,11 -445,10 +445,10 @@@ iomap_page_mkwrite_actor(struct inode *
  	return length;
  }
  
- int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
- 		const struct iomap_ops *ops)
 -int iomap_page_mkwrite(struct vm_fault *vmf, struct iomap_ops *ops)
++int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops)
  {
  	struct page *page = vmf->page;
- 	struct inode *inode = file_inode(vma->vm_file);
+ 	struct inode *inode = file_inode(vmf->vma->vm_file);
  	unsigned long length;
  	loff_t offset, size;
  	ssize_t ret;
