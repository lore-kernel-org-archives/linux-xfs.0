Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D49567F54
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:08:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5C07304053
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:08:10 -0700 (PDT)
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH v8 0/7] userns: Convert xfs to use kuid_t/kgid_t where
	appropriate
Date: Thu, 15 Aug 2013 14:07:57 -0400
Message-Id: <1376590084-12888-1-git-send-email-dwight.engen@oracle.com>
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
Cc: Ben Myers <bpm@sgi.com>

Hi All,

This patchset adds USER_NS support to XFS. It has been rebased on top
of 2c2bcc07 git://oss.sgi.com/xfs/xfs.git master branch.

The patches do not convert the id's returned from bulkstat, since bulkstat
cannot be called from inside a userns right now anyway since the caller
must be CAP_SYS_ADMIN in init_user_ns. Similar checks ensure that
open_by_handle, and changing of projid can also only be called from
init_user_ns.

Changes since v7 patchset
- 0003 only allow setting of projid from init_user_ns
- 0006 change readonly check from IS_RDONLY to xfs style

Changes since v6 patchset (addressing Dave's comments)
- 0006 just do a capable(CAP_SYS_ADMIN) check for XFS_IOC_FREE_EOFBLOCKS

Changes since v5 patchset (addressing Brian's comments,
only 0005 and 0006 are changed):
 - 0005 put all eofblocks validation in xfs_fs_eofblocks_from_user()
 - 0006 don't export internal flag, add K to internal flag name,
   start internal flags bits at msb (with the intention that other internal
   flags would be in descending order) and ensure that it doesn't
accidentally
   collide with external flags

Changes since v4 patchset (addressing Dave's comments):
 - add parenthesis in if with binary and logical and (EOFBLOCKS flags)
 - rename xfs_fs_eofblocks_to_internal -> xfs_fs_eofblocks_from_user and
   move conversion validation into it
 - fix negative error returns from XFS_IOC_FREE_EOFBLOCKS
 - add check for read-only filesystem to XFS_IOC_FREE_EOFBLOCKS

Changes since v3 patchset:
 - export inode_capable() for building xfs as a module
 - implement Brian's proposal for an internal flag to indicate to
   xfs_inode_free_eofblocks() that it should do a permission check.
   ioctl callers will always set this flag, which is simpler than
   making them specify XFS_EOF_FLAGS_UID or XFS_EOF_FLAGS_GID,
   internal callers can leave it unset so no permission checking is
   done
 - take Brian's suggestion on moving the policy from the conversion
   function into the ioctl code, and moving stuff to xfs_icache.h

Dwight Engen (7):
  xfs: create wrappers for converting kuid_t to/from uid_t
  xfs: convert kuid_t to/from uid_t in ACLs
  xfs: ioctl check for capabilities in the current user namespace
  xfs: convert kuid_t to/from uid_t for internal structures
  xfs: create internal eofblocks structure with kuid_t types
  xfs: add capability check to free eofblocks ioctl
  enable building user namespace with xfs

 fs/xfs/xfs_acl.c     | 20 ++++++++++++++++----
 fs/xfs/xfs_fs.h      |  2 +-
 fs/xfs/xfs_icache.c  | 12 ++++++------
 fs/xfs/xfs_icache.h  | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c   |  9 +++++----
 fs/xfs/xfs_ioctl.c   | 35 +++++++++++++++++++++--------------
 fs/xfs/xfs_iops.c    | 38 ++++++++++++++++++++------------------
 fs/xfs/xfs_linux.h   | 26 ++++++++++++++++++++++++++
 fs/xfs/xfs_qm.c      | 10 +++++-----
 fs/xfs/xfs_quota.h   | 11 ++++++-----
 fs/xfs/xfs_symlink.c |  7 +++++--
 init/Kconfig         | 13 -------------
 kernel/capability.c  |  1 +
 13 files changed, 155 insertions(+), 72 deletions(-)

-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
