Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C00458047
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 13:53:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 659CD8F80BA
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 11:53:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VfhZbQeTSt08kvtk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 11:53:08 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t16Jr71F016993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:07 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t16Jr6Mh022339
	for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:06 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 00/18] xfs: sparse inode chunks
Date: Fri,  6 Feb 2015 14:52:47 -0500
Message-Id: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
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

Here's v3 of sparse inode chunk suport for XFS. The primary update for
this version is an update to how inodes are aligned when sparse inode
support is enabled. Inode chunks are currently aligned to cluster size
to support single I/O per inode cluster. This means that the minimum
block range between two non-adjacent inode chunks is the cluster size.
Cluster size is also the granularity of sparse allocation. Therefore, it
is possible to allocate a cluster size chunk that cannot be converted to
an inode record due to overlap on both sides (ambiguous metadata). The
only recourse in this situation is to undo the allocation and likely
return ENOSPC. Given the added complexity of that and the already
complicated inode allocation path, an approach that avoids this
potential condition in the first place is preferred.

To address this situation, inode alignment is increased from cluster
size to chunk size (by mkfs) when sparse inode chunks are enabled. This
guarantees that the minimum block range between two non-adjacent inode
chunks is at least big enough for one full chunk. This greatly
simplifies sparse inode record management. Allocations occur at cluster
size granularity and are shifted into inode records that align to chunk
size. In other words, for any particular sparse allocation, a well known
record startino is determined by aligning the agbno of the allocation to
the chunk size.

The increased inode chunk alignment does limit the ability to allocate
full inode chunks on a significantly populated fs, but what is lost in
that regard is regained by the ability to allocate sparse records in any
AG that can satisfy the minimum free space requirement[1].

Other changes in this version include marking the feature as
experimental, a block allocation agbno range limit to avoid invalid
inode records at AG boundaries, DEBUG mode allocation logic to improve
test coverage, etc. This series survives xfstests regression runs on
basic v5 configurations as well as some longer term debug mode fsstress
testing. Thoughts, reviews, flames appreciated!

Brian

[1] - This can also be mitigated by future work to consider allocation
of inode chunks in batches rather than one at a time.

v3:
- Rebase to latest for-next (bulkstat rework, data structure shuffling,
  etc.).
- Fix issparse helper logic.
- Update inode alignment model w/ spinodes enabled. All inode records
  are chunk size aligned, sparse allocations cluster size aligned (both
  enforced on mount).
- Reworked sparse inode record merge logic to coincide w/ new alignment
  model.
- Mark feature as experimental (warn on mount).
- Include and use block allocation agbno range limit to prevent
  allocation of invalid inode records.
- Add some DEBUG bits to improve sparse alloc. test coverage.
v2: http://oss.sgi.com/archives/xfs/2014-11/msg00007.html
- Use a manually set feature bit instead of dynamic based on the
  existence of sparse inode chunks.
- Add sb/mp fields for sparse alloc. granularity (use instead of cluster
  size).
- Undo xfs_inobt_insert() loop removal to avoid breakage of larger page
  size arches.
- Rename sparse record overlap helper and do XFS_LOOKUP_LE search.
- Use byte of pad space in inobt record for inode count field.
- Convert bitmap mgmt to use generic bitmap code.
- Rename XFS_INODES_PER_SPCHUNK to XFS_INODES_PER_HOLEMASK_BIT.
- Add fs geometry bit for sparse inodes.
- Rebase to latest for-next (bulkstat refactor).
v1: http://oss.sgi.com/archives/xfs/2014-07/msg00355.html

Brian Foster (18):
  xfs: add sparse inode chunk alignment superblock field
  xfs: use sparse chunk alignment for min. inode allocation requirement
  xfs: sparse inode chunks feature helpers and mount requirements
  xfs: introduce inode record hole mask for sparse inode chunks
  xfs: create macros/helpers for dealing with sparse inode chunks
  xfs: pass inode count through ordered icreate log item
  xfs: handle sparse inode chunks in icreate log recovery
  xfs: helpers to convert holemask to/from generic bitmap
  xfs: support min/max agbno args in block allocator
  xfs: allocate sparse inode chunks on full chunk allocation failure
  xfs: randomly do sparse inode allocations in DEBUG mode
  xfs: filter out sparse regions from individual inode allocation
  xfs: update free inode record logic to support sparse inode records
  xfs: only free allocated regions of inode chunks
  xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()
  xfs: use actual inode count for sparse records in bulkstat/inumbers
  xfs: add fs geometry bit for sparse inode chunks
  xfs: enable sparse inode chunks for v5 superblocks

 fs/xfs/libxfs/xfs_alloc.c        |  42 ++-
 fs/xfs/libxfs/xfs_alloc.h        |   2 +
 fs/xfs/libxfs/xfs_format.h       |  33 +-
 fs/xfs/libxfs/xfs_fs.h           |   1 +
 fs/xfs/libxfs/xfs_ialloc.c       | 651 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_ialloc.h       |  17 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |   4 +-
 fs/xfs/libxfs/xfs_sb.c           |  31 +-
 fs/xfs/xfs_fsops.c               |   4 +-
 fs/xfs/xfs_inode.c               |  28 +-
 fs/xfs/xfs_itable.c              |  14 +-
 fs/xfs/xfs_log_recover.c         |  23 +-
 fs/xfs/xfs_mount.c               |  16 +
 fs/xfs/xfs_mount.h               |   2 +
 fs/xfs/xfs_trace.h               |  47 +++
 15 files changed, 836 insertions(+), 79 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
