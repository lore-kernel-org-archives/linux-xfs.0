Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Dec 2007 16:51:25 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB70pHtx024668
	for <xfs@oss.sgi.com>; Thu, 6 Dec 2007 16:51:21 -0800
Received: from kuber.nabble.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3116C4544FC
	for <xfs@oss.sgi.com>; Thu,  6 Dec 2007 16:51:25 -0800 (PST)
Received: from kuber.nabble.com (kuber.nabble.com [216.139.236.158]) by cuda.sgi.com with ESMTP id ah4iGxa3RBnnByQz for <xfs@oss.sgi.com>; Thu, 06 Dec 2007 16:51:25 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1J0RR6-0004yc-Ay
	for xfs@oss.sgi.com; Thu, 06 Dec 2007 16:51:24 -0800
Message-ID: <14204640.post@talk.nabble.com>
Date: Thu, 6 Dec 2007 16:51:24 -0800 (PST)
From: Kingghost <mrlitres@gmail.com>
Subject: Re: XFS_Repair PRoblem
In-Reply-To: <20071206210636.GM115527101@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <14194915.post@talk.nabble.com> <20071206210636.GM115527101@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hello,

Ya it said if I couldnt mount it to use -L so I did. Apparently this was a
mistake. 

I dd_rescued all the data to a new drive, so drive isnt the issue anymore.


David Chinner wrote:
> 
> On Thu, Dec 06, 2007 at 08:10:21AM -0800, Kingghost wrote:
>> 
>> Hello,
>> 
>> So I was seeing my serial link go up and down so I rebooted and
>> everything
>> was working fine, except my vg0 wouldnt mount. So I tried to xfs_repair
>> it
>> and this is the output I recieved.
>> 
>> slutb0x:/# xfs_repair -o assume_xfs /dev/vg0/media 
>> Phase 1 - find and verify superblock... 
>> sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
>> calculated value 128 
> 
> NULLFSINO? Something has overwritten your superblock with a bunch of -1
> values?
> 
>> resetting superblock root inode pointer to 128 
>> sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent
>> with
>> calculated value 129 
>> resetting superblock realtime bitmap ino pointer to 129 
>> sb realtime summary inode 18446744073709551615 (NULLFSINO) inconsistent
>> with
>> calculated value 130 
>> resetting superblock realtime summary ino pointer to 130 
>> Phase 2 - using internal log 
>> - zero log... 
> 
> Uh-oh - you ran a xfs_repair -L, didn't you?
>> 
>> missing inbetween 
>> 
>> rebuilding directory inode 1225702584 
>> bad hash table for directory inode 1342177425 (no data entry): rebuilding 
> 
> And a bunch of trashed directory structures...
> 
>> disconnected dir inode 752117670, moving to lost+found 
>> disconnected inode 809433019, moving to lost+found 
>> disconnected dir inode 823780059, moving to lost+found 
>> disconnected dir inode 823780089, moving to lost+found 
>> 
>> fatal error -- creation of .. entry failed (117), filesystem may be out
>> of
>> space 
> 
> 117 = EUCLEAN - corrupted filesystem. Sounds like there's more corruption
> there than was discovered or the underlying disk is still corruption
> blocks.
> What version of repair are you running ?
> 
> This is a dying disk you're trying to repair right?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
> 
> 
> 
> 

-- 
View this message in context: http://www.nabble.com/XFS_Repair-PRoblem-tf4956832.html#a14204640
Sent from the Xfs - General mailing list archive at Nabble.com.
