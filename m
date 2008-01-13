Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jan 2008 13:52:11 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0DLpgbo008485
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:51:45 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7022411CA622
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:52:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id yFpNzj2i9aNxsG8l for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:52:00 -0800 (PST)
Message-ID: <478A87FD.60203@sandeen.net>
Date: Sun, 13 Jan 2008 15:51:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Cannot delete a directory on a XFS file system
References: <200801131723.12626.microchip@telenet.be> <alpine.DEB.0.999999.0801131448070.17216@p34.internal.lan> <478A8256.8030000@sandeen.net> <200801132238.52075.microchip@telenet.be>
In-Reply-To: <200801132238.52075.microchip@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Grozdan Nikolov (openSUSE Linux)" <microchip@telenet.be>
Cc: xfs@oss.sgi.com

Grozdan Nikolov (openSUSE Linux) wrote:

> I do not know what version is the latest of xfsprogs. I use my distro's 
> default (2.8.11)

Ok, 2.9.4 is latest.  2.8.11 is from Aug 2006.... Perhaps the more
recent version will properly fix your fs.

>From the changelog:

xfsprogs-2.8.15 (19 October 2006)
        - Fix up nlink checks and repairs in phase 7 for xfs_repair.


>> using xfs_metadump to provide a filesystem image for Barry to reproduce
>> with would be helpful.
> 
> I can't find xfs_metadump on my system. I only have xfsdump. Is this the same?

Nope, it's not there in your older xfsprogs.

>>> 3. run ls -lR on the dir that has problems
>>> 4. run ls -li on the director(ies) that cannot be deleted for the inode
>>> #s
>> ls -a on the dir to be sure there are no hidden dotfiles

> ls -a "MusicApps/Loops/loops/Acid Loops/Bass"
> 
> .  ..

Ok, no hidden files.

> 
>> ls -id on the dir to see if it is inode 184549517
> 
> ls -id "MusicApps/Loops/loops/Acid Loops/Bass"

So, the dir you can't delete is the one with the link count mismatch
stated by xfs_check - that's what I figured but wanted to double check.

I'd be willing to bet that the latest xfsprogs would fix this for you.

Alternately some xfs_db hackery could too, but using more recent repair
would be the best route I think.

-Eric

> 184549517 MusicApps/Loops/loops/Acid Loops/Bass
> 
>> -Eric
> 
