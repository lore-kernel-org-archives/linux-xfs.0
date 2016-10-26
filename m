Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47826 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753689AbcJZH5E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Oct 2016 03:57:04 -0400
Date: Wed, 26 Oct 2016 09:57:02 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] iomap: implement direct I/O
Message-ID: <20161026075702.GB28408@lst.de>
References: <1477408098-10153-1-git-send-email-hch@lst.de> <1477408098-10153-6-git-send-email-hch@lst.de> <20161025195153.ehrxmjqaqqkdc23f@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161025195153.ehrxmjqaqqkdc23f@kmo-pixel>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, axboe@fb.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Oct 25, 2016 at 11:51:53AM -0800, Kent Overstreet wrote:
> So - you're hitting inode locks on each call to iomap_begin()/iomap_end()?  :/

Depends on your defintion of inode locks.  In XFS we have three inode
locks:

 (1) the IOLOCK, which this patch series actually replaces entirely by the
     VFS i_rwsem.  This one just serializes I/O to a file.  It is taken
     exactly once for each read or write or truncate or similar operation.
 (2) the MMAPLOCK, which is taken in page faults to synchronize against
     truncate.  Note taken at all for read/write
 (3) the ILOCK, which serializes access to the extent list for a file as
     well as a few minor bits not relevant here.  This one is taken in
     each iomap_begin call at the moment, although I have a crude prototype
     that allows lockless lookup in the in-memory extent list.

> But - (I'm not too familiar with the XFS code) - it looks like you're also doing
> a full extents btree traversal on each iomap_begin() call too, behind
> xfs_bmapi_read()?

xfs_bmapi_read does a "full" extent lookup in the in-memory extent list,
yes.  It's not actually a btree but a linear list with indirection
arrays at the moment.  A somewhat messy structure that hopefully won't
be around for too long.

> Are you returning the right thing on partial reads/writes? the existing dio code
> squashes -EFAULT (but not on other errors, even when some IO was successfully
> done, e.g. -ENOMEM from gup(), which doesn't seem right to me...)

Both the old and the new code only support partial reads when hitting
EOF - everything else is getting turned into a negative error.

> One thing you're not doing that the existing dio code does is limit the number
> of outstanding pinned pages. I don't think it needs to be, but it does mean
> you'll return an error from gup() if someone issues a huge IO, too big to pin
> all the pages at once

Where would that error come from?  It's not like get_user_pages accounts
for the number of pinned pages in any way.  I also don't see the old
code to care for the pinned pages anywhere, it just has it's little
64 page array that it wants to reuse to not have unbounded kernel
allocation for large I/O.  For the new code the bio mempool takes care
of that throtteling.

> So I think it would be a good idea to handle any memory allocation failures by
> waiting for outstanding IOs to complete and then continuing, and only bailing
> out if there aren't any IOs outstanding (and that still gets rid of the stupid
> hard limit on the number of pinned pages in the existing dio code).

We have exactly two memory allocation in the iomap part of the code (the
fs might have more):  The initial dio structure, and then the bios.  For
a dio allocation failure we just return -ENOMEM, and bio allocation don't
fail, they just wait for other bios to complete, so I get this behavior
for free.

> Your dio refcounting - you have the submitting thread unconditionally holding
> its own ref, and dropping it in iomap_dio_rw() after submitting all the IOs:
> this is definitely the right way to do it for the sake of sanity, but it's going
> to be a performance hit - this is something I've been bit by recently. The issue
> is that you've already gone down the rest of the IO stack in either submit_bio()
> or blk_finish_plug(), so the ref is no longer cache hot and that one atomic is
> _significantly_ more expensive than the rest.
> 
> The way you've got the code setup it looks like it wouldn't be that painful to
> get rid of that final atomic_dec_and_test() when it's not needed (async kiocbs),
> but I also wouldn't see anything wrong with keeping things simple until after
> the code is in and leaving that optimization for later.

Yes, I don't want to over-optimize things - there still is a lot
easier fish to fry for the fs direct I/O case.  But I also have a cut
down variant of this code just for block devices that has optimized
every little bit we can - with that we get 4 microsecond latency from
a userspace program to an (DRAM based) NVMe device.  The code is here:

http://git.infradead.org/users/hch/block.git/commitdiff/2491eb79a983f7f6841189ad179c714a93316603
