Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 17:17:09 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T0Gtoi016585
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:16:55 -0700
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 747AC12AF843
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:16:54 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with ESMTP id sd5RGfp0fy0ct3Ab for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 17:16:54 -0700 (PDT)
Date: Wed, 29 Oct 2008 01:16:53 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [patch 0/9] writeback data integrity and other fixes (take 3)
Message-ID: <20081029001653.GF15599@wotan.suse.de>
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
> > 
> > I haven't seen any -EIO failures from XFS... maybe I'm just not doing the
> > right thing, or there is a caveat I'm not aware of.
> > 
> > All fault injections I noticed had a trace like this:
> > FAULT_INJECTION: forcing a failure
> > Call Trace:
> > 9f9cd758:  [<6019f1de>] random32+0xe/0x20
> > 9f9cd768:  [<601a31b9>] should_fail+0xd9/0x130
> > 9f9cd798:  [<6018d0c4>] generic_make_request+0x304/0x4e0
> > 9f9cd7a8:  [<60062301>] mempool_alloc+0x51/0x130
> > 9f9cd858:  [<6018e6bf>] submit_bio+0x4f/0xe0
> > 9f9cd8a8:  [<60165505>] xfs_submit_ioend_bio+0x25/0x40
> > 9f9cd8c8:  [<6016603c>] xfs_submit_ioend+0xbc/0xf0
> > 9f9cd908:  [<60166bf9>] xfs_page_state_convert+0x3d9/0x6a0
> > 9f9cd928:  [<6005d515>] delayacct_end+0x95/0xb0
> > 9f9cda08:  [<60166ffd>] xfs_vm_writepage+0x6d/0x110
> > 9f9cda18:  [<6006618b>] set_page_dirty+0x4b/0xd0
> > 9f9cda58:  [<60066115>] __writepage+0x15/0x40
> > 9f9cda78:  [<60066775>] write_cache_pages+0x255/0x470
> > 9f9cda90:  [<60066100>] __writepage+0x0/0x40
> > 9f9cdb98:  [<600669b0>] generic_writepages+0x20/0x30
> > 9f9cdba8:  [<60165ba3>] xfs_vm_writepages+0x53/0x70
> > 9f9cdbd8:  [<600669eb>] do_writepages+0x2b/0x40
> > 9f9cdbf8:  [<6006004c>] __filemap_fdatawrite_range+0x5c/0x70
> > 9f9cdc58:  [<6006026a>] filemap_fdatawrite+0x1a/0x20
> > 9f9cdc68:  [<600a7a05>] do_fsync+0x45/0xe0
> > 9f9cdc98:  [<6007794b>] sys_msync+0x14b/0x1d0
> > 9f9cdcf8:  [<60019a70>] handle_syscall+0x50/0x80
> > 9f9cdd18:  [<6002a10f>] userspace+0x44f/0x510
> > 9f9cdfc8:  [<60016792>] fork_handler+0x62/0x70
> 
> XFS reports bio errors through the I/O completion path, not the
> submission path.
> 
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

This one-liner has it reporting EIO errors like a champion. I
don't know if you'll actually need to put this into the
linux API layer or not, but anyway the root cause of the problem
AFAIKS is this.
--

XFS: fix fsync errors not being propogated back to userspace.
---
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c
+++ linux-2.6/fs/xfs/xfs_vnodeops.c
@@ -715,7 +715,7 @@ xfs_fsync(
 	/* capture size updates in I/O completion before writing the inode. */
 	error = filemap_fdatawait(VFS_I(ip)->i_mapping);
 	if (error)
-		return XFS_ERROR(error);
+		return XFS_ERROR(-error);
 
 	/*
 	 * We always need to make sure that the required inode state is safe on
