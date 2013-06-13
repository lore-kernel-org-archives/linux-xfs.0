Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.10-rc1-31-gade1335
Message-Id: <20130613191914.6B7E729E0C@oss.sgi.com>
Date: Thu, 13 Jun 2013 14:19:14 -0500 (CDT)
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
  ade1335 xfs: ensure btree root split sets blkno correctly
      from  8a1fd2950e1fe267e11fc8c85dcaa6b023b51b60 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit ade1335afef556df6538eb02e8c0dc91fbd9cc37
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 12 12:19:08 2013 +1000

    xfs: ensure btree root split sets blkno correctly
    
    For CRC enabled filesystems, the BMBT is rooted in an inode, so it
    passes through a different code path on root splits than the
    freespace and inode btrees. This is much less traversed by xfstests
    than the other trees. When testing on a 1k block size filesystem,
    I've been seeing ASSERT failures in generic/234 like:
    
    XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_private.b.allocated == 0, file: fs/xfs/xfs_btree.c, line: 317
    
    which are generally preceded by a lblock check failure. I noticed
    this in the bmbt stats:
    
    $ pminfo -f xfs.btree.block_map
    
    xfs.btree.block_map.lookup
        value 39135
    
    xfs.btree.block_map.compare
        value 268432
    
    xfs.btree.block_map.insrec
        value 15786
    
    xfs.btree.block_map.delrec
        value 13884
    
    xfs.btree.block_map.newroot
        value 2
    
    xfs.btree.block_map.killroot
        value 0
    .....
    
    Very little coverage of root splits and merges. Indeed, on a 4k
    filesystem, block_map.newroot and block_map.killroot are both zero.
    i.e. the code is not exercised at all, and it's the only generic
    btree infrastructure operation that is not exercised by a default run
    of xfstests.
    
    Turns out that on a 1k filesystem, generic/234 accounts for one of
    those two root splits, and that is somewhat of a smoking gun. In
    fact, it's the same problem we saw in the directory/attr code where
    headers are memcpy()d from one block to another without updating the
    self describing metadata.
    
    Simple fix - when copying the header out of the root block, make
    sure the block number is updated correctly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_btree.c | 10 ++++++++++
 1 file changed, 10 insertions(+)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
