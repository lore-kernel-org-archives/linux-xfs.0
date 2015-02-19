Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B85EF7F51
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 12:13:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A65EB30406A
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 10:13:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0dhefqSSPlzzxjwR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 10:13:46 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1JIDjGm014607
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:45 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t1JIDjiu015181
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:13:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5 00/18] xfs: sparse inode chunks
Date: Thu, 19 Feb 2015 13:13:25 -0500
Message-Id: <1424369623-5656-1-git-send-email-bfoster@redhat.com>
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

Here's v5 of sparse inode chunks. The only real change here is to
convert the allocmask helpers back to using the XFS bitmap helpers
rather than the generic bitmap code. This eliminates the need for the
endian-conversion hack and extra helper to export a generic bitmap to a
native type. The former users of the generic bitmap itself have been
converted to use the native 64-bit value appropriately.

The XFS bitmap code is actually not in userspace either so neither of
these implementations backport cleanly to userspace. As it is, I've not
included the sparse alloc/free code in my xfsprogs branch as this code
currently isn't needed. Nothing in userspace that I've seen requires the
ability to do a sparse inode allocation or free. I suspect if it is
needed in the future, we can more easily sync the XFS bitmap helpers to
userspace than the generic Linux bitmap code.

Thoughts, reviews, flames appreciated...

Brian

v5:
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

 fs/xfs/libxfs/xfs_alloc.c        |  42 +++-
 fs/xfs/libxfs/xfs_alloc.h        |   2 +
 fs/xfs/libxfs/xfs_format.h       |  50 +++-
 fs/xfs/libxfs/xfs_fs.h           |   1 +
 fs/xfs/libxfs/xfs_ialloc.c       | 530 +++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_ialloc.h       |  12 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |  93 ++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.h |  10 +
 fs/xfs/libxfs/xfs_sb.c           |  30 ++-
 fs/xfs/xfs_fsops.c               |   4 +-
 fs/xfs/xfs_inode.c               |  28 ++-
 fs/xfs/xfs_itable.c              |  13 +-
 fs/xfs/xfs_log_recover.c         |  26 +-
 fs/xfs/xfs_mount.c               |  16 ++
 fs/xfs/xfs_mount.h               |   2 +
 fs/xfs/xfs_trace.h               |  47 ++++
 16 files changed, 820 insertions(+), 86 deletions(-)

-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
