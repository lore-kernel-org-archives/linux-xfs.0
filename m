Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jan 2008 13:26:50 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0DLQhnC005314
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:26:47 -0800
Received: from harold.telenet-ops.be (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75DAF5150A6
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:27:00 -0800 (PST)
Received: from harold.telenet-ops.be (harold.telenet-ops.be [195.130.133.65]) by cuda.sgi.com with ESMTP id MUDHghIjkrgdTA2U for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 13:27:00 -0800 (PST)
From: "Grozdan Nikolov (openSUSE Linux)" <microchip@telenet.be>
Subject: Re: Cannot delete a directory on a XFS file system
Date: Sun, 13 Jan 2008 22:26:59 +0100
References: <200801131723.12626.microchip@telenet.be> <alpine.DEB.0.999999.0801131448070.17216@p34.internal.lan>
In-Reply-To: <alpine.DEB.0.999999.0801131448070.17216@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200801132226.59652.microchip@telenet.be>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Sunday 13 January 2008 20:49, you wrote:
> On Sun, 13 Jan 2008, Grozdan Nikolov (openSUSE Linux) wrote:
> > Hi,
> >
> > I have a small problem with XFS on a small 40 GB IDE disk that I use for
> > my music collection. The disk (/dev/hdb) has only one partition on it
> > formatted as XFS. On this partition, there is a directory that no matter
> > what I do, I cannot delete it. I tried everything, in Konqueror,
> > right-click on the directory and choose to delete it. As root on the
> > console
> > doing "rm -rf /media/data/DATA/MusicApps" ... but nothing works.
> >
> > When I try to "rm -rf" on this directory I get a message saying...
> >
> > rm: cannot remove directory `MusicApps/Loops/loops/Acid Loops/Bass':
> > Directory not empty
> >
> > But the "Bass" directory is completely empty, there's nothing in there.
> > Also when I unmount the file system and do a "xfs_check /dev/hdb1" I get
> > a message saying...
> >
> > link count mismatch for inode 184549517 (name ?), nlink 3, counted 2
> >
> > I did several times "xfs_repair /dev/hdb1" but I still get the same
> > result. xfs_check reports the same message and I still can't get rid of
> > this empty directory. I'm using kernel 2.6.24-rc7, but it's the same with
> > other kernels. I also did check the partition for bad block with the
> > "badblocks" program, but nothing came out, so the disk is just fine.
> >
> > Any ideas how I can delete this directory?
>
> The developers get in on Monday :P
>
> But some things they will ask:
>
> 1. run xfs_info /dev/hdb1

meta-data=/dev/hdb1              isize=256    agcount=16, agsize=610595 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=9769520, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=4770, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0

> 2. run (and capture the full output from the repair process)

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - clear lost+found (if it exists) ...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
        - agno = 6
        - agno = 7
        - agno = 8
        - agno = 9
        - agno = 10
        - agno = 11
        - agno = 12
        - agno = 13
        - agno = 14
        - agno = 15
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - ensuring existence of lost+found directory
        - traversing filesystem starting at / ...
        - traversal finished ...
        - traversing all unattached subtrees ...
        - traversals finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

> 3. run ls -lR on the dir that has problems

MusicApps:
total 0
drwxr-xr-x 3 microchip users 18 2007-12-16 02:02 Loops

MusicApps/Loops:
total 0
drwxr-xr-x 3 microchip users 23 2007-12-16 02:02 loops

MusicApps/Loops/loops:
total 0
drwxr-xr-x 3 microchip users 17 2007-12-16 02:02 Acid Loops

MusicApps/Loops/loops/Acid Loops:
total 0
drwxr-xr-x 3 microchip users 6 2007-12-16 02:02 Bass

MusicApps/Loops/loops/Acid Loops/Bass:
total 0

> 4. run ls -li on the director(ies) that cannot be deleted for the inode #s

total 0
201326732 drwxr-xr-x 3 microchip users 18 2007-12-16 02:02 Loops

>
> If you give them this information in advance they'll have more info to
> help you.
>
> Justin.
