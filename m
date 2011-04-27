Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3R2W6u5192411 for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 21:32:08 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C50621332A5F
	for <xfs@oss.sgi.com>; Tue, 26 Apr 2011 19:35:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	M0FdLlwMGIPPWZGR for <xfs@oss.sgi.com>;
	Tue, 26 Apr 2011 19:35:38 -0700 (PDT)
Date: Wed, 27 Apr 2011 12:35:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs performance problem
Message-ID: <20110427023534.GF12436@dastard>
References: <4DB72084.8020205@inf.ethz.ch>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DB72084.8020205@inf.ethz.ch>
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
To: Benjamin Schindler <bschindler@inf.ethz.ch>
Cc: xfs@oss.sgi.com

On Tue, Apr 26, 2011 at 09:44:04PM +0200, Benjamin Schindler wrote:
> Hi
> 
> Since upgrading to newer kernels I have serious problems with xfs
> performance on my root fs.
> It runs on a software raid 0 with 2 disks. On the same two disks, there
> are two more partitions running a software raid-1 with ext3. On the ext3
> system, I have no issue, so I assume the drives are fine.
> But on the xfs filesystem, extracting a linux kernel archive takes 5
> minutes or more, running ldconfig similarily long. The harddrives are
> sata-2.
> I'm running gentoo linux with kernel 2.6.38-gentoo-r1. I'm attaching the
> kernel config but I guess more info is needed - just let me know what is
> needed.

more than likely your problem is that barriers have been enabled for
MD/DM devices on the new kernel, and they aren't on the old kernel.
XFS uses barriers by default, ext3 does not. Hence XFS performance
will change while ext3 will not. Check dmesg output when mounting
the filesystems on the different kernels.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
