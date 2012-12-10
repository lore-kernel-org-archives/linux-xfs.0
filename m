Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qBA1ulHj167879 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 19:56:47 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	VQQZEyL3O0vTuI6b for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 17:59:14 -0800 (PST)
Date: Mon, 10 Dec 2012 12:59:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 4/5] xfs: fix the multi-segment log buffer format
Message-ID: <20121210015911.GM15784@dastard>
References: <20121204231801.982422341@sgi.com>
	<20121204224938.906216248@sgi.com>
	<20121208123821.GD29107@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121208123821.GD29107@infradead.org>
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
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Sat, Dec 08, 2012 at 07:38:21AM -0500, Christoph Hellwig wrote:
> On Tue, Dec 04, 2012 at 05:18:05PM -0600, Mark Tinguely wrote:
> > Per Dave Chinner suggestion, this patch:
> >  1) Corrects the detection of whether a multi-segment buffer is
> >     still tracking data.
> >  2) Clears all the buffer log formats for a multi-segment buffer.
> > 
> > Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> > fs/xfs/xfs_buf_item.c  |   13 ++++++++++---
> >  fs/xfs/xfs_buf_item.c  |   13 ++++++++++---
> >  fs/xfs/xfs_trans_buf.c |    7 +++++--
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> > 
> > Index: b/fs/xfs/xfs_buf_item.c
> > ===================================================================
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -611,7 +611,7 @@ xfs_buf_item_unlock(
> >  {
> >  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> >  	struct xfs_buf		*bp = bip->bli_buf;
> > -	int			aborted;
> > +	int			aborted, clean, i;
> >  	uint			hold;
> >  
> >  	/* Clear the buffer's association with this transaction. */
> > @@ -654,8 +654,15 @@ xfs_buf_item_unlock(
> >  	 * If the buf item isn't tracking any data, free it, otherwise drop the
> >  	 * reference we hold to it.
> >  	 */
> > -	if (xfs_bitmap_empty(bip->__bli_format.blf_data_map,
> > -			     bip->__bli_format.blf_map_size))
> > +	clean = 1;
> > +	for (i = 0; i < bip->bli_format_count; i++) {
> > +		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
> > +			     bip->bli_formats[i].blf_map_size)) {
> > +			clean = 0;
> > +			break;
> > +		}
> > +	}
> > +	if (clean)
> >  		xfs_buf_item_relse(bp);
> >  	else
> >  		atomic_dec(&bip->bli_refcount);
> 
> Looks ok, although avoiding the clean variable would be even better:
> 
> 	for (i = 0; i < bip->bli_format_count; i++) {
> 		if (!xfs_bitmap_empty(bip->bli_formats[i].blf_data_map,
> 				      bip->bli_formats[i].blf_map_size)) {
> 			atomic_dec(&bip->bli_refcount);
> 			goto out;
> 		}
> 	}
> 
> 	xfs_buf_item_relse(bp);
> out:

Definitely better.

> 
> bu that might be getting a bit too much into bikeshedding.
> 
> What I'm worried more about is how we semi-duplicate this bli_refcount
> decrement vs xfs_buf_item_relse in xfs_trans_brelse, but use the
> xfs_buf_item_dirty (aka XFS_BLI_DIRTY) check there instead.

Well, we only get to the case in xfs_trans_brelse() if the buffer
was not modified in this transaction. Hence the check is for whether
it was modified in a previous transaction (and hence is in the AIL)
and not whether the buffer has any changes in the bitmap or not.

So to me the checks seem to be for two different cases - one if so
whether the buffer has physical changes, the other for whether it is
currently in the AIL.

A further complication is that the XFS_BLI_DIRTY flag is cleared
when the buffer is marked stale, so any path that looks at this flag
needs to specifically handle the XFS_BLI_STALE case before the dirty
case.

It seems to me that the one place that XFS_BLI_DIRTY is checked
could actually be replaced with a:

	if (!(bip->bli_item.li_flags & XFS_LI_IN_AIL)) {
		....
	}

check and hence remove the reason for it's existence completely.
At that point, the flag could be repurposed as you suggest here:

> It seems like the proper fix might be to:
> 
>  - only set XFS_BLI_DIRTY in xfs_buf_item_log if we actually set
>    any bits in a bitmap
>  - use the XFS_BLI_DIRTY check in xfs_buf_item_unlock as well
>  - kill the useless xfs_buf_item_dirty wrapper
> 
> Probably both of these aren't worth doing it for now as we'll need to
> get fixes into Linus tree quickly, so:

Agreed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
