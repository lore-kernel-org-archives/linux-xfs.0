Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2AC867CB4
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 09:55:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF3E28F804B
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 07:55:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DImwq1IA7V4Mao3M (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2016 07:55:30 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v19 00/23] Richacls (Core and Ext4)
Date: Mon, 14 Mar 2016 15:54:59 +0100
Message-Id: <1457967322-14886-1-git-send-email-agruenba@redhat.com>
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

Al,

could you please merge the current richacl patch queue, up to and including
the ext4 support?


Changes since the last posting (https://lwn.net/Articles/677901/):

 * richacl_from_xattr now takes an invalid_error parameter specifying
   the error code to return when an xattr is invallid.  This allows to
   better use this function when decoding an xattr stored on a filesystem
   as well as when decoding a user-provided xattr.

 * ext4_acl_chmod and xfs_acl_chmod have lost their mode parameter;
   they have aready been using inode->i_mode instead of the parameter.

 * Use __u8 instead of unsigned char in uapi headers.  Drop left-over
   MODULE_LICENSE declarations.  Use IS_ERR_OR_NULL instead of IS_ERR in
   ext4_init_richacl.

 * Rebased on top of v4.5.


The complete patch queue is available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
        richacl-2016-03-14


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

Andreas Gruenbacher (21):
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
 fs/ext4/richacl.c                               | 137 ++++++
 fs/ext4/richacl.h                               |  40 ++
 fs/ext4/super.c                                 |  49 +-
 fs/ext4/xattr.c                                 |   7 +
 fs/f2fs/acl.c                                   |   4 +-
 fs/inode.c                                      |  15 +-
 fs/jffs2/acl.c                                  |  10 +-
 fs/namei.c                                      | 118 ++++-
 fs/posix_acl.c                                  |  50 +-
 fs/richacl_base.c                               | 578 ++++++++++++++++++++++++
 fs/richacl_inode.c                              | 333 ++++++++++++++
 fs/richacl_xattr.c                              | 235 ++++++++++
 fs/xattr.c                                      |  29 +-
 include/linux/fs.h                              |  60 ++-
 include/linux/posix_acl.h                       |  13 +-
 include/linux/richacl.h                         | 208 +++++++++
 include/linux/richacl_xattr.h                   |  31 ++
 include/uapi/linux/Kbuild                       |   2 +
 include/uapi/linux/fs.h                         |   3 +-
 include/uapi/linux/richacl.h                    | 152 +++++++
 include/uapi/linux/richacl_xattr.h              |  44 ++
 include/uapi/linux/xattr.h                      |   2 +
 33 files changed, 2150 insertions(+), 107 deletions(-)
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
