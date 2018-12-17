Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:43004 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbeLQXVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Dec 2018 18:21:39 -0500
Date: Tue, 18 Dec 2018 10:21:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] iomap: optimize iomap_is_partially_uptodate for full
 page range
Message-ID: <20181217232133.GD10644@dastard>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
 <1544739929-21651-4-git-send-email-sandeen@sandeen.net>
 <20181214030528.GK6311@dastard>
 <568c811c-bfd5-216e-30a0-c54ebc2989a0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <568c811c-bfd5-216e-30a0-c54ebc2989a0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de

On Fri, Dec 14, 2018 at 08:10:19AM -0600, Eric Sandeen wrote:
> On 12/13/18 9:05 PM, Dave Chinner wrote:
> > On Thu, Dec 13, 2018 at 04:25:29PM -0600, Eric Sandeen wrote:
> >> From: Eric Sandeen <sandeen@redhat.com>
> >>
> >> We only call ->is_partially_uptodate to look for an uptodate range
> >> within a not-uptodate page.
> >>
> >> If the range covers all blocks in the page, there is no point to checking
> >> each block individually - if the whole range (i.e. the whole page) were
> >> uptodate, the page would be uptodate as well.  Hence in this case, we
> >> can return early and skip the loop.
> >>
> >> This is similar to what is done in block_is_partially_uptodate().
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> >> ---
> >>  fs/iomap.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/fs/iomap.c b/fs/iomap.c
> >> index ce837d9..7d7d985 100644
> >> --- a/fs/iomap.c
> >> +++ b/fs/iomap.c
> >> @@ -515,6 +515,10 @@ struct iomap_readpage_ctx {
> >>  	first = from >> inode->i_blkbits;
> >>  	last = (from + len - 1) >> inode->i_blkbits;
> >>  
> >> +	/* If page wasn't uptodate and range covers all blocks: no partial */
> >> +	if (first == 0 && last == (PAGE_SIZE - 1) >> inode->i_blkbits)
> >> +		return 0;
> >> +
> > 
> > Even if the range covers the entire page, we still have to check
> > that all the individual blocks in the page are up to date or not.
> > Hence I think this is wrong....
> 
> Didn't PageUptodate(page) answer that question already in the caller?
> 
> The caller does:
> 
>                         if (PageUptodate(page))
>                                 goto page_ok;
> ...
>                         if (!mapping->a_ops->is_partially_uptodate(page,
>                                                         offset, iter->count))
>                                 goto page_not_up_to_date_locked;
> 
> 
> So if it was found to be uptodate, we never called this op.  If we /were/
> called (page was not uptodate) that can only be because at least one block in
> the page is not uptodate.  So what's the need for checking them all again?

AFAIA, ->is_partially_uptodate() is supposed to use page private
data to determine if the page is up to date, not assume that because
the range spans the entire page it's not uptodate.

i.e. if the method relies on the caller to perform certain
-undocumented- actions to ensure that the method does the right
thing, then the API and method is broken. To then make undocumented
optimisations in the method implementations to avoid checking
private state based on the undocumented assumption that callers have
all done some certain undocumented things, well, that's a pretty
awful API and even worse documentation...

> block_is_partially_uptodate does the same thing:
> 
>         if (from < blocksize && to > PAGE_SIZE - blocksize)
>                 return 0;

Which, again, assumes that the caller has done certain things and
that there are specific, fixed, undocumented access and page private
state initialisation assumptions made by the callers of
->is_partially_uptodate().

> Still, this also seems like maybe something the caller should do instead.

*nod*

IMO all the block size vs page size, page locking, truncation
checks, etc should be wrapped up in the ->is_partially_uptodate()
method. i.e. it's really a ->page_range_contains_data() check, and
really has nothing to do with the overall PageUptodate() flag state.

FWIW, if you look at how page_seek_hole_data() uses
->is_partially_uptodate - it calls it multiple times on the same
page asking whether each individual block on the page is up to date.
It doesn't even check PageUptodate() for block size < page size, so
assumptions in ->is_partially_uptodate that PageUptodate() has
already been checked are clearly invalid...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
