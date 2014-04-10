Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA8937FA4
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:08:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D3DFAC00F
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ro1p2hzkWAWXMvJh for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:08:39 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AG8clJ002817
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:38 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s3AG8cFX031924
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:08:38 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 00/11] xfs: introduce the free inode btree
Date: Thu, 10 Apr 2014 12:08:25 -0400
Message-Id: <1397146116-42546-1-git-send-email-bfoster@redhat.com>
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

This is a minor rebase of the finobt series on the latest for-next
branch. The previous version (v4) is here:

http://oss.sgi.com/archives/xfs/2014-02/msg00763.html

The most recent series with review feedback is v3:

http://oss.sgi.com/archives/xfs/2014-02/msg00121.html

Brian

v5:
- Rebase to latest for-next.
v4:
- Fixed up comments associated with separation of the AGI into separate
  logging regions.
- Added warning on ENOSPC failure of ifree reservation and comment
  describing reasoning for ifree being reserve-enabled.
- Removed finobt res. from xfs_calc_create_resv_alloc() (v4 sb only).
- Updated xfs_calc_finobt_res() to account for free space btrees and
  enable for inode alloc. record modification scenario.
- Renamed xfs_dialloc_ag_slow() to xfs_dialloc_ag_inobt().
- Refactored the inode allocation algorithm into several smaller helper
  functions.
- Fixed up comments in xfs_difree_finobt().
v3:
- Rebased to latest master.
- Fixed up unused variable warning in xfs_difree_inobt().
- Replaced a few more typedefs.
v2:
- Rebase to latest xfs tree (minor shifting around of some header bits).
- Added "xfs: report finobt status in fs geometry" patch to series.
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

Brian Foster (11):
  xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
  xfs: reserve v5 superblock read-only compat. feature bit for finobt
  xfs: support the XFS_BTNUM_FINOBT free inode btree type
  xfs: update inode allocation/free transaction reservations for finobt
  xfs: insert newly allocated inode chunks into the finobt
  xfs: use and update the finobt on inode allocation
  xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helper
  xfs: update the finobt on inode free
  xfs: add finobt support to growfs
  xfs: report finobt status in fs geometry
  xfs: enable the finobt feature on v5 superblocks

 fs/xfs/xfs_ag.h           |  36 ++-
 fs/xfs/xfs_btree.c        |   6 +-
 fs/xfs/xfs_btree.h        |   3 +
 fs/xfs/xfs_format.h       |  14 +-
 fs/xfs/xfs_fs.h           |   1 +
 fs/xfs/xfs_fsops.c        |  36 ++-
 fs/xfs/xfs_ialloc.c       | 695 +++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_ialloc_btree.c |  68 ++++-
 fs/xfs/xfs_ialloc_btree.h |   3 +-
 fs/xfs/xfs_inode.c        |  25 +-
 fs/xfs/xfs_itable.c       |   6 +-
 fs/xfs/xfs_log_recover.c  |   2 +
 fs/xfs/xfs_sb.h           |  10 +-
 fs/xfs/xfs_stats.c        |   1 +
 fs/xfs/xfs_stats.h        |  18 +-
 fs/xfs/xfs_trans_resv.c   |  53 +++-
 fs/xfs/xfs_trans_space.h  |   7 +-
 fs/xfs/xfs_types.h        |   2 +-
 18 files changed, 850 insertions(+), 136 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
