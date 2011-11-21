Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALN2vfO026212 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 17:02:57 -0600
Received: from e33.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3CAF2690F4
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 15:02:56 -0800 (PST)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id fiE3QiMtxlQ9wkxh for
	<xfs@oss.sgi.com>; Mon, 21 Nov 2011 15:02:56 -0800 (PST)
Received: from /spool/local
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 21 Nov 2011 16:02:53 -0700
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pALN1wqj104436 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:01:59 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pALN1tg8024924
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 16:01:57 -0700
Subject: Re: [PATCH] xfs: Remove the entries from the queue while waking
	them up.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20111119011450.GL7046@dastard>
References: <1321644054.2201.80.camel@chandra-lucid.austin.ibm.com>
	<20111119011450.GL7046@dastard>
Date: Mon, 21 Nov 2011 17:01:52 -0600
Message-ID: <1321916512.7115.4.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Hi Dave,

Thanks for the review and comments.

On Sat, 2011-11-19 at 12:14 +1100, Dave Chinner wrote:
> On Fri, Nov 18, 2011 at 01:20:54PM -0600, Chandra Seetharaman wrote:
> > l_reserveq and l_writeq maintains a list of processes waiting to get log
> > space. Processes are supposed to get in the list when the amount of free
> > space available in the log is less than what they need.
> > 
> > When space becomes available current code, wakes up the processes, but
> > expect the processes to remove themselves from the queue.
> > 
> > Since the lock protecting the list is only acquired later by the woken
> > up process, there is a window of time were a new process that is looking
> > for space can wrongly get into the queue while there is enough space
> > available. 
> > 
> > Since there is enough space available, this process can never be woken
> > up, which leads to the hang of the process.
> 
> Excellent work, Chandra.

Thanks Dave.

Made all the changes (except one as noted below). Testing the new code
and will sent it soon.

:
:
:
<snip>

> > @@ -2550,8 +2552,7 @@ redo:
> >  	free_bytes = xlog_space_left(log, &log->l_grant_reserve_head);
> >  	if (free_bytes < need_bytes) {
> >  		spin_lock(&log->l_grant_reserve_lock);
> > -		if (list_empty(&tic->t_queue))
> > -			list_add_tail(&tic->t_queue, &log->l_reserveq);
> > +		list_add_tail(&tic->t_queue, &log->l_reserveq);
> >  
> >  		trace_xfs_log_grant_sleep2(log, tic);
> >  
> 
> Ok, we now have the assumption that when we enter this code the
> ticket is not on any queue at all. Can you add an
> "ASSERT(list_empty(&tic->t_queue));" to the code before the above
> xlog_space_left() call? That way we'll know if we violate that
> assumption as potentially corrupt memory....

As Christoph pointed, we might have been woken up by some system event.
So, I changed the code a bit around here. Please comment on the new
code.


<snip>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
