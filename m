Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 29B887CA0
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2016 00:21:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 876FCAC001
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 22:21:07 -0700 (PDT)
Received: from mail-io0-f193.google.com (mail-io0-f193.google.com
	[209.85.223.193]) by cuda.sgi.com with ESMTP id
	VyWiWezYKOr9Zojn (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 22:21:00 -0700 (PDT)
Received: by mail-io0-f193.google.com with SMTP id 124so1274791iov.2
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 22:21:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458166743-18488-1-git-send-email-agruenba@redhat.com>
References: <1458166743-18488-1-git-send-email-agruenba@redhat.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 18 Mar 2016 00:20:40 -0500
Message-ID: <CAH2r5mu66qi=G6sMNQzS_Ciu9ctyS4Q+bKskVqk1Hj5_x7FWng@mail.gmail.com>
Subject: Re: [PATCH v20 00/23] Richacls (Core and Ext4)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

Reviewing the current version of your patch series in your tree
 git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
        richacl-2016-03-16

you can add my reviewed by to the following patches so far:
0001-vfs-Add-IS_ACL-and-IS_RICHACL-tests.patch
0002-vfs-Add-MAY_CREATE_FILE-and-MAY_CREATE_DIR-permissio.patch
0003-vfs-Add-MAY_DELETE_SELF-and-MAY_DELETE_CHILD-permiss.patch
0004-vfs-Make-the-inode-passed-to-inode_change_ok-non-con.patch
0005-vfs-Add-permission-flags-for-setting-file-attributes.patch
0011-posix_acl-Improve-xattr-fixup-code.patch
0013-vfs-Add-get_richacl-and-set_richacl-inode-operations.patch
0024-xfs-Make-xfs_set_mode-non-static.patch
0042-ext4-Don-t-allow-unmapped-identifiers-in-richacls.patch
0043-xfs-Don-t-allow-unmapped-identifiers-in-richacls.patch

Reviewed-by: Steve French <steve.french@primarydata.com>

On Wed, Mar 16, 2016 at 5:18 PM, Andreas Gruenbacher
<agruenba@redhat.com> wrote:
> Al,
>
> here is a minor update to the richacl patches with some feedback from Christoph
> incorporated.
>
> Changes since the last posting (https://lkml.org/lkml/2016/3/14/503):
>
>  * Merge richacl_base.c and richacl_inode.c into richacl.c.
>
>  * Add linux/acl.h header including function acl_chmod.
>    Use it in richacl enabled filesystems.
>
>
> The complete patch queue is available here:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux-richacl.git \
>         richacl-2016-03-16
>
>
> The richacl user-space utilitites, man pages, and test suite are available
> here:
>
>   https://github.com/andreas-gruenbacher/richacl
>
>
> Changes to other user-space packages for richacl:
>
>   https://github.com/andreas-gruenbacher/coreutils
>   https://github.com/andreas-gruenbacher/e2fsprogs
>   https://github.com/andreas-gruenbacher/samba
>   https://github.com/andreas-gruenbacher/xfsprogs-dev
>   https://github.com/andreas-gruenbacher/nfs-utils
>
>
> Please see the richacl homepage for more information:
>
>   http://www.bestbits.at/richacl/
>
>
> Thanks,
> Andreas
>
> Andreas Gruenbacher (21):
>   vfs: Add IS_ACL() and IS_RICHACL() tests
>   vfs: Add MAY_CREATE_FILE and MAY_CREATE_DIR permission flags
>   vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD permission flags
>   vfs: Make the inode passed to inode_change_ok non-const
>   vfs: Add permission flags for setting file attributes
>   richacl: In-memory representation and helper functions
>   richacl: Permission mapping functions
>   richacl: Compute maximum file masks from an acl
>   richacl: Permission check algorithm
>   posix_acl: Unexport acl_by_type and make it static
>   posix_acl: Improve xattr fixup code
>   vfs: Cache base_acl objects in inodes
>   vfs: Add get_richacl and set_richacl inode operations
>   vfs: Cache richacl in struct inode
>   richacl: Update the file masks in chmod()
>   richacl: Check if an acl is equivalent to a file mode
>   richacl: Create-time inheritance
>   richacl: Automatic Inheritance
>   richacl: xattr mapping functions
>   richacl: Add richacl xattr handler
>   vfs: Add richacl permission checking
>
> Aneesh Kumar K.V (2):
>   ext4: Add richacl support
>   ext4: Add richacl feature flag
>
>  drivers/staging/lustre/lustre/llite/llite_lib.c |   2 +-
>  fs/Kconfig                                      |   3 +
>  fs/Makefile                                     |   1 +
>  fs/attr.c                                       |  81 ++-
>  fs/ext4/Kconfig                                 |  11 +
>  fs/ext4/Makefile                                |   1 +
>  fs/ext4/ext4.h                                  |   6 +-
>  fs/ext4/file.c                                  |   3 +
>  fs/ext4/ialloc.c                                |  11 +-
>  fs/ext4/inode.c                                 |   5 +-
>  fs/ext4/namei.c                                 |   5 +
>  fs/ext4/richacl.c                               | 137 ++++
>  fs/ext4/richacl.h                               |  40 ++
>  fs/ext4/super.c                                 |  49 +-
>  fs/ext4/xattr.c                                 |   7 +
>  fs/f2fs/acl.c                                   |   4 +-
>  fs/inode.c                                      |  15 +-
>  fs/jffs2/acl.c                                  |  10 +-
>  fs/namei.c                                      | 118 +++-
>  fs/posix_acl.c                                  |  50 +-
>  fs/richacl.c                                    | 889 ++++++++++++++++++++++++
>  fs/richacl_xattr.c                              | 235 +++++++
>  fs/xattr.c                                      |  29 +-
>  include/linux/acl.h                             |  15 +
>  include/linux/fs.h                              |  60 +-
>  include/linux/posix_acl.h                       |  13 +-
>  include/linux/richacl.h                         | 205 ++++++
>  include/linux/richacl_xattr.h                   |  31 +
>  include/uapi/linux/Kbuild                       |   2 +
>  include/uapi/linux/fs.h                         |   3 +-
>  include/uapi/linux/richacl.h                    | 152 ++++
>  include/uapi/linux/richacl_xattr.h              |  44 ++
>  include/uapi/linux/xattr.h                      |   2 +
>  33 files changed, 2131 insertions(+), 108 deletions(-)
>  create mode 100644 fs/ext4/richacl.c
>  create mode 100644 fs/ext4/richacl.h
>  create mode 100644 fs/richacl.c
>  create mode 100644 fs/richacl_xattr.c
>  create mode 100644 include/linux/acl.h
>  create mode 100644 include/linux/richacl.h
>  create mode 100644 include/linux/richacl_xattr.h
>  create mode 100644 include/uapi/linux/richacl.h
>  create mode 100644 include/uapi/linux/richacl_xattr.h
>
> --
> 2.5.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
