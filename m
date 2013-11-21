Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6D767F3F
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 21:16:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 55976AC004
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 19:16:22 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	P1nuTis7ATk6ZQh3 for <xfs@oss.sgi.com>;
	Wed, 20 Nov 2013 19:16:19 -0800 (PST)
Date: Thu, 21 Nov 2013 14:16:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: prevent spurious "head behind tail" warnings
Message-ID: <20131121031600.GC6188@dastard>
References: <1384900659-22215-1-git-send-email-david@fromorbit.com>
	<528BEF71.1000607@sgi.com> <528BF327.2050802@sandeen.net>
	<528BF7F2.3050708@sgi.com> <20131121021933.GA6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131121021933.GA6188@dastard>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Nov 21, 2013 at 01:19:33PM +1100, Dave Chinner wrote:
> On Tue, Nov 19, 2013 at 05:44:50PM -0600, Mark Tinguely wrote:
> > On 11/19/13 17:24, Eric Sandeen wrote:
> > >On 11/19/13, 5:08 PM, Mark Tinguely wrote:
> > >>On 11/19/13 16:37, Dave Chinner wrote:
> > >>>From: Dave Chinner<dchinner@redhat.com>
> > >>>
> > >>>When xlog_space_left() cracks the grant head and the log tail, it
> > >>>does so without locking to synchronise the sampling of the
> > >>>variables. It samples the grant head first, so if there is a delay
> > >>>before it smaples the log tail, there is a window where the log tail
> > >>>could have moved onwards and be moved past the sampled value of the
> > >>>grant head. This then leads to the "xlog_space_left: head behind
> > >>>tail" warning message.
> > >>>
> > >>>To avoid spurious output in this situation, swap the order in which
> > >>>the variables are cracked. This means that the head may grant head
> > >>>may move if there is a delay, but the log tail will be stable, hence
> > >>>ensure the tail does not jump the head accidentally.
> > >>>
> > >>>While this avoids the spurious head behind tail problem, it
> > >>>introduces the opposite problem - the head can move more than a full
> > >>>cycle past the tail. The code already handles this case by
> > >>>indicating that the log is full (i.e. zero space available) but
> > >>>that's still (generally) a spurious situation.
> > >>>
> > >>>Hence, if we detect that the head is more than a cycle ahead of the
> > >>>tail or the head is behind the tail, start the calculation again by
> > >>>resampling the variables and trying again. If we get too many
> > >>>resamples, then throw a warning and return a full or empty log
> > >>>appropriately.
> > >>>
> > >>>Signed-off-by: Dave Chinner<dchinner@redhat.com>
> > >>>---
> > >>
> > >>I am still getting the debug message:
> > >>
> > >>   xlog_verify_grant_tail: space>  BBTOB(tail_blocks)
> > >>
> > >>This is a real over grant. It has been a while since I did all the tests, but basically the only way to stop it is to have a lock between checking for xlog_space_left() and actually reserving the space.
> > >>
> > >>I am not a fan of another band-aid on a problem that is caused because we are granting space without locks.
> > >
> > >Mark, can you remind us of your testcase that produces this?
> > >(sorry, I guess I should search for that old thread...)
> > >
> > >Thanks,
> > >-Eric
> > >
> > >>--Mark.
> > 
> > xfstest 273 hits it 100% of the time for me, as does 32+ process
> > fsstress, pretty much any high log usage test.
> 
> Yet I do those sorts of tests all the time on lots of different
> machines and I rarely see either of the warnings that we are talking
> about here. I sent the xlog_space_left() patch because a user
> reported their log being spammed, not because they had a problem
> with a filesystem hanging on log space.
> 
> i.e. spam == false positive, log space hang == real problem.
> 
> > I know Brian hit this with xfstest 273 when he was testing for
> > commit 9a3a5dab.
> > 
> > Using xfstest 273, I was seeing ten of thousand of bytes of over
> > commit.
> 
> That doesn't mean it's real.
> 
> By definition, a false positive shows exactly the same numbers as a
> real problem. The only way to determine it is a false positive is to
> use some other method of verifying the numbers. That could be
> checking the state of other related variables or simply resampling
> the variables multiple times to reduce the probability that the
> problem was caused by a temporary condition (i.e. a race).
> 
> In this case, resampling them from their source is used to reverify
> them, and if we get continual failures being detected, then the
> likelihood of them being a false positive is very low.
> 
> > From what I recall, I tried a separate lock for the
> > write/reserve grant heads,
> 
> We already have a per-grant head lock, and most of the calls to
> xlog_space_left() are called under it. Hence the problem I'm
> addressing is not a result of the grant head changing - the problem
> is the log tail is updated concurrently. No amount of locking being
> added to the grant heads will fix that problem.
> 
> And regardless of the fact that xlog_verify_grant_tail() samples the
> write grant head with locks (it's a atomic64_t to do this safely),

		   without locks

> the problem is that log tail can then change before it is sampled.
> No amount of locking the grant heads will fix that problem, either.
> 
> > put locks to make sure the verifier was
> > not getting stale information, ordered the write/reserve ungrants
> > relative to the grants, put in cache smp_mb() call. Some attempts
> > were more successful than others, but the only way I could prevent
> > the overgrant completely was to put back the global lock between the
> > checking for space and the granting of space.
> 
> Which won't have solved the problem of concurrent log tail updates
> occurring after the grant head has been sampled. All this change
> does is modify the concurrency patterns and hence made the race
> condition much harder to hit by disabling pre-emption across
> functions.
> 
> IOWs, we can probably get exactly the same result from adding
> "preempt_disable(); ....  preempt_enable();" around the variable
> sampling so that we cannot be pre-empted at all between the two
> samples being taken.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
