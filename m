Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. v3.10-rc1-39-g2fb8b50
Message-Id: <20130619194936.813997F37@oss.sgi.com>
Date: Wed, 19 Jun 2013 14:49:36 -0500 (CDT)
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
  2fb8b50 xfs: Remove two dead transaction log reservaion macros
  635c4d0 xfs: return FIEMAP_EXTENT_UNKNOWN for delayed allocation extent
  725eb1e xfs: fix the symbolic link assert in xfs_ifree
      from  1ebdf3611c8968e7202c47c2dcb2d36986c44cb0 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 2fb8b5027dbde32a45edf5f3d7ee082be9261d93
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri May 3 15:41:19 2013 +0800

    xfs: Remove two dead transaction log reservaion macros
    
    Upstream commit 5b292ae3a951a58e32119d73c7ac8f5bec7395a3
    	xfs: make use of xfs_calc_buf_res() in xfs_trans.c
    
    Beginning from above commit, neither XFS_ALLOCFREE_LOG_RES() nor
    XFS_DIROP_LOG_RES() is used by those routines for calculating
    transaction space reservations, so it's safe to remove them now.
    
    Also, with a slightly update for the relevant comments to reflect
    the ideas of why those log count numbers should be.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 635c4d0bd94512de3aafa7ae8f45c1dce0fc1ffe
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Thu Jun 6 06:24:01 2013 -0700

    xfs: return FIEMAP_EXTENT_UNKNOWN for delayed allocation extent
    
    For FIEMAP ioctl(2), if an extent is in delayed allocation
    state, we need to return the FIEMAP_EXTENT_UNKNOWN flag except
    the FIEMAP_EXTENT_DELALLOC because its data location is unknown.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 725eb1eb2ae88c200466fec34bcf1fbce4b8eca3
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Mon Jun 17 15:35:57 2013 -0500

    xfs: fix the symbolic link assert in xfs_ifree
    
    Adding an extended attribute to a symbolic link can force that
    link to an remote extent. xfs_inactive() incorrectly assumes
    that any symbolic link small enough to be in the inode core
    is incore, resulting in the remote extent to not be removed.
    xfs_ifree() will assert on presence of this leaked remote extent.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_iops.c     |  3 ++-
 fs/xfs/xfs_symlink.c  | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_symlink.h  |  2 +-
 fs/xfs/xfs_trace.h    |  1 +
 fs/xfs/xfs_trans.h    | 11 +++--------
 fs/xfs/xfs_vnodeops.c | 15 +++------------
 6 files changed, 56 insertions(+), 24 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
