Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 12D437F47
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 18:04:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E647B304043
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2015 16:04:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WUmsc9Mu9H9kJ5YZ for <xfs@oss.sgi.com>;
	Sat, 10 Jan 2015 16:04:32 -0800 (PST)
Message-ID: <54B1BE0E.7020302@sandeen.net>
Date: Sat, 10 Jan 2015 18:04:30 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
References: <54B01927.2010506@redhat.com>
	<54B019F4.8030009@sandeen.net>	<20150109182310.GA2785@htj.dyndns.org>	<54B03BCC.7040207@sandeen.net>
	<20150110192852.GD25319@htj.dyndns.org>
In-Reply-To: <20150110192852.GD25319@htj.dyndns.org>
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
To: Tejun Heo <tj@kernel.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 1/10/15 1:28 PM, Tejun Heo wrote:
> Hello, Eric.


> As long as the split worker is queued on a separate workqueue, it's
> not really stuck behind xfs_end_io's.  If the global pool that the
> work item is queued on can't make forward progress due to memory
> pressure, the rescuer will be summoned and it will pick out that work
> item and execute it.

Ok, but that's not happening...

> The only reasons that work item would stay there are
> 
> * The rescuer is already executing something else from that workqueue
>   and that one is stuck.

I'll have to look at that.  I hope I still have access to the core...

> * The worker pool is still considered to be making forward progress -
>   there's a worker which isn't blocked and can burn CPU cycles.

AFAICT, the first thing in the pool is the xffs_end_io blocked waiting for the ilock.

I assume it's only the first one that matters?

>   ie. if you have a busy spinning work item on the per-cpu workqueue,
>   it can stall progress.

...

> Again, if xfs is using workqueue correctly, that work item shouldn't
> get stuck at all.  What other workqueues are doing is irrelevant.

and yet here we are; one of us must be missing something.  It's quite
possibly me :) but we definitely have this thing wedged, and moving
the xfsalloc item to the front via high priority did solve it.  Not saying
it's the right solution, just a data point.

Thanks,
-Eric
 
> Thanks.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
