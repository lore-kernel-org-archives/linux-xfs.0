Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E40EB7F5E
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 09:56:28 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9E0A18F8049
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2QDj0LWjsAq891Q2 for
	<xfs@oss.sgi.com>; Wed, 13 Nov 2013 07:56:24 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rADFuOlb014547
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:24 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id rADFuNO9001241
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 10:56:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 00/20] xfsprogs: introduce the free inode btree
Date: Wed, 13 Nov 2013 10:56:02 -0500
Message-Id: <1384358182-37967-1-git-send-email-bfoster@redhat.com>
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

This is the v2 userspace portion of finobt support corresponding to v2
of the kernel series.

Patches 1-10 are straight application of the corresponding kernel patches
with omissions where appropriate. At this point, I'd suggest review of
those patches target the kernel equivalents, as this set will progress
using the kernel set as a base.

Patch 11 adds mkfs support. Patches 12 and 13 provide a couple minor db
and repair fixes to support the new agi fields and calculate the fs
format respectively. Patches 14-18 add real repair support for the
finobt. Patch 19 adds support to report finobt state in xfs_info. Patch
20 adds support for metadump.

Note that this series is based on Dave's latest (v5) CRC write support
series for userspace:

http://oss.sgi.com/archives/xfs/2013-11/msg00351.html

This is required for metadump support in particular.

I think this set is now fairly comprehensive in terms of finobt support.
My biggest question at the moment is with regard to how far to enhance
repair support. Repair currently scans the finobt in phase 2, attempts
to call out inconsistencies and regenerates the finobt based on the
in-core data in phase 5. Once basic support is ironed out, we have a
duplicate source of a subset of inode metadata (chunks with free inodes)
from which to potentially make more intelligent repair decisions.
Thoughts appreciated.

Brian

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
 libxfs/xfs_ialloc.c        | 616 ++++++++++++++++++++++++++++++++++++++-------
 libxfs/xfs_ialloc_btree.c  |  68 ++++-
 libxfs/xfs_trans_resv.c    |  47 +++-
 mkfs/xfs_mkfs.c            |  83 ++++--
 repair/incore.h            |  27 ++
 repair/phase5.c            | 109 ++++++--
 repair/scan.c              | 239 +++++++++++++++++-
 repair/xfs_repair.c        |   2 +
 21 files changed, 1144 insertions(+), 178 deletions(-)

-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
