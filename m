Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7MJFxl1038785 for <xfs@oss.sgi.com>; Wed, 22 Aug 2012 14:15:59 -0500
Date: Wed, 22 Aug 2012 14:16:42 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20120822191642.GF29979@sgi.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<5032ABBD.80504@sgi.com> <20120820224306.GF19235@dastard>
	<20120821163337.GC29979@sgi.com> <20120821220926.GP19235@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120821220926.GP19235@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

Dave,

On Wed, Aug 22, 2012 at 08:09:26AM +1000, Dave Chinner wrote:
> On Tue, Aug 21, 2012 at 11:33:37AM -0500, Ben Myers wrote:
> > On Tue, Aug 21, 2012 at 08:43:06AM +1000, Dave Chinner wrote:
> > > On Mon, Aug 20, 2012 at 04:27:25PM -0500, Mark Tinguely wrote:
> > > > On 07/26/12 04:27, Dave Chinner wrote:
> > > > >Alt-Subject: Games with Sed, Grep and Awk.
> > > > >
> > > > >This series is based on top of the large filesystem test series.
> > > > >
> > > > >This moves all the tests into a ./tests subdirectory, and sorts them into
> > > > >classes of related tests. Those are:
> > > > >
> > > > >	tests/generic:	valid for all filesystems
> > > > >	tests/shared:	valid for a limited number of filesystems
> > > > >	tests/xfs:	xfs specific tests
> > > > >	tests/btrfs	btrfs specific tests
> > > > >	tests/ext4	ext4 specific tests
> > > > >	tests/udf	udf specific tests
> > > > 
> > > > The SGI XFS group talked about your proposed changes to xfstests and
> > > > the response is very positive.
> > > > 
> > > > The couple concerns are:
> > > > 
> > > > 1) There is a consensus in the group that the benchmark framework
> > > >    should remain until there is a common benchmark available.
> > > > 
> > > >    Could the benchmark infrastructure be placed into its own directory
> > > >    until a new common benchmark framework has been adopted?
> > > 
> > > Keeping it just complicates things. The benchmark infrastructure
> > > is bitrotted and was largely just a hack tacked on to the side of
> > > the regression test suite.
> > > 
> > > For it to be useful in an automated test environment, it would need
> > > to be re-implemented from scratch with reliable recording of results
> > > and the ability to determine if a result is unusual or not. None of
> > > this exists - it's just a framework to run a couple of benchmarks
> > > and dump some output to stdout using the xfstests machine config
> > > files....
> > > 
> > > I have tried integrating other benchmarks into xfstests a while back
> > > (e.g. compile bench, fsmark, etc) and using the results for some
> > > kind of meaningful performance regression test. I rapidly came to
> > > the conclusion that the infrastructure was not up to scratch and
> > > that my simple handwritten standalone test scripts to iterate
> > > through benchmarks and capture results was much easier to use and
> > > modify than to jump through the weird bench infrastructure hoops.
> > > 
> > > So, no, I don't think it's worth keeping at all.
> > 
> > You've already made it clear that you feel the current bench implementation is
> > not worth keeping.  Once a suitable replacement for the bench infrastructure
> > has been implemented we can remove the old one.  Until then we prefer to keep
> > what we have in the tree.
> 
> That's not how the process works 

That is exactly how the process works.  You posted an RFC and Mark and the XFS
team at SGI walked through your patch set.  Mark subsequently posted the
commentary in reply to your RFC.  Cruft or not, the removal of a feature goes
through the same review process as everything else.  In this case, SGI would
like to keep the benchmark capability in xfstests in order have a better chance
of catching performance regressions.

> - if it's cruft that no-one is
> using that gets in the way of progress, it goes.  It's still in the
> revision history so it's not like it is lost forever. If you have an
> actual reason for keeping it other than "there isn't a replacement",
> then tells us what that reason is.
> 
> i.e. are you trying to tell us that SGI uses it internally without
> actually saying so? If so, why not just say that straight up? If
> not, then why is removing an unused hack a problem?
> 
> As it is, I've been removing hacky functionality and then
> re-implementing it in a sane manner after everything has been moved
> about if it is still useful (e.g. expunged tests). The bench stuff
> is no different - I just don't see it as a useful addition to
> xfstests, so I haven't readded it.
> 
> Hence, if you really want to keep the bench functionality as viable,
> long term supported fucntionality, then send me patches that
> re-implement it cleanly on top of the patchset I posted. There's
> nothing stopping you from helping with this re-org of xfstests by
> contributing patches to provide the functionality you'd like to
> have....

Your point is well taken here.  SGI would like to keep the bench functionality
and we're prepared to spend time on keeping it viable.  Phil White has agreed
to take point on that effort.  The current thinking is to move the benchmark
code out of the way into a subdirectory first, and then set about improving (or
replacing) it.

> > > > 2) Could there be a single result directory rather than mirroring the
> > > >    test hierarchy? A single directory can eventually become uniquely
> > > >    identified and also be easier to upload to a result depository.
> > > 
> > > One of the features requested for splitting up the test
> > > directories is to allow duplicate test names in different test
> > > directories. You can't have a single result directory if you allow
> > > duplicate test names....
> > 
> > Being able to have duplicate test names in different directories makes perfect
> > sense.
> > 
> > An additional idea that we kicked around is to (optionally) do a
> > results/<timestamp-hostname> style results directory on a per-run basis.  This
> > would enable us to keep all of the results history and maybe upload the results
> > to a central location.
> 
> That's the reason the results directory can be supplied as an
> environment variable - so an external controlling script (like an
> automated QA harness) can direct the results to somewhere that it
> controls and archives. External results directories don't completely
> work in the patchset I posted - I have more patches that get
> closer to supporting that goal....

Nice.  A repo of results history is an excellent goal.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
