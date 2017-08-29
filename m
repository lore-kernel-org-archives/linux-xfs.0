Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754336AbdH2O3q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Aug 2017 10:29:46 -0400
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 0/4] ext4: SEEK_HOLE / SEEK_DATA via iomap
Date: Tue, 29 Aug 2017 16:29:38 +0200
Message-Id: <20170829142942.21594-1-agruenba@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>

Add IOMAP_REPORT support to ext4, including support for inline data
which iomap couldn't report so far.  Switch to iomap_seek_{hole,data} on
ext4.

This patch set seems to be working correctly on ext4 as well as xfs
under xfstests.  Jan Kara has pointed out an issue that I can't
reproduce though, so please review carefully.

Thanks,
Andreas

Andreas Gruenbacher (3):
  iomap: Switch from blkno to disk offset
  iomap: Add IOMAP_F_DATA_INLINE flag
  ext4: Add iomap support for inline data

Christoph Hellwig (1):
  ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA

 fs/buffer.c           |   4 +-
 fs/dax.c              |   2 +-
 fs/ext2/inode.c       |   4 +-
 fs/ext4/Kconfig       |   1 +
 fs/ext4/ext4.h        |   7 +-
 fs/ext4/file.c        | 271 +++-----------------------------------------------
 fs/ext4/inline.c      |  33 ++++++
 fs/ext4/inode.c       | 114 +++++++--------------
 fs/iomap.c            |  13 +--
 fs/nfsd/blocklayout.c |   4 +-
 fs/xfs/xfs_iomap.c    |   6 +-
 include/linux/iomap.h |  15 +--
 12 files changed, 115 insertions(+), 359 deletions(-)

-- 
2.13.3

