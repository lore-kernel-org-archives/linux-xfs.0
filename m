Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB21UXJj244091 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 19:30:34 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A36B81BB270
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 17:32:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	BySFDH6YoApFGSYT for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 17:32:16 -0800 (PST)
Date: Thu, 2 Dec 2010 12:32:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/8] xfs: bulk AIL insertion during transaction commit
Message-ID: <20101202013213.GM16922@dastard>
References: <1290993152-20999-1-git-send-email-david@fromorbit.com>
	<1290993152-20999-4-git-send-email-david@fromorbit.com>
	<20101130224057.GA16143@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101130224057.GA16143@infradead.org>
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

On Tue, Nov 30, 2010 at 05:40:57PM -0500, Christoph Hellwig wrote:
> Generally looks good, a few minor comments below:
> 
> > +void
> > +xfs_trans_committed_bulk(
> > +	struct xfs_ail		*ailp,
> > +	struct xfs_log_vec	*log_vector,
> > +	xfs_lsn_t		commit_lsn,
> > +	int			aborted)
> > +{
> > +#define LGIA_SIZE	32
> > +	struct xfs_log_item	*lgia[LGIA_SIZE];
> 
> The lgia name seems a bit to obscure to me.

lgia == "log item array"

> What about just log_items
> as variable name, and LOG_ITEM_BATCH_SIZE or similar for the size?

Ok, that's easy to do.

> > +			spin_lock(&ailp->xa_lock);
> > +			xfs_trans_ail_update_bulk(ailp, lgia, LGIA_SIZE,
> > +							commit_lsn);
> > +			for (i = 0; i < LGIA_SIZE; i++)
> > +				IOP_UNPIN(lgia[i], 0);
> 
> > +		spin_lock(&ailp->xa_lock);
> > +		xfs_trans_ail_update_bulk(ailp, lgia, i, commit_lsn);
> > +		for (j = 0; j < i; j++)
> > +			IOP_UNPIN(lgia[j], 0);
> 
> It might be worth to factor these two little sniplets into a little
> helper.

I thought about it, but didn't because there was more code in
writing a helper. I'll do it anyway...

> 
> > + * Bulk update version of xfs_trans_ail_update.
> 
> That won't be a very useful comment anymore once xfs_trans_ail_update is
> implemented as a wrapper around this function..

Yup, but when the wrapper is introduced the comment is updated
appropriately.

> 
> > +	struct xfs_log_item	**lgia,
> 
> Same naming comment here.

Will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
