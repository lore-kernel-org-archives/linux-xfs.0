Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 May 2008 00:05:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4674pgG012114
	for <xfs@oss.sgi.com>; Tue, 6 May 2008 00:04:53 -0700
Received: from bay0-omc3-s41.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9D0AAB13A05
	for <xfs@oss.sgi.com>; Tue,  6 May 2008 00:05:36 -0700 (PDT)
Received: from bay0-omc3-s41.bay0.hotmail.com (bay0-omc3-s41.bay0.hotmail.com [65.54.246.241]) by cuda.sgi.com with ESMTP id VIkfb0nBmzzUSjCB for <xfs@oss.sgi.com>; Tue, 06 May 2008 00:05:36 -0700 (PDT)
Message-ID: <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com>
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper: page allocation failure. order:3, mode:0x4020)
Date: Tue, 6 May 2008 09:03:06 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

David Chinner wrote:

> [Please cc the XFS list (xfs@oss.sgi.com) on bug reports or put "XFS"
in the
> subject line so ppl know to pay attention to your report.]

ok sorry.

> On Mon, May 05, 2008 at 03:41:29PM +0200, Marco Berizzi wrote:
> > Hi.
> > Just few minutes ago an xfs filesystem
> > was shutdown with these errors:
> >
> > May  5 14:31:38 Pleiadi kernel: xfs_inotobp: xfs_imap()  returned an
> > error 22 on hda8.  Returning error.
> > May  5 14:31:38 Pleiadi kernel: xfs_iunlink_remove: xfs_inotobp()
> > returned an error 22 on hda8.  Returning error.
> > May  5 14:31:38 Pleiadi kernel: xfs_inactive:^Ixfs_ifree() returned
an
> > error = 22 on hda8
> > May  5 14:31:38 Pleiadi kernel: xfs_force_shutdown(hda8,0x1) called
from
> > line 1737 of file fs/xfs/xfs_vnodeops.c.  Return address =
0xc01e6fde
> > May  5 14:31:38 Pleiadi kernel: Filesystem "hda8": I/O Error
Detected.
> > Shutting down filesystem: hda8
> > May  5 14:31:38 Pleiadi kernel: Please umount the filesystem, and
> > rectify the problem(s)
> > May  5 14:36:43 Pleiadi kernel: xfs_force_shutdown(hda8,0x1) called
from
> > line 420 of file fs/xfs/xfs_rw.c.  Return address = 0xc01eaf21
>
> Is it reproducable?

honestly, I don't know. As you may see from the
dmesg output this box has been started on 24 april
and the crash has happened yesterday.

IMHO the crash happended because of this:
At 12:23 squid complain that there is no left space
on device, and it start to shrinking cache_dir, and
at 12:57 the kernel start logging...
This box is pretty slow (celeron) and the hda8 filesystem
is about 2786928 1k-blocks.

> What were you doing at the time the problem occurred?

this box is running squid (http proxy): hda8 is where
squid cache and logs are stored.
I haven't rebooted this box since the problem happened.
If you need ssh access just email me.
This is the output from xfs_repair:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is
being
destroyed because the -L option was used.
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
data fork in ino 351800 claims free block 25655
imap claims in-use inode 351800 is free, correcting imap
data fork in ino 755175 claims free block 47552
data fork in ino 755175 claims free block 47553
data fork in ino 755175 claims free block 47554
imap claims in-use inode 755175 is free, correcting imap
        - agno = 1
        - agno = 2
        - agno = 3
data fork in ino 6750465 claims free block 422290
imap claims in-use inode 6750465 is free, correcting imap
data fork in ino 6750520 claims free block 422467
data fork in ino 6750520 claims free block 422468
data fork in ino 6750520 claims free block 422469
data fork in ino 6750520 claims free block 422470
imap claims in-use inode 6750520 is free, correcting imap
        - agno = 4
        - agno = 5
data fork in ino 10787308 claims free block 681220
imap claims in-use inode 10787308 is free, correcting imap
data fork in ino 10787309 claims free block 681221
imap claims in-use inode 10787309 is free, correcting imap
data fork in ino 10842499 claims free block 677665
imap claims in-use inode 10842499 is free, correcting imap
data fork in ino 10870100 claims free block 679867
imap claims in-use inode 10870100 is free, correcting imap
data fork in ino 10895430 claims free block 681114
imap claims in-use inode 10895430 is free, correcting imap
data fork in ino 10895431 claims free block 681115
imap claims in-use inode 10895431 is free, correcting imap
        - agno = 6
data fork in ino 12986518 claims free block 813324
data fork in ino 12986518 claims free block 813325
data fork in ino 12986518 claims free block 813326
data fork in ino 12986518 claims free block 813327
data fork in ino 12986518 claims free block 813328
imap claims in-use inode 12986518 is free, correcting imap
        - agno = 7
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
disconnected inode 351800, moving to lost+found
disconnected inode 755175, moving to lost+found
disconnected inode 6750465, moving to lost+found
disconnected inode 6750520, moving to lost+found
disconnected inode 10787308, moving to lost+found
disconnected inode 10787309, moving to lost+found
disconnected inode 10842499, moving to lost+found
disconnected inode 10870100, moving to lost+found
disconnected inode 10895430, moving to lost+found
disconnected inode 10895431, moving to lost+found
disconnected inode 12986518, moving to lost+found
Phase 7 - verify and correct link counts...
done

PS: xfsprogs is 2.8.10 from slackware 11.0
