Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D51517CA2
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:18:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69C50AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:18:01 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id yO4enlNFB0EpBWof (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:17:59 -0700 (PDT)
Subject: [PATCH v6 000/119] xfs: add reverse mapping, reflink, dedupe,
	and online scrub support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:17:53 -0700
Message-ID: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Hi all,

This is the sixth revision of a patchset that adds to XFS kernel
support for tracking reverse-mappings of physical blocks to file and
metadata (rmap); support for mapping multiple file logical blocks to
the same physical block (reflink); and implements the beginnings of
online metadata scrubbing.  Given the significant amount of design
assumptions that change with block sharing, rmap and reflink are
provided together.  There shouldn't be any incompatible on-disk format
changes, pending a thorough review of the patches within.

The reverse mapping implementation features a simple per-AG b+tree
containing tuples of (physical block, owner, offset, blockcount) with
the key being the first three fields.  The large record size will
enable us to reconstruct corrupt block mapping btrees (bmbt); the
large key size is necessary to identify uniquely each rmap record in
the presence of shared physical blocks.  In contrast to previous
iterations of this patchset, it is no longer a requirement that there
be a 1:1 correspondence between bmbt and rmapbt records; each rmapbt
record can cover multiple bmbt records.

The reflink implementation features a simple per-AG b+tree containing
tuples of (physical block, blockcount, refcount) with the key being
the physical block.  Copy on Write (CoW) is implemented by creating a
separate CoW fork and using the existing delayed allocation mechanism
to try to allocate as large of a replacement extent as possible before
committing the new data to media.  A CoW extent size hint allows
administrators to influence the size of the replacement extents, and
certain writes can be "promoted" to CoW when it would be advantageous
to reduce fragmentation.  The userspace interface to reflink and
dedupe are the VFS FICLONE, FICLONERANGE, and FIDEDUPERANGE ioctls,
which were previously private to btrfs.

Since the previous posting, I have made some major changes to the
underlying XFS common code.  First, I have extended the generic b+tree
implementation to support overlapping intervals, which is necessary
for the rmapbt on a reflink filesystem where there can be a number of
rmapbt records representing a physical block.  The new b+tree variant
introduces the notion of a "high key" for each record; it is the
highest key that can be used to identify a record.  On disk, an
overlapped-interval b+tree looks like a traditional b+tree except that
nodes store both the lowest key and the highest key accessible through
that subtree pointer.  There's a new interval query function that uses
both keys to iterate all records overlapping a given range of keys.
This change allows us to remove the old requirement that each bmbt
record correspond to a matching rmapbt record.

The second big change is to the xfs_bmap_free functions.  The existing
code implements a mechanism to defer metadata (specifically, free
space b+tree) updates across a transaction commit by logging redo
items that can be replayed during recovery.  It is an elegant way to
avoid running afoul of AG locking order rules /and/ it can in theory
be used to get around running out of transaction reservation.  That
said, I have refactored it into a generic "deferred operations"
mechanism that can defer arbitrary types of work to a subsequent
rolled transaction.  The framework thus allows me to schedule rmapbt,
refcountbt, and bmbt updates while maintaining correct redo in case of
failure.  Remapping activities for reflink and CoW are now atomic.

The third big change is the establishment of a per-AG block
reservation mechanism.  This "hides" some blocks from the regular
block allocator; refcountbt and rmapbt expansions use these blocks to
handle the removal of the assumption that file mapping operations
always involve block allocation.  This gets us into trouble when a
file allocates an entire AG, is reflinked by other files, and
subsequent CoWs cause record splits in the rmap and reflink btrees.

At the very end of the patchset is an initial implementation of a
GETFSMAPX ioctl for userland to query the physical block mapping of a
filesystem; and metadata scrubbing for XFS.  The scrubber iterates
the per-AG btrees and does some simple cross-checking when possible;
I built it to check the functionality of the new b+tree code.

The first few patches fix various vfs/xfs bugs, adds an enhancement to
the xfs_buf tracepoints so that we can analyze buffer deadlocks, and
merges difference between the kernel and userspace libxfs so that the
rest of the patches apply consistently.

There are still two functionality gaps: the extent swap ioctl isn't
functional when rmap is enabled; and rmap cannot (yet) coexist with
realtime devices.  These will be addressed in the next sprint.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
There are also updates for xfs-docs[4].  The kernel patches should
apply to dchinner's for-next; xfsprogs patches to for-next; and
xfstest to master.  NOTE however that the kernel git tree already has
the five for-next patches included.

The patches have been xfstested with x64, i386, and armv7l--arm64,
ppc64, and ppc64le no longer boot in qemu.  All three architectures
pass all 'clone' group tests except xfs/128 (which is the swapext
test), and AFAICT don't cause any new failures for the 'auto' group.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/djwong-devel
[2] https://github.com/djwong/xfsprogs/tree/djwong-devel
[3] https://github.com/djwong/xfstests/tree/djwong-devel
[4] https://github.com/djwong/xfs-documentation/tree/djwong-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
