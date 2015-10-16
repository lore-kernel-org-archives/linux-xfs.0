Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB9377F69
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:18:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 711DD304062
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:18:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tnOkyti5A5ATUBH2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:18:36 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 00/48] Richacls
Date: Fri, 16 Oct 2015 17:17:38 +0200
Message-Id: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

Here is another update of the richacl patch queue.  I would like to ask for
feedback so that the core and local filesystem code (patches 1-24) can be
merged in the 4.4 merge window.

Changes since the last posting (http://lwn.net/Articles/660392/):

 * The kernel nfs client can now distinguish between users and
   groups which have no ID mapping and the nobody user/group.
   This requires an extension to the nfsidmap user-space helper
   from the nfs-utils package [2].  When the kernel detects
   that nfsidmap doesn't support the new mapping, it falls
   back to the old one.

 * Minor bugs with unmapped user and group names in nfs and nfsd
   have been fixed.  Some functions have been split to be easier
   to understand.

 * The ext4 and xfs filesystem code has been simplified based on
   feedback from Dave Chinner.  On xfs, richacls can no longer
   be compiled out (but they will only be effective on file
   systems with the richacl feature set).


The complete patch queue is available in git form at [1].  The richacl
user-space utilitites and test suite are available at [3].  Please see the
richacl homepage [4] for more information.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
	richacl-2015-10-16
[2] https://github.com/andreas-gruenbacher/nfs-utils
[3] https://github.com/andreas-gruenbacher/richacl/
[4] http://www.bestbits.at/richacl/


Thanks,
Andreas


Andreas Gruenbacher (46):
  vfs: Add IS_ACL() and IS_RICHACL() tests
  vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR permission flags
  vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD permission flags
  vfs: Make the inode passed to inode_change_ok non-const
  vfs: Add permission flags for setting file attributes
  richacl: In-memory representation and helper functions
  richacl: Permission mapping functions
  richacl: Compute maximum file masks from an acl
  richacl: Permission check algorithm
  vfs: Cache base_acl objects in inodes
  vfs: Add get_richacl and set_richacl inode operations
  vfs: Cache richacl in struct inode
  richacl: Update the file masks in chmod()
  richacl: Check if an acl is equivalent to a file mode
  richacl: Create-time inheritance
  richacl: Automatic Inheritance
  richacl: xattr mapping functions
  richacl: Add richacl xattr handler
  vfs: Add richacl permission checking
  xfs: Fix error path in xfs_get_acl
  xfs: Make xfs_set_mode non-static
  xfs: Add richacl support
  richacl: acl editing helper functions
  richacl: Move everyone@ aces down the acl
  richacl: Propagate everyone@ permissions to other aces
  richacl: Set the owner permissions to the owner mask
  richacl: Set the other permissions to the other mask
  richacl: Isolate the owner and group classes
  richacl: Apply the file masks to a richacl
  richacl: Create richacl from mode values
  nfsd: Keep list of acls to dispose of in compoundargs
  nfsd: Use richacls as internal acl representation
  nfsd: Add richacl support
  nfsd: Add support for the v4.1 dacl attribute
  nfsd: Add support for the MAY_CREATE_{FILE,DIR} permissions
  richacl: Add support for unmapped identifiers
  nfsd: Add support for unmapped richace identifiers
  ext4: Don't allow unmapped identifiers in richacls
  xfs: Don't allow unmapped identifiers in richacls
  sunrpc: Allow to demand-allocate pages to encode into
  sunrpc: Add xdr_init_encode_pages
  nfs: Fix GETATTR bitmap verification
  nfs: Remove unused xdr page offsets in getacl/setacl arguments
  nfs: Distinguish missing users and groups from nobody
  nfs: Add richacl support
  nfs: Add support for the v4.1 dacl attribute

Aneesh Kumar K.V (2):
  ext4: Add richacl support
  ext4: Add richacl feature flag

 drivers/staging/lustre/lustre/llite/llite_lib.c |   2 +-
 fs/Kconfig                                      |   9 +
 fs/Makefile                                     |   3 +
 fs/attr.c                                       |  81 ++-
 fs/ext4/Kconfig                                 |  11 +
 fs/ext4/Makefile                                |   1 +
 fs/ext4/ext4.h                                  |   6 +-
 fs/ext4/file.c                                  |   3 +
 fs/ext4/ialloc.c                                |  11 +-
 fs/ext4/inode.c                                 |  12 +-
 fs/ext4/namei.c                                 |   5 +
 fs/ext4/richacl.c                               | 145 ++++
 fs/ext4/richacl.h                               |  40 ++
 fs/ext4/super.c                                 |  42 +-
 fs/ext4/xattr.c                                 |   7 +
 fs/f2fs/acl.c                                   |   4 +-
 fs/inode.c                                      |  15 +-
 fs/jffs2/acl.c                                  |   6 +-
 fs/namei.c                                      | 111 ++-
 fs/nfs/inode.c                                  |   3 -
 fs/nfs/nfs4idmap.c                              |  57 +-
 fs/nfs/nfs4proc.c                               | 734 ++++++++++++++-----
 fs/nfs/nfs4xdr.c                                | 261 ++++++-
 fs/nfs/super.c                                  |   4 +-
 fs/nfs_common/Makefile                          |   1 +
 fs/nfs_common/nfs4acl.c                         |  44 ++
 fs/nfsd/Kconfig                                 |   1 +
 fs/nfsd/acl.h                                   |  23 +-
 fs/nfsd/nfs4acl.c                               | 487 +++++++------
 fs/nfsd/nfs4proc.c                              |  25 +-
 fs/nfsd/nfs4xdr.c                               | 268 ++++---
 fs/nfsd/nfsd.h                                  |   6 +-
 fs/nfsd/nfsfh.c                                 |   8 +-
 fs/nfsd/vfs.c                                   |  28 +-
 fs/nfsd/vfs.h                                   |  17 +-
 fs/nfsd/xdr4.h                                  |  12 +-
 fs/posix_acl.c                                  |  26 +-
 fs/richacl_base.c                               | 685 ++++++++++++++++++
 fs/richacl_compat.c                             | 915 ++++++++++++++++++++++++
 fs/richacl_inode.c                              | 333 +++++++++
 fs/richacl_xattr.c                              | 345 +++++++++
 fs/xattr.c                                      |  34 +-
 fs/xfs/Kconfig                                  |   1 +
 fs/xfs/Makefile                                 |   1 +
 fs/xfs/libxfs/xfs_format.h                      |  11 +-
 fs/xfs/xfs_acl.c                                |  19 +-
 fs/xfs/xfs_acl.h                                |   1 -
 fs/xfs/xfs_inode.c                              |  24 +
 fs/xfs/xfs_inode.h                              |   2 +
 fs/xfs/xfs_iops.c                               |  44 +-
 fs/xfs/xfs_richacl.c                            | 106 +++
 fs/xfs/xfs_richacl.h                            |  23 +
 fs/xfs/xfs_super.c                              |   6 +-
 fs/xfs/xfs_super.h                              |   4 +
 fs/xfs/xfs_xattr.c                              |   2 +
 include/linux/fs.h                              |  51 +-
 include/linux/nfs4.h                            |  24 +-
 include/linux/nfs4acl.h                         |   7 +
 include/linux/nfs_fs.h                          |   1 -
 include/linux/nfs_fs_sb.h                       |   3 +
 include/linux/nfs_xdr.h                         |  13 +-
 include/linux/posix_acl.h                       |  12 +-
 include/linux/richacl.h                         | 276 +++++++
 include/linux/richacl_compat.h                  |  40 ++
 include/linux/richacl_xattr.h                   |  44 ++
 include/linux/sunrpc/xdr.h                      |   2 +
 include/uapi/linux/Kbuild                       |   2 +
 include/uapi/linux/fs.h                         |   3 +-
 include/uapi/linux/nfs4.h                       |   3 +-
 include/uapi/linux/richacl.h                    | 111 +++
 include/uapi/linux/richacl_xattr.h              |  44 ++
 include/uapi/linux/xattr.h                      |   2 +
 net/sunrpc/xdr.c                                |  34 +
 73 files changed, 4985 insertions(+), 762 deletions(-)
 create mode 100644 fs/ext4/richacl.c
 create mode 100644 fs/ext4/richacl.h
 create mode 100644 fs/nfs_common/nfs4acl.c
 create mode 100644 fs/richacl_base.c
 create mode 100644 fs/richacl_compat.c
 create mode 100644 fs/richacl_inode.c
 create mode 100644 fs/richacl_xattr.c
 create mode 100644 fs/xfs/xfs_richacl.c
 create mode 100644 fs/xfs/xfs_richacl.h
 create mode 100644 include/linux/nfs4acl.h
 create mode 100644 include/linux/richacl.h
 create mode 100644 include/linux/richacl_compat.h
 create mode 100644 include/linux/richacl_xattr.h
 create mode 100644 include/uapi/linux/richacl.h
 create mode 100644 include/uapi/linux/richacl_xattr.h

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
