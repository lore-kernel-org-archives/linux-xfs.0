Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4NJPLxr014916 for <xfs@oss.sgi.com>; Sat, 23 May 2009 14:25:22 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 013791A13137
	for <xfs@oss.sgi.com>; Sat, 23 May 2009 12:25:33 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id nv1qDpFEFnosyrsk for
	<xfs@oss.sgi.com>; Sat, 23 May 2009 12:25:33 -0700 (PDT)
Message-ID: <4A184DAC.8060400@sandeen.net>
Date: Sat, 23 May 2009 14:25:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Invalid argument
References: <4A180FCD.9080905@cape-horn-eng.com>
	<4A181B40.9080608@sandeen.net>	<20090523180721.94212hyfjppuupmo@webmail.df.eu>	<4A1833D7.30608@sandeen.net>	<20090523194552.66062w3zquwvms00@webmail.df.eu>
	<4A1844AF.7030906@sandeen.net>
In-Reply-To: <4A1844AF.7030906@sandeen.net>
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
To: richard.ems@cape-horn-eng.com
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> richard.ems@cape-horn-eng.com wrote:
>> Quoting Eric Sandeen <sandeen@sandeen.net>:
>>> Not sure ... how big is the current fs and how big is the device?  Can
>>> you provide:
>>>
>>> # xfs_info /mnt
>>> # grep sda1 /proc/partitions
>> It is a 16TB FS, and I add 4 x 1 TB HDDs to the RAID 6 array, so the  
>> device went from 16 TB to 20 TB.
>>
>> c3m:~ # xfs_info /backup/IFT
>> meta-data=/dev/sda1              isize=256    agcount=52, agsize=76288719 blks
>>           =                       sectsz=512   attr=1
>> data     =                       bsize=4096   blocks=3905982455, imaxpct=25
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=32768, version=1
>>           =                       sectsz=512   sunit=0 blks, lazy-count=0
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>>
>> c3m:~ # grep sda1 /proc/partitions
>>     8     1 19529912286 sda1
> 
> thanks, with that info I can reproduce it, I'll look into it soon... but
> not today.

Actually I lied, I looked at it ;)

if you growfs to a nr of blocks that is about 55 blocks less than the
actual device size, it should succeed for you.  There's a case where the
last AG would be too small and it tries to compensate but there's an
overflow, I'll send a patch.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
