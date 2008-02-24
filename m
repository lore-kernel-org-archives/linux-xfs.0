Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Feb 2008 19:53:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1O3rYke007009
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 19:53:35 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CBACEA338F
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 19:54:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id WWpEM8sAwq1WeOgY for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 19:54:00 -0800 (PST)
Message-ID: <47C0EA38.5060601@sandeen.net>
Date: Sat, 23 Feb 2008 21:53:28 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs I/O error
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
In-Reply-To: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rekrutacja119 <rekrutacja119@gmail.com>
Cc: xfs@oss.sgi.com

Rekrutacja119 wrote:
> hello, is there any way to force XFS to ignore I/O errors? it seems it is
> shutting down the fs when it encounters any error.

It does not shut down on any error; it should only be shutting down on
errors after which it cannot guarantee filesystem consistency.

> The problem is that i can't mark badsectors, as XFS doesn't support bad
> sector marking, but i also cannot access any correct data on partition,
> because when i try to access damaged sector, the whole fs goes down.
>
> any idea why?

Depends on what the sector is and what xfs is doing with it.

(btw the trace you posted in your next messages looks like you edited
out some relevant information)

> i use xfsprogs 2.9.4, my xfs is array made from 3 HDs, RAID 0, and one of
> them is getting some bad sectors. i cannot replace it currently.

xfs can't really help you with your bad hardware ;)

> after i run xfs_repair on it, i was able to mount it and access the data,
> but when somebody tries to access bad data, the whole XFS goes down. i don't
> want that, i also dont have place to xfsmetadump the whole array to another
> disks.

I do not think metadump does what you think it does... it only copies
metadata.

> i tried scaning whole disk with badblocks (badblocks -c 1 -s -v /dev/sdb),
> and then running dd if=/dev/zero of=/dev/sdb count=1 bs=1
> seek=NUMBER_FROM_BADBLOCKOUTPUT
> 
> but every block was written fine! (which is strange i guess), and it didnt
> help.

as iustin said, I think you just pretty well clobbered some important
metadata on your disk.  badblocks gives you block numbers in 1024 units.
 You gave dd a block size of 1... then rather than seeking out the
proper number of 1024 units, you seeked that many bytes; overwriting
probably important stuff at the beginning of your disk (since your wrote
at 1/1024 the offset that you should have)

> please advise me anything other than switching the drive (i will do it,
> can't now though) or dumping the whole thing as i need to much space.

mount it readonly to get to the data you need?

> the easiest solution would be to just ignore errors, and if not, then to
> somehow force xfs to mark them as bad sectors (smartctl is showing errors
> like for example

IMHO marking sectors bad is pointless.  If you have a failing drive, it
will only get worse.  At best you could use badblocks to try some writes
to remap; assuming you don't get it wrong and just zero out more of your
disk...

-Eric

> # 2  Extended offline    Completed: unknown failure    90%      9395
> -
> 
> or
> 
> 
> Error 8324 occurred at disk power-on lifetime: 9398 hours (391 days + 14
> hours)
>   When the command that caused the error occurred, the device was active or
> idle.
> 
>   After command completion occurred, registers were:
>   ER ST SC SN CL CH DH
>   -- -- -- -- -- -- --
>   40 51 00 30 33 59 e6  Error: UNC at LBA = 0x06593330 = 106509104
> 
> 
> [[HTML alternate version deleted]]
> 
> 
