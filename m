Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:23879 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727383AbfAHFqn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 00:46:43 -0500
Date: Tue, 8 Jan 2019 16:46:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202053] [xfstests generic/464]: XFS corruption and
 Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 985
Message-ID: <20190108054639.GV4205@dastard>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
 <bug-202053-201763-R7nWMjQIjy@https.bugzilla.kernel.org/>
 <20190104123217.GA16751@bfoster>
 <20190105213120.GS4205@dastard>
 <20190107144104.GA5506@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107144104.GA5506@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org

On Mon, Jan 07, 2019 at 09:41:04AM -0500, Brian Foster wrote:
> On Sun, Jan 06, 2019 at 08:31:20AM +1100, Dave Chinner wrote:
> > On Fri, Jan 04, 2019 at 07:32:17AM -0500, Brian Foster wrote:
> > > On Tue, Dec 25, 2018 at 06:10:59AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > - writepages is in progress on a particular file that has decently sized
> > >   post-eof speculative preallocation
> > > - writepages gets to the point where it looks up or allocates a new imap
> > >   that includes the preallocation, the allocation/lookup result is
> > >   stored in wpc
> > > - the file is closed by one process, killing off preallocation, then
> > >   immediately appended to by another, updating the file size by a few
> > >   bytes
> > > - writepages comes back around to xfs_map_blocks() and trims imap to the
> > >   current size, but imap still includes one block of the original speculative
> > >   prealloc (that was truncated and recreated) because the size increased
> > >   between the time imap was stored and trimmed
> > 
> > I'm betting hole punch can cause similar problems with cached maps
> > in writepage. I wrote a patch yonks ago to put a generation number
> > in the extent fork and to store it in the cached map, and to
> > invalidate the cached map if they didn't match.
> > 
> 
> Isn't hole punch already serialized with writeback? I thought the issue

Yes, dirty pages over the range of the hole are flushed flushed
before we punch the hole. And we do that after preventing new pages
from being dirtied. But this doesn't prevent background writeback
from running at the same time on regions of the file outside the
range to be hole punched. It also does not prevent writeback from
caching a map that covers the range that has a hole punched in the
middle of it.

Say the file has one large allocated extent and all the pages are in
cache and dirty (e.g. full file overwrite). Hole punch
runs, locks out new writes and cleans the middle of the file. At the
same time, background writeback starts at offset zero and
caches the single extent that maps the entire file. Hole punch then locks the
extent list, punches out the middle of the file and drops all it's
locks. writeback is still writing pages at the start of the file,
oblivious to the hole that has just been punched that made it's
cached extent map stale.

App then dirties a new page over the hole, creating a delalloc
extent.

If writeback hasn't yet reached the hole and skipped over it because
there are no dirty pages in that range (say it
blocked in the block device because of device congestion or
throttling), it will see this newly dirtied page and check that it
is within the range of the cached map. Which it is, because the
cached map spans the entire file. So writeback will map it directly
to a bio because it considers the cached map to be correct.

However, the hole punch made the cached map stale, and the newly
dirtied page needs to call xfs_iomap_write_allocate() to convert the
delalloc extent. But because we had no way to detect that the cached
map no longer reflected the inode's extent map, writeback will
incorrectly map the newly dirtied data to a freed (and potentially
reallocated) block on disk. i.e. it's a use after free situation.

FWIW, the recent range_cyclic changes we made removed one of the
vectors for this problem (skip over hole, go back to start, hit
newly dirtied page and write with stale cached map), but the problem
still exists if the cached extent is large enough and we block
writeback lower in the IO stack....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
