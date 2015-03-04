Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3E977F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 09:04:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9146B8F8071
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 07:04:52 -0800 (PST)
Received: from gum.cmpxchg.org (gum.cmpxchg.org [85.214.110.215]) by
	cuda.sgi.com with ESMTP id d4yw5NYgW0DQRsnt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 07:04:50 -0800 (PST)
Date: Wed, 4 Mar 2015 10:04:36 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150304150436.GA16442@phnom.home.cmpxchg.org>
References: <20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150222172930.6586516d.akpm@linux-foundation.org>
	<20150223073235.GT4251@dastard>
	<20150302202228.GA15089@phnom.home.cmpxchg.org>
	<20150302231206.GK18360@dastard>
	<20150303025023.GA22453@phnom.home.cmpxchg.org>
	<20150304065242.GR18360@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304065242.GR18360@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org

On Wed, Mar 04, 2015 at 05:52:42PM +1100, Dave Chinner wrote:
> I suspect you've completely misunderstood what I've been suggesting.
> 
> By definition, we have the pages we reserved in the reserve pool,
> and unless we've exhausted that reservation with permanent
> allocations we should always be able to allocate from it. If the
> pool got emptied by demand page allocations, then we back off and
> retry reclaim until the reclaimable objects are released back into
> the reserve pool. i.e. reclaim fills reserve pools first, then when
> they are full pages can go back on free lists for normal
> allocations.  This provides the mechanism for forwards progress, and
> it's essentially the same mechanism that mempools use to guarantee
> forwards progess. the only difference is that reserve pool refilling
> comes through reclaim via shrinker invocation...

Yes, I had something else in mind.

In order to rely on replenishing through reclaim, you have to make
sure that all allocations taken out of the pool are guaranteed to come
back in a reasonable time frame.  So once Ted said that the filesystem
will not be able to declare which allocations of a task are allowed to
dip into its reserves, and thus allocations of indefinite lifetime can
enter the picture, my mind went to a one-off reserve pool that doesn't
rely on replenishing in order to make forward progress.  You declare
the worst-case, finish the transaction, and return what is left of the
reserves.  This obviously conflicts with the estimation model that you
are proposing, I hope it's now clear where our misunderstanding lies.

Yes, we can make this work if you can tell us which allocations have
limited/controllable lifetime.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
