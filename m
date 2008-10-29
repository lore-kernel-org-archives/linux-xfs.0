Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 21:00:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T40JLe001945
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 21:00:21 -0700
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6842554E72
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 21:00:18 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id MLDZ4PD06g38F5vR for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 21:00:18 -0700 (PDT)
Date: Wed, 29 Oct 2008 05:00:14 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029040014.GB17624@wotan.suse.de>
References: <20081028144715.683011000@suse.de> <20081028153953.GB3082@wotan.suse.de> <20081028222746.GB4985@disturbed> <20081029001653.GF15599@wotan.suse.de> <20081029031645.GE4985@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029031645.GE4985@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: akpm@linux-foundation.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Cc: linux-ext4@vger.kernel.org

On Wed, Oct 29, 2008 at 02:16:45PM +1100, Dave Chinner wrote:
> On Wed, Oct 29, 2008 at 01:16:53AM +0100, Nick Piggin wrote:
> > On Wed, Oct 29, 2008 at 09:27:46AM +1100, Dave Chinner wrote:
> > > On Tue, Oct 28, 2008 at 04:39:53PM +0100, Nick Piggin wrote:
> > > Yes - that's coming from end_buffer_async_write() when an error is
> > > reported in bio completion. This does:
> > > 
> > >  465                 set_bit(AS_EIO, &page->mapping->flags);
> > >  466                 set_buffer_write_io_error(bh);
> > >  467                 clear_buffer_uptodate(bh);
> > >  468                 SetPageError(page);
> > > 
> > > Hmmmm - do_fsync() calls filemap_fdatawait() which ends up in
> > > wait_on_page_writeback_range() which is appears to be checking the
> > > mapping flags for errors. I wonder why that error is not being
> > > propagated then? AFAICT both XFS and the fsync code are doing the
> > > right thing but somewhere the error has gone missing...
> > 
> > This one-liner has it reporting EIO errors like a champion. I
> > don't know if you'll actually need to put this into the
> > linux API layer or not, but anyway the root cause of the problem
> > AFAIKS is this.
> > --
> > 
> > XFS: fix fsync errors not being propogated back to userspace.
> > ---
> > Index: linux-2.6/fs/xfs/xfs_vnodeops.c
> > ===================================================================
> > --- linux-2.6.orig/fs/xfs/xfs_vnodeops.c
> > +++ linux-2.6/fs/xfs/xfs_vnodeops.c
> > @@ -715,7 +715,7 @@ xfs_fsync(
> >  	/* capture size updates in I/O completion before writing the inode. */
> >  	error = filemap_fdatawait(VFS_I(ip)->i_mapping);
> >  	if (error)
> > -		return XFS_ERROR(error);
> > +		return XFS_ERROR(-error);
> 
> <groan>
> 
> Yeah, that'd do it. Good catch. I can't believe I recently fixed a
> bug that touched these lines of code without noticing the inversion.
> Sometimes I wonder if we should just conver the entire of XFS to
> return negative errors - mistakes in handling negative error numbers
> in the core XFS code happen all the time.

Heh, yeah it seems a bit tricky. BTW. feel free to add
Signed-off-by: Nick Piggin <npiggin@suse.de>
if you would like to merge it, or alternatively if you fix it another
way then I can rerun the test in 2 minutes if it is not 100% obviously
correct.

BTW. XFS seems to really be a lot more consistent than ext3 (ordered)
in reporting EIO with this change in place. I don't know why exactly,
but in ext3 I can see hundreds or thousands of failures injected in this
manner:

FAULT_INJECTION: forcing a failure
Call Trace:
9ebe17f8:  [<6019f34e>] random32+0xe/0x20
9ebe1808:  [<601a3329>] should_fail+0xd9/0x130
9ebe1838:  [<6018d234>] generic_make_request+0x304/0x4e0
9ebe1848:  [<600622e1>] mempool_alloc+0x51/0x130
9ebe18f8:  [<6018e82f>] submit_bio+0x4f/0xe0
9ebe1948:  [<600a8969>] submit_bh+0xd9/0x130
9ebe1978:  [<600aab08>] __block_write_full_page+0x198/0x310
9ebe1988:  [<600a8487>] alloc_buffer_head+0x37/0x50
9ebe19a0:  [<600f6ec0>] ext3_get_block+0x0/0x110
9ebe19d8:  [<600f6ec0>] ext3_get_block+0x0/0x110
9ebe19e8:  [<600aad48>] block_write_full_page+0xc8/0x100
9ebe1a38:  [<600f8951>] ext3_ordered_writepage+0xd1/0x180
9ebe1a48:  [<6006616b>] set_page_dirty+0x4b/0xd0
9ebe1a88:  [<600660f5>] __writepage+0x15/0x40
9ebe1aa8:  [<60066755>] write_cache_pages+0x255/0x470
9ebe1ac0:  [<600660e0>] __writepage+0x0/0x40
9ebe1bc8:  [<60066990>] generic_writepages+0x20/0x30
9ebe1bd8:  [<600669db>] do_writepages+0x3b/0x40
9ebe1bf8:  [<6006006c>] __filemap_fdatawrite_range+0x5c/0x70
9ebe1c58:  [<6006028a>] filemap_fdatawrite+0x1a/0x20
9ebe1c68:  [<600a7a15>] do_fsync+0x45/0xe0
9ebe1c98:  [<6007792b>] sys_msync+0x14b/0x1d0
9ebe1cf8:  [<60019a70>] handle_syscall+0x50/0x80
9ebe1d18:  [<6002a10f>] userspace+0x44f/0x510
9ebe1fc8:  [<60016792>] fork_handler+0x62/0x70

Buffer I/O error on device ram0, logical block 8228
lost page write due to I/O error on ram0

But eventually the filesystem aborts when we get a journal writing error,
and sometimes I see a single EIO to msync, sometimes not (cc ext3 list).

Wheras XFS reports a lot more EIOs as it goes...

If ext3 guys have any suggestions, I could test them out.

 
> FWIW, the core issue here is that we've got to do the
> filemap_fdatawait() call in the ->fsync method because ->fsync
> gets called before we've waited for the data I/O to complete.
> XFS updates inode state on I/O completion, so we *must* wait
> for data I/O to complete before logging the inode changes. I
> think btrfs has the same problem....

Interesting. Does that mean you can do without the final filemap_fdatawait?
Can you do the first fdatawait without i_mutex held?

There was some talk IIRC about moving all this logic into the filesystem
to provide more flexibility here. If there is still enough interest,
we should get that moving...


> Thanks again, Nick.

No problem.

Thanks,
Nick
