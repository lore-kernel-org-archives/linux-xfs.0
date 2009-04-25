Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3P11adc121323 for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 20:01:36 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 403071CE72B1
	for <xfs@oss.sgi.com>; Fri, 24 Apr 2009 18:01:33 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id lLTUqc2NajiVLj0G for
	<xfs@oss.sgi.com>; Fri, 24 Apr 2009 18:01:33 -0700 (PDT)
Message-ID: <49F260F1.4030503@sandeen.net>
Date: Fri, 24 Apr 2009 20:01:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Slab memory usage
References: <73EE3FB2-381F-43F1-82C1-FA4C020E7C02@strands.com>
In-Reply-To: <73EE3FB2-381F-43F1-82C1-FA4C020E7C02@strands.com>
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
To: Poul Petersen <petersen@strands.com>
Cc: xfs@oss.sgi.com

Poul Petersen wrote:
> 	I'm running Debian Lenny with kernel 2.6.26-1-amd64 and  
> xfsprogs-2.9.8-1. I've been having a problem with the amount of slab  
> memory that XFS seems to be consuming when running a rsync backup job,  
> a du, or other file-system intensive programs. Below is an example of  
> the output of slabtop and /proc/meminfo. I'm running a tool that  
> monitors free memory space, and it starts generating alerts, though I  
> don't blame it when the SLAB is running at 50% of memory!
> 
> 	When the process finishes, the memory usually frees up over a period  
> of several hours. However, on a similar system, even 24 hours after  
> the rsync job finished, the slab never freed up. On that machine, if I  
> run:
> 
> echo 2 > /proc/sys/vm/drop_caches
> 
> 	Then the slab goes down to something more like 1% or 2% of system  
> RAM. Any ideas what is causing this behaviour? And how I might  
> alleviate it?
> 
> Thanks,
> 
> -poul
> 
> slabtop
> =======
> 
>   Active / Total Objects (% used)    : 7684622 / 7875871 (97.6%)
>   Active / Total Slabs (% used)      : 720661 / 720662 (100.0%)
>   Active / Total Caches (% used)     : 105 / 176 (59.7%)
>   Active / Total Size (% used)       : 2683658.81K / 2702989.38K (99.3%)
>   Minimum / Average / Maximum Object : 0.02K / 0.34K / 4096.00K
> 
>    OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 1933952 1933787  99%    0.44K 241744        8    966976K xfs_inode
> 1933918 1933787  99%    0.56K 276274        7   1105096K xfs_vnode
> 1361008 1359980  99%    0.20K  71632       19    286528K dentry


o/~ the dentry's connected to the ... v-node, the v-node's connected to
the ... i-node .... o/~

This is really mostly the linux vfs hanging onto the dentries.  This in
turn pins the inodes and related xfs structures.

But, your memory is there for caching, most of the time.  If it's not
(mostly) used, then it's wasted.  If the memory is needed for other
purposes, the vfs frees the cached dentries, which in turn frees the
related structures.  This really isn't necessarily indicative of a problem.

There are some tunables* you could play with to change this behavior if
you like, but unless you are actually seeing performance problems, I
wouldn't be too concerned.

-Eric


*from Documentation/sysctl/vm.txt:

vfs_cache_pressure
------------------

Controls the tendency of the kernel to reclaim the memory which is used
for caching of directory and inode objects.

At the default value of vfs_cache_pressure=100 the kernel will attempt
to reclaim dentries and inodes at a "fair" rate with respect to
pagecache and swapcache reclaim.  Decreasing vfs_cache_pressure causes
the kernel to prefer to retain dentry and inode caches.  Increasing
vfs_cache_pressure beyond 100 causes the kernel to prefer to reclaim
dentries and inodes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
