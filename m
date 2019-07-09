Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfGIQj5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 12:39:57 -0400
Date: Tue, 9 Jul 2019 09:39:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [GIT PULL] vfs: fix copy_file_range bad behavior
Message-ID: <20190709163947.GE5164@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>

Hi Linus,

Please pull this series to fix numerous parameter checking problems and
inconsistent behaviors in the new(ish) copy_file_range system call.  Now
the system call will actually check its range parameters correctly;
refuse to copy into files for which the caller does not have sufficient
privileges; update mtime and strip setuid like file writes are supposed
to do; and allows copying up to the EOF of the source file instead of
failing the call like we used to.

The branch merges cleanly against this morning's HEAD and survived an
overnight run of xfstests.  The merge was completely straightforward, so
please let me know if you run into anything weird.

--D

The following changes since commit d1fdb6d8f6a4109a4263176c84b899076a5f8008:

  Linux 5.2-rc4 (2019-06-08 20:24:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/copy-file-range-fixes-1

for you to fetch changes up to fe0da9c09b2dc448ff781d1426ecb36d145ce51b:

  fuse: copy_file_range needs to strip setuid bits and update timestamps (2019-06-09 10:07:07 -0700)

----------------------------------------------------------------
Changes to copy_file_range for 5.3 from Dave and Amir:
- Create a generic copy_file_range handler and make individual
  filesystems responsible for calling it (i.e. no more assuming that
  do_splice_direct will work or is appropriate)
- Refactor copy_file_range and remap_range parameter checking where they
  are the same
- Install missing copy_file_range parameter checking(!)
- Remove suid/sgid and update mtime like any other file write
- Change the behavior so that a copy range crossing the source file's
  eof will result in a short copy to the source file's eof instead of
  EINVAL
- Permit filesystems to decide if they want to handle cross-superblock
  copy_file_range in their local handlers.

----------------------------------------------------------------
Amir Goldstein (7):
      vfs: introduce generic_file_rw_checks()
      vfs: remove redundant checks from generic_remap_checks()
      vfs: add missing checks to copy_file_range
      vfs: introduce file_modified() helper
      xfs: use file_modified() helper
      vfs: allow copy_file_range to copy across devices
      fuse: copy_file_range needs to strip setuid bits and update timestamps

Dave Chinner (2):
      vfs: introduce generic_copy_file_range()
      vfs: no fallback for ->copy_file_range

 fs/ceph/file.c     |  23 ++++++++--
 fs/cifs/cifsfs.c   |   4 ++
 fs/fuse/file.c     |  29 +++++++++++--
 fs/inode.c         |  20 +++++++++
 fs/nfs/nfs4file.c  |  23 ++++++++--
 fs/read_write.c    | 124 +++++++++++++++++++++++++++++------------------------
 fs/xfs/xfs_file.c  |  15 +------
 include/linux/fs.h |   9 ++++
 mm/filemap.c       | 110 ++++++++++++++++++++++++++++++++++++++---------
 9 files changed, 257 insertions(+), 100 deletions(-)
