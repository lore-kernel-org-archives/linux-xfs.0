Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 17:05:40 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9905blj010666
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 17:05:37 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 024D4A16002
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 17:07:17 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id IjE5JWurtEPaAtgw for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 17:07:17 -0700 (PDT)
Date: Thu, 9 Oct 2008 11:06:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] XFS: replace fixed size busy extent array with an
	rbtree
Message-ID: <20081009000659.GC9597@disturbed>
References: <1223417377-8679-1-git-send-email-david@fromorbit.com> <1223417377-8679-3-git-send-email-david@fromorbit.com> <20081008184928.GB6823@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008184928.GB6823@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 08, 2008 at 02:49:28PM -0400, Christoph Hellwig wrote:
> > @@ -131,14 +131,8 @@ STATIC void
> >  xfs_free_perag(
> >  	xfs_mount_t	*mp)
> >  {
> > -	if (mp->m_perag) {
> > -		int	agno;
> > -
> > -		for (agno = 0; agno < mp->m_maxagi; agno++)
> > -			if (mp->m_perag[agno].pagb_list)
> > -				kmem_free(mp->m_perag[agno].pagb_list);
> > +	if (mp->m_perag)
> >  		kmem_free(mp->m_perag);
> > -	}
> 
> kmem_free(NULL) is fine, so no need for the if.  And with that there's
> no need for this one-line wrapper and we can just do the free in the
> caller.

Ok, I'll do that.

> >  typedef struct xfs_log_busy_slot {
> > -	xfs_agnumber_t		lbc_ag;
> > -	ushort			lbc_idx;	/* index in perag.busy[] */
> > +	struct xfs_busy_extent	*lbc_busyp;
> >  } xfs_log_busy_slot_t;
> 
> Just use xfs_busy_extent directly - there's only about a handful places
> using xfs_log_busy_slot anyway.
> 
> >  xfs_log_busy_slot_t *
> > -xfs_trans_add_busy(xfs_trans_t *tp, xfs_agnumber_t ag, xfs_extlen_t idx)
> > +xfs_trans_add_busy(
> > +	xfs_trans_t		*tp,
> > +	struct xfs_busy_extent	*busyp)
> 
> And this one can lose it's return value.  It's always the second
> argmument and ignored by all callers anyway.

I'm not concerned about this as the busy slot stuff in the struct
xfs_trans gets removed in the last patch of the series. I'm
half-tempted to integrate this one with the initial rbtree patch
as all that intermediate stuffing around just goes away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
