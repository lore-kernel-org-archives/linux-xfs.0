Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB21xrSY245458 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 19:59:53 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 22EF41C85066
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 18:01:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	qNmZFGzcJeGanLPS for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 18:01:35 -0800 (PST)
Date: Thu, 2 Dec 2010 13:01:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/14] xfs: convert log grant heads to LSN notation
Message-ID: <20101202020132.GP16922@dastard>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-4-git-send-email-david@fromorbit.com>
	<20101201130504.GA18379@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201130504.GA18379@infradead.org>
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

On Wed, Dec 01, 2010 at 08:05:04AM -0500, Christoph Hellwig wrote:
> > -STATIC int	 xlog_space_left(xlog_t *log, int cycle, int bytes);
> > +STATIC int	 xlog_space_left(int logsize, xfs_lsn_t tail_lsn,
> > +				xfs_lsn_t head);
> 
> Looking further through the series I have to say I really hate
> passing in the logsize instead of the log structure.  Passing the
> log pointer from higher level functions just makes a lot more sense.
> 
> Also in this case passing the tail_lsn explicitly doesn't make any sense
> - it becomes atomic later and thus there is no locking requirement for
> it.

What I wanted to make clear is that the calculation works on fixed
values and doesn't sample values internally itself. I guess that's
not important for the log size, but for stuff like the tail lsn
it avoids  needing to sample inside xlog_space_left() before we
crack it. i.e. something like this is wrong:

	cycle = CYCLE_LSN(atomic64_read(&log->l_tail_lsn));
	block = BLOCK_LSN(atomic64_read(&log->l_tail_lsn));

and this is correct:

	tail_lsn = atomic64_read(&log->l_tail_lsn);
	cycle = CYCLE_LSN(tail_lsn);
	block = BLOCK_LSN(tail_lsn);

So it makes sense to me to have the value of of the tail lsn and
other variables that should only be sampled once passed into the
function. That avoids misunderstandings further down the track
because it is obvious that the calculation works on constant values.
Perhaps I should add "const" to the parameter declarations to help
make my intentions clear...

> 
> > -xlog_grant_sub_space(struct log *log, int bytes)
> > +__xlog_grant_sub_space(
> > +	xfs_lsn_t	*head,
> > +	int		bytes,
> > +	int		logsize)
> 
> Same thing here - the calling convention would be a lot more regular
> by still passing the log as first argument.

Ok, it's only for the logsize again, but that's not the important
part of the calculation...

> After the factoring I also think we could cut down on the amount of
> wrappers in this area.  Just rename __xlog_grant_sub_space and
> __xlog_grant_add_space to not have the __ prefix, and kill the wrappers
> around it - they only have one or two callers, and just having two
> helpers and passing the heads we're interested in is a lot simpler and
> cleaner.

I thought about that - my first version even did this. I thought it
was easier to understand the changes if I didn't change the calling
conventions for modifying the grant heads. As such, I'd prefer to
make this change to the wrappers in a separate patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
