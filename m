Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DM0Cb4053816 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:00:22 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2AA8F304089
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 15:00:58 -0700 (PDT)
Message-Id: <E037F1E5-2CC8-4F6E-92ED-AFE7BE6EBD1B@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A8474D2.7050508@jquigley.com>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: XFS corruption with failover
Date: Thu, 13 Aug 2009 16:44:05 -0500
References: <4A8474D2.7050508@jquigley.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: John Quigley <jquigley@jquigley.com>
Cc: XFS Development <xfs@oss.sgi.com>


On Aug 13, 2009, at 3:17 PM, John Quigley wrote:

> Folks:
>
> We're deploying XFS in a configuration where the file system is  
> being exported with NFS.  XFS is being mounted on Linux, with  
> default options; an iSCSI volume is the formatted media.  We're  
> working out a failover solution for this deployment utilizing Linux  
> HA.  Things appear to work correctly in the general case, but in  
> continuous testing we're getting XFS superblock corruption on a very  
> reproducible basis.
> The sequence of events in our test scenario:
>
> 1. NFS server #1 online
> 2. Run IO to NFS server #1 from NFS client
> 3. NFS server #1 offline, (via passing 'b' to /proc/sysrq-trigger)
> 4. NFS server #2 online
> 5. XFS mounted as part of failover mechanism, mount fails
>
> The mount fails with the following:
>
> <snip>
> kernel: XFS mounting filesystem sde
> kernel: Starting XFS recovery on filesystem: sde (logdev: internal)
> kernel: XFS: xlog_recover_process_data: bad clientid
> kernel: XFS: log mount/recovery failed: error 5

This is an IO error. Is the block device (/dev/sde) accessible
from the server #2 OK? Can you dd from that device?

>
> kernel: XFS: log mount failed
> </snip>
>
> When running xfs_repair:

That's not a good time to run xfs_repair. There were no
indication that the filesystem is corrupted.

Let's take for a sec "NFS server #2" out of the picture.
Can you mount the filesystem from the original server
after it reboots?

Felix

>
>
> <snip>
> [root@machine ~]# xfs_repair /dev/sde xfs_repair: warning - cannot  
> set blocksize on block device /dev/sde: Invalid argument
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>       - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which  
> needs ...
> </snip>
>
> Any advice or insight into what we're doing wrong would be very much  
> appreciated.  My apologies in advance for the somewhat off-topic  
> question.
>
> - John Quigley
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
