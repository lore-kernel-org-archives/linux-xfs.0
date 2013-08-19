Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. for-linus-v3.11-rc1-2-12178-g2ad01f5
Message-Id: <20130819181212.D4DE07F89@oss.sgi.com>
Date: Mon, 19 Aug 2013 13:12:12 -0500 (CDT)
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
  2ad01f5 xfs: use reference counts to free clean buffer items
  8c567a7 xfs: add capability check to free eofblocks ioctl
  b9fe505 xfs: create internal eofblocks structure with kuid_t types
  7aab1b2 xfs: convert kuid_t to/from uid_t for internal structures
  fd5e2aa xfs: ioctl check for capabilities in the current user namespace
  288bbe0 xfs: convert kuid_t to/from uid_t in ACLs
  c5eeb7e xfs: create wrappers for converting kuid_t to/from uid_t
      from  4bb928cdb900d0614f4766d5f1ca5bc3844f7656 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 2ad01f53dc34ef3180e555d40b331f95f269a0fa
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 12 20:50:11 2013 +1000

    xfs: use reference counts to free clean buffer items
    
    When a transaction is cancelled and the buffer log item is clean in
    the transaction, the buffer log item is unconditionally freed. If
    the log item is in the AIL, however, this leads to a use after free
    condition as the item still has other users.
    
    In this case, xfs_buf_item_relse() should only be called on clean
    buffer items if the reference count has dropped to zero. This
    ensures only the last user frees the item.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 8c567a7fab6e086a0284eee2db82348521e7120c
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Thu Aug 15 14:08:03 2013 -0400

    xfs: add capability check to free eofblocks ioctl
    
    Check for CAP_SYS_ADMIN since the caller can truncate preallocated
    blocks from files they do not own nor have write access to. A more
    fine grained access check was considered: require the caller to
    specify their own uid/gid and to use inode_permission to check for
    write, but this would not catch the case of an inode not reachable
    via path traversal from the callers mount namespace.
    
    Add check for read-only filesystem to free eofblocks ioctl.
    
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
    Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b9fe505258375b98519493a41a8088e384965aa9
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Thu Aug 15 14:08:02 2013 -0400

    xfs: create internal eofblocks structure with kuid_t types
    
    Have eofblocks ioctl convert uid_t to kuid_t into internal structure.
    Update internal filter matching to compare ids with kuid_t types.
    
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
    Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 7aab1b28879d2280c9a0e50000e4ae153cfac55a
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Thu Aug 15 14:08:01 2013 -0400

    xfs: convert kuid_t to/from uid_t for internal structures
    
    Use uint32 from init_user_ns for xfs internal uid/gid
    representation in xfs_icdinode, xfs_dqid_t.
    
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
    Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit fd5e2aa8653665ae1cc60f7aca1069abdbcad3f6
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Thu Aug 15 14:08:00 2013 -0400

    xfs: ioctl check for capabilities in the current user namespace
    
    Use inode_capable() to check if SUID|SGID bits should be cleared to match
    similar check in inode_change_ok().
    
    The check for CAP_LINUX_IMMUTABLE was not modified since all other file
    systems also check against init_user_ns rather than current_user_ns.
    
    Only allow changing of projid from init_user_ns.
    
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
    Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 288bbe0eeb3da7238482ca586c6fb029801336be
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Thu Aug 15 14:07:59 2013 -0400

    xfs: convert kuid_t to/from uid_t in ACLs
    
    Change permission check for setting ACL to use inode_owner_or_capable()
    which will additionally allow a CAP_FOWNER user in a user namespace to
    be able to set an ACL on an inode covered by the user namespace mapping.
    
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
    Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit c5eeb7ec3e1bb9884e97066bc293792ab57fb4ab
Author: Dwight Engen <dwight.engen@oracle.com>
Date:   Thu Aug 15 14:07:58 2013 -0400

    xfs: create wrappers for converting kuid_t to/from uid_t
    
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>
    Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_acl.c      | 20 ++++++++++++++++----
 fs/xfs/xfs_buf_item.c |  6 ++----
 fs/xfs/xfs_fs.h       |  2 +-
 fs/xfs/xfs_icache.c   | 12 ++++++------
 fs/xfs/xfs_icache.h   | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c    |  9 +++++----
 fs/xfs/xfs_ioctl.c    | 35 +++++++++++++++++++++--------------
 fs/xfs/xfs_iops.c     | 38 ++++++++++++++++++++------------------
 fs/xfs/xfs_linux.h    | 26 ++++++++++++++++++++++++++
 fs/xfs/xfs_qm.c       | 10 +++++-----
 fs/xfs/xfs_quota.h    | 11 ++++++-----
 fs/xfs/xfs_symlink.c  |  7 +++++--
 12 files changed, 156 insertions(+), 63 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
