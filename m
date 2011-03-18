Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2I44cOv012021 for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 23:04:43 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D580710EE80D
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 21:07:34 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XvcBfyTftIl9Xzgy for <xfs@oss.sgi.com>;
	Thu, 17 Mar 2011 21:07:34 -0700 (PDT)
Date: Fri, 18 Mar 2011 15:07:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] xfs: push the AIL from memory reclaim and periodic
	sync
Message-ID: <20110318040722.GH30195@dastard>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-7-git-send-email-david@fromorbit.com>
	<20110310213144.GA9371@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110310213144.GA9371@infradead.org>
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

On Thu, Mar 10, 2011 at 04:31:44PM -0500, Christoph Hellwig wrote:
> > -STATIC void xfs_ail_splice(struct xfs_ail *, struct list_head *, xfs_lsn_t);
> > -STATIC void xfs_ail_delete(struct xfs_ail *, xfs_log_item_t *);
> > -STATIC xfs_log_item_t * xfs_ail_min(struct xfs_ail *);
> > -STATIC xfs_log_item_t * xfs_ail_next(struct xfs_ail *, xfs_log_item_t *);
> > -
> 
> Reordering and cleanup of unrelated existing functions should be in a
> separate patch.

OK.

> 
> > @@ -55,16 +93,32 @@ xfs_lsn_t
> >  xfs_trans_ail_tail(
> >  	struct xfs_ail	*ailp)
> >  {
> > -	xfs_lsn_t	lsn;
> > +	xfs_lsn_t	lsn = 0;
> >  	xfs_log_item_t	*lip;
> >  
> >  	spin_lock(&ailp->xa_lock);
> >  	lip = xfs_ail_min(ailp);
> > -	if (lip == NULL) {
> > -		lsn = (xfs_lsn_t)0;
> > -	} else {
> > +	if (lip)
> > +		lsn = lip->li_lsn;
> > +	spin_unlock(&ailp->xa_lock);
> > +
> > +	return lsn;
> > +}
> > +
> > +/*
> > + * Return the maximum lsn held in the AIL, or zero if the AIl is empty.
> > + */
> > +static xfs_lsn_t
> > +xfs_ail_max_lsn(
> > +	struct xfs_ail  *ailp)
> > +{
> > +	xfs_lsn_t       lsn = 0;
> > +	xfs_log_item_t  *lip;
> > +
> > +	spin_lock(&ailp->xa_lock);
> > +	lip = xfs_ail_max(ailp);
> > +	if (lip)
> 
> As this is the counterpart to xfs_trans_ail_tail the naming for both
> should be similar.  I much prefer the descriptive _lsn naming over the
> random trans in xfs_trans_ail_tail.

Ok, will change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
