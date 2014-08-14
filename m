Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06F2C7F47
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 14:09:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4717304032
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 12:09:24 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QTzRLESBNkAEdGM5 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 12:09:23 -0700 (PDT)
Date: Thu, 14 Aug 2014 15:09:18 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: hole the inode lock across a full file collapse
Message-ID: <20140814190918.GB51682@bfoster.bfoster>
References: <1407523766-62233-1-git-send-email-bfoster@redhat.com>
	<1407523766-62233-3-git-send-email-bfoster@redhat.com>
	<20140813154229.GB4426@laptop.bfoster>
	<20140814031136.GG20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140814031136.GG20518@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 14, 2014 at 01:11:36PM +1000, Dave Chinner wrote:
> On Wed, Aug 13, 2014 at 11:42:29AM -0400, Brian Foster wrote:
> > On Fri, Aug 08, 2014 at 02:49:26PM -0400, Brian Foster wrote:
> > > A file collapse stress test workload reproduces collapse failures
> > > mid-operation due to changes in the inode fork extent count across
> > > extent shift cycles. xfs_collapse_file_space() currently calls
> > > xfs_bmap_shift_extents() to shift one extent at a time per transaction.
> > > The extent index is used to track the next extent to shift after each
> > > iteration.
> 
> Right, it does so after writing back all the dirty pages and
> invalidating the cache. This is done under the IOLOCK_EXCL, so we
> should end up with nothing being able to newly dirty the inode while
> the collapse range operation is in progress.
> > > 
> > > A concurrent fsx and fsstress workload reproduces a scenario where the
> > > extent count changes during this sequence, causing the 'current_ext'
> > > index to become inaccurate and possibly skip shifting an extent. The
> > > likely result of this behavior is the subsequent shift attempt will not
> > > find a hole in the area of the skipped extent and fail, leaving the file
> > > in a partially collapsed state.
> > > 
> > > This occurs because the ilock is released and acquired across each
> > > transaction and each individual extent shift. Tracepoint output shows
> > > that once the ilock is released after an extent shift, a pending
> > > blocking writeback (e.g., sync) can acquire the lock and proceed before
> > > the next extent is shifted down. If the writeback converts part of a
> > > delayed allocation earlier in the file, for example, it can insert a new
> > > extent into the map. Tracing confirms a call to
> > > xfs_bmap_add_extent_delay_real() in this particular instance.
> 
> Are we getting a dirty extent in the range being collapsed, or does
> it exist outside the range being shifted? If outside, then shouldn't
> we just sync the entire file first? i.e. treat it the same way as we
> do xfs_swap_extents()?
> 

The dirty extent is prior to the range being collapsed, presumably
already dirty by the time we acquire the iolock. The free space portion
of the collapse currently only syncs from the start of the range to EOF.

Syncing the entire file is something I was planning to experiment with,
particularly since it seems like the remaining failure I mentioned in
the series intro appears to be related to hitting a delalloc extent
during the collapse. I don't yet know how that occurs, but my last test
dumped enough trace data to show a startblock value that includes the
mask used for delalloc extents. The collapse attempts to look up an
extent in the bmap btree with these values and falls over when it's not
found.

> Realistically, cur_extent is not valid once we drop the ILOCK.
> Perhaps we should keep the offset of the extent we are up to in the
> shift, and then look up the offset to get current extent map index
> once we pick the ILOCK back up. That way we avoid issues with other
> parts of the extent map changing between ILOCK hold contexts.
> 

I noticed that one or more of the other bmap functions do something like
this. Unless there's some other reason that we don't want to drop ilock
here, that sounds like a safer approach. Thanks.

> > > To prevent this scenario, hold the ilock across the entire extent shift
> > > loop in xfs_collapse_file_space().
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_bmap_util.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index 2f1e30d..96eb97b 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -1474,6 +1474,8 @@ xfs_collapse_file_space(
> > >  	if (error)
> > >  		return error;
> > >  
> > > +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > > +
> > 
> > I realized this moves the lock outside of the xfs_trans_reserve(), thus
> > opening a potential deadlock scenario with regard to the log. I suppose
> > this might be harder to hit in real life than a sync() causing the
> > operation to fall over mid-sequence, so I'm still Ok with keeping this
> > unless anybody objects.
> 
> We can't do that. Inode locking rules explicitly forbid it - we've
> avoided needing to do break this rule for 20 years, so let's not
> start making exceptions now just because it's a "simple fix".
> 

Sounds good, let's drop this one then and I'll revisit it. Are we still
Ok with the first patch? I think that one is still warranted since it
limits the current flaws of collapse to the collapse operation itself.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
