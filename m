Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44116 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752522AbdHDVgq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Aug 2017 17:36:46 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id A76BE61253B
        for <linux-xfs@vger.kernel.org>; Fri,  4 Aug 2017 16:35:51 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 3540b41
Message-ID: <9b8a1f5d-216c-05cb-e3c5-39f7aa5858ad@sandeen.net>
Date: Fri, 4 Aug 2017 16:36:45 -0500
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

3540b41 xfs_db: btdump should avoid eval for push and pop of cursor

New Commits:

Brian Foster (1):
      [2c6c632] libxfs: init ->b_maps on contig buffers for uncached compatibili

Carlos Maiolino (1):
      [b4056fe] xfs_io: Print filesystem statfs flags in 'statfs' command

Darrick J. Wong (8):
      [14f8b68] xfsprogs: remove double-underscore integer types
      [5a707ca] xfs_repair: fix symlink target length checks by changing MAXPATH
      [449df23] xfs_db: fix metadump redirection (again)
      [a05feed] xfs_db: dump dir/attr btrees
      [29b90b5] xfs_db: print attribute remote value blocks
      [89baf91] xfs_db: write values into dir/attr blocks and recalculate CRCs
      [984af2e] xfs_db: introduce fuzz command
      [3540b41] xfs_db: btdump should avoid eval for push and pop of cursor

Eric Sandeen (3):
      [61a1556] xfs_db: associate proper type with free inode btree root
      [e66eae0] xfs_metadump: properly handle obfuscation of all remote attribut
      [1e9c13c] xfs_db: use TYP_F_CRC_FUNC for inodes & dquots

Ross Zwisler (1):
      [e13a325] xfs_io: allow lsattr & lsproj on foreign filesystems

Code Diffstat:

 copy/xfs_copy.c           |  14 +-
 copy/xfs_copy.h           |   2 +-
 db/Makefile               |   3 +-
 db/agi.c                  |   2 +-
 db/attr.c                 | 103 ++++++++++-
 db/attr.h                 |   2 +
 db/attrshort.c            |   4 +-
 db/bit.c                  |  21 +--
 db/bit.h                  |   7 +-
 db/block.c                |   8 +-
 db/btdump.c               | 275 ++++++++++++++++++++++++---
 db/check.c                |  18 +-
 db/command.c              |   2 +
 db/convert.c              |  28 +--
 db/dir2.c                 |  37 ++++
 db/dir2.h                 |   1 +
 db/dquot.c                |  11 ++
 db/dquot.h                |   1 +
 db/faddr.c                |  14 +-
 db/field.c                |  47 ++---
 db/field.h                |   1 +
 db/fprint.c               |   8 +-
 db/frag.c                 |   8 +-
 db/fuzz.c                 | 460 ++++++++++++++++++++++++++++++++++++++++++++++
 db/fuzz.h                 |  21 +++
 db/inode.c                |  45 +++--
 db/inode.h                |   1 +
 db/io.c                   |  59 ++----
 db/io.h                   |   9 +-
 db/metadump.c             |  61 ++++--
 db/sb.c                   |   6 +-
 db/type.c                 |  60 ++++--
 db/type.h                 |   3 +
 db/write.c                |  13 +-
 fsr/xfs_fsr.c             |   2 +-
 include/darwin.h          |  18 +-
 include/freebsd.h         |   6 +-
 include/gnukfreebsd.h     |   6 +-
 include/libxcmd.h         |   6 +-
 include/linux.h           |   8 +-
 include/xfs_arch.h        |  22 +--
 include/xfs_inode.h       |   4 +-
 include/xfs_log_recover.h |   2 +-
 include/xfs_metadump.h    |   4 +-
 include/xfs_mount.h       |  22 +--
 io/attr.c                 |   2 +-
 io/open.c                 |   2 +-
 io/stat.c                 |   1 +
 libhandle/handle.c        |   2 +-
 libhandle/jdm.c           |   2 +-
 libxcmd/topology.c        |  14 +-
 libxfs/darwin.c           |   2 +-
 libxfs/freebsd.c          |   2 +-
 libxfs/init.c             |   2 +-
 libxfs/irix.c             |   2 +-
 libxfs/libxfs_io.h        |   1 +
 libxfs/libxfs_priv.h      |   4 +-
 libxfs/linux.c            |   2 +-
 libxfs/logitem.c          |   2 +-
 libxfs/radix-tree.c       |   8 +-
 libxfs/rdwr.c             |  16 +-
 libxfs/util.c             |   8 +-
 logprint/log_misc.c       |   6 +-
 man/man8/xfs_db.8         |  88 ++++++++-
 mdrestore/xfs_mdrestore.c |   2 +-
 mkfs/proto.c              |   2 +-
 mkfs/xfs_mkfs.c           |  76 ++++----
 quota/edit.c              |  64 +++----
 quota/free.c              |  44 ++---
 quota/quot.c              |  24 +--
 quota/quota.c             |   4 +-
 quota/quota.h             |  12 +-
 quota/report.c            |   4 +-
 quota/state.c             |   2 +-
 quota/util.c              |  66 +++----
 repair/README             |   2 +-
 repair/agheader.h         |  14 +-
 repair/attr_repair.h      |  26 +--
 repair/avl64.c            |  38 ++--
 repair/avl64.h            |  18 +-
 repair/dinode.c           |  44 ++---
 repair/dinode.h           |   4 +-
 repair/dir2.c             |   2 +-
 repair/globals.h          |  18 +-
 repair/incore.c           |  10 +-
 repair/incore.h           |  46 ++---
 repair/incore_ext.c       |   6 +-
 repair/incore_ino.c       |  72 ++++----
 repair/phase2.c           |   2 +-
 repair/phase3.c           |   6 +-
 repair/phase4.c           |   4 +-
 repair/phase5.c           |  28 +--
 repair/phase6.c           |  16 +-
 repair/phase7.c           |   6 +-
 repair/progress.c         |  30 +--
 repair/progress.h         |   4 +-
 repair/rmap.c             |  18 +-
 repair/rmap.h             |   2 +-
 repair/sb.c               |  24 +--
 repair/scan.c             |  50 ++---
 repair/scan.h             |  12 +-
 repair/xfs_repair.c       |   2 +-
 102 files changed, 1715 insertions(+), 710 deletions(-)
 create mode 100644 db/fuzz.c
 create mode 100644 db/fuzz.h
