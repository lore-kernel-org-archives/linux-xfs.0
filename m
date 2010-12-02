Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2BjhAX014925 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 05:45:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67668140521E
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 03:47:27 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id N3Shda6FvUSZqRSW for
	<xfs@oss.sgi.com>; Thu, 02 Dec 2010 03:47:27 -0800 (PST)
Date: Thu, 2 Dec 2010 06:47:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/14] xfs: convert log grant heads to LSN notation
Message-ID: <20101202114726.GC21365@infradead.org>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-4-git-send-email-david@fromorbit.com>
	<20101201130504.GA18379@infradead.org>
	<20101202020132.GP16922@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101202020132.GP16922@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Dec 02, 2010 at 01:01:32PM +1100, Dave Chinner wrote:
> On Wed, Dec 01, 2010 at 08:05:04AM -0500, Christoph Hellwig wrote:
> > > -STATIC int	 xlog_space_left(xlog_t *log, int cycle, int bytes);
> > > +STATIC int	 xlog_space_left(int logsize, xfs_lsn_t tail_lsn,
> > > +				xfs_lsn_t head);
> > 
> > Looking further through the series I have to say I really hate
> > passing in the logsize instead of the log structure.  Passing the
> > log pointer from higher level functions just makes a lot more sense.
> > 
> > Also in this case passing the tail_lsn explicitly doesn't make any sense
> > - it becomes atomic later and thus there is no locking requirement for
> > it.
> 
> What I wanted to make clear is that the calculation works on fixed
> values and doesn't sample values internally itself. I guess that's
> not important for the log size, but for stuff like the tail lsn
> it avoids  needing to sample inside xlog_space_left() before we
> crack it. i.e. something like this is wrong:
> 
> 	cycle = CYCLE_LSN(atomic64_read(&log->l_tail_lsn));
> 	block = BLOCK_LSN(atomic64_read(&log->l_tail_lsn));
> 
> and this is correct:
> 
> 	tail_lsn = atomic64_read(&log->l_tail_lsn);
> 	cycle = CYCLE_LSN(tail_lsn);
> 	block = BLOCK_LSN(tail_lsn);
> 
> So it makes sense to me to have the value of of the tail lsn and
> other variables that should only be sampled once passed into the
> function. That avoids misunderstandings further down the track
> because it is obvious that the calculation works on constant values.
> Perhaps I should add "const" to the parameter declarations to help
> make my intentions clear...

I don't think obsfucating the code is a good idea to reach this goal.

What might be better is a helper like:

static inline void xlog_crack_lsn(atomic64_t *lsn, int *cycle, int *block)
{
	xfs_lsn_t = atomic64_read(lsn);

	*cycle = CYCLE_LSN(tail_lsn);
 	*block = BLOCK_LSN(tail_lsn);
}

and a long comment explaining how it needs to be used.

> I thought about that - my first version even did this. I thought it
> was easier to understand the changes if I didn't change the calling
> conventions for modifying the grant heads. As such, I'd prefer to
> make this change to the wrappers in a separate patch.

Heh, when looking at the patch I actually found this part pretty hard
to read already.  So moving the factoring of the helpers out into a
separate patch might indeed be a good idea, and that patch can also
remove the wrappers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
