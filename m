Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0Q4CHwC098837 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 22:12:17 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E3B351C7A30D
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 20:13:20 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	R0GZ7BVm7gJZ2UO8 for <xfs@oss.sgi.com>;
	Mon, 25 Jan 2010 20:13:20 -0800 (PST)
Date: Tue, 26 Jan 2010 15:13:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: Sort delayed write buffers before dispatch
Message-ID: <20100126041317.GB15853@discord.disaster>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
	<1264400564-19704-5-git-send-email-david@fromorbit.com>
	<20100125120054.GE8595@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100125120054.GE8595@infradead.org>
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

On Mon, Jan 25, 2010 at 07:00:54AM -0500, Christoph Hellwig wrote:
> > @@ -1937,42 +1967,46 @@ xfs_flush_buftarg(
> >  	xfs_buftarg_t	*target,
> >  	int		wait)
> >  {
> > -	struct list_head tmp;
> > -	xfs_buf_t	*bp, *n;
> > +	xfs_buf_t	*bp;
> >  	int		pincount = 0;
> > +	LIST_HEAD(tmp_list);
> > +	LIST_HEAD(wait_list);
> >  
> >  	xfs_buf_runall_queues(xfsconvertd_workqueue);
> >  	xfs_buf_runall_queues(xfsdatad_workqueue);
> >  	xfs_buf_runall_queues(xfslogd_workqueue);
> >  
> >  	set_bit(XBT_FORCE_FLUSH, &target->bt_flags);
> > -	pincount = xfs_buf_delwri_split(target, &tmp, 0);
> > +	pincount = xfs_buf_delwri_split(target, &tmp_list, 0);
> >  
> >  	/*
> > -	 * Dropped the delayed write list lock, now walk the temporary list
> > +	 * Dropped the delayed write list lock, now walk the temporary list.
> > +	 * All I/O is issued async and then if we need to wait for completion
> > +	 * we do that after issuing all the IO.
> >  	 */
> > -	list_for_each_entry_safe(bp, n, &tmp, b_list) {
> > +	list_sort(NULL, &tmp_list, xfs_buf_cmp);
> > +	while (!list_empty(&tmp_list)) {
> > +		struct xfs_buf *bp;
> 
> This now has a bp variable both in functionp-wide scope and a local one
> here.  Might be worth to decide for either style.

I removed the second declaration.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
