Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43484 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750848AbeCICj4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Mar 2018 21:39:56 -0500
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8104217DD3
        for <linux-xfs@vger.kernel.org>; Thu,  8 Mar 2018 20:38:47 -0600 (CST)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 12ac6e0
Message-ID: <9cd6be9a-a1c5-f620-54e6-e82d0940e1de@sandeen.net>
Date: Thu, 8 Mar 2018 20:39:55 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

12ac6e0 xfs_repair: don't fail directory repairs when grabbing inodes

New Commits:

Brian Foster (1):
      [57e7138] xfs_io: support a basic extent swap command

Darrick J. Wong (10):
      [1b0adc7] misc: enable retpolines across all xfsprogs utilities
      [e61f155] misc: enable link time optimization, if requested
      [a93fcc0] misc: fix gcc 7.3 warnings
      [de24d64] xfs_db: don't crash in ablock if there's no inode
      [7c30915] xfs_scrub: log operational messages when interactive
      [c767c5a] xfs_scrub: don't ask user to run xfs_repair for only warnings
      [a440f87] xfs_scrub: fix #include ordering to avoid build failure
      [e24ee6b] xfs_scrub: don't try to scan xattrs if bstat says there aren't a
      [ad9ac92] xfs_db: print transaction reservation type information
      [12ac6e0] xfs_repair: don't fail directory repairs when grabbing inodes

Dave Chinner (1):
      [d976382] xfs_io: add RWF_DSYNC support to pwrite

Eric Sandeen (6):
      [fc9f709] libxfs: Replace XFS_BUF_SET_PTR with xfs_buf_associate_memory
      [864028e] libxfs: add function to free all buffers in bcache
      [bf0e024] libxfs: move xfs_inode_zone to rdwr.c
      [4448849] libxfs: Catch non-empty zones on destroy
      [2ce8bff] xfsprogs: call libxfs_destroy from other utilities
      [f50eb2c] xfsprogs: new libxfs-apply option for Signed-off-by: tag

Goldwyn Rodrigues (1):
      [99d6e84] xfs_io: Add missing perror for write_once (-O)

Luis R. Rodriguez (1):
      [9d50331] xfs_scrub: make interpreter explicit to python3

Xiao Yang (1):
      [a2e8105] xfs_repair: Add missing braces to allow zeroing of corrupt log


Code Diffstat:

 configure.ac              |  13 ++++++
 copy/xfs_copy.c           |   1 +
 db/attrset.c              |   6 ++-
 db/bit.c                  |   4 +-
 db/block.c                |   5 +++
 db/command.c              |   1 +
 db/init.c                 |   2 +
 db/logformat.c            |  59 +++++++++++++++++++++++++
 db/logformat.h            |   1 +
 debian/rules              |   4 +-
 include/builddefs.in      |  16 +++++++
 include/kmem.h            |   1 +
 include/xfs_inode.h       |   6 ++-
 io/Makefile               |   4 +-
 io/init.c                 |   1 +
 io/io.h                   |   1 +
 io/pwrite.c               |  12 ++++--
 io/swapext.c              | 107 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/init.c             |  42 +++++++++++-------
 libxfs/kmem.c             |  14 ++++++
 libxfs/libxfs_api_defs.h  |   2 +-
 libxfs/libxfs_io.h        |  13 ++++--
 libxfs/rdwr.c             |  45 +++++++++++++++----
 libxfs/trans.c            |   6 ++-
 libxfs/util.c             |   2 +-
 libxlog/xfs_log_recover.c |   4 +-
 m4/package_libcdev.m4     |  48 +++++++++++++++++++++
 man/man8/xfs_db.8         |   6 +++
 man/man8/xfs_io.8         |  15 ++++++-
 mkfs/xfs_mkfs.c           |   1 +
 repair/dinode.c           |   1 +
 repair/phase2.c           |   3 +-
 repair/phase6.c           |  16 ++++---
 repair/scan.c             |   1 +
 repair/xfs_repair.c       |   1 +
 scrub/bitmap.c            |   5 +--
 scrub/common.c            |  54 +++++++++++++++++++++--
 scrub/common.h            |  10 +++++
 scrub/counter.c           |   2 +-
 scrub/disk.c              |   9 +---
 scrub/filemap.c           |   6 +--
 scrub/fscounters.c        |   5 +--
 scrub/inodes.c            |   4 +-
 scrub/phase1.c            |  13 ++----
 scrub/phase2.c            |   5 +--
 scrub/phase3.c            |   5 +--
 scrub/phase4.c            |   6 +--
 scrub/phase5.c            |  14 +++---
 scrub/phase6.c            |   5 +--
 scrub/phase7.c            |   5 +--
 scrub/progress.c          |   4 +-
 scrub/read_verify.c       |   5 +--
 scrub/scrub.c             |   6 +--
 scrub/spacemap.c          |   5 +--
 scrub/unicrash.c          |   5 +--
 scrub/vfs.c               |   4 +-
 scrub/xfs_scrub.c         |  30 ++++++++-----
 scrub/xfs_scrub.h         |   3 +-
 scrub/xfs_scrub_all.in    |   2 +-
 tools/libxfs-apply        |  17 +++++++-
 60 files changed, 535 insertions(+), 158 deletions(-)
 create mode 100644 io/swapext.c
