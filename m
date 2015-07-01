Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 683917F50
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 18:10:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D9531AC005
	for <xfs@oss.sgi.com>; Wed,  1 Jul 2015 16:10:31 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id V75yWY4V66puymam (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Jul 2015 16:10:29 -0700 (PDT)
Date: Wed, 1 Jul 2015 16:10:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/14] libxfs: adjust refcounts in reflink btree
Message-ID: <20150701231022.GC10043@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
	<20150625233923.4992.89446.stgit@birch.djwong.org>
	<20150701010654.GQ22807@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150701010654.GQ22807@dastard>
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

On Wed, Jul 01, 2015 at 11:06:54AM +1000, Dave Chinner wrote:
> On Thu, Jun 25, 2015 at 04:39:23PM -0700, Darrick J. Wong wrote:
> > Provide a function to adjust the reference counts for a range of
> > blocks in the reflink btree.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_reflink_btree.c |  406 +++++++++++++++++++++++++++++++++++++
> >  fs/xfs/libxfs/xfs_reflink_btree.h |    4 
> >  2 files changed, 410 insertions(+)
> 
> As per previous comments, this all belongs in
> fs/xfs/libxfs/xfs_reflink.c...
> 
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_reflink_btree.c b/fs/xfs/libxfs/xfs_reflink_btree.c
> > index 8a0fa5d..380ed72 100644
> > --- a/fs/xfs/libxfs/xfs_reflink_btree.c
> > +++ b/fs/xfs/libxfs/xfs_reflink_btree.c
> > @@ -529,3 +529,409 @@ xfs_reflinkbt_delete(
> >  error0:
> >  	return error;
> >  }
> > +
> > +#ifdef REFLINK_DEBUG
> > +static void
> > +dump_cur_loc(
> > +	struct xfs_btree_cur	*cur,
> > +	const char		*str,
> > +	int			line)
> > +{
> > +	xfs_agblock_t		gbno;
> > +	xfs_extlen_t		glen;
> > +	xfs_nlink_t		gnr;
> > +	int			i;
> > +
> > +	xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
> > +	printk(KERN_INFO "%s(%d) cur[%d]:[%u,%u,%u,%d] ", str, line,
> > +	       cur->bc_ptrs[0], gbno, glen, gnr, i);
> > +	if (i && cur->bc_ptrs[0]) {
> > +		cur->bc_ptrs[0]--;
> > +		xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
> > +		printk("left[%d]:[%u,%u,%u,%d] ", cur->bc_ptrs[0],
> > +		       gbno, glen, gnr, i);
> > +		cur->bc_ptrs[0]++;
> > +	}
> > +
> > +	if (i && cur->bc_ptrs[0] < xfs_reflinkbt_get_maxrecs(cur, 0)) {
> > +		cur->bc_ptrs[0]++;
> > +		xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
> > +		printk("right[%d]:[%u,%u,%u,%d] ", cur->bc_ptrs[0],
> > +		       gbno, glen, gnr, i);
> > +		cur->bc_ptrs[0]--;
> > +	}
> > +	printk("\n");
> > +}
> > +#else
> > +# define dump_cur_loc(c, s, l)
> > +#endif
> 
> Use trace points on lookup/update/insert/delete so debug like this
> is unnecessary.
> 
> 
> > +/*
> > + * Adjust the ref count of a range of AG blocks.
> > + */
> > +int						/* error */
> > +xfs_reflinkbt_adjust_refcount(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_trans	*tp,		/* transaction pointer */
> > +	struct xfs_buf		*agbp,		/* buffer for agf structure */
> > +	xfs_agnumber_t		agno,		/* allocation group number */
> > +	xfs_agblock_t		agbno,		/* start of range */
> > +	xfs_extlen_t		aglen,		/* length of range */
> > +	int			adj)		/* how much to change refcnt */
> 
> 350 line function. Needs factoring. Also needs a comment explaining
> the algorithm. 
> 
> > +{
> > +	struct xfs_btree_cur	*cur;
> > +	int			error;
> > +	int			i, have;
> > +	bool			real_crl;	/* cbno/clen is on disk? */
> > +	xfs_agblock_t		lbno, cbno, rbno;	/* rlextent start */
> > +	xfs_extlen_t		llen, clen, rlen;	/* rlextent length */
> > +	xfs_nlink_t		lnr, cnr, rnr;		/* rlextent refcount */
> 
> "num" is the usual shorthand for "number". And in this case, nr is
> extremely ambiguous: Number of records, number of reflinks, some
> other number? I can't easily tell when I read the code, so the
> variable names need to be better. factoring will certainly help
> here.

"refc" as shorthand for reference count, perhaps?

> > +	xfs_agblock_t		bno;		/* ag bno in the loop */
> > +	xfs_agblock_t		agbend;		/* end agbno of the loop */
> > +	xfs_extlen_t		len;		/* remaining len to add */
> > +	xfs_nlink_t		new_cnr;	/* new refcount */
> > +
> > +	CHECK_AG_NUMBER(mp, agno);
> > +	CHECK_AG_EXTENT(mp, agbno, aglen);
> 
> No real need for these checks - bad agno or extent sizes shoul dhave
> been validated long before this.
> 
> > +
> > +	/*
> > +	 * Allocate/initialize a cursor for the by-number freespace btree.
> > +	 */
> > +	cur = xfs_reflinkbt_init_cursor(mp, tp, agbp, agno);
> 
> You can kill that incorrect comment.
> 
> > +
> > +	/*
> > +	 * Split a left rlextent that crosses agbno.
> > +	 */
> 
> These comments need some ascii art displaying the before, current
> extent and after states so it's clear what the intent is. As it is,
> I'd probably split these into "left/right/middle" helper functions,
> as there is no state created by these initial overlap splits
> used later in the function. That would get rid of excessive
> indentation, make the error handling more obvious, etc.

Ok, I'll draw some pictures. :)

> > +	error = xfs_reflink_lookup_le(cur, agbno, &have);
> > +	if (error)
> > +		goto error0;
> 
> 		goto out_error;
> 
> > +	if (have) {
> 
> if I "have" what?  "found_rec" would be a better name, because then
> the code reads clearly...
> 
> > +	/*
> > +	 * Start iterating the range we're adjusting.  rlextent boundaries
> > +	 * should be at agbno and agbend.
> > +	 */
> 
> Trying to work my way through this loop, but the logic is hard to
> follow. It's hurting my head trying to work out what it is supposed
> to be doing, so I'm going to wait for more comments, ascii art, and
> factoring before really looking at it.

:)

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
