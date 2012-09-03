Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q835UIT4147304 for <xfs@oss.sgi.com>; Mon, 3 Sep 2012 00:30:18 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WDjOU2lEMsl0YJu9 for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 22:31:14 -0700 (PDT)
Date: Mon, 3 Sep 2012 15:31:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfstests: Use libtool to install lstat64
Message-ID: <20120903053111.GU15292@dastard>
References: <20120828172605.607853317@sgi.com>
	<20120828172928.785762590@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120828172928.785762590@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 28, 2012 at 12:26:06PM -0500, Rich Johnston wrote:
> Use libtool to install lstat64 on $SCRATCH_MNT instead of cp.  Libtool will
> install the binary from the proper location and display a warning if any
> shared library dependancies are not properly installed.  This ensures that a
> libtool wrapper shell script is not installed in place of lstat64 when libtool
> wrappers are being used. 

This patch is unnecessary if the configure script does the right
thing and refuse to build is library dependencies are not correct.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
