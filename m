Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B22F17F47
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:51:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 833F8304043
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:51:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mzrdLROQNHAHidDC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:51:13 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OEpCom008437
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:51:12 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OEN9mm030704
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 00/18] xfs: sparse inode chunks
Date: Thu, 24 Jul 2014 10:22:50 -0400
Message-Id: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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

This is a first pass at sparse inode chunk support for XFS. Some
background on this work is available here:

http://oss.sgi.com/archives/xfs/2013-08/msg00346.html

The basic idea is to allow the partial allocation of inode chunks into
fragmented regions of free space. This is accomplished through addition
of a holemask field into the inobt record that defines what portion(s)
of an inode chunk are invalid (i.e., holes in the chunk). This work is
not quite complete, but is at a point where I'd like to start getting
feedback on the design and what direction to take for some of the known
gaps.

The basic breakdown of functionality in this set is as follows:

- Patches 1-2 - A couple generic cleanups that are dependencies for later
  patches in the series.
- Patches 3-5 - Basic data structure update, feature bit and minor
  helper introduction.
- Patches 6-7 - Update v5 icreate logging and recovery to handle sparse
  inode records.
- Patches 8-13 - Allocation support for sparse inode records. Physical
  chunk allocation and individual inode allocation.
- Patches 14-16 - Deallocation support for sparse inode chunks. Physical
  chunk deallocation, individual inode free and cluster free.
- Patch 17 - Fixes for bulkstat/inumbers.
- Patch 18 - Activate support for sparse chunk allocation and
  processing.

This work is lightly tested for regression (some xfstests failures due
to repair) and basic functionality. I have a new xfstests test I'll
forward along for demonstration purposes.

Some notes on gaps in the design:

- Sparse inode chunk allocation granularity:

The current minimum sparse chunk allocation granularity is the cluster
size. My initial attempts at this work tried to redefine to the minimum
chunk length based on the holemask granularity (a la the stale macro I
seemingly left in this series ;), but this involves tweaking the
codepaths that use the cluster size (i.e., imap) which proved rather
hairy. This also means we need a solution where an imap can change if an
inode was initially mapped as a sparse chunk and said chunk is
subsequently made full. E.g., we'd perhaps need to invalidate the inode
buffers for sparse chunks at the time where they are made full. Given
that, I landed on using the cluster size and leaving those codepaths as
is for the time being.

There is a tradeoff here for v5 superblocks because we've recently made
a change to scale the cluster size based on the factor increase in the
inode size from the default (see xfsprogs commit 7b5f9801). This means
that effectiveness of sparse chunks is tied to whether the level of free
space fragmentation matches the cluster size. By that I mean effectivess
is good (near 100% utilization possible) if free space fragmentation
leaves free extents around that at least match the cluster size. If
fragmentation is worse than the cluster size, effectiveness is reduced.
This can also be demonstrated with the forthcoming xfstests test.

- On-disk lifecycle of the sparse inode chunks feature bit:

We set an incompatible feature bit once a sparse inode chunk is
allocated because older revisions of code will interpret the non-zero
holemask bits in the higher order bytes of the record freecount. The
feature bit must be removed once all sparse inode chunks are eliminated
one way or another. This series does not currently remove the feature
bit once set simply because I hadn't thought through the mechanism quite
yet. For the next version, I'm thinking about adding an inobt walk
mechanism that can be conditionally invoked (i.e., feature bit is
currently set and a sparse inode chunk has been eliminated) either via
workqueue on an interval or during unmount if necessary. Thoughts or
alternative suggestions on that appreciated.

That's about it for now. Thoughts, reviews, flames appreciated. Thanks.

Brian

Brian Foster (18):
  xfs: refactor xfs_inobt_insert() to eliminate loop and support
    variable count
  xfs: pass xfs_mount directly to xfs_ialloc_cluster_alignment()
  xfs: define sparse inode chunks v5 sb feature bit and helper function
  xfs: introduce inode record hole mask for sparse inode chunks
  xfs: create macros/helpers for dealing with sparse inode chunks
  xfs: pass inode count through ordered icreate log item
  xfs: handle sparse inode chunks in icreate log recovery
  xfs: create helper to manage record overlap for sparse inode chunks
  xfs: allocate sparse inode chunks on full chunk allocation failure
  xfs: set sparse inodes feature bit when a sparse chunk is allocated
  xfs: reduce min. inode allocation space requirement for sparse inode
    chunks
  xfs: helper to convert inobt record holemask to inode alloc. bitmap
  xfs: filter out sparse regions from individual inode allocation
  xfs: update free inode record logic to support sparse inode records
  xfs: only free allocated regions of inode chunks
  xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()
  xfs: use actual inode count for sparse records in bulkstat/inumbers
  xfs: enable sparse inode chunks for v5 superblocks

 fs/xfs/libxfs/xfs_format.h       |  17 +-
 fs/xfs/libxfs/xfs_ialloc.c       | 441 +++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_ialloc.h       |  17 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |   4 +-
 fs/xfs/libxfs/xfs_sb.h           |   9 +-
 fs/xfs/xfs_inode.c               |  28 ++-
 fs/xfs/xfs_itable.c              |  12 +-
 fs/xfs/xfs_log_recover.c         |  23 +-
 8 files changed, 460 insertions(+), 91 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
