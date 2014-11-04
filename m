Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88E2D7F9B
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 15:18:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4AA2F8F8035
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 13:18:59 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	uIJHxBFfIYXbY1CS for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 13:18:53 -0800 (PST)
Date: Wed, 5 Nov 2014 08:18:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] xfs: bulkstat chunk-formatter has issues
Message-ID: <20141104211838.GB28565@dastard>
References: <1415105601-6455-1-git-send-email-david@fromorbit.com>
	<1415105601-6455-4-git-send-email-david@fromorbit.com>
	<20141104185849.GE55611@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141104185849.GE55611@bfoster.bfoster>
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
Cc: xfs@oss.sgi.com

On Tue, Nov 04, 2014 at 01:58:49PM -0500, Brian Foster wrote:
> On Tue, Nov 04, 2014 at 11:53:18PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The loop construct has issues:
> > 	- clustidx is completely unused, so remove it.
> > 	- the loop tries to be smart by terminating when the
> > 	  "freecount" tells it that all inodes are free. Just drop
> > 	  it as in most cases we have to scan all inodes in the
> > 	  chunk anyway.
> > 	- move the "user buffer left" condition check to the only
> > 	  point where we consume space int eh user buffer.
> > 	- move the initialisation of agino out of the loop, leaving
> > 	  just a simple loop control logic using the clusteridx.
> > 
> > Also, double handling of the user buffer variables leads to problems
> > tracking the current state - use the cursor variables directly
> > rather than keeping local copies and then having to update the
> > cursor before returning.
> > 
> > cc: <stable@vger.kernel.org>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_itable.c | 55 ++++++++++++++++++++---------------------------------
> >  1 file changed, 21 insertions(+), 34 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index 50a3e59..ff31965 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -283,59 +283,46 @@ xfs_bulkstat_ag_ichunk(
> >  	xfs_ino_t			*lastino)
> >  {
> >  	char				__user **ubufp = acp->ac_ubuffer;
> > -	int				ubleft = acp->ac_ubleft;
> > -	int				ubelem = acp->ac_ubelem;
> > -	int				chunkidx, clustidx;
> > +	int				chunkidx;
> >  	int				error = 0;
> >  	xfs_agino_t			agino;
> >  
> > -	for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
> > -	     XFS_BULKSTAT_UBLEFT(ubleft) &&
> > -	     irbp->ir_freecount < XFS_INODES_PER_CHUNK;
> > -	     chunkidx++, clustidx++, agino++) {
> > -		int		fmterror;	/* bulkstat formatter result */
> > +	agino = irbp->ir_startino;
> > +	for (chunkidx = 0; chunkidx < XFS_INODES_PER_CHUNK;
> > +	     chunkidx++, agino++) {
> > +		int		fmterror;
> >  		int		ubused;
> >  		xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, agno, agino);
> >  
> > -		ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
> > -
> >  		/* Skip if this inode is free */
> >  		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
> >  			*lastino = ino;
> >  			continue;
> >  		}
> >  
> > -		/*
> > -		 * Count used inodes as free so we can tell when the
> > -		 * chunk is used up.
> > -		 */
> > -		irbp->ir_freecount++;
> > -
> >  		/* Get the inode and fill in a single buffer */
> >  		ubused = statstruct_size;
> > -		error = formatter(mp, ino, *ubufp, ubleft, &ubused, &fmterror);
> > -		if (fmterror == BULKSTAT_RV_NOTHING) {
> > -			if (error && error != -ENOENT && error != -EINVAL) {
> > -				ubleft = 0;
> > -				break;
> > -			}
> > -			*lastino = ino;
> > -			continue;
> > -		}
> > -		if (fmterror == BULKSTAT_RV_GIVEUP) {
> > -			ubleft = 0;
> > +		error = formatter(mp, ino, *ubufp, acp->ac_ubleft,
> > +				  &ubused, &fmterror);
> > +		if (fmterror == BULKSTAT_RV_GIVEUP ||
> > +		    (error && error != -ENOENT && error != -EINVAL)) {
> > +			acp->ac_ubleft = 0;
> >  			ASSERT(error);
> >  			break;
> >  		}
> > -		if (*ubufp)
> > -			*ubufp += ubused;
> > -		ubleft -= ubused;
> > -		ubelem++;
> > +		if (fmterror == BULKSTAT_RV_NOTHING || error) {
> > +			*lastino = ino;
> > +			continue;
> > +		}
> 
> Not introduced by this patch, but this looks like inconsistent error
> handling. The structure of the code suggests we intend to carry on in
> the event of ENOENT or EINVAL, but said errors can leak out of this
> function if we never get back to the formatter call (e.g., we're at the
> last inode or all subsequent inodes are free).

Good catch - I'll fix it. I'll just zero the error in that branch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
