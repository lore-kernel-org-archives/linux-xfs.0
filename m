Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE9217F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 17:30:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B024C304032
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:30:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zATtk3XvxseGZdg1 for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:30:32 -0800 (PST)
Date: Mon, 24 Feb 2014 18:30:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/10] repair: factor out threading setup code
Message-ID: <20140224233021.GA7585@bfoster.bfoster>
References: <1393223369-4696-1-git-send-email-david@fromorbit.com>
	<1393223369-4696-6-git-send-email-david@fromorbit.com>
	<20140224204304.GB49654@bfoster.bfoster>
	<20140224231620.GS13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140224231620.GS13647@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 10:16:20AM +1100, Dave Chinner wrote:
> On Mon, Feb 24, 2014 at 03:43:05PM -0500, Brian Foster wrote:
> > On Mon, Feb 24, 2014 at 05:29:24PM +1100, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > The same code is repeated in different places to set up
> > > multithreaded prefetching. This can all be factored into a single
> > > implementation.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ....
> > >  static void
> > >  traverse_ags(
> > > -	xfs_mount_t 		*mp)
> > > +	struct xfs_mount	*mp)
> > >  {
> > > -	int			i;
> > > -	work_queue_t		queue;
> > > -	prefetch_args_t		*pf_args[2];
> > > -
> > > -	/*
> > > -	 * we always do prefetch for phase 6 as it will fill in the gaps
> > > -	 * not read during phase 3 prefetch.
> > > -	 */
> > > -	queue.mp = mp;
> > > -	pf_args[0] = start_inode_prefetch(0, 1, NULL);
> > > -	for (i = 0; i < glob_agcount; i++) {
> > > -		pf_args[(~i) & 1] = start_inode_prefetch(i + 1, 1,
> > > -				pf_args[i & 1]);
> > > -		traverse_function(&queue, i, pf_args[i & 1]);
> > > -	}
> > > +	do_inode_prefetch(mp, 0, traverse_function, true, true);
> > 
> > The cover letter indicates the parallelization of phase 6 was dropped,
> > but this appears to (conditionally) enable it.
> 
> No, it enables prefetch, it does not enable threading. The second
> parameter is "0" which means that do_inode_prefetch() executes the
> single threaded prefetch walk like the above code. i.e.:
> 
> > > + */
> > > +void
> > > +do_inode_prefetch(
> > > +	struct xfs_mount	*mp,
> > > +	int			stride,
> 
> stride = 0
> 
> > > +	void			(*func)(struct work_queue *,
> > > +					xfs_agnumber_t, void *),
> > > +	bool			check_cache,
> > > +	bool			dirs_only)
> > > +{
> > > +	int			i, j;
> > > +	xfs_agnumber_t		agno;
> > > +	struct work_queue	queue;
> > > +	struct work_queue	*queues;
> > > +	struct prefetch_args	*pf_args[2];
> > > +
> > > +	/*
> > > +	 * If the previous phases of repair have not overflowed the buffer
> > > +	 * cache, then we don't need to re-read any of the metadata in the
> > > +	 * filesystem - it's all in the cache. In that case, run a thread per
> > > +	 * CPU to maximise parallelism of the queue to be processed.
> > > +	 */
> > > +	if (check_cache && !libxfs_bcache_overflowed()) {
> > > +		queue.mp = mp;
> > > +		create_work_queue(&queue, mp, libxfs_nproc());
> > > +		for (i = 0; i < mp->m_sb.sb_agcount; i++)
> > > +			queue_work(&queue, func, i, NULL);
> > > +		destroy_work_queue(&queue);
> > > +		return;
> > > +	}
> > > +
> > > +	/*
> > > +	 * single threaded behaviour - single prefetch thread, processed
> > > +	 * directly after each AG is queued.
> > > +	 */
> > > +	if (!stride) {
> > > +		queue.mp = mp;
> > > +		pf_args[0] = start_inode_prefetch(0, dirs_only, NULL);
> > > +		for (i = 0; i < mp->m_sb.sb_agcount; i++) {
> > > +			pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
> > > +					dirs_only, pf_args[i & 1]);
> > > +			func(&queue, i, pf_args[i & 1]);
> > > +		}
> > > +		return;
> > > +	}
> 
> So we run this "!stride" code. Hmmmm - maybe you are commenting on
> the "check_cache" code? I probably should prevent that from
> triggering, too.
> 

Sorry, I could have been more clear on that. Yes, I'm referring
specifically to setting check_cache to true.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
