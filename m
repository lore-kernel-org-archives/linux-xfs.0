Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAA417CBB
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 17:24:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A874304048
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 15:24:39 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	tYDrslkGbyCzjG3z for <xfs@oss.sgi.com>;
	Mon, 14 Mar 2016 15:24:36 -0700 (PDT)
Date: Tue, 15 Mar 2016 09:24:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFSTESTS v4 0/4] Richacl tests
Message-ID: <20160314222433.GC11812@dastard>
References: <1457525199-15355-1-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457525199-15355-1-git-send-email-agruenba@redhat.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

On Wed, Mar 09, 2016 at 01:06:34PM +0100, Andreas Gruenbacher wrote:
> Hello,
> 
> here is a new version of the richacl tests.

xfstests patches need to be sent to fstests@vger.kernel.org (added
to CC list), not xfs@oss.sgi.com.

> According to feedback from the
> previous posting (http://oss.sgi.com/archives/xfs/2015-12/msg00316.html), each
> of the richacl tests is not run separately, on a new scratch filesystem.

Oh, my. So, you've taken this one comment:

	"The rule of thumb is that there should be one xfs test per
	individual regression test. You've got at least 10 separate
	regression tests there, so there should be at least 10
	xfstests.  They should not be aggregated into a single test
	- if you need to run them all at once, then that is what the
	richacl test group is for..."

And then *implemented your own execution infrastructure* so that the
tests are /listed/ as separate tests in a group file but you still
/run them/ as one test?

I'm almost lost for words.

It seems to me that you've ignored all the comments Eric and I have
made to you about properly integrating the tests into xfstests so
that they are able to be maintained by anyone who works with
xfstests. Instead, you've kept most of the wacky stuff and instead
made the richacl tests even more of a special snowflake than they
were before.

This is not rocket science, Andreas. Both Eric and I have spelt out
exactly how to convert the richacl test scripts to use xfstests
scripts and infrastructure (e.g.
http://oss.sgi.com/archives/xfs/2015-11/msg00506.html), but you seem
to be willfully ignoring the feedback you are being given. i.e.

	- the separation of tests between richacl/<test> and
	  tests/<fs>/<test number> is wrong. Implement the
	  tests directly inside tests/<fs>/<test number>, using
	  xfstests infrastructure, please.

	- still not using .out files and instead are using your own
	  internal frankenstein output matching to determine success
	  or failure. Use the xfstests infrastructure for golden
	  output matching, please.

	- now has weird-ass richacl test execution from generic/338
	  and execute the tests correctly from the test harness
	  itself. Again, use the xfstests infrastructure correctly
	  rather than reinventing your own, please.

Most of this is as simple as copying the execution parts of your
scripts to the xfstests test scripts, and the output parts of the
test scripts into the test.out file. There's no new infrastructure
needed for running tests, no separate richacl/ script directory,
etc.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
