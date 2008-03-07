Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Mar 2008 14:40:41 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m27MeKnB008259
	for <xfs@oss.sgi.com>; Fri, 7 Mar 2008 14:40:24 -0800
Date: Sat, 8 Mar 2008 09:40:40 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Message-ID: <20080307224040.GV155259@sgi.com>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Mar 07, 2008 at 09:32:57PM +0100, Christian Kujau wrote:
> Hi,
> 
> after upgrading from 2.6.24.1 to 2.6.25-rc3, I came across[0]. This 
> warning seems to be gone now. With 2.6.25-rc4 (and the fix from [1])
> the box was running fine for 20 hours or so (doing its usual jobs plus 
> a "make randconfig && make" loop).
> 
> After this, I noticed that /bin/sync would not exit anymore and
> remains stuck in D state. Looking around I noticed that the rsync
> backup jobs (rsync'ing to an xfs partition) from earlier this
> morning did not exit either and hung in D state. With sync hung, the 
> following messages started to appear:
> 
> [75377.756985] INFO: task sync:2697 blocked for more than 120 seconds.
> [75377.757579] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
> this message.
> [75377.758211] sync          D c013835c     0  2697  16457
> [75377.758216]        f59506c0 00000082 f4c34000 c013835c fffeffff f6c1bcb0 
> f5dd0000 f4c34000 [75377.758223]        c04405d7 f53f7e98 f6c1bcb4 f6c1bcd0 
> 00000000 f6c1bcb0 00000000 f7ca1090 [75377.758230]        f4c34000 c044070a 
> f6c1bcd0 f6c1bcd0 f5dd0000 00000001 f6c1bcb0 c044074b [75377.758237] Call 
> Trace:
> [75377.758253]  [<c013835c>] trace_hardirqs_on+0x9c/0x110
> [75377.758269]  [<c04405d7>] rwsem_down_failed_common+0x67/0x150
> [75377.758279]  [<c044070a>] rwsem_down_read_failed+0x1a/0x24
> [75377.758286]  [<c044074b>] call_rwsem_down_read_failed+0x7/0xc
> [75377.758291]  [<c012fd7c>] down_read_nested+0x4c/0x60
> [75377.758295]  [<c027a64b>] xfs_ilock+0x5b/0xb0
> [75377.758301]  [<c027a64b>] xfs_ilock+0x5b/0xb0
> [75377.758306]  [<c029693d>] xfs_sync_inodes+0x3dd/0x6b0
> [75377.758314]  [<c0440b14>] _spin_unlock+0x14/0x20
> [75377.758325]  [<c0296d9b>] xfs_syncsub+0x18b/0x300
> [75377.758330]  [<c0440b14>] _spin_unlock+0x14/0x20
> [75377.758335]  [<c02a7c2b>] xfs_fs_sync_super+0x2b/0xd0
> [75377.758342]  [<c016a124>] sync_filesystems+0xa4/0x100
> [75377.758351]  [<c043fdd8>] down_read+0x38/0x50
> [75377.758356]  [<c016a13f>] sync_filesystems+0xbf/0x100
> [75377.758361]  [<c01872b3>] do_sync+0x33/0x70
> [75377.758366]  [<c0102ed7>] restore_nocheck+0x12/0x15
> [75377.758371]  [<c01872fa>] sys_sync+0xa/0x10
> [75377.758375]  [<c0102dee>] sysenter_past_esp+0x5f/0xa5
> [75377.758402]  =======================
> [75377.758405] 3 locks held by sync/2697:
> [75377.758407]  #0:  (mutex){--..}, at: [<c016a091>] 
> sync_filesystems+0x11/0x100
> [75377.758414]  #1:  (&type->s_umount_key#22){----}, at: [<c016a124>] 
> sync_filesystems+0xa4/0x100
> [75377.758422]  #2:  (&(&ip->i_iolock)->mr_lock){----}, at: [<c027a64b>] 
> xfs_ilock+0x5b/0xb0

Well, if that is hung there, something else must be holding on to
the iolock it's waiting on. What are the other D state processes in the
machine?

Also, the iolock can be held across I/O so it's possible you've lost an I/O.
Any I/O errors in the syslog?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
