Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IBghbS111012 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 06:42:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE1DD15D525C
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 04:52:31 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	ZbXeZG19U2xI0HYQ for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 04:52:31 -0700 (PDT)
Date: Wed, 18 Aug 2010 21:43:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel bug in xfs_lrw.c (centos v5.5, directio, aio)
Message-ID: <20100818114305.GR10429@dastard>
References: <alpine.LNX.2.00.1008171906220.21398@mahi.cmie.ernet.in>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1008171906220.21398@mahi.cmie.ernet.in>
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
To: Nohez <nohez@cmie.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 17, 2010 at 07:12:12PM +0530, Nohez wrote:
> 
> Hi,
> 
> I had a kernel bug today when running xfs on CentOS v5.5. I moved to
> xfs from ext3 today.
> 
> The only application accessing the xfs filesystem is Sybase ASE v15.x.
> Database has been configured to use directio with native kernel
> asynchronous disk i/o enabled.

The warning is being issued because the application is mixing
buffered IO with direct IO on the same file. i.e. data corruption
waiting to happen. This is an application bug - the responsibility
for ensuring data coherency and integrity is assumed by the
application issuing the direct IO.

This was discussed in more detail on a recent thread on this list -
you shoul dbe able to find it in the archives easily enough.

> Let me know if there is any other information I can provide to help
> with debugging.

Report it to the application vendor - it's an application bug, not
a filesystem bug.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
