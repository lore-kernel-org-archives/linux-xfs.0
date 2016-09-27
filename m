Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33881 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932297AbcI0PjB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 11:39:01 -0400
Date: Wed, 28 Sep 2016 01:38:54 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 04/11] splice: lift pipe_lock out of splice_to_pipe()
Message-ID: <20160928013854.515db6fc@roar.ozlabs.ibm.com>
In-Reply-To: <20160924172901.GS2356@ZenIV.linux.org.uk>
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
        <20160924172901.GS2356@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, 24 Sep 2016 18:29:01 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Sat, Sep 24, 2016 at 04:59:08AM +0100, Al Viro wrote:
> 
> > 	FWIW, updated (with fixes) and force-pushed.  Added piece:
> > default_file_splice_read() converted to iov_iter.  Seems to work, after
> > fixing a braino in __pipe_get_pages().  Changed: #4 (sleep only in the
> > beginning, as described above), #6 (context changes from #4), #10 (missing
> > get_page() added in __pipe_get_pages()), #11 (removed pointless truncation
> > of len - ->read_iter() can bloody well handle that on its own) and added #12.
> > Stands at 28 files changed, 657 insertions(+), 1009 deletions(-) now...  
> 
> 	I think I see how to get full zero-copy (including the write side
> of things).  Just add a "from" side for ITER_PIPE iov_iter (advance,
> get_pages, get_pages_alloc, npages and alignment will need to behave
> differently for "to" and "from" ones) and pull the following trick:
> have fault_in_readable return NULL instead of 0, ERR_PTR(-EFAULT) instead
> of -EFAULT *and* return a struct page if it was asked for a full-page
> range on a page that could be successfully stolen (only "from pipe" iov_iter
> would go for the last one, of course).  Then we make generic_perform_write()
> shove the return value of fault-in into 'page'.  ->write_begin() is given
> &page as an argument, to return the resulting page via that.  All instances
> currently just store into that pointer, completely ignoring the prior value.
> And they'll keep working just fine.
> 
> 	Let's make sure that all method call sites outside of
> generic_perform_write() (there's only one such, actually) have NULL
> stored in there prior to the call.  Now we can start switching the
> instances to zero-copy support - all it takes is replacing
> grab_cache_page_write_begin() with "if *page is non-NULL, try to
> shove it (locked, non-uptodate) into pagecache; if that succeeds grab a
> reference to our page and we are done, if it fails - fall back to
> grab_cache_page_write_begin()".  Then do get_block, etc., or whatever that
> ->write_begin() instance would normally do, just remember not to zero anything  
> if the page had been passed to us by caller.

Interesting stuff. It should also be possible for a filesystem to replace
existing pagecache as a zero-copy overwrite with the migration APIs and
just a little bit of work.
