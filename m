Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB9A27CA1
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 06:32:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CF98304048
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 04:31:59 -0700 (PDT)
Received: from mail-wm0-f67.google.com (mail-wm0-f67.google.com
	[74.125.82.67]) by cuda.sgi.com with ESMTP id miDtYIUTCKKKDwBt
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 18 May 2016 04:31:57 -0700 (PDT)
Received: by mail-wm0-f67.google.com with SMTP id n129so12118155wmn.1
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 04:31:57 -0700 (PDT)
Date: Wed, 18 May 2016 13:31:55 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: Xfs lockdep warning with for-dave-for-4.6 branch
Message-ID: <20160518113155.GG21654@dhcp22.suse.cz>
References: <20160513160341.GW20141@dhcp22.suse.cz>
	<20160516104130.GK3193@twins.programming.kicks-ass.net>
	<20160516130519.GJ23146@dhcp22.suse.cz>
	<20160516132541.GP3193@twins.programming.kicks-ass.net>
	<20160516231056.GE18496@dastard>
	<20160517144912.GZ3193@twins.programming.kicks-ass.net>
	<20160517223549.GV26977@dastard>
	<20160518072005.GA3193@twins.programming.kicks-ass.net>
	<20160518082538.GE21654@dhcp22.suse.cz>
	<20160518094952.GB3193@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160518094952.GB3193@twins.programming.kicks-ass.net>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com, linux-mm@kvack.org, Ingo Molnar <mingo@kernel.org>

On Wed 18-05-16 11:49:52, Peter Zijlstra wrote:
> On Wed, May 18, 2016 at 10:25:39AM +0200, Michal Hocko wrote:
> > On Wed 18-05-16 09:20:05, Peter Zijlstra wrote:
> > > On Wed, May 18, 2016 at 08:35:49AM +1000, Dave Chinner wrote:
> > > > On Tue, May 17, 2016 at 04:49:12PM +0200, Peter Zijlstra wrote:
> > [...]
> > > > > In any case; would something like this work for you? Its entirely
> > > > > untested, but the idea is to mark an entire class to skip reclaim
> > > > > validation, instead of marking individual sites.
> > > > 
> > > > Probably would, but it seems like swatting a fly with runaway
> > > > train. I'd much prefer a per-site annotation (e.g. as a GFP_ flag)
> > > > so that we don't turn off something that will tell us we've made a
> > > > mistake while developing new code...
> > > 
> > > Fair enough; if the mm folks don't object to 'wasting' a GFP flag on
> > > this the below ought to do I think.
> > 
> > GFP flag space is quite scarse. 
> 
> There's still 5 or so bits available, and you could always make gfp_t
> u64.

It seems we have some places where we encode further data into the same
word as gfp_mask (radix tree tags and mapping_flags). From a quick
glance they should be OK even with __GFP_BITS_SHIFT increased to 27 but
this tells us that we shouldn't consume them without a good reason.
 
> > Especially when it would be used only
> > for lockdep configurations which are mostly disabled. Why cannot we go
> > with an explicit disable/enable API I have proposed? 
> 
> It has unbounded scope. And in that respect the GFP flag thingy is wider
> than I'd like too, it avoids setting the state for all held locks, even
> though we'd only like to avoid setting it for one class.
>
> So ideally we'd combine the GFP flag with the previously proposed skip
> flag to only avoid marking the one class while keeping everything
> working for all other held locks.

This is definitely your call but I would prefer starting with something
simple and extend it when we find out that the scope/gfp opt-out hides
real bugs or it is insufficient for other reasons. I do not this opt out
to be used much, quite contrary. We do not hear about false positives
reclaim lockdep lockups very often - except for very complex reclaim
implementations which are quite uncommon.

Thanks!
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
