Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JLqvf2253941 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 16:52:57 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	eo2p3GZIKo8R9Gtk for <xfs@oss.sgi.com>;
	Wed, 19 Sep 2012 14:54:08 -0700 (PDT)
Date: Thu, 20 Sep 2012 07:54:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: restrict allocate worker to x86_64
Message-ID: <20120919215405.GE31501@dastard>
References: <20120919163133.097340199@sgi.com>
	<20120919163145.367256258@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120919163145.367256258@sgi.com>
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
To: tinguely@sgi.com
Cc: xfs@oss.sgi.com

On Wed, Sep 19, 2012 at 11:31:34AM -0500, tinguely@sgi.com wrote:
> Restrict the allocation worker to X86_64 machines. This will improve
> performance on non-X86-64 machines and avoid the AGF buffer hang.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

NACK.

The stack overflow problems that this works around are not limited
to x86-64. In the past we've seen overflows on i686 (even with 8k
stacks), s390 and other platforms, so it's not an isolated issue.

It either works or it doesn't - let's not start down the rathole of
having different code paths and behaviours for different platforms.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
