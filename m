Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:40294 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751362AbeA2M0j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 07:26:39 -0500
Received: by mail-qk0-f195.google.com with SMTP id d18so5226276qke.7
        for <linux-xfs@vger.kernel.org>; Mon, 29 Jan 2018 04:26:38 -0800 (PST)
Message-ID: <1517228795.5965.24.camel@redhat.com>
Subject: [GIT PULL] inode->i_version rework for v4.16
From: Jeff Layton <jlayton@redhat.com>
Date: Mon, 29 Jan 2018 07:26:35 -0500
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: open list <linux-kernel@vger.kernel.org>, "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, xfs <linux-xfs@vger.kernel.org>, "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

The following changes since commit 50c4c4e268a2d7a3e58ebb698ac74da0de40ae36:

  Linux 4.15-rc3 (2017-12-10 17:56:26 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git tags/iversion-v4.16-1

for you to fetch changes up to f02a9ad1f15daf4378afeda025a53455f72645dd:

  fs: handle inode->i_version more efficiently (2018-01-29 06:42:21 -0500)

----------------------------------------------------------------
Hi Linus,

This pile of patches is a rework of the inode->i_version field. We have
traditionally incremented that field on every inode data or metadata
change. Typically this increment needs to be logged on disk even when
nothing else has changed, which is rather expensive.

It turns out though that none of the consumers of that field actually
require this behavior. The only real requirement for all of them is that
it be different iff the inode has changed since the last time the field
was checked.

Given that, we can optimize away most of the i_version increments and
avoid dirtying inode metadata when the only change is to the i_version 
and no one is querying it. Queries of the i_version field are rather
rare, so we can help write performance under many common workloads.

This patch series converts existing accesses of the i_version field to a
new API, and then converts all of the in-kernel filesystems to use it.
The last patch in the series then converts the backend implementation to
a scheme that optimizes away a large portion of the metadata updates
when no one is looking at it.

In my own testing this series significantly helps performance with small
I/O sizes. I also got this email for Christmas this year from the kernel
test robot (a 244% r/w bandwidth improvement with XFS over DAX, with 4k
writes):

    https://lkml.org/lkml/2017/12/25/8

A few of the earlier patches in this pile are also flowing to you via
other trees (mm, integrity, and nfsd trees in particular), so there may
be some minor merge conflicts here. Hopefully they're trivial to
resolve, but let me know if there are problems.

Thanks!
----------------------------------------------------------------
Jeff Layton (21):
      lustre: don't set f_version in ll_readdir
      ntfs: remove i_version handling
      fs: new API for handling inode->i_version
      fs: don't take the i_lock in inode_inc_iversion
      fat: convert to new i_version API
      affs: convert to new i_version API
      afs: convert to new i_version API
      btrfs: convert to new i_version API
      exofs: switch to new i_version API
      ext2: convert to new i_version API
      ext4: convert to new i_version API
      nfs: convert to new i_version API
      nfsd: convert to new i_version API
      ocfs2: convert to new i_version API
      ufs: use new i_version API
      xfs: convert to new i_version API
      IMA: switch IMA over to new i_version API
      fs: only set S_VERSION when updating times if necessary
      xfs: avoid setting XFS_ILOG_CORE if i_version doesn't need incrementing
      btrfs: only dirty the inode in btrfs_update_time if something was changed
      fs: handle inode->i_version more efficiently

Sascha Hauer (1):
      ima: Use i_version only when filesystem supports it

 drivers/staging/lustre/lustre/llite/dir.c |   3 -
 fs/affs/amigaffs.c                        |   5 +-
 fs/affs/dir.c                             |   5 +-
 fs/affs/super.c                           |   3 +-
 fs/afs/fsclient.c                         |   3 +-
 fs/afs/inode.c                            |   5 +-
 fs/btrfs/delayed-inode.c                  |   7 +-
 fs/btrfs/file.c                           |   1 +
 fs/btrfs/inode.c                          |  12 +-
 fs/btrfs/ioctl.c                          |   1 +
 fs/btrfs/tree-log.c                       |   4 +-
 fs/btrfs/xattr.c                          |   1 +
 fs/exofs/dir.c                            |   9 +-
 fs/exofs/super.c                          |   3 +-
 fs/ext2/dir.c                             |   9 +-
 fs/ext2/super.c                           |   5 +-
 fs/ext4/dir.c                             |   9 +-
 fs/ext4/inline.c                          |   7 +-
 fs/ext4/inode.c                           |  13 +-
 fs/ext4/ioctl.c                           |   3 +-
 fs/ext4/namei.c                           |   5 +-
 fs/ext4/super.c                           |   3 +-
 fs/ext4/xattr.c                           |   5 +-
 fs/fat/dir.c                              |   3 +-
 fs/fat/inode.c                            |   9 +-
 fs/fat/namei_msdos.c                      |   7 +-
 fs/fat/namei_vfat.c                       |  22 +-
 fs/inode.c                                |  11 +-
 fs/nfs/delegation.c                       |   3 +-
 fs/nfs/fscache-index.c                    |   5 +-
 fs/nfs/inode.c                            |  18 +-
 fs/nfs/nfs4proc.c                         |  10 +-
 fs/nfs/nfstrace.h                         |   5 +-
 fs/nfs/write.c                            |   8 +-
 fs/nfsd/nfsfh.h                           |   3 +-
 fs/ntfs/inode.c                           |   9 -
 fs/ntfs/mft.c                             |   6 -
 fs/ocfs2/dir.c                            |  15 +-
 fs/ocfs2/inode.c                          |   3 +-
 fs/ocfs2/namei.c                          |   3 +-
 fs/ocfs2/quota_global.c                   |   3 +-
 fs/ufs/dir.c                              |   9 +-
 fs/ufs/inode.c                            |   3 +-
 fs/ufs/super.c                            |   3 +-
 fs/xfs/libxfs/xfs_inode_buf.c             |   7 +-
 fs/xfs/xfs_icache.c                       |   5 +-
 fs/xfs/xfs_inode.c                        |   3 +-
 fs/xfs/xfs_inode_item.c                   |   3 +-
 fs/xfs/xfs_trans_inode.c                  |  16 +-
 include/linux/fs.h                        |  17 +-
 include/linux/iversion.h                  | 341 ++++++++++++++++++++++++++++++
 security/integrity/ima/ima_api.c          |   3 +-
 security/integrity/ima/ima_main.c         |   4 +-
 53 files changed, 525 insertions(+), 153 deletions(-)
 create mode 100644 include/linux/iversion.h
-- 
Jeff Layton <jlayton@redhat.com>
