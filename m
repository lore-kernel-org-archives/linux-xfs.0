Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7A4NSL208672 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 04:04:24 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bF1d4ttx4AiJ87Qg for <xfs@oss.sgi.com>;
	Fri, 07 Dec 2012 02:06:48 -0800 (PST)
Date: Fri, 7 Dec 2012 21:06:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [3.0-stable PATCH 00/36] Proposed 3.0-stable bug patches
Message-ID: <20121207100646.GJ27172@dastard>
References: <20121203144208.143464631@sgi.com> <20121205214505.GG29399@dastard>
	<50C0D57A.9000704@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50C0D57A.9000704@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Thu, Dec 06, 2012 at 11:27:22AM -0600, Mark Tinguely wrote:
> On 12/05/12 15:45, Dave Chinner wrote:
> >On Mon, Dec 03, 2012 at 05:42:08PM -0600, Mark Tinguely wrote:
> >>Here a collection of bug fixes for 3.0-stable. Many of these patches
> >>were also selected by Dave Chinner as possible 3.0-stable patches:
> >>	http://oss.sgi.com/archives/xfs/2012-08/msg00255.html
> >>
> >>I chose only bug fixes and kept the changes to a minimum.
> >>
> >>Patch 21/22 are required for the bug fix in patch 23 but they are
> >>important changes in their own right.
> >
> >So I'll ask the same question that Christoph asked me: If nobody is
> >reporting problems on 3.0.x, why do this and risk regression and
> >fallout that requires fixing?
> >
> >FWIW, what testing have you done?
> 
> Do you mean?
> 
> 	http://oss.sgi.com/archives/xfs/2012-09/msg00002.html
> 
> I read that message as a concern that your original Linux 3.0-stable
> patch series contained some items that did not meet the -stable
> criteria.

I read it as "why change something that no-one is reporting bugs
for?". I posted that series because I had to do the work for RHEL to
address customer reported problems, not because I felt like pushing
a bunch of fixes back to 3.0.

I've spent quite a bit of time over the past few weeks dealing with
various weird regressions as a result of that backport. If you're
going to backport a singificant amount of stuff to 3.0.x, then
that's what you are signing up for. i.e. doing all the bug triage
and fixing that will result from the backport...

> As for adding patches to 3.0-stable. I believed then and now that
> proactively suggesting bug fixes into 3.0-stable is a good thing
> because it is the long term stable branch.

Which is in direct contrast to what most of us think. That is, if
nobody is reporting problems, then it ain't broke and it doesn't
need fixing.

> A few days after Christoph's email, I put my "Reviewed-by:" on your
> series.
> 
> 	http://oss.sgi.com/archives/xfs/2012-09/msg00167.html
> 
> As for testing, the whole series is spun on xfstests loops for days on
> x86_32 and x86_64 boxes, just like we test a top of tree patch series.

Which we all know does not catch all possible regressions. What
about crash/shutdown testing? Or load/stress testing? 

/me is playing Devil's Advocate because I'm not signing up to
triage a whole new set of 3.0.x stable kernel regressions when
nobody is currently reporting problems.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
