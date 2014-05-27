Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 856B57F4E
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 19:34:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C8B3304032
	for <xfs@oss.sgi.com>; Mon, 26 May 2014 17:34:40 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BxAw5q7MPAsMAbfK for <xfs@oss.sgi.com>;
	Mon, 26 May 2014 17:34:38 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Wp5L4-0001iN-Iw
	for xfs@oss.sgi.com; Tue, 27 May 2014 10:33:58 +1000
Date: Tue, 27 May 2014 10:33:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 03e956b
Message-ID: <20140527003358.GT18954@dastard>
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

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

03e956b db: add finobt support to metadump

New Commits:

Brian Foster (20):
      [70eb733] xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
      [dad1321] xfs: reserve v5 superblock read-only compat. feature bit for finobt
      [c0a4c22] xfs: support the XFS_BTNUM_FINOBT free inode btree type
      [0f88d64] xfs: update inode allocation/free transaction reservations for finobt
      [3c69927] xfs: insert newly allocated inode chunks into the finobt
      [88fc730] xfs: use and update the finobt on inode allocation
      [eb9a297] xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helper
      [1bb93fd] xfs: update the finobt on inode free
      [608dff0] xfs: report finobt status in fs geometry
      [a9f4ba9] xfs: enable the finobt feature on v5 superblocks
      [f49c4e8] mkfs: finobt mkfs support
      [2a0cd7a] db: finobt support
      [7b37090] repair: account for finobt in ag 0 geometry pre-calculation
      [1578050] repair: phase 2 finobt scan
      [bb26606] repair: pass btree block magic as param to build_ino_tree()
      [d6412d1] repair: pull the build_agi() call up out of the inode tree build
      [01159bd] repair: helpers for finding in-core inode records w/ free inodes
      [bbdb21b] repair: reconstruct the finobt in phase 5
      [0506438] growfs: report finobt status in fs geometry (xfs_info)
      [03e956b] db: add finobt support to metadump


Code Diffstat:

 db/agi.c                   |   2 +
 db/btblock.c               |  12 +
 db/metadump.c              |  25 +-
 growfs/xfs_growfs.c        |  14 +-
 include/xfs_ag.h           |  32 ++-
 include/xfs_btree.h        |   3 +
 include/xfs_format.h       |  14 +-
 include/xfs_fs.h           |   1 +
 include/xfs_ialloc_btree.h |   3 +-
 include/xfs_sb.h           |  10 +-
 include/xfs_trans_space.h  |   7 +-
 include/xfs_types.h        |   2 +-
 libxfs/xfs_btree.c         |   6 +-
 libxfs/xfs_ialloc.c        | 617 ++++++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_ialloc_btree.c  |  68 ++++-
 libxfs/xfs_trans_resv.c    |  47 +++-
 mkfs/xfs_mkfs.c            |  93 +++++--
 repair/incore.h            |  27 ++
 repair/phase5.c            | 109 ++++++--
 repair/scan.c              | 251 +++++++++++++++++-
 repair/xfs_repair.c        |  10 +-
 21 files changed, 1171 insertions(+), 182 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
