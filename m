Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 06:59:43 -0700 (PDT)
Received: from bay0-omc1-s13.bay0.hotmail.com (bay0-omc1-s13.bay0.hotmail.com [65.54.246.85])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l58DxcWt010121
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 06:59:40 -0700
Message-ID: <BAY103-DAV141D991980E54836534A00B2250@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com> <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl> <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl> <20070320064632.GO32602149@melbourne.sgi.com> <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl> <20070607130505.GE85884050@sgi.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Date: Fri, 8 Jun 2007 15:59:39 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Marco Berizzi <pupilla@hotmail.com>

David Chinner wrote:

> > Jun  6 09:47:09 Pleiadi kernel:  =======================
> > Jun  6 09:47:09 Pleiadi kernel: 0x0: 28 f1 45 d4 22 53 35 11 09 80
37 5a
> > 47 8a 22 ee
> > Jun  6 09:47:09 Pleiadi kernel: Filesystem "sda8": XFS internal
error
> > xfs_da_do_buf(2) at line 2086 of file fs/xfs/xfs_da_btree.c.  Caller
> > 0xc01b2301
> > Jun  6 09:47:09 Pleiadi kernel:  [<c01b21f7>]
xfs_da_do_buf+0x70c/0x7b1
> > Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>]
xfs_da_read_buf+0x30/0x35
> > Jun  6 09:47:09 Pleiadi kernel:  [<c01b2301>]
xfs_da_read_buf+0x30/0x35
>
> These above stack trace is the sign of a corrupted directory.
>
> Chopping out the rest of the top posting (please don't do that)

apologies

> we get down to 3 months ago:
>
> > > On Mon, Mar 19, 2007 at 11:32:27AM +0100, Marco Berizzi wrote:
> > > > Marco Berizzi wrote:
> > > > Here is the relevant results:
> > > >
> > > > Phase 2 - found root inode chunk
> > > > Phase 3 - ...
> > > >             agno = 0
> > > >             ...
> > > >             agno = 12
> > > > LEAFN node level is 1 inode 1610612918 bno = 8388608
> > >
> > > Hmmm - single bit error in the bno - that reminds of this:
> > >
> > > http://oss.sgi.com/projects/xfs/faq.html#dir2
> > >
> > > So I'd definitely make sure that is repaired....
>
> Where we saw signs of on disk directory corruption. Have you run
> xfs_repair successfully on the filesystem since you reported
> this?

yes.

> If you did clean up the error, does xfs_repair report the same sort
> of error again?

I have run xfs_repair this morning.
Here is the report:

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

> Have you run a 2.6.16-rcX or 2.6.17.[0-6] kernel since you last
> reported this problem?

No. I have run only 2.6.19.x and 2.6.21.x

After the xfs_repair I have remounted the file system.
After few hours linux has crashed with this message:
BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
I have also the monitor bitmap.
