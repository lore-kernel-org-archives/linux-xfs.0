Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 07D177CA1
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 04:50:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AE6BA304048
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 02:50:08 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id COQCUbBc5rYtSdo0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 May 2016 02:49:57 -0700 (PDT)
Date: Wed, 18 May 2016 11:49:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160518094952.GB3193@twins.programming.kicks-ass.net>
References: <20160512080321.GA18496@dastard>
	<20160513160341.GW20141@dhcp22.suse.cz>
	<20160516104130.GK3193@twins.programming.kicks-ass.net>
	<20160516130519.GJ23146@dhcp22.suse.cz>
	<20160516132541.GP3193@twins.programming.kicks-ass.net>
	<20160516231056.GE18496@dastard>
	<20160517144912.GZ3193@twins.programming.kicks-ass.net>
	<20160517223549.GV26977@dastard>
	<20160518072005.GA3193@twins.programming.kicks-ass.net>
	<20160518082538.GE21654@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160518082538.GE21654@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, linux-mm@kvack.org, Ingo Molnar <mingo@kernel.org>

On Wed, May 18, 2016 at 10:25:39AM +0200, Michal Hocko wrote:
> On Wed 18-05-16 09:20:05, Peter Zijlstra wrote:
> > On Wed, May 18, 2016 at 08:35:49AM +1000, Dave Chinner wrote:
> > > On Tue, May 17, 2016 at 04:49:12PM +0200, Peter Zijlstra wrote:
> [...]
> > > > In any case; would something like this work for you? Its entirely
> > > > untested, but the idea is to mark an entire class to skip reclaim
> > > > validation, instead of marking individual sites.
> > > 
> > > Probably would, but it seems like swatting a fly with runaway
> > > train. I'd much prefer a per-site annotation (e.g. as a GFP_ flag)
> > > so that we don't turn off something that will tell us we've made a
> > > mistake while developing new code...
> > 
> > Fair enough; if the mm folks don't object to 'wasting' a GFP flag on
> > this the below ought to do I think.
> 
> GFP flag space is quite scarse. 

There's still 5 or so bits available, and you could always make gfp_t
u64.

> Especially when it would be used only
> for lockdep configurations which are mostly disabled. Why cannot we go
> with an explicit disable/enable API I have proposed? 

It has unbounded scope. And in that respect the GFP flag thingy is wider
than I'd like too, it avoids setting the state for all held locks, even
though we'd only like to avoid setting it for one class.

So ideally we'd combine the GFP flag with the previously proposed skip
flag to only avoid marking the one class while keeping everything
working for all other held locks.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
