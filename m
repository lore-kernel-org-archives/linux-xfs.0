Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6KARRB085889 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 14:10:27 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BEssRC9HsOHTOO4h for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 12:12:23 -0800 (PST)
Date: Wed, 7 Nov 2012 07:12:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfstests: Revert commit edd6bc "optionally run all tests
	under quota"
Message-ID: <20121106201210.GB24575@dastard>
References: <20121105150133.857716755@sgi.com>
	<20121105150150.558785273@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121105150150.558785273@sgi.com>
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
To: rjohnston@sgi.com
Cc: xfs@oss.sgi.com

On Mon, Nov 05, 2012 at 09:01:34AM -0600, rjohnston@sgi.com wrote:
> Revert commit edd6bc which causes the following tests to fail:
> 
> 142.out.bad:Can't initialize the DMAPI
> 143.out.bad:Can't initialize the DMAPI
> 144.out.bad:Can't initialize the DMAPI
> 145.out.bad:Can't initialize the DMAPI
> 146.out.bad:Can't initialize the DMAPI
> 147.out.bad:Can't initialize the DMAPI
> 150.out.bad:Can't initialize the DMAPI
> 155.out.bad:Can't initialize the DMAPI
> 156.out.bad:Can't initialize the DMAPI
> 157.out.bad:Can't initialize the DMAPI
> 158.out.bad:Can't initialize the DMAPI
> 161.out.bad:Can't initialize the DMAPI
> 168.out.bad:Can't initialize the DMAPI
> 175.out.bad:Can't initialize the DMAPI
> 176.out.bad:Can't initialize the DMAPI
> 185.out.bad:Can't initialize the DMAPI
> 
> Signed-off-by: Rich Johnston <rjohnston@sgi.com>

Looks fine, but please use 'git revert edd6bcf' to revert the patch
and put this error message in it rather than applying a quilt patch
to do the revert.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
