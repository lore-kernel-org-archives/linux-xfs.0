Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nA99J57w178031 for <xfs@oss.sgi.com>; Mon, 9 Nov 2009 03:19:07 -0600
Received: from mail.in-medias-res.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0781122FB0B
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2009 01:19:20 -0800 (PST)
Received: from mail.in-medias-res.com (mail.in-medias-res.com [78.47.10.114])
	by cuda.sgi.com with ESMTP id 6Nsh10N8WJFpQjuR for
	<xfs@oss.sgi.com>; Mon, 09 Nov 2009 01:19:20 -0800 (PST)
Date: Mon, 9 Nov 2009 10:19:15 +0100
From: mill / in-medias-res <mill@in-medias-res.com>
Subject: Re: xfs_repair breaks; xfs_metadump hangs
Message-ID: <20091109091915.GB3601@mytux.intra.in-medias-res.com>
References: <20091104152022.GA21347@mytux.intra.in-medias-res.com>
	<4AF4A66B.8090906@digitalelves.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AF4A66B.8090906@digitalelves.com>
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
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com


> Hmm interesting.
> Can you go into xfs_db and print out the bad inode? send it to us?
> I'm guessing the extents are corrupted somehow.

Did you mean "xfs_db -x -c 'blockget inode 3256930831' /dev/sdc2" ?
xfs_db consumes 99% of CPU and Virt 2510m RES 194m of RAM.

How long should i wait?



> One option to then flag the inode as deleted which will cause repair to
> toss is hopefully clean up the mess.
>
> Here is a write up how to do that.
> http://jijo.free.net.ph/19
If i can't get that block i will try with deleting it, Thanks!

Best regards,
Maximilian Mill
>> time: 67,27s user 10,09s system 10% cpu 12:05,31 total
>>
>> I tried to run xfs_metadump serveral times and it hangs everytime on this position:
>> xfs_metadump  -g /dev/sdc2 metadump-sdc2-2
>> Copied 1411840 of 4835520 inodes (0 of 3 AGs)
>>
>> It runs till 2 days on the same inode and xfs_db consumes 99% of CPU.
>> Should i wait here?
>>
>> Versions:
>> dpkg -l |grep xfs
>> ii  xfsdump   3.0.2~bpo50+1       Administrative utilities for the XFS filesys
>> ii  xfsprogs  3.0.4~bpo50+1       Utilities for managing the XFS filesystem
>> Distribution: Debian lenny with xfsprogs, xfsdump backport from unstable.
>>
>> The xfs_repair with stock Debian Lenny version also does crash at inode 3256930831.
>>
>> Best Regards,
>> Maximilian Mill
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
>>
>>   
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
