Return-Path: <SRS0=LlZ6=BV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F060C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 02:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD68206DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Aug 2020 02:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgHKCBA convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 22:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbgHKCA7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Aug 2020 22:00:59 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Tue, 11 Aug 2020 02:00:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-208827-201763-xVo4fURzBm@https.bugzilla.kernel.org/>
In-Reply-To: <bug-208827-201763@https.bugzilla.kernel.org/>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=208827

--- Comment #9 from Dave Chinner (david@fromorbit.com) ---
On Mon, Aug 10, 2020 at 07:08:59PM +1000, Dave Chinner wrote:
> On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
> > [cc Jens]
> > 
> > [Jens, data corruption w/ io_uring and simple fio reproducer. see
> > the bz link below.]

Looks like a io_uring/fio bugs at this point, Jens. All your go fast
bits turns the buffered read into a short read, and neither fio nor
io_uring async buffered read path handle short reads. Details below.

Also, the block_rq_* trace points appear to emit corrupt trace
records that crash trace-cmd. That probably needs to be looked into
as well:

$ sudo trace-cmd record -e xfs_file\* -e iomap\* -e block_bio\* -e
block_rq_complete -e printk fio tests/io_uring_corruption.fio
.....
$ trace-cmd report > s.t
ug! no event found for type 4228
ug! no event found for type 32
ug! negative record size -4
ug! no event found for type 16722
ug! no event found for type 0
ug! no event found for type 4228
ug! no event found for type 32
ug! negative record size -4
ug! no event found for type 16722
ug! no event found for type 4228
ug! no event found for type 4230
ug! no event found for type 32
ug! no event found for type 0
ug! no event found for type 4230
ug! no event found for type 32
ug! no event found for type 0
ug! no event found for type 32
ug! negative record size -4
Segmentation fault
$



> > On Mon, Aug 10, 2020 at 01:56:05PM +1000, Dave Chinner wrote:
> > > On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
> > > > On Fri, Aug 07, 2020 at 03:12:03AM +0000,
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > > > > --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
> > > > > On Thu, Aug 06, 2020 at 04:57:58AM +0000,
> bugzilla-daemon@bugzilla.kernel.org
> > > > > wrote:
> > > > > > https://bugzilla.kernel.org/show_bug.cgi?id=208827
> > > > > > 
> > > > > >             Bug ID: 208827
> > > > > >            Summary: [fio io_uring] io_uring write data crc32c
> verify
> > > > > >                     failed
> > > > > >            Product: File System
> > > > > >            Version: 2.5
> > > > > >     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
> > > > 
> > > > FWIW, I can reproduce this with a vanilla 5.8 release kernel,
> > > > so this isn't related to contents of the XFS dev tree at all...
> > > > 
> > > > In fact, this bug isn't a recent regression. AFAICT, it was
> > > > introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
> > > > reproduce. More info once I've finished bisecting it....
> > > 
> > > f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
> > > commit f67676d160c6ee2ed82917fadfed6d29cab8237c
> > > Author: Jens Axboe <axboe@kernel.dk>
> > > Date:   Mon Dec 2 11:03:47 2019 -0700
> > > 
> > >     io_uring: ensure async punted read/write requests copy iovec
> > 
> > ....
> > 
> > Ok, I went back to vanilla 5.8 to continue debugging and adding
> > tracepoints, and it's proving strangely difficult to reproduce now.
> 
> Which turns out to be caused by a tracepoint I inserted to try to
> narrow down if this was an invalidation race. I put this in
> invalidate_complete_page:
> 
> 
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -257,8 +257,11 @@ int invalidate_inode_page(struct page *page)
>         struct address_space *mapping = page_mapping(page);
>         if (!mapping)
>                 return 0;
> -       if (PageDirty(page) || PageWriteback(page))
> +       if (PageDirty(page) || PageWriteback(page)) {
> +               trace_printk("ino 0x%lx page %p, offset 0x%lx\n",
> +                       mapping->host->i_ino, page, page->index * PAGE_SIZE);
>                 return 0;
> +       }
>         if (page_mapped(page))
>                 return 0;
>         return invalidate_complete_page(mapping, page);

So I updated to the current 5.9 whcih has all the new async buffered
read stuff in it to see if that fixed the problem, but it didn't.
Instead, it actually made this problem occur almost instantenously.

I could put the above trace code back in and it didn't purturb the
situation, either. Neither did writeback, which I was now able to
confirm didn't actually impact on this problem at all.

The problem is, instead, reads racing with readahead completion.
There is no page cache corruption at all, just fio is reusing
buffers that contain stale data from previous read IO and hence any
part of the buffer that doesn't get updated by the read IO ends up
being detected as "corrupt" because they already contain stale data.

