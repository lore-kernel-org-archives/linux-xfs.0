Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:34343 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdBJHOr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 10 Feb 2017 02:14:47 -0500
Date: Fri, 10 Feb 2017 18:07:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the akpm-current tree with the xfs tree
Message-ID: <20170210180733.670c80b1@canb.auug.org.au>
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

  include/linux/iomap.h

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

diff --cc include/linux/iomap.h
index 891459caa278,857e440af9d5..000000000000
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@@ -72,17 -72,16 +72,16 @@@ struct iomap_ops 
  };
  
  ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 -		struct iomap_ops *ops);
 +		const struct iomap_ops *ops);
  int iomap_file_dirty(struct inode *inode, loff_t pos, loff_t len,
 -		struct iomap_ops *ops);
 +		const struct iomap_ops *ops);
  int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
 -		bool *did_zero, struct iomap_ops *ops);
 +		bool *did_zero, const struct iomap_ops *ops);
  int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
 -		struct iomap_ops *ops);
 -int iomap_page_mkwrite(struct vm_fault *vmf, struct iomap_ops *ops);
 +		const struct iomap_ops *ops);
- int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
- 		const struct iomap_ops *ops);
++int iomap_page_mkwrite(struct vm_fault *vmf, const struct iomap_ops *ops);
  int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 -		loff_t start, loff_t len, struct iomap_ops *ops);
 +		loff_t start, loff_t len, const struct iomap_ops *ops);
  
  /*
   * Flags for direct I/O ->end_io:
