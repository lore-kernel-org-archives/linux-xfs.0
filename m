Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3QLmqCl183962
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 16:48:52 -0500
Received: from mail.1-click.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E7BB153BCAB
	for <linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:52:23 -0700 (PDT)
Received: from mail.1-click.hu (ns2.netcenter.hu [195.228.155.139]) by
	cuda.sgi.com with ESMTP id goaG3PvXmekIuqCn for
	<linux-xfs@oss.sgi.com>; Tue, 26 Apr 2011 14:52:23 -0700 (PDT)
Message-ID: <2FDAD38566FF4F8B9C5ACF3F900287D6@myXP>
From: "Janos Haar" <janos.haar@netcenter.hu>
References: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
	<4DA36676.1070206@hardwarefreak.com>
Subject: Re: 2 question about XFS fragmentation and _fsr: SPLITTED Q1:sparese
	files
Date: Tue, 26 Apr 2011 23:50:43 +0200
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
This have only Question-1 the storage with only sparse files.

----- Original Message ----- 
From: "Stan Hoeppner" <stan@hardwarefreak.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-xfs@oss.sgi.com>
Sent: Monday, April 11, 2011 10:37 PM
Subject: Re: 2 question about XFS fragmentation and _fsr


> Janos Haar put forth on 4/11/2011 12:39 PM:
>
>> In the result, actually we have >6TB images on the 3TB disk, wich is
>> 97.9% fragmented.
>
> How much free space does the filesystem have?  How big is each image
> file?  For xfs_fsr to work properly it must have sufficient free space
> in the filesystem.

Actually less than 1%.
I know, this is too less for xfs_fsr, but i am only thinking actually to try 
because i am unsure this is useful for me.

>
>> Basically the sparse RAW disk images should be more faster accessible
>> than the original drive, because this is 4disk raid, instead of one, AND
>> the head don't need to travel through the empty space of the drive...
>
> It sounds like you may have some other issues besides filesystem
> fragmentation.
>
>> The XFS_FSR can be good for me or not?
>
> If you have plenty of free space.
>
> -- 
> Stan

Thanks,
Janos 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
