Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 17:04:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T04XVm015438
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:04:34 -0700
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A66C6149FC9C
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:04:28 -0700 (PDT)
Received: from mx1.suse.de (ns.suse.de [195.135.220.2]) by cuda.sgi.com with ESMTP id dOWknbg6tZz3cc5F for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:04:28 -0700 (PDT)
Date: Wed, 29 Oct 2008 01:04:24 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029000424.GD15599@wotan.suse.de>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081028222746.GB4985@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 09:27:46AM +1100, Dave Chinner wrote:
> On Tue, Oct 28, 2008 at 04:39:53PM +0100, Nick Piggin wrote:
> > On Wed, Oct 29, 2008 at 01:47:15AM +1100, npiggin@suse.de wrote:
> > I haven't seen any -EIO failures from XFS... maybe I'm just not doing the
> > right thing, or there is a caveat I'm not aware of.
> > 
> > All fault injections I noticed had a trace like this:
[...]
> 
> XFS reports bio errors through the I/O completion path, not the
> submission path.

Right, that's just to give you an indication of where it's failing...

 
> > And the kernel would sometimes say this:
> > Buffer I/O error on device ram0, logical block 279
> > lost page write due to I/O error on ram0
> > Buffer I/O error on device ram0, logical block 379
> > lost page write due to I/O error on ram0
> > Buffer I/O error on device ram0, logical block 389
> > lost page write due to I/O error on ram0
> 
> Yes - that's coming from end_buffer_async_write() when an error is
> reported in bio completion. This does:
> 
>  465                 set_bit(AS_EIO, &page->mapping->flags);
>  466                 set_buffer_write_io_error(bh);
>  467                 clear_buffer_uptodate(bh);
>  468                 SetPageError(page);
> 
> Hmmmm - do_fsync() calls filemap_fdatawait() which ends up in
> wait_on_page_writeback_range() which is appears to be checking the
> mapping flags for errors. I wonder why that error is not being
> propagated then? AFAICT both XFS and the fsync code are doing the
> right thing but somewhere the error has gone missing...

Yeah, I couldn't immediately see why nothing comes out. I'll do a bit
more digging.

 
> > I think I also saw a slab bug when running dbench with fault injection on.
> > Running latest Linus kernel.
[...]
>
> Now that is interesting.
> 
> We've got a rolling transaction in progress, and the commit of the
> first part of the transaction has got the I/O error.  That frees the
> transaction structure used during that commit, as well as the
> ticket.
> 
> However, before we committed the initial transaction, we duplicated
> the transaction structure to allow the transaction to continue to
> track all the dirty objects in the first commit. That included
> duplicating the pointer to the ticket.
> 
> Then the EIO is returned to mkdir code with the duplicated
> transaction, which is then cancelled, and that frees the transaction
> and the ticket it holds. However, we'd already freed the ticket.
> 
> Ok, we're only seeing this problem now because I recently modified
> the ticket allocation to use a slab instead of a roll-your-own free
> list structure that wouldn't have been poisoned. Nice to know that
> this change did more than just remove code. ;)
> 
> This might take a little while to fix - a lot of code needs
> auditing - but thanks for reporting the problem.

No problem, hope it helps.

Thanks,
Nick
