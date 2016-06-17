Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 230BA7CA2
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:04:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D429A30404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:04:21 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id BNSflzmmDnqoFU6u for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:04:20 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [RFC PATCH 0/2] Initial support for badblock checking in xfs
Date: Thu, 16 Jun 2016 19:03:37 -0600
Message-Id: <1466125419-17736-1-git-send-email-vishal.l.verma@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-nvdimm@lists.01.org, xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>, Vishal Verma <vishal.l.verma@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

These are early/RFC patches to add badblock support in xfs.

Patch 1 should be relatively straightforward - it adds a notifier chain
to badblocks that filesystems can register with.

Patch 2 is the beginnings of xfs support. So far, I have the notifier
registration and building the initial badblock list happening in
xfs_mountfs. The next steps (and I may need some help with this as I'm
no (x)fs developer :)) are to add this badblocks info to the reverse
mapping tree, and then to check for it before accessing the media.

Right now, this just prints the sector numbers/counts/{added, removed}
to the kernel log, for both the initial list, and subsequent notifier
hits.

While I've tested this with a fake pmem device using libnvdimm's
nfit_test framework, it should also work using badblock injection with
any block device:

# mkfs.xfs -f /dev/<device>
# echo 122 1 > /sys/block/<device>/badblocks
# echo 124 1 > /sys/block/<device>/badblocks
# mount -t xfs /dev/<device> /mnt
... in log:
[  +8.803776] XFS (pmem7): Mounting V4 Filesystem
[  +0.009633] XFS (pmem7): Ending clean mount
[  +0.001655] XFS (pmem7): got badblocks: sector 122, count 1
[  +0.002018] XFS (pmem7): got badblocks: sector 124, count 1

# echo 132 5 | > /sys/block/<device>/badblocks
[Jun16 18:56] XFS (pmem7): xfs badblock added sector 132 (count 5)

This is all based on Darrik's rmap work at:
https://github.com/djwong/linux/tree/rmap-reflink-devel

Since this is based on a v4.5-rc kernel, it lacks pmem support for
clearing badblocks on zeroing/writing, so those parts can't easily
be tested yet. The clearing work is in 4.7-rs kernels, and once we
rebase to that, that should also be available.


Vishal Verma (2):
  block, badblocks: add a notifier for badblocks
  xfs: initial/partial support for badblocks

 block/badblocks.c         |  79 +++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_linux.h        |   1 +
 fs/xfs/xfs_mount.c        | 104 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h        |   1 +
 include/linux/badblocks.h |  19 +++++++++
 5 files changed, 201 insertions(+), 3 deletions(-)

-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
