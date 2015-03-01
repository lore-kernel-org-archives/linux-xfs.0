Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CB5E57F69
	for <xfs@oss.sgi.com>; Sun,  1 Mar 2015 14:44:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 688C1AC003
	for <xfs@oss.sgi.com>; Sun,  1 Mar 2015 12:44:28 -0800 (PST)
Received: from gum.cmpxchg.org (gum.cmpxchg.org [85.214.110.215]) by
	cuda.sgi.com with ESMTP id xO8wCsL0C4A6uhH8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Mar 2015 12:44:23 -0800 (PST)
Date: Sun, 1 Mar 2015 15:44:12 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150301204412.GA8497@phnom.home.cmpxchg.org>
References: <20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150228162943.GA17989@phnom.home.cmpxchg.org>
	<20150228164158.GE5404@thunk.org>
	<20150228221558.GA23028@phnom.home.cmpxchg.org>
	<20150301134322.GA3287@thunk.org>
	<20150301161506.GA1854@phnom.home.cmpxchg.org>
	<20150301193635.GB3287@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150301193635.GB3287@thunk.org>
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

On Sun, Mar 01, 2015 at 02:36:35PM -0500, Theodore Ts'o wrote:
> On Sun, Mar 01, 2015 at 11:15:06AM -0500, Johannes Weiner wrote:
> > 
> > We had these lockups in cgroups with just a handful of threads, which
> > all got stuck in the allocator and there was nobody left to volunteer
> > unreclaimable memory.  When this was being addressed, we knew that the
> > same can theoretically happen on the system-level but weren't aware of
> > any reports.  Well now, here we are.
> 
> I think the "few threads in a small" cgroup problem is a little
> difference, because in those cases very often the global system has
> enough memory, and there is always the possibility that we might relax
> the memory cgroup guarantees a little in order to allow forward
> progress.

That's exactly how we fixed it.  __GFP_NOFAIL are allowed to simply
bypass the cgroup memory limits when reclaim within the group fails to
make room for the allocation.  I'm just mentioning that because the
global case doesn't have the same out, but is susceptible to the same
deadlock situation when there are no other threads volunteering pages.

If your machines are loaded with hundreds or thousands of threads, the
chances that a thread stuck in the allocator will be bailed out by the
other threads in the system is likely (or that you run into CPU limits
first), but if you have only a handful of memory-intensive tasks, this
might not be the case.  The cgroup problem was closer to that second
scenario, where few threads split all available memory between them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
