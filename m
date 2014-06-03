Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 40B5D7F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 16:43:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B0B01AC008
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 14:43:26 -0700 (PDT)
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com
	[209.85.213.175]) by cuda.sgi.com with ESMTP id
	j4ykrExdXkzenkCD (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Jun 2014 14:43:25 -0700 (PDT)
Received: by mail-ig0-f175.google.com with SMTP id uq10so5522356igb.14
	for <xfs@oss.sgi.com>; Tue, 03 Jun 2014 14:43:24 -0700 (PDT)
Date: Tue, 3 Jun 2014 14:43:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm/vmscan: Do not block forever atshrink_inactive_list().
In-Reply-To: <201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
Message-ID: <alpine.DEB.2.02.1406031442170.19491@chino.kir.corp.google.com>
References: <20140520004449.GE18954@dastard>
	<20140519225915.3370328d.akpm@linux-foundation.org>
	<20140520063024.GH18954@dastard>
	<201405202358.ADF10119.SMOFOQLFtOVHJF@I-love.SAKURA.ne.jp>
	<6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
	<201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
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
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, kosaki.motohiro@jp.fujitsu.com, Motohiro.Kosaki@us.fujitsu.com, fengguang.wu@intel.com, akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com

On Mon, 26 May 2014, Tetsuo Handa wrote:

> In shrink_inactive_list(), we do not insert delay at
> 
>   if (!sc->hibernation_mode && !current_is_kswapd())
>     wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
> 
> if sc->hibernation_mode != 0.
> Follow the same reason, we should not insert delay at
> 
>   while (unlikely(too_many_isolated(zone, file, sc))) {
>     congestion_wait(BLK_RW_ASYNC, HZ/10);
> 
>     /* We are about to die and free our memory. Return now. */
>     if (fatal_signal_pending(current))
>       return SWAP_CLUSTER_MAX;
>   }
> 
> if sc->hibernation_mode != 0.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  mm/vmscan.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 32c661d..89c42ca 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1362,6 +1362,9 @@ static int too_many_isolated(struct zone *zone, int file,
>  	if (current_is_kswapd())
>  		return 0;
>  
> +	if (sc->hibernation_mode)
> +		return 0;
> +
>  	if (!global_reclaim(sc))
>  		return 0;
>  

This isn't the only too_many_isolated() functions that do a delay, how is 
the too_many_isolated() in mm/compaction.c different?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
