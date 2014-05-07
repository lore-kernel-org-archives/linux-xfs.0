Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C34C07F50
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 07:22:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 971B6304059
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 05:22:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n383WcxwIlI9Tt9c for
	<xfs@oss.sgi.com>; Wed, 07 May 2014 05:22:01 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s47CM0Hm005262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:00 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s47CM07L013067
	for <xfs@oss.sgi.com>; Wed, 7 May 2014 08:22:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 00/20] xfsprogs: introduce the free inode btree
Date: Wed,  7 May 2014 08:21:39 -0400
Message-Id: <1399465319-65066-1-git-send-email-bfoster@redhat.com>
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

Here's v4 of the finobt series for xfsprogs. Patches 1-10 are unchanged
as they are based on the corresponding kernel patches, which have now
been merged.

v4 includes some fairly isolated fixes for mkfs and repair based on
review feedback for v3:

	http://oss.sgi.com/archives/xfs/2014-04/msg00239.html

Some concern was raised over xfs_repair performance based on the
implementation of patch 17 in v3, so I have run a few repair tests on
largish filesystems. Tests involved creating a large number of inodes on
a 1TB 4xraid0, freeing a random percentage to populate the finobt and
running xfs_repair (e.g., no actual corruptions). xfs_repair was run
normally (with these patches) and with a change to skip the finobt
processing via an xfs_sb_version_hasfinobt() hack. The tests were run on
a 16xcpu, 32GB RAM server.

In just about all cases I don't reproduce much of a delta between the
finobt and non-finobt when the tests are averaged out over several runs:

16m inodes, 15 AGs, ~3% randomly freed
	- finobt avg. runtime	89s
	- !finobt avg. runtime	89s
16m inodes, 31 AGs, ~1% randomly freed
	- finobt avg. runtime	95s
	- !finobt avg. runtime	95s
77m inodes, 1000 AGs, no random removals
	- finobt avg. runtime	21m
	- !finobt avg. runtime	22m

A sample repair summary for the finobt run of the very last test listed is as
follows:

        XFS_REPAIR Summary    Tue May  6 11:16:19 2014

Phase           Start           End             Duration
Phase 1:        05/06 10:55:56  05/06 10:56:03  7 seconds
Phase 2:        05/06 10:56:03  05/06 10:56:12  9 seconds
Phase 3:        05/06 10:56:12  05/06 11:02:34  6 minutes, 22 seconds
Phase 4:        05/06 11:02:34  05/06 11:08:14  5 minutes, 40 seconds
Phase 5:        05/06 11:08:14  05/06 11:08:15  1 second
Phase 6:        05/06 11:08:15  05/06 11:15:49  7 minutes, 34 seconds
Phase 7:        05/06 11:15:49  05/06 11:15:50  1 second

This shows the bulk of the time spent in phases 3, 4 and 6, which I
believe are mostly responsible for reading/processing/checking inodes
and directories. The inobt and finobt reconstruction occur in phase 5,
which runs in ~1s. For this reason, I haven't thus far attempted any
runtime optimizations, but feedback or suggestions on other test
procedures that might affect these results is appreciated.

Brian

v4:
- Disable finobt when crc is disabled in mkfs. This fixes xfstests
  xfs/00[12]. (patch 11)
- Fix the comment for calc_mkfs(). (patch 13)
- Fixed xfs_repair phase2 logic to detect allocation state mismatches
  between the inode btrees. Also added/fixed some comments. (patch 14)
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
 mkfs/xfs_mkfs.c            |  93 +++++--
 repair/incore.h            |  27 ++
 repair/phase5.c            | 109 ++++++--
 repair/scan.c              | 251 +++++++++++++++++-
 repair/xfs_repair.c        |  10 +-
 21 files changed, 1171 insertions(+), 182 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
