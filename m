Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. v3.10-rc1-29-g5c87d4b
Message-Id: <20130605162921.1C7D67F52@oss.sgi.com>
Date: Wed,  5 Jun 2013 11:29:20 -0500 (CDT)
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
  5c87d4b xfs: increase number of ACL entries for V5 superblocks
  d3eaace xfs: disable noattr2/attr2 mount options for CRC enabled filesystems
  0a32c26 xfs: inode unlinked list needs to recalculate the inode CRC
  a775ad7 xfs: fix log recovery transaction item reordering
      from  59913f14dfe8eb772ff93eb442947451b4416329 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 5 12:09:10 2013 +1000

    xfs: increase number of ACL entries for V5 superblocks
    
    The limit of 25 ACL entries is arbitrary, but baked into the on-disk
    format.  For version 5 superblocks, increase it to the maximum nuber
    of ACLs that can fit into a single xattr.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinuguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit d3eaace84e40bf946129e516dcbd617173c1cf14
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 5 12:09:09 2013 +1000

    xfs: disable noattr2/attr2 mount options for CRC enabled filesystems
    
    attr2 format is always enabled for v5 superblock filesystems, so the
    mount options to enable or disable it need to be cause mount errors.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0a32c26e720a8b38971d0685976f4a7d63f9e2ef
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 5 12:09:08 2013 +1000

    xfs: inode unlinked list needs to recalculate the inode CRC
    
    The inode unlinked list manipulations operate directly on the inode
    buffer, and so bypass the inode CRC calculation mechanisms. Hence an
    inode on the unlinked list has an invalid CRC. Fix this by
    recalculating the CRC whenever we modify an unlinked list pointer in
    an inode, ncluding during log recovery. This is trivial to do and
    results in  unlinked list operations always leaving a consistent
    inode in the buffer.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit a775ad778073d55744ed6709ccede36310638911
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jun 5 12:09:07 2013 +1000

    xfs: fix log recovery transaction item reordering
    
    There are several constraints that inode allocation and unlink
    logging impose on log recovery. These all stem from the fact that
    inode alloc/unlink are logged in buffers, but all other inode
    changes are logged in inode items. Hence there are ordering
    constraints that recovery must follow to ensure the correct result
    occurs.
    
    As it turns out, this ordering has been working mostly by chance
    than good management. The existing code moves all buffers except
    cancelled buffers to the head of the list, and everything else to
    the tail of the list. The problem with this is that is interleaves
    inode items with the buffer cancellation items, and hence whether
    the inode item in an cancelled buffer gets replayed is essentially
    left to chance.
    
    Further, this ordering causes problems for log recovery when inode
    CRCs are enabled. It typically replays the inode unlink buffer long before
    it replays the inode core changes, and so the CRC recorded in an
    unlink buffer is going to be invalid and hence any attempt to
    validate the inode in the buffer is going to fail. Hence we really
    need to enforce the ordering that the inode alloc/unlink code has
    expected log recovery to have since inode chunk de-allocation was
    introduced back in 2003...
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_acl.c         | 31 +++++++++++---------
 fs/xfs/xfs_acl.h         | 31 +++++++++++++++-----
 fs/xfs/xfs_inode.c       | 16 +++++++++++
 fs/xfs/xfs_log_recover.c | 74 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_super.c       | 11 +++++++
 5 files changed, 136 insertions(+), 27 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
