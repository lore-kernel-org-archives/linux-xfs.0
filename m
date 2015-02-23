Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD9377F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 04:48:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 864B6AC002
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 02:48:14 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id X7pWsDM34M1gXn8r (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 02:48:12 -0800 (PST)
Date: Mon, 23 Feb 2015 11:48:10 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150223104810.GD24272@dhcp22.suse.cz>
References: <201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<201502201936.HBH34799.SOLFFFQtHOMOJV@I-love.SAKURA.ne.jp>
	<20150220231511.GH12722@dastard> <20150221032000.GC7922@thunk.org>
	<20150221011907.2d26c979.akpm@linux-foundation.org>
	<20150222002058.GB25079@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150222002058.GB25079@phnom.home.cmpxchg.org>
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
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, rientjes@google.com, oleg@redhat.com, xfs@oss.sgi.com, linux-mm@kvack.org, mgorman@suse.de, dchinner@redhat.com, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, torvalds@linux-foundation.org

On Sat 21-02-15 19:20:58, Johannes Weiner wrote:
> On Sat, Feb 21, 2015 at 01:19:07AM -0800, Andrew Morton wrote:
> > Short term, we need to fix 3.19.x and 3.20 and that appears to be by
> > applying Johannes's akpm-doesnt-know-why-it-works patch:
> > 
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2382,8 +2382,15 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
> >  		if (high_zoneidx < ZONE_NORMAL)
> >  			goto out;
> >  		/* The OOM killer does not compensate for light reclaim */
> > -		if (!(gfp_mask & __GFP_FS))
> > +		if (!(gfp_mask & __GFP_FS)) {
> > +			/*
> > +			 * XXX: Page reclaim didn't yield anything,
> > +			 * and the OOM killer can't be invoked, but
> > +			 * keep looping as per should_alloc_retry().
> > +			 */
> > +			*did_some_progress = 1;
> >  			goto out;
> > +		}
> >  		/*
> >  		 * GFP_THISNODE contains __GFP_NORETRY and we never hit this.
> >  		 * Sanity check for bare calls of __GFP_THISNODE, not real OOM.
> > 
> > Have people adequately confirmed that this gets us out of trouble?
> 
> I'd be interested in this too.  Who is seeing these failures?
> 
> Andrew, can you please use the following changelog for this patch?
> 
> ---
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> mm: page_alloc: revert inadvertent !__GFP_FS retry behavior change
> 
> Historically, !__GFP_FS allocations were not allowed to invoke the OOM
> killer once reclaim had failed, but nevertheless kept looping in the
> allocator.  9879de7373fc ("mm: page_alloc: embed OOM killing naturally
> into allocation slowpath"), which should have been a simple cleanup
> patch, accidentally changed the behavior to aborting the allocation at
> that point.  This creates problems with filesystem callers (?) that
> currently rely on the allocator waiting for other tasks to intervene.
> 
> Revert the behavior as it shouldn't have been changed as part of a
> cleanup patch.

OK, if this a _short term_ change. I really think that all the requests
except for __GFP_NOFAIL should be able to fail. I would argue that it
should be the caller who should be fixed but it is true that the patch
was introduced too late (rc7) and so it caught other subsystems
unprepared so backporting to stable makes sense to me. But can we please
move on and stop pretending that allocations do not fail for the
upcoming release?

> Fixes: 9879de7373fc ("mm: page_alloc: embed OOM killing naturally into allocation slowpath")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
