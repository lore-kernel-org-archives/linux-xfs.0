Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.10-rc1-61-g83e782e
Message-Id: <20130628225118.450DE7F9C@oss.sgi.com>
Date: Fri, 28 Jun 2013 17:51:18 -0500 (CDT)
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
  83e782e xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
  0e6436d xfs: Change xfs_dquot_acct to be a 2-dimensional array
  113a568 xfs: Code cleanup and removal of some typedef usage
  995961c xfs: Replace macro XFS_DQ_TO_QIP with a function
  329e087 xfs: Replace macro XFS_DQUOT_TREE with a function
  9cad19d xfs: Define a new function xfs_is_quota_inode()
  dc037ad xfs: implement inode change count
      from  ddf6ad01434e72bfc8423e1619abdaa0af9394a8 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 83e782e1a1cc0159888e58e14dfc8f3289663338
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Thu Jun 27 17:25:10 2013 -0500

    xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
    
    Remove all incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD. Instead,
    start using XFS_GQUOTA_.* XFS_PQUOTA_.* counterparts for GQUOTA and
    PQUOTA respectively.
    
    On-disk copy still uses XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD.
    
    Read and write of the superblock does the conversion from *OQUOTA*
    to *[PG]QUOTA*.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0e6436d99e730f9384f3c11d24a5efb788885fc6
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Thu Jun 27 17:25:09 2013 -0500

    xfs: Change xfs_dquot_acct to be a 2-dimensional array
    
    In preparation for combined pquota/gquota support, for the sake
    of readability, change xfs_dquot_acct to be a 2-dimensional array.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 113a56835d938d5cf9b4599053da7afb80d6f710
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Thu Jun 27 17:25:07 2013 -0500

    xfs: Code cleanup and removal of some typedef usage
    
    In preparation for combined pquota/gquota support, for the sake
    of readability, do some code cleanup surrounding the affected
    code.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 995961c4510460d9eef9b5ae46789aa2315545fe
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Thu Jun 27 17:25:06 2013 -0500

    xfs: Replace macro XFS_DQ_TO_QIP with a function
    
    In preparation for combined pquota/gquota support, for the sake
    of readability, change the macro to an inline function.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 329e0875286984df9053d410df83f839f85bea6e
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Thu Jun 27 17:25:05 2013 -0500

    xfs: Replace macro XFS_DQUOT_TREE with a function
    
    In preparation for combined pquota/gquota support, for the sake
    of readability, change the macro to an inline function.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 9cad19d2cb57a2c32887a303b516d74254aa4b1c
Author: Chandra Seetharaman <sekharan@us.ibm.com>
Date:   Thu Jun 27 17:25:04 2013 -0500

    xfs: Define a new function xfs_is_quota_inode()
    
    In preparation for combined pquota/gquota support, define
    a new function to check if the given inode is a quota inode.
    
    Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit dc037ad7d24f3711e431a45c053b5d425995e9e4
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Jun 27 16:04:59 2013 +1000

    xfs: implement inode change count
    
    For CRC enabled filesystems, add support for the monotonic inode
    version change counter that is needed by protocols like NFSv4 for
    determining if the inode has changed in any way at all between two
    unrelated operations on the inode.
    
    This bumps the change count the first time an inode is dirtied in a
    transaction. Since all modifications to the inode are logged, this
    will catch all changes that are made to the inode, including
    timestamp updates that occur during data writes.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_dquot.c       |  16 ++---
 fs/xfs/xfs_dquot.h       |   4 --
 fs/xfs/xfs_icache.c      |   3 +-
 fs/xfs/xfs_itable.c      |   2 +-
 fs/xfs/xfs_mount.c       |  51 ++++++++++++++
 fs/xfs/xfs_qm.c          | 175 +++++++++++++++++++++++++----------------------
 fs/xfs/xfs_qm.h          |  83 +++++++++++++++-------
 fs/xfs/xfs_qm_syscalls.c |  51 +++++++-------
 fs/xfs/xfs_quota.h       |  47 ++++++++-----
 fs/xfs/xfs_quotaops.c    |   6 +-
 fs/xfs/xfs_sb.h          |   6 ++
 fs/xfs/xfs_super.c       |  20 +++---
 fs/xfs/xfs_symlink.c     |   3 +-
 fs/xfs/xfs_trans_dquot.c |  87 ++++++++++-------------
 fs/xfs/xfs_trans_inode.c |  11 +++
 15 files changed, 340 insertions(+), 225 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
