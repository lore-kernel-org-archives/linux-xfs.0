Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KMhBea009937 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 17:43:12 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xZtIX8XhfH0AAZNN for <xfs@oss.sgi.com>;
	Mon, 20 Aug 2012 15:43:10 -0700 (PDT)
Date: Tue, 21 Aug 2012 08:43:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] [PATCH 0/18] xfstests: move tests out of top level
Message-ID: <20120820224306.GF19235@dastard>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<5032ABBD.80504@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5032ABBD.80504@sgi.com>
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
Cc: xfs@oss.sgi.com

On Mon, Aug 20, 2012 at 04:27:25PM -0500, Mark Tinguely wrote:
> On 07/26/12 04:27, Dave Chinner wrote:
> >Alt-Subject: Games with Sed, Grep and Awk.
> >
> >This series is based on top of the large filesystem test series.
> >
> >This moves all the tests into a ./tests subdirectory, and sorts them into
> >classes of related tests. Those are:
> >
> >	tests/generic:	valid for all filesystems
> >	tests/shared:	valid for a limited number of filesystems
> >	tests/xfs:	xfs specific tests
> >	tests/btrfs	btrfs specific tests
> >	tests/ext4	ext4 specific tests
> >	tests/udf	udf specific tests
> 
> The SGI XFS group talked about your proposed changes to xfstests and
> the response is very positive.
> 
> The couple concerns are:
> 
> 1) There is a consensus in the group that the benchmark framework
>    should remain until there is a common benchmark available.
> 
>    Could the benchmark infrastructure be placed into its own directory
>    until a new common benchmark framework has been adopted?

Keeping it just complicates things. The benchmark infrastructure
is bitrotted and was largely just a hack tacked on to the side of
the regression test suite.

For it to be useful in an automated test environment, it would need
to be re-implemented from scratch with reliable recording of results
and the ability to determine if a result is unusual or not. None of
this exists - it's just a framework to run a couple of benchmarks
and dump some output to stdout using the xfstests machine config
files....

I have tried integrating other benchmarks into xfstests a while back
(e.g. compile bench, fsmark, etc) and using the results for some
kind of meaningful performance regression test. I rapidly came to
the conclusion that the infrastructure was not up to scratch and
that my simple handwritten standalone test scripts to iterate
through benchmarks and capture results was much easier to use and
modify than to jump through the weird bench infrastructure hoops.

So, no, I don't think it's worth keeping at all.

> 2) Could there be a single result directory rather than mirroring the
>    test hierarchy? A single directory can eventually become uniquely
>    identified and also be easier to upload to a result depository.

One of the features requested for splitting up the test
directories is to allow duplicate test names in different test
directories. You can't have a single result directory if you allow
duplicate test names....

> Lastly, there are a couple minor link issues:
> 
> 1) In tests xfs/071, xfs/096 and generic/097 the links are missing the
>    $RESULT_DIR and the links are being made on the top directory. For
>    example in generic/097:
> 
> - rm -rf $seq.out
> + rm -rf $RESULT_DIR/$seq.out
> if [ "$FSTYP" == "xfs" ]; then
> -     ln -s $seq.out.xfs $seq.out
> +     ln -s $RESULT_DIR/$seq.out.xfs $RESULT_DIR/$seq.out
> else
> -     ln -s -$seq.out.udf $seq.out
> +     ln -s $RESULT_DIR/$seq.out.udf $RESULT_DIR/$seq.out
> fi

Yeah, I missed them because they don't use _link_out_file() and sed
is only as smart as it's user....

> 2) In patch 18, the old link needs to be removed in _link_out_file()
>    routine to prevent "File exists" errors on subsequent runs of the
>    scripts.

Sure. I fixed this about 5 minutes after I posted the series.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
