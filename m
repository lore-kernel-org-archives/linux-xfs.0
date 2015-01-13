Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B6A537F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 16:58:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88CD9304039
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:58:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EB7jGnCe6WyXNO1H for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 14:58:30 -0800 (PST)
Message-ID: <54B5A313.2030300@sandeen.net>
Date: Tue, 13 Jan 2015 16:58:27 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
References: <20150109182310.GA2785@htj.dyndns.org>	<54B03BCC.7040207@sandeen.net>	<20150110192852.GD25319@htj.dyndns.org>	<54B429EB.9050807@sandeen.net>	<20150112225314.GC22156@htj.dyndns.org>	<54B454E2.70707@sandeen.net>	<20150112233755.GD22156@htj.dyndns.org>	<54B56D2B.6090401@sandeen.net>	<20150113201900.GA9489@htj.dyndns.org>	<54B58041.9070502@sandeen.net>
	<20150113204633.GC9489@htj.dyndns.org>
In-Reply-To: <20150113204633.GC9489@htj.dyndns.org>
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

On 1/13/15 2:46 PM, Tejun Heo wrote:

> So,
> 
> 	nr_workers == 15,
> 	nr_idle == 0,
> 	nr_running == 0,
> 
> That means one worker must be playing the role of manager by executing
> manage_workers() whic his also responsible for kicking off the
> rescuers if it fails to create new workers in a short period of time.
> The manager is identifier as the holder of pool->manager_arb and while
> a manager is trying to creat a worker, pool->mayday_timer must be
> armed continuously firing off every MAYDAY_INTERVAL summoning rescuers
> to the pool, which should be visible through the pool_pwq->mayday_node
> corresponding to the stalled pool being queued on wq->maydays.
> 
> Can you post the full dump of the pool, wq and all kworkers?
> 
> Thanks.
> 

Just for mailing list archive posterity, Tejun thinks he's found the culprit
in the workqueue code, I or he can follow up again when he has a patch ready
to go.

Thanks Tejun!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
