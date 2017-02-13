Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753219AbdBMPcn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Feb 2017 10:32:43 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v28 00/21] Richacls (Core and Ext4)
Date: Mon, 13 Feb 2017 16:32:16 +0100
Message-Id: <1486999957-2381-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

Here is another update of the richacl patches.  Changes since the last posting
(https://lwn.net/Articles/703199/):

 * Fix permission checking for file exchange (i.e., renameat2 with the
   RENAME_EXCHANGE flag): in some cases, the MAY_CREATE_FILE and MAY_CREATE_DIR
   permissions were swapped.

   This should have been caught by the test suite but wasn't.  Meanwhile the
   test suite is fixed as well.

 * When deleting a file and we have MAY_DELETE_SELF permission on the file, we
   don't require MAY_DELETE_CHILD permission on the containing directory.
   However, we must still call inode_permission with MAY_WRITE in mask for
   checks beyond file permission bits or ACLs, such as LSM.


Many thanks to Miklos for the previous patch review.


The complete patch queue is available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
	richacl-2017-02-13


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


Thanks,
Andreas

Andreas Gruenbacher (19):
  vfs: Add IS_ACL() and IS_RICHACL() tests
  vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR permission flags
  vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD permission flags
  vfs: Add permission flags for setting file attributes
  richacl: In-memory representation and helper functions
  richacl: Permission mapping functions
  richacl: Permission check algorithm
  richacl: Compute maximum file masks from an acl
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
  vfs: Move check_posix_acl and check_richacl out of fs/namei.c

Aneesh Kumar K.V (2):
  ext4: Add richacl support
  ext4: Add richacl feature flag

 fs/9p/acl.c                        |   8 +-
 fs/Kconfig                         |   3 +
 fs/Makefile                        |   1 +
 fs/attr.c                          |  79 +++-
 fs/ext4/Kconfig                    |  11 +
 fs/ext4/Makefile                   |   1 +
 fs/ext4/ext4.h                     |   7 +-
 fs/ext4/file.c                     |   3 +
 fs/ext4/ialloc.c                   |  11 +-
 fs/ext4/inode.c                    |   4 +-
 fs/ext4/namei.c                    |   5 +
 fs/ext4/richacl.c                  | 134 ++++++
 fs/ext4/richacl.h                  |  40 ++
 fs/ext4/super.c                    |  48 +-
 fs/ext4/xattr.c                    |   7 +
 fs/f2fs/acl.c                      |   4 +-
 fs/inode.c                         |  43 +-
 fs/jffs2/acl.c                     |   6 +-
 fs/namei.c                         | 150 +++---
 fs/nfs/nfs3acl.c                   |  14 +-
 fs/posix_acl.c                     |  97 ++--
 fs/richacl.c                       | 937 +++++++++++++++++++++++++++++++++++++
 fs/richacl_xattr.c                 | 222 +++++++++
 include/linux/acl.h                |  15 +
 include/linux/fs.h                 |  58 ++-
 include/linux/posix_acl.h          |  24 +-
 include/linux/richacl.h            | 218 +++++++++
 include/linux/richacl_xattr.h      |  31 ++
 include/uapi/linux/Kbuild          |   2 +
 include/uapi/linux/fs.h            |   3 +-
 include/uapi/linux/richacl.h       | 152 ++++++
 include/uapi/linux/richacl_xattr.h |  44 ++
 include/uapi/linux/xattr.h         |   2 +
 33 files changed, 2216 insertions(+), 168 deletions(-)
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
2.7.4

