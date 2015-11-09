Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 761D87CBF
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 05:09:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A5A8304032
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 03:09:15 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n1v64CWNGZ8VVJl2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2015 03:09:14 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v15 00/22] Richacls (Core and Ext4)
Date: Mon,  9 Nov 2015 12:08:41 +0100
Message-Id: <1447067343-31479-1-git-send-email-agruenba@redhat.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Here is another update to the richacl patch queue.  This posting contains
the patches ready to be merged; the patches later in the queue still need
some more review.

Changes since the last posting (http://thread.gmane.org/gmane.linux.kernel.cifs/11221):

 * Replacing an existing file or directory requires to be able to delete
   and recreate it.  A new function may_replace was added to test for replace
   access vs. delete access (may_delete); this simplifies the code and makes it
   more readable.  Without richacls, deleting and creating requires the same
   permissions, and making that distinction wasn't useful.

 * The DELETE permission on a file was accidentally allowing to replace the
   file without also requiring the ADD_FILE permission on the containing
   directory.  This was fixed and a regression test was added to the test
   suite.

 * A comment as to how pages for XDR-encoded ACLs are alocated was added to
   __nfs4_proc_set_acl.  (See the complete patch queue for that.)


The complete patch queue is available in git form here:

  git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
	richacl-2015-11-09


The richacl user-space utilitites, man pages, and test suite are available
here:

  https://github.com/andreas-gruenbacher/richacl


Changes to other user-space packages for richacl are available here:

  https://github.com/andreas-gruenbacher/coreutils
  https://github.com/andreas-gruenbacher/e2fsprogs
  https://github.com/andreas-gruenbacher/xfsprogs-dev
  https://github.com/andreas-gruenbacher/nfs-utils


Please see the richacl homepage for more information:

  http://www.bestbits.at/richacl/


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
  posix_acl: Unexport acl_by_type and make it static
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
 fs/Kconfig                                      |   3 +
 fs/Makefile                                     |   2 +
 fs/attr.c                                       |  81 +++-
 fs/ext4/Kconfig                                 |  11 +
 fs/ext4/Makefile                                |   1 +
 fs/ext4/ext4.h                                  |   6 +-
 fs/ext4/file.c                                  |   3 +
 fs/ext4/ialloc.c                                |  11 +-
 fs/ext4/inode.c                                 |  12 +-
 fs/ext4/namei.c                                 |   5 +
 fs/ext4/richacl.c                               | 142 ++++++
 fs/ext4/richacl.h                               |  40 ++
 fs/ext4/super.c                                 |  49 +-
 fs/ext4/xattr.c                                 |   7 +
 fs/f2fs/acl.c                                   |   4 +-
 fs/inode.c                                      |  15 +-
 fs/jffs2/acl.c                                  |  10 +-
 fs/namei.c                                      | 118 +++--
 fs/posix_acl.c                                  |  50 +--
 fs/richacl_base.c                               | 564 ++++++++++++++++++++++++
 fs/richacl_inode.c                              | 333 ++++++++++++++
 fs/richacl_xattr.c                              | 298 +++++++++++++
 fs/xattr.c                                      |  34 +-
 include/linux/fs.h                              |  60 ++-
 include/linux/posix_acl.h                       |  13 +-
 include/linux/richacl.h                         | 208 +++++++++
 include/linux/richacl_xattr.h                   |  44 ++
 include/uapi/linux/Kbuild                       |   2 +
 include/uapi/linux/fs.h                         |   3 +-
 include/uapi/linux/richacl.h                    | 152 +++++++
 include/uapi/linux/richacl_xattr.h              |  44 ++
 include/uapi/linux/xattr.h                      |   2 +
 33 files changed, 2222 insertions(+), 107 deletions(-)
 create mode 100644 fs/ext4/richacl.c
 create mode 100644 fs/ext4/richacl.h
 create mode 100644 fs/richacl_base.c
 create mode 100644 fs/richacl_inode.c
 create mode 100644 fs/richacl_xattr.c
 create mode 100644 include/linux/richacl.h
 create mode 100644 include/linux/richacl_xattr.h
 create mode 100644 include/uapi/linux/richacl.h
 create mode 100644 include/uapi/linux/richacl_xattr.h

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
