Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1H2fiHh044229 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 20:41:45 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	KsdC482quTuyYzcH for <xfs@oss.sgi.com>;
	Thu, 16 Feb 2012 18:41:42 -0800 (PST)
Date: Fri, 17 Feb 2012 13:41:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 11/12] xfs: share code for grant head availability checks
Message-ID: <20120217024140.GF14132@dastard>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141435.484216051@bombadil.infradead.org>
	<20120216212506.GZ7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120216212506.GZ7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Feb 16, 2012 at 03:25:06PM -0600, Ben Myers wrote:
> Add xlog_grant_head_check() to replace sections of
> xlog_regrant_write_log_space() and xlog_grant_log_space().
> 
> On Mon, Dec 12, 2011 at 09:13:58AM -0500, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
.....
> >  xlog_grant_log_space(
> >  	struct log		*log,
> >  	struct xlog_ticket	*tic)
> >  {
> > -	int			free_bytes, need_bytes;
> > +	int			need_bytes;
> >  	int			error = 0;
> >  
> > -	ASSERT(!(log->l_flags & XLOG_ACTIVE_RECOVERY));
> > -
> >  	trace_xfs_log_grant_enter(log, tic);
> >  
> > -	/*
> > -	 * If there are other waiters on the queue then give them a chance at
> > -	 * logspace before us.  Wake up the first waiters, if we do not wake
> > -	 * up all the waiters then go to sleep waiting for more free space,
> > -	 * otherwise try to get some space for this transaction.
> > -	 */
> > -	need_bytes = tic->t_unit_res;
> > -	if (tic->t_flags & XFS_LOG_PERM_RESERV)
> > -		need_bytes *= tic->t_ocnt;
> 				     ^
> Here the calculation was done with tic->t_ocnt.
> 
> You don't see it in this patch, but xlog_ticket_reservation is using
> t_cnt.  I haven't looked into which is correct.

Good question, Ben.

Basically, a permanent log transaction is a transaction with larger
initial reservation on both the reserve and write heads so that
further reservations are not needed for most simple operations that
involving rolling commits. For operations that require long rolling
transactions, t_cnt reaches zero after a few dup/commit/reserve
loops and then it goes back to blocking to regrant log space. IOWs,
it's an optimisation to minimise blocking on log space for the
common case while keeping log reservation sizes somewhat sane.

A good example of this is that inode allocation can involve two
commits - one for allocating a new inode chunk, the second for
allocating an inode out of the new chunk. The "count" passed in to
the initial xfs_trans_reserve() call is 2. Hence the permanent log
reservation means that the initial transaction reservation can
reserve enough reserve and write head space for both commits without
needing to block in the second xfs_trans_reserve() call after
commiting the inode chunk allocation transaction.

For permanent transactions, in the current code,
xlog_grant_log_space() is called it is only for the first
transaction reservation of the series (i.e. no ticket yet exists).
That means tic->t_ocnt = tic->t_cnt because the ticket was just
initialised.  IOWs, for xlog_grant_log_space() it doesn't matter if
we use t_ocnt or t_cnt for the initial reservation and we don't use
t_ocnt anywhere else.

In subsequent rolling permanent transactions (i.e. the duplicated
transaction needing a new reservation), the ticket already exists
and we go down the path of xlog_regrant_write_log_space() instead.
That only reserves more write grant space if the t_cnt has reached
zero, and only does a single transaction reservation at a time. i.e.
t_ocnt is not used for these reservations at all.

Looking at Christophs new code, everything works the same, except
for making use of the observation that when we come through
xlog_ticket_reservation() for the reserve head, t_ocnt = t_cnt and
so we can use t_cnt for that case as well. That makes the code
generic for use with al the other places that do the same
calculation with t_cnt after it may have been modified due to
rolling transaction commits.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
