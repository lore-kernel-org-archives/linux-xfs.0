Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o363r6AK046586 for <xfs@oss.sgi.com>; Mon, 5 Apr 2010 22:53:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84AD629DA31
	for <xfs@oss.sgi.com>; Mon,  5 Apr 2010 20:54:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	OITxmVSMUV2lOov9 for <xfs@oss.sgi.com>;
	Mon, 05 Apr 2010 20:54:55 -0700 (PDT)
Date: Tue, 6 Apr 2010 13:54:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Assertion fail in xfs_reclaim_inode [2.6.33.2]
Message-ID: <20100406035452.GC11036@dastard>
References: <20100406004730.GB11263@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100406004730.GB11263@hostway.ca>
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
To: Simon Kirby <sim@hostway.ca>
Cc: xfs@oss.sgi.com

On Mon, Apr 05, 2010 at 05:47:30PM -0700, Simon Kirby wrote:
> We're seeing crashing from XFS likely resulting from some storage
> corruption.  This seems to be getting tickled from backups every two
> days as it happens at the same time of day each time on whichever box
> is active for these storage volumes.  We've seen it about 4 times now.
> 
> This was captured over a serial console over IPMI serial-over-LAN, and
> it seemed the serial console loglevel was not low enough to see the
> priority-less printk() in assfail() in fs/xfs/support/debug.c, so all we
> got this time was this backtrace:
.....
> 
> Seems to be from the only assert in xfs_reclaim_inode:
> 
>         ASSERT_ALWAYS(__xfs_iflags_test(ip, XFS_IRECLAIMABLE));
> 
> Would any of the patches in the stable queue-2.6.32 be missing from
> 2.6.33 but perhaps fix this issue?

Yes, there is - commit f1f724e4b523d444c5a598d74505aefa3d6844d2.
I've been a bit slack in doing the backport and push to 2.6.33.x.
I'll get the ball rolling later this afternoon....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
