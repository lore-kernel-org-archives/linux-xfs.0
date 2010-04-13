Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D8FJiw207146 for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 03:15:19 -0500
Received: from fgwmail5.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D8672BB111
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 01:17:13 -0700 (PDT)
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id Yjv0mvoMFmauNpBu for
	<xfs@oss.sgi.com>; Tue, 13 Apr 2010 01:17:13 -0700 (PDT)
Received: from m4.gw.fujitsu.co.jp ([10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id
	o3D8HAR2013194
	for <xfs@oss.sgi.com> (envelope-from kosaki.motohiro@jp.fujitsu.com);
	Tue, 13 Apr 2010 17:17:10 +0900
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 5F8F745DE60
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 17:17:10 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 3349A45DE4D
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 17:17:10 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 165BC1DB8037
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 17:17:10 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id BB8841DB803B
	for <xfs@oss.sgi.com>; Tue, 13 Apr 2010 17:17:09 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] mm: add context argument to shrinker callback
In-Reply-To: <1271118255-21070-2-git-send-email-david@fromorbit.com>
References: <1271118255-21070-1-git-send-email-david@fromorbit.com>
	<1271118255-21070-2-git-send-email-david@fromorbit.com>
Message-Id: <20100413170653.D10A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Date: Tue, 13 Apr 2010 17:17:08 +0900 (JST)
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com, xfs@oss.sgi.com

> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e70f21b..7d48942 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -982,11 +982,11 @@ static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
>  /*
>   * A callback you can register to apply pressure to ageable caches.
>   *
> - * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
> - * look through the least-recently-used 'nr_to_scan' entries and
> - * attempt to free them up.  It should return the number of objects
> - * which remain in the cache.  If it returns -1, it means it cannot do
> - * any scanning at this time (eg. there is a risk of deadlock).
> + * 'shrink' is passed a context 'ctx', a count 'nr_to_scan' and a 'gfpmask'.
> + * It should look through the least-recently-used 'nr_to_scan' entries and
> + * attempt to free them up.  It should return the number of objects which
> + * remain in the cache.  If it returns -1, it means it cannot do any scanning
> + * at this time (eg. there is a risk of deadlock).
>   *
>   * The 'gfpmask' refers to the allocation we are currently trying to
>   * fulfil.
> @@ -995,7 +995,8 @@ static inline void sync_mm_rss(struct task_struct *task, struct mm_struct *mm)
>   * querying the cache size, so a fastpath for that case is appropriate.
>   */
>  struct shrinker {
> -	int (*shrink)(int nr_to_scan, gfp_t gfp_mask);
> +	int (*shrink)(void *ctx, int nr_to_scan, gfp_t gfp_mask);
> +	void *ctx;	/* user callback context */
>  	int seeks;	/* seeks to recreate an obj */
>  
>  	/* These are for internal use */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5321ac4..40f27d2 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -215,8 +215,9 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
>  	list_for_each_entry(shrinker, &shrinker_list, list) {
>  		unsigned long long delta;
>  		unsigned long total_scan;
> -		unsigned long max_pass = (*shrinker->shrink)(0, gfp_mask);
> +		unsigned long max_pass;
>  
> +		max_pass = (*shrinker->shrink)(shrinker->ctx, 0, gfp_mask);
>  		delta = (4 * scanned) / shrinker->seeks;
>  		delta *= max_pass;
>  		do_div(delta, lru_pages + 1);
> @@ -244,8 +245,10 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
>  			int shrink_ret;
>  			int nr_before;
>  
> -			nr_before = (*shrinker->shrink)(0, gfp_mask);
> -			shrink_ret = (*shrinker->shrink)(this_scan, gfp_mask);
> +			nr_before = (*shrinker->shrink)(shrinker->ctx,
> +							0, gfp_mask);
> +			shrink_ret = (*shrinker->shrink)(shrinker->ctx,
> +							this_scan, gfp_mask);
>  			if (shrink_ret == -1)
>  				break;
>  			if (shrink_ret < nr_before)

Looks good about this mm part.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


off-topic: shrink_slab() was introduced for page/[id]-cache scan balancing
at first. now it still have hardcorded shrinker->nr calculation for slab
although now lots another subsystem using it. shrinker->seeks seems no
intuitive knob. probably we should try generalization it in future. but
it is another story. I think this patch provide good first step.

                delta = (4 * scanned) / shrinker->seeks;
                delta *= max_pass;
                do_div(delta, lru_pages + 1);
                shrinker->nr += delta;


Thanks.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
