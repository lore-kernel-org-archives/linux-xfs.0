Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2AA837F54
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 03:10:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0AEB08F8089
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 01:10:05 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4TVHfuzlKESOAXgf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 01:10:03 -0800 (PST)
Date: Fri, 20 Feb 2015 10:10:01 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150220091001.GC21248@dhcp22.suse.cz>
References: <20150218082502.GA4478@dhcp22.suse.cz>
	<20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150219110124.GC15569@phnom.home.cmpxchg.org>
	<20150219122914.GH28427@dhcp22.suse.cz>
	<201502192229.FCJ73987.MFQLOHSJFFtOOV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201502192229.FCJ73987.MFQLOHSJFFtOOV@I-love.SAKURA.ne.jp>
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
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, hannes@cmpxchg.org, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, fernando_b1@lab.ntt.co.jp, torvalds@linux-foundation.org

On Thu 19-02-15 22:29:37, Tetsuo Handa wrote:
> Michal Hocko wrote:
> > On Thu 19-02-15 06:01:24, Johannes Weiner wrote:
> > [...]
> > > Preferrably, we'd get rid of all nofail allocations and replace them
> > > with preallocated reserves.  But this is not going to happen anytime
> > > soon, so what other option do we have than resolving this on the OOM
> > > killer side?
> > 
> > As I've mentioned in other email, we might give GFP_NOFAIL allocator
> > access to memory reserves (by giving it __GFP_HIGH). This is still not a
> > 100% solution because reserves could get depleted but this risk is there
> > even with multiple oom victims. I would still argue that this would be a
> > better approach because selecting more victims might hit pathological
> > case more easily (other victims might be blocked on the very same lock
> > e.g.).
> > 
> Does "multiple OOM victims" mean "select next if first does not die"?
> Then, I think my timeout patch http://marc.info/?l=linux-mm&m=142002495532320&w=2
> does not deplete memory reserves. ;-)

It doesn't because
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2603,9 +2603,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 		else if (in_serving_softirq() && (current->flags & PF_MEMALLOC))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
-		else if (!in_interrupt() &&
-				((current->flags & PF_MEMALLOC) ||
-				 unlikely(test_thread_flag(TIF_MEMDIE))))
+		else if (!in_interrupt() && (current->flags & PF_MEMALLOC))
 			alloc_flags |= ALLOC_NO_WATERMARKS;

you disabled the TIF_MEMDIE heuristic and use it only for OOM exclusion
and break out from the allocator. Exiting task might need a memory to do
so and you make all those allocations fail basically. How do you know
this is not going to blow up?

> If we change to permit invocation of the OOM killer for GFP_NOFS / GFP_NOIO,
> those who do not want to fail (e.g. journal transaction) will start passing
> __GFP_NOFAIL?
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
