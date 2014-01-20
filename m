Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3FD637F51
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 23:45:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 369F98F8037
	for <xfs@oss.sgi.com>; Sun, 19 Jan 2014 21:45:45 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Fq7CSDaFtxnqazka for <xfs@oss.sgi.com>;
	Sun, 19 Jan 2014 21:45:40 -0800 (PST)
Date: Mon, 20 Jan 2014 16:45:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests updated to 3099791
Message-ID: <20140120054533.GA13997@dastard>
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

Hi all,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

Note that I didn't pull in the tmpfs support patch series this time
around as I'm not sure the discussions ever came to a conclusion
before xmas/new year/LCA intervened. That will need to be picked up
again...

The new head of the master branch is commit:

3099791 btrfs: sparse copy between different filesystems/mountpoints

New Commits:

Anand Jain (2):
      [83adc23] btrfs/006: fails with mixed-mode/small disks
      [7cb5299] btrfs/001: filter subvol delete output

David Sterba (3):
      [9ced657] Makefile: fix minor build warning
      [d7e5b7f] check: accept tests/ prefix for test name on commandline
      [a050cb0] lsqa.pl: update for new tests layout

Eric Sandeen (2):
      [94d3f77] xfs/049, 073: use MKFS_XFS_PROG where appropriate
      [6571cea] xfstests: allow override of XFS_IOC_DIOINFO

Filipe David Borba Manana (1):
      [74643fc] btrfs: test send issue with non-aligned clone operations

Jeff Mahoney (1):
      [99b3a9a] aio-stress: use calloc for thread_info array

Jie Liu (4):
      [2086933] common: introduce two pre-checkup routines for xfs crc specified testing
      [cc92a95] xfs: refactor xfs/299 for crc feature pre-checkup
      [b42851e] xfs: verify turn group/project quotas off while user quotas is on
      [9645d9a] xfs: disable group/project quotas along with fsstress

Koen De Wit (4):
      [c8d9f19] btrfs: simple sparse copy testcase for btrfs
      [890bc11] btrfs: sparse copy of a directory tree on btrfs
      [9b48c97] btrfs: moving and deleting sparse copies on btrfs
      [3099791] btrfs: sparse copy between different filesystems/mountpoints

Lukas Czerner (3):
      [a056ab7] common: Filter out lost+found directory from _ls_l() output
      [1a98c8b] generic/322: use _filter_scratch()
      [3128e9c] generic/321, 322: do not remove lost+found

Miao Xie (1):
      [5aafebc] common: Enhance the scratch dev pool and deletable device check

Wang Shilong (1):
      [d1d43f6] btrfs/022: fix failed case with qgroup limit test


Code Diffstat:

 Makefile              |   3 +-
 check                 |   3 +-
 common/filter         |   6 +++
 common/filter.btrfs   |  11 +++++
 common/rc             |  63 ++++++++++++++++++++++++-----
 lsqa.pl               |  32 +++++++++++----
 ltp/aio-stress.c      |   4 +-
 ltp/doio.c            |  12 ++++++
 ltp/fsstress.c        |  12 ++++++
 ltp/iogen.c           |  10 +++++
 src/unwritten_sync.c  |   5 +++
 tests/btrfs/001       |   3 +-
 tests/btrfs/003       |   2 +-
 tests/btrfs/011       |   2 +-
 tests/btrfs/022       |  20 ++++++++--
 tests/btrfs/025       |  98 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/025.out   |  18 +++++++++
 tests/btrfs/026       |  90 +++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/026.out   |  16 ++++++++
 tests/btrfs/027       | 107 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/027.out   |  25 ++++++++++++
 tests/btrfs/028       |  81 +++++++++++++++++++++++++++++++++++++
 tests/btrfs/028.out   |   7 ++++
 tests/btrfs/029       | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/029.out   |  15 +++++++
 tests/btrfs/group     |   5 +++
 tests/generic/321     |   2 +-
 tests/generic/322     |  10 ++---
 tests/generic/322.out |   8 ++--
 tests/xfs/049         |   2 +-
 tests/xfs/073         |   2 +-
 tests/xfs/299         |  14 ++-----
 tests/xfs/299.out     |   1 -
 tests/xfs/304         |  86 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/304.out     |   7 ++++
 tests/xfs/305         |  89 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/305.out     |   7 ++++
 tests/xfs/group       |   2 +
 38 files changed, 937 insertions(+), 51 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
