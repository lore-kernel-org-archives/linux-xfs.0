Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1B9BB7F91
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 11:11:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95A8A8F8035
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zJXkjoVLBDBRS3F2 for
	<xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:11:13 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3AGBCj0003693
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:12 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s3AGBCfd021274
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 12:11:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 00/20] xfsprogs: introduce the free inode btree
Date: Thu, 10 Apr 2014 12:10:50 -0400
Message-Id: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
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

This is the v3 userspace portion of finobt support corresponding to v5
of the kernel series.

Patches 1-10 are straight application of the corresponding kernel patches
with omissions where appropriate.

Patch 11 adds mkfs support. Patches 12 and 13 provide a couple minor db
and repair fixes to support the new agi fields and calculate the fs
format respectively. Patches 14-18 add real repair support for the
finobt. Patch 19 adds support to report finobt state in xfs_info. Patch
20 adds support for metadump.

Thoughts, reviews, flames appreciated.

Brian

v3:
- Rebased to latest master.
v2:
- Rebased onto the CRC v5 series and v2 kernel finobt bits.
- Core finobt repair support.
- xfs_info support.
- xfs_metadump support.

Brian Foster (20):
  xfs: refactor xfs_ialloc_btree.c to support multiple inobt numbers
  xfs: reserve v5 superblock read-only compat. feature bit for finobt
  xfs: support the XFS_BTNUM_FINOBT free inode btree type
  xfs: update inode allocation/free transaction reservations for finobt
  xfs: insert newly allocated inode chunks into the finobt
  xfs: use and update the finobt on inode allocation
  xfs: refactor xfs_difree() inobt bits into xfs_difree_inobt() helper
  xfs: update the finobt on inode free
  xfs: report finobt status in fs geometry
  xfs: enable the finobt feature on v5 superblocks
  xfsprogs/mkfs: finobt mkfs support
  xfsprogs/db: finobt support
  xfsprogs/repair: account for finobt in ag 0 geometry pre-calculation
  xfsprogs/repair: phase 2 finobt scan
  xfsprogs/repair: pass btree block magic as param to build_ino_tree()
  xfsprogs/repair: pull the build_agi() call up out of the inode tree
    build
  xfsprogs/repair: helpers for finding in-core inode records w/ free
    inodes
  xfsprogs/repair: reconstruct the finobt in phase 5
  xfsprogs/growfs: report finobt status in fs geometry (xfs_info)
  xfsprogs/db: add finobt support to metadump

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
 mkfs/xfs_mkfs.c            |  83 ++++--
 repair/incore.h            |  27 ++
 repair/phase5.c            | 109 ++++++--
 repair/scan.c              | 239 +++++++++++++++++-
 repair/xfs_repair.c        |   2 +
 21 files changed, 1144 insertions(+), 179 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
