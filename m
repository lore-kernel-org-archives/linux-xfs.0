Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7O46hSp154633 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 23:06:43 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oHyLJPXGkFknNAJL for <xfs@oss.sgi.com>;
	Thu, 23 Aug 2012 21:07:28 -0700 (PDT)
Date: Fri, 24 Aug 2012 14:07:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20120824040724.GA19235@dastard>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<5032ABBD.80504@sgi.com> <20120820224306.GF19235@dastard>
	<20120821163337.GC29979@sgi.com> <20120821220926.GP19235@dastard>
	<20120822191642.GF29979@sgi.com> <20120822234219.GR19235@dastard>
	<20120823170025.GG29979@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120823170025.GG29979@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Thu, Aug 23, 2012 at 12:00:25PM -0500, Ben Myers wrote:
> On Thu, Aug 23, 2012 at 09:42:19AM +1000, Dave Chinner wrote:
> > On Wed, Aug 22, 2012 at 02:16:42PM -0500, Ben Myers wrote:
> > > On Wed, Aug 22, 2012 at 08:09:26AM +1000, Dave Chinner wrote:
> > > > > > For it to be useful in an automated test environment, it would need
> > > > > > to be re-implemented from scratch with reliable recording of results
> > > > > > and the ability to determine if a result is unusual or not. None of
> > > > > > this exists - it's just a framework to run a couple of benchmarks
> > > > > > and dump some output to stdout using the xfstests machine config
> > > > > > files....
> > > > > > 
> > > > > > I have tried integrating other benchmarks into xfstests a while back
> > > > > > (e.g. compile bench, fsmark, etc) and using the results for some
> > > > > > kind of meaningful performance regression test. I rapidly came to
> > > > > > the conclusion that the infrastructure was not up to scratch and
> > > > > > that my simple handwritten standalone test scripts to iterate
> > > > > > through benchmarks and capture results was much easier to use and
> > > > > > modify than to jump through the weird bench infrastructure hoops.
> > > > > > 
> > > > > > So, no, I don't think it's worth keeping at all.
> > > > > 
> > > > > You've already made it clear that you feel the current bench implementation is
> > > > > not worth keeping.  Once a suitable replacement for the bench infrastructure
> > > > > has been implemented we can remove the old one.  Until then we prefer to keep
> > > > > what we have in the tree.
> > > > 
> > > > That's not how the process works 
> > > 
> > > That is exactly how the process works.  You posted an RFC and Mark and the XFS
> > > team at SGI walked through your patch set.  Mark subsequently posted the
> > > commentary in reply to your RFC.  Cruft or not, the removal of a feature goes
> > > through the same review process as everything else.
> > 
> > Sure, but you need to justify your arguments for keeping something
> > with evidence and logic - handwaving about wanting something is, and
> > always has been, insufficient justification. That's the part of the
> > process I'm talking about - that statements of need require
> > evidence, especially when you agreed to the removal at LSF in San
> > Fransisco a few months ago. My arguments at the time were:
> > 
> > 	a) nobody is actually using it,
> > 	b) it has effectively been unmaintained since 2003
> > 	c) it has no regression analysis or detection capability
> > 	d) it shares *very little* of xfstests
> > 	e) it gets in the way of cleaning up xfstests
> > 	f) there are far better workload generators that are being
> > 	actively maintained.
> > 
> > And AFAIA, nothing has changed in the past few months.
> 
> "In this case, SGI would like to keep the benchmark capability in xfstests in
> order have a better chance of catching performance regressions."  There has
> been a been performance regression in the past few months (and there will be
> more in the future), we have had performance regressions internally too, and
> this has brought the value of having benchmarks in xfstests into sharp focus.

I heard you the first time - it didn't answer the first questions I
asked, Repeating it doesn't answer the second set of questions,
either, which could be answered with "yes" or "no". That is: are you
using bench *right now* for perforamnce regression testing?

The information I'm after is whether removing it breaks your current
test environment. Given you are suggesting moving it out of the way
rather than removal, I think the answer is "no" but I'd like a yes
or no confirming that.

> > OK, so moving it to revision history will be just fine until patches
> > are written some time in the future to make it work again in a
> > subdirectory.
> > 
> > But before anything major gets done with bench, there needs to be a
> > coherent development plan produced.
> 
> Doesn't removing bench fall in to the category 'major'?

Not really, because it's all of 5 minutes work in a larger project.
But for the sake of argument, let's say that it is and so I need to
communicate and develop a plan....

> Did you develop a
> coherent development plan on how to replace it with something better?

Yes, I communicated and developed a plan, and got agreement on it,
too. The plan was to remove it as there are other benchmark/test
suites better suited to performance regression testing than
xfstests. We discussed this and a consensus was reached on this at
LSF. Everything in the patchset is in my notes from the LSF
discussion....

> > Then, once we have an idea of what is going to be done, the white
> > elephant can then be addressed: is xfstests the right place for this
> > functionality?
> 
> I think it is the perfect place.  xfstests already has a wide following with
> linux filesystems folks, so if we get bench cleaned up everyone will have
> access to the same suite automatically.  I'd really like the focus to stay on
> improving xfstests as opposed to some other suite, and I prefer not to be doing
> SGI internal-only test suites for benchmarking and testing where possible.

There's no reason why a new performance regression suite would have
to be SGI internal. If you want it to be part of xfstests so the
work is put into a public GPL project, then I think your motivation
for using/keeping bench is all wrong....

Anyway, let's leave it there. Gather requirements (e.g. put out a
request for discussion on linux-fsdevel), research existing tools
that can do the job, develop a plan, then we can discuss how best ot
proceed.

> > FWIW, this is the sort of reporting that a performance regression
> > test suite should produce:
> > 
> > http://lists.linux.hp.com/~enw/ext4/3.2/
> 
> Yeah, that's really nice.  Do you happen to know what tool created it?

IIRC, a relatively simple set of scripts around the outside of ffsb,
lockstat, oprofile and gnuplot. You should probably ask Eric if he
can share them...

> 
> > Indeed, why start with bench when you can start with something far
> > more advanced....
> 
> I understand that bench is bitrotted, but it still has some value even today.
> Phil has agreed to take this on as a project so the bitrot will be addressed.
> You have good points about needing a better plan in this area.  But we should
> come up with a plan before taking the major step of removing benchmarking from
> xfstests entirely.  That's not handwaving, it's good sense.  ;)
> 
> Lets stay focused on improving xfstests...

Yep, I'm trying to do that by removing peripheral, non-core
functionality. ;)

Really, it makes no difference to me whether I remove bench or move
it to a sub-directory in a broken state.  If you are really that set
on it being useful, I'll move it to another directory (say
"broken-bench-do-not-sit-down-here" :) and leave it in a
busted state. If it hasn't been fixed 6 months later, I'll post
patches to remove it again....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
