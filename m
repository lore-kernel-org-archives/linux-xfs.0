Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1A1qati212394 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 19:52:36 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SAA0BMeSWjPI2Lw4 for <xfs@oss.sgi.com>;
	Thu, 09 Feb 2012 17:52:35 -0800 (PST)
Date: Fri, 10 Feb 2012 12:52:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/7] xfs: use a normal shrinker for the dquot freelist
Message-ID: <20120210015233.GF12836@dastard>
References: <20120201135719.202171828@bombadil.infradead.org>
	<20120201140039.011990931@bombadil.infradead.org>
	<20120209220320.GL7762@sgi.com>
	<20120209225626.GA844@infradead.org>
	<20120209231346.GM7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120209231346.GM7762@sgi.com>
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

On Thu, Feb 09, 2012 at 05:13:46PM -0600, Ben Myers wrote:
> On Thu, Feb 09, 2012 at 05:56:26PM -0500, Christoph Hellwig wrote:
> > On Thu, Feb 09, 2012 at 04:03:20PM -0600, Ben Myers wrote:
> > > > -
> > > > -	return B_TRUE;
> > > > +	while (!list_empty(&dispose_list)) {
> > > > +		dqp = list_first_entry(&dispose_list, struct xfs_dquot,
> > > > +				       q_freelist);
> > > > +		list_del_init(&dqp->q_freelist);
> > > > +		xfs_qm_dqfree_one(dqp);
> > > > +	}
> > > > +out:
> > > > +	return (xfs_Gqm->qm_dqfrlist_cnt / 100) * sysctl_vfs_cache_pressure;
> > > 
> > > return atomic_read(&xfs_Gqm->qm_totaldquots);
> > > 
> > > This works well for me and seems to be closer to the shrinker interface
> > > as documented:
> > 
> > It's pointless - we can only apply pressure to dquots that are on the
> > freelist.  No amount of shaking will allow us to reclaim a referenced
> > dquot.
> 
> Sure... then it should be:
> 
> return atomic_read(&xfs_Gqm->qm_frlist_cnt);
> 
> What is the value of the additional calculation?

It's applying the user controllable vfs_cache_pressure setting to
the reclaim weight. That is, if the user wants to reclaim
inode/dentry/dquot slab caches faster than the page cache (i.e.
perfer data caching over metadata caching) or vice cersa, then the
change the sysctl value and shrinkers should then take that into
account....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
