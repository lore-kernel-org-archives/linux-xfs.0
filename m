Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59778 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbeC0XaD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 19:30:03 -0400
Date: Tue, 27 Mar 2018 16:29:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/20] xfs: add repair helpers for the reverse mapping
 btree
Message-ID: <20180327232958.GI4818@magnolia>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210857318.13184.219852203461550085.stgit@magnolia>
 <20180327230327.GU18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327230327.GU18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 28, 2018 at 10:03:27AM +1100, Dave Chinner wrote:
> On Mon, Mar 26, 2018 at 04:56:13PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add a couple of functions to the reverse mapping btree that will be used
> > to repair the rmapbt.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Not exactly sure how/what these will be used for yet, so it's hard
> to say if they are correct or not. :P
> 
> Couple of things, though.
> 
> > @@ -2454,3 +2482,54 @@ xfs_rmap_record_exists(
> >  		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
> >  	return 0;
> >  }
> > +
> > +struct xfs_rmap_has_other_keys {
> > +	uint64_t			owner;
> > +	uint64_t			offset;
> > +	bool				*has_rmap;
> 
> Seems very strange this is a pointer, given we are passing the
> structure.
> 
> > +	unsigned int			flags;
> > +};
> 
> struct xfs_rmap_key_state

Ok.

> > +/* For each rmap given, figure out if it doesn't match the key we want. */
> > +STATIC int
> > +xfs_rmap_has_other_keys_helper(
> > +	struct xfs_btree_cur		*cur,
> > +	struct xfs_rmap_irec		*rec,
> > +	void				*priv)
> 
> And this can become just xfs_rmap_has_other_keys()

Uh... did you mean (struct xfs_rmap_key_state *) ?

The awkward void *priv argument + type conversion is there because
xfs_rmap_query_range takes a function with a void pointer as its third
parameter, and changing it here causes gcc complaints.

> > +{
> > +	struct xfs_rmap_has_other_keys	*rhok = priv;
> > +
> > +	if (rhok->owner == rec->rm_owner && rhok->offset == rec->rm_offset &&
> > +	    ((rhok->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rhok->flags)
> > +		return 0;
> > +	*rhok->has_rmap = true;
> > +	return XFS_BTREE_QUERY_RANGE_ABORT;
> > +}
> > +
> > +/*
> > + * Given an extent and some owner info, can we find records overlapping
> > + * the extent whose owner info does not match the given owner?
> > + */
> > +int
> > +xfs_rmap_has_other_keys(
> > +	struct xfs_btree_cur		*cur,
> > +	xfs_agblock_t			bno,
> > +	xfs_extlen_t			len,
> > +	struct xfs_owner_info		*oinfo,
> > +	bool				*has_rmap)
> > +{
> > +	struct xfs_rmap_irec		low = {0};
> > +	struct xfs_rmap_irec		high;
> > +	struct xfs_rmap_has_other_keys	rhok;
> > +
> > +	xfs_owner_info_unpack(oinfo, &rhok.owner, &rhok.offset, &rhok.flags);
> > +	*has_rmap = false;
> > +	rhok.has_rmap = has_rmap;
> 
> Oh, you're embedding another bool variable in it. I think it would
> be better to copy in/out of the internal structure rather than
> pass a pointer of unknown scope around....
> 
> 	rhok.has_rmap = *has_rmap;

Fair 'enough.

> > +
> > +	low.rm_startblock = bno;
> > +	memset(&high, 0xFF, sizeof(high));
> > +	high.rm_startblock = bno + len - 1;
> > +
> > +	return xfs_rmap_query_range(cur, &low, &high,
> > +			xfs_rmap_has_other_keys_helper, &rhok);
> 
> 	error = xfs_rmap_query_range(..., &rhok)
> 	*has_rmap = rhok.has_rmap;
> 	return error;

Done.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
