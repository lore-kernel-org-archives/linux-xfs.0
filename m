Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5P09TMQ059476 for <xfs@oss.sgi.com>; Fri, 24 Jun 2011 19:09:30 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A61292D4CB
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2011 17:09:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	g1xUF15rBNNnxd4n for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2011 17:09:27 -0700 (PDT)
Date: Sat, 25 Jun 2011 10:09:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failure of test case : 250
Message-ID: <20110625000924.GB32466@dastard>
References: <BANLkTinCLAb3X59J=SnXgEkeRCLgB6FAGg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTinCLAb3X59J=SnXgEkeRCLgB6FAGg@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 24, 2011 at 11:49:45AM +0530, Amit Sahrawat wrote:
> Dear All,
> 
> Test Case : 250 results in failure on x86(2.6.31.y) and ARM(2.6.35.13..)

The XFS_WANT_CORRUPTED_GOTO bug wasn't fixed until 3.0-rc1 (bf59170
xfs: obey minleft values during extent allocation correctly), so of
course you'll get that failure on .31 and .35 kernels.

Amit, I'd suggest that you try to reproduce the problems you have on
a top of tree kernel first before reporting them. Most of us XFS
developers don't really have time to triage or solve failures on old
kernels like 2.6.31 or 2.6.35 and so are ignoring your bug reports.
Reporting bugs on old kernels that have since been fixed is really
just a waste of our (limited) time. If you find a bug that isn't
fixed on TOT, then we'll triage it and get it fixed in TOT.

However, if you can't reproduce them on top of tree, then you need
to go an find the commit (kernel, xfsprogs or xfstests) yourself
that makes the test pass and back port it to your tree. Same for if
we fix a bug you report in TOT - we're not going to backport the
fixes to your trees for you. We'll review backported patches if you
post them to the list, but we don't have time (or motivation) to do
the backports and QA them for you.

And if you are backporting to a long term stable tree, feel free to
submit the tested backports to stable@kernel.org (cc'ing the xfs
list so they can be reviewed, of course) so that everyone else can
also benefit from your work....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
