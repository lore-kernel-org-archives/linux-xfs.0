Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7LGXfm0098757 for <xfs@oss.sgi.com>; Tue, 21 Aug 2012 11:33:42 -0500
Date: Tue, 21 Aug 2012 11:33:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20120821163337.GC29979@sgi.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<5032ABBD.80504@sgi.com> <20120820224306.GF19235@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120820224306.GF19235@dastard>
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

Hey Dave,

On Tue, Aug 21, 2012 at 08:43:06AM +1000, Dave Chinner wrote:
> On Mon, Aug 20, 2012 at 04:27:25PM -0500, Mark Tinguely wrote:
> > On 07/26/12 04:27, Dave Chinner wrote:
> > >Alt-Subject: Games with Sed, Grep and Awk.
> > >
> > >This series is based on top of the large filesystem test series.
> > >
> > >This moves all the tests into a ./tests subdirectory, and sorts them into
> > >classes of related tests. Those are:
> > >
> > >	tests/generic:	valid for all filesystems
> > >	tests/shared:	valid for a limited number of filesystems
> > >	tests/xfs:	xfs specific tests
> > >	tests/btrfs	btrfs specific tests
> > >	tests/ext4	ext4 specific tests
> > >	tests/udf	udf specific tests
> > 
> > The SGI XFS group talked about your proposed changes to xfstests and
> > the response is very positive.
> > 
> > The couple concerns are:
> > 
> > 1) There is a consensus in the group that the benchmark framework
> >    should remain until there is a common benchmark available.
> > 
> >    Could the benchmark infrastructure be placed into its own directory
> >    until a new common benchmark framework has been adopted?
> 
> Keeping it just complicates things. The benchmark infrastructure
> is bitrotted and was largely just a hack tacked on to the side of
> the regression test suite.
> 
> For it to be useful in an automated test environment, it would need
> to be re-implemented from scratch with reliable recording of results
> and the ability to determine if a result is unusual or not. None of
> this exists - it's just a framework to run a couple of benchmarks
> and dump some output to stdout using the xfstests machine config
> files....
> 
> I have tried integrating other benchmarks into xfstests a while back
> (e.g. compile bench, fsmark, etc) and using the results for some
> kind of meaningful performance regression test. I rapidly came to
> the conclusion that the infrastructure was not up to scratch and
> that my simple handwritten standalone test scripts to iterate
> through benchmarks and capture results was much easier to use and
> modify than to jump through the weird bench infrastructure hoops.
> 
> So, no, I don't think it's worth keeping at all.

You've already made it clear that you feel the current bench implementation is
not worth keeping.  Once a suitable replacement for the bench infrastructure
has been implemented we can remove the old one.  Until then we prefer to keep
what we have in the tree.

> > 2) Could there be a single result directory rather than mirroring the
> >    test hierarchy? A single directory can eventually become uniquely
> >    identified and also be easier to upload to a result depository.
> 
> One of the features requested for splitting up the test
> directories is to allow duplicate test names in different test
> directories. You can't have a single result directory if you allow
> duplicate test names....

Being able to have duplicate test names in different directories makes perfect
sense.

An additional idea that we kicked around is to (optionally) do a
results/<timestamp-hostname> style results directory on a per-run basis.  This
would enable us to keep all of the results history and maybe upload the results
to a central location.

Great patch set.  I've verified that we're good with removing the hangcheck and
tests remaining bits.  The only sticking point is bench which we'd like to
keep.  Looks great.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
