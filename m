Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47217 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753161AbdAaAvL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jan 2017 19:51:11 -0500
Date: Mon, 30 Jan 2017 16:48:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [ANNOUNCE] xfs-linux: xfs-4.11-merge updated to 1dbba08
Message-ID: <20170131004854.GE9134@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>

Hi folks,

The xfs-4.11-merge branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

** NOTE **
This branch is merely a rollup of the fixes I've collected so far for
4.11.  The merge window is probably still a ways away, but I thought I'd
get things started ahead of time.  If you've sent a patch and it hasn't
been reviewed, you still have time.  If you've sent a patch, had it
reviewed, and it still isn't in either 4.10 or this branch, please
resend it to the list.

** NOTE **
Also cc'ing the ext4 list because of the dax changes within.

The new head of the xfs-4.11-merge branch is commit:

1dbba08 xfs: remove unused full argument from bmap

New Commits:

Brian Foster (3):
      [a36b926] xfs: pull up iolock from xfs_free_eofblocks()
      [c315509] xfs: sync eofblocks scans under iolock are livelock prone
      [e4229d6] xfs: fix eofblocks race with file extending async dio writes

Christoph Hellwig (1):
      [8ff6daa] iomap: constify struct iomap_ops

Eric Sandeen (5):
      [f88ae46] xfs: glean crc status from mp not flags in xfs_btree_init_block_int
      [af7d20f] xfs: make xfs_btree_magic more generic
      [b6f41e4] xfs: remove boilerplate around xfs_btree_init_block
      [64f61ab] xfs: remove unused struct declarations
      [1dbba08] xfs: remove unused full argument from bmap


Code Diffstat:

 fs/dax.c                        |  6 ++---
 fs/ext2/ext2.h                  |  2 +-
 fs/ext2/inode.c                 |  4 +--
 fs/ext4/ext4.h                  |  2 +-
 fs/ext4/inode.c                 |  2 +-
 fs/internal.h                   |  2 +-
 fs/iomap.c                      | 18 ++++++-------
 fs/xfs/libxfs/xfs_bmap.c        | 19 +++----------
 fs/xfs/libxfs/xfs_bmap_btree.c  | 10 ++-----
 fs/xfs/libxfs/xfs_btree.c       | 45 ++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_btree.h       |  6 +++--
 fs/xfs/libxfs/xfs_log_recover.h |  1 -
 fs/xfs/xfs_bmap_util.c          | 48 ++++++++++++++-------------------
 fs/xfs/xfs_bmap_util.h          |  5 ++--
 fs/xfs/xfs_file.c               | 13 ++++++---
 fs/xfs/xfs_fsops.c              | 39 +++++++--------------------
 fs/xfs/xfs_icache.c             | 59 ++++++++++++-----------------------------
 fs/xfs/xfs_icache.h             |  2 --
 fs/xfs/xfs_inode.c              | 51 +++++++++++++++++++----------------
 fs/xfs/xfs_ioctl.c              |  4 +--
 fs/xfs/xfs_iomap.c              |  4 +--
 fs/xfs/xfs_iomap.h              |  4 +--
 fs/xfs/xfs_log.h                |  1 -
 fs/xfs/xfs_trace.h              |  1 -
 fs/xfs/xfs_trans.h              |  1 -
 include/linux/dax.h             |  8 +++---
 include/linux/iomap.h           | 14 +++++-----
 27 files changed, 162 insertions(+), 209 deletions(-)
