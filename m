Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QLQmaH183284
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 16:26:49 -0500
Received: from mail.1-click.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1625B13C294F
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:30:19 -0700 (PDT)
Received: from mail.1-click.hu (ns2.netcenter.hu [195.228.155.139]) by
	cuda.sgi.com with ESMTP id Fj0xZTAiMbAgl1ut for
	<linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:30:19 -0700 (PDT)
Message-ID: <1412F1CF7FB24EA68598F8A0483EDD40@myXP>
From: "Janos Haar" <janos.haar@netcenter.hu>
References: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
	<4DA36676.1070206@hardwarefreak.com>
Subject: Re: 2 question about XFS fragmentation and _fsr: SPLITTED Q2:normal
	files, samba share
Date: Tue, 26 Apr 2011 23:21:22 +0200
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-xfs@oss.sgi.com

Note: I have splitted my previous letter for easyer discusion...
This have only Question-2 the storage with only normal files and samba 
share.

----- Original Message ----- 
From: "Stan Hoeppner" <stan@hardwarefreak.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-xfs@oss.sgi.com>
Sent: Monday, April 11, 2011 10:37 PM
Subject: Re: 2 question about XFS fragmentation and _fsr


> Janos Haar put forth on 4/11/2011 12:39 PM:
>> Question 2:
>> One of our customers have one storage wich is exactly the same like the
>> one wich is described on the Q1, but only used for samba storage for
>> storing media files (big files.)
>
> Writing large files sequentially shouldn't cause fragmentation.
>
>> I am sure, there is no torrent or similar, and i have told to the
>> customers on the beginning "don't write more files parallel, to avoid
>> fragmentation", but today the storage is >95% fragmented.
>> The customer sad, he only does file write one by one, and nothing more.
>> How can this be?
>
> What were the mkfs.xfs arguments you used when creating these
> filesystem?  Please share xfs_info output for the filesystems in
> question, and details of the underlying hardware RAID storage.

This was the default.

 xfs_info /dev/loop0
meta-data=/dev/loop0             isize=256    agcount=32, agsize=114269833 
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=3656634656, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

>
> -- 
> Stan

Thanks,
Janos 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
