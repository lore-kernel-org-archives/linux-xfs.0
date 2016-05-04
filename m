Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92F5F7CA0
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 19:09:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BAC1AC003
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 17:09:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	mWKR7UWlYQUOUHtx for <xfs@oss.sgi.com>;
	Tue, 03 May 2016 17:09:35 -0700 (PDT)
Date: Wed, 4 May 2016 10:07:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] mm, debug: report when GFP_NO{FS,IO} is used
	explicitly from memalloc_no{fs,io}_{save,restore} context
Message-ID: <20160504000703.GW26977@dastard>
References: <1461671772-1269-1-git-send-email-mhocko@kernel.org>
	<1461671772-1269-3-git-send-email-mhocko@kernel.org>
	<20160426225845.GF26977@dastard>
	<20160428081759.GA31489@dhcp22.suse.cz>
	<20160428215145.GM26977@dastard>
	<20160429121219.GL21977@dhcp22.suse.cz>
	<20160429234008.GN26977@dastard>
	<20160503153823.GB4470@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160503153823.GB4470@dhcp22.suse.cz>
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
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Tue, May 03, 2016 at 05:38:23PM +0200, Michal Hocko wrote:
> On Sat 30-04-16 09:40:08, Dave Chinner wrote:
> > On Fri, Apr 29, 2016 at 02:12:20PM +0200, Michal Hocko wrote:
> [...]
> > > - was it 
> > > "inconsistent {RECLAIM_FS-ON-[RW]} -> {IN-RECLAIM_FS-[WR]} usage"
> > > or a different class reports?
> > 
> > Typically that was involved, but it quite often there'd be a number
> > of locks and sometimes even interrupt stacks in an interaction
> > between 5 or 6 different processes. Lockdep covers all sorts of
> > stuff now (like fs freeze annotations as well as locks and memory
> > reclaim) so sometimes the only thing we can do is remove the
> > reclaim context from the stack and see if that makes it go away...
> 
> That is what I was thinking of. lockdep_reclaim_{disable,enable} or
> something like that to tell __lockdep_trace_alloc to not skip
> mark_held_locks(). This would effectivelly help to get rid of reclaim
> specific reports. It is hard to tell whether there would be others,
> though.

Yeah, though I suspect this would get messy having to scatter it
around the code. I can encapsulate it via internal XFS KM flags,
though, so I do think that will be a real issue.

> > > > They may have been fixed since, but I'm sceptical
> > > > of that because, generally speaking, developer testing only catches
> > > > the obvious lockdep issues. i.e. it's users that report all the
> > > > really twisty issues, and they are generally not reproducable except
> > > > under their production workloads...
> > > > 
> > > > IOWs, the absence of reports in your testing does not mean there
> > > > isn't a problem, and that is one of the biggest problems with
> > > > lockdep annotations - we have no way of ever knowing if they are
> > > > still necessary or not without exposing users to regressions and
> > > > potential deadlocks.....
> > > 
> > > I understand your points here but if we are sure that those lockdep
> > > reports are just false positives then we should rather provide an api to
> > > silence lockdep for those paths
> > 
> > I agree with this - please provide such infrastructure before we
> > need it...
> 
> Do you think a reclaim specific lockdep annotation would be sufficient?

It will help - it'll take some time to work through all the explicit
KM_NOFS calls in XFS, though, to determine if they are just working
around lockdep false positives or some other potential problem....

> I do understand your concerns and I really do not ask you to redesign
> your code. I would like make the code more maintainable and reducing the
> number of (undocumented) GFP_NOFS usage to the minimum seems to be like
> a first step. Now the direct usage of GFP_NOFS (resp. KM_NOFS) in xfs is
> not that large.

That's true, and if we can reduce them to real cases of GFP_NOFS
being needed vs annotations to silence lockdep false positives we'll
then know what problems we really need to fix...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
