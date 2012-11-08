Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8LbZ5F024565 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 15:37:35 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZNh0LBqqihI0t8Gf for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 13:39:32 -0800 (PST)
Date: Fri, 9 Nov 2012 08:39:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: better perf and memory uage for xfs_fsr? Trivial patch against
	xfstools-3.16 included...
Message-ID: <20121108213911.GS6434@dastard>
References: <509BAABF.3030608@tlinx.org>
 <509C1653.7050906@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <509C1653.7050906@tlinx.org>
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Nov 08, 2012 at 12:30:11PM -0800, Linda Walsh wrote:
> FWIW, the benefit, probably comes from the read-file, as the written file
> is written with DIRECT I/O and I can't see that it should make a difference
> there.

Hmmm, so it does. I think that's probably the bug that needs to be
fixed, not so much using posix_fadvise....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
