Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jan 2008 13:27:46 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0DLRcAs005480
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:27:41 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E14E75150AF
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:27:56 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id A7uo4m6kTkYGcZDh for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:27:56 -0800 (PST)
Message-ID: <478A8256.8030000@sandeen.net>
Date: Sun, 13 Jan 2008 15:27:50 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Cannot delete a directory on a XFS file system
References: <200801131723.12626.microchip@telenet.be> <alpine.DEB.0.999999.0801131448070.17216@p34.internal.lan>
In-Reply-To: <alpine.DEB.0.999999.0801131448070.17216@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Grozdan Nikolov (openSUSE Linux)" <microchip@telenet.be>, xfs@oss.sgi.com

Justin Piszcz wrote:
> 
> On Sun, 13 Jan 2008, Grozdan Nikolov (openSUSE Linux) wrote:
> 
>> Hi,
>>
>> I have a small problem with XFS on a small 40 GB IDE disk that I use for my
>> music collection. The disk (/dev/hdb) has only one partition on it formatted
>> as XFS. On this partition, there is a directory that no matter what I do, I
>> cannot delete it. I tried everything, in Konqueror, right-click on the
>> directory and choose to delete it. As root on the console
>> doing "rm -rf /media/data/DATA/MusicApps" ... but nothing works.
>>
>> When I try to "rm -rf" on this directory I get a message saying...
>>
>> rm: cannot remove directory `MusicApps/Loops/loops/Acid Loops/Bass': Directory
>> not empty
>>
>> But the "Bass" directory is completely empty, there's nothing in there. Also
>> when I unmount the file system and do a "xfs_check /dev/hdb1" I get a message
>> saying...
>>
>> link count mismatch for inode 184549517 (name ?), nlink 3, counted 2
>>
>> I did several times "xfs_repair /dev/hdb1" but I still get the same result.
>> xfs_check reports the same message and I still can't get rid of this empty
>> directory. I'm using kernel 2.6.24-rc7, but it's the same with other kernels.
>> I also did check the partition for bad block with the "badblocks" program,
>> but nothing came out, so the disk is just fine.
>>
>> Any ideas how I can delete this directory?
>>
>>
> 
> The developers get in on Monday :P
> 
> But some things they will ask:
> 
> 1. run xfs_info /dev/hdb1
> 2. run (and capture the full output from the repair process)

... with very latest xfsprogs please.  If latest repair doesn't fix it,
using xfs_metadump to provide a filesystem image for Barry to reproduce
with would be helpful.

> 3. run ls -lR on the dir that has problems
> 4. run ls -li on the director(ies) that cannot be deleted for the inode #s

ls -a on the dir to be sure there are no hidden dotfiles
ls -id on the dir to see if it is inode 184549517

-Eric
