Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:25252 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbfAEVbf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Jan 2019 16:31:35 -0500
Date: Sun, 6 Jan 2019 08:31:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202053] [xfstests generic/464]: XFS corruption and
 Assertion failed: 0, file: fs/xfs/xfs_super.c, line: 985
Message-ID: <20190105213120.GS4205@dastard>
References: <bug-202053-201763@https.bugzilla.kernel.org/>
 <bug-202053-201763-R7nWMjQIjy@https.bugzilla.kernel.org/>
 <20190104123217.GA16751@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190104123217.GA16751@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org

On Fri, Jan 04, 2019 at 07:32:17AM -0500, Brian Foster wrote:
> On Tue, Dec 25, 2018 at 06:10:59AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> - writepages is in progress on a particular file that has decently sized
>   post-eof speculative preallocation
> - writepages gets to the point where it looks up or allocates a new imap
>   that includes the preallocation, the allocation/lookup result is
>   stored in wpc
> - the file is closed by one process, killing off preallocation, then
>   immediately appended to by another, updating the file size by a few
>   bytes
> - writepages comes back around to xfs_map_blocks() and trims imap to the
>   current size, but imap still includes one block of the original speculative
>   prealloc (that was truncated and recreated) because the size increased
>   between the time imap was stored and trimmed

I'm betting hole punch can cause similar problems with cached maps
in writepage. I wrote a patch yonks ago to put a generation number
in the extent fork and to store it in the cached map, and to
invalidate the cached map if they didn't match.

> The EOF trim approach is known to be a bandaid and potentially racy, but
> ISTM that this problem can be trivially avoided by moving or adding
> trims of wpc->imap immediately after a new one is cached. I don't
> reproduce the problem so far with a couple such extra calls in place.
> 
> Bigger picture, we need some kind of invalidation mechanism similar to
> what we're already doing for dealing with the COW fork in this writeback
> context. I'm not sure the broad semantics used by the COW fork sequence
> counter mechanism is really suitable for the data fork because any
> extent-related change in the fork would cause an invalidation, but I am
> wondering if we could define some subset of less frequent operations for
> the same mechanism to reliably invalidate (e.g., on eofblocks trims, for
> starters).

The patch I had is below - I haven't forward ported it or anything,
just pulled it from my archive to demonstrate what I think we
probably need to be doing here. If we want to limit when it causes
invalidations, then we need probably need to limit which operations
cause the generation number for that inode fork to be bumped.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
