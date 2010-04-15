Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3F9Lpi0153356 for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 04:21:52 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 234D01D424A8
	for <xfs@oss.sgi.com>; Thu, 15 Apr 2010 02:23:45 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	TkrePk21xgk3rFB9 for <xfs@oss.sgi.com>;
	Thu, 15 Apr 2010 02:23:45 -0700 (PDT)
Date: Thu, 15 Apr 2010 19:23:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
Message-ID: <20100415092330.GU2493@dastard>
References: <20100408025822.GL11036@dastard>
	<11b701cad9c8$93212530$0400a8c0@dcccs>
	<20100412001158.GA2493@dastard>
	<18b101cadadf$5edbb660$0400a8c0@dcccs>
	<20100413083931.GW2493@dastard>
	<190201cadaeb$02ec22c0$0400a8c0@dcccs>
	<20100413113445.GZ2493@dastard>
	<1cd501cadb62$3a93e790$0400a8c0@dcccs>
	<20100414001615.GC2493@dastard>
	<233401cadc69$64c1f4f0$0400a8c0@dcccs>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <233401cadc69$64c1f4f0$0400a8c0@dcccs>
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
To: Janos Haar <janos.haar@netcenter.hu>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, xiyou.wangcong@gmail.com, kamezawa.hiroyu@jp.fujitsu.com

On Thu, Apr 15, 2010 at 09:00:49AM +0200, Janos Haar wrote:
> Dave,
> 
> The corruption + crash reproduced. (unfortunately)
> 
> http://download.netcenter.hu/bughunt/20100413/messages-15
> 
> Apr 14 01:06:33 alfa kernel: XFS mounting filesystem sdb2
> 
> This was the point of the xfs_repair more times.

OK, the inodes that are corrupted are different, so there's still
something funky going on here. I still would suggest replacing the
RAID controller to rule that out as the cause.

FWIW, do you have any other servers with similar h/w, s/w and
workloads? If so, are they seeing problems?

Can you recompile the kernel with CONFIG_XFS_DEBUG enabled and
reboot into it before you repair and remount the filesystem again?
(i.e. so that we know that we have started with a clean filesystem
and the debug kernel) I'm hoping that this will catch the corruption
much sooner, perhaps before it gets to disk. Note that this will
cause the machine to panic when corruption is detected, and it is
much,much more careful about checking in memory structures so there
is a CPU overhead involved as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
