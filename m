Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jan 2008 11:49:54 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0DJnhJm024261
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 11:49:47 -0800
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C00E514CAF
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 11:50:01 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by cuda.sgi.com with ESMTP id ZBi8shzv2JgQyta0 for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 11:50:01 -0800 (PST)
Date: Sun, 13 Jan 2008 14:49:30 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Cannot delete a directory on a XFS file system
In-Reply-To: <200801131723.12626.microchip@telenet.be>
Message-ID: <alpine.DEB.0.999999.0801131448070.17216@p34.internal.lan>
References: <200801131723.12626.microchip@telenet.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Grozdan Nikolov (openSUSE Linux)" <microchip@telenet.be>
Cc: xfs@oss.sgi.com



On Sun, 13 Jan 2008, Grozdan Nikolov (openSUSE Linux) wrote:

> Hi,
>
> I have a small problem with XFS on a small 40 GB IDE disk that I use for my
> music collection. The disk (/dev/hdb) has only one partition on it formatted
> as XFS. On this partition, there is a directory that no matter what I do, I
> cannot delete it. I tried everything, in Konqueror, right-click on the
> directory and choose to delete it. As root on the console
> doing "rm -rf /media/data/DATA/MusicApps" ... but nothing works.
>
> When I try to "rm -rf" on this directory I get a message saying...
>
> rm: cannot remove directory `MusicApps/Loops/loops/Acid Loops/Bass': Directory
> not empty
>
> But the "Bass" directory is completely empty, there's nothing in there. Also
> when I unmount the file system and do a "xfs_check /dev/hdb1" I get a message
> saying...
>
> link count mismatch for inode 184549517 (name ?), nlink 3, counted 2
>
> I did several times "xfs_repair /dev/hdb1" but I still get the same result.
> xfs_check reports the same message and I still can't get rid of this empty
> directory. I'm using kernel 2.6.24-rc7, but it's the same with other kernels.
> I also did check the partition for bad block with the "badblocks" program,
> but nothing came out, so the disk is just fine.
>
> Any ideas how I can delete this directory?
>
>

The developers get in on Monday :P

But some things they will ask:

1. run xfs_info /dev/hdb1
2. run (and capture the full output from the repair process)
3. run ls -lR on the dir that has problems
4. run ls -li on the director(ies) that cannot be deleted for the inode #s

If you give them this information in advance they'll have more info to 
help you.

Justin.
