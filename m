Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:37072 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754294AbcIXR3F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Sep 2016 13:29:05 -0400
Date: Sat, 24 Sep 2016 18:29:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 04/11] splice: lift pipe_lock out of splice_to_pipe()
Message-ID: <20160924172901.GS2356@ZenIV.linux.org.uk>
References: <CA+55aFznQaOWoSMNphgGJJWZ=8-odrc0DAUMzfGPQe+_N4UgNA@mail.gmail.com>
 <20160914042559.GC2356@ZenIV.linux.org.uk>
 <20160917082007.GA6489@ZenIV.linux.org.uk>
 <20160917190023.GA8039@ZenIV.linux.org.uk>
 <20160923190032.GA25771@ZenIV.linux.org.uk>
 <20160923190326.GB2356@ZenIV.linux.org.uk>
 <CA+55aFxzPH2AYvDVWSAomO6bN_sW4+qDv87Xbq8XHMyvBEYe+w@mail.gmail.com>
 <20160923201025.GJ2356@ZenIV.linux.org.uk>
 <CA+55aFyr-X_6FcWkSXBUcxV0p1BUZw8d=46wawv2x+8y7f8YcQ@mail.gmail.com>
 <20160924035908.GM2356@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160924035908.GM2356@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, Sep 24, 2016 at 04:59:08AM +0100, Al Viro wrote:

> 	FWIW, updated (with fixes) and force-pushed.  Added piece:
> default_file_splice_read() converted to iov_iter.  Seems to work, after
> fixing a braino in __pipe_get_pages().  Changed: #4 (sleep only in the
> beginning, as described above), #6 (context changes from #4), #10 (missing
> get_page() added in __pipe_get_pages()), #11 (removed pointless truncation
> of len - ->read_iter() can bloody well handle that on its own) and added #12.
> Stands at 28 files changed, 657 insertions(+), 1009 deletions(-) now...

	I think I see how to get full zero-copy (including the write side
of things).  Just add a "from" side for ITER_PIPE iov_iter (advance,
get_pages, get_pages_alloc, npages and alignment will need to behave
differently for "to" and "from" ones) and pull the following trick:
have fault_in_readable return NULL instead of 0, ERR_PTR(-EFAULT) instead
of -EFAULT *and* return a struct page if it was asked for a full-page
range on a page that could be successfully stolen (only "from pipe" iov_iter
would go for the last one, of course).  Then we make generic_perform_write()
shove the return value of fault-in into 'page'.  ->write_begin() is given
&page as an argument, to return the resulting page via that.  All instances
currently just store into that pointer, completely ignoring the prior value.
And they'll keep working just fine.

	Let's make sure that all method call sites outside of
generic_perform_write() (there's only one such, actually) have NULL
stored in there prior to the call.  Now we can start switching the
instances to zero-copy support - all it takes is replacing
grab_cache_page_write_begin() with "if *page is non-NULL, try to
shove it (locked, non-uptodate) into pagecache; if that succeeds grab a
reference to our page and we are done, if it fails - fall back to
grab_cache_page_write_begin()".  Then do get_block, etc., or whatever that
->write_begin() instance would normally do, just remember not to zero anything
if the page had been passed to us by caller.

	Now all we need is to make sure that iov_iter_copy_from_user_atomic()
for those guys recongnizes the case of full-page copy when source and target
are the same page and quietly returns PAGE_SIZE.  Voila - we can make
iter_file_splice_write() pass pipe-backed iov_iter instead of bvec-backed
one *and* get write-side zero-copy for all filesystems with ->write_begin()
taught to handle that (see above).  Since the filesystems with unmodified
->write_begin() will act correctly (just do the copying), we don't have
to make that a flagday change; ->write_begin() instances can be switched
one by one.  Similar treatment of iomap_write_begin()/iomap_write_actor()
would cover iomap-using ->write_iter() instances.

	It's clearly not something I want to touch until -rc1, but it looks
feasible for the next cycle, and if done right it promises to unify the
plain and splice sides of fuse_dev_...() stuff, simplifying the hell out
of them without losing zero-copy there.  And if everything really goes
right, we might be able to get rid of net/* ->splice_read() and ->sendpage()
methods as well...
