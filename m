Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 60EA07F89
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:07:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50205304039
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 11:07:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id q9vGwHio7mQ5PsqM for
	<xfs@oss.sgi.com>; Wed, 09 Oct 2013 11:07:33 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r99I7Wqe007924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 9 Oct 2013 14:07:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r99I7Wkk004857
	for <xfs@oss.sgi.com>; Wed, 9 Oct 2013 14:07:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 00/10] xfs: introduce the free inode btree
Date: Wed,  9 Oct 2013 14:06:48 -0400
Message-Id: <1381342018-35829-1-git-send-email-bfoster@redhat.com>
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

Hi all,

Here is the first release of free inode btree support for the kernel. It
is based on the RFC previously made available here:

http://oss.sgi.com/archives/xfs/2013-09/msg00076.html

The free inode btree adds a new inode btree to XFS with the intent to
track only inode chunks with at least one free inode. Patches 1-3 add
the necessary support for the new XFS_BTNUM_FINOBT type and introduce a
read-only v5 superblock flag. Patch 4 updates the transaction
reservations for inode allocation operations to account for the finobt.
Patches 5-9 add support to manage the finobt on inode chunk allocation,
inode allocation, inode free (and chunk deletion) and growfs. The 10th
and final patch adds the feature bit to the associated mask. Thoughts,
reviews and flames appreciated.

Brian

v1:
- Separate patch to enable rw finobt support at end of series.
- Rework xfs_ialloc_log_agi() to log the agi in two distinct regions.
- Rework xfs_ialloc_btree.c changes to use separate finobt handlers
  where appropriate.
- Fix bug to show fibt2 stats data in stat proc file.
- Move finobt log reservation calculations into separate helper, made
  conditional and merged to a single patch.
- Use reserved block pool in xfs_inactive() codepath instead of flush.
- Moved and cleaned up xfs_inobt_insert() to use inobt helpers.
- Enhanced lookup algorithm for allocation (xfs_dialloc_ag()).
- Refactored xfs_difree() to use xfs_difree_inobt() and
  xfs_difree_finobt(), cleaned up the latter.

Brian Foster (10):
  xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
  xfs: reserve v5 superblock read-only compat. feature bit for finobt
  xfs: support the XFS_BTNUM_FINOBT free inode btree type
  xfs: update inode allocation/free transaction reservations for finobt
  xfs: insert newly allocated inode chunks into the finobt
  xfs: use and update the finobt on inode allocation
  xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helper
  xfs: update the finobt on inode free
  xfs: add finobt support to growfs
  xfs: enable the finobt feature on v5 superblocks

 fs/xfs/xfs_ag.h           |  32 ++-
 fs/xfs/xfs_btree.c        |   6 +-
 fs/xfs/xfs_btree.h        |   3 +
 fs/xfs/xfs_fsops.c        |  32 +++
 fs/xfs/xfs_ialloc.c       | 616 ++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_ialloc_btree.c |  68 ++++-
 fs/xfs/xfs_ialloc_btree.h |  17 +-
 fs/xfs/xfs_inode.c        |   4 +-
 fs/xfs/xfs_itable.c       |   6 +-
 fs/xfs/xfs_log_recover.c  |   2 +
 fs/xfs/xfs_sb.h           |  10 +-
 fs/xfs/xfs_stats.c        |   1 +
 fs/xfs/xfs_stats.h        |  18 +-
 fs/xfs/xfs_trans_resv.c   |  47 +++-
 fs/xfs/xfs_trans_space.h  |   7 +-
 fs/xfs/xfs_types.h        |   2 +-
 16 files changed, 742 insertions(+), 129 deletions(-)

-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
