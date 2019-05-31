Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33894 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfEaQrL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 May 2019 12:47:11 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 0/9] Fixes for major copy_file_range() issues
Date: Fri, 31 May 2019 19:46:52 +0300
Message-Id: <20190531164701.15112-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org

Hi Darrick,

Following is a re-work of Dave Chinner's copy_file_range() patches.
This v4 patch set includes review tags and excludes the individual
filesystem fixes that are not related to cross-device copy.
Those patches will be sent to maintainers seperately once the
dependency patch is made available on a public branch.

I did include the FUSE patch in this posting since we got an ACK
from Miklos. You may take it or leave it.

Thanks,
Amir.

Changes since v3:
- Drop per filesystem patch for file_modified()/file_accessed()
- Fix wrong likely()
- Add Reviewed-by tags

Changes since v2:
- Re-order generic_remap_checks() fix patch before
  forking generic_copy_file_checks()
- Document @req_count helper argument (Darrick)
- Fold generic_access_check_limits() (Darrick)
- Added file_modified() helper (Darrick)
- Added xfs patch to use file_modified() helper
- Drop generic_copy_file_range_prep() helper
- Per filesystem patch for file_modified()/file_accessed()
- Post copy file_remove_privs() for ceph/generic (Darrick)

Changes since v1:
- Short read instead of EINVAL (Christoph)
- generic_file_rw_checks() helper (Darrick)
- generic_copy_file_range_prep() helper (Christoph)
- Not calling ->remap_file_range() with different sb
- Not calling ->copy_file_range() with different fs type
- Remove changes to overlayfs
- Extra fix to clone/dedupe checks

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

 fs/ceph/file.c     |  23 +++++++--
 fs/cifs/cifsfs.c   |   4 ++
 fs/fuse/file.c     |  29 +++++++++--
 fs/inode.c         |  20 +++++++
 fs/nfs/nfs4file.c  |  23 +++++++--
 fs/read_write.c    | 126 +++++++++++++++++++++++++--------------------
 fs/xfs/xfs_file.c  |  15 +-----
 include/linux/fs.h |   9 ++++
 mm/filemap.c       | 110 +++++++++++++++++++++++++++++++--------
 9 files changed, 259 insertions(+), 100 deletions(-)

-- 
2.17.1
