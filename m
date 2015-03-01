Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 726EA7F67
	for <xfs@oss.sgi.com>; Sun,  1 Mar 2015 14:18:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4342B304032
	for <xfs@oss.sgi.com>; Sun,  1 Mar 2015 12:17:58 -0800 (PST)
Received: from gum.cmpxchg.org (gum.cmpxchg.org [85.214.110.215]) by
	cuda.sgi.com with ESMTP id 5z4NvyWbYDtFPSY2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Mar 2015 12:17:56 -0800 (PST)
Date: Sun, 1 Mar 2015 15:17:39 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150301201739.GA7365@phnom.home.cmpxchg.org>
References: <20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150228162943.GA17989@phnom.home.cmpxchg.org>
	<20150228164158.GE5404@thunk.org>
	<20150228221558.GA23028@phnom.home.cmpxchg.org>
	<20150301134322.GA3287@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150301134322.GA3287@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Sun, Mar 01, 2015 at 08:43:22AM -0500, Theodore Ts'o wrote:
> On Sat, Feb 28, 2015 at 05:15:58PM -0500, Johannes Weiner wrote:
> > Overestimating should be fine, the result would a bit of false memory
> > pressure.  But underestimating and looping can't be an option or the
> > original lockups will still be there.  We need to guarantee forward
> > progress or the problem is somewhat mitigated at best - only now with
> > quite a bit more complexity in the allocator and the filesystems.
> 
> We've lived with looping as it is and in practice it's actually worked
> well.  I can only speak for ext4, but I do a lot of testing under very
> high memory pressure situations, and it is used in *production* under
> very high stress situations --- and the only time we'e run into
> trouble is when the looping behaviour somehow got accidentally
> *removed*.

Memory is a finite resource and there are (unlimited) consumers that
do not allow their share to be reclaimed/recycled.  Mainly this is the
kernel itself, but it also includes anon memory once swap space runs
out, as well as mlocked and dirty memory.  It's not a question of
whether there exists a true point of OOM (where not enough memory is
recyclable to satisfy new allocations).  That point inevitably exists.
It's a policy question of how to inform userspace once it is reached.

We agree that we can't unconditionally fail allocations, because we
might be in the middle of a transaction, where an allocation failure
can potentially corrupt userdata.  However, endlessly looping for
progress that can not happen at this point has the exact same effect:
the transaction won't finish.  Only the machine locks up in addition.
It's great that your setups don't ever truly go out of memory, but
that doesn't mean it can't happen in practice.

One answer to users at this point could certainly be to stay away from
the true point of OOM, and if you don't then that's your problem.  But
the issue I take with this answer is that, for the sake of memory
utilization, users kind of do want to get fairly close to this point,
and at the same time it's hard to reliably predict the memory
consumption of a workload in advance.  It can depend on the timing
between threads, it can depend on user/network-supplied input, and it
can simply be a bug in the application.  And if that OOM situation is
accidentally entered, I'd prefer we had a better answer than locking
up the machine and blame the user.

So one attempt to make progress in this situation is to kill userspace
applications that are pinning unreclaimable memory.  This is what we
are doing now, but there are several problems with it.  For one, we
are doing a terrible job and might still get stuck sometimes, which
deteriorates the situation back to failing the allocation and
corrupting the filesystem.  Secondly, killing tasks is disruptive, and
because it's driven by heuristics we're never going to kill the
"right" one in all situations.

Reserves would allow us to look ahead and avoid starting transactions
that can not be finished given the available resources.  So we are at
least avoiding filesystem corruption.  The tasks could probably be put
to sleep for some time in the hope that ongoing transactions complete
and release memory, but there might not be any, and eventually the OOM
situation has to be communicated to userspace.  Arguably, an -ENOMEM
from a syscall at this point might be easier to handle than a SIGKILL
from the OOM killer in an unrelated task.

So if we could pull off reserves, they look like the most attractive
solution to me.  If not, the OOM killer needs to be fixed to always
make forward progress instead.  I proposed a patch for that already.
But infinite loops that force the user to reboot the machine at the
point of OOM seem like a terrible policy.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
