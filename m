Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 444667F3F
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 07:46:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09D9D304077
	for <xfs@oss.sgi.com>; Thu,  5 Jun 2014 05:46:11 -0700 (PDT)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id KAfX1F5fkFWEcfLY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Jun 2014 05:46:09 -0700 (PDT)
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140520063024.GH18954@dastard>
	<201405202358.ADF10119.SMOFOQLFtOVHJF@I-love.SAKURA.ne.jp>
	<6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
	<201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1406031442170.19491@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406031442170.19491@chino.kir.corp.google.com>
Message-Id: <201406052145.CIB35534.OQLVMSJFOHtFOF@I-love.SAKURA.ne.jp>
Date: Thu, 5 Jun 2014 21:45:26 +0900
Mime-Version: 1.0
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
To: rientjes@google.com, Motohiro.Kosaki@us.fujitsu.com
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com

David Rientjes wrote:
> On Mon, 26 May 2014, Tetsuo Handa wrote:
> 
> > In shrink_inactive_list(), we do not insert delay at
> > 
> >   if (!sc->hibernation_mode && !current_is_kswapd())
> >     wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
> > 
> > if sc->hibernation_mode != 0.
> > Follow the same reason, we should not insert delay at
> > 
> >   while (unlikely(too_many_isolated(zone, file, sc))) {
> >     congestion_wait(BLK_RW_ASYNC, HZ/10);
> > 
> >     /* We are about to die and free our memory. Return now. */
> >     if (fatal_signal_pending(current))
> >       return SWAP_CLUSTER_MAX;
> >   }
> > 
> > if sc->hibernation_mode != 0.
> > 
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > ---
> >  mm/vmscan.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 32c661d..89c42ca 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1362,6 +1362,9 @@ static int too_many_isolated(struct zone *zone, int file,
> >  	if (current_is_kswapd())
> >  		return 0;
> >  
> > +	if (sc->hibernation_mode)
> > +		return 0;
> > +
> >  	if (!global_reclaim(sc))
> >  		return 0;
> >  
> 
> This isn't the only too_many_isolated() functions that do a delay, how is 
> the too_many_isolated() in mm/compaction.c different?
> 

I don't know. But today I realized that this patch is not sufficient.

I'm trying to find why __alloc_pages_slowpath() cannot return for many minutes
when a certain type of memory pressure is given on a RHEL7 environment with
4 CPU / 2GB RAM. Today I tried to use ftrace for examining the breakdown of
time-consuming functions inside __alloc_pages_slowpath(). But on the first run,
all processes are trapped into this too_many_isolated()/congestion_wait() loop
while kswapd is not running; stalling forever because nobody can perform
operations for making too_many_isolated() to return 0.

This means that, under rare circumstances, it is possible that all processes
other than kswapd are trapped into too_many_isolated()/congestion_wait() loop
while kswapd is sleeping because this loop assumes that somebody else shall
wake up kswapd and kswapd shall perform operations for making
too_many_isolated() to return 0. However, we cannot guarantee that kswapd is
waken by somebody nor kswapd is not blocked by blocking operations inside
shrinker functions (e.g. mutex_lock()).

We need some more changes. I'm thinking memory allocation watchdog thread.
Add an "unsigned long" field to "struct task_struct", set jiffies to the field
upon entry of GFP_WAIT-able memory allocation attempts, and clear the field
upon returning from GFP_WAIT-able memory allocation attempts. A kernel thread
periodically scans task list and compares the field and jiffies, and (at least)
print warning messages (maybe optionally trigger OOM-killer or kernel panic)
if single memory allocation attempt is taking too long (e.g. 60 seconds).
What do you think?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
