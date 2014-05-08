Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D4AC07F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 17:05:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9AC8C304051
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 15:05:27 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	LIvz3n8QkdVu35Pc for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 15:05:25 -0700 (PDT)
Date: Fri, 9 May 2014 08:05:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove XFS_TRANS_RESERVE in collapse range
Message-ID: <20140508220505.GG26353@dastard>
References: <002601cf6aa2$c59cd670$50d68350$@samsung.com>
	<20140508133637.GB47272@bfoster.bfoster>
	<20140508211712.GD26353@dastard>
	<20140508215115.GA30141@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140508215115.GA30141@laptop.bfoster>
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
Cc: Namjae Jeon <namjae.jeon@samsung.com>, xfs@oss.sgi.com

On Thu, May 08, 2014 at 05:51:16PM -0400, Brian Foster wrote:
> On Fri, May 09, 2014 at 07:17:12AM +1000, Dave Chinner wrote:
> > On Thu, May 08, 2014 at 09:36:37AM -0400, Brian Foster wrote:
> > > On Thu, May 08, 2014 at 06:49:14PM +0900, Namjae Jeon wrote:
> > > > There is no need to dip into reserve pool. Reserve pool is used for much
> > > > more important things. And xfs_trans_reserve will never return ENOSPC
> > > > because punch hole is already done. If we get ENOSPC, collapse range
> > > > will be simply failed.
> > > > 
> > > > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > > > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > > > ---
> > > >  fs/xfs/xfs_bmap_util.c | 3 +--
> > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > > index 296160b..91a43c5 100644
> > > > --- a/fs/xfs/xfs_bmap_util.c
> > > > +++ b/fs/xfs/xfs_bmap_util.c
> > > > @@ -1519,7 +1519,6 @@ xfs_collapse_file_space(
> > > >  
> > > >  	while (!error && !done) {
> > > >  		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> > > > -		tp->t_flags |= XFS_TRANS_RESERVE;
> > > 
> > > Makes sense.
> > > 
> > > >  		/*
> > > >  		 * We would need to reserve permanent block for transaction.
> > > >  		 * This will come into picture when after shifting extent into
> > > > @@ -1529,7 +1528,7 @@ xfs_collapse_file_space(
> > > >  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
> > > >  				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
> > > >  		if (error) {
> > > > -			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
> > > > +			ASSERT(XFS_FORCED_SHUTDOWN(mp));
> > > 
> > > The xfs_trans_reserve() call still reserves XFS_DIOSTRAT_SPACE_RES()
> > > blocks, so therefore I think ENOSPC is still a possibility. The question
> > > is probably whether or not we need to reserve blocks for this
> > > transaction.
> > > 
> > > Making a pass through the code... we have the possibility of deleting a
> > > btree record in xfs_bmap_shift_extents(). This in turn could potentially
> > > free a btree block, which frees space. I _think_ this could mean we
> > > want to keep the block reservation because we update the free space
> > > trees, but I suppose that could be handled by the freelist...
> > > 
> > > Perhaps Dave can confirm which direction we should go here..?
> > 
> > Having collapse range fail with ENOSPC is not an issue - it is being
> > executed in a context where we can fail safely and return an error
> > to the user.
> > 
> > XFS_TRANS_RESERVE is used in places where a failure is unrecoverable
> > or there is no one to report the error to.  e.g. prevent data loss
> > due to ENOSPC in unwritten extent conversion during background
> > buffered write IO completion
> > 
> > So here there is no need for it at all....
> > 
> 
> Yeah, dropping XFS_TRANS_RESERVE makes sense. The question I have is
> whether we should reserve blocks for this transaction (for a potential
> bmbt block free). If we do reserve blocks, then I assume the ENOSPC
> assert should stick around.

Yes, the assert is wrong because xfs_trans_reserve() can
return ENOMEM as well as ENOSPC. It should just be removed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
