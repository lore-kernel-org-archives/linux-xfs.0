Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 718D47F5D
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 12:17:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B2EC8F8071
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 10:17:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vuMpJyaS6BcMDXT6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 12 Feb 2015 10:17:29 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1CIHSId015115
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:28 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1CIHSWm030635
	for <xfs@oss.sgi.com>; Thu, 12 Feb 2015 13:17:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 00/18] xfs: sparse inode chunks
Date: Thu, 12 Feb 2015 13:17:07 -0500
Message-Id: <1423765045-15791-1-git-send-email-bfoster@redhat.com>
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

Here's v4 of sparse inode support for XFS. The changes are primarily
based on Dave's review comments from v3. The highlights are a refactor
of the on-disk inobt record format and sparse inode chunk allocation and
record management code.

The inobt record refactor introduces a union to distinguish the original
on-disk format from the new format and an associated change in behavior
where the in-core record fields can be unconditionally considered valid.
For example, higher level code can refer to the in-core ir_count field
regardless of whether the sparse inodes feature is enabled or not. This
reduces the need for helpers and sb feature check clutter throughout the
code.

The sparse chunk allocation refactor cleans up the sparse record
management code such that record merge and inobt updates do not involve
multiple tree lookups. It also condenses the sparse record management
code into a single helper (a la xfs_inobt_insert() for full inode
chunks) that can be used for the inobt and finobt.

Patches 1-3 are generic preparation patches that do not depend on sparse
inode bits. Patches 4-7 introduce the sb alignment field, mount feature
helpers and associated bits. Patches 8-12 introduce the inobt record
data structure update and associated bits/helpers. Patches 13-17
implement the sparse chunk and individual inode allocation and free
mechanisms. Finally, patch 18 enables the ability to mount sparse inode
enabled filesystems.

Thoughts, reviews, flames appreciated...

Brian

v4:
- Rename sb_spinoalignmt to sb_spino_align.
- Clean up error/warning messages.
- Use a union to differentiate old/new xfs_inobt_rec on-disk format.
  Refactor such that in-core record fields are always valid.
- Rename/move allocmap (bitmap) helper functions and provide extra
  helper for endian conv.
- Refactor sparse chunk allocation record management code.
- Clean up #ifdef and label usage for DEBUG mode sparse allocs.
- Split up and moved some generic, preparatory hunks earlier in series.
v3: http://oss.sgi.com/archives/xfs/2015-02/msg00110.html
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
  xfs: create individual inode alloc. helper
  xfs: update free inode record logic to support sparse inode records
  xfs: support min/max agbno args in block allocator
  xfs: add sparse inode chunk alignment superblock field
  xfs: use sparse chunk alignment for min. inode allocation requirement
  xfs: sparse inode chunks feature helpers and mount requirements
  xfs: add fs geometry bit for sparse inode chunks
  xfs: introduce inode record hole mask for sparse inode chunks
  xfs: use actual inode count for sparse records in bulkstat/inumbers
  xfs: pass inode count through ordered icreate log item
  xfs: handle sparse inode chunks in icreate log recovery
  xfs: helpers to convert holemask to/from generic bitmap
  xfs: allocate sparse inode chunks on full chunk allocation failure
  xfs: randomly do sparse inode allocations in DEBUG mode
  xfs: filter out sparse regions from individual inode allocation
  xfs: only free allocated regions of inode chunks
  xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()
  xfs: enable sparse inode chunks for v5 superblocks

 fs/xfs/libxfs/xfs_alloc.c        |  42 ++-
 fs/xfs/libxfs/xfs_alloc.h        |   2 +
 fs/xfs/libxfs/xfs_format.h       |  50 +++-
 fs/xfs/libxfs/xfs_fs.h           |   1 +
 fs/xfs/libxfs/xfs_ialloc.c       | 533 +++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_ialloc.h       |  12 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c | 123 ++++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.h |  14 +
 fs/xfs/libxfs/xfs_sb.c           |  30 ++-
 fs/xfs/xfs_fsops.c               |   4 +-
 fs/xfs/xfs_inode.c               |  28 +-
 fs/xfs/xfs_itable.c              |  13 +-
 fs/xfs/xfs_log_recover.c         |  26 +-
 fs/xfs/xfs_mount.c               |  16 ++
 fs/xfs/xfs_mount.h               |   2 +
 fs/xfs/xfs_trace.h               |  47 ++++
 16 files changed, 857 insertions(+), 86 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
