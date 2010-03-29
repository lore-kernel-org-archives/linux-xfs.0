Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2T3M0Fi027649 for <xfs@oss.sgi.com>; Sun, 28 Mar 2010 22:22:01 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F164C1BC747D
	for <xfs@oss.sgi.com>; Sun, 28 Mar 2010 20:23:43 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	BrvEYxCN3p5heTY1 for <xfs@oss.sgi.com>;
	Sun, 28 Mar 2010 20:23:43 -0700 (PDT)
Date: Mon, 29 Mar 2010 14:23:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Always update the log tail on disk in sync
Message-ID: <20100329032340.GP3335@dastard>
References: <1269493671-11034-1-git-send-email-david@fromorbit.com>
	<20100328093541.GA11654@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100328093541.GA11654@infradead.org>
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

On Sun, Mar 28, 2010 at 05:35:41AM -0400, Christoph Hellwig wrote:
> 
> Looks good.
> 
>  
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> > +	switch (log->l_covered_state) {
> > +	case XLOG_STATE_COVER_NEED:
> > +	case XLOG_STATE_COVER_NEED2:
> > +		if (!xfs_trans_ail_tail(log->l_ailp) &&
> > +		    xlog_iclogs_empty(log)) {
> > +			if (log->l_covered_state == XLOG_STATE_COVER_NEED)
> > +				log->l_covered_state = XLOG_STATE_COVER_DONE;
> > +			else {
> > +				ASSERT(log->l_covered_state == XLOG_STATE_COVER_NEED2);
> 
> Moving this assert into the switch introduces an overly long line.
> But it's rather pintless anyway, so we can just drop it.
> 
> Together with reordering the switch statement for slightly better
> readability we might get something like the version below:

Yeah, that looks better. I'll run it through cycle and repost when
done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
