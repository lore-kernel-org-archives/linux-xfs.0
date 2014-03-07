Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 49D197F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 18:05:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40F36304070
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 16:05:12 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	M4emY0N2PO1pbxo4 for <xfs@oss.sgi.com>;
	Thu, 06 Mar 2014 16:05:05 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WLiHI-0007Ub-Mu
	for xfs@oss.sgi.com; Fri, 07 Mar 2014 11:04:40 +1100
Date: Fri, 7 Mar 2014 11:04:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 97b1fcf
Message-ID: <20140307000440.GO6851@dastard>
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

Hi Folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

97b1fcf xfs_repair: fix array overrun in do_inode_prefetch

New Commits:

Dave Chinner (13):
      [46ea3a6] libxfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
      [4b0c789] libxfs: sanitize sb_inopblock in xfs_mount_validate_sb
      [f3cddd9] libxfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
      [c13fe77] libxfs: skip verification on initial "guess" superblock read
      [ba5027e] libxfs: limit superblock corruption errors to actual corruption
      [dbf564d] libxfs: skip pointless CRC updates after verifier failures
      [3faddc5] libxfs: Use defines for CRC offsets in all cases
      [d21ca64] libxfs: add helper for verifying checksums on xfs_bufs
      [43b5aee] libxfs: add helper for updating checksums on xfs_bufs
      [99c1ec9] libxfs: add xfs_verifier_error()
      [4592293] libxfs: modify verifiers to differentiate CRC from other errors
      [9c0a86e] xfs_db: Use EFSBADCRC for CRC validity indication
      [88f364a] repair: phase 1 does not handle superblock CRCs

Eric Sandeen (1):
      [97b1fcf] xfs_repair: fix array overrun in do_inode_prefetch


Code Diffstat:

 db/io.c                     |  5 ++--
 db/io.h                     |  2 +-
 include/darwin.h            |  1 +
 include/freebsd.h           |  1 +
 include/gnukfreebsd.h       |  1 +
 include/irix.h              |  2 ++
 include/libxfs.h            | 16 +++++++++-
 include/linux.h             |  1 +
 include/xfs_ag.h            |  6 ++++
 include/xfs_dinode.h        |  2 ++
 include/xfs_format.h        |  2 ++
 include/xfs_sb.h            |  2 ++
 libxfs/util.c               | 13 +++++++++
 libxfs/xfs.h                |  1 +
 libxfs/xfs_alloc.c          | 45 ++++++++++++----------------
 libxfs/xfs_alloc_btree.c    | 16 +++++-----
 libxfs/xfs_attr_leaf.c      | 17 ++++++-----
 libxfs/xfs_attr_remote.c    | 15 ++++------
 libxfs/xfs_bmap_btree.c     | 16 +++++-----
 libxfs/xfs_btree.c          | 14 ++++-----
 libxfs/xfs_da_btree.c       | 17 ++++++-----
 libxfs/xfs_dir2_block.c     | 17 ++++++-----
 libxfs/xfs_dir2_data.c      | 20 ++++++-------
 libxfs/xfs_dir2_leaf.c      | 17 ++++++-----
 libxfs/xfs_dir2_node.c      | 17 ++++++-----
 libxfs/xfs_dquot_buf.c      | 11 ++++---
 libxfs/xfs_ialloc.c         | 24 +++++++--------
 libxfs/xfs_ialloc_btree.c   | 16 +++++-----
 libxfs/xfs_inode_buf.c      |  7 ++---
 libxfs/xfs_sb.c             | 32 +++++++++++---------
 libxfs/xfs_symlink_remote.c | 16 +++++-----
 repair/agheader.c           |  2 +-
 repair/globals.h            |  3 +-
 repair/phase1.c             |  5 ++--
 repair/prefetch.c           |  2 +-
 repair/protos.h             |  3 +-
 repair/sb.c                 | 71 +++++++++++++++++++++++++--------------------
 repair/scan.c               |  1 -
 repair/xfs_repair.c         | 26 ++++++++++-------
 39 files changed, 273 insertions(+), 212 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
