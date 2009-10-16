Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9GFrkv1112615 for <xfs@oss.sgi.com>; Fri, 16 Oct 2009 10:53:46 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A0A71BF6B7F
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2009 08:55:16 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id B1IMuMiCqc8bD5Vp for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2009 08:55:16 -0700 (PDT)
Message-ID: <4AD89761.4000605@sandeen.net>
Date: Fri, 16 Oct 2009 10:55:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS mount failuer on RAID5
References: <389deec70910152009i7656aaf2s9d929b8b68e4e740@mail.gmail.com>
	<4AD89128.2010206@sandeen.net>
In-Reply-To: <4AD89128.2010206@sandeen.net>
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
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com

Eric Sandeen wrote:
> hank peng wrote:
>> Hi, all:
>> I have a self-built board, cpu is MPC8548(PPC arch), kernel is based
>> on MPC8548CDS demo board, version is 2.6.23.
>> A SATA controller is conected to CPU via PCIX, and I have 3 disks
>> attached to it.
>>
> ...
> 
>> root@Storage:~# mkfs.xfs -f -ssize=4k /dev/vg/lvtest
>> Warning - device mapper device, but no dmsetup(8) found
>> Warning - device mapper device, but no dmsetup(8) found
>> meta-data=/dev/vg/lvtest         isize=256    agcount=4, 
>> agsize=6553600 blks
>>          =                       sectsz=4096  attr=2
>> data     =                       bsize=4096   blocks=26214400, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096
>> log      =internal log           bsize=4096   blocks=12800, version=2
>>          =                       sectsz=4096  sunit=1 blks, lazy-count=0
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> root@Storage:~# mkdir tmp
>> root@Storage:~# mount -t xfs /dev/vg/lvtest ./tmp/
>> Filesystem "dm-0": Disabling barriers, not supported by the underlying 
>> device
>> XFS mounting filesystem dm-0
>> XFS: totally zeroed log
>> Filesystem "dm-0": XFS internal error xlog_clear_stale_blocks(2) at
>> line 1252 of file fs/xfs/xfs_log_recover.c.  Caller 0xc018ec88
> 
> 
> Can you try the patch that Andy Poling posted to the list just 
> yesterday?  Slight longshot but it may be it.
> 
> Otherwise I will look at this in a bit; on the road today though.
> 
> -Eric

Actually you might try a newer xfsprogs and/or kernel; if I do this on a 
loopback file, creating the same geometry as you have:

mkfs.xfs -dfile,name=fsfile,size=2621440b -lsize=12800b,lazy-count=0 
-ssize=4096

it mounts fine w/ latest xfsprogs and a 2.6.30 kernel.

-Eric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
