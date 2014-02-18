Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 84DF77FFC
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 15:31:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7FCA98F804C
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 13:31:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XedhEI5t83inXi4k for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 13:31:17 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1WFsG1-00014U-50
	for xfs@oss.sgi.com; Wed, 19 Feb 2014 08:31:13 +1100
Date: Wed, 19 Feb 2014 08:31:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to db6d20e
Message-ID: <20140218213113.GH13647@dastard>
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
outstanding patches were in this update. If they have not been
included in this update, please resubmit them to xfs@oss.sgi.com so
they can be picked up in the next update.

The new head of the master branch is commit:

db6d20e generic: test for atime-related mount options

New Commits:

Dave Chinner (2):
      [47dbcf1] xfs/299: users can't modify root owned files
      [0fde595] xfs/021: filter v5 filesystem metadata

David Disseldorp (3):
      [db5addd] btrfs: add small program for clone testing
      [678fd16] src/cloner: use btrfs/ioctl.h header if present
      [2965c15] btrfs: add new clone overwrite regression test

Eric Sandeen (2):
      [3698f09] xfs: check that junk in V4 superblocks doesn't break growfs
      [0ab3beb] xfs: ensure bad primary sb crc fails mount

Filipe David Borba Manana (5):
      [fc3e4e6] btrfs: add test for data corruption when using compression
      [4eb876c] btrfs: add regression test for incremental send
      [32dba77] btrfs: add test for incremental send after dir renames
      [56c94f4] btrfs: add test for send issuing duplicated rmdir ops
      [0535565] btrfs: cleanup tests btrfs/030 and btrfs/034

Koen De Wit (1):
      [db6d20e] generic: test for atime-related mount options

Mark Tinguely (1):
      [b985883] xfs: test setting XFS BMBT fields in xfs_db

Wang Shilong (3):
      [8564bb8] btrfs: add a regression test for running snapshot and send concurrently
      [617252f] btrfs/004: fix to make test really work
      [8350a0b] btrfs/005: log test result to right path


Code Diffstat:

 .gitignore            |    1 +
 common/rc             |   13 +
 configure.ac          |    1 +
 src/Makefile          |    2 +-
 src/cloner.c          |  192 +++++
 tests/btrfs/004       |   16 +-
 tests/btrfs/005       |   13 +-
 tests/btrfs/030       |   14 +-
 tests/btrfs/034       |   28 +-
 tests/btrfs/034.out   | 1880 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/035       |   77 ++
 tests/btrfs/035.out   |    3 +
 tests/btrfs/036       |   85 +++
 tests/btrfs/036.out   |    2 +
 tests/btrfs/037       |  111 +++
 tests/btrfs/037.out   |    3 +
 tests/btrfs/038       |  119 ++++
 tests/btrfs/038.out   |    9 +
 tests/btrfs/039       |  131 ++++
 tests/btrfs/039.out   |    1 +
 tests/btrfs/040       |  124 ++++
 tests/btrfs/040.out   |    1 +
 tests/btrfs/group     |    6 +
 tests/generic/003     |  199 ++++++
 tests/generic/003.out |    2 +
 tests/generic/group   |    1 +
 tests/xfs/001         |   98 +++
 tests/xfs/001.out     |  150 ++++
 tests/xfs/002         |   75 ++
 tests/xfs/002.out     |    1 +
 tests/xfs/005         |   66 ++
 tests/xfs/005.out     |    4 +
 tests/xfs/021         |    9 +
 tests/xfs/299         |    6 +
 tests/xfs/299.out     |   96 ++-
 tests/xfs/group       |    3 +
 36 files changed, 3455 insertions(+), 87 deletions(-)
 create mode 100644 src/cloner.c
 create mode 100755 tests/btrfs/035
 create mode 100644 tests/btrfs/035.out
 create mode 100755 tests/btrfs/036
 create mode 100644 tests/btrfs/036.out
 create mode 100755 tests/btrfs/037
 create mode 100644 tests/btrfs/037.out
 create mode 100755 tests/btrfs/038
 create mode 100644 tests/btrfs/038.out
 create mode 100755 tests/btrfs/039
 create mode 100644 tests/btrfs/039.out
 create mode 100755 tests/btrfs/040
 create mode 100644 tests/btrfs/040.out
 create mode 100755 tests/generic/003
 create mode 100644 tests/generic/003.out
 create mode 100755 tests/xfs/001
 create mode 100644 tests/xfs/001.out
 create mode 100755 tests/xfs/002
 create mode 100644 tests/xfs/002.out
 create mode 100755 tests/xfs/005
 create mode 100644 tests/xfs/005.out
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
