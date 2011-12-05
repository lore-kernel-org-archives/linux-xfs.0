Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB58csSI122717 for <xfs@oss.sgi.com>; Mon, 5 Dec 2011 02:38:54 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D69454D885C
	for <xfs@oss.sgi.com>; Mon,  5 Dec 2011 00:38:53 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	iFXZpKCiUOytOzAe for <xfs@oss.sgi.com>;
	Mon, 05 Dec 2011 00:38:53 -0800 (PST)
Date: Mon, 5 Dec 2011 03:38:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/16] xfs: implement lazy removal for the dquot freelist
Message-ID: <20111205083852.GC29401@infradead.org>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.638600213@bombadil.infradead.org>
	<20111205043230.GO7046@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111205043230.GO7046@dastard>
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

On Mon, Dec 05, 2011 at 03:32:31PM +1100, Dave Chinner wrote:
> > +		/*
> > +		 * move the dquot to the front of the hashchain
> > +		 */
> > +		list_move(&dqp->q_hashlist, &qh->qh_list);
> > +		trace_xfs_dqlookup_done(dqp);
> > +		*O_dqpp = dqp;
> > +		return 0;
> 
> Back when the inode cache used a hash, we found that this moving of
> the item to the front of the list actually slowed down lookups - the
> impact of dirtying cachelines (i.e. remote CPU cache invalidation)
> to move the item in the list was greater than the time saved during
> lookups. That was because that when there are no hash chain
> modifications taking place, then the frequently hit chains simply
> end up shared in all the cpu caches rather than being turfed out on
> every successful lookup on a different CPU....

Yes, I doubt having this is an overly good idea.  But instead of
spending more time on optimizing the cache I'd prefer getting the
patches to move to a tree in after another merge window or two.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
