Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5KKuNXB186440 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 15:56:23 -0500
Message-ID: <4DFFB3F3.3070606@sgi.com>
Date: Mon, 20 Jun 2011 15:56:19 -0500
From: Kevan Rehm <kfr@sgi.com>
MIME-Version: 1.0
Subject: question on xfs_vm_writepage in combination with fsync
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Greetings,

I've run into a case where the fsync() system call seems to have
returned before all file data was actually on disk.  (A SLES11SP1 system
crash occurred shortly after an fsync which had returned zero.  After
restarting the machine, the last I/O before the fsync is not in the
file.)  In attempting to find the problem, I've come across code I don't
understand, and am hoping someone can enlighten me as to how things are
supposed to work.

Routine xfs_vm_writepage has various situations under which it will
decide it can't currently initiate writeback on a page, and in that case
calls redirty_page_for_writepage, unlocks the page, and returns zero.
That seems to me to be incompatible with fsync(), so I'm obviously
missing some key piece of logic.

The calling sequence of routines involved in fsync is:

do_fsync->vfs_fsync->vfs_fsync_range->
	filemap_write_and_wait_range->
	__filemap_fdatawrite_range->
	do_writepages->generic_writepages->
	write_cache_pages

Routine write_cache_pages walks the radix tree and calls
clear_page_dirty_for_io and then __writepage on each dirty page to
initiate writeback.  __writepage calls xfs_vm_writepage.  That routine
is occasionally unable to immediately start writeback of the page, and
so it calls redirty_page_for_writepage without setting the writeback flag.

When write_cache_pages resumes after the __writepage call, it continues
walking the radix tree starting additional writebacks on dirty pages,
but nothing I can see will ever come back and try again to start a
writeback on the page that xfs_vm_writepage couldn't writeback.
Eventually control bubbles back up to filemap_write_and_wait_range()
where wait_on_page_writeback_range is called, but that routine only
waits for writebacks to complete, it doesn't do anything about dirty
pages.   So it appears to me that the dirty page will be left dirty
indefinitely even though the wbc contained WB_SYNC_ALL.

I'd like to believe that I am missing something, and that the code is
correct, but I do have a crash dump where I can see dirty pages in files
that were recently fsync'd.  And I can't believe the problem is
something inside XFS, because I see other filesystems also call
redirty_page_for_writepage, so I think the same problem could occur with
them.

Could someone please describe to me how fsync is supposed to work in
combination with xfs_vm_writepage?

Thanks in advance,

Regards, Kevan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
