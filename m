Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IFt7gw120831 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 10:55:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50532CE0D48
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 09:04:56 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	aGGIdoe2ob6qSjop for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 09:04:56 -0700 (PDT)
Date: Thu, 19 Aug 2010 01:55:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel bug in xfs_lrw.c (centos v5.5, directio, aio)
Message-ID: <20100818155533.GM7362@dastard>
References: <alpine.LNX.2.00.1008171906220.21398@mahi.cmie.ernet.in>
	<20100818114305.GR10429@dastard>
	<alpine.LNX.2.00.1008181715380.12207@sangam.cmie.ernet.in>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1008181715380.12207@sangam.cmie.ernet.in>
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

On Wed, Aug 18, 2010 at 08:21:31PM +0530, Nohez wrote:
> 
> Thank you for your reply.
> 
> I checked the archives and found a bug report. The function names in
> the call trace report are different from the ones I have reported.
> 
> Since it's an application bug, it does not matter which filesystem
> is being used. Can I assume that the data corruption can happen on
> ext3 too?

It depends on the way the filesystem handles parallelism when doing
direct IO. In general, though, you cannot rely on the filesystem
maintaining data coherence if you mix concurrent buffered/mmap IO
and direct IO to the same file. Filesystems do make efforts to
minimise the possibility of coherency problems, but they cannot be
prevented entirely. Hence the delegation of responsibility to the
application issuing the direct IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
