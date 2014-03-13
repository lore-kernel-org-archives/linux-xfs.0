Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 75FF37F4E
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 00:27:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25E7DAC001
	for <xfs@oss.sgi.com>; Wed, 12 Mar 2014 22:27:39 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Zohs3Q1IdoKIaFSy for <xfs@oss.sgi.com>;
	Wed, 12 Mar 2014 22:27:37 -0700 (PDT)
Date: Thu, 13 Mar 2014 16:27:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to 3948694
Message-ID: <20140313052732.GG6851@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update. I know I skipped a couple of posted
tests because they hadn't obviously been reviewed and I didn't know
what the status of them was, so reposts (and reviews!) would be
appreciated.

The new head of the master branch is commit:

3948694 xfs/300: fix golden output

New Commits:

Dave Chinner (5):
      [763b46f] xfs/033: add golden output for CRC enabled filesystems
      [97a665b] xfs/189: noattr2 invalid for CRC enabled filesystems
      [84edd7a] generic/003: ensure time changes between stat calls
      [4a74700] xfs/217: prevent enospc failures on small test devices
      [b50473c] xfs/167: need at least 10GB of scratch space to run

Dmitry Monakhov (2):
      [3365817] fsstress: add verifiable logging mode
      [33e02a8] generic/280: use waidpid instead of ugly sleep

Eric Sandeen (2):
      [9642986] aio-dio: fix error msg in aio-dio-subblock-eof-read.c
      [3948694] xfs/300: fix golden output

Filipe David Borba Manana (2):
      [2dd0dbe] btrfs: add function _require_fssum()
      [5f1cd20] btrfs: add test for btrfs-progs restore feature

Jie Liu (1):
      [5f6be5c] shared/051: add filter to match the golden output for large acls

Lukas Czerner (8):
      [212f48f] common: Create single function for testing xfs_io commands
      [9589e15] common: create _test_block_boundaries in common/punch
      [613cb30] generic/008: Add test for fallocate zero range at block boundary
      [2dc43e0] build: Move fallocate include into global.h
      [2d2d853] fsstress: Add fallocate zero range operation
      [4544179] fsstress: translate flags in fiemap_f
      [f074613] fsx: Add fallocate zero range operation
      [4d46e47] ext4/001: Add ext4 specific test for fallocate zero range

Wang Shilong (1):
      [8acf172] btrfs: add basic functional test for btrfs quota groups

ZhangZhen (1):
      [f7f9492] btrfs: cleanup tests 004, 007, 022 and 025


Code Diffstat:

 check                                           |   2 +-
 common/attr                                     |  10 +
 common/filter                                   |   3 +
 common/punch                                    | 106 ++++++
 common/rc                                       |  78 +++--
 configure.ac                                    |   3 +-
 ltp/fsstress.c                                  | 222 ++++++++----
 ltp/fsx.c                                       | 146 +++++---
 src/aio-dio-regress/aio-dio-subblock-eof-read.c |   4 +-
 src/global.h                                    |  25 ++
 tests/btrfs/004                                 |   2 +-
 tests/btrfs/007                                 |  11 +-
 tests/btrfs/016                                 |   5 +-
 tests/btrfs/022                                 |  24 +-
 tests/btrfs/025                                 |  20 +-
 tests/btrfs/030                                 |   5 +-
 tests/btrfs/038                                 |   5 +-
 tests/btrfs/039                                 |   5 +-
 tests/btrfs/040                                 |   5 +-
 tests/btrfs/041                                 | 113 +++++++
 tests/btrfs/041.out                             |  40 +++
 tests/btrfs/042                                 |  95 ++++++
 tests/btrfs/042.out                             |   2 +
 tests/btrfs/group                               |   2 +
 tests/ext4/001                                  |  64 ++++
 tests/ext4/001.out                              | 337 ++++++++++++++++++
 tests/ext4/group                                |   1 +
 tests/generic/003                               | 110 +++---
 tests/generic/008                               |  57 ++++
 tests/generic/008.out                           | 433 ++++++++++++++++++++++++
 tests/generic/280                               |   3 +-
 tests/generic/group                             |   1 +
 tests/shared/051                                |  10 +-
 tests/shared/051.out                            |   2 +-
 tests/xfs/033                                   |  10 +-
 tests/xfs/033.crc.out.linux                     | 197 +++++++++++
 tests/xfs/167                                   |   6 +
 tests/xfs/189                                   |   2 +
 tests/xfs/217                                   |   4 +
 tests/xfs/290                                   |  40 +--
 tests/xfs/290.out                               |  13 +-
 tests/xfs/300.out                               |   2 +-
 42 files changed, 1930 insertions(+), 295 deletions(-)
 mode change 100644 => 100755 tests/btrfs/016
 create mode 100755 tests/btrfs/041
 create mode 100644 tests/btrfs/041.out
 create mode 100755 tests/btrfs/042
 create mode 100644 tests/btrfs/042.out
 create mode 100755 tests/ext4/001
 create mode 100644 tests/ext4/001.out
 create mode 100755 tests/generic/008
 create mode 100644 tests/generic/008.out
 create mode 100644 tests/xfs/033.crc.out.linux
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
