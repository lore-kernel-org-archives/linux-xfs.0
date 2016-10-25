Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35428 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932538AbcJYTv5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 15:51:57 -0400
Date: Tue, 25 Oct 2016 11:51:53 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 5/6] iomap: implement direct I/O
Message-ID: <20161025195153.ehrxmjqaqqkdc23f@kmo-pixel>
References: <1477408098-10153-1-git-send-email-hch@lst.de>
 <1477408098-10153-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477408098-10153-6-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, axboe@fb.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Oct 25, 2016 at 05:08:17PM +0200, Christoph Hellwig wrote:
> This adds a full fledget direct I/O implementation using the iomap
> interface. Full fledged in this case means all features are supported:
> AIO, vectored I/O, any iov_iter type including kernel pointers, bvecs
> and pipes, support for hole filling and async apending writes.  It does
> not mean supporting all the warts of the old generic code.  We expect
> i_rwsem to be held over the duration of the call, and we expect to
> maintain i_dio_count ourselves, and we pass on any kinds of mapping
> to the file system for now.
> 
> The algorithm used is very simple: We use iomap_apply to iterate over
> the range of the I/O, and then we use the new bio_iov_iter_get_pages
> helper to lock down the user range for the size of the extent.
> bio_iov_iter_get_pages can currently lock down twice as many pages as
> the old direct I/O code did, which means that we will have a better
> batch factor for everything but overwrites of badly fragmented files.

So - you're hitting inode locks on each call to iomap_begin()/iomap_end()?  :/

But - (I'm not too familiar with the XFS code) - it looks like you're also doing
a full extents btree traversal on each iomap_begin() call too, behind
xfs_bmapi_read()?

I guess that's probably how it worked before though, so ah well - if it was a
performance issue worth caring about you'd know, and like you said it only
matters for fragmented files - or, wouldn't alternating written/unwritten
extents trigger this? That does happen.

Anyways... more relevant comments...

Are you returning the right thing on partial reads/writes? the existing dio code
squashes -EFAULT (but not on other errors, even when some IO was successfully
done, e.g. -ENOMEM from gup(), which doesn't seem right to me...)

One thing you're not doing that the existing dio code does is limit the number
of outstanding pinned pages. I don't think it needs to be, but it does mean
you'll return an error from gup() if someone issues a huge IO, too big to pin
all the pages at once (i'm not sure why they would do that... copying a mmap'd
file? actually, running under severe memory pressure probably makes this a real
issue) where it would've worked with the existing dio code - and userspace could
just continue after the short read/write except a) we all know how much
userspace code won't, and b) that means you've dropped and retaken locks, and
it's no longer atomic, so it is a change in semantics.

So I think it would be a good idea to handle any memory allocation failures by
waiting for outstanding IOs to complete and then continuing, and only bailing
out if there aren't any IOs outstanding (and that still gets rid of the stupid
hard limit on the number of pinned pages in the existing dio code).

Your dio refcounting - you have the submitting thread unconditionally holding
its own ref, and dropping it in iomap_dio_rw() after submitting all the IOs:
this is definitely the right way to do it for the sake of sanity, but it's going
to be a performance hit - this is something I've been bit by recently. The issue
is that you've already gone down the rest of the IO stack in either submit_bio()
or blk_finish_plug(), so the ref is no longer cache hot and that one atomic is
_significantly_ more expensive than the rest.

The way you've got the code setup it looks like it wouldn't be that painful to
get rid of that final atomic_dec_and_test() when it's not needed (async kiocbs),
but I also wouldn't see anything wrong with keeping things simple until after
the code is in and leaving that optimization for later.

On the whole though it looks pretty clean to me, I can't find anything that
looks wrong.
