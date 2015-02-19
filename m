Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1291E7FBF
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 07:29:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A42BEAC003
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 05:29:51 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id 1JgHIjFlcFWGryNX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 05:29:49 -0800 (PST)
Subject: Re: How to handle TIF_MEMDIE stalls?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20150218082502.GA4478@dhcp22.suse.cz>
	<20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150219110124.GC15569@phnom.home.cmpxchg.org>
	<20150219122914.GH28427@dhcp22.suse.cz>
In-Reply-To: <20150219122914.GH28427@dhcp22.suse.cz>
Message-Id: <201502192229.FCJ73987.MFQLOHSJFFtOOV@I-love.SAKURA.ne.jp>
Date: Thu, 19 Feb 2015 22:29:37 +0900
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
To: mhocko@suse.cz, hannes@cmpxchg.org
Cc: dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, fernando_b1@lab.ntt.co.jp, torvalds@linux-foundation.org

Michal Hocko wrote:
> On Thu 19-02-15 06:01:24, Johannes Weiner wrote:
> [...]
> > Preferrably, we'd get rid of all nofail allocations and replace them
> > with preallocated reserves.  But this is not going to happen anytime
> > soon, so what other option do we have than resolving this on the OOM
> > killer side?
> 
> As I've mentioned in other email, we might give GFP_NOFAIL allocator
> access to memory reserves (by giving it __GFP_HIGH). This is still not a
> 100% solution because reserves could get depleted but this risk is there
> even with multiple oom victims. I would still argue that this would be a
> better approach because selecting more victims might hit pathological
> case more easily (other victims might be blocked on the very same lock
> e.g.).
> 
Does "multiple OOM victims" mean "select next if first does not die"?
Then, I think my timeout patch http://marc.info/?l=linux-mm&m=142002495532320&w=2
does not deplete memory reserves. ;-)

If we change to permit invocation of the OOM killer for GFP_NOFS / GFP_NOIO,
those who do not want to fail (e.g. journal transaction) will start passing
__GFP_NOFAIL?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
