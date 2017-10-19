Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:57187 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdJSELv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 00:11:51 -0400
Received: by mail-yw0-f196.google.com with SMTP id l32so2442229ywh.13
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 21:11:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
References: <1508367333-3237-1-git-send-email-allison.henderson@oracle.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Oct 2017 07:11:50 +0300
Message-ID: <CAOQ4uxhzZT=5O6PM4Gp=uSwYPFdrO5X9D8UF54f3jEmM2LxK1Q@mail.gmail.com>
Subject: Re: [PATCH 00/17] Parent Pointers V3
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Oct 19, 2017 at 1:55 AM, Allison Henderson
<allison.henderson@oracle.com> wrote:
> Hi all,
>
> This is the third version of parent pointer attributes for xfs.
> I've integrated the suggestions made since v2, mostly moving the
> attr buffers in the xfs_attr_log_item to pointers that point to
> xfs_attr_item. I've also implementing the recovery routines for
> the xfs_attr_log_format.  If I missed anything please point it
> out.  As always, comments and feedback are appreciated.  Thank
> you!
>

A minor comment about the cover letter.
All designated reviewers must know exactly what "parent pointers" are for,
but it could be useful to add some context in the cover letter about the purpose
of this work for the sake of other readers on the list. Useful to refer to the
upcoming scrub support patches.

BTW, not sure if this was mentioned in the previous lifetime of those
patches, but parent pointers can be used to implement exportfs operation
xfs_fs_fh_to_parent() for "non-connectable" file handles (FILEID_INO32_GEN)
and to implement xfs_fs_get_name(), which would make reconnect_path()
*much* more efficient.

Also, you may want to use git format-patch -v3 for V3
makes it easier to browse old versions of patches on the list.

Cheers,
Amir.

> Allison Henderson (7):
>   Add helper functions xfs_attr_set_args and xfs_attr_remove_args
>   Set up infastructure for deferred attribute operations
>   Add xfs_attr_set_defered and xfs_attr_remove_defered
>   Remove all strlen calls in all xfs_attr_* functions for attr names.
>   Add the extra space requirements for parent pointer attributes when
>     calculating the minimum log size during mkfs
>   Add parent pointers to rename
>   Add the parent pointer support to the superblock version 5.
>
> Brian Foster (1):
>   xfs_bmap_add_attrfork(): re-add error handling from set_attrforkoff()
>     call
>
> Dave Chinner (5):
>   xfs: define parent pointer xattr format
>   :xfs: extent transaction reservations for parent attributes
>   xfs: parent pointer attribute creation
>   xfs: add parent attributes to link
>   xfs: remove parent pointers in unlink
>
> Mark Tinguely (4):
>   xfs: get directory offset when adding directory name
>   xfs: get directory offset when removing directory name
>   xfs: get directory offset when replacing a directory name
>   xfs: add parent pointer support to attribute code
>
>  fs/xfs/Makefile                |   3 +
>  fs/xfs/libxfs/xfs_attr.c       | 476 +++++++++++++++++++++++++++-----------
>  fs/xfs/libxfs/xfs_bmap.c       |  51 ++--
>  fs/xfs/libxfs/xfs_bmap.h       |   1 +
>  fs/xfs/libxfs/xfs_da_btree.h   |   1 +
>  fs/xfs/libxfs/xfs_da_format.h  |  12 +-
>  fs/xfs/libxfs/xfs_defer.h      |   1 +
>  fs/xfs/libxfs/xfs_dir2.c       |  41 ++--
>  fs/xfs/libxfs/xfs_dir2.h       |  10 +-
>  fs/xfs/libxfs/xfs_dir2_block.c |   9 +-
>  fs/xfs/libxfs/xfs_dir2_leaf.c  |   8 +-
>  fs/xfs/libxfs/xfs_dir2_node.c  |   8 +-
>  fs/xfs/libxfs/xfs_dir2_sf.c    |   6 +
>  fs/xfs/libxfs/xfs_format.h     |  37 ++-
>  fs/xfs/libxfs/xfs_fs.h         |   1 +
>  fs/xfs/libxfs/xfs_log_format.h |  36 ++-
>  fs/xfs/libxfs/xfs_log_rlimit.c |  34 +++
>  fs/xfs/libxfs/xfs_parent.c     | 163 +++++++++++++
>  fs/xfs/libxfs/xfs_trans_resv.c | 103 +++++++--
>  fs/xfs/libxfs/xfs_types.h      |   1 +
>  fs/xfs/xfs_acl.c               |  12 +-
>  fs/xfs/xfs_attr.h              |  68 +++++-
>  fs/xfs/xfs_attr_item.c         | 512 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_attr_item.h         | 111 +++++++++
>  fs/xfs/xfs_fsops.c             |   4 +-
>  fs/xfs/xfs_inode.c             | 146 +++++++++---
>  fs/xfs/xfs_ioctl.c             |  13 +-
>  fs/xfs/xfs_iops.c              |   6 +-
>  fs/xfs/xfs_log_recover.c       | 140 +++++++++++
>  fs/xfs/xfs_qm.c                |   2 +-
>  fs/xfs/xfs_qm.h                |   1 +
>  fs/xfs/xfs_super.c             |   1 +
>  fs/xfs/xfs_symlink.c           |   2 +-
>  fs/xfs/xfs_trans.h             |  13 ++
>  fs/xfs/xfs_trans_attr.c        | 286 +++++++++++++++++++++++
>  fs/xfs/xfs_xattr.c             |  10 +-
>  36 files changed, 2064 insertions(+), 265 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_parent.c
>  create mode 100644 fs/xfs/xfs_attr_item.c
>  create mode 100644 fs/xfs/xfs_attr_item.h
>  create mode 100644 fs/xfs/xfs_trans_attr.c
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
