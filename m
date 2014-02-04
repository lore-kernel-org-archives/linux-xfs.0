Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1DD5F7F51
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 22:15:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 074F98F804C
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 20:15:32 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	p9ld1ONCrUzxLBTE for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 20:15:31 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1WAXPv-0000h6-3S
	for xfs@oss.sgi.com; Tue, 04 Feb 2014 15:15:23 +1100
Date: Tue, 4 Feb 2014 15:15:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: updated to 4356e45
Message-ID: <20140204041523.GZ13997@dastard>
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

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

The new head of the master branch is commit:

4356e45 generic: inconsistent initial state for test_generic_punch

New Commits:

Dave Chinner (4):
      [586d190] xfs/199: enforce v4 superblock format for test
      [180adeb] xfs/291: fix spurious ENOSPC errors
      [9c5d298] generic: _test_generic_punch not blocksize clean
      [4356e45] generic: inconsistent initial state for test_generic_punch

Filipe David Borba Manana (1):
      [1a258e9] xfstests: add test for btrfs incremental send data corruption


Code Diffstat:

 common/punch          |  19 +++++++---
 tests/btrfs/034       | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/034.out   |   6 +++
 tests/btrfs/group     |   1 +
 tests/generic/255.out |  36 +++++++++++++-----
 tests/generic/316.out |  36 +++++++++++++-----
 tests/xfs/199         |   5 ++-
 tests/xfs/242.out     |   7 +++-
 tests/xfs/252.out     |  36 +++++++++++++-----
 tests/xfs/291         |   9 +++--
 10 files changed, 215 insertions(+), 41 deletions(-)
 create mode 100755 tests/btrfs/034
 create mode 100644 tests/btrfs/034.out
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
