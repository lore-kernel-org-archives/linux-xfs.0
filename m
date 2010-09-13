Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8DGxH4G082451 for <xfs@oss.sgi.com>; Mon, 13 Sep 2010 11:59:17 -0500
Subject: Re: [PATCH 4/4] xfs: convert buffer cache hash to rbtree
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100909015150.GB11362@infradead.org>
References: <1283958778-28610-1-git-send-email-david@fromorbit.com>
	<1283958778-28610-5-git-send-email-david@fromorbit.com>
	<20100909015150.GB11362@infradead.org>
Date: Mon, 13 Sep 2010 11:59:45 -0500
Message-ID: <1284397185.2404.54.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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


> > @@ -210,8 +210,6 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
> >  	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> >  	if (pag) {
> >  		ASSERT(atomic_read(&pag->pag_ref) >= 0);
> > -		/* catch leaks in the positive direction during testing */
> > -		ASSERT(atomic_read(&pag->pag_ref) < 1000);
> 
> Di you manage to hit this during testing?  Either way it should probably
> be a separate patch.

I'm pretty sure this is due to each buffer now holding
a perag reference.  It might be nice to preserve this
functionality by checking against the number of blocks
in the AG or something similar.  But it's debug so it's
not quite as critical.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
