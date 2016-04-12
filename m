Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A93F7CA1
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 11:42:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE4C1304070
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TWkoDGu7Otwt2lqA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 09:42:55 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 PATCH 00/10] dm-thin/xfs: prototype a block reservation
	allocation model
Date: Tue, 12 Apr 2016 12:42:43 -0400
Message-Id: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com

Hi all,

This is v2 of the XFS and block device reservation experiment. The
significant changes in v2 are that the bdev interface has been condensed
to a single callback function, the XFS transaction reservation
management has been reworked to make transactions responsible for
tracking and releasing excess reservation (for non-delalloc cases) and a
workaround for the fallocate over-reservation issue is included. Beyond
that, this version adds a bunch of miscellaneous cleanups and fixes some
of the nastier locking/leak issues present in the first rfc.

Patches 1-2 refactor some XFS reserve pool and block accounting code in
preparation for subsequent patches. Patches 3-5 add block/device-mapper
reservation support. Patches 6-10 add the core reservation
infrastructure and management bits to XFS. See the link to the original
rfc below for instructions and further details around the purpose of
this series.

Finally, note that this is still highly experimental/theoretical and
should not be used on production systems. Thoughts, reviews, flames
appreciated.

Brian

rfcv2:
- Rebased to 4.6.0-rc3.
- Fix compile warnings reported by kbuild.
- Fix reservation leakage on fs ENOSPC.
- Fix mod_fdblocks locking to avoid BUG() (still racy).
- Fix XFS reserve block ENOSPC handling.
- Kill block wrappers, condense get/set/provision to a single callback.
- Update XFS transaction to track reservation, don't release excess on
  provision.
- Add transaction noblkres mode, use for fallocate reservation
  optimization.
rfc: http://oss.sgi.com/pipermail/xfs/2016-March/047673.html

Brian Foster (7):
  xfs: refactor xfs_reserve_blocks() to handle ENOSPC correctly
  xfs: replace xfs_mod_fdblocks() bool param with flags
  xfs: thin block device reservation mechanism
  xfs: adopt a reserved allocation model on dm-thin devices
  xfs: handle bdev reservation ENOSPC correctly from XFS reserved pool
  xfs: support no block reservation transaction mode
  xfs: use contiguous bdev reservation for file preallocation

Joe Thornber (1):
  dm thin: add methods to set and get reserved space

Mike Snitzer (2):
  block: add block_device_operations methods to set and get reserved
    space
  dm: add methods to set and get reserved space

 drivers/md/dm-thin.c          | 181 +++++++++++++++++++++++++++--
 drivers/md/dm.c               |  41 +++++++
 fs/xfs/Makefile               |   1 +
 fs/xfs/libxfs/xfs_alloc.c     |  25 ++++
 fs/xfs/libxfs/xfs_bmap.c      |  17 ++-
 fs/xfs/libxfs/xfs_shared.h    |   2 +
 fs/xfs/xfs_bmap_util.c        |  29 ++++-
 fs/xfs/xfs_fsops.c            | 128 ++++++++++++++-------
 fs/xfs/xfs_mount.c            | 106 +++++++++++++++--
 fs/xfs/xfs_mount.h            |  12 +-
 fs/xfs/xfs_thin.c             | 260 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_thin.h             |  31 +++++
 fs/xfs/xfs_trace.h            |  27 +++++
 fs/xfs/xfs_trans.c            |  94 +++++++++++++--
 fs/xfs/xfs_trans.h            |   1 +
 include/linux/blkdev.h        |   6 +
 include/linux/device-mapper.h |   5 +
 17 files changed, 880 insertions(+), 86 deletions(-)
 create mode 100644 fs/xfs/xfs_thin.c
 create mode 100644 fs/xfs/xfs_thin.h

-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
