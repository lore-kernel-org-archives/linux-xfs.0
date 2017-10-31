Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19928 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752473AbdJaW6H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 18:58:07 -0400
Date: Wed, 1 Nov 2017 09:58:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: flush the range before zero partial block range on
 truncate down
Message-ID: <20171031225804.GF5858@dastard>
References: <20171027125328.25001-1-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027125328.25001-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 27, 2017 at 08:53:28PM +0800, Eryu Guan wrote:
> On truncate down, if new size is not block size aligned, we zero the
> rest of block via iomap_truncate_page() to avoid exposing stale data
> to user, and iomap_truncate_page() skips zeroing if the range is
> already in unwritten status or a hole.

Unless the page is in the page cache already, and then it gets
zeroed in memory as part of truncate_setsize() call.

> But it's possible that a buffer write overwrites the unwritten
> extent, which won't be converted to a normal extent until I/O
> completion, and iomap_truncate_page() skips zeroing wrongly because
> of the not-converted unwritten extent. This would cause a subsequent
> mmap read sees non-zeros beyond EOF.

Yes, it should skip the zeroing on disk. The page in the page cache
over the unwritten extent will be zeroed on read.

The real question is this: where are the zeros in the page that fsx
is complaining about?

> I occasionally see this in fsx runs in fstests generic/112, a
> simplified fsx operation sequence is like (assuming 4k block size
> xfs):

What should have is:

>   fallocate 0x0 0x1000 0x0 keep_size

Unwritten, no data.

>   write 0x0 0x1000 0x0

Unwritten, contains data in page cache.

>   truncate 0x0 0x800 0x1000

Unwritten, page contains data 0-0x800, zeros 0x800-0x1000

>   punch_hole 0x0 0x800 0x800

Unwritten, page contains zeros 0x0-0x1000

>   mapread 0x0 0x800 0x800

Should map a page full of zeros as it is either a read over an
unwritten extent or a hole, or it finds a page cache page that is
fully zeroed.

The only wrinkle in this is if the write is direct IO, but
then the truncate would see a written extent and this whole problem
doesn't occur.

So, more info required. :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
