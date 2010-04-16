Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3G85OCi233657 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 03:05:24 -0500
Received: from mail.netcenter.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEE9B2C89C3
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 01:01:26 -0700 (PDT)
Received: from mail.netcenter.hu (ns.netcenter.hu [195.228.254.57]) by
	cuda.sgi.com with ESMTP id 3z2CmXMntFXelwEX for
	<xfs@oss.sgi.com>; Fri, 16 Apr 2010 01:01:26 -0700 (PDT)
Message-ID: <295901cadd3a$fbeb1650$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
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
	<20100415092330.GU2493@dastard>
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look
	please!...)
Date: Fri, 16 Apr 2010 10:01:10 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, xiyou.wangcong@gmail.com, kamezawa.hiroyu@jp.fujitsu.com


----- Original Message ----- 
From: "Dave Chinner" <david@fromorbit.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <xiyou.wangcong@gmail.com>; <linux-kernel@vger.kernel.org>; 
<kamezawa.hiroyu@jp.fujitsu.com>; <linux-mm@kvack.org>; <xfs@oss.sgi.com>; 
<axboe@kernel.dk>
Sent: Thursday, April 15, 2010 11:23 AM
Subject: Re: Kernel crash in xfs_iflush_cluster (was Somebody take a look 
please!...)


> On Thu, Apr 15, 2010 at 09:00:49AM +0200, Janos Haar wrote:
>> Dave,
>>
>> The corruption + crash reproduced. (unfortunately)
>>
>> http://download.netcenter.hu/bughunt/20100413/messages-15
>>
>> Apr 14 01:06:33 alfa kernel: XFS mounting filesystem sdb2
>>
>> This was the point of the xfs_repair more times.
>
> OK, the inodes that are corrupted are different, so there's still
> something funky going on here. I still would suggest replacing the
> RAID controller to rule that out as the cause.

News:

(reminder from the actual state:
xfs_repair fixed the fs, than kernel reported again the corruption and 
crashed, i wrote the provious letter to report this.)

Yesterday i have stopped the service, and run xfs_repair (new version only) 
on 2 FS, but it was clean!
(this shows me, the reported corruption was only in memory, or the kernel 
repaired it on the reboot.)
(The XFS_Debug turned on before.)
Today morning i have another messages in the syslog from the sdb2 again.
At this point, i don't know what to think.

http://download.netcenter.hu/bughunt/20100413/messages-16

Regards,
Janos


>
> FWIW, do you have any other servers with similar h/w, s/w and
> workloads? If so, are they seeing problems?
>
> Can you recompile the kernel with CONFIG_XFS_DEBUG enabled and
> reboot into it before you repair and remount the filesystem again?
> (i.e. so that we know that we have started with a clean filesystem
> and the debug kernel) I'm hoping that this will catch the corruption
> much sooner, perhaps before it gets to disk. Note that this will
> cause the machine to panic when corruption is detected, and it is
> much,much more careful about checking in memory structures so there
> is a CPU overhead involved as well.
>
> Cheers,
>
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/ 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
