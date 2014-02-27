Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 71F8C7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 14:02:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1EEFAC003
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 12:02:34 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gSlVAWKpUCjMFq6v for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 12:02:32 -0800 (PST)
Date: Fri, 28 Feb 2014 07:01:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/10] repair: prefetch runs too far ahead
Message-ID: <20140227200150.GD30131@dastard>
References: <1393494675-30194-1-git-send-email-david@fromorbit.com>
	<1393494675-30194-10-git-send-email-david@fromorbit.com>
	<20140227140846.GB62463@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140227140846.GB62463@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 27, 2014 at 09:08:46AM -0500, Brian Foster wrote:
> On Thu, Feb 27, 2014 at 08:51:14PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> 
> Hmm, I replied to this one in the previous thread, but now I notice that
> it apparently never made it to the list. Dave, did you happen to see
> that in your inbox? Anyways, I had a couple minor comments/questions
> that I'll duplicate here (which probably don't require another
> repost)...

No, I didn't.

[snip typos that need fixing]

> > diff --git a/repair/prefetch.c b/repair/prefetch.c
> > index aee6342..7d3efde 100644
> > --- a/repair/prefetch.c
> > +++ b/repair/prefetch.c
> > @@ -866,6 +866,48 @@ start_inode_prefetch(
> >  	return args;
> >  }
> >  
> 
> A brief comment before the prefetch_ag_range bits that explain the
> implicit design constraints (e.g., throttle prefetch based on
> processing) would be nice. :)

Can do.

> > @@ -919,20 +955,27 @@ do_inode_prefetch(
> >  	 * create one worker thread for each segment of the volume
> >  	 */
> >  	queues = malloc(thread_count * sizeof(work_queue_t));
> > -	for (i = 0, agno = 0; i < thread_count; i++) {
> > +	for (i = 0; i < thread_count; i++) {
> > +		struct pf_work_args *wargs;
> > +
> > +		wargs = malloc(sizeof(struct pf_work_args));
> > +		wargs->start_ag = i * stride;
> > +		wargs->end_ag = min((i + 1) * stride,
> > +				    mp->m_sb.sb_agcount);
> > +		wargs->dirs_only = dirs_only;
> > +		wargs->func = func;
> > +
> >  		create_work_queue(&queues[i], mp, 1);
> > -		pf_args[0] = NULL;
> > -		for (j = 0; j < stride && agno < mp->m_sb.sb_agcount;
> > -				j++, agno++) {
> > -			pf_args[0] = start_inode_prefetch(agno, dirs_only,
> > -							  pf_args[0]);
> > -			queue_work(&queues[i], func, agno, pf_args[0]);
> > -		}
> > +		queue_work(&queues[i], prefetch_ag_range_work, 0, wargs);
> > +
> > +		if (wargs->end_ag >= mp->m_sb.sb_agcount)
> > +			break;
> >  	}
> 
> Ok, so instead of giving prefetch a green light on every single AG (and
> queueing the "work" functions), we queue a series of prefetch(next) then
> do_work() instances based on the stride. The prefetch "greenlight" (to
> distinguish from the prefetch itself) is now offloaded to the threads
> doing the work, which will only green light the next AG in the sequence.

Right - prefetch is now limited to one AG ahead of the AG being
processed by each worker thread.

> The code looks reasonable to me. Does the non-crc fs referenced in the
> commit log to repair at 1m57 still run at that rate with this enabled?

It's within the run-to-run variation:

<recreate 50m inode filesystem without CRCs>
....

Run single threaded:

$ time sudo xfs_repair -v -v -o bhash=32768  -t 1 -o ag_stride=-1 /dev/vdc
.....

        XFS_REPAIR Summary    Fri Feb 28 06:53:45 2014

Phase       Start       End             Duration
Phase 1:    02/28 06:51:54      02/28 06:51:54  
Phase 2:    02/28 06:51:54      02/28 06:52:02  8 seconds
Phase 3:    02/28 06:52:02      02/28 06:52:37  35 seconds
Phase 4:    02/28 06:52:37      02/28 06:53:03  26 seconds
Phase 5:    02/28 06:53:03      02/28 06:53:03  
Phase 6:    02/28 06:53:03      02/28 06:53:44  41 seconds
Phase 7:    02/28 06:53:44      02/28 06:53:44  

Total run time: 1 minute, 50 seconds
done

Run auto-threaded:

$ time sudo xfs_repair -v -v -o bhash=32768  -t 1 /dev/vdc
.....
        XFS_REPAIR Summary    Fri Feb 28 06:58:08 2014

Phase       Start       End             Duration
Phase 1:    02/28 06:56:13      02/28 06:56:14  1 second
Phase 2:    02/28 06:56:14      02/28 06:56:20  6 seconds
Phase 3:    02/28 06:56:20      02/28 06:56:59  39 seconds
Phase 4:    02/28 06:56:59      02/28 06:57:28  29 seconds
Phase 5:    02/28 06:57:28      02/28 06:57:28  
Phase 6:    02/28 06:57:28      02/28 06:58:08  40 seconds
Phase 7:    02/28 06:58:08      02/28 06:58:08  

Total run time: 1 minute, 55 seconds
done

Even single AG prefetching on this test is bandwidth bound (pair of
SSDs in RAID0, reading 900MB/s @ 2,500 IOPS), so multi-threading
doesn't make it any faster.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
