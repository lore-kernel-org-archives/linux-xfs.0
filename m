Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:52507 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751705AbdLUWun (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 Dec 2017 17:50:43 -0500
Date: Fri, 22 Dec 2017 09:50:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the xfs tree with Linus' tree
Message-ID: <20171222095041.3fe014ec@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>

Hi all,

Today's linux-next merge of the xfs tree got a conflict in:

  fs/xfs/xfs_super.c

between commit:

  1751e8a6cb93 ("Rename superblock flags (MS_xyz -> SB_xyz)")

from Linus' tree and commit:

  10ddf64e420f ("xfs: remove leftover CoW reservations when remounting ro")

from the xfs tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc fs/xfs/xfs_super.c
index 5122d3021117,2db6a40a96bd..000000000000
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@@ -1368,7 -1369,15 +1369,15 @@@ xfs_fs_remount
  	}
  
  	/* rw -> ro */
 -	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
 +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & SB_RDONLY)) {
+ 		/* Get rid of any leftover CoW reservations... */
+ 		cancel_delayed_work_sync(&mp->m_cowblocks_work);
+ 		error = xfs_icache_free_cowblocks(mp, NULL);
+ 		if (error) {
+ 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+ 			return error;
+ 		}
+ 
  		/* Free the per-AG metadata reservation pool. */
  		error = xfs_fs_unreserve_ag_blocks(mp);
  		if (error) {
