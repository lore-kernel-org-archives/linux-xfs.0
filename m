Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F31F7F67
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 07:28:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F2CEC8F8068
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 05:28:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id aUvAYy4lAZ8Dwx0M (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 05:28:10 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t22DS90A010011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:09 -0500
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t22DS8O3012615
	for <xfs@oss.sgi.com>; Mon, 2 Mar 2015 08:28:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v6 00/18] xfs: sparse inode chunks
Date: Mon,  2 Mar 2015 08:27:50 -0500
Message-Id: <1425302888-4962-1-git-send-email-bfoster@redhat.com>
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

Here's a v6 of sparse inode chunks. This fixes a bug on large block size
filesystems where an inode chunk was being incorrectly freed. The
problem was that patch 2 changed the previously implicit behavior of
never freeing an inode chunk on filesystems where the block size is
large enough for multiple chunks (e.g., bsize=64k, isize<=512). Patch 2
has been fixed to preserve original behavior.

There have also been some minor fixups throughout associated with a
rebase to the latest for-next. This includes killing some old sb logging
bits and passing mp to XFS_WANT_CORRUPTED_GOTO().

Brian

v6:
- Rebase to latest for-next (minor fixups).
- Fix corruption bug on multi-inode-chunk per block fs (patch 2).
v5: http://oss.sgi.com/archives/xfs/2015-02/msg00371.html
- Use XFS helpers for allocmask code instead of generic bitmap helpers.
v4: http://oss.sgi.com/archives/xfs/2015-02/msg00240.html
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
  xfs: helper to convert holemask to inode alloc. bitmap
  xfs: allocate sparse inode chunks on full chunk allocation failure
  xfs: randomly do sparse inode allocations in DEBUG mode
  xfs: filter out sparse regions from individual inode allocation
  xfs: only free allocated regions of inode chunks
  xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()
  xfs: enable sparse inode chunks for v5 superblocks

 fs/xfs/libxfs/xfs_alloc.c        |  42 ++-
 fs/xfs/libxfs/xfs_alloc.h        |   2 +
 fs/xfs/libxfs/xfs_format.h       |  48 +++-
 fs/xfs/libxfs/xfs_fs.h           |   1 +
 fs/xfs/libxfs/xfs_ialloc.c       | 541 +++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_ialloc.h       |  12 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |  93 ++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.h |  10 +
 fs/xfs/libxfs/xfs_sb.c           |  30 ++-
 fs/xfs/xfs_fsops.c               |   4 +-
 fs/xfs/xfs_inode.c               |  28 +-
 fs/xfs/xfs_itable.c              |  13 +-
 fs/xfs/xfs_log_recover.c         |  26 +-
 fs/xfs/xfs_mount.c               |  16 ++
 fs/xfs/xfs_mount.h               |   2 +
 fs/xfs/xfs_trace.h               |  47 ++++
 16 files changed, 829 insertions(+), 86 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
