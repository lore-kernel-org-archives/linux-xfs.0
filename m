Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5PAY4lw228515 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 05:34:05 -0500
Received: from vserv.windfluechter.net (vserv.windfluechter.net
	[178.63.83.104]) by cuda.sgi.com with ESMTP id LKvI3kiiprOXDmjN
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jun 2012 03:34:01 -0700 (PDT)
Received: from [172.16.10.1] (helo=hro.bluespice.org)
	by vserv.windfluechter.net with esmtps
	(TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16) (Exim 4.72)
	(envelope-from <ij@2012.bluespice.org>) id 1Sj6cJ-0000UK-Uv
	for xfs@oss.sgi.com; Mon, 25 Jun 2012 12:34:00 +0200
MIME-Version: 1.0
Date: Mon, 25 Jun 2012 12:33:59 +0200
From: =?UTF-8?Q?Ingo_J=C3=BCrgensmann?= <ij@2012.bluespice.org>
Subject: Re: mkfs.xfs states log stripe unit is too large
In-Reply-To: <20120623234445.GZ19223@dastard>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard>
Message-ID: <6ced350bf42b8ca6243a14e271fe475e@localhost>
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
To: xfs@oss.sgi.com

On 2012-06-24 01:44, Dave Chinner wrote:

> If you increase the log stripe unit, you also increase the minimum
> log buffer size that the filesystem supports. The filesystem can
> support up to 256k log buffers, and hence the limit on maximum log
> stripe alignment.

So, no way to increase log buffers to match 1.2 format superblocks 
default size of 512 kiB, I guess, because it would change on 
disk-format?

>> - will performance suffer from log stripe size adjusted to just 32
>> kiB? Some of my logical volumes will just store data, but one or
>> the other will have some workload acting as storage for BackupPC.
> For data volumes, no. For backupPC, it depends on whether the MD
> RAID stripe cache can turn all the sequential log writes into a full
> stripe write. In general, this is not a problem, and is almost never
> a problem for HW RAID with BBWC....

Well, the external log would have been on my other RAID disks. Having a 
RAID1 for this would be doable, but I decided to not go that way. It 
would limit me too much to replace those 1 TB disks by bigger ones 
somewhen in the future.
Regarding BackupPC: it might more likely benefit from a smaller log 
stripe size, because BackupPC makes extensive use of hardlinks, so I 
guess the overhead will be smaller when using 32 kiB log stripe size, as 
you suggests as well below:

>> - would it be worth the effort to raise log stripe to at least 256
>> kiB?
> Depends on your workload. If it is fsync heavy, I'd advise against
> it, as every log write will be padded out to 256k, even if you only
> write 500 bytes worth of transaction data....

BackupPC will check against its pool of files, whether a file is 
already in it (by comparing md5sum or shaXXXsum) or not. If it's in the 
pool already it will hardlink to it, if it's not it will copy the file 
and hardlink then. Therefore I assume that the workload will mainly be 
fsyncs.

>> - or would it be better to run with external log on the old 1 TB
>> RAID?
> External logs provide muchless benefit with delayed logging than hey
> use to. As it is, your external log needs to have the same
> reliability characteristics as the main volume - lose the log,
> corrupt the filesystem. Hence for RAID5 volumes, you need a RAID1
> log, and for RAID6 you either need RAID6 or a 3-way mirror to
> provide the same reliability....

That would be possible. But as stated above, I won't go that way for 
practical reasons.

>> End note: the 4 TB disks are not yet "in production", so I can run
>> tests with both RAID setup as well as mkfs.xfs. Reshaping the RAID
>> will take up to 10 hours, though...
> IMO, RAID reshaping is just a bad idea - it changes the alignment
> characteristic of the volume, hence everything that the
> filesystemlaid down in an aligned fashion is now unaligned, and you
> have to tell the filesytemteh new alignment before new files will be
> correctly aligned. Also, it's usually faster to back up, recreate
> and restore than reshape and that puts a lot less load on your
> disks, too...

True. Therefor I've re-created the RAID again instead of still running 
it from re-shaped RAID1-to-RAID5. Anyway, reshaping is only an issue as 
long as there's already a FS on it. But a bad feeling still persists... 
;)

Thanks for your explanation, Dave!

-- 
Ciao...          //    Fon: 0381-2744150
.     Ingo     \X/     http://blog.windfluechter.net

gpg pubkey: http://www.juergensmann.de/ij_public_key.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
