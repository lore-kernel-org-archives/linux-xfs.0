Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:51771 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753930AbcLKXTu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 11 Dec 2016 18:19:50 -0500
Date: Mon, 12 Dec 2016 10:19:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the vfs tree with the xfs tree
Message-ID: <20161212101945.31f29cb1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in:

  fs/xfs/xfs_reflink.c

between commit:

  fba3e594ef0a ("xfs: always succeed when deduping zero bytes")

from the xfs tree and commit:

  876bec6f9bbf ("vfs: refactor clone/dedupe_file_range common functions")

from the vfs tree.

I fixed it up (the latter removed some code updated by the former and
see below) and can carry the fix as necessary. This is now fixed as far
as linux-next is concerned, but any non trivial conflicts should be
mentioned to your upstream maintainer when your tree is submitted for
merging.  You may also want to consider cooperating with the maintainer
of the conflicting tree to minimise any particularly complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc fs/xfs/xfs_reflink.c
index 88fd03c66e99,95d6828967f0..000000000000
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@@ -1251,32 -1194,16 +1143,14 @@@ xfs_reflink_remap_range
  		return -EIO;
  
  	/* Lock both files against IO */
 -	if (same_inode) {
 -		xfs_ilock(src, XFS_IOLOCK_EXCL);
 +	lock_two_nondirectories(inode_in, inode_out);
 +	if (same_inode)
  		xfs_ilock(src, XFS_MMAPLOCK_EXCL);
 -	} else {
 -		xfs_lock_two_inodes(src, dest, XFS_IOLOCK_EXCL);
 +	else
  		xfs_lock_two_inodes(src, dest, XFS_MMAPLOCK_EXCL);
 -	}
  
- 	/* Don't touch certain kinds of inodes */
- 	ret = -EPERM;
- 	if (IS_IMMUTABLE(inode_out))
- 		goto out_unlock;
- 
- 	ret = -ETXTBSY;
- 	if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
- 		goto out_unlock;
- 
- 
- 	/* Don't reflink dirs, pipes, sockets... */
- 	ret = -EISDIR;
- 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
- 		goto out_unlock;
+ 	/* Check file eligibility and prepare for block sharing. */
  	ret = -EINVAL;
- 	if (S_ISFIFO(inode_in->i_mode) || S_ISFIFO(inode_out->i_mode))
- 		goto out_unlock;
- 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
- 		goto out_unlock;
- 
  	/* Don't reflink realtime inodes */
  	if (XFS_IS_REALTIME_INODE(src) || XFS_IS_REALTIME_INODE(dest))
  		goto out_unlock;
