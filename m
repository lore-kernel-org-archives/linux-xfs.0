Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35205 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761890AbcINMn6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Sep 2016 08:43:58 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/4] ovl: efficient copy up by reflink
Date: Wed, 14 Sep 2016 15:43:10 +0300
Message-Id: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel@vger.kernel.org

This is the 3rd revision of implementing overlayfs
copy up by reflink.

Btrfs has file reflink support and XFS is about to gain
file reflink support soon. It is very useful to use reflink
to implement copy up of regular file data when possible.

For example, on my laptop, xfstest overlay/001 (copy up of 4G
sparse files) takes less than 1 second with copy up by reflink
vs. 25 seconds with regular copy up.

This series includes two pairs of patches:
- patches 1,2 utilize the clone_file_range() API
- patches 3,4 utilize the copy_file_range() API

The two pairs of patches are independent of each other.
They were each tested separately and both tested together.
All combinations passed the unionmount-testsuite (over tmpfs)
All combinations passed the overlay/??? xfstests over the
following underlying fs:
1. ext4 (copy up)
2. xfs + reflink patches + mkfs.xfs (copy up)
3. xfs + reflink patches + mkfs.xfs -m reflink=1 (reflink up)

Dave Chinner suggested the following implementation for copy up,
which I implemented in this series:
1. try to clone_file_range() entire length
2. fallback to trying copy_file_range() in small chunks
3. fallback to do_splice_direct() in small chunks

This is a good general implementation to cover the future use cases of
file systems that can do either clone_file_range() or copy_file_range().
However, currently, the only in-tree file systems that support
clone/copy_file_range are btrfs, xfs (soon), cifs and nfs.
btrfs and xfs use the same implementation for clone and copy range,
so the copy_file_range() step is never needed.
cifs supports only clone_file_range() so copy_file_range() step is moot.
nfs does have a different implementation for clone_file_range() and
copy_file_range(), but nfs is not supported as upper layer for overlayfs
at the moment.

Please pick patches 1,2 for clear and immediate benefit to copy up
performance on filesystems with reflink support.

Please consider picking patches 3,4 additionally for future generations
and for code consolidation into vfs helpers.

Cheers,
Amir.

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

Amir Goldstein (4):
  vfs: allow vfs_clone_file_range() across mount points
  ovl: use vfs_clone_file_range() for copy up if possible
  vfs: allow vfs_copy_file_range() across file systems
  ovl: use vfs_copy_file_range() to copy up file data

 fs/ioctl.c             |  2 ++
 fs/overlayfs/copy_up.c | 22 ++++++++++++++++------
 fs/read_write.c        | 25 ++++++++++++++++++-------
 3 files changed, 36 insertions(+), 13 deletions(-)

-- 
2.7.4

