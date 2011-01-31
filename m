Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0VMn8fg131743 for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 16:49:08 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E40F2A0F46
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 14:51:34 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XyAHHY7BWLbW79In for <xfs@oss.sgi.com>;
	Mon, 31 Jan 2011 14:51:34 -0800 (PST)
Date: Tue, 1 Feb 2011 09:51:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Possible memory corruption in xfs_buf_iomove()
Message-ID: <20110131225131.GK11040@dastard>
References: <86FBE6A1-CDCD-4FA3-B389-8D8C75A67CAB@mac.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86FBE6A1-CDCD-4FA3-B389-8D8C75A67CAB@mac.com>
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
To: Dale Stephenson <dalestephenson@mac.com>
Cc: xfs@oss.sgi.com

On Mon, Jan 31, 2011 at 04:29:16PM -0500, Dale Stephenson wrote:
> At Snap Appliance, we were running into appeared to be random oops
> when setting/reading large attributes.  Trevor Heathorn was able to
> trace the problem down to the function xfs_buf_iomove() in
> linux-2.6-xfs/xfs_buf.c.  The size of the copy within the loop is
> calculated as a minimum of the page size and bp->b_count_desired,
> minus the applicable offsets.  This can result in a copy size
> greater than the remaining size of the data length, which in the
> case of a read caused whatever else is in the buffer to be written
> past the end of the data area we had allocated.  He found that this
> fix prevented the oops:

Good catch! Do you have a test case that reproduced the problem? If
so, can you post that, too, so we can push it into xfstests as a
regression test?

[ As an aside, if you've got other regression tests that you'd like
to have run regularly during mainline developement and can be
integrated into xfstests, we can help make that happen. ]

> --- xfs_buf.c	17 Sep 2009 00:19:49 -0000	1.4
> +++ xfs_buf.c	31 Jan 2011 20:22:59 -0000	1.5
> @@ -1313,6 +1313,7 @@
>  			      PAGE_CACHE_SIZE-cpoff, bp->b_count_desired-boff);
> 
>  		ASSERT(((csize + cpoff) <= PAGE_CACHE_SIZE));
> +		csize = min(csize, (bend - boff));
> 
>  		switch (mode) {
>  		case XBRW_ZERO:

Yup, definitely needed. Can you add a Signed-off-by tag to this with
an appropriate commit message (pretty much what you've already
included with this report), we can get this fix into mainline
quickly.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
