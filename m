Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE41A7F57
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 10:12:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7761B30404E
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2014 08:12:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xckFTLW6IFuCD9h9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Nov 2014 08:12:29 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sA3GCSff027586
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:28 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id sA3GCRHA017036
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2014 11:12:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 00/17] xfs: sparse inode chunks
Date: Mon,  3 Nov 2014 11:12:09 -0500
Message-Id: <1415031146-9107-1-git-send-email-bfoster@redhat.com>
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

Here's another pass of sparse inode chunk support. There are still some
outstanding things to resolve, but I think this hits on some of the
larger comments of v1 and serves as a decent checkpoint.

My biggest open question at this point is how to handle backwards
compatibility in relation to the behavior of the new ir_count field
introduced in v2. The current behavior is to use ir_count whenever
sparse inode chunk support is enabled (from a feature bit perspective,
see xfs_inobt_insert()). The side effect of this is that backwards
compatibility is no longer solely tied to the existence of sparse inode
chunks. In other words, we cannot simply toggle off a feature bit for
fs' without sparse inode allocations, as the existing allocations have
an ir_count == 64 value in the upper bytes of the old ir_free field.

We can follow a couple alternate directions that I can think of:

- Only use ir_count for actual sparse chunks. E.g., ir_count == 0 for
  chunks with XFS_INODES_PER_CHUNK inodes. 
- Always use ir_count when feature bit enabled, consider inverting
  ir_holemask to ir_allocmask or some such to simplify.

The further I progress on this work, the more I think the backwards
compatibility has limited utility, poor cost-benefit and I lean towards
the second approach.

That said, I don't necessarily see a problem with retaining the
backwards compatible nature of the on-disk structures with the
understanding that the ability for such conversions probably will not be
provided in the near term. E.g., backwards compat. simply becomes a
design characteristic to leave the window open for future work. But I'm
also not a huge fan of letting some unknown conversion mechanism from
the future put too many constraints on simplification of an existing
design. E.g., what's the point if the end result ends up being some kind
of userspace conversion via xfs_repair (for example) that can track
sparse chunks and fix up the records appropriately?

Thoughts?

Brian

v2:
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

Brian Foster (17):
  xfs: add sparse inode chunk alignment superblock field
  xfs: use sparse chunk alignment for min. inode allocation requirement
  xfs: define sparse inode chunks v5 sb feature bit and helper function
  xfs: introduce inode record hole mask for sparse inode chunks
  xfs: create macros/helpers for dealing with sparse inode chunks
  xfs: pass inode count through ordered icreate log item
  xfs: handle sparse inode chunks in icreate log recovery
  xfs: create helper to manage record overlap for sparse inode chunks
  xfs: allocate sparse inode chunks on full chunk allocation failure
  xfs: helpers to convert holemask to/from generic bitmap
  xfs: filter out sparse regions from individual inode allocation
  xfs: update free inode record logic to support sparse inode records
  xfs: only free allocated regions of inode chunks
  xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()
  xfs: use actual inode count for sparse records in bulkstat/inumbers
  xfs: add fs geometry bit for sparse inode chunks
  xfs: enable sparse inode chunks for v5 superblocks

 fs/xfs/libxfs/xfs_format.h       |  17 +-
 fs/xfs/libxfs/xfs_ialloc.c       | 456 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_ialloc.h       |  17 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |   4 +-
 fs/xfs/libxfs/xfs_sb.c           |   9 +-
 fs/xfs/libxfs/xfs_sb.h           |  16 +-
 fs/xfs/xfs_fs.h                  |   1 +
 fs/xfs/xfs_fsops.c               |   4 +-
 fs/xfs/xfs_inode.c               |  28 ++-
 fs/xfs/xfs_itable.c              |  16 +-
 fs/xfs/xfs_log_recover.c         |  23 +-
 fs/xfs/xfs_mount.h               |   2 +
 12 files changed, 525 insertions(+), 68 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
