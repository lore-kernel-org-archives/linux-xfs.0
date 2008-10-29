Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 20:17:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T3GrNe026407
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:16:53 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22DD98A1C0F
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:16:49 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id PRAvFZChMCT5AmoI for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:16:49 -0700 (PDT)
Date: Wed, 29 Oct 2008 14:16:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029031645.GE4985@disturbed>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029001653.GF15599@wotan.suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nick Piggin <npiggin@suse.de>
Cc: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>

On Wed, Oct 29, 2008 at 01:16:53AM +0100, Nick Piggin wrote:
> On Wed, Oct 29, 2008 at 09:27:46AM +1100, Dave Chinner wrote:
> > On Tue, Oct 28, 2008 at 04:39:53PM +0100, Nick Piggin wrote:
> > Yes - that's coming from end_buffer_async_write() when an error is
> > reported in bio completion. This does:
> > 
> >  465                 set_bit(AS_EIO, &page->mapping->flags);
> >  466                 set_buffer_write_io_error(bh);
> >  467                 clear_buffer_uptodate(bh);
> >  468                 SetPageError(page);
> > 
> > Hmmmm - do_fsync() calls filemap_fdatawait() which ends up in
> > wait_on_page_writeback_range() which is appears to be checking the
> > mapping flags for errors. I wonder why that error is not being
> > propagated then? AFAICT both XFS and the fsync code are doing the
> > right thing but somewhere the error has gone missing...
> 
> This one-liner has it reporting EIO errors like a champion. I
> don't know if you'll actually need to put this into the
> linux API layer or not, but anyway the root cause of the problem
> AFAIKS is this.
> --
> 
> XFS: fix fsync errors not being propogated back to userspace.
> ---
> Index: linux-2.6/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_vnodeops.c
> +++ linux-2.6/fs/xfs/xfs_vnodeops.c
> @@ -715,7 +715,7 @@ xfs_fsync(
>  	/* capture size updates in I/O completion before writing the inode. */
>  	error = filemap_fdatawait(VFS_I(ip)->i_mapping);
>  	if (error)
> -		return XFS_ERROR(error);
> +		return XFS_ERROR(-error);

<groan>

Yeah, that'd do it. Good catch. I can't believe I recently fixed a
bug that touched these lines of code without noticing the inversion.
Sometimes I wonder if we should just conver the entire of XFS to
return negative errors - mistakes in handling negative error numbers
in the core XFS code happen all the time.

FWIW, the core issue here is that we've got to do the
filemap_fdatawait() call in the ->fsync method because ->fsync
gets called before we've waited for the data I/O to complete.
XFS updates inode state on I/O completion, so we *must* wait
for data I/O to complete before logging the inode changes. I
think btrfs has the same problem....

Thanks again, Nick.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
