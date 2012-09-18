Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8I6eDx1019855 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 01:40:13 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GZA7SDVuMCx2T7u1 for <xfs@oss.sgi.com>;
	Mon, 17 Sep 2012 23:41:23 -0700 (PDT)
Date: Tue, 18 Sep 2012 16:40:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
Message-ID: <20120918064039.GS11511@dastard>
References: <nsxa9wojdcd.fsf@closure.thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <nsxa9wojdcd.fsf@closure.thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Mon, Sep 17, 2012 at 10:04:34PM -0400, Theodore Ts'o wrote:
> 
> Does anyone have test cases for SEEK_HOLE/SEEK_DATA handy?  As near as I
> can tell xfstests doesn't have any tests for SEEK_HOLE/SEEK_DATA
> functionality, and I was hoping someone had some test programs and test
> sets already written.

Perhaps a cc to xfs@oss.sgi.com so the xfstests maintainers see the
question would be a sensible idea?

As it is, there are tests pending check-in that test
seek-data/seek-hole functionality - they were used to verify the
unwritten extent aware XFS implementation that recently went into
the kernel....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
