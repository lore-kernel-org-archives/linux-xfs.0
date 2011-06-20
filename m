Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5K1PbGh098465 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 20:25:37 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 108061C582
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 18:25:36 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	12Q8q8p2RTHIvWfk for <xfs@oss.sgi.com>;
	Sun, 19 Jun 2011 18:25:36 -0700 (PDT)
Date: Mon, 20 Jun 2011 11:25:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/12] vmscan: shrinker->nr updates race and go wrong
Message-ID: <20110620012531.GN561@dastard>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
	<1306998067-27659-3-git-send-email-david@fromorbit.com>
	<4DFE987E.1070900@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DFE987E.1070900@jp.fujitsu.com>
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
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jun 20, 2011 at 09:46:54AM +0900, KOSAKI Motohiro wrote:
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 48e3fbd..dce2767 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -251,17 +251,29 @@ unsigned long shrink_slab(struct shrink_control *shrink,
> >  		unsigned long total_scan;
> >  		unsigned long max_pass;
> >  		int shrink_ret = 0;
> > +		long nr;
> > +		long new_nr;
> >  
> > +		/*
> > +		 * copy the current shrinker scan count into a local variable
> > +		 * and zero it so that other concurrent shrinker invocations
> > +		 * don't also do this scanning work.
> > +		 */
> > +		do {
> > +			nr = shrinker->nr;
> > +		} while (cmpxchg(&shrinker->nr, nr, 0) != nr);
> > +
> > +		total_scan = nr;
> >  		max_pass = do_shrinker_shrink(shrinker, shrink, 0);
> >  		delta = (4 * nr_pages_scanned) / shrinker->seeks;
> >  		delta *= max_pass;
> >  		do_div(delta, lru_pages + 1);
> > -		shrinker->nr += delta;
> > -		if (shrinker->nr < 0) {
> > +		total_scan += delta;
> > +		if (total_scan < 0) {
> >  			printk(KERN_ERR "shrink_slab: %pF negative objects to "
> >  			       "delete nr=%ld\n",
> > -			       shrinker->shrink, shrinker->nr);
> > -			shrinker->nr = max_pass;
> > +			       shrinker->shrink, total_scan);
> > +			total_scan = max_pass;
> >  		}
> >  
> >  		/*
> > @@ -269,13 +281,11 @@ unsigned long shrink_slab(struct shrink_control *shrink,
> >  		 * never try to free more than twice the estimate number of
> >  		 * freeable entries.
> >  		 */
> > -		if (shrinker->nr > max_pass * 2)
> > -			shrinker->nr = max_pass * 2;
> > +		if (total_scan > max_pass * 2)
> > +			total_scan = max_pass * 2;
> >  
> > -		total_scan = shrinker->nr;
> > -		shrinker->nr = 0;
> >  
> > -		trace_mm_shrink_slab_start(shrinker, shrink, nr_pages_scanned,
> > +		trace_mm_shrink_slab_start(shrinker, shrink, nr, nr_pages_scanned,
> >  					lru_pages, max_pass, delta, total_scan);
> >  
> >  		while (total_scan >= SHRINK_BATCH) {
> > @@ -295,8 +305,19 @@ unsigned long shrink_slab(struct shrink_control *shrink,
> >  			cond_resched();
> >  		}
> >  
> > -		shrinker->nr += total_scan;
> > -		trace_mm_shrink_slab_end(shrinker, shrink_ret, total_scan);
> > +		/*
> > +		 * move the unused scan count back into the shrinker in a
> > +		 * manner that handles concurrent updates. If we exhausted the
> > +		 * scan, there is no need to do an update.
> > +		 */
> > +		do {
> > +			nr = shrinker->nr;
> > +			new_nr = total_scan + nr;
> > +			if (total_scan <= 0)
> > +				break;
> > +		} while (cmpxchg(&shrinker->nr, nr, new_nr) != nr);
> > +
> > +		trace_mm_shrink_slab_end(shrinker, shrink_ret, nr, new_nr);
> >  	}
> >  	up_read(&shrinker_rwsem);
> >  out:
> 
> Looks great fix. Please remove tracepoint change from this patch and send it
> to -stable. iow, I expect I'll ack your next spin.

I don't believe such a change belongs in -stable. This code has been
buggy for many years and as I mentioned it actually makes existing
bad shrinker behaviour worse. I don't test stable kernels, so I've
got no idea what side effects it will have outside of this series.
I'm extremely hesitant to change VM behaviour in stable kernels
without having tested first, so I'm not going to push it for stable
kernels.

If you want it in stable kernels, then you can always let
stable@kernel.org know once the commits are in the mainline tree and
you've tested them...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
