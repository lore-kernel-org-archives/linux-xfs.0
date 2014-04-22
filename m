Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 671117F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 02:03:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56E2E304032
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 00:02:57 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bHEM0ySjadAb1aSO for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 00:02:55 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WcUiu-000844-Ea
	for xfs@oss.sgi.com; Tue, 22 Apr 2014 17:02:32 +1000
Date: Tue, 22 Apr 2014 17:02:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to 6f55bbd
Message-ID: <20140422070232.GE15995@dastard>
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

Hi Folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

The new head of the master branch is commit:

6f55bbd xfs/167: need at least 10GB of scratch space to run

New Commits:

Dave Chinner (1):
      [6f55bbd] xfs/167: need at least 10GB of scratch space to run

Eric Sandeen (2):
      [c365b11] fsx: introduce FSX_AVOID env var
      [de876b9] xfs: test X_QUOTARM functionality

Eric Whitney (3):
      [b90e14f] common: add helper for zero range support check
      [9c04c84] ext4/001: fix check for zero range support
      [fbd6c52] generic/009: fix check for zero range support

Eryu Guan (1):
      [7f783df] common: set _fs_has_crcs=0 as default in _filter_mkfs()

Filipe David Borba Manana (4):
      [f81be18] btrfs: punch holes and prealloc extents with send
      [57e801d] btrfs: add test for btrfs properties
      [73d9443] btrfs/004: fix filefrag filter for files with 1 block only
      [6fcbf58] btrfs/004: fix failure with inlined file extents

Konstantin Khlebnikov (1):
      [35ee392] generic/285: fix test for generic SEEK_HOLE/DATA implementations

Lukas Czerner (1):
      [9631a1f] common: Remove unused functions

Namjae Jeon (1):
      [d37388c] fsstress: remove duplicate COLLAPSE_RANGE flags


Code Diffstat:

 README                 |   5 ++
 common/config          |   4 +
 common/filter          |   1 +
 common/rc              | 103 ++++-------------------
 ltp/fsstress.c         |   1 -
 src/seek_sanity_test.c |   5 +-
 tests/btrfs/004        |  36 +++++---
 tests/btrfs/047        | 122 +++++++++++++++++++++++++++
 tests/btrfs/047.out    |  35 ++++++++
 tests/btrfs/048        | 220 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/048.out    |  78 ++++++++++++++++++
 tests/btrfs/group      |   2 +
 tests/ext4/001         |   2 +-
 tests/generic/009      |   2 +-
 tests/generic/075      |   2 +-
 tests/generic/091      |   2 +-
 tests/generic/112      |   2 +-
 tests/generic/127      |   8 +-
 tests/generic/231      |   2 +-
 tests/generic/263      |   2 +-
 tests/xfs/007          |  79 ++++++++++++++++++
 tests/xfs/007.out      |  10 +++
 tests/xfs/167          |   6 ++
 tests/xfs/group        |   1 +
 24 files changed, 617 insertions(+), 113 deletions(-)
 create mode 100755 tests/btrfs/047
 create mode 100644 tests/btrfs/047.out
 create mode 100755 tests/btrfs/048
 create mode 100644 tests/btrfs/048.out
 create mode 100755 tests/xfs/007
 create mode 100644 tests/xfs/007.out
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
