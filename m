Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2333D7F3F
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 14:53:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F2BF4304039
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 12:53:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	j4K44CCJcFTUCILp for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 12:53:15 -0800 (PST)
Date: Fri, 13 Dec 2013 07:53:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] repair: phase 6 is trivially parallelisable
Message-ID: <20131212205311.GZ10988@dastard>
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
	<1386832945-19763-4-git-send-email-david@fromorbit.com>
	<20131212184346.GA23479@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131212184346.GA23479@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 10:43:46AM -0800, Christoph Hellwig wrote:
> >  static void
> >  add_dotdot_update(
> > @@ -64,12 +65,14 @@ add_dotdot_update(
> >  		do_error(_("malloc failed add_dotdot_update (%zu bytes)\n"),
> >  			sizeof(dotdot_update_t));
> >  
> > +	pthread_mutex_lock(&dotdot_lock);
> >  	dir->next = dotdot_update_list;
> >  	dir->irec = irec;
> >  	dir->agno = agno;
> >  	dir->ino_offset = ino_offset;
> >  
> >  	dotdot_update_list = dir;
> > +	pthread_mutex_unlock(&dotdot_lock);
> 
> Would be nice to make this use a list_head if you touch it anyway.
> (As a separate patch)
> 
> >  static void
> >  traverse_ags(
> > -	xfs_mount_t 		*mp)
> > +	xfs_mount_t		*mp)
> 
> Not quite sure what actually changed here, but if you touch it anyway
> you might as well use the struct version..

Whitespace after xfs_mount_t, judging by the highlighting I see in
the editor right now.

> > +	if (!ag_stride) {
> > +		work_queue_t	queue;
> > +
> > +		queue.mp = mp;
> > +		pf_args[0] = start_inode_prefetch(0, 1, NULL);
> > +		for (i = 0; i < glob_agcount; i++) {
> > +			pf_args[(~i) & 1] = start_inode_prefetch(i + 1, 1,
> > +					pf_args[i & 1]);
> > +			traverse_function(&queue, i, pf_args[i & 1]);
> > +		}
> > +		return;
> >  	}
> > +
> > +	/*
> > +	 * create one worker thread for each segment of the volume
> > +	 */
> > +	queues = malloc(thread_count * sizeof(work_queue_t));
> > +	for (i = 0, agno = 0; i < thread_count; i++) {
> > +		create_work_queue(&queues[i], mp, 1);
> > +		pf_args[0] = NULL;
> > +		for (j = 0; j < ag_stride && agno < glob_agcount; j++, agno++) {
> > +			pf_args[0] = start_inode_prefetch(agno, 1, pf_args[0]);
> > +			queue_work(&queues[i], traverse_function, agno,
> > +				   pf_args[0]);
> > +		}
> > +	}
> > +
> > +	/*
> > +	 * wait for workers to complete
> > +	 */
> > +	for (i = 0; i < thread_count; i++)
> > +		destroy_work_queue(&queues[i]);
> > +	free(queues);
> 
> 
> This is the third copy of this code block, might make sense to
> consolidate it.

Agreed, just haven't got to it.

> Btw, does anyone remember why we have the libxfs_bcache_overflowed()
> special case in phase4, but not anywhere else?

I recall something about memory consumption, but I doubt that code
can even trigger given that if we get to overflow conditions we
immediately double the cache size and so libxfs_bcache_overflowed()
will never see an overflow condition....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
