Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2L4UYtD047455 for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 23:30:35 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gZp427cqSfbdWpHJ for <xfs@oss.sgi.com>;
	Tue, 20 Mar 2012 21:30:33 -0700 (PDT)
Date: Wed, 21 Mar 2012 15:30:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: kernel: XFS (dm-7): xlog_space_left: head behind tail
Message-ID: <20120321043031.GW5091@dastard>
References: <CAJzjPKkUm-uWuGs2xPLF9yZ71uUV8QwPApjGAf6EKDoGqQYqBA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJzjPKkUm-uWuGs2xPLF9yZ71uUV8QwPApjGAf6EKDoGqQYqBA@mail.gmail.com>
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
To: Gregory Machin <gdm@linuxpro.co.za>
Cc: xfs@oss.sgi.com

On Wed, Mar 21, 2012 at 05:00:02PM +1300, Gregory Machin wrote:
> I have a CentOS 6.2 virtual machine in a vmware ESXi 4.0 host 4G Ram 4
> virtaul cpus and with about 4 TB of disk space formatted with XFS .
> I'm seeing a lot of :
> 
> Mar 21 10:49:42 nzhmlfpr05 kernel: XFS (dm-4): xlog_space_left: head behind tail
> Mar 21 10:49:42 nzhmlfpr05 kernel:  tail_cycle = 129, tail_bytes = 20163072
> Mar 21 10:49:42 nzhmlfpr05 kernel:  GH   cycle = 129, GH   bytes = 20162880
> Mar 21 10:49:42 nzhmlfpr05 kernel: XFS (dm-7): xlog_space_left: head behind tail
> Mar 21 10:49:42 nzhmlfpr05 kernel:  tail_cycle = 5, tail_bytes = 333417984
> Mar 21 10:49:42 nzhmlfpr05 kernel:  GH   cycle = 5, GH   bytes = 333417792
> Mar 21 10:49:42 nzhmlfpr05 kernel: XFS (dm-7): xlog_space_left: head behind tail
> Mar 21 10:49:42 nzhmlfpr05 kernel:  tail_cycle = 5, tail_bytes = 333417984
> Mar 21 10:49:42 nzhmlfpr05 kernel:  GH   cycle = 5, GH   bytes = 333417792

can you send the complete set of output, including the first
occurrence of it?

What workload are you running? Are you freezing you filesystem
frequently?

> What would casue this ? A quick google , I found a post that indicated
> I should unmount and mount the file systems. I have live production
> data on this machine so I need to be careful. What is the best
> solution ?

Best solution? I don't know enough about the problem yet to suggest
one.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
