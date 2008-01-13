Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jan 2008 14:56:32 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0DMuQwR013348
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 14:56:27 -0800
Received: from monty.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E570311CA98A
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 14:56:40 -0800 (PST)
Received: from monty.telenet-ops.be (monty.telenet-ops.be [195.130.132.56]) by cuda.sgi.com with ESMTP id BOdyu2yVYa2JyfYz for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 14:56:40 -0800 (PST)
From: "Grozdan Nikolov (openSUSE Linux)" <microchip@telenet.be>
Subject: Re: Cannot delete a directory on a XFS file system
Date: Sun, 13 Jan 2008 23:56:39 +0100
References: <200801131723.12626.microchip@telenet.be> <200801132238.52075.microchip@telenet.be> <478A87FD.60203@sandeen.net>
In-Reply-To: <478A87FD.60203@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801132356.39966.microchip@telenet.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Sunday 13 January 2008 22:51, you wrote:
> Grozdan Nikolov (openSUSE Linux) wrote:
> > I do not know what version is the latest of xfsprogs. I use my distro's
> > default (2.8.11)
>
> Ok, 2.9.4 is latest.  2.8.11 is from Aug 2006.... Perhaps the more
> recent version will properly fix your fs.
>
> From the changelog:
>
> xfsprogs-2.8.15 (19 October 2006)
>         - Fix up nlink checks and repairs in phase 7 for xfs_repair.

ok, I added the latest version of xfsprogs from the SUSE build service, ran 
xfs_repair /dev/hdb1 and when it finished it resetted the inode...

resetting inode 184549517 nlinks from 3 to 2

after this, I was able to delete the directory.

Thank for all your help :) 

>
> >> using xfs_metadump to provide a filesystem image for Barry to reproduce
> >> with would be helpful.
> >
> > I can't find xfs_metadump on my system. I only have xfsdump. Is this the
> > same?
>
> Nope, it's not there in your older xfsprogs.
>
> >>> 3. run ls -lR on the dir that has problems
> >>> 4. run ls -li on the director(ies) that cannot be deleted for the inode
> >>> #s
> >>
> >> ls -a on the dir to be sure there are no hidden dotfiles
> >
> > ls -a "MusicApps/Loops/loops/Acid Loops/Bass"
> >
> > .  ..
>
> Ok, no hidden files.
>
> >> ls -id on the dir to see if it is inode 184549517
> >
> > ls -id "MusicApps/Loops/loops/Acid Loops/Bass"
>
> So, the dir you can't delete is the one with the link count mismatch
> stated by xfs_check - that's what I figured but wanted to double check.
>
> I'd be willing to bet that the latest xfsprogs would fix this for you.
>
> Alternately some xfs_db hackery could too, but using more recent repair
> would be the best route I think.
>
> -Eric
>
> > 184549517 MusicApps/Loops/loops/Acid Loops/Bass
> >
> >> -Eric
