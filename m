Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08BGtfK034898 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 05:16:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A5381DAFEE1
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2010 03:17:47 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	r9tBuCIDh2IfUYRA for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2010 03:17:47 -0800 (PST)
Date: Fri, 8 Jan 2010 22:17:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: Sort delayed write buffers before dispatch
Message-ID: <20100108111744.GA10735@discord.disaster>
References: <1262649861-28530-1-git-send-email-david@fromorbit.com>
	<1262649861-28530-4-git-send-email-david@fromorbit.com>
	<20100108111152.GA29812@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100108111152.GA29812@infradead.org>
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

On Fri, Jan 08, 2010 at 06:11:52AM -0500, Christoph Hellwig wrote:
> > +/*
> > + * Compare function is more complex than it needs to be because
> > + * the return value is only 32 bits and we are doing comparisons
> > + * on 64 bit values
> > + */
> > +int
> > +xfs_buf_cmp(
> 
> Should be marked static.
> 
> > +void
> > +xfs_buf_delwri_sort(
> > +	xfs_buftarg_t	*target,
> > +	struct list_head *list)
> > +{
> > +	list_sort(NULL, list, xfs_buf_cmp);
> > +}
> 
> Same here.  Not sure I would even bother with the wrapper.  Also the
> first argument is entirely unused.
> 
> >  STATIC int
> >  xfsbufd(
> >  	void		*data)
> >  {
> > +	xfs_buftarg_t   *target = (xfs_buftarg_t *)data;
> >  
> >  	current->flags |= PF_MEMALLOC;
> >  
> > @@ -1739,6 +1774,8 @@ xfsbufd(
> >  	do {
> >  		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
> >  		long	tout = age;
> > +		int	count = 0;
> > +		struct list_head tmp;
> >  
> >  		if (unlikely(freezing(current))) {
> >  			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
> > @@ -1753,11 +1790,10 @@ xfsbufd(
> >  		schedule_timeout_interruptible(tout);
> >  
> >  		xfs_buf_delwri_split(target, &tmp, age);
> > +		xfs_buf_delwri_sort(target, &tmp);
> >  		while (!list_empty(&tmp)) {
> > +			struct xfs_buf *bp;
> > +			bp = list_first_entry(&tmp, struct xfs_buf, b_list);
> >  			list_del_init(&bp->b_list);
> >  			xfs_buf_iostrategy(bp);
> >  			count++;
> > 
> >  
> >  	if (wait)
> >  		blk_run_address_space(target->bt_mapping);
> >  
> > +	/* Now wait for IO to complete if required. */
> > +	while (!list_empty(&wait_list)) {
> > +		bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
> >  
> >  		list_del_init(&bp->b_list);
> >  		xfs_iowait(bp);
> 
> As a tiny optimization you might want to move this into the if (wait)
> block

All makes sense, will update.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
