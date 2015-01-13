Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (unknown [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 46DCB7F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 14:46:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 69AA4AC003
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:46:39 -0800 (PST)
Received: from mail-qc0-f173.google.com (mail-qc0-f173.google.com
	[209.85.216.173]) by cuda.sgi.com with ESMTP id
	6FH41qm6gEV98lc4 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 12:46:36 -0800 (PST)
Received: by mail-qc0-f173.google.com with SMTP id i17so4301552qcy.4
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:46:36 -0800 (PST)
Date: Tue, 13 Jan 2015 15:46:33 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/2] xfs: mark the xfs-alloc workqueue as high priority
Message-ID: <20150113204633.GC9489@htj.dyndns.org>
References: <20150109182310.GA2785@htj.dyndns.org>
	<54B03BCC.7040207@sandeen.net>
	<20150110192852.GD25319@htj.dyndns.org>
	<54B429EB.9050807@sandeen.net>
	<20150112225314.GC22156@htj.dyndns.org>
	<54B454E2.70707@sandeen.net>
	<20150112233755.GD22156@htj.dyndns.org>
	<54B56D2B.6090401@sandeen.net>
	<20150113201900.GA9489@htj.dyndns.org>
	<54B58041.9070502@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54B58041.9070502@sandeen.net>
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

Hello, Eric.

On Tue, Jan 13, 2015 at 02:29:53PM -0600, Eric Sandeen wrote:
> > Can you please also report the value of nr_running?  That's what
> > regulates the kick off of new workers and rescuers.
> 
> sorry about that, swapped nr_workers w/ nr_running in my brain:
> 
>   nr_running = {
>     counter = 0
>   }, 

So,

	nr_workers == 15,
	nr_idle == 0,
	nr_running == 0,

That means one worker must be playing the role of manager by executing
manage_workers() whic his also responsible for kicking off the
rescuers if it fails to create new workers in a short period of time.
The manager is identifier as the holder of pool->manager_arb and while
a manager is trying to creat a worker, pool->mayday_timer must be
armed continuously firing off every MAYDAY_INTERVAL summoning rescuers
to the pool, which should be visible through the pool_pwq->mayday_node
corresponding to the stalled pool being queued on wq->maydays.

Can you post the full dump of the pool, wq and all kworkers?

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
