Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANBG9Dk198519 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 05:16:09 -0600
Received: from BLADE4.ISTI.CNR.IT (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6114E13E4C4E
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 03:17:45 -0800 (PST)
Received: from BLADE4.ISTI.CNR.IT (blade4.isti.cnr.it [194.119.192.20]) by
	cuda.sgi.com with ESMTP id tZKcsFkgOCMIOiXE for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 03:17:45 -0800 (PST)
Received: from SCRIPT-SPFWL-DAEMON.mx.isti.cnr.it by mx.isti.cnr.it
	(PMDF V6.5 #31825) id <01NULG5HN6RKLGYGNJ@mx.isti.cnr.it> for
	xfs@oss.sgi.com; Tue, 23 Nov 2010 12:16:38 +0100 (MET)
Received: from conversionlocal.isti.cnr.it by mx.isti.cnr.it (PMDF V6.5 #31825)
	id <01NULG5C3ER4LGYABD@mx.isti.cnr.it> for xfs@oss.sgi.com; Tue,
	23 Nov 2010 12:15:42 +0100 (MET)
Date: Tue, 23 Nov 2010 12:17:41 +0100
From: Spelic <spelic@shiftmail.org>
Subject: Re: Xfs delaylog hanged up
In-reply-to: <20101122232929.GJ13830@dastard>
Message-id: <4CEBA2D5.2020708@shiftmail.org>
MIME-version: 1.0
References: <4CEAC412.9000406@shiftmail.org> <20101122232929.GJ13830@dastard>
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
Cc: xfs@oss.sgi.com

On 11/23/2010 12:29 AM, Dave Chinner wrote:
>> 16 disk MD raid-5
>>      
> What is the storage hardware and the MD raid5 configuration?
>    

Tyan motherboard with 5400 chipset
dual Xeon E5420

16 disks on this one:
05:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID PCIe (rev 01)
         Subsystem: 3ware Inc 9650SE SATA-II RAID PCIe
         Flags: bus master, fast devsel, latency 0, IRQ 16
         Memory at ce000000 (64-bit, prefetchable) [size=32M]
         Memory at d2600000 (64-bit, non-prefetchable) [size=4K]
         I/O ports at 3000 [size=256]
         [virtual] Expansion ROM at d26e0000 [disabled] [size=128K]
         Capabilities: <access denied>
         Kernel driver in use: 3w-9xxx
         Kernel modules: 3w-9xxx

mdadm --create /dev/md5 --raid-devices=16 --chunk=1024 --level=5 
--metadata=1.0 pci-0000:05:00.0-scsi-0:0:{15..0}:0 
--name=backup:perftest --assume-clean

>> mount line:
>>         /dev/mapper/perftestvg-xfslv /perftest/xfs xfs rw,relatime,attr2,delaylog,nobarrier,inode64,logbufs=8,logbsize=256k,noquota
>> 0 0
>>      
> FYI, relatime, attr2, logbufs=8 and noquota are default values that
> you don't need to specify.
>    

ok, that was the /proc/mounts line..

mkfs.xfs -l size=128m -d agcount=16 <device>

mount -o delaylog,nobarrier,inode64,logbufs=8,logbsize=256k <device> 
<mountpoint>


> Thanks for the test case - I'll try to reproduce this. One more key
> piece of information I need: the output of mkfs.xfs so I can see your
> filesystem geometry. if you have the filesystem mounted, then the
> output of 'xfs_info<mntpt>' will give the same information.
>    

/# xfs_info /perftest/xfs/
meta-data=/dev/mapper/perftestvg-xfslv isize=256    agcount=16, 
agsize=50331648 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=805306368, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

> It is stable enough that all my local machines are running with
> delaylog. And as a dev team, we have enough confidence in it to
> remove the EXPERIMENTAL status for the 2.6.37 release. That doesn't
> mean it is perfectly bug free - it just means more people will start
> to use it.  And as this happens, we will find new problems in
> different environments (just like you have), but this is a pretty
> normal occurrence for new code.
>    

ok I understand...

thanks for your work!


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
