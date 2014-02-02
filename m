Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B5D9B7FA4
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 17:50:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 91752304051
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:50:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	y8h0sM2BpvQUFYSn for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 15:49:56 -0800 (PST)
Date: Mon, 3 Feb 2014 10:49:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUCE] xfstests: updated to ad969ca
Message-ID: <20140202234952.GO13997@dastard>
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

ad969ca btrfs/030: add more test cases

New Commits:

Brian Foster (2):
      [20641b8] xfs: remove spurious line continuation from _require_xfs_crc
      [710281f] generic/313: initialise TEST_DIR before use

Eric Whitney (1):
      [138ea5c] ext4/306: avoid failures caused by incompatible mount options

Filipe David Borba Manana (2):
      [fd7a8e8] btrfs/025: make test more robust
      [ad969ca] btrfs/030: add more test cases

Josef Bacik (2):
      [78d86b9] btrfs/029: filter mkfs and cp output
      [8ebabf7] generic/299: truncate can fail with ENOSPC

Wang Shilong (2):
      [6717b24] Btrfs: add regression test for transaction abortion when remounting
      [cd86825] Btrfs: add regression test for iterating backrefs


Code Diffstat:

 common/rc           |  2 +-
 tests/btrfs/025     | 34 ++++++++++-----------
 tests/btrfs/025.out | 12 --------
 tests/btrfs/029     |  6 ++--
 tests/btrfs/029.out |  4 +--
 tests/btrfs/030     | 86 ++++++++++++++++++++++++++++++++++++++++-------------
 tests/btrfs/032     | 57 +++++++++++++++++++++++++++++++++++
 tests/btrfs/032.out |  3 ++
 tests/btrfs/033     | 71 +++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/033.out |  2 ++
 tests/btrfs/group   |  2 ++
 tests/ext4/306      | 21 +++++--------
 tests/generic/299   |  2 +-
 tests/generic/313   |  3 +-
 14 files changed, 233 insertions(+), 72 deletions(-)
 create mode 100755 tests/btrfs/032
 create mode 100644 tests/btrfs/032.out
 create mode 100755 tests/btrfs/033
 create mode 100644 tests/btrfs/033.out
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
