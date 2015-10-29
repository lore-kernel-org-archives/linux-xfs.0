Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 946247CBF
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 18:38:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 83432304053
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 16:38:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	j8HRuE1OtDk3P6hK for <xfs@oss.sgi.com>;
	Thu, 29 Oct 2015 16:37:58 -0700 (PDT)
Date: Fri, 30 Oct 2015 10:37:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: Don't use unwritten extents for DAX
Message-ID: <20151029233756.GS19199@dastard>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-4-git-send-email-david@fromorbit.com>
	<20151029142950.GE11663@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151029142950.GE11663@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Thu, Oct 29, 2015 at 10:29:50AM -0400, Brian Foster wrote:
> On Mon, Oct 19, 2015 at 02:27:15PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > DAX has a page fault serialisation problem with block allocation.
> > Because it allows concurrent page faults and does not have a page
> > lock to serialise faults to the same page, it can get two concurrent
> > faults to the page that race.
> > 
> > When two read faults race, this isn't a huge problem as the data
> > underlying the page is not changing and so "detect and drop" works
> > just fine. The issues are to do with write faults.
> > 
> > When two write faults occur, we serialise block allocation in
> > get_blocks() so only one faul will allocate the extent. It will,
> > however, be marked as an unwritten extent, and that is where the
> > problem lies - the DAX fault code cannot differentiate between a
> > block that was just allocated and a block that was preallocated and
> > needs zeroing. The result is that both write faults end up zeroing
> > the block and attempting to convert it back to written.
> > 
> > The problem is that the first fault can zero and convert before the
> > second fault starts zeroing, resulting in the zeroing for the second
> > fault overwriting the data that the first fault wrote with zeros.
> > The second fault then attempts to convert the unwritten extent,
> > which is then a no-op because it's already written. Data loss occurs
> > as a result of this race.
> > 
> > Because there is no sane locking construct in the page fault code
> > that we can use for serialisation across the page faults, we need to
> > ensure block allocation and zeroing occurs atomically in the
> > filesystem. This means we can still take concurrent page faults and
> > the only time they will serialise is in the filesystem
> > mapping/allocation callback. The page fault code will always see
> > written, initialised extents, so we will be able to remove the
> > unwritten extent handling from the DAX code when all filesystems are
> > converted.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/dax.c           |  5 +++++
> >  fs/xfs/xfs_aops.c  | 13 +++++++++----
> >  fs/xfs/xfs_iomap.c | 21 ++++++++++++++++++++-
> >  3 files changed, 34 insertions(+), 5 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index c3cb5a5..f4f5b43 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> ...
> >  	tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> > +
> > +	/*
> > +	 * For DAX, we do not allocate unwritten extents, but instead we zero
> > +	 * the block before we commit the transaction.  Ideally we'd like to do
> > +	 * this outside the transaction context, but if we commit and then crash
> > +	 * we may not have zeroed the blocks and this will be exposed on
> > +	 * recovery of the allocation. Hence we must zero before commit.
> > +	 * Further, if we are mapping unwritten extents here, we need to zero
> > +	 * and convert them to written so that we don't need an unwritten extent
> > +	 * callback for DAX. This also means that we need to be able to dip into
> > +	 * the reserve block pool if there is no space left but we need to do
> > +	 * unwritten extent conversion.
> > +	 */
> > +	if (IS_DAX(VFS_I(ip))) {
> > +		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
> > +		tp->t_flags |= XFS_TRANS_RESERVE;
> > +	}
> 
> Am I following the commit log description correctly in that block
> zeroing is only required for DAX faults? Do we zero blocks for DAX DIO
> as well to be consistent, or is that also required (because it looks
> like we still have end_io completion for dio writes anyways)?

DAX DIO will do the zeroing rather than using unwritten extents,
too. But we still have DIO IO completion as that needs to do file
size updates.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
