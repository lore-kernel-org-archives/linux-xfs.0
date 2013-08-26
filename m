Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. for-linus-v3.11-rc1-2-12213-g0d0ab12
Message-Id: <20130826164021.0DD937F3F@oss.sgi.com>
Date: Mon, 26 Aug 2013 11:40:20 -0500 (CDT)
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

The branch, master has been updated
  0d0ab12 xfs: check for underflow in xfs_iformat_fork()
  98f7462 xfs: xfs_dir3_sfe_put_ino can be static
      from  00574da199291751bfaaee15ad0f42a7144276ad (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 0d0ab120d1fe90fcc73a2bfff3945bea636b3025
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Thu Aug 15 08:53:38 2013 +0300

    xfs: check for underflow in xfs_iformat_fork()
    
    The "di_size" variable comes from the disk and it's a signed 64 bit.
    We check the upper limit but we should check for negative numbers as
    well.
    
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 98f7462c4331cbf283e7b5c2269d17c17b8f00f2
Author: Fengguang Wu <fengguang.wu@intel.com>
Date:   Sat Aug 24 08:50:17 2013 +0800

    xfs: xfs_dir3_sfe_put_ino can be static
    
    TO: Dave Chinner <david@fromorbit.com>
    CC: Ben Myers <bpm@sgi.com>
    CC: linux-kernel@vger.kernel.org
    
    Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_dir2_sf.c    | 2 +-
 fs/xfs/xfs_inode_fork.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
