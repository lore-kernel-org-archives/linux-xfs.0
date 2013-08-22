Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-2-12208-g3e3c51c
Message-Id: <20130822155111.62EF17FAF@oss.sgi.com>
Date: Thu, 22 Aug 2013 10:51:10 -0500 (CDT)
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
  3e3c51c xfs: add xfs sb v4 support for dirent filetype field
  1c55cec xfs: Add write support for dirent filetype field
  0cb9776 xfs: Add read-only support for dirent filetype field
      from  ed56f34f11da4f491680cd39482fd533134fd589 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 3e3c51cee9a07d67e3910cc514867b56ac60ec94
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Mon Aug 19 15:19:36 2013 -0500

    xfs: add xfs sb v4 support for dirent filetype field
    
    Add XFS superblock v4 support for the file type field in the
    directory entry feature.
    
    This support adds a feature bit for version 4 superblocks and
    leaves the original superblock 5 incompatibility bit.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Geoffrey Wehrman <gwehrman@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 1c55cece084aa4c9a3fa34ed4eecbdf18afbf05d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:50:10 2013 +1000

    xfs: Add write support for dirent filetype field
    
    Add support to propagate and add filetype values into the on-disk
    directs. This involves passing the filetype into the xfs_da_args
    structure along with the name and namelength for direct operations,
    and encoding it into the dirent at the same time we write the inode
    number into the dirent.
    
    With write support, add the feature flag to the
    XFS_SB_FEAT_INCOMPAT_ALL mask so we can now mount filesystems with
    this feature set.
    
    Performance of directory recursion is now much improved. Parallel
    walk of ~50 million directory entries across hundreds of directories
    improves significantly. Unpatched, no CRCs:
    
    Walking via ls -R
    
    real    3m19.886s
    user    6m36.960s
    sys     28m19.087s
    
    THis is doing roughly 500 getdents() calls per second, and 250,000
    inode lookups per second to determine the inode type at roughly
    17,000 read IOPS. CPU usage is 90% kernel space.
    
    With dtype support patched in and the fileset recreated with CRCs
    enabled:
    
    Walking via ls -R
    
    real    0m31.316s
    user    6m32.975s
    sys     0m21.111s
    
    This is doing roughly 3500 getdents() calls per second at 16,000
    IOPS. There are no inode lookups at all. CPU usages is almost 100%
    userspace.
    
    This is a big win for recursive directory walks that only need to
    find file names and file types.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0cb97766f2928579f1029ea7b28ae946cdd6fbe1
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:50:09 2013 +1000

    xfs: Add read-only support for dirent filetype field
    
    Add support for the file type field in directory entries so that
    readdir can return the type of the inode the dirent points to to
    userspace without first having to read the inode off disk.
    
    The encoding of the type field is a single byte that is added to the
    end of the directory entry name length. For all intents and
    purposes, it appends a "hidden" byte to the name field which
    contains the type information. As the directory entry is already of
    dynamic size, helpers are already required to access and decode the
    direct entry structures.
    
    Hence the relevent extraction and iteration helpers are updated to
    understand the hidden byte.  Helpers for reading and writing the
    filetype field from the directory entries are also added. Only the
    read helpers are used by this patch.  It also adds all the code
    necessary to read the type information out of the dirents on disk.
    
    Further we add the superblock feature bit and helpers to indicate
    that we understand the on-disk format change. This is not a
    compatible change - existing kernels cannot read the new format
    successfully - so an incompatible feature flag is added. We don't
    yet allow filesystems to mount with this flag yet - that will be
    added once write support is added.
    
    Finally, the code to take the type from the VFS, convert it to an
    XFS on-disk type and put it into the xfs_name structures passed
    around is added, but the directory code does not use this field yet.
    That will be in the next patch.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_da_btree.h     |   1 +
 fs/xfs/xfs_dir2.c         |   8 +-
 fs/xfs/xfs_dir2.h         |   4 +-
 fs/xfs/xfs_dir2_block.c   |  23 ++++--
 fs/xfs/xfs_dir2_data.c    |  15 ++--
 fs/xfs/xfs_dir2_format.h  | 183 ++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_dir2_leaf.c    |   9 ++-
 fs/xfs/xfs_dir2_node.c    |  11 ++-
 fs/xfs/xfs_dir2_priv.h    |   9 +++
 fs/xfs/xfs_dir2_readdir.c |  69 ++++++++++++++---
 fs/xfs/xfs_dir2_sf.c      | 140 ++++++++++++++++++++++-------------
 fs/xfs/xfs_iops.c         |  27 ++++---
 fs/xfs/xfs_sb.h           |  31 ++++++--
 fs/xfs/xfs_types.h        |   1 +
 14 files changed, 406 insertions(+), 125 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
