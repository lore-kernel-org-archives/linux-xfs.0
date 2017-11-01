Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751390AbdKADql (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 23:46:41 -0400
Date: Wed, 1 Nov 2017 11:46:39 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: flush the range before zero partial block range on
 truncate down
Message-ID: <20171101034639.GP17339@eguan.usersys.redhat.com>
References: <20171027125328.25001-1-eguan@redhat.com>
 <20171031225804.GF5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031225804.GF5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2017 at 09:58:04AM +1100, Dave Chinner wrote:
> On Fri, Oct 27, 2017 at 08:53:28PM +0800, Eryu Guan wrote:
> > On truncate down, if new size is not block size aligned, we zero the
> > rest of block via iomap_truncate_page() to avoid exposing stale data
> > to user, and iomap_truncate_page() skips zeroing if the range is
> > already in unwritten status or a hole.
> 
> Unless the page is in the page cache already, and then it gets
> zeroed in memory as part of truncate_setsize() call.
> 
> > But it's possible that a buffer write overwrites the unwritten
> > extent, which won't be converted to a normal extent until I/O
> > completion, and iomap_truncate_page() skips zeroing wrongly because
> > of the not-converted unwritten extent. This would cause a subsequent
> > mmap read sees non-zeros beyond EOF.
> 
> Yes, it should skip the zeroing on disk. The page in the page cache
> over the unwritten extent will be zeroed on read.
> 
> The real question is this: where are the zeros in the page that fsx
> is complaining about?

The partial block that iomap_truncate_page() skipped zeroing was latter
written back to disk, and the punch_hole before mmap read invalidated
the page cache so mmap read from disk and saw non-zeros. This is a
hard-to-hit sequence, it took me almost 2000 iterations of generic/112
runs to hit one failure. I'll provide more details below.

> 
> > I occasionally see this in fsx runs in fstests generic/112, a
> > simplified fsx operation sequence is like (assuming 4k block size
> > xfs):
> 
> What should have is:
> 
> >   fallocate 0x0 0x1000 0x0 keep_size
> 
> Unwritten, no data.

Yes, assuming 4k block size and 4k page size, unwritten extent with 1
block allocated, i_size stays 0.

> 
> >   write 0x0 0x1000 0x0
> 
> Unwritten, contains data in page cache.

Exactly, and in-core i_size is 4k now, but on-disk di_size is still 0.

> 
> >   truncate 0x0 0x800 0x1000
> 
> Unwritten, page contains data 0-0x800, zeros 0x800-0x1000

Yes, the page cache after truncate is correct. But before we zero the
page cache (in truncate_setsize()), we skipped zeroing the partial block
range 0x800-0x1000 and then triggered a writeback on range
[di_size, newsize], which was 0-0x800, and 0x800-0x1000 was written back
to disk too, which contained non-zeros.

(newsize(2k) > di_size(0) && oldsize(4k) != di_size(0)) was true.

        if (did_zeroing ||                                                                                                                                                                                                       
            (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {                                                                                                                                                         
                error = filemap_write_and_wait_range(mapping, ip->i_d.di_size,                                                                                                                                                   
                                                        newsize - 1);                                                                                                                                                            
                if (error)                                                                                                                                                                                                       
                        return error;                                                                                                                                                                                            
        }

> 
> >   punch_hole 0x0 0x800 0x800
> 
> Unwritten, page contains zeros 0x0-0x1000

i_mapping had no pages (nrpages == 0) after punch_hole.

> 
> >   mapread 0x0 0x800 0x800

pagefault read block from disk, 0-0x7ff was zero, but 0x800-0xfff was
non-zero.

> 
> Should map a page full of zeros as it is either a read over an
> unwritten extent or a hole, or it finds a page cache page that is
> fully zeroed.
> 
> The only wrinkle in this is if the write is direct IO, but
> then the truncate would see a written extent and this whole problem
> doesn't occur.
> 
> So, more info required. :P

Above is what I observed in debugging, maybe I should have provided more
details in the first place. (I did add some comments to the fstests case
though..).

Thanks,
Eryu

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
