Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 430307FF5
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 15:24:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 33BB0304064
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 13:24:15 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 4DC4MBBGOdIswrKh
	for <xfs@oss.sgi.com>; Fri, 04 Apr 2014 13:24:14 -0700 (PDT)
Message-ID: <533F14EC.6040705@hardwarefreak.com>
Date: Fri, 04 Apr 2014 15:24:12 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 10GB memorys occupied by XFS
References: <1396596386220-35015.post@n7.nabble.com>
In-Reply-To: <1396596386220-35015.post@n7.nabble.com>
Reply-To: stan@hardwarefreak.com
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
To: daiguochao <dx-wl@163.com>, xfs@oss.sgi.com

On 4/4/2014 2:26 AM, daiguochao wrote:
> Hello folks,

Hello,

Note that your problems are not XFS specific, but can occur with any
Linux filesystem.

> I used xfs file system in kernel-2.6.32-220.13.1.el6.x86_64 for store
> pictures. About 100 days system memorys is lost and some nginx process is
> killed by oom-killer.So,I looked /proc/meminfo and find memorys is
> lost.Finally, I try to umount xfs system and 10GB memorys is coming back. l
> look xfs bugzilla no such BUG.I have no idea for it.
> 
> Cheers,
> 
> Guochao.
> 
> some memorys info:
> 
> 0> free -m
>              total       used       free     shared    buffers     cached
> Mem:         11887      11668        219          0          0          2
> -/+ buffers/cache:      11665        222
> Swap:            0          0          0


First problem:  no swap
Second problem: cache is not being reclaimed

Read vfs_cache_pressure at:
https://www.kernel.org/doc/Documentation/sysctl/vm.txt

You've likely set this value to zero.  Changing it to 200 should prompt
the kernel to reclaim dentries and inodes aggressively, preventing the
oom-killer from kicking in.

Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
