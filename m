Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 13:45:16 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0ILj6CO027277
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 13:45:07 -0800
Received: from mail.g-house.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FF80C92A75
	for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 13:45:24 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75]) by cuda.sgi.com with ESMTP id zsbLoffF6koSEqAD for <xfs@oss.sgi.com>; Fri, 18 Jan 2008 13:45:24 -0800 (PST)
Date: Fri, 18 Jan 2008 22:45:17 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: 2.6.24-rc8: possible circular locking dependency detected
Message-ID: <alpine.DEB.1.00.0801182240310.6521@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: LKML <linux-kernel@vger.kernel.org>

Hi,

just FYI, upgrading to -rc8 gave the following messages in kern.log in
the morning hours, when the backups were run:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.24-rc8 #2
-------------------------------------------------------
rsync/23295 is trying to acquire lock:
  (iprune_mutex){--..}, at: [<c017a552>] shrink_icache_memory+0x72/0x220

but task is already holding lock:
  (&(&ip->i_iolock)->mr_lock){----}, at: [<c0275056>] xfs_ilock+0x96/0xb0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&ip->i_iolock)->mr_lock){----}:
        [<c0138c01>] __lock_acquire+0xbe1/0x10b0
        [<c0275056>] xfs_ilock+0x96/0xb0
        [<c0137b4f>] trace_hardirqs_on+0x9f/0x140
        [<c013912f>] lock_acquire+0x5f/0x80
        [<c0275056>] xfs_ilock+0x96/0xb0
        [<c012f4b1>] down_write_nested+0x41/0x60
        [<c0275056>] xfs_ilock+0x96/0xb0
        [<c0275056>] xfs_ilock+0x96/0xb0
        [<c02751ea>] xfs_ireclaim+0x1a/0x60
        [<c0294e73>] xfs_finish_reclaim+0x53/0x1a0
        [<c02a40ce>] xfs_fs_clear_inode+0x5e/0x90
        [<c017a102>] clear_inode+0x82/0x160
        [<c017a55c>] shrink_icache_memory+0x7c/0x220
        [<c017a43a>] dispose_list+0x1a/0xc0
        [<c017a6c2>] shrink_icache_memory+0x1e2/0x220
        [<c014f6d1>] shrink_slab+0x101/0x160
        [<c014fa4a>] kswapd+0x2aa/0x410
        [<c012c1f0>] autoremove_wake_function+0x0/0x40
        [<c014f7a0>] kswapd+0x0/0x410
        [<c012bf42>] kthread+0x42/0x70

Full dmesg and .config: http://nerdbynature.de/bits/2.6.24-rc8/

Thanks,
Christian.
-- 
BOFH excuse #18:

excess surge protection
