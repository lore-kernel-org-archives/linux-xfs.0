Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.12-11685-gf9b395a
Message-Id: <20131211212929.CB59D7F55@oss.sgi.com>
Date: Wed, 11 Dec 2013 15:29:29 -0600 (CST)
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
  f9b395a xfs: align initial file allocations correctly
  8e825e3 xfs: fix calculation of freed inode cluster blocks
  b3f03ba xfs: xfs_dir2_block_to_sf temp buffer allocation fails
      from  df8052e7dae00bde6f21b40b6e3e1099770f3afc (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit f9b395a8ef8f34d19cae2cde361e19c96e097fad
Author: Dave Chinner <dchinner@redhat.com>
Date:   Fri Nov 22 10:41:16 2013 +1100

    xfs: align initial file allocations correctly
    
    The function xfs_bmap_isaeof() is used to indicate that an
    allocation is occurring at or past the end of file, and as such
    should be aligned to the underlying storage geometry if possible.
    
    Commit 27a3f8f ("xfs: introduce xfs_bmap_last_extent") changed the
    behaviour of this function for empty files - it turned off
    allocation alignment for this case accidentally. Hence large initial
    allocations from direct IO are not getting correctly aligned to the
    underlying geometry, and that is cause write performance to drop in
    alignment sensitive configurations.
    
    Fix it by considering allocation into empty files as requiring
    aligned allocation again.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 8e825e3a02ff20973154559c33e662cacedc4458
Author: Ben Myers <bpm@sgi.com>
Date:   Tue Dec 10 14:59:31 2013 -0600

    xfs: fix calculation of freed inode cluster blocks
    
    rec.ir_startino is an agino rather than an ino.  Use the correct macro
    when dealing with it in xfs_difree.
    
    Signed-off-by: Ben Myers <bpm@sgi.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>

commit b3f03bac8132207a20286d5602eda64500c19724
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Dec 3 23:50:57 2013 +1100

    xfs: xfs_dir2_block_to_sf temp buffer allocation fails
    
    If we are using a large directory block size, and memory becomes
    fragmented, we can get memory allocation failures trying to
    kmem_alloc(64k) for a temporary buffer. However, there is not need
    for a directory buffer sized allocation, as the end result ends up
    in the inode literal area. This is, at most, slightly less than 2k
    of space, and hence we don't need an allocation larger than that
    fora temporary buffer.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_bmap.c    |  9 ++++++--
 fs/xfs/xfs_dir2_sf.c | 58 ++++++++++++++++++++++++++++++----------------------
 fs/xfs/xfs_ialloc.c  |  2 +-
 3 files changed, 42 insertions(+), 27 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
