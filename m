Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40164 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751980AbdFPOva (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 10:51:30 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 0/7] lseek SEEK_HOLE / SEEK_DATA via iomap
Date: Fri, 16 Jun 2017 16:51:13 +0200
Message-Id: <1497624680-16685-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Bob Peterson <rpeterso@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com

Here's an updated patch queue that implements iomap in gfs2 and switches gfs2
fiemap over to use iomap.  Following that is lseek SEEK_HOLE and SEEK_DATA
support for gfs2 and xfs.  Finally, xfs's internal use of lseek SEEK_HOLE /
SEEK_DATA is converted to iomap.

With the approach taken by this patch queue, filesystems that support iomap
still need to implement fiemap and lseek SEEK_HOLE / SEEK_DATA separately.
Those implementations will all be identical except for the filesystem specific
locking / unlocking code at the beginning / end of the operations.

Wouldn't it make sense to add iomap_lock and iomap_unlock operations, expose
the iomap ops at the vfs layer, and implement fiemap and lseek SEEK_HOLE /
SEEK_DATA generically in a next step?

Thanks,
Andreas


Andreas Gruenbacher (4):
  vfs: Add iomap_seek_hole_data helper
  gfs2: Implement lseek SEEK_HOLE / SEEK_DATA via iomap
  xfs: Switch to iomap for lseek SEEK_HOLE / SEEK_DATA
  xfs: Switch to iomap for seeking in quota files

Bob Peterson (3):
  GFS2: Make height info part of metapath
  GFS2: Implement iomap for block_map
  GFS2: Switch fiemap implementation to use iomap

 fs/gfs2/Kconfig       |   1 +
 fs/gfs2/bmap.c        | 288 ++++++++++++++++++++++++++++++------------
 fs/gfs2/bmap.h        |   4 +
 fs/gfs2/file.c        |  14 ++-
 fs/gfs2/inode.c       |  54 ++++++--
 fs/gfs2/inode.h       |   1 +
 fs/gfs2/trace_gfs2.h  |  65 ++++++++++
 fs/iomap.c            |  81 ++++++++++++
 fs/xfs/xfs_dquot.c    |   5 +-
 fs/xfs/xfs_file.c     | 337 +-------------------------------------------------
 fs/xfs/xfs_inode.h    |   2 -
 include/linux/iomap.h |   9 +-
 12 files changed, 429 insertions(+), 432 deletions(-)

-- 
2.7.5

