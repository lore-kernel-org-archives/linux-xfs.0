Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NMVf25113079 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 16:31:42 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5ED02143048
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 14:31:10 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id uMCmXzryJGAPha6x for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2009 14:31:10 -0800 (PST)
Message-ID: <49A323AB.4050104@sandeen.net>
Date: Mon, 23 Feb 2009 16:31:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS on ARM-based Linux on USR8700 NAS appliance w/ mdadm/RAID5
References: <200902231243.33897.harry.mangalam@uci.edu>
	<200902231345.25062.harry.mangalam@uci.edu>
	<49A31AFD.8070804@sandeen.net>
	<200902231424.25130.harry.mangalam@uci.edu>
In-Reply-To: <200902231424.25130.harry.mangalam@uci.edu>
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
To: Harry Mangalam <harry.mangalam@uci.edu>
Cc: xfs@oss.sgi.com

Harry Mangalam wrote:
> mount -t xfs -o loop,offset=11403264,ro,norecovery /dev/md0 /lost
> 
> gives me a mount(!!):
> 
> df -> /lost/public, but it's not a standard entry:
> ?--------- ? ?    ?    ?    ? /lost/public
> 
> and dmesg coughs up many lines of XFS errors:

not sure at this point.  i'd put it back in the nas box w/ the recreated
raid mount -o ro,norecovery again for safety if you like, and hope for
the best.

Otherwise maybe run repair; on a dd image if you prefer, again for
safety....

-Eric

> loop: AES key scrubbing enabled
> loop: loaded (max 8 devices)
> Filesystem "loop0": Disabling barriers, not supported by the 
> underlying device
> Mounting filesystem "loop0" in no-recovery mode.  Filesystem will be 
> inconsistent.
> XFS resetting qflags for filesystem loop0
> xfs_force_shutdown(loop0,0x1) called from line 424 of file 
> fs/xfs/xfs_rw.c.  Return address = 0xfb2fc728
> Filesystem "loop0": I/O Error Detected.  Shutting down filesystem: 
> loop0
> Please umount the filesystem, and rectify the problem(s)
> xfs_force_shutdown(loop0,0x1) called from line 424 of file 
> fs/xfs/xfs_rw.c.  Return address = 0xfb2fc728
> Filesystem "loop0": Disabling barriers, not supported by the 
> underlying device
> Mounting filesystem "loop0" in no-recovery mode.  Filesystem will be 
> inconsistent.
> XFS resetting qflags for filesystem loop0
> 
> 
> 
> 
> On Monday 23 February 2009, Eric Sandeen wrote:
>> try mount -o loop,offset=11403264 /dev/whatever /mnt/whatever
>>
>> I'd probably also add ro,norecovery to the options as well so you
>> don't actually write anything to it at this point.
>>
>> -Eric
> 
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
