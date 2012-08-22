Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7MNfcNG081238 for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 18:41:39 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	BEN5v5nVnuJo1zid for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 16:42:22 -0700 (PDT)
Date: Thu, 23 Aug 2012 09:42:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20120822234219.GR19235@dastard>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<5032ABBD.80504@sgi.com> <20120820224306.GF19235@dastard>
	<20120821163337.GC29979@sgi.com> <20120821220926.GP19235@dastard>
	<20120822191642.GF29979@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120822191642.GF29979@sgi.com>
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

On Wed, Aug 22, 2012 at 02:16:42PM -0500, Ben Myers wrote:
> Dave,
> 
> On Wed, Aug 22, 2012 at 08:09:26AM +1000, Dave Chinner wrote:
> > On Tue, Aug 21, 2012 at 11:33:37AM -0500, Ben Myers wrote:
> > > On Tue, Aug 21, 2012 at 08:43:06AM +1000, Dave Chinner wrote:
> > > > On Mon, Aug 20, 2012 at 04:27:25PM -0500, Mark Tinguely wrote:
> > > > > On 07/26/12 04:27, Dave Chinner wrote:
> > > > > >Alt-Subject: Games with Sed, Grep and Awk.
> > > > > >
> > > > > >This series is based on top of the large filesystem test series.
> > > > > >
> > > > > >This moves all the tests into a ./tests subdirectory, and sorts them into
> > > > > >classes of related tests. Those are:
> > > > > >
> > > > > >	tests/generic:	valid for all filesystems
> > > > > >	tests/shared:	valid for a limited number of filesystems
> > > > > >	tests/xfs:	xfs specific tests
> > > > > >	tests/btrfs	btrfs specific tests
> > > > > >	tests/ext4	ext4 specific tests
> > > > > >	tests/udf	udf specific tests
> > > > > 
> > > > > The SGI XFS group talked about your proposed changes to xfstests and
> > > > > the response is very positive.
> > > > > 
> > > > > The couple concerns are:
> > > > > 
> > > > > 1) There is a consensus in the group that the benchmark framework
> > > > >    should remain until there is a common benchmark available.
> > > > > 
> > > > >    Could the benchmark infrastructure be placed into its own directory
> > > > >    until a new common benchmark framework has been adopted?
> > > > 
> > > > Keeping it just complicates things. The benchmark infrastructure
> > > > is bitrotted and was largely just a hack tacked on to the side of
> > > > the regression test suite.
> > > > 
> > > > For it to be useful in an automated test environment, it would need
> > > > to be re-implemented from scratch with reliable recording of results
> > > > and the ability to determine if a result is unusual or not. None of
> > > > this exists - it's just a framework to run a couple of benchmarks
> > > > and dump some output to stdout using the xfstests machine config
> > > > files....
> > > > 
> > > > I have tried integrating other benchmarks into xfstests a while back
> > > > (e.g. compile bench, fsmark, etc) and using the results for some
> > > > kind of meaningful performance regression test. I rapidly came to
> > > > the conclusion that the infrastructure was not up to scratch and
> > > > that my simple handwritten standalone test scripts to iterate
> > > > through benchmarks and capture results was much easier to use and
> > > > modify than to jump through the weird bench infrastructure hoops.
> > > > 
> > > > So, no, I don't think it's worth keeping at all.
> > > 
> > > You've already made it clear that you feel the current bench implementation is
> > > not worth keeping.  Once a suitable replacement for the bench infrastructure
> > > has been implemented we can remove the old one.  Until then we prefer to keep
> > > what we have in the tree.
> > 
> > That's not how the process works 
> 
> That is exactly how the process works.  You posted an RFC and Mark and the XFS
> team at SGI walked through your patch set.  Mark subsequently posted the
> commentary in reply to your RFC.  Cruft or not, the removal of a feature goes
> through the same review process as everything else.

Sure, but you need to justify your arguments for keeping something
with evidence and logic - handwaving about wanting something is, and
always has been, insufficient justification. That's the part of the
process I'm talking about - that statements of need require
evidence, especially when you agreed to the removal at LSF in San
Fransisco a few months ago. My arguments at the time were:

	a) nobody is actually using it,
	b) it has effectively been unmaintained since 2003
	c) it has no regression analysis or detection capability
	d) it shares *very little* of xfstests
	e) it gets in the way of cleaning up xfstests
	f) there are far better workload generators that are being
	actively maintained.

And AFAIA, nothing has changed in the past few months.

> In this case, SGI would
> like to keep the benchmark capability in xfstests in order have a better chance
> of catching performance regressions.
....
> > i.e. are you trying to tell us that SGI uses it internally without
> > actually saying so? If so, why not just say that straight up? If
> > not, then why is removing an unused hack a problem?

You haven't answered the most important question I've asked (i.e.
provided any evidence that bench is valuable as it stands).
You've skirted around answering this question, so I'm left to read
between the lines and hearing this:

	a) We think that we might use bench in the future,
	b) but we don't really know if bench is useful or not,
	c) and we don't really know what something useful might look
	like, either,
	d) so just move it out of the way into a subdir for now

It's all just indecisive handwaving with a (IMO) silly conclusion
because you have no clear plan what you want to do for performance
regression testing, except for the thought that "bench might be
useful".

The thing is - all I've done is:

	d) so just move it out of the way

It's in a git repository - deleted files are not lost! They are
simply moved into revision history where they can still be accessed
at will. i.e. the file(s), all their contents and history are still
preserved, you just need to run a git command to get them back.

IMO, that's a far better solution that moving bitrotted code to
another directory and just leaving it in an even more bitrotted (and
now broken) state for people to trip over.

> > As it is, I've been removing hacky functionality and then
> > re-implementing it in a sane manner after everything has been moved
> > about if it is still useful (e.g. expunged tests). The bench stuff
> > is no different - I just don't see it as a useful addition to
> > xfstests, so I haven't readded it.
> > 
> > Hence, if you really want to keep the bench functionality as viable,
> > long term supported fucntionality, then send me patches that
> > re-implement it cleanly on top of the patchset I posted. There's
> > nothing stopping you from helping with this re-org of xfstests by
> > contributing patches to provide the functionality you'd like to
> > have....
> 
> Your point is well taken here.  SGI would like to keep the bench functionality
> and we're prepared to spend time on keeping it viable.  Phil White has agreed
> to take point on that effort.  The current thinking is to move the benchmark
> code out of the way into a subdirectory first, and then set about improving (or
> replacing) it.

OK, so moving it to revision history will be just fine until patches
are written some time in the future to make it work again in a
subdirectory.

But before anything major gets done with bench, there needs to be a
coherent development plan produced. What is it that you intend to do
with bench? You made no mention of this at LSF, so I'm completely in
the dark here about your intentions. If you are going to develop
bench into a performance regression suite, then we first need a
discussion (and document) cwonstating what it is and isn't going to
do, how regressions are going to be detected, how the results are
going to be stored for trend analysis and presentation, etc.

For example, the first feature on my list for any new performance
regression test suite is PCP integration. If you can't monitor the
system behaviour effectively during performance tests, then they are
effectively useless for analysing the root cause of regressions. A
lot of what I do is performance related, and modifcations live and
die by what such monitoring shows of the system behaviour.
Therefore, any new performance regression suite needs to generate
PCP archives of system and XFS level behaviour....

Then, once we have an idea of what is going to be done, the white
elephant can then be addressed: is xfstests the right place for this
functionality?

FWIW, this is the sort of reporting that a performance regression
test suite should produce:

http://lists.linux.hp.com/~enw/ext4/3.2/

Indeed, why start with bench when you can start with something far
more advanced....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
