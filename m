Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jan 2008 13:38:41 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0DLcZBW007157
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:38:37 -0800
Received: from edna.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CA4411CA579
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:38:52 -0800 (PST)
Received: from edna.telenet-ops.be (edna.telenet-ops.be [195.130.132.58]) by cuda.sgi.com with ESMTP id SdDHXkAeiQe70VwR for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:38:52 -0800 (PST)
From: "Grozdan Nikolov (openSUSE Linux)" <microchip@telenet.be>
Subject: Re: Cannot delete a directory on a XFS file system
Date: Sun, 13 Jan 2008 22:38:51 +0100
References: <200801131723.12626.microchip@telenet.be> <alpine.DEB.0.999999.0801131448070.17216@p34.internal.lan> <478A8256.8030000@sandeen.net>
In-Reply-To: <478A8256.8030000@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801132238.52075.microchip@telenet.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Sunday 13 January 2008 22:27, you wrote:
> Justin Piszcz wrote:
> > On Sun, 13 Jan 2008, Grozdan Nikolov (openSUSE Linux) wrote:
> >> Hi,
> >>
> >> I have a small problem with XFS on a small 40 GB IDE disk that I use for
> >> my music collection. The disk (/dev/hdb) has only one partition on it
> >> formatted as XFS. On this partition, there is a directory that no matter
> >> what I do, I cannot delete it. I tried everything, in Konqueror,
> >> right-click on the directory and choose to delete it. As root on the
> >> console
> >> doing "rm -rf /media/data/DATA/MusicApps" ... but nothing works.
> >>
> >> When I try to "rm -rf" on this directory I get a message saying...
> >>
> >> rm: cannot remove directory `MusicApps/Loops/loops/Acid Loops/Bass':
> >> Directory not empty
> >>
> >> But the "Bass" directory is completely empty, there's nothing in there.
> >> Also when I unmount the file system and do a "xfs_check /dev/hdb1" I get
> >> a message saying...
> >>
> >> link count mismatch for inode 184549517 (name ?), nlink 3, counted 2
> >>
> >> I did several times "xfs_repair /dev/hdb1" but I still get the same
> >> result. xfs_check reports the same message and I still can't get rid of
> >> this empty directory. I'm using kernel 2.6.24-rc7, but it's the same
> >> with other kernels. I also did check the partition for bad block with
> >> the "badblocks" program, but nothing came out, so the disk is just fine.
> >>
> >> Any ideas how I can delete this directory?
> >
> > The developers get in on Monday :P
> >
> > But some things they will ask:
> >
> > 1. run xfs_info /dev/hdb1
> > 2. run (and capture the full output from the repair process)
>
> ... with very latest xfsprogs please.  If latest repair doesn't fix it,

I do not know what version is the latest of xfsprogs. I use my distro's 
default (2.8.11)

> using xfs_metadump to provide a filesystem image for Barry to reproduce
> with would be helpful.

I can't find xfs_metadump on my system. I only have xfsdump. Is this the same?

>
> > 3. run ls -lR on the dir that has problems
> > 4. run ls -li on the director(ies) that cannot be deleted for the inode
> > #s
>
> ls -a on the dir to be sure there are no hidden dotfiles

ls -a MusicApps

.  ..  Loops

ls -a "MusicApps/Loops/loops/Acid Loops/Bass"

.  ..

> ls -id on the dir to see if it is inode 184549517

ls -id "MusicApps/Loops/loops/Acid Loops/Bass"

184549517 MusicApps/Loops/loops/Acid Loops/Bass

>
> -Eric
