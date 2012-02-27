Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1R6SFIE027486 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 00:28:15 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 11B31SkzrNpi7Ekf
	for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 22:28:13 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 5101B6C0C5
	for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 00:28:13 -0600 (CST)
Message-ID: <4F4B2281.1070200@hardwarefreak.com>
Date: Mon, 27 Feb 2012 00:28:17 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: mount: Structure needs cleaning
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com>
	<33393429.post@talk.nabble.com> <20120227004902.GQ3592@dastard>
	<33397518.post@talk.nabble.com>
In-Reply-To: <33397518.post@talk.nabble.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 2/26/2012 9:11 PM, MikeJeezy wrote:

>> On 02/26/2012 11:07am, Stan Hoeppner wrote: 
>> Are those other VMs using XFS filesystems? 
> 
> What kernel version are you running?  
> 
> 2.6.18-274.18.1.el5

I'm not familiar enough with Red Hat kernel revs to know if all relevant
patches are included in this kernel.  There are a few Red Hat devs here
who should have more insight on this.

>> Are you using LVM under XFS?  
> 
> No
> 
>> What fstab mount options?  
> 
> /dev/sdd1               /mnt/ob1               xfs     defaults        0 0
> /dev/sde1               /mnt/ob2               xfs     defaults        0 0
> 
>> Does your SAN array have battery backed write cache?  
> 
> This one does not currently, but I have ordered BBWC for it.

Good.  I suggest disabling the SAN controller's write caching until the
BBWC is installed and verified to be functioning correctly.

>> Are the individual drive caches in the underlying array disabled? 
> 
> Write cache: enabled
> Read ahead: enabled

In the case of a SAN array or PCIe RAID controller, this dmesg output is
telling you about the state of the controller's cache, not the
individual drive caches.  Enable/disable of the drive caches should be
an option in the controller firmware interface.  You want the individual
drive write caches disabled.  Leaving their read caches enabled is fine.

The reason is that a power drop, kernel panic, or hardware lockup
(thermal etc) clears the drive write caches before the blocks are
written to the platters.  It is suspected that many/most of these free
space btree corruptions, such as yours here, are caused by data in
caches not being flushed to the platters.  SAN/RAID controllers with
BBWC usually guarantee data in the write cache gets properly flushed to
the platters when the system comes back up.

So, way back when, you may have had a system (VM) crash of one kind or
another, or an improper shutdown (VM power-off), then rebooted, and
everything seemed fine.  Months later, you discover you have a corrupted
free space btree, which was caused by the crash long ago, that everyone
forgot about, never documented, etc.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
