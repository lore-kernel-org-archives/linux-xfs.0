Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HHl5S0099935 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 11:47:05 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HMGGzkKnQKpoCEMS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 09:47:03 -0800 (PST)
Date: Fri, 17 Feb 2012 12:47:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] xfs: remove the per-filesystem list of dquots
Message-ID: <20120217174702.GD21796@infradead.org>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023147.213091674@bombadil.infradead.org>
	<20120215225922.GO14132@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215225922.GO14132@dastard>
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
Cc: xfs@oss.sgi.com

On Thu, Feb 16, 2012 at 09:59:22AM +1100, Dave Chinner wrote:
> On Tue, Feb 14, 2012 at 09:29:29PM -0500, Christoph Hellwig wrote:
> > Instead of keeping a separate per-filesystem list of dquots we can walk
> > the radix tree for the two places where we need to iterate all quota
> > structures.
> 
> And with the new radix tree iterator code being worked on, this will
> become even simpler soon...

Indeed.

> >  	struct xfs_mount	*mp = dqp->q_mount;
> >  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> >  
> >  	xfs_dqlock(dqp);
> > +	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
> > +		xfs_dqlock(dqp);
> 
> xfs_dqunlock()?

Yes.

> > - * Flush all dquots of the given file system to disk. The dquots are
> > - * _not_ purged from memory here, just their data written to disk.
> > + * The quota lookup is done in batches to keep the amount of lock traffic and
> > + * radix tree lookups to a minimum. The batch size is a trade off between
> > + * lookup reduction and stack usage.
> 
> Given the way the locking works here, the gang lookup doesn't really
> do anythign for reducing lock traffic. It reduces lookup overhead a
> bit, but seeing as we don't drop the tree lock while executing
> operations on each dquot I don't see much advantage in the
> complexity of batched lookups....

True.  On the other hand the code is there and debugged now, so I don't
see much point to change it - except for maybe using the new radix tree
iterator once it goes in.

> The problem I see with this is that it holds the qi_tree_lock over
> the entire walk - it is not dropped anywhere it there is no
> reschedule pressure. Hence all lookups will stall while a walk is in
> progress. Given a walk can block on IO or dquot locks, this could
> mean that a walk holds off lookups for quite some time.

Ok, maybe I should move it to individual lookups.  Then again this
code is only called either after quotacheck, when the isn't online
yet, or during umount/quotaoff, so all this doesn't matter too much.

> Seeing as it is a purge, even on an error I'd still try to purge all
> trees. Indeed, what happens in the case of a filesystem shutdown
> here?

I'll need to take a deeper look and figure this out.  Thanks for the
headsup.

> Hmmmm- all the walk cases pass 0 as their flags. Are they used in
> later patches?

No - it's a copy and paste leftover from the inode iterator.

In fact I'm tempted to simply log all dquots after a quotacheck now
that we have delaylog and support relogging.  After this we could drop
the generic iterator and just hardcode a function that while loop over
finding any dquot and purging it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
