Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5DF7B7F5D
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:56:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E546CAC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:31 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zeHIc2Z6FI2VE11W (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:29 -0800 (PST)
Subject: [RFCv4 00/76] xfs: add reverse-mapping, reflink, and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:56:23 -0800
Message-ID: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Hi all,

This is the fourth revision of an RFC for adding to XFS kernel support
for tracking reverse-mappings of physical blocks to file and metadata;
and support for mapping multiple file logical blocks to the same
physical block, more commonly known as reflinking.  Given the
significant amount of re-engineering required to make the initial rmap
implementation compatible with reflink, I decided to publish both
features as an integrated patchset off of upstream.  This means that
rmap and reflink are now compatible with each other.

Since the previous RFC, I've integrated Anna Schumaker and Christoph
Hellwig's patches to hoist the reflink ioctls into the VFS, and done
the same to the dedupe ioctl.  These patches were posted separately to
a wider list, and are a build requirement for this patch set.

Dave Chinner's initial rmap implementation featured a simple b+tree
containing (_physical_block_, blockcount, owner) records and enough
code to stuff the rmap btree (rmapbt) whenever a block was allocated
or freed.  However, a generic reflink implementation requires the
ability to map a block to any logical block offset in any file.
Therefore it is necessary to expand the rmapbt record definition to be
(_physical block_, _owner_, _offset_, blockcount) to maintain uniquely
identifiable records.  The upper two bits of the offset field are used
to flag attr fork records and bmbt block records, respectively.  The
highest bit of the blockcount is used to indicate an unwritten extent.
It is intended that in the future the rmapbt will some day be used to
reconstruct a corrupt block map btree (bmbt).

The reflink implementation features a simple b+tree containing
(_physical block_, blockcount, refcount) records to track the
reference counts of extents of physical blocks.  There's also support
code to provide the desired copy-on-write behavior and the userland
interfaces to reflink, query the status of, and a new fallocate mode
to un-reflink parts of files.

For single-owner blocks (i.e. metadata) the rmapbt records are still
managed at alloc/free time.  To enable reflink and rmap at the same
time, however, it becomes necessary to manage rmapbt records for file
extents at map/unmap time.  In the current implementation, file extent
records exactly mirror bmbt contents.  It should be easy to merge
file extent rmaps on non-reflink filesystems, but that is not yet
written.  In theory merging can happen for file extent rmaps on
reflink filesystems too, but that could involve a lot of searching
through the tree since records are not indexed on the last physical
block of the extent.

The ioctl interface to XFS reflink looks surprisingly like the btrfs
ioctl interface -- you can reflink a file, reflink subranges
of a file, or dedupe subranges of files.  To un-reflink a file, I'm
proposing a new fallocate flag which will (try to) fork all shared
blocks within a certain file range.  xfs_fsr is a better candidate
for de-reflinking a file since it also defragments the file; the
extent swap ioctl has also been upgraded (crappily) to support
updating the rmapbt as needed.

The patch set is based on the current (4.4-rc5) upstream kernel.
There are plenty of bugs in this code.  There are too many patches to
discuss individually, but they are grouped by subject area:

1. Cleanups
2. rmapbt support
3. Re-engineering rmapbt to support reflink
4. refcntbt support
5. Implement the data block sharing pieces of reflink
6. Reflink/dedupe control for userspace

Fixed since RFCv3:

 * The reflink and dedupe ioctls are being hoisted to the VFS, as
   provided in the first few patches.  Patch 81 connects to this
   functionality.

 * Copy on write has been rewritten for v4.  We now use the existing
   delayed allocation mechanism to coalesce writes together, deferring
   allocation until writeout time.  This enables CoW to make better
   block placement decisions and significantly reduces overhead.
   CoW is still pretty slow, but not as slow as before.

 * Direct IO CoW has been implemented using the same mechanism as
   above, but modified to perform the allocation and remapping right
   then and there.  Throughput is much higher than pushing data
   through the page cache CoW.  (It's the same mechanism, but we're
   playing with chunks bigger than a single memory page.)

 * CoW ENOSPC works correctly now, except in the pathological case
   that the AG fills up and the rmap btree cannot expand.  That will
   be addressed for v5.

 * fallocate will now unshare blocks to prevent future ENOSPC, as
   you'd expect.

 * refcount btree blocks are preallocated at mount time to prevent
   ENOSPC while trying to expand the tree.  This also has the effect
   of grouping the btree blocks together, which can speed up CoW
   remapping.

Issues: 

 * The extent swapping ioctl still allocates a bigger fixed-size
   transaction.  That's most likely a stupid thing to do, so getting a
   better grip on how the journalling code works and auditing all the
   new transaction users will have to happen.  Right now it mostly
   gets lucky.

 * EFI tracking for the allocated-but-not-yet-mapped blocks is
   nonexistant.  A crash will leak them.

 * ENOSPC while expanding the rmap btree can crash the FS.  For now we
   work around this problem by making the AGFL as big as possible,
   failing CoW attempts with ENOSPC if there aren't enough AGFL blocks
   available, and hoping that doesn't actually happen.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
There are also updates for xfs-docs[4] and man-pages[5].

The patches have been xfstested with x64, i386, and ppc64; while in
general the tests run to completion, there are still periodic bugs
that will be addressed by the next RFC.  There's a persistent crash on
arm64 and ppc64el that I haven't been able to triage.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave
[2] https://github.com/djwong/xfsprogs/tree/for-dave
[3] https://github.com/djwong/xfstests/tree/for-dave
[4] https://github.com/djwong/xfs-documentation/tree/for-dave
[5] https://github.com/djwong/man-pages/commits/for-mtk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
