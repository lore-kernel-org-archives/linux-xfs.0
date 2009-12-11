Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBB0nYu1131681 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 18:49:34 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A40651956542
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 16:50:07 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	vaXNGVjUM9GZ8bF7 for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2009 16:50:07 -0800 (PST)
Date: Fri, 11 Dec 2009 11:50:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/6] [XFS] Reference count per-ag structures
Message-ID: <20091211005004.GG30608@discord.disaster>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-7-git-send-email-david@fromorbit.com>
	<20091210234836.GA4774@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091210234836.GA4774@infradead.org>
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

On Thu, Dec 10, 2009 at 06:48:36PM -0500, Christoph Hellwig wrote:
> On Wed, Dec 02, 2009 at 05:11:39PM +1100, Dave Chinner wrote:
> > -		xfs_perag_put(args->pag);
> >  		if (bump_rotor || (type == XFS_ALLOCTYPE_ANY_AG)) {
> >  			if (args->agno == sagno)
> >  				mp->m_agfrotor = (mp->m_agfrotor + 1) %
> > @@ -2571,6 +2570,7 @@ xfs_alloc_vextent(
> >  			args->len);
> >  #endif
> >  	}
> > +	xfs_perag_put(args->pag);
> >  	return 0;
> >  error0:
> >  	xfs_perag_put(args->pag);
> 
> Should be folded into the earlier patches.

Will do.

> >  static inline xfs_perag_t *
> >  xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
> > @@ -393,6 +393,12 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
> >  
> >  	spin_lock(&mp->m_perag_lock);
> >  	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> > +	if (pag) {
> > +		ASSERT(atomic_read(&pag->pag_ref) >= 0);
> > +		/* catch leaks in the positive direction during testing */
> > +		ASSERT(atomic_read(&pag->pag_ref) < 1000);
> 
> Is there any good reason why we should not be able to hit this number?

that would require 1000 parallel accesses to the perag structure.
Most accesses are serialised by the AGF/AGI buffer locks, and there
are only a handful of traversal references that can be made, so I
don't think that a reference count of more than 10 is going to be
common in real life.

> Patch looks good, although I'm a bit worried about the performance
> overhead.

None that I've been able to see so far - effectively we are
replacing a rwsem with a spin lock and an atomic op, so I think
the overhead is comparable, perhaps even lower than before.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
