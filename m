Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 01:20:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5J8Kdne006071
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:20:41 -0700
Received: from bay0-omc3-s17.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58E00CF398C
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:21:37 -0700 (PDT)
Received: from bay0-omc3-s17.bay0.hotmail.com (bay0-omc3-s17.bay0.hotmail.com [65.54.246.217]) by cuda.sgi.com with ESMTP id SSSnxwTbdAmCl98W for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 01:21:37 -0700 (PDT)
Message-ID: <BAY103-DAV10F6F255F26103152B312EB2AA0@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV69C0718B7EDB534D9337FB2A90@phx.gbl> <20080618161252.GV3700@disturbed> <BAY103-DAV10F0AFAC45572E50A384AB2AB0@phx.gbl> <20080619041441.GW3700@disturbed>
Subject: Re: XFS: 2.6.26-rc6 link count mismatch for inode
Date: Thu, 19 Jun 2008 10:20:56 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner wrote:

> Yeah, it sounds like the I/O subsystem hung somewhere. Without
> details I can't say what went wrong. If it happens again doing
> this:
>
> # echo w > /proc/sysrq-trigger

ok, thanks for the tip.

> To get a dump of all the blocked processes on the console. That
> may contain enough info to tell us what the problem is.
>
> Sure, go ahead and fix it up.

right now, I'm not able to reproduce the bug anymore.
Thanks for the support Dave.
BTW, this is the xfs_repair output:

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
b77dcb90: Badness in key lookup (length)
bp=(bno 5280, len 16384 bytes) key=(bno 5280, len 8192 bytes)
imap claims a free inode 70353 is in use, correcting imap and clearing
inode
cleared inode 70353
imap claims a free inode 98831 is in use, correcting imap and clearing
inode
cleared inode 98831
b5659b90: Badness in key lookup (length)
bp=(bno 5655872, len 16384 bytes) key=(bno 5655872, len 8192 bytes)
        - agno = 1
b4bffb90: Badness in key lookup (length)
bp=(bno 10238304, len 16384 bytes) key=(bno 10238304, len 8192 bytes)
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
imap claims a free inode 85450805 is in use, correcting imap and
clearing inode
cleared inode 85450805
imap claims a free inode 85450806 is in use, correcting imap and
clearing inode
cleared inode 85450806
imap claims a free inode 85450807 is in use, correcting imap and
clearing inode
cleared inode 85450807
imap claims a free inode 85450808 is in use, correcting imap and
clearing inode
cleared inode 85450808
imap claims a free inode 85450809 is in use, correcting imap and
clearing inode
cleared inode 85450809
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
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
entry ".deps" in shortform directory 19893187 references free inode
70353
junking entry ".deps" in directory inode 19893187
        - agno = 2
        - agno = 3
        - agno = 4
        - agno = 5
entry "CVS" in shortform directory 67179727 references free inode
85450805
junking entry "CVS" in directory inode 67179727
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
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
disconnected inode 10573, moving to lost+found
disconnected inode 18086534, moving to lost+found
disconnected inode 18086535, moving to lost+found
disconnected inode 34026152, moving to lost+found
Phase 7 - verify and correct link counts...
resetting inode 19893187 nlinks from 3 to 2
resetting inode 67179727 nlinks from 3 to 2
done
