Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23585 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933167AbeAKWOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 17:14:40 -0500
Date: Fri, 12 Jan 2018 09:09:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] libxfs: manage xfs_buf_zone count within cache
Message-ID: <20180111220951.GV16421@dastard>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
 <1515699458-6925-7-git-send-email-sandeen@sandeen.net>
 <20180111202026.GG5602@magnolia>
 <f55b38bc-09eb-46f9-4b64-97f1117ac7ca@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f55b38bc-09eb-46f9-4b64-97f1117ac7ca@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Jan 11, 2018 at 02:48:33PM -0600, Eric Sandeen wrote:
> 
> 
> On 1/11/18 2:20 PM, Darrick J. Wong wrote:
> > On Thu, Jan 11, 2018 at 01:37:36PM -0600, Eric Sandeen wrote:
> >> Fake up the xfs_buf_zone allocated count a bit to account
> >> for buffers freed to and allocated from cache.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> >> ---
> >>  libxfs/rdwr.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> >> index 474e5eb..c5ffd4d 100644
> >> --- a/libxfs/rdwr.c
> >> +++ b/libxfs/rdwr.c
> >> @@ -665,6 +665,7 @@ __libxfs_getbufr(int blen)
> >>  				free(bp->b_maps);
> >>  			bp->b_maps = NULL;
> >>  		}
> >> +		xfs_buf_zone->allocated++;
> > 
> > I'm confused.  kmem_zone_zalloc increments zone->allocated and
> > kmem_zone_free decrements it.  Now we're messing with ->allocated
> > ourselves, which means that buffers that have ended up on
> > xfs_buf_freelist are still allocated (according to the heap) but the
> > zone accounting thinks the buffer is freed?
> > 
> > <goes away, reviews the next patch, comes back>
> > 
> > The next patch has xfs_buf_freelist frees the buffer directly and
> > bypassing kmem_zone_free.  So I wonder, if you change the next patch to
> > call kmem_zone_free and kill this patch, won't the accounting work out?
> > 
> > (xfs buf zone allocated == 0)
> > 
> > bp = _zone_alloc()
> > xfs_buf_zone->allocated++
> > 
> > ...do stuff with buffer...
> > 
> > xfs_buf_relse(bp)
> > list_add(bp, xfs_buf_freelist)
> > 
> > ...buffer still allocated, xfs_buf_zone->allocated == 1...
> > 
> > libxfs_bcache_free()
> > _zone_free(bp)
> > xfs_buf_zone->allocated--
> > 
> > ...exit program, and:
> > xfs_buf_zone->allocated == 0
> > 
> > I think killing this patch and teaching the next one to kmem_zone_free
> > the buffer works, right?  Or am I missing some subtlety here, in which
> > case said subtlety needs comments.
> 
> Yes, it would work out.  This patch was trying to fake up actual use
> by libxfs, because my main goal was to be able to find leaks in libxfs.
> Counting it as still allocated when libxfs thinks it's put it away
> seems to confuse that goal.
> 
> In the end, it's just where I want to draw the line for the accounting.
> 
> In this way I was hoping to keep the cache details out of that
> accounting.  When libxfs says the buffer is done and puts the last ref,
> it's considered to be freed by libxfs, whether or not the cache chooses
> to hang on to it, discard it later, or whatever.

It's not the job of the zone allocator to track whether something
is cached or not - it just tracks how many objects are allocated.

Indeed, the libxfs cache iitself keeps track of how many objects it
has remaining in it, and if you define CACHE_DEBUG it will issue a
warning if the cache is not empty after it has been purged and is
being torn down.  i.e. we already have debug mechanisms to tell if
we are leaking objects through the cache...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
