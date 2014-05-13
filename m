Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6CF207F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 01:30:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D956AAC003
	for <xfs@oss.sgi.com>; Mon, 12 May 2014 23:30:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GoKr0qAee8e6Hx4w for <xfs@oss.sgi.com>;
	Mon, 12 May 2014 23:30:21 -0700 (PDT)
Date: Tue, 13 May 2014 16:30:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests: master branch updated to 10fd79a
Message-ID: <20140513063018.GB5421@dastard>
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
picked up in the next update.

The new head of the master branch is commit:

10fd79a locktest: add a F_GETLK vs. openmode test

New Commits:

Brian Foster (5):
      [2a52b8f] xfs/030: filter out extra repair noise for finobt enabled fs'
      [9d5cb63] common: add _require_xfs_[mkfs_]finobt() checks for finobt tests
      [01fbf44] repair: filter agno/ino repair output for finobt
      [d95ecb0] xfs/010: test repair for finobt corruption
      [c141570] xfs/013: stress the free inode btree

Eryu Guan (1):
      [ec08236] common: new function to get real device path name and basename

Jeff Layton (4):
      [2baab36] locktest: don't assume that F_OPEN should use O_RDWR
      [ece564a] locktest: set f_fd to INVALID_HANDLE on close
      [fe7056d] locktest: consolidate do_lock and do_unlock, and add ability to F_GETLK
      [10fd79a] locktest: add a F_GETLK vs. openmode test

Josef Bacik (2):
      [0fd4705] common: fix flink check
      [b6689ad] config: fix selinux context handling

Namjae Jeon (1):
      [995a459] fsstress: fix incorrect if condition check for collapse range mode

Theodore Ts'o (1):
      [9f35155] check: add support for an external file containing tests to exclude

Wang Shilong (1):
      [49398f8] btrfs: add regression test for inode cache vs tree log

hch@infradead.org (1):
      [7f82a5f] common: use a relative path to fsstress


Code Diffstat:

 check               |   6 ++
 common/config       |  18 +++---
 common/rc           |  36 ++++++++++++
 common/repair       |   2 +
 ltp/fsstress.c      |   2 +-
 src/locktest.c      | 125 +++++++++++++++++++-----------------------
 tests/btrfs/049     | 109 ++++++++++++++++++++++++++++++++++++
 tests/btrfs/049.out |   1 +
 tests/btrfs/group   |   1 +
 tests/ext4/305      |   2 +-
 tests/generic/009   |   2 +-
 tests/generic/019   |   4 +-
 tests/generic/285   |   2 +-
 tests/generic/312   |   2 +-
 tests/xfs/010       | 133 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/010.out   |  57 +++++++++++++++++++
 tests/xfs/013       | 155 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/013.out   |   7 +++
 tests/xfs/030       |   3 +-
 tests/xfs/group     |   2 +
 20 files changed, 582 insertions(+), 87 deletions(-)
 create mode 100644 tests/btrfs/049
 create mode 100644 tests/btrfs/049.out
 create mode 100755 tests/xfs/010
 create mode 100644 tests/xfs/010.out
 create mode 100755 tests/xfs/013
 create mode 100644 tests/xfs/013.out
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
