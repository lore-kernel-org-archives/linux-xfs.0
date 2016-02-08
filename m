Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BE1C67CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 00:08:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9A1B304048
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 22:08:33 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qRcEQtFQZsxaWZrp for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 22:08:27 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aSezH-0007FY-N0
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 17:07:51 +1100
Date: Mon, 8 Feb 2016 17:07:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 4a91310
Message-ID: <20160208060751.GA27429@dastard>
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

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. I've pushed this out with both generic quota
and direct Io modifications in it, so if they end up going into
another tree expect a rebase of the for-next branch to occur to pull
them in from the appropriate trees.

There is still a lot of changes pending review to go into this
for-next tree, and I'm hoping to get the first part of the
rmap/reflink work into it as well, so there's plenty of work still
to be done in this cycle....

The new head of the for-next branch is commit:

4a91310 Merge branch 'xfs-misc-fixes-4.6' into for-next

New Commits:

Brian Foster (2):
      [60630fe] xfs: clean up unwritten buffers on write failure
      [af055e3] xfs: fix xfs_log_ticket leak in xfs_end_io() after fs shutdown

Carlos Maiolino (1):
      [be60794] xfs: Split default quota limits by quota type

Christoph Hellwig (6):
      [187372a] direct-io: always call ->end_io if non-NULL
      [273dda7] xfs: don't use ioends for direct write completions
      [c19b104] xfs: fold xfs_vm_do_dio into xfs_vm_direct_IO
      [196328e] xfs: handle errors from ->free_blocks in xfs_btree_kill_iroot
      [c46ee8a] xfs: factor btree block freeing into a helper
      [edfd9dd] xfs: move buffer invalidation to xfs_btree_free_block

Darrick J. Wong (2):
      [8e0bd49] xfs: fix endianness error when checking log block crc on big endian platforms
      [244efea] xfs: move struct xfs_attr_shortform to xfs_da_format.h

Dave Chinner (7):
      [4b680af] xfs: lock rt summary inode on allocation
      [a204d07] xfs: RT bitmap and summary buffers are not typed
      [ca4de5c] xfs: RT bitmap and summary buffers need verifiers
      [e892a10] Merge branch 'xfs-rt-fixes-4.6' into for-next
      [ec370f5] Merge branch 'xfs-get-next-dquot-4.6' into for-next
      [0d077b8] Merge branch 'xfs-dio-fix-4.6' into for-next
      [4a91310] Merge branch 'xfs-misc-fixes-4.6' into for-next

Eric Sandeen (8):
      [3218a3e] quota: remove unused cmd argument from quota_quotaon()
      [8b37524] quota: add new quotactl Q_XGETNEXTQUOTA
      [926132c] quota: add new quotactl Q_GETNEXTQUOTA
      [a484bcd] xfs: don't overflow quota ID when initializing dqblk
      [4d4d952] xfs: get quota inode from mp & flags rather than dqp
      [8aa7d37] xfs: Factor xfs_seek_hole_data into helper
      [296c24e] xfs: wire up Q_XGETNEXTQUOTA / get_nextdqblk
      [de0b85a] xfs: remove unused function definitions

Michal Hocko (1):
      [18f1df4] xfs: Make xfsaild freezeable again


Code Diffstat:

 fs/dax.c                         |   9 +-
 fs/direct-io.c                   |   9 +-
 fs/ext4/inode.c                  |   9 +-
 fs/ocfs2/aops.c                  |   7 +-
 fs/quota/quota.c                 |  66 +++++++++-
 fs/xfs/libxfs/xfs_alloc_btree.c  |   2 -
 fs/xfs/libxfs/xfs_attr_sf.h      |  16 ---
 fs/xfs/libxfs/xfs_bmap_btree.c   |   1 -
 fs/xfs/libxfs/xfs_btree.c        |  32 +++--
 fs/xfs/libxfs/xfs_da_format.h    |  16 +++
 fs/xfs/libxfs/xfs_ialloc_btree.c |  12 +-
 fs/xfs/libxfs/xfs_inode_fork.c   |   1 +
 fs/xfs/libxfs/xfs_log_format.h   |   2 +
 fs/xfs/libxfs/xfs_quota_defs.h   |   3 +-
 fs/xfs/libxfs/xfs_rtbitmap.c     |  30 ++++-
 fs/xfs/libxfs/xfs_sb.h           |   1 -
 fs/xfs/libxfs/xfs_shared.h       |   1 +
 fs/xfs/xfs_aops.c                | 274 +++++++++++++++------------------------
 fs/xfs/xfs_bmap_util.c           |   4 +-
 fs/xfs/xfs_dquot.c               | 129 +++++++++++++++---
 fs/xfs/xfs_file.c                |  82 ++++++++----
 fs/xfs/xfs_fsops.h               |   1 -
 fs/xfs/xfs_inode.h               |   2 +
 fs/xfs/xfs_log_recover.c         |   9 +-
 fs/xfs/xfs_mount.h               |   1 -
 fs/xfs/xfs_qm.c                  |  55 ++++++--
 fs/xfs/xfs_qm.h                  |  48 +++++--
 fs/xfs/xfs_qm_syscalls.c         |  27 ++--
 fs/xfs/xfs_quotaops.c            |  36 ++++-
 fs/xfs/xfs_trace.h               |   9 +-
 fs/xfs/xfs_trans_ail.c           |   5 +-
 fs/xfs/xfs_trans_dquot.c         |  15 ++-
 include/linux/fs.h               |   2 +-
 include/linux/quota.h            |   2 +
 include/uapi/linux/dqblk_xfs.h   |   1 +
 include/uapi/linux/quota.h       |  14 ++
 36 files changed, 615 insertions(+), 318 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
