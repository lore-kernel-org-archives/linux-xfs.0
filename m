Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.13-rc1-2-13369-gef70160
Message-Id: <20131205231049.0BA9E7F55@oss.sgi.com>
Date: Thu,  5 Dec 2013 17:10:48 -0600 (CST)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, for-next has been updated
  ef70160 xfs: fix memory leak in xfs_dir2_node_removename
  2a84108 xfs: free the list of recovery items on error
  b7d961b xfs: growfs overruns AGFL buffer on V4 filesystems
      from  f9fd0135610084abef6867d984e9951c3099950d (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit ef701600fd26cace9d513ee174688a2b83832126
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Sat Oct 5 21:48:25 2013 -0500

    xfs: fix memory leak in xfs_dir2_node_removename
    
    Fix the leak of kernel memory in xfs_dir2_node_removename()
    when xfs_dir2_leafn_remove() returns an error code.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 2a84108fe275f95fbe838b1c92b7c45258dcae5c
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Wed Oct 2 07:51:12 2013 -0500

    xfs: free the list of recovery items on error
    
    Recovery builds a list of items on the transaction's
    r_itemq head. Normally these items are committed and freed.
    But in the event of a recovery error, these allocations
    are leaked.
    
    If the error occurs during item reordering, then reconstruct
    the r_itemq list before deleting the list to avoid leaking
    the entries that were on one of the temporary lists.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b7d961b35b3ab69609aeea93f870269cb6e7ba4d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Nov 21 15:41:06 2013 +1100

    xfs: growfs overruns AGFL buffer on V4 filesystems
    
    This loop in xfs_growfs_data_private() is incorrect for V4
    superblocks filesystems:
    
    		for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
    			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
    
    For V4 filesystems, we don't have a agfl header structure, and so
    XFS_AGFL_SIZE() returns an entire sector's worth of entries, which
    we then index from an offset into the sector. Hence: buffer overrun.
    
    This problem was introduced in 3.10 by commit 77c95bba ("xfs: add
    CRC checks to the AGFL") which changed the AGFL structure but failed
    to update the growfs code to handle the different structures.
    
    Fix it by using the correct offset into the buffer for both V4 and
    V5 filesystems.
    
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_dir2_node.c   | 26 +++++++++++++-------------
 fs/xfs/xfs_fsops.c       |  6 +++++-
 fs/xfs/xfs_log_recover.c | 17 ++++++++++++++---
 3 files changed, 32 insertions(+), 17 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
