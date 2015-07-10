Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 409CB7F37
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 01:19:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AF2F5AC009
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 23:19:29 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XtLtViCnhQkmVfDw for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 23:19:22 -0700 (PDT)
Date: Fri, 10 Jul 2015 16:19:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs puzzle] kmem_alloc hang in xlog_cil_insert_format_items
Message-ID: <20150710061920.GK3902@dastard>
References: <559F3750.5040002@unitedstack.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <559F3750.5040002@unitedstack.com>
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
To: juncheng bai <baijuncheng@unitedstack.com>
Cc: bfoster@redhat.com, sandeen@sandeen.net, xfs@oss.sgi.com

On Fri, Jul 10, 2015 at 11:09:04AM +0800, juncheng bai wrote:
> Hi,All.
> 
> Recently, I test xfs to verify kmem_alloc hang in
> xfs_dir2_block_to_sf in kernel-3.14, for patch
> b3f03bac8132207a20286d5602eda64500c19724.

You do not need to spam the list if you do not get an immediate
response to your initial question.

As it is, you commented on the bug report a couple of days again
where I explained exactly what the state of this problem was
(i.e. you asked "why can't we just use vmalloc?")

> After running for five hours , the output of warning all the time:
> 2015-07-07T23:32:18.230120+00:00 server-69 kernel: XFS: possible
> memory allocation deadlock in kmem_alloc (mode:0x8250 size:32832)

And that's pretty clear what the trigger here is - the 
allocation is just over the PAGE_ALLOC_COSTLY_ORDER threshold. We
see this retry come up at this point because that threshold changes
the behaviour of memory reclaim and makes allocations more likely to
fail...

> The patch b3f03bac8132207a20286d5602eda64500c19724 solves the
> problem of the big directroy size, more than 64k.
> Now, the 'struct txfs_log_vec' need 32k, but fail when the physical
> memory fragmentation is very serious; In the later, kmalloc may fail
> when process 16k.

Right now we have to choose between:
	- running small machines out of vmalloc space
	- triggering the OOM killer and killing random processes
	- failing the allocation whcih corrupts the filesystem in
	  memory, so we need to shut down the filesystem
	- retrying until we succeed.

We currently default to the least worst situation which is "retry
until we succeed" because all the other situations are much worse
(i.e. take the filesystem and/or machine down, rather than recover
when memory becomes available again).

As I said earlier, there is no quick fix for this problem and
shouting at us about it isn't going to get it solved any sooner.

> So, I think can we provide a unified solution? And I think why can't we
> use vmalloc when kmalloc fails?

I told you - there is limited vmalloc space on 32 bit systems, so
vmalloc can also fail due to vmalloc space being unavaiable, even
when there is plenty of memory available. i.e. on 32 bit systems
vmalloc is a lot more unreliable than kmalloc(). IOws, while vmalloc
might fix your specific problem on your machine, it is not a general
solution to the problem of kmalloc failing large allocations when
you run your system to OOM conditions.

And, FWIW, you can reduce the impact of the problem simply by making
your directory block size smaller.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
