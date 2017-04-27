Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35704 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033635AbdD0P6w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2017 11:58:52 -0400
Date: Thu, 27 Apr 2017 08:58:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: try to avoid blowing out the transaction
 reservation when bunmaping a shared extent
Message-ID: <20170427155809.GF23371@birch.djwong.org>
References: <20170425020954.GV23371@birch.djwong.org>
 <20170427074042.GB18392@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170427074042.GB18392@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Apr 27, 2017 at 12:40:42AM -0700, Christoph Hellwig wrote:
> > @@ -483,13 +485,24 @@ xfs_bui_recover(
> >  	}
> >  	xfs_trans_ijoin(tp, ip, 0);
> >  
> > +	count = bmap->me_len;
> >  	error = xfs_trans_log_finish_bmap_update(tp, budp, &dfops, type,
> >  			ip, whichfork, bmap->me_startoff,
> > -			bmap->me_startblock, bmap->me_len,
> > -			state);
> > +			bmap->me_startblock, &count, state);
> >  	if (error)
> >  		goto err_dfops;
> >  
> > +	if (count > 0) {
> > +		ASSERT(type == XFS_BMAP_UNMAP);
> > +		irec.br_startblock = bmap->me_startblock;
> > +		irec.br_blockcount = count;
> > +		irec.br_startoff = bmap->me_startoff;
> > +		irec.br_state = state;
> > +		error = xfs_bmap_unmap_extent(tp->t_mountp, &dfops, ip, &irec);
> > +		if (error)
> > +			goto err_dfops;
> > +	}
> 
> Aren't we always returning -EAGAIN from xfs_trans_log_finish_bmap_update
> if count is non-zero?  Seems like this path isn't currently hit by
> testing.

I hit it on generic/187 with a 1k block size.

> 
> > +
> >  	/* Finish transaction, free inodes. */
> >  	error = xfs_defer_finish(&tp, &dfops, NULL);
> >  	if (error)
> 
> > diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
> > index 6408e7d..14543d9 100644
> > --- a/fs/xfs/xfs_trans_bmap.c
> > +++ b/fs/xfs/xfs_trans_bmap.c
> > @@ -63,7 +63,7 @@ xfs_trans_log_finish_bmap_update(
> >  	int				whichfork,
> >  	xfs_fileoff_t			startoff,
> >  	xfs_fsblock_t			startblock,
> > -	xfs_filblks_t			blockcount,
> > +	xfs_filblks_t			*blockcount,
> >  	xfs_exntst_t			state)
> >  {
> >  	int				error;
> > @@ -196,16 +196,23 @@ xfs_bmap_update_finish_item(
> >  	void				**state)
> >  {
> >  	struct xfs_bmap_intent		*bmap;
> > +	xfs_filblks_t			count;
> >  	int				error;
> >  
> >  	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
> > +	count = bmap->bi_bmap.br_blockcount;
> >  	error = xfs_trans_log_finish_bmap_update(tp, done_item, dop,
> >  			bmap->bi_type,
> >  			bmap->bi_owner, bmap->bi_whichfork,
> >  			bmap->bi_bmap.br_startoff,
> >  			bmap->bi_bmap.br_startblock,
> > -			bmap->bi_bmap.br_blockcount,
> > +			&count,
> >  			bmap->bi_bmap.br_state);
> > +	if (!error && count > 0) {
> > +		ASSERT(bmap->bi_type == XFS_BMAP_UNMAP);
> > +		bmap->bi_bmap.br_blockcount = count;
> > +		return -EAGAIN;
> > +	}
> 
> Can we just kill off xfs_trans_log_finish_bmap_update, move the
> code here and avoid the weird calling conventions?

I guess we could open-code all the stuff that it does in
xfs_bmap_update_finish_item and xfs_bui_recover, but I'd hate to have to
remember to update both copies.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
