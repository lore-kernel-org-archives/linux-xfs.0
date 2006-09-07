Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Sep 2006 23:52:40 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k876qKDW006399
	for <xfs@oss.sgi.com>; Wed, 6 Sep 2006 23:52:25 -0700
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k875rUnx001062
	for <xfs@oss.sgi.com>; Thu, 7 Sep 2006 00:53:30 -0500
Received: from omx2.sgi.com ([198.149.32.25])
	by internal-mail-relay1.corp.sgi.com (8.12.9/8.12.10/SGI_generic_relay-1.2) with ESMTP id k875r98s37777792
	for <xfs@oss.sgi.com>; Wed, 6 Sep 2006 22:53:09 -0700 (PDT)
Message-ID: <44FFB39C.3000700@melbourne.sgi.com>
Date: Thu, 07 Sep 2006 15:52:28 +1000
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: XFS update for 2.6.18-rc6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org
Cc: akpm@osdl.org, xfs@oss.sgi.com, axboe@kernel.dk

Hi Linus,

Please pull from:
	git://oss.sgi.com:8090/xfs/xfs-2.6

This will update the following files:

 fs/xfs/linux-2.6/xfs_aops.c |   18 +++++++++++++-----
 fs/xfs/linux-2.6/xfs_lrw.c  |   27 ++++++++++++++++++++++-----
 fs/xfs/quota/xfs_qm_bhv.c   |    2 +-
 fs/xfs/xfs_alloc.h          |   20 ++++++++++++++++++++
 fs/xfs/xfs_fsops.c          |   16 ++++++++++------
 fs/xfs/xfs_mount.c          |   32 ++++++++------------------------
 fs/xfs/xfs_vfsops.c         |    3 ++-
 7 files changed, 76 insertions(+), 42 deletions(-)

through these commits:

commit 4be536debe3f7b0c62283e77fd6bd8bdb9f83c6f
Author: David Chinner <dgc@sgi.com>
Date:   Thu Sep 7 14:26:50 2006 +1000

    [XFS] Prevent free space oversubscription and xfssyncd looping.

    The fix for recent ENOSPC deadlocks introduced certain limitations on
    allocations. The fix could cause xfssyncd to loop endlessly if we did not
    leave some space free for the allocator to work correctly. Basically, we
    needed to ensure that we had at least 4 blocks free for an AG free list
    and a block for the inode bmap btree at all times.

    However, this did not take into account the fact that each AG has a free
    list that needs 4 blocks. Hence any filesystem with more than one AG could
    cause oversubscription of free space and make xfssyncd spin forever trying
    to allocate space needed for AG freelists that was not available in the
    AG.

    The following patch reserves space for the free lists in all AGs plus the
    inode bmap btree which prevents oversubscription. It also prevents those
    blocks from being reported as free space (as they can never be used) and
    makes the SMP in-core superblock accounting code and the reserved block
    ioctl respect this requirement.

    SGI-PV: 955674
    SGI-Modid: xfs-linux-melb:xfs-kern:26894a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: David Chatterton <chatz@sgi.com>


commit 721259bce2851893155c6cb88a3f8ecb106b348c
Author: Lachlan McIlroy <lachlan@sgi.com>
Date:   Thu Sep 7 14:27:05 2006 +1000

    [XFS] Fix ABBA deadlock between i_mutex and iolock. Avoid calling
    __blockdev_direct_IO for the DIO_OWN_LOCKING case for direct I/O reads
    since it drops and reacquires the i_mutex while holding the iolock and
    this violates the locking order.

    SGI-PV: 955696
    SGI-Modid: xfs-linux-melb:xfs-kern:26898a

    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
    Signed-off-by: David Chatterton <chatz@sgi.com>


commit 0a8d17d090a4939643a52194b7d4a4001b9b2d93
Author: David Chinner <dgc@sgi.com>
Date:   Thu Sep 7 14:27:15 2006 +1000

    [XFS] Fix xfs_splice_write() so appended data gets to disk.

    xfs_splice_write() failed to update the on disk inode size when extending
    the so when the file was closed the range extended by splice was truncated
    off. Hence any region of a file written to by splice would end up as a
    hole full of zeros.

    SGI-PV: 955939
    SGI-Modid: xfs-linux-melb:xfs-kern:26920a

    Signed-off-by: David Chinner <dgc@sgi.com>
    Signed-off-by: David Chatterton <chatz@sgi.com>


commit 0edc7d0f3709e8c3bb7e69c4df614218a753361e
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Sep 7 14:27:23 2006 +1000

    [XFS] Fix a bad pointer dereference in the quota statvfs handling.

    SGI-PV: 955993
    SGI-Modid: xfs-linux-melb:xfs-kern:26934a

    Signed-off-by: Nathan Scott <nathans@sgi.com>
    Signed-off-by: David Chatterton <chatz@sgi.com>


Thanks,

David
