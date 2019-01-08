Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54702 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727662AbfAHOy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 09:54:56 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 68CCB28D22
        for <linux-xfs@vger.kernel.org>; Tue,  8 Jan 2019 14:54:55 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202053] [xfstests generic/464]: XFS corruption and Assertion
 failed: 0, file: fs/xfs/xfs_super.c, line: 985
Date: Tue, 08 Jan 2019 14:54:54 +0000
Message-ID: <bug-202053-201763-bBrUxVv102@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202053-201763@https.bugzilla.kernel.org/>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202053

--- Comment #16 from bfoster@redhat.com ---
On Tue, Jan 08, 2019 at 04:46:39PM +1100, Dave Chinner wrote:
> On Mon, Jan 07, 2019 at 09:41:04AM -0500, Brian Foster wrote:
> > On Sun, Jan 06, 2019 at 08:31:20AM +1100, Dave Chinner wrote:
> > > On Fri, Jan 04, 2019 at 07:32:17AM -0500, Brian Foster wrote:
> > > > On Tue, Dec 25, 2018 at 06:10:59AM +0000,
> bugzilla-daemon@bugzilla.kernel.org wrote:
> > > > - writepages is in progress on a particular file that has decently
> sized
> > > >   post-eof speculative preallocation
> > > > - writepages gets to the point where it looks up or allocates a new
> imap
> > > >   that includes the preallocation, the allocation/lookup result is
> > > >   stored in wpc
> > > > - the file is closed by one process, killing off preallocation, then
> > > >   immediately appended to by another, updating the file size by a few
> > > >   bytes
> > > > - writepages comes back around to xfs_map_blocks() and trims imap to
> the
> > > >   current size, but imap still includes one block of the original
> speculative
> > > >   prealloc (that was truncated and recreated) because the size
> increased
> > > >   between the time imap was stored and trimmed
> > > 
> > > I'm betting hole punch can cause similar problems with cached maps
> > > in writepage. I wrote a patch yonks ago to put a generation number
> > > in the extent fork and to store it in the cached map, and to
> > > invalidate the cached map if they didn't match.
> > > 
> > 
> > Isn't hole punch already serialized with writeback? I thought the issue
> 
> Yes, dirty pages over the range of the hole are flushed flushed
> before we punch the hole. And we do that after preventing new pages
> from being dirtied. But this doesn't prevent background writeback
> from running at the same time on regions of the file outside the
> range to be hole punched. It also does not prevent writeback from
> caching a map that covers the range that has a hole punched in the
> middle of it.
> 
> Say the file has one large allocated extent and all the pages are in
> cache and dirty (e.g. full file overwrite). Hole punch
> runs, locks out new writes and cleans the middle of the file. At the
> same time, background writeback starts at offset zero and
> caches the single extent that maps the entire file. Hole punch then locks the
> extent list, punches out the middle of the file and drops all it's
> locks. writeback is still writing pages at the start of the file,
> oblivious to the hole that has just been punched that made it's
> cached extent map stale.
> 
> App then dirties a new page over the hole, creating a delalloc
> extent.
> 

Ah right, thanks. I had just lost track of this. I was wondering why we
didn't have a test for this problem and then I realized I wrote one[1]
over a year ago and it just never landed. :P

The test uses truncate/pwrite rather than hole punch, but it triggers
the same fundamental problem. It looks like it left off at trying to
find a suitable set of parameters to (reasonably) reliably reproduce on
various test setups without taking forever.

Anyways, I have a small series to include a stable fix and then replace
the whole EOF trim band-aid with an invalidation fix based on
Christoph's aforementioned fork seqno patch. It needs more massage and
testing, but I'll revisit the fstest and include that as well.

Brian

[1] https://marc.info/?l=fstests&m=150902929900510&w=2


> If writeback hasn't yet reached the hole and skipped over it because
> there are no dirty pages in that range (say it
> blocked in the block device because of device congestion or
> throttling), it will see this newly dirtied page and check that it
> is within the range of the cached map. Which it is, because the
> cached map spans the entire file. So writeback will map it directly
> to a bio because it considers the cached map to be correct.
> 
> However, the hole punch made the cached map stale, and the newly
> dirtied page needs to call xfs_iomap_write_allocate() to convert the
> delalloc extent. But because we had no way to detect that the cached
> map no longer reflected the inode's extent map, writeback will
> incorrectly map the newly dirtied data to a freed (and potentially
> reallocated) block on disk. i.e. it's a use after free situation.
> 
> FWIW, the recent range_cyclic changes we made removed one of the
> vectors for this problem (skip over hole, go back to start, hit
> newly dirtied page and write with stale cached map), but the problem
> still exists if the cached extent is large enough and we block
> writeback lower in the IO stack....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
