Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55952 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968220AbeEYUfP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 May 2018 16:35:15 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 2066A4872EB
        for <linux-xfs@vger.kernel.org>; Fri, 25 May 2018 15:34:58 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to fc52865
Message-ID: <f10b59d7-ea39-d980-db6a-4d63c256b41a@sandeen.net>
Date: Fri, 25 May 2018 15:35:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

** This also rebased the tree **

(Sorry, I accidentally pushed from a guilt branch for a merge and
wanted to clean that up)

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

fc52865 xfs_io: Allow -P and -L to be given to open for O_PATH and  O_NOFOLLOW

New Commits:

Darrick J. Wong (21):
       [dee7606] xfs: don't fail when converting shortform attr to long form duri
       [930af86] xfs_repair: examine all remote attribute blocks
       [41b465f] xfs_repair: don't leak buffer on xattr remote buf verifier  erro
       [eb9cee6] xfs_repair: validate some of the log space information
       [d2be29d] xfs_repair: zap corrupt remote symlink
       [67a79e2] xfs_repair: treat zero da btree pointers as corruption
       [f9c559f] xfs_repair: invalidate dirty dir buffers when we zap a  director
       [bf67850] xfs_repair: only update in-core extent state after scanning full
       [3cc93dd] xfs_repair: don't crash if da btree is corrupt
       [7554707] xfs_repair: actually fix .. entries that point to inode zero
       [8fec4f7] xfs_repair: check inode nsec for obviously garbage values
       [369c0b5] xfs_repair: don't assert on bad '.' entry in no-modify mode
       [fe08f67] libfrog: move platform specific runtime support code out of libx
       [96aaf9b] libfrog: refactor fs geometry printing function
       [ebc2e79] mkfs: use geometry generation / helper functions
       [172793e] xfs_db: add a superblock info command
       [6fb7087] xfs_spaceman: print a nicer message when file path isn't on xfs
       [6719d62] xfs_spaceman: add a superblock info command
       [3fda24e] xfs_info: move to xfs_spaceman
       [6750f2b] xfs_info: call xfs_db for offline filesystems
       [35f7c5b] xfs_growfs: refactor geometry reporting

David Howells (1):
       [fc52865] xfs_io: Allow -P and -L to be given to open for O_PATH and  O_NO

Eric Sandeen (6):
       [3060f26] xfs: enhance dinode verifier
       [7c4d311] xfs: set format back to extents if xfs_bmap_extents_to_btree
       [73b28e5] Merge branch 'libxfs-4.17-sync' into for-next
       [98c4a01] xfsprogs: be careful about what we stat in platform_check_mount
       [5857dce] xfs_repair: check and repair quota metadata
       [cfa10b0] xfs_io: add label command

Jeff Layton (1):
       [7c4889e] xfs_io: syncfs can fail


Code Diffstat:

  db/Makefile                      |   2 +-
  db/command.c                     |   1 +
  db/command.h                     |   1 +
  db/info.c                        |  74 ++++++++++++++
  growfs/Makefile                  |   2 -
  growfs/xfs_growfs.c              |  88 +---------------
  include/fsgeom.h                 |  24 +++++
  io/Makefile                      |   6 +-
  io/file.c                        |   6 +-
  io/init.c                        |   9 +-
  io/io.h                          |   3 +
  io/label.c                       | 108 ++++++++++++++++++++
  io/open.c                        |  41 +++++++-
  io/sync.c                        |   6 +-
  libfrog/Makefile                 |   5 +
  {libxfs => libfrog}/darwin.c     |   0
  {libxfs => libfrog}/freebsd.c    |   0
  libfrog/fsgeom.c                 |  82 +++++++++++++++
  {libxfs => libfrog}/irix.c       |   0
  {libxfs => libfrog}/linux.c      |  10 ++
  libxfs/Makefile                  |   3 -
  libxfs/libxfs_api_defs.h         |   3 +
  libxfs/libxfs_priv.h             |   2 -
  libxfs/xfs_attr.c                |   9 +-
  libxfs/xfs_bmap.c                |   4 +
  libxfs/xfs_inode_buf.c           |  21 ++++
  libxfs/xfs_quota_defs.h          |   2 +
  man/man8/xfs_db.8                |   8 ++
  man/man8/xfs_growfs.8            |  47 +--------
  man/man8/xfs_info.8              |  97 ++++++++++++++++++
  man/man8/xfs_io.8                |  25 ++++-
  man/man8/xfs_spaceman.8          |   7 ++
  mkfs/xfs_mkfs.c                  |  54 +++-------
  repair/attr_repair.c             |   7 +-
  repair/da_util.c                 |   8 ++
  repair/dinode.c                  | 216 +++++++++++++++++++++++++++++++++++++--
  repair/dir2.c                    |  23 ++++-
  repair/globals.h                 |   3 +-
  repair/incore.h                  |   3 +
  repair/phase6.c                  |  49 ++++++++-
  repair/sb.c                      |  27 +++++
  repair/xfs_repair.c              |   2 +
  spaceman/Makefile                |   4 +-
  spaceman/file.c                  |   7 +-
  spaceman/info.c                  |  96 +++++++++++++++++
  spaceman/init.c                  |   6 +-
  spaceman/space.h                 |   1 +
  {growfs => spaceman}/xfs_info.sh |  14 ++-
  48 files changed, 1004 insertions(+), 212 deletions(-)
  create mode 100644 db/info.c
  create mode 100644 include/fsgeom.h
  create mode 100644 io/label.c
  rename {libxfs => libfrog}/darwin.c (100%)
  rename {libxfs => libfrog}/freebsd.c (100%)
  create mode 100644 libfrog/fsgeom.c
  rename {libxfs => libfrog}/irix.c (100%)
  rename {libxfs => libfrog}/linux.c (93%)
  create mode 100644 man/man8/xfs_info.8
  create mode 100644 spaceman/info.c
  rename {growfs => spaceman}/xfs_info.sh (55%)
