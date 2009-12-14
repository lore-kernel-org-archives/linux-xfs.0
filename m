Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBFAnooj225257 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 04:49:50 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49939F6EE9
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 02:50:26 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id TyFSRmD9mzYBiN6M for <xfs@oss.sgi.com>;
	Tue, 15 Dec 2009 02:50:26 -0800 (PST)
Date: Mon, 14 Dec 2009 15:16:16 +1100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 5/6] [XFS] Replace per-ag array with a radix tree
Message-ID: <20091214041615.GB9208@nick>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-6-git-send-email-david@fromorbit.com>
	<20091210234547.GA28289@infradead.org>
	<20091211004353.GF30608@discord.disaster>
	<20091211114627.GB5436@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091211114627.GB5436@infradead.org>
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

On Fri, Dec 11, 2009 at 06:46:27AM -0500, Christoph Hellwig wrote:
> On Fri, Dec 11, 2009 at 11:43:53AM +1100, Dave Chinner wrote:
> > > > +	spin_lock(&mp->m_perag_lock);
> > > > +	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> > > > +	spin_unlock(&mp->m_perag_lock);
> > > > +	return pag;
> > > 
> > > Can't we do this as a lock-less (at least for lookups) radix tree?
> > 
> > I think it can be (RCU-based?) , but I think that makes sense as a
> > followup optimisation once we have confidence the code is working
> > as it should.
> 
> Nick, what are the rules for the lock-less radix tree reader side?

OK, well basically we can do a radix_tree_lookup and get the pointer
without locking. In order to be able to follow the pointer to the
object of course the calling code needs to do its own synchronization
(eg. objects might be RCU protected as well so it can be used or a
refcount can be taken on it under rcu_read_lock).

A single lookup basically has concurrency semantics as though it may
have been performed before or after any concurrent modifications. This
is really just the same as:

spin_lock()
ptr = radix_tree_lookup()
spin_unlock()
/* use the ptr */

Because before the lock is taken and after it is released, we can get
any kind of interleaving of modifications anyway, so by the time we
use the pointer then regardless of whether we use lock or RCU, then the
tree may have been modified anyway.

This looks like the pattern used in Dave's patch.

If you need any kind of atomic multiple lookups (including gang lookups)
or atomic lookups and modifications, then you'll need a lock.


> Dave is introducing a radix tree in XFS which has the following access
> pattern:
> 
>  - lots of read side access during normal fs operations
>  - insertations currently only happen during mount before the fs is life
>    and during a very rare operation (filesystem resize)
>  - currently items are never deleted, but we might need that in the
>    future (for filesystem shrink support)
>  - the objects pointed to are kmalloced and refcounted structures,
>    but we don't even strictly need the refcounting until the filesystem
>    shrink support is implemented

This sounds like it would be perfectly suited to RCU lookups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
