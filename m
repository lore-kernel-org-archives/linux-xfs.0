Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9H7MoSO038929 for <xfs@oss.sgi.com>; Wed, 17 Oct 2012 02:22:50 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	QiaWJjRFOG6aZpuc for <xfs@oss.sgi.com>;
	Wed, 17 Oct 2012 00:24:27 -0700 (PDT)
Date: Wed, 17 Oct 2012 18:24:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests: SEEK_HOLE/SEEK_DATA advanced tests
Message-ID: <20121017072424.GC26797@dastard>
References: <20121016204240.142425319@sgi.com>
	<20121016204244.997819918@sgi.com> <20121017023439.GB26797@dastard>
	<507E284D.40800@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <507E284D.40800@oracle.com>
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
To: Jie Liu <jeff.liu@oracle.com>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On Wed, Oct 17, 2012 at 11:38:53AM +0800, Jie Liu wrote:
> On 10/17/12 10:34, Dave Chinner wrote:
> > On Tue, Oct 16, 2012 at 03:42:41PM -0500, Mark Tinguely wrote:
> >> This is the test of the advanced SEEK_HOLE and SEEK_DATA features
> >> of the lseek() function call.
> >>
> >> Jie Liu <jeff.liu@oracle.com> wrote the C code, I converted it to
> >> a test with his permission.
> > Jie, can you sign-off on this patch as well as it has Oracle
> > copyright statements in it?
> Hi Dave,
> 
> I can sign-off this patch, but it's better to keep the copyright
> statements with SGI for this test script since
> it wrote by Mark, and Mark is already made the C test file as Oracle.

The .c file has this:

+ * Copyright (C) 2011-2012 Oracle. All rights reserved.

Which is why the patch needs your signoff.

But if the test is redone without the .c file (i.e. SEEK_HOLE/DATA
added to xfs_io) then it won't be necessary (unless you do that
work :).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
