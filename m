Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EE3skB085528 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 09:03:55 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D47C94DFD7F
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 07:03:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	gZNXEgBhOZF9iyrM for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2011 07:03:51 -0700 (PDT)
Date: Wed, 15 Jun 2011 00:03:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstest run result on 2.6.35.13 X86, 51 test cases failed
Message-ID: <20110614140348.GD32466@dastard>
References: <BANLkTinCvmt+=ZO9HwUWda1vkmLEqOfSwg@mail.gmail.com>
	<20110613141324.GC32466@dastard>
	<BANLkTi=3NPR=EG8bqjr+xzPtNRkpYnyqmA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTi=3NPR=EG8bqjr+xzPtNRkpYnyqmA@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 14, 2011 at 02:08:59PM +0530, Ajeet Yadav wrote:
> On Mon, Jun 13, 2011 at 7:43 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Jun 13, 2011 at 02:16:02PM +0530, Ajeet Yadav wrote:
> >> Dear All.
> >> I have installed the 2.6.35.13 long term valilla kernel release
> >> (www.kenrel.org) on my Intel core 2 duo PC, and run 11-05-2011 xfstest
> >> version, and run on it, below is the list of fails test cases.
> >> As far as I know community uses xfstest for QA, seeing so many fails,
> >> I am bit worried.
> >
> > It shouldn't fail very many tests at all...
> >
> >> Can anyone hepl me know that why so many fails, is I missed some
> >> config option ? or these test cases are not applicable ? or there is
> >> someting else
> >
> > Well, without telling us why the tests are failing (i.e. copy all
> > the output rather than just telling us some tests failed) we have no
> > idea what the failures you are seeing are. Without some indication
> > of what they failures are nobody can really comment on your
> > situation....
>
> I better to send the xfstest log as attachment becuase of it large size

Which means I can't easily quote sections of it.

It looks like you are running "check" without a group specification,
so it's just running all the tests, including known broken tests
(e.g. test 018). It looks like there are problems unmounting the
scratch device as a result, so lots of tests are subsequently
failing due to that.  You should be running either the "auto" or
"quick" group tests.

Aslo, seeing failures like this:

180      [failed, exit status 1] - output mismatch (see 180.out.bad)
--- 180.out     2011-05-11 22:32:24.000000000 +0530
+++ 180.out.bad 2011-06-09 18:18:39.666610999 +0530
@@ -1 +1,3 @@
 QA output created by 180
+common.config: Error: $SCRATCH_MNT (/home/manish/Projects/xfstests/sdb4) is not a directory
+./180: line 38: _cleanup_testdir: command not found

Makes me think you've got problems with your test setup that need
to be fixed before you go any further.

FWIW, your tests are running terribly slowly - e.g. it's taking 2795
seconds to run test 013 on a non-debug kernel. It takes 20s to run
in a VM on my laptop (and it's quite a slow laptop) so I really
suspect you may have some deeper problem of which the xfstests
failures are just a symptom of....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