The problem is clear from this sequence trace:

     io_uring-sq-4518  [012]    52.806976: xfs_file_buffered_read: dev 253:32
ino 0x86 size 0x10000000 offset 0x6f40000 count 0x10000
     io_uring-sq-4518  [012]    52.806987: iomap_readahead:      dev 253:32 ino
0x86 nr_pages 16
     io_uring-sq-4518  [012]    52.806987: iomap_apply:          dev 253:32 ino
0x86 pos 116654080 length 65536 flags  (0x0) ops xfs_read_iomap_ops caller
iomap_readahead actor iomap_readahead_actor
     io_uring-sq-4518  [012]    52.806988: iomap_apply_dstmap:   dev 253:32 ino
0x86 bdev 253:32 addr 922058752 offset 116654080 length 65536 type MAPPED flags 
     io_uring-sq-4518  [012]    52.806990: block_bio_queue:      253,32 RA
1800896 + 128 [io_uring-sq]
....
     io_uring-sq-4518  [012]    52.806992: xfs_file_buffered_read: dev 253:32
ino 0x86 size 0x10000000 offset 0x6f40000 count 0xfffffffffffffff5
     io_uring-sq-4518  [012]    52.806993: xfs_file_buffered_read: dev 253:32
ino 0x86 size 0x10000000 offset 0x6f40000 count 0x10000
     io_uring-sq-4518  [012]    52.806994: xfs_file_buffered_read: dev 253:32
ino 0x86 size 0x10000000 offset 0x6f40000 count 0xfffffffffffffdef
     io_uring-sq-4518  [012]    52.806995: xfs_file_buffered_read: dev 253:32
ino 0x86 size 0x10000000 offset 0x6bf0000 count 0x10000
....
             fio-4515  [013]    52.807855: block_rq_complete:    253,32 RA ()
1800896 + 128 [0]
     io_uring-sq-4518  [012]    52.807863: xfs_file_buffered_read: dev 253:32
ino 0x86 size 0x10000000 offset 0x6f40000 count 0x10000
     io_uring-sq-4518  [012]    52.807866: xfs_file_buffered_read: dev 253:32
ino 0x86 size 0x10000000 offset 0x6f41000 count 0x1000
....
             fio-4515  [013]    52.807871: block_rq_complete:    253,32 RA ()
1752640 + 128 [0]
             fio-4515  [013]    52.807876: block_rq_complete:    253,32 RA ()
1675200 + 128 [0]
             fio-4515  [013]    52.807880: block_rq_complete:    253,32 RA ()
1652672 + 128 [0]

What we see is -3- calls to do the buffered read. The first call
triggers readahead and we can see iomap map the file offset and
issue the bio. This is IOCB_NOWAIT context, so this is actually
broken as we can block for a long time in this path (e.g. on
inode locks).

Once the IO is issued, we see a second xfs_file_buffered_read trace
with the return value in the count - that's -EAGAIN because
IOCB_NOWAIT is set and now we are going to block waiting for IO.

Immediately after this, the io_uring code issues the buffered read
again, only this time with IOCB_WAITQ|IOCB_NOWAIT set and it hits
the "page not up to date" path. This then hits
__wait_on_page_locked_async() which sets the PageWaiter bit and
returns -EIOCBQUEUED to tell the caller that it has been queued.

About a millisecond later, the readahead IO completes, and the block
layer logs it. This ends up calling iomap_read_end_io() which walks
each page(bvec) in the bio, marks them uptodate and unlocks them.
The first page unlock sees the PageWaiter bit, which then does a

        wake_up_page_bit(page, PG_locked);

because the PageWaiter bit is set. We see the same io_uring worker
thread then immmediately re-issue the buffered read and it does it
with IOCB_WAITQ|IOCB_NOWAIT context. This gets the first page, then
finds the second page not up to date or has to block trying to lock
it. It aborts the read at that point, and because we've already read
a page it returns 4096 bytes read.

I left the post-buffered read IO completions that were being run by
the block layer to show that the buffered read was issued and
completed while the block layer was still processing the readahead
bio completion.

At this point (a positive byte count being returned) the io_uring
layer considers the IO done and returns the result to the userspace
app. Fio then completely fails to check for a short read despite
being in "verify" mode and instead yells about corruption due to
stale data that it had left in the buffer that it passed the
kernel....

IOWs, there does not appear to be a filesystem or page cache issue
here at all - it's just an unhandled short read.

Jens, if strace worked on io_uring, I wouldn't have wasted 2 and
half days tracking this down. It would have taken 5 minutes with
strace and it would have been totally obvious. I'd suggest this
needs addressing as a matter of priority over everything else for
io_uring....

Cheers, 

Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
