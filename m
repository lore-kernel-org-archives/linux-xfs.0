Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33997 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751731AbcIWIiq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2016 04:38:46 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 0/4] ovl: efficient copy up by reflink
Date: Fri, 23 Sep 2016 11:38:09 +0300
Message-Id: <1474619892-5113-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

This is the 4rd revision of implementing overlayfs
copy up by reflink.

Btrfs has file reflink support and XFS is about to gain
file reflink support soon. It is very useful to use reflink
to implement copy up of regular file data when possible.

For example, on my laptop, xfstest overlay/001 (copy up of 4G
sparse files) takes less than 1 second with copy up by reflink
vs. 25 seconds with regular copy up.

This series includes 3 patches:
- patches 1,2 are re-factoring patches to allow using the
  vfs_clone_file_range() helper from file system code.
- patch 3 utilizes the helper for overlay copy up

These changes passed the unionmount-testsuite (over tmpfs)
They passed the overlay/??? xfstests over the following underlying fs:
1. ext4 (copy up)
2. xfs + reflink patches + mkfs.xfs (copy up)
3. xfs + reflink patches + mkfs.xfs -m reflink=1 (reflink up)

Dave Chinner suggested the following implementation for copy up:
1. try to clone_file_range() entire length
2. fallback to trying copy_file_range() in small chunks
3. fallback to do_splice_direct() in small chunks

This is a good general implementation to cover the future use cases of
filesystems that can do either clone_file_range() or copy_file_range()
and for filesystems that may fail clone_file_range() and succeed
to copy_file_range().

However, currently, the only in-tree file systems that support
clone/copy_file_range are btrfs, xfs (soon), cifs and nfs.
btrfs and xfs use the same implementation for clone and copy range,
so copy_file_range() in small chunks is only useful in extreme
ENOSPC cases.
cifs supports only clone_file_range() so copy_file_range() step is moot.
nfs does have a different implementation for clone_file_range() and
copy_file_range(), but neither nfs nor cifs are supported as lower layer
for overlayfs.

For this posting, I decided to leave out the copy_file_range() patches
until a reliable use case to test them presents itself.

Miklos,

Please pick these patches to your tree for clear and immediate benefit to
copy up performance on filesystems with reflink support.

Thanks,
Amir.

V4:
- Fix recursive mnt_want_write()
- Leave out the vfs_copy_file_range() patches

V3:
- Address style comments from Dave Chinner

V2:
- Re-factor vfs helpers so they can be called from copy up
- Single call to vfs_clone_file_range() and fallback to
  vfs_copy_file_range() loop

V1:
- Replace iteravite call to copy_file_range() with
  a single call to clone_file_range()

V0:
- Call clone_file_range() and fallback to do_splice_direct()


Amir Goldstein (3):
  vfs: allow vfs_clone_file_range() across mount points
  vfs: call vfs_clone_file_range() under mnt_want_write()
  ovl: use vfs_clone_file_range() for copy up if possible

 fs/ioctl.c             | 11 +++++++++++
 fs/overlayfs/copy_up.c |  8 ++++++++
 fs/read_write.c        | 13 ++++++-------
 3 files changed, 25 insertions(+), 7 deletions(-)

-- 
2.7.4

