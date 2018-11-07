Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:27974 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726298AbeKGQBN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:13 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 00/16] xfs: Block size > PAGE_SIZE support
Date: Wed,  7 Nov 2018 17:31:11 +1100
Message-Id: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Hi folks,

We've had a fair number of problems reported on 64k block size
filesystems of late, but none of the XFS developers have Power or
ARM machines handy to reproduce them or even really test the fixes.

The iomap infrastructure we introduced a while back was designed
with the capabity of block size > page size support in mind, but we
hadn't tried to implement it.

So after another 64k block size bug report late last week I said to
Darrick "How hard could it be"?

About 6 billion (yes, B) fsx ops later, I have most of the XFS
functionality working on 64k block sizes on x86_64.  Buffered
read/write, mmap read/write and direct IO read/write all work. All
the fallocate() operations work correctly, as does truncate. xfsdump
and xfs_restore are happy with it, as is xfs_repair. xfs-scrub
needed some help, but I've tested Darrick's fixes for that quite a
bit over the past few days.

It passes most of xfstests - there's some test failures that I have
to determine whether they are code bugs or test problems (i.e. some
tests don't deal with 64k block sizes correctly or assume block size
<= page size).

What I haven't tested yet is shared extents - the COW path,
clone_file_range and dedupe_file_range. I discovered earlier today
that fsx doesn't support copy/clone/dedupe_file_operations
operations, so before I go any further I need to enxpahnce fsx. Then
fix all the bugs it uncovers on block size <= page size filesystems.
And then I'll move onto adding the rest of the functionality this
patch set requires.

The main addition to the iomap code to support this functionality is
the "zero-around" capability. When the filesystem is mapping a new
block, a delalloc range or an unwritten extent, it sets the
IOMAP_F_ZERO_AROUND flag in the iomap it returns. This tells the
iomap code that it needs to expand the range of the operation being
performed to cover entire blocks. i.e. if the data being written
doesn't span the filesystem block, it needs to instantiate and zero
pages in the page cache to cover the portions of the block the data
doesn't cover.

Because the page cache may already hold data for the regions (e.g.
read over a hole/unwritten extent) the zero-around code does not
zero pages that are already marked up to date. It is assumed that
whatever put those pages into the page cache has already done the
right thing with them.

Yes, this means the unit of page cache IO is still individual pages.
There are no mm/ changes at all, no page cache changes, nothing.
That all still just operates on individual pages and is oblivious to
the fact the filesystem/iomap codeis now processing gangs of pages
at a time instead of just one.

Actually, I stretch the truth there a little - there is one change
to XFS that is important to note here. I removed ->writepage from
XFS (patches 1 and 2). We can't use it for large block sizes because
we want to write whole blocks at a time if they are newly allocated
or unwritten. And really, it's just a nasty hack that gets in the
way of background writeback doing an efficient job of cleaning dirty
pages. So I killed it.

We also need to expose the large block size to stat(2). If we don't,
the applications that use stat.st_bsize for operations that require
block size alignment (e.g. various fallocate ops) then fail because
4k is not the block size of a 64k block size filesystem.

A number of latent bugs in existing code were uncovered as I worked
through this - patches 3-5 fix bugs in XFS and iomap that can be
triggered on existing systems but it's somewhat hard to expose them.

Patches 6-12 introduce all the iomap infrastructure needed to
support block size > page size.

Patches 13-16 introduce the necessary functionality to trigger the
iompa infrastructure, tell userspace the right thing, make sub-block
fsync ranges do the right thing and finally remove the code that
prevents large block size filesystems from mounting on small page
size machines.

It works, it seems pretty robust and runs enough of fstests that
I've already used it to find, fix and test a 64k block size bug in
XFS:

https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git/commit/?h=for-next&id=837514f7a4ca4aca06aec5caa5ff56d33ef06976

I think this is the last of the XFS Irix features we haven't
implemented in Linux XFS - it's only taken us 20 years to
get here, but the end of the tunnel is in sight.

Nah, it's probably a train. Or maybe a flame. :)

Anyway, I'm interested to see what people think of the approach.

Cheers,

Dave.
