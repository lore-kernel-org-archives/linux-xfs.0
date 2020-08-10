Return-Path: <SRS0=bIZx=BU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D6EC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 09:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB987206B5
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 09:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgHJJJG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 05:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgHJJJG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Aug 2020 05:09:06 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 208827] [fio io_uring] io_uring write data crc32c verify failed
Date:   Mon, 10 Aug 2020 09:09:04 +0000
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
Message-ID: <bug-208827-201763-xNQFRS4LfF@https.bugzilla.kernel.org/>
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

--- Comment #5 from Dave Chinner (david@fromorbit.com) ---
On Mon, Aug 10, 2020 at 05:08:07PM +1000, Dave Chinner wrote:
> [cc Jens]
> 
> [Jens, data corruption w/ io_uring and simple fio reproducer. see
> the bz link below.]
> 
> On Mon, Aug 10, 2020 at 01:56:05PM +1000, Dave Chinner wrote:
> > On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
> > > On Fri, Aug 07, 2020 at 03:12:03AM +0000,
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > > > --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
> > > > On Thu, Aug 06, 2020 at 04:57:58AM +0000,
> bugzilla-daemon@bugzilla.kernel.org
> > > > wrote:
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=208827
> > > > > 
> > > > >             Bug ID: 208827
> > > > >            Summary: [fio io_uring] io_uring write data crc32c verify
> > > > >                     failed
> > > > >            Product: File System
> > > > >            Version: 2.5
> > > > >     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
> > > 
> > > FWIW, I can reproduce this with a vanilla 5.8 release kernel,
> > > so this isn't related to contents of the XFS dev tree at all...
> > > 
> > > In fact, this bug isn't a recent regression. AFAICT, it was
> > > introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
> > > reproduce. More info once I've finished bisecting it....
> > 
> > f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
> > commit f67676d160c6ee2ed82917fadfed6d29cab8237c
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   Mon Dec 2 11:03:47 2019 -0700
> > 
> >     io_uring: ensure async punted read/write requests copy iovec
> 
> ....
> 
> Ok, I went back to vanilla 5.8 to continue debugging and adding
> tracepoints, and it's proving strangely difficult to reproduce now.

Which turns out to be caused by a tracepoint I inserted to try to
narrow down if this was an invalidation race. I put this in
invalidate_complete_page:


--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -257,8 +257,11 @@ int invalidate_inode_page(struct page *page)
        struct address_space *mapping = page_mapping(page);
        if (!mapping)
                return 0;
-       if (PageDirty(page) || PageWriteback(page))
+       if (PageDirty(page) || PageWriteback(page)) {
+               trace_printk("ino 0x%lx page %p, offset 0x%lx\n",
+                       mapping->host->i_ino, page, page->index * PAGE_SIZE);
                return 0;
+       }
        if (page_mapped(page))
                return 0;
        return invalidate_complete_page(mapping, page);


And that alone, without even enabling tracepoints, made the
corruption go completely away. So I suspect a page state race
condition and look at POSIX_FADV_DONTNEED, which fio is issuing
before running it's verification reads. First thing that does:

        if (!inode_write_congested(mapping->host))
                __filemap_fdatawrite_range(mapping, offset, endbyte,
                                           WB_SYNC_NONE);

It starts async writeback of the dirty pages. There's 256MB of dirty
pages on these inodes, and iomap tracing indicates the entire 256MB
immediately runs through the trace_iomap_writepage() tracepoint.
i.e. every page goes Dirty -> Writeback and is submitted for async
IO.

Then the POSIX_FADV_DONTNEED code goes and runs
invalidate_mapping_pages(), which ends up try-locking each page and
then running invalidate_inode_page() on the page, which is where the
trace debug I put in on pages under writeback gets hit. So if
changing the invalidation code for pages under writeback makes the
problem go away, then stopping invalidate_mapping_pages() from
racing with page writeback should make the problem go away, too.

This does indeed make the corruption go away:

--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -109,9 +109,8 @@ int generic_fadvise(struct file *file, loff_t offset,
loff_t len, int advice)
        case POSIX_FADV_NOREUSE:
                break;
        case POSIX_FADV_DONTNEED:
                if (!inode_write_congested(mapping->host))
-                       __filemap_fdatawrite_range(mapping, offset, endbyte,
-                                                  WB_SYNC_NONE);
+                       filemap_write_and_wait_range(mapping, offset, endbyte);

                /*
                 * First and last FULL page! Partial pages are deliberately

by making the invalidation wait for the pages to go fully to the
clean state before starting.

This, however, only fixes the specific symptom being tripped over
here.  To further test this, I removed this writeback from
POSIX_FADV_DONTNEED completely so I could trigger writeback via
controlled background writeback. And, as I expected, whenever
background writeback ran to write back these dirty files, the
verification failures triggered again. It is quite reliable.

So it looks like there is some kind of writeback completion vs page
invalidation race condition occurring, but more work is needed to
isolate it further. I don't know what part the async read plays in
the corruption yet, because I don't know how we are getting pages in
the cache where page->index != the file offset stamped in the data.
That smells of leaking PageUptodate flags...

-Dave.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
