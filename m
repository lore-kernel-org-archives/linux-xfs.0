Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58680 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdF1QFO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jun 2017 12:05:14 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 94B13614048
        for <linux-xfs@vger.kernel.org>; Wed, 28 Jun 2017 11:05:03 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to f77f990
Message-ID: <68d7164d-fe53-2485-348c-c65f49fc99fd@sandeen.net>
Date: Wed, 28 Jun 2017 11:05:13 -0500
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

The main thing in here is the new spaceman tool; it also includes
the tweaks to metadump re: dirty log, a change to xfs_info/growfs
to require an actual mountpoint, a new xfs_db option to show
only aligned freespace, a new polish tranlation, and more - see
commit list below for info.

Thanks to everyone who is actively contributing to xfsprogs!

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

f77f990 xfs_spaceman: add group summary mode

New Commits:

Bill O'Donnell (1):
      [b97815a] xfs_growfs: ensure target path is an active xfs mountpoint

Christoph Hellwig (1):
      [e195146] mkfs: remove leftover blkid include

Darrick J. Wong (8):
      [fb2bfcd] xfs_io: refactor numlen into a library function
      [7f36f37] libxcmd: add cvt{int, long} to convert strings to int and long
      [5a4d6a2] libxfs: use crc32c slice-by-8 variant by default
      [71956d7] xfs: introduce the XFS_IOC_GETFSMAP ioctl
      [3fcab54] xfs_io: support the new getfsmap ioctl
      [197c2c6] xfs_repair: replace rmap_compare with libxfs version
      [e627898] xfs_spaceman: add a man page
      [f77f990] xfs_spaceman: add group summary mode

Dave Chinner (4):
      [48ec290] xfs_spaceman: space management tool
      [c6e8a42] xfs_spaceman: add FITRIM support
      [c98132d] xfs_spaceman: add new speculative prealloc control
      [cccf6ab] xfs_spaceman: Free space mapping command

Eric Sandeen (2):
      [732f8f5] xfs_db: add alignment filter to freesp command
      [2291c68] xfs_metadump: tag metadump image with informational flags

Jakub Bogusz (1):
      [d14c3ad] po/pl.po: update Polish translation for 4.11.0

Jan Tulak (1):
      [3b3751a] metadump: warn about corruption if log is dirty

Zirong Lang (1):
      [28a0a30] xfs_repair: handle reading superblock from image on larger secto


Code Diffstat:

 Makefile                  |    3 +-
 configure.ac              |    1 +
 db/freesp.c               |   11 +-
 db/metadump.c             |   26 +-
 growfs/xfs_growfs.c       |   10 +-
 include/builddefs.in      |    4 +
 include/input.h           |    9 +
 include/linux.h           |  103 +
 include/path.h            |    1 +
 include/xfs_metadump.h    |    8 +-
 io/Makefile               |    7 +
 io/bmap.c                 |   19 +-
 io/copy_file_range.c      |    2 +-
 io/encrypt.c              |    1 +
 io/fiemap.c               |   14 +-
 io/fsmap.c                |  589 +++
 io/init.c                 |    8 +-
 io/io.h                   |   14 +-
 io/open.c                 |   21 +-
 io/pwrite.c               |    2 +-
 io/reflink.c              |    4 +-
 io/sendfile.c             |    2 +-
 libxcmd/input.c           |  165 +
 libxcmd/paths.c           |   31 +
 libxfs/Makefile           |    4 +-
 libxfs/crc32defs.h        |   34 +
 libxfs/libxfs_api_defs.h  |    1 +
 m4/package_libcdev.m4     |   20 +
 man/man8/xfs_db.8         |    7 +-
 man/man8/xfs_io.8         |   99 +
 man/man8/xfs_mdrestore.8  |   12 +-
 man/man8/xfs_spaceman.8   |  179 +
 mdrestore/xfs_mdrestore.c |   40 +-
 mkfs/xfs_mkfs.c           |    3 -
 po/pl.po                  | 8733 ++++++++++++++++++++++++++++-----------------
 repair/rmap.c             |   32 +-
 repair/xfs_repair.c       |   96 +-
 spaceman/Makefile         |   40 +
 spaceman/file.c           |  137 +
 spaceman/freesp.c         |  413 +++
 spaceman/init.c           |  119 +
 spaceman/init.h           |   24 +
 spaceman/prealloc.c       |  119 +
 spaceman/space.h          |   46 +
 spaceman/trim.c           |  132 +
 45 files changed, 7887 insertions(+), 3458 deletions(-)
 create mode 100644 io/fsmap.c
 create mode 100644 man/man8/xfs_spaceman.8
 create mode 100644 spaceman/Makefile
 create mode 100644 spaceman/file.c
 create mode 100644 spaceman/freesp.c
 create mode 100644 spaceman/init.c
 create mode 100644 spaceman/init.h
 create mode 100644 spaceman/prealloc.c
 create mode 100644 spaceman/space.h
 create mode 100644 spaceman/trim.c
