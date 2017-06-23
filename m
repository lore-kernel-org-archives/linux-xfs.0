Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751183AbdFWNet (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Jun 2017 09:34:49 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 0/6] SEEK_HOLE / SEEK_DATA via iomap
Date: Fri, 23 Jun 2017 15:34:38 +0200
Message-Id: <1498224884-346-1-git-send-email-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, cluster-devel@redhat.com, Jan Kara <jack@suse.cz>

These patches, on top of the page_cache_seek_hole_data patches posted earlier
today, convert xfs to implement SEEK_HOLE / SEEK_DATA via iomap, and implement
SEEK_HOLE / SEEK_DATA via iomap in gfs2.

ext4 doesn't implement IOMAP_REPORT, so it can't be switched to use the iomap
based SEEK_HOLE / SEEK_DATA or fiemap code so far.

Thanks,
Andreas

Andreas Gruenbacher (3):
  vfs: Add iomap_seek_hole_data helper
  xfs: Switch to iomap for SEEK_HOLE / SEEK_DATA
  gfs2: Implement SEEK_HOLE / SEEK_DATA via iomap

Bob Peterson (3):
  GFS2: Make height info part of metapath
  GFS2: Implement iomap for block_map
  GFS2: Switch fiemap implementation to use iomap

 fs/gfs2/Kconfig       |   1 +
 fs/gfs2/bmap.c        | 288 ++++++++++++++++++++++++++++++++++++--------------
 fs/gfs2/bmap.h        |   4 +
 fs/gfs2/file.c        |  14 ++-
 fs/gfs2/inode.c       |  57 ++++++++--
 fs/gfs2/inode.h       |   1 +
 fs/gfs2/trace_gfs2.h  |  65 ++++++++++++
 fs/iomap.c            |  89 ++++++++++++++++
 fs/xfs/xfs_file.c     |  21 +---
 include/linux/iomap.h |   6 +-
 10 files changed, 437 insertions(+), 109 deletions(-)

-- 
2.7.5

