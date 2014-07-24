Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2BC4A7F3F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 11:28:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 19301304071
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:28:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fCF8BTYj9JFL37nq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 09:28:19 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OGSI1A001976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 12:28:18 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OGSHnS012498
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 12:28:17 -0400
Date: Thu, 24 Jul 2014 12:28:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC 00/18] xfs: sparse inode chunks
Message-ID: <20140724162815.GC37832@bfoster.bfoster>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 24, 2014 at 10:22:50AM -0400, Brian Foster wrote:
> Hi all,
> 
> This is a first pass at sparse inode chunk support for XFS. Some
> background on this work is available here:
> 
> http://oss.sgi.com/archives/xfs/2013-08/msg00346.html
> 
> The basic idea is to allow the partial allocation of inode chunks into
> fragmented regions of free space. This is accomplished through addition
> of a holemask field into the inobt record that defines what portion(s)
> of an inode chunk are invalid (i.e., holes in the chunk). This work is
> not quite complete, but is at a point where I'd like to start getting
> feedback on the design and what direction to take for some of the known
> gaps.
> 

I've attached a tarball to this message with a couple userspace patches
and an xfstests patch to facilitate experimentation. The userspace
patches update the inobt record data structure and add the holemask
field to xfs_db to facilitate poking around. Note that the rest of
userspace is untouched at this point, including repair being broken,
etc., so I don't recommend use beyond xfs_db.

The xfstests test case fragments free space, allocates inodes until
ENOSPC and expects to consume most of the free space available in the
fs. The "fragmentation factor" is currently dynamic and based on the
cluster size due to the cluster size scaling behavior documented below.

Finally, sparse inode chunks are only enabled for v5 superblocks, so a
crc enabled fs is required to test.

Brian

> The basic breakdown of functionality in this set is as follows:
> 
> - Patches 1-2 - A couple generic cleanups that are dependencies for later
>   patches in the series.
> - Patches 3-5 - Basic data structure update, feature bit and minor
>   helper introduction.
> - Patches 6-7 - Update v5 icreate logging and recovery to handle sparse
>   inode records.
> - Patches 8-13 - Allocation support for sparse inode records. Physical
>   chunk allocation and individual inode allocation.
> - Patches 14-16 - Deallocation support for sparse inode chunks. Physical
>   chunk deallocation, individual inode free and cluster free.
> - Patch 17 - Fixes for bulkstat/inumbers.
> - Patch 18 - Activate support for sparse chunk allocation and
>   processing.
> 
> This work is lightly tested for regression (some xfstests failures due
> to repair) and basic functionality. I have a new xfstests test I'll
> forward along for demonstration purposes.
> 
> Some notes on gaps in the design:
> 
> - Sparse inode chunk allocation granularity:
> 
> The current minimum sparse chunk allocation granularity is the cluster
> size. My initial attempts at this work tried to redefine to the minimum
> chunk length based on the holemask granularity (a la the stale macro I
> seemingly left in this series ;), but this involves tweaking the
> codepaths that use the cluster size (i.e., imap) which proved rather
> hairy. This also means we need a solution where an imap can change if an
> inode was initially mapped as a sparse chunk and said chunk is
> subsequently made full. E.g., we'd perhaps need to invalidate the inode
> buffers for sparse chunks at the time where they are made full. Given
> that, I landed on using the cluster size and leaving those codepaths as
> is for the time being.
> 
> There is a tradeoff here for v5 superblocks because we've recently made
> a change to scale the cluster size based on the factor increase in the
> inode size from the default (see xfsprogs commit 7b5f9801). This means
> that effectiveness of sparse chunks is tied to whether the level of free
> space fragmentation matches the cluster size. By that I mean effectivess
> is good (near 100% utilization possible) if free space fragmentation
> leaves free extents around that at least match the cluster size. If
> fragmentation is worse than the cluster size, effectiveness is reduced.
> This can also be demonstrated with the forthcoming xfstests test.
> 
> - On-disk lifecycle of the sparse inode chunks feature bit:
> 
> We set an incompatible feature bit once a sparse inode chunk is
> allocated because older revisions of code will interpret the non-zero
> holemask bits in the higher order bytes of the record freecount. The
> feature bit must be removed once all sparse inode chunks are eliminated
> one way or another. This series does not currently remove the feature
> bit once set simply because I hadn't thought through the mechanism quite
> yet. For the next version, I'm thinking about adding an inobt walk
> mechanism that can be conditionally invoked (i.e., feature bit is
> currently set and a sparse inode chunk has been eliminated) either via
> workqueue on an interval or during unmount if necessary. Thoughts or
> alternative suggestions on that appreciated.
> 
> That's about it for now. Thoughts, reviews, flames appreciated. Thanks.
> 
> Brian
> 
> Brian Foster (18):
>   xfs: refactor xfs_inobt_insert() to eliminate loop and support
>     variable count
>   xfs: pass xfs_mount directly to xfs_ialloc_cluster_alignment()
>   xfs: define sparse inode chunks v5 sb feature bit and helper function
>   xfs: introduce inode record hole mask for sparse inode chunks
>   xfs: create macros/helpers for dealing with sparse inode chunks
>   xfs: pass inode count through ordered icreate log item
>   xfs: handle sparse inode chunks in icreate log recovery
>   xfs: create helper to manage record overlap for sparse inode chunks
>   xfs: allocate sparse inode chunks on full chunk allocation failure
>   xfs: set sparse inodes feature bit when a sparse chunk is allocated
>   xfs: reduce min. inode allocation space requirement for sparse inode
>     chunks
>   xfs: helper to convert inobt record holemask to inode alloc. bitmap
>   xfs: filter out sparse regions from individual inode allocation
>   xfs: update free inode record logic to support sparse inode records
>   xfs: only free allocated regions of inode chunks
>   xfs: skip unallocated regions of inode chunks in xfs_ifree_cluster()
>   xfs: use actual inode count for sparse records in bulkstat/inumbers
>   xfs: enable sparse inode chunks for v5 superblocks
> 
>  fs/xfs/libxfs/xfs_format.h       |  17 +-
>  fs/xfs/libxfs/xfs_ialloc.c       | 441 +++++++++++++++++++++++++++++++++------
>  fs/xfs/libxfs/xfs_ialloc.h       |  17 +-
>  fs/xfs/libxfs/xfs_ialloc_btree.c |   4 +-
>  fs/xfs/libxfs/xfs_sb.h           |   9 +-
>  fs/xfs/xfs_inode.c               |  28 ++-
>  fs/xfs/xfs_itable.c              |  12 +-
>  fs/xfs/xfs_log_recover.c         |  23 +-
>  8 files changed, 460 insertions(+), 91 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--dTy3Mrz/UPE2dbVg
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="xfs_spinodes_user.tar.bz2"
Content-Transfer-Encoding: base64

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
UJAhNlHm

--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--dTy3Mrz/UPE2dbVg--
