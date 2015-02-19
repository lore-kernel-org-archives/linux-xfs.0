Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5A8B67F61
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 15:44:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29A108F8052
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:44:13 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	5ZBFmOAccNn1c1h3 for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 13:44:10 -0800 (PST)
Date: Fri, 20 Feb 2015 08:43:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150219214356.GW12722@dastard>
References: <20150210151934.GA11212@phnom.home.cmpxchg.org>
	<201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150218082502.GA4478@dhcp22.suse.cz>
	<20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150219110124.GC15569@phnom.home.cmpxchg.org>
	<20150219122914.GH28427@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150219122914.GH28427@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Thu, Feb 19, 2015 at 01:29:14PM +0100, Michal Hocko wrote:
> On Thu 19-02-15 06:01:24, Johannes Weiner wrote:
> [...]
> > Preferrably, we'd get rid of all nofail allocations and replace them
> > with preallocated reserves.  But this is not going to happen anytime
> > soon, so what other option do we have than resolving this on the OOM
> > killer side?
> 
> As I've mentioned in other email, we might give GFP_NOFAIL allocator
> access to memory reserves (by giving it __GFP_HIGH).

Won't work when you have thousands of concurrent transactions
running in XFS and they are all doing GFP_NOFAIL allocations. That's
why I suggested the per-transaction reserve pool - we can use that
to throttle the number of concurent contexts demanding memory for
forwards progress, just the same was we throttle the number of
concurrent processes based on maximum log space requirements of the
transactions and the amount of unreserved log space available.

No log space, transaction reservations waits on an ordered queue for
space to become available. No memory available, transaction
reservation waits on an ordered queue for memory to become
available.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
