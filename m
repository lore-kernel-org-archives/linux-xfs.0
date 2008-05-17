Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 May 2008 14:17:10 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4HLH7as032510
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 14:17:07 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2713D16E0927
	for <xfs@oss.sgi.com>; Sat, 17 May 2008 14:17:54 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id L03NrrriZ5fkuB6G for <xfs@oss.sgi.com>; Sat, 17 May 2008 14:17:54 -0700 (PDT)
Date: Sat, 17 May 2008 14:17:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
In-Reply-To: <200805172109.59244.alistair@devzero.co.uk>
Message-ID: <alpine.LFD.1.10.0805171411250.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <200805171922.56272.alistair@devzero.co.uk> <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org> <200805172109.59244.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com, Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org



On Sat, 17 May 2008, Alistair John Strachan wrote:
> 
> I actually had the opposite problem, too little was showing. I guess this is
> because the log level the "SysRq : Show Blocked State" bit goes out on is
> higher than the level of the actual result, so it was being trapped by sysklogd.

Ahh, yeah, I hate how all the distro's hide the default messages. Bad, 
bad.

> Regardless, I managed to get a log. Thanks for the help Linus..
> 
> Both XFS and md are showing up:

Ok, looks like block device breakage, possibly MD-related.

> [4294293.003500] SysRq : Show Blocked State
> [4294293.003500]   task                        PC stack   pid father
> [4294293.003500] pdflush       D 0000000000000002     0   191      2
> [4294293.003500]  ffff81007cee1660 0000000000000046 0000000000000082 0000000000000001
> [4294293.003500]  0000000000000001 ffff81007cee1610 ffff81007cee15e0 ffffffff80625dc0
> [4294293.003500]  ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0
> [4294293.003500] Call Trace:
> [4294293.003500]  [<ffffffff803f5256>] ? raid5_unplug_device+0xdd/0xe6
> [4294293.003500]  [<ffffffff8047a79e>] io_schedule+0x28/0x33
> [4294293.003500]  [<ffffffff8025f5cd>] sync_page+0x3f/0x43
> [4294293.003500]  [<ffffffff8047aa31>] __wait_on_bit+0x45/0x77
> [4294293.003500]  [<ffffffff8025f58e>] ? sync_page+0x0/0x43
> [4294293.003500]  [<ffffffff8025f835>] wait_on_page_bit+0x6f/0x76

Looks like something is waiting for IO to complete, and it never does. 
Which indicates the block layer. And yes, likely some race in unplugging.

And while it is waiting, it is holding the XFS locks, because this was 
brought on by a low-memory situation:

> [4294293.003500]  [<ffffffff8028106a>] __kmalloc+0x3e/0xe6
> [4294293.003500]  [<ffffffff803067fc>] ? xfs_iflush_int+0x272/0x2fb
> [4294293.003500]  [<ffffffff80320552>] kmem_alloc+0x6a/0xd1
> [4294293.003500]  [<ffffffff80307a9c>] xfs_iflush_cluster+0x4b/0x33f
> [4294293.003500]  [<ffffffff8030681e>] ? xfs_iflush_int+0x294/0x2fb
> [4294293.003500]  [<ffffffff80307f4b>] xfs_iflush+0x1bb/0x29d
> [4294293.003500]  [<ffffffff8031bc30>] xfs_inode_flush+0xb8/0xdd
> [4294293.003500]  [<ffffffff80328b1f>] xfs_fs_write_inode+0x30/0x4c

And as a result, all the XFS stuff is then waiting for that lock which is 
held by pdflush above:

> [4294293.003500] xfsdatad/0    D ffffffff8032085b     0   249      2
> [4294293.003500]  ffff81007bd0bd70 0000000000000046 0000000000000002 0000000000000000
> [4294293.003500]  ffff81007839c0d0 ffff81007bd0bd20 ffffffff8024660e ffffffff80625dc0
> [4294293.003500]  ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0 ffffffff80625dc0
> [4294293.003500] Call Trace:
> [4294293.003500]  [<ffffffff8047c49d>] __down_write_nested+0x91/0xab
> [4294293.003500]  [<ffffffff8047c4c2>] __down_write+0xb/0xd
> [4294293.003500]  [<ffffffff80246e66>] down_write_nested+0x2b/0x2f
> [4294293.003500]  [<ffffffff8030320e>] xfs_ilock+0x5b/0x79

Jens, there's been a *lot* of breakage in the block layer. The DMA bounce 
buffer crap, and this looks like the atomic bit setting was broken too.

Alistair, does the problem go away if you revert both the patch from Neil 
and the original patch that caused the need for that patch to begin with 
(ie commit 75ad23bc0fcb4f992a5d06982bf0857ab1738e9e "block: make queue 
flags non-atomic").

Jens, Nick, I think that whole series just needs to be undone.

		Linus
