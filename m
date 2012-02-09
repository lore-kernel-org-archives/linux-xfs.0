Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q19NDigG202921 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 17:13:44 -0600
Date: Thu, 9 Feb 2012 17:13:46 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/7] xfs: use a normal shrinker for the dquot freelist
Message-ID: <20120209231346.GM7762@sgi.com>
References: <20120201135719.202171828@bombadil.infradead.org>
	<20120201140039.011990931@bombadil.infradead.org>
	<20120209220320.GL7762@sgi.com>
	<20120209225626.GA844@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120209225626.GA844@infradead.org>
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

Hey Christoph,

On Thu, Feb 09, 2012 at 05:56:26PM -0500, Christoph Hellwig wrote:
> On Thu, Feb 09, 2012 at 04:03:20PM -0600, Ben Myers wrote:
> > I've been messing with this and haven't gotten it to call us with
> > nr_to_scan other than 0 or -1 yet.  Maybe I need more dquots.
> > (time passes)  Ok, I have it going now.  Comments below.
> 
> To actually hit this I hade to use a VM with very little memory assigned
> to it, and then creat lots of dquots and causes memory pressure.
> 
> I have about 20.000 users on it, and I did a quota report for all of
> them while catting one block device into another using buffered I/O.

Ah, I see.

> > > +	LIST_HEAD		(dispose_list);
> > > +	struct xfs_dquot	*dqp;
> > >  
> > > -	if (nfree <= ndqused && nfree < ndquot)
> > > +	if ((sc->gfp_mask & (__GFP_FS|__GFP_WAIT)) != (__GFP_FS|__GFP_WAIT))
> > >  		return 0;
> > > +	if (!nr_to_scan)
> > > +		goto out;
> > 
> > I suggest something more like:
> > 
> > 	if (!nr_to_scan)
> > 		goto out;
> >         if ((sc->gfp_mask...
> > 		return -1;
> 
> Why?  Counting the number of objects when we can't actually do anything
> is just a waste of time,
> and -1 vs 0 for the sizing pass seem to be
> treateds the same in the calling code.

That's a good point, but the shrinker interface has documented that
you're supposed to return -1 in this situation... and that you aren't
allowed to return -1 when nr_to_scan == 0.

> > > -
> > > -	return B_TRUE;
> > > +	while (!list_empty(&dispose_list)) {
> > > +		dqp = list_first_entry(&dispose_list, struct xfs_dquot,
> > > +				       q_freelist);
> > > +		list_del_init(&dqp->q_freelist);
> > > +		xfs_qm_dqfree_one(dqp);
> > > +	}
> > > +out:
> > > +	return (xfs_Gqm->qm_dqfrlist_cnt / 100) * sysctl_vfs_cache_pressure;
> > 
> > return atomic_read(&xfs_Gqm->qm_totaldquots);
> > 
> > This works well for me and seems to be closer to the shrinker interface
> > as documented:
> 
> It's pointless - we can only apply pressure to dquots that are on the
> freelist.  No amount of shaking will allow us to reclaim a referenced
> dquot.

Sure... then it should be:

return atomic_read(&xfs_Gqm->qm_frlist_cnt);

What is the value of the additional calculation?

> >  * The callback must not return -1 if nr_to_scan is zero.
> 
> this is against your suggestion of using -1 for the estimation pass
> above, btw.

No it isn't... if nr_to_scan == 0 we would have jumped to 'out' and
returned the count.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
