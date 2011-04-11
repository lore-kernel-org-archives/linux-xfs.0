Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3BKXu91111473
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 15:33:56 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 5958F1B6A8E8
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 13:37:16 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with SMTP id UBhUOBY3I3DJvnRE
	for <linux-xfs@oss.sgi.com>; Mon, 11 Apr 2011 13:37:16 -0700 (PDT)
Message-ID: <4DA36676.1070206@hardwarefreak.com>
Date: Mon, 11 Apr 2011 15:37:10 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 2 question about XFS fragmentation and _fsr
References: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
In-Reply-To: <DFA094D472104424BEA7AA9060DE0D6F@myXP>
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
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-xfs@oss.sgi.com

Janos Haar put forth on 4/11/2011 12:39 PM:

> In the result, actually we have >6TB images on the 3TB disk, wich is
> 97.9% fragmented.

How much free space does the filesystem have?  How big is each image
file?  For xfs_fsr to work properly it must have sufficient free space
in the filesystem.

> Basically the sparse RAW disk images should be more faster accessible
> than the original drive, because this is 4disk raid, instead of one, AND
> the head don't need to travel through the empty space of the drive...

It sounds like you may have some other issues besides filesystem
fragmentation.

> The XFS_FSR can be good for me or not?

If you have plenty of free space.

> Question 2:
> One of our customers have one storage wich is exactly the same like the
> one wich is described on the Q1, but only used for samba storage for
> storing media files (big files.)

Writing large files sequentially shouldn't cause fragmentation.

> I am sure, there is no torrent or similar, and i have told to the
> customers on the beginning "don't write more files parallel, to avoid
> fragmentation", but today the storage is >95% fragmented.
> The customer sad, he only does file write one by one, and nothing more.
> How can this be?

What were the mkfs.xfs arguments you used when creating these
filesystem?  Please share xfs_info output for the filesystems in
question, and details of the underlying hardware RAID storage.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
