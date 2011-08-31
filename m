Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VCbaov207769 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 07:37:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38C161E80867
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 05:37:34 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	lEdk7RFs3di4C109 for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 05:37:34 -0700 (PDT)
Date: Wed, 31 Aug 2011 08:37:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: merging the quota source files
Message-ID: <20110831123734.GA30478@infradead.org>
References: <20110830121112.GA19509@infradead.org>
	<20110831002236.GV3162@dastard>
	<20110831052049.GA29511@infradead.org>
	<20110831121746.GJ32358@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110831121746.GJ32358@dastard>
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

On Wed, Aug 31, 2011 at 10:17:46PM +1000, Dave Chinner wrote:
> > This is the queue I plan to submit for Linux 3.2 if we get any progress
> > on getting the current pending queue reviewed and applied.
> 
> I'm slowly working my way through the queue. I've got plenty of
> stuff on my plate at the moment, though, and I'll be on holidays
> for a couple of weeks starting next week, so don't rely on me to get
> stuff reviewed in the near term....

Ok.  It would be good to get the bmapi refactor off the plate - the
series is huge and has chances to get a major pain to rebase.  Been
through it once from your original series, and I don't want to do it
again.  I don't think there is much else that you haven't reviewed yet.

> > I have a prototype to use a radix tree.  You said before you didn't like
> > it as the radix tree assumeds the quota ids are clustered, but so are
> > the actual dqouts in the quota file, so I do not think it is a problem.
> > We'll probably need testing at a big quota user site to decided this.
> 
> I'd just use the generic btree code in lib/btree.c. That way we
> simply don't have to care what quota ids are in use and how sparse
> they are....

I do not trust code that is used by a single fringe filesystem as
much code used all over the core VM/VFS.  Nevermind that the radix
tree has a lot of features that do come in handy for quotas.

I've also done a survey of large users systems I have access to and all
of them absolutely do cluster uids. Less so for GIDs, but none of them
has a lot of those.

> > I have ptrototypes / WIP patches for this, but it doesn't make sense
> > before item 3 is done.
> 
> Similarly I was planning ondoingthis to use the generic LRU code
> I've proposed...

That is the idea.  We'll need a few iterations before getting there,
though.

> > 
> > So that's one vote for keeping them separate.
> 
> Yeah. the dquot design pattern is based on the pattern that inodes
> use, so having the code structured in a similar manner makes sense
> to me.

I don't really see a similar split for the inode.  What would be the
equivalent to xfs_qm.c by your previous split?

Btw, if we look at xfs_qm.c in current minaline, lines:

    0 -   63:	boilerplate
   64 -  272:	handling of xfs_Gqm		(will go away)
  273 -  410:	mount / unmount handling
  411 -  604:	dquot flushing / reclaim
  605 -  879:	dquot attach / detach		(belongs into xfs_dquot.c?)
  880 -  973:	xfs_qm_sync			(will go away)
  974 - 1540:	mount / umount handling
 1541 - 1793:	quotacheck / quota inode allocation
 1794 - 2043:	quota reclaim / reuse
 2044 - 2072:	sb write helper
 2073 - 2416:	vop helpers

So less than half of the code is thing that do belong into xfs_qm.c
by your previous defintion.  I think we'd be simpler off with a merge.

> Speaking of which (and going well and truly OT), I don't see much
> reason for keeping xfs_iget.c separate from xfs_inode.c anymore -
> there isn't really much code left in xfs_iget.c now, and stuff like
> all the locking code isn't really related to the inode lookup
> function of xfs_iget(), anyway...

No real reason.  If we want to resplit these I'd split the about 2/3
of xfs_inode.c that are shared with userspace into a separate file,
though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
