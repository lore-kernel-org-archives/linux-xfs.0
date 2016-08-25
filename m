Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2206F7CD2
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:32:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7D88BAC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:32:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Mt5E3ClaLQJl8qab (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:32:05 -0700 (PDT)
Subject: [PATCH v8 00/71] xfs: add reflink and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:31:56 -0700
Message-ID: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Hi all,

This is the eighth revision of a patchset that adds to XFS kernel
support for mapping multiple file logical blocks to the same physical
block (reflink/deduplication), implements the beginnings of online
metadata scrubbing and preening, and implements reverse mapping for
the realtime device.  There shouldn't be any incompatible on-disk
format changes, pending a thorough review of the patches within.

(NOTE: In the git trees, this series is preceded by the pending rmap
fixes patches posted to linux-xfs a few days ago.)

The reflink implementation features a simple per-AG b+tree containing
tuples of (physical block, blockcount, refcount) with the key being
the physical block.  Copy on Write (CoW) is implemented by creating a
separate CoW extent mapping fork and using the existing delayed
allocation mechanism to try to allocate as large of a replacement
extent as possible before committing the new data to media.  A CoW
extent size hint allows administrators to influence the size of the
replacement extents, and certain writes can be "promoted" to CoW when
it would be advantageous to reduce fragmentation.  The userspace
interface to reflink and dedupe are the VFS FICLONE, FICLONERANGE, and
FIDEDUPERANGE ioctls, which were previously private to btrfs.

At the beginning of the patchset is the establishment of a per-AG
block reservation mechanism.  This "hides" some blocks from the
regular block allocator so that the refcountbt and rmapbt can expand
without hitting ENOSPC.  The block reservation mechanism built into
transactions isn't sufficient for this purpose because it only
reserves blocks at a broad filesystem level, whereas per-AG btree
expansion requires specific per-AG reservations.

Next comes the reference count B+tree, which tracks the reference
counts of shared extents (refcount > 1) and extents being used to
stage a copy-on-write operation (refcount == 1).  We define new log
redo item pairs both for refcount updates and for inode fork updates;
these plug into the deferred ops framework created for the reverse
mapping patches.

After that comes the reflink code, which handles the actual
copy-on-write behavior that is required for block sharing; and
connections to the VFS file ops for reflink, dedupe, and
copy_file_range.

At the very end of the patchset is a reimplementation of the swap
extents code that uses reverse mapping and block mapping deferred ops
to implement xfs_swap_extent for filesystems with reverse-mapping.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3],
xfs-docs[4], and man-pages[5].  The kernel patches in the git trees
should apply to 4.8-rc3; xfsprogs patches to for-next; and xfstest to
master.

The patches have been xfstested with x64, ppc64, and armhf; all tests
in the clone and rmap groups pass.  AFAICT they don't cause any new
failures for the 'auto' group.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/djwong-devel
[2] https://github.com/djwong/xfsprogs/tree/djwong-devel
[3] https://github.com/djwong/xfstests/tree/djwong-devel
[4] https://github.com/djwong/xfs-documentation/tree/djwong-devel
[5] https://github.com/djwong/man-pages/tree/djwong-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
