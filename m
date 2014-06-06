Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 13FC57F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 07:20:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0A96AC003
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 05:19:59 -0700 (PDT)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id lJP2josy5mTUxsHv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 05:19:57 -0700 (PDT)
Subject: Re: [PATCH] mm/vmscan: Do not block forever atshrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
	<201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1406031442170.19491@chino.kir.corp.google.com>
	<201406052145.CIB35534.OQLVMSJFOHtFOF@I-love.SAKURA.ne.jp>
	<20140605131753.GD4523@dastard>
In-Reply-To: <20140605131753.GD4523@dastard>
Message-Id: <201406062119.HHJ30796.FtLFOSFJOOVQMH@I-love.SAKURA.ne.jp>
Date: Fri, 6 Jun 2014 21:19:22 +0900
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
To: david@fromorbit.com
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, Motohiro.Kosaki@us.fujitsu.com, fengguang.wu@intel.com, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com

Dave Chinner wrote:
> On Thu, Jun 05, 2014 at 09:45:26PM +0900, Tetsuo Handa wrote:
> > This means that, under rare circumstances, it is possible that all processes
> > other than kswapd are trapped into too_many_isolated()/congestion_wait() loop
> > while kswapd is sleeping because this loop assumes that somebody else shall
> > wake up kswapd and kswapd shall perform operations for making
> > too_many_isolated() to return 0. However, we cannot guarantee that kswapd is
> > waken by somebody nor kswapd is not blocked by blocking operations inside
> > shrinker functions (e.g. mutex_lock()).
> 
> So what you are saying is that kswapd is having problems with
> getting blocked on locks held by processes in direct reclaim?
> 
> What are the stack traces that demonstrate such a dependency loop?

If a normal task's GFP_KERNEL memory allocation called a shrinker function and
the shrinker function does GFP_WAIT-able allocation with a mutex held, there
is a possibility that kswapd is waken up due to GFP_WAIT-able allocation and
kswapd calls the shrinker function, and the kswapd is blocked at trying to
hold the same mutex inside the shrinker function, isn't it?

Since ttm_dma_pool_shrink_count()/ttm_dma_pool_shrink_scan() holds a mutex
and ttm_dma_pool_shrink_scan() does GFP_WAIT-able allocation, I think such
a dependency loop is possible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
