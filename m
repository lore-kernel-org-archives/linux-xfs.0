Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47594 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbfGDPGW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jul 2019 11:06:22 -0400
Date: Thu, 4 Jul 2019 08:06:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE RESEND] xfs-linux: copy-file-range-fixes updated to
 fe0da9c09b2d
Message-ID: <20190704150617.GC5164@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>

Hi folks,

The copy-file-range-fixes branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has (not) been updated.  This is a resend of an earlier announcement
about the copy file range cleanups that I plan to merge for 5.3.

The new head of the copy-file-range-fixes branch is commit:

fe0da9c09b2d fuse: copy_file_range needs to strip setuid bits and update timestamps

New Commits:

Amir Goldstein (7):
      [a31713517dac] vfs: introduce generic_file_rw_checks()
      [646955cd5425] vfs: remove redundant checks from generic_remap_checks()
      [96e6e8f4a68d] vfs: add missing checks to copy_file_range
      [e38f7f53c352] vfs: introduce file_modified() helper
      [8c3f406c097b] xfs: use file_modified() helper
      [5dae222a5ff0] vfs: allow copy_file_range to copy across devices
      [fe0da9c09b2d] fuse: copy_file_range needs to strip setuid bits and update timestamps

Dave Chinner (2):
      [f16acc9d9b37] vfs: introduce generic_copy_file_range()
      [64bf5ff58dff] vfs: no fallback for ->copy_file_range


Code Diffstat:

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
