Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6AB47F57
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 15:58:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3A47BAC002
	for <xfs@oss.sgi.com>; Thu, 16 Jan 2014 13:58:20 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jYhFWcxmWm7SbHRg for <xfs@oss.sgi.com>;
	Thu, 16 Jan 2014 13:58:15 -0800 (PST)
Date: Fri, 17 Jan 2014 08:58:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs: blocked for more than 120 seconds
Message-ID: <20140116215812.GS3431@dastard>
References: <CALNbWOb8+85bKhyKkJ0qHw9FqK8ogW+ePOcUouE=_MBRukRmng@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALNbWOb8+85bKhyKkJ0qHw9FqK8ogW+ePOcUouE=_MBRukRmng@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ivan Novick <inovick@gopivotal.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 16, 2014 at 11:51:52AM -0800, Ivan Novick wrote:
> Hello,
> 
> I am running a server with heavy workload on a XFS mount:
> /dev/mapper/v2-d1 on /d/d1 type xfs (rw,nodev,noatime,inode64,allocsize=16m)
> 2.6.32-424.el6.x86_64 #1 SMP Mon Oct 14 20:11:50 EDT 2013 x86_64 x86_64
> x86_64 GNU/Linux
> 
> We get errors in log indicating processes are blocked for more than 120
> seconds.
> 
> 1) Is this expected during heavy workload?
> 2) What would be the impact on the processes?  Are they basically hung in
> userspace waiting for IO?
> 3) Is there anything we tune here?
> 
> Below is the output.
> 
> Cheers,
> Ivan Novick
> 
> INFO: task flush-253:1:6882 blocked for more than 120 seconds.
>       Tainted: P           ---------------    2.6.32-424.el6.x86_64 #1

Proprietary kernel module taint on a RHEL/centos kernel, so there's
no guarantee anyone will be able to debug this here. If it's RHEL
you are using, please report it through your support channels...

> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> flush-253:1   D 0000000000000000     0  6882      2 0x00000000
>  ffff881011fa5690 0000000000000046 0000000000000000 ffff881013cba040
>  0000000000000001 ffff88012a447d40 ffff881013cba040 ffff881016eb4830
>  ffff881013cba5f8 ffff881011fa5fd8 000000000000fbc8 ffff881013cba5f8
> Call Trace:
>  [<ffffffff815289d3>] io_schedule+0x73/0xc0
>  [<ffffffff81267d18>] get_request_wait+0x108/0x1d0
>  [<ffffffff8109b4a0>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff812618ce>] ? elv_merge+0x17e/0x1c0
>  [<ffffffff81267e79>] blk_queue_bio+0x99/0x620
>  [<ffffffff81266f00>] generic_make_request+0x240/0x5a0

Waiting for IO completion. Looks like you've either severely
overloaded your storage subsystem, or it's died and isn't responding
anymore.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
