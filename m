Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18638 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756169AbcI1Cxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:53:35 -0400
Subject: [PATCH v9 00/63] xfs: add reflink and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:53:30 -0700
Message-ID: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

This is the ninth revision of a patchset that adds to XFS kernel
support for mapping multiple file logical blocks to the same physical
block (reflink/deduplication).  There shouldn't be any incompatible on-disk
format changes, pending a thorough review of the patches within.

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

The patches contained within are also available as git trees.  The
kernel patches[1] apply against Dave Chinner's for-next branch, and for
user tools you'll want to use the xfsprogs dev branch[2].  I do not
intend to mail out userspace patches until after the merge window and
libxfs-apply resync happens.  The clone group xfstests should all pass.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave-for-4.9-7
[2] https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-5
