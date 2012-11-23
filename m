Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qANLNYfi119123 for <xfs@oss.sgi.com>; Fri, 23 Nov 2012 15:23:34 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	4In4dQMkdpBsKYqS for <xfs@oss.sgi.com>;
	Fri, 23 Nov 2012 13:25:46 -0800 (PST)
Date: Sat, 24 Nov 2012 08:25:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/32] xfs: use btree block initialisation functions in
	growfs
Message-ID: <20121123212544.GJ32450@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-7-git-send-email-david@fromorbit.com>
	<20121123124015.GB12150@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121123124015.GB12150@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Nov 23, 2012 at 07:40:15AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 12, 2012 at 10:53:58PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Factor xfs_btree_init_block() to be independent of the btree cursor,
> > and use the function to initialise btree blocks in the growfs code.
> > This makes adding support for different format btree blocks simple.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_btree.c |   33 ++++++++++++++++++++++++---------
> >  fs/xfs/xfs_btree.h |   11 +++++++++++
> >  fs/xfs/xfs_fsops.c |   37 +++++++++++++------------------------
> >  3 files changed, 48 insertions(+), 33 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
> > index e53e317..121ea99 100644
> > --- a/fs/xfs/xfs_btree.c
> > +++ b/fs/xfs/xfs_btree.c
> > @@ -853,18 +853,22 @@ xfs_btree_set_sibling(
> >  	}
> >  }
> >  
> > -STATIC void
> > +void
> >  xfs_btree_init_block(
> > -	struct xfs_btree_cur	*cur,
> > -	int			level,
> > -	int			numrecs,
> > -	struct xfs_btree_block	*new)	/* new block */
> > +	struct xfs_mount *mp,
> > +	struct xfs_buf	*bp,
> 
> Do we need the mount argument here?  bp->b_mount should always
> be initialized.

Possible.

> > +	__u32		magic,
> > +	__u16		level,
> > +	__u16		numrecs,
> > +	unsigned int	flags)
> >  {
> > -	new->bb_magic = cpu_to_be32(xfs_magics[cur->bc_btnum]);
> > +	struct xfs_btree_block	*new = XFS_BUF_TO_BLOCK(bp);
> 
> Any reaosn not to pass the btree_block directly instead of the buffer?

CRC additions require the block number to be put into the structure,
so we need to pass the buffer.

> 
> > +STATIC void
> > +xfs_btree_init_block_cur(
> > +	struct xfs_btree_cur	*cur,
> > +	int			level,
> > +	int			numrecs,
> > +	struct xfs_buf		*bp)
> > +{
> > +	xfs_btree_init_block(cur->bc_mp, bp, xfs_magics[cur->bc_btnum],
> > +			       level, numrecs, cur->bc_flags);
> 
> I'd scrapt this helper.

I only used it to avoid changing existing code. I can remove it when
CRCs are introduced if you want, as this touches all this code
again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
