Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4BB4C7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 06:51:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CD3E5AC003
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 04:51:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WF8QOOErteMkSuUo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 04:51:04 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v22 00/22] Richacls (Core and Ext4)
Date: Tue, 31 May 2016 13:50:32 +0200
Message-Id: <1464695454-18557-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

Here is another update of the richacl patches.  Changes since the last posting
(https://lwn.net/Articles/686799/):

 * Rebase on top of 4.7-rc1 because of the getxattr/setxattr inode operation
   changes in mainline.

[* xfs: Treat RichACLs like POSIX ACLs: allow setting arbitrary values as root
   via "trusted.richacl" even though that may introduce inconsistencies. Drop
   patch "xfs: Fix richacl access by ioctl" which made the attr ioctls behave
   the same way as the xattr syscalls.]

[* nfs: Fix an uninitialized pointer dereference (nfsi->richacl) accidentally
   introduced in the last snapshot.]


The complete patch queue is available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
	richacl-2016-05-31


The richacl user-space utilitites, man pages, and test suite are available
here:

  https://github.com/andreas-gruenbacher/richacl


Changes to other user-space packages for richacl:

  https://github.com/andreas-gruenbacher/coreutils
  https://github.com/andreas-gruenbacher/e2fsprogs
  https://github.com/andreas-gruenbacher/samba
  https://github.com/andreas-gruenbacher/xfsprogs-dev
  https://github.com/andreas-gruenbacher/nfs-utils


Please see the richacl homepage for more information:

  http://www.bestbits.at/richacl/


What more needs to be done to get this initial set of patches merged?

Thanks,
Andreas

Andreas Gruenbacher (20):
  vfs: Add IS_ACL() and IS_RICHACL() tests
  vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR permission flags
  vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD permission flags
  vfs: Make the inode passed to inode_change_ok non-const
  vfs: Add permission flags for setting file attributes
  richacl: In-memory representation and helper functions
  richacl: Permission mapping functions
  richacl: Compute maximum file masks from an acl
  richacl: Permission check algorithm
  posix_acl: Improve xattr fixup code
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

Aneesh Kumar K.V (2):
  ext4: Add richacl support
  ext4: Add richacl feature flag

 drivers/staging/lustre/lustre/llite/llite_lib.c |   2 +-
 fs/9p/acl.c                                     |   8 +-
 fs/Kconfig                                      |   3 +
 fs/Makefile                                     |   1 +
 fs/attr.c                                       |  81 ++-
 fs/ext4/Kconfig                                 |  11 +
 fs/ext4/Makefile                                |   1 +
 fs/ext4/ext4.h                                  |   6 +-
 fs/ext4/file.c                                  |   3 +
 fs/ext4/ialloc.c                                |  11 +-
 fs/ext4/inode.c                                 |   5 +-
 fs/ext4/namei.c                                 |   5 +
 fs/ext4/richacl.c                               | 134 ++++
 fs/ext4/richacl.h                               |  40 ++
 fs/ext4/super.c                                 |  49 +-
 fs/ext4/xattr.c                                 |   7 +
 fs/f2fs/acl.c                                   |   4 +-
 fs/inode.c                                      |  43 +-
 fs/jffs2/acl.c                                  |   6 +-
 fs/namei.c                                      | 152 ++--
 fs/nfs/nfs3acl.c                                |  14 +-
 fs/posix_acl.c                                  |  69 +-
 fs/richacl.c                                    | 893 ++++++++++++++++++++++++
 fs/richacl_xattr.c                              | 234 +++++++
 fs/xattr.c                                      |  29 +-
 include/linux/acl.h                             |  15 +
 include/linux/fs.h                              |  67 +-
 include/linux/posix_acl.h                       |  21 +-
 include/linux/richacl.h                         | 210 ++++++
 include/linux/richacl_xattr.h                   |  31 +
 include/uapi/linux/Kbuild                       |   2 +
 include/uapi/linux/fs.h                         |   3 +-
 include/uapi/linux/richacl.h                    | 152 ++++
 include/uapi/linux/richacl_xattr.h              |  44 ++
 include/uapi/linux/xattr.h                      |   2 +
 35 files changed, 2198 insertions(+), 160 deletions(-)
 create mode 100644 fs/ext4/richacl.c
 create mode 100644 fs/ext4/richacl.h
 create mode 100644 fs/richacl.c
 create mode 100644 fs/richacl_xattr.c
 create mode 100644 include/linux/acl.h
 create mode 100644 include/linux/richacl.h
 create mode 100644 include/linux/richacl_xattr.h
 create mode 100644 include/uapi/linux/richacl.h
 create mode 100644 include/uapi/linux/richacl_xattr.h

-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
