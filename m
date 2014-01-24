Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C0D6D7FC5
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 20:59:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 854EB304048
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 18:59:19 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	kJsNq8x07jxHmKQ6 for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 18:59:17 -0800 (PST)
Date: Fri, 24 Jan 2014 13:58:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfstests updated to 197f773
Message-ID: <20140124025846.GL27606@dastard>
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

The new head of the master branch is commit:

197f773 xfstests: define $seqres in btrfs/026-029

New Commits:

Dave Chinner (7):
      [ea0b6eb] xfs: test scratch device mkfs features
      [b9b5d74] xfs: New _require_* tests for CRC enabled filesystems
      [86e91cc] xfs: add fsstress/recovery test
      [5b524ee] xfs/073, 208: remove .full output before starting the test
      [b04b0fd] xfs: support xfs_metadump with external logs
      [3ed573e] xfs/104: use fixed log size
      [7657a10] generic/204: use fixed log size for XFS

David Sterba (3):
      [80622a6] xfstests: don't suggest to run full diff when DIFF_LENGTH is 0
      [586a06c] xfstests: use value of FSTYP if defined externally
      [1ed9046] xfstests: clean command names in btrfs tests

Eric Sandeen (1):
      [a93b1dd] ext4: regression test for ext4 resize with non-extent files

Filipe David Borba Manana (1):
      [8c427eb] xfstests: add test for btrfs incremental send infinite loop issue

Koen De Wit (2):
      [0c58766] xfstests: btrfs: cross-subvolume sparse copy
      [197f773] xfstests: define $seqres in btrfs/026-029


Code Diffstat:

 README              |   3 ++
 check               |  13 ++---
 common/attr         |   6 +++
 common/rc           | 122 +++++++++++++++++++++++++++---------------
 tests/btrfs/003     |   2 +-
 tests/btrfs/004     |   2 +-
 tests/btrfs/007     |   4 +-
 tests/btrfs/008     |  12 ++---
 tests/btrfs/009     |   6 +--
 tests/btrfs/013     |   2 +-
 tests/btrfs/014     |   6 +--
 tests/btrfs/015     |   2 +-
 tests/btrfs/016     |  14 ++---
 tests/btrfs/017     |   2 +-
 tests/btrfs/019     |  14 ++---
 tests/btrfs/022     |   6 +--
 tests/btrfs/024     |   2 +-
 tests/btrfs/025     |   4 +-
 tests/btrfs/026     |   1 +
 tests/btrfs/027     |   1 +
 tests/btrfs/028     |   1 +
 tests/btrfs/029     |   1 +
 tests/btrfs/030     | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/030.out |   1 +
 tests/btrfs/031     | 138 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/031.out |  48 +++++++++++++++++
 tests/btrfs/group   |   2 +
 tests/ext4/306      |  82 +++++++++++++++++++++++++++++
 tests/ext4/306.out  |  13 +++++
 tests/ext4/group    |   1 +
 tests/generic/204   |   4 ++
 tests/generic/208   |   2 +
 tests/shared/298    |   2 +-
 tests/xfs/073       |   2 +
 tests/xfs/104       |   2 +-
 tests/xfs/186       |   1 +
 tests/xfs/187       |  32 ++++++-----
 tests/xfs/244       |   1 +
 tests/xfs/253       |   3 +-
 tests/xfs/278       |   1 +
 tests/xfs/287       |   3 +-
 tests/xfs/291       |   4 +-
 tests/xfs/306       | 105 ++++++++++++++++++++++++++++++++++++
 tests/xfs/306.out   |   2 +
 tests/xfs/group     |   1 +
 45 files changed, 716 insertions(+), 109 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
