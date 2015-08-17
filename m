Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE7267F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 17:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9DECB304067
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 15:19:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nzq8WBQxj0oSP3pj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 15:19:55 -0700 (PDT)
Date: Mon, 17 Aug 2015 18:19:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 14/13] xfs: swap leaf buffer into path struct atomically
	during path shift
Message-ID: <20150817221952.GA16225@bfoster.bfoster>
References: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
	<1439830072-61117-1-git-send-email-bfoster@redhat.com>
	<20150817213413.GC714@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150817213413.GC714@dastard>
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

On Tue, Aug 18, 2015 at 07:34:13AM +1000, Dave Chinner wrote:
> On Mon, Aug 17, 2015 at 12:47:52PM -0400, Brian Foster wrote:
...
> > 
> >  fs/xfs/libxfs/xfs_da_btree.c | 25 ++++++++++++++++---------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> > index 3264d81..04a3765 100644
> > --- a/fs/xfs/libxfs/xfs_da_btree.c
> > +++ b/fs/xfs/libxfs/xfs_da_btree.c
> > @@ -1822,6 +1822,7 @@ xfs_da3_path_shift(
> >  	struct xfs_da_args	*args;
> >  	struct xfs_da_node_entry *btree;
> >  	struct xfs_da3_icnode_hdr nodehdr;
> > +	struct xfs_buf		*bp;
> >  	xfs_dablk_t		blkno = 0;
> >  	int			level;
> >  	int			error;
> > @@ -1865,21 +1866,27 @@ xfs_da3_path_shift(
> >  	 * same depth we were at originally.
> >  	 */
> >  	for (blk++, level++; level < path->active; blk++, level++) {
> > +		struct xfs_buf	**bpp = &blk->bp;
> > +
> 
> What do we need this for? The new code is:
> 
> >  		/*
> > +		 * Read the next child block into a local buffer.
> >  		 */
> > +		error = xfs_da3_node_read(args->trans, dp, blkno, -1, &bp,
> > +					  args->whichfork);
> > +		if (error)
> > +			return error;
> >  
> >  		/*
> > +		 * Release the old block (if it's dirty, the trans doesn't
> > +		 * actually let go) and swap the local buffer into the path
> > +		 * structure. This ensures failure of the above read doesn't set
> > +		 * a NULL buffer in an active slot in the path.
> >  		 */
> > +		if (release)
> > +			xfs_trans_brelse(args->trans, blk->bp);
> >  		blk->blkno = blkno;
> > +		*bpp = bp;
> 
> And this can simply be:
> 
> 		blk->bp = bp;
> 
> so I don't think *bpp is necessary at all.
> 

Yeah, that's a thinko. v2 incoming...

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
