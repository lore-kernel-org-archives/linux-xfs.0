Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 732AF7CA1
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 09:30:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3983C30406B
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3NOTPqXcPQyK0yEV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:39 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 0/9] dm-thin/xfs: prototype a block reservation allocation
	model
Date: Thu, 17 Mar 2016 10:30:28 -0400
Message-Id: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
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

This is a proof-of-concept of a block reservation allocation model
between XFS and dm-thin. The purpose is to create a mechanism by which
the filesystem can determine an underlying thin volume is out of space
and opt to return -ENOSPC to userspace rather than waiting until the
volume is driven out of space (and deactivated or transitioned
read-only). The idea, in principle, is to use a similar reservation
model for thin pool blocks as the filesystem does today for delayed
allocation blocks and to prevent similar risk of overprovisioning of fs
blocks.

This idea was concocted a while back during some discussions around how
to provide a more user friendly out of space condition to users of
filesystems on top of thin devices. At the moment, we (XFS) write to the
underlying volume until it runs out of space and transitions to
read-only. The administrator is responsible to prevent or recover from
this condition via auto provisioning and/or monitoring for low watermark
notifications. With a reservation model, the filesytem returns -ENOSPC
at write time when the underlying pool is out of space and operation
otherwise continues (e.g., space can be freed from the fs) as if the fs
itself were out of space.

Joe and Mike were kind enough to hack together a dm block reservation
mechanism to help us experiment further. I slightly modified and hacked
in an additional provision call based on their code, and then hacked up
an integration with the existing XFS resource reservation mechanism. I
think the results are slightly encouraging, at least in that the basic
buffered write mechanism works as expected without too much inefficiency
due to the over-reservation.

There are still flaws and tradeoffs to this approach, of course. The
current implementation uses a worst case reservation model that assumes
every unallocated filesystem block requires a new dm-thin block
allocation. With dm-thin block sizes on the order of 256k-1MB for larger
volumes, this is a significant over-reservation for 4k (or smaller)
filesystem blocks. XFS has algorithms in some areas (buffered writes)
that deal with this problem already, but at the very least, further
optimization might be in order to improve performance. This also doesn't
consider other operations (fallocate) or filesystems that might not be
immediately suited to handle this limitation. Also, the interface to the
block device is clearly crude, incomplete and hacked together
(particularly the provision bits added by me). It remains to be seen
whether we can define a sane interface to fully support this
functionality.

As far as the implementation goes, this is a toy/experiment with various
other known issues (mostly documented in the code, see the comments in
xfs_thin.c) and should not be used for anything outside of
experimentation. I haven't done much testing beyond simple buffered
write runs to ENOSPC, so problems in other areas can be expected.
Apologies for whatever general shoddiness might be discovered, but I
wanted to get something posted to generate discussion before putting too
much effort into testing and exploring all of the dark corners where
more issues certainly lurk.

In summary, the primary purpose of this series is to close the loop on
some of the early XFS/dm-thin discussion around whether something like
this is feasible, worthwhile, and to otherwise gather initial thoughts
from fs and dm folks on the general topic. If worth pursuing further,
discussion around things like an appropriate interface to the block
device is certainly warranted.

Thanks again to Joe and Mike for entertaining the idea and hacking
something together to play around with. Thoughts, reviews, flames
appreciated. (BTW, I'm also planning to be at LSF if anybody is
interested in discussing this further).

Brian

P.S., With these patches applied, use the following to create an
over-provisioned thin volume and mount XFS in "reservation mode:"

# lvcreate --thinpool test/pool -L1G
# lvcreate -T test/pool -n thin -V 10G
# mkfs.xfs -f /dev/test/thin
# mount /dev/test/thin /mnt -o discard
# dmesg | tail
...
XFS (dm-8): Mounting V5 Filesystem
XFS (dm-8): Ending clean mount
XFS (dm-8): Thin pool reservation enabled
XFS (dm-8): Thin reserve blocksize: 512 sectors
# dd if=/dev/zero of=/mnt/file bs=4k
dd: error writing '/mnt/file': No space left on device
...

Brian Foster (6):
  dm thin: update reserve space func to allow reduction
  block: add a block_device_operations method to provision space
  dm: add method to provision space
  dm thin: add method to provision space
  xfs: thin block device reservation mechanism
  xfs: adopt a reserved allocation model on dm-thin devices

Joe Thornber (1):
  dm thin: add methods to set and get reserved space

Mike Snitzer (2):
  block: add block_device_operations methods to set and get reserved
    space
  dm: add methods to set and get reserved space

 drivers/md/dm-thin.c          | 187 +++++++++++++++++++++++++++--
 drivers/md/dm.c               | 110 +++++++++++++++++
 fs/block_dev.c                |  30 +++++
 fs/xfs/Makefile               |   1 +
 fs/xfs/libxfs/xfs_alloc.c     |   6 +
 fs/xfs/xfs_mount.c            |  81 +++++++++++--
 fs/xfs/xfs_mount.h            |   7 ++
 fs/xfs/xfs_thin.c             | 273 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_thin.h             |   9 ++
 fs/xfs/xfs_trace.h            |  27 +++++
 fs/xfs/xfs_trans.c            |  26 +++-
 include/linux/blkdev.h        |   7 ++
 include/linux/device-mapper.h |   7 ++
 13 files changed, 749 insertions(+), 22 deletions(-)
 create mode 100644 fs/xfs/xfs_thin.c
 create mode 100644 fs/xfs/xfs_thin.h

-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
