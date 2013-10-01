Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc3-7-gd948709
Message-Id: <20131001225342.3F59729DFC@oss.sgi.com>
Date: Tue,  1 Oct 2013 17:53:42 -0500 (CDT)
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
  d948709 xfs: remove usage of is_bad_inode
  17ec81c xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
  0799a3e xfs: get rid of count from xfs_iomap_write_allocate()
      from  aaaae98022efa4f3c31042f1fdf9e7a0c5f04663 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit d948709b8e468510d8c855d1e4c9f1cb7b524880
Author: Ben Myers <bpm@sgi.com>
Date:   Tue Sep 10 18:11:22 2013 -0500

    xfs: remove usage of is_bad_inode
    
    XFS never calls mark_inode_bad or iget_failed, so it will never see a
    bad inode.  Remove all checks for is_bad_inode because they are
    unnecessary.
    
    Signed-off-by: Ben Myers <bpm@sgi.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>

commit 17ec81c15fd022842f9bc947841ba9fb9eb52591
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Sun Sep 22 16:25:15 2013 +0800

    xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
    
    At xfs_iext_realloc_direct(), the new_size is changed by adding
    if_bytes if originally the extent records are stored at the inline
    extent buffer, and we have to switch from it to a direct extent
    list for those new allocated extents, this is wrong. e.g,
    
    Create a file with three extents which was showing as following,
    
    xfs_io -f -c "truncate 100m" /xfs/testme
    
    for i in $(seq 0 5 10); do
    	offset=$(($i * $((1 << 20))))
    	xfs_io -c "pwrite $offset 1m" /xfs/testme
    done
    
    Inline
    ------
    irec:	if_bytes	bytes_diff	new_size
    1st	0		16		16
    2nd	16		16		32
    
    Switching
    ---------						rnew_size
    3rd	32		16		48 + 32 = 80	roundup=128
    
    In this case, the desired value of new_size should be 48, and then
    it will be roundup to 64 and be assigned to rnew_size.
    
    However, this issue has been covered by resetting the if_bytes to
    the new_size which is calculated at the begnning of xfs_iext_add()
    before leaving out this function, and in turn make the rnew_size
    correctly again. Hence, this can not be detected via xfstestes.
    
    This patch fix above problem and revise the new_size comments at
    xfs_iext_realloc_direct() to make it more readable.  Also, fix the
    comments while switching from the inline extent buffer to a direct
    extent list to reflect this change.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0799a3e808e5543235bcdfe9d1fa1572e0e86ab5
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Sun Sep 29 18:56:04 2013 +0800

    xfs: get rid of count from xfs_iomap_write_allocate()
    
    Get rid of function variable count from xfs_iomap_write_allocate() as
    it is unused.
    
    Additionally, checkpatch warn me of the following for this change:
    WARNING: extern prototypes should be avoided in .h files
    +extern int xfs_iomap_write_allocate(struct xfs_inode *, xfs_off_t,
    
    So this patch also remove all extern function prototypes at xfs_iomap.h
    to suppress it to make this code style in consistent manner in this file.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c       | 2 +-
 fs/xfs/xfs_icache.c     | 7 -------
 fs/xfs/xfs_inode.c      | 2 +-
 fs/xfs/xfs_inode_fork.c | 9 ++-------
 fs/xfs/xfs_iomap.c      | 1 -
 fs/xfs/xfs_iomap.h      | 8 ++++----
 fs/xfs/xfs_super.c      | 9 ---------
 7 files changed, 8 insertions(+), 30 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
