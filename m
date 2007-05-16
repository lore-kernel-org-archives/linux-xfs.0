Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 May 2007 09:05:08 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4GG52fB013061
	for <linux-xfs@oss.sgi.com>; Wed, 16 May 2007 09:05:04 -0700
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1HoL3m-0003Ql-FP
	for linux-xfs@oss.sgi.com; Wed, 16 May 2007 17:05:02 +0200
Received: from ns1.q-leap.de ([153.94.51.193])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 16 May 2007 17:05:02 +0200
Received: from bschubert by ns1.q-leap.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 16 May 2007 17:05:02 +0200
From: Bernd Schubert <bschubert@q-leap.de>
Subject: possible recursive locking detected
Date: Wed, 16 May 2007 16:50:08 +0200
Message-ID: <f2f5n0$1ja$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

with 2.6.20 and almost all debugging options I get this:

[  293.840172] =============================================
[  293.847880] [ INFO: possible recursive locking detected ]
[  293.853862] 2.6.20.3-debug #11
[  293.857288] ---------------------------------------------
[  293.863243] dd/6202 is trying to acquire lock:
[  293.868192]  (&(&ip->i_lock)->mr_lock){----}, at: [<ffffffff881693a6>] xfs_ilock+0x56/0x7a [xfs]
[  293.878200]
[  293.878201] but task is already holding lock:
[  293.884788]  (&(&ip->i_lock)->mr_lock){----}, at: [<ffffffff881693a6>] xfs_ilock+0x56/0x7a [xfs]
[  293.894802]
[  293.894803] other info that might help us debug this:
[  293.902116] 2 locks held by dd/6202:
[  293.906114]  #0:  (&inode->i_mutex){--..}, at: [<ffffffff804adbbd>] mutex_lock+0x23/0x27
[  293.915438]  #1:  (&(&ip->i_lock)->mr_lock){----}, at: [<ffffffff881693a6>] xfs_ilock+0x56/0x7a [xfs]
[  293.925977]
[  293.925978] stack backtrace:
[  293.930948]
[  293.930949] Call Trace:
[  293.935457]  [<ffffffff8024325a>] __lock_acquire+0x44d/0xc60
[  293.941707]  [<ffffffff80242699>] mark_held_locks+0x5a/0x71
[  293.956483]  [<ffffffff881693a6>] :xfs:xfs_ilock+0x56/0x7a
[  293.962537]  [<ffffffff80243e94>] lock_acquire+0x7c/0xa0
[  293.968447]  [<ffffffff881693a6>] :xfs:xfs_ilock+0x56/0x7a
[  293.974510]  [<ffffffff8023f6cb>] down_write+0x33/0x3f
[  293.980236]  [<ffffffff881693a6>] :xfs:xfs_ilock+0x56/0x7a
[  293.986315]  [<ffffffff88169895>] :xfs:xfs_iget+0x43c/0x7a8
[  293.992509]  [<ffffffff8817f4ad>] :xfs:xfs_trans_iget+0xa9/0x115
[  293.999177]  [<ffffffff8816aa74>] :xfs:xfs_ialloc+0x91/0x453
[  294.005475]  [<ffffffff8817fd6a>] :xfs:xfs_dir_ialloc+0x74/0x286
[  294.012145]  [<ffffffff88184b4b>] :xfs:xfs_create+0x347/0x626
[  294.018532]  [<ffffffff8818ee57>] :xfs:xfs_vn_mknod+0x1e2/0x432
[  294.025077]  [<ffffffff8023f733>] up_read+0x24/0x28
[  294.030501]  [<ffffffff88169f69>] :xfs:xfs_iunlock+0x74/0x79
[  294.036788]  [<ffffffff881837d1>] :xfs:xfs_access+0x43/0x4e
[  294.042943]  [<ffffffff80243a15>] __lock_acquire+0xc08/0xc60
[  294.049200]  [<ffffffff804afa5b>] _spin_unlock_irqrestore+0x3f/0x47
[  294.056083]  [<ffffffff80242699>] mark_held_locks+0x5a/0x71
[  294.062239]  [<ffffffff804afa5b>] _spin_unlock_irqrestore+0x3f/0x47
[  294.069138]  [<ffffffff802428a5>] trace_hardirqs_on+0x129/0x154
[  294.075690]  [<ffffffff881837d1>] :xfs:xfs_access+0x43/0x4e
[  294.081883]  [<ffffffff8818f0b2>] :xfs:xfs_vn_create+0xb/0xd
[  294.088139]  [<ffffffff80281eeb>] vfs_create+0xb7/0xfb
[  294.093826]  [<ffffffff80282342>] open_namei+0x1d1/0x6d3
[  294.099717]  [<ffffffff80243a15>] __lock_acquire+0xc08/0xc60
[  294.105970]  [<ffffffff80278796>] do_filp_open+0x5b/0x7e
[  294.111851]  [<ffffffff80278b2a>] do_sys_open+0x4d/0xd4
[  294.117636]  [<ffffffff80278bcc>] sys_open+0x1b/0x1d
[  294.123128]  [<ffffffff8020965e>] system_call+0x7e/0x83
[  294.128913]

Thanks,
Bernd
