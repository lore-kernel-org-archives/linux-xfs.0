Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6FA8B804C
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 08:52:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16D9FAC016
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 06:52:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RttmmqGUfronutAg for
	<xfs@oss.sgi.com>; Tue, 08 Apr 2014 06:52:42 -0700 (PDT)
Date: Tue, 8 Apr 2014 09:52:40 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs_repair: fix prefetch queue waiting
Message-ID: <20140408135239.GB23051@bfoster.bfoster>
References: <53436CA0.1090106@redhat.com>
	<20140408125832.GA23051@bfoster.bfoster>
	<5343FB53.6030902@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5343FB53.6030902@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 08, 2014 at 08:36:19AM -0500, Eric Sandeen wrote:
> On 4/8/14, 7:58 AM, Brian Foster wrote:
> > On Mon, Apr 07, 2014 at 10:27:28PM -0500, Eric Sandeen wrote:
> >> This fixes a regression caused by:
> >>
> >> 97b1fcf xfs_repair: fix array overrun in do_inode_prefetch
> >>
> >> The thread creation loop has 2 ways to exit; either via
> >> the loop counter based on thread_count, or the break statement
> >> if we've started enough workers to cover all AGs.
> >>
> >> Whether or not the loop counter "i" reflects the number of
> >> threads started depends on whether or not we exited via the
> >> break.
> >>
> >> The above commit prevented us from indexing off the end
> >> of the queues[] array if we actually advanced "i" all the
> >> way to thread_count, but in the case where we break, "i"
> >> is one *less* than the nr of threads started, so we don't
> >> wait for completion of all threads, and all hell breaks
> >> loose in phase 5.
> >>
> >> Just stop with the cleverness of re-using the loop counter -
> >> instead, explicitly count threads that we start, and then use
> >> that counter to wait for each worker to complete.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> I have one fs which demonstrates the problem, and have verified
> >> the regression & tested the fix against that.
> >>
> >> I'll run this over xfstests overnight, but it seems obvious
> >> from here (OTOH the other fix seemed obvious too) :(
> >>
> >> diff --git a/repair/prefetch.c b/repair/prefetch.c
> >> index e47a48e..4c32395 100644
> >> --- a/repair/prefetch.c
> >> +++ b/repair/prefetch.c
> >> @@ -944,6 +944,7 @@ do_inode_prefetch(
> >>  	int			i;
> >>  	struct work_queue	queue;
> >>  	struct work_queue	*queues;
> >> +	int			queues_started = 0;
> >>  
> >>  	/*
> >>  	 * If the previous phases of repair have not overflowed the buffer
> >> @@ -987,6 +988,7 @@ do_inode_prefetch(
> >>  
> >>  		create_work_queue(&queues[i], mp, 1);
> >>  		queue_work(&queues[i], prefetch_ag_range_work, 0, wargs);
> >> +		queues_started++;
> >>  
> >>  		if (wargs->end_ag >= mp->m_sb.sb_agcount)
> >>  			break;
> >> @@ -995,7 +997,7 @@ do_inode_prefetch(
> >>  	/*
> >>  	 * wait for workers to complete
> >>  	 */
> >> -	while (i--)
> >> +	for (i = 0; i < queues_started; i++)
> >>  		destroy_work_queue(&queues[i]);
> > 
> > Fix looks good, but any reason to reverse the order of the destroy loop?
> 
> simplicity? :)
> 

Fine by me. :)

Reviewed-by: Brian Foster <bfoster@redhat.com>

> I don't think it matters operationally...
> 
> -Eric
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
