Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 826FF7F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 19:39:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11E3DAC008
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 17:39:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vGEyNMyjoUsFUmO3 for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 17:39:20 -0700 (PDT)
Date: Fri, 10 Jul 2015 10:39:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/20] xfs: add an extent to the rmap btree
Message-ID: <20150710003908.GF7943@dastard>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-16-git-send-email-david@fromorbit.com>
	<20150625164123.GD36162@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150625164123.GD36162@bfoster.bfoster>
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

On Thu, Jun 25, 2015 at 12:41:23PM -0400, Brian Foster wrote:
> On Wed, Jun 03, 2015 at 04:04:52PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now all the btree, free space and transaction infrastructure is in
> > place, we can finally add the code to insert reverse mappings to the
> > rmap btree. Freeing will be done in a spearate patch, so just the
> > addition operation can be focussed on here.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_rmap.c | 139 ++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 138 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
> > index 38a92a1..c1e5d23 100644
> > --- a/fs/xfs/libxfs/xfs_rmap.c
> > +++ b/fs/xfs/libxfs/xfs_rmap.c
> > @@ -120,6 +120,18 @@ out_error:
> >  	return error;
> >  }
> >  
> > +/*
> > + * When we allocate a new block, the first thing we do is add a reference to the
> > + * extent in the rmap btree. This takes the form of a [agbno, length, owner]
> > + * record.  Newly inserted extents should never overlap with an existing extent
> > + * in the rmap btree. Hence the insertion is a relatively trivial exercise,
> > + * involving checking for adjacent records and merging if the new extent is
> > + * contiguous and has the same owner.
> > + *
> > + * Note that we have no MAXEXTLEN limits here when merging as the length in the
> > + * record has the full 32 bits available and hence a single record can track the
> > + * entire space in the AG.
> > + */
> >  int
> >  xfs_rmap_alloc(
> >  	struct xfs_trans	*tp,
> > @@ -130,18 +142,143 @@ xfs_rmap_alloc(
> >  	uint64_t		owner)
> >  {
> >  	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_btree_cur	*cur;
> > +	struct xfs_rmap_irec	ltrec;
> > +	struct xfs_rmap_irec	gtrec;
> > +	int			have_gt;
> >  	int			error = 0;
> > +	int			i;
> >  
> >  	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
> >  		return 0;
> >  
> >  	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, owner);
> > -	if (1)
> > +	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
> > +
> > +	/*
> > +	 * For the initial lookup, look for and exact match or the left-adjacent
> > +	 * record for our insertion point. This will also give us the record for
> > +	 * start block contiguity tests.
> > +	 */
> > +	error = xfs_rmap_lookup_le(cur, bno, len, owner, &i);
> > +	if (error)
> > +		goto out_error;
> > +	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
> > +
> 
> Are we intentionally relying on the fact that a left record will always
> exist due to the static metadata blocks that start the AG? If so, I'd
> just suggest to note that in the comment above.

Yes. I thought there was a note somewhere about this, but I'll add a
new one...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
