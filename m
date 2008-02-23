Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Feb 2008 13:46:34 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1NLkTVH011125
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 13:46:31 -0800
Received: from wr-out-0506.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C5EC760E1F5
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 13:46:55 -0800 (PST)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.232]) by cuda.sgi.com with ESMTP id LAhWZgbrVgzwxz05 for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 13:46:55 -0800 (PST)
Received: by wr-out-0506.google.com with SMTP id 50so1612649wra.18
        for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 13:46:54 -0800 (PST)
Message-ID: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
Date: Sat, 23 Feb 2008 22:46:52 +0100
From: Rekrutacja119 <rekrutacja119@gmail.com>
Subject: xfs I/O error
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

hello, is there any way to force XFS to ignore I/O errors? it seems it is
shutting down the fs when it encounters any error.
The problem is that i can't mark badsectors, as XFS doesn't support bad
sector marking, but i also cannot access any correct data on partition,
because when i try to access damaged sector, the whole fs goes down.

any idea why?

i use xfsprogs 2.9.4, my xfs is array made from 3 HDs, RAID 0, and one of
them is getting some bad sectors. i cannot replace it currently.

after i run xfs_repair on it, i was able to mount it and access the data,
but when somebody tries to access bad data, the whole XFS goes down. i don't
want that, i also dont have place to xfsmetadump the whole array to another
disks.

i tried scaning whole disk with badblocks (badblocks -c 1 -s -v /dev/sdb),
and then running dd if=/dev/zero of=/dev/sdb count=1 bs=1
seek=NUMBER_FROM_BADBLOCKOUTPUT

but every block was written fine! (which is strange i guess), and it didnt
help.

please advise me anything other than switching the drive (i will do it,
can't now though) or dumping the whole thing as i need to much space.

the easiest solution would be to just ignore errors, and if not, then to
somehow force xfs to mark them as bad sectors (smartctl is showing errors
like for example

# 2  Extended offline    Completed: unknown failure    90%      9395
-

or


Error 8324 occurred at disk power-on lifetime: 9398 hours (391 days + 14
hours)
  When the command that caused the error occurred, the device was active or
idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 30 33 59 e6  Error: UNC at LBA = 0x06593330 = 106509104


[[HTML alternate version deleted]]
