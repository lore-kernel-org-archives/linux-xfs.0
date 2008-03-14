Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Mar 2008 16:57:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2ENvdnh015591
	for <xfs@oss.sgi.com>; Fri, 14 Mar 2008 16:57:41 -0700
Date: Sat, 15 Mar 2008 00:58:02 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
In-Reply-To: <47DA44EB.8000307@redhat.com>
Message-ID: <alpine.DEB.1.00.0803150044130.4696@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <20080309213441.GQ155407@sgi.com> <47DA44EB.8000307@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Milan Broz <mbroz@redhat.com>
Cc: David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com

On Fri, 14 Mar 2008, Milan Broz wrote:
> Yes, there is bug in dm-crypt...
> Please try if the patch here helps: http://lkml.org/lkml/2008/3/14/71

Hm, it seems to help the hangs, yes. Applied to today's -git a few hours 
ago, the hangs are gone. However, when doing lots of disk I/O, the machine 
locks up after a few (10-20) minutes. Sadly, netconsole got nothing :(

After the first lockup I tried again and shortly after bootup I got:

[  866.681441] [ INFO: possible circular locking dependency detected ]
[  866.681876] 2.6.25-rc5 #1
[  866.682203] -------------------------------------------------------
[  866.682637] kswapd0/132 is trying to acquire lock:
[  866.683028]  (&(&ip->i_iolock)->mr_lock){----}, at: [<c027a686>] xfs_ilock+0x96/0xb0
[  866.683916] 
[  866.683917] but task is already holding lock:
[  866.684582]  (iprune_mutex){--..}, at: [<c017b592>] shrink_icache_memory+0x72/0x220
[  866.685461] 
[  866.685462] which lock already depends on the new lock.
[  866.685463] 
[  866.686440] 
[  866.686441] the existing dependency chain (in reverse order) is:
[  866.687151] 
[  866.687152] -> #1 (iprune_mutex){--..}:
[  866.687339]        [<c0136914>] add_lock_to_list+0x44/0xc0
[  866.687339]        [<c01393a6>] __lock_acquire+0xc26/0x10b0
[  866.687339]        [<c017b592>] shrink_icache_memory+0x72/0x220
[  866.687339]        [<c013890f>] __lock_acquire+0x18f/0x10b0
[  866.687339]        [<c013988e>] lock_acquire+0x5e/0x80
[  866.687339]        [<c017b592>] shrink_icache_memory+0x72/0x220
[  866.687339]        [<c043fc79>] mutex_lock_nested+0x89/0x240
[  866.687339]        [<c017b592>] shrink_icache_memory+0x72/0x220
[  866.687339]        [<c017b592>] shrink_icache_memory+0x72/0x220
[  866.687339]        [<c017b592>] shrink_icache_memory+0x72/0x220
[  866.687339]        [<c0150051>] shrink_slab+0x21/0x160
[  866.687340]        [<c0150131>] shrink_slab+0x101/0x160
[  866.687340]        [<c01502e2>] try_to_free_pages+0x152/0x230
[  866.687340]        [<c014f060>] isolate_pages_global+0x0/0x60
[  866.687340]        [<c014b95b>] __alloc_pages+0x14b/0x370
[  866.687340]        [<c04413a0>] _read_unlock_irq+0x20/0x30
[  866.687340]        [<c0146601>] __grab_cache_page+0x81/0xc0
[  866.687340]        [<c01896f6>] block_write_begin+0x76/0xe0
[  866.687340]        [<c029ec76>] xfs_vm_write_begin+0x46/0x50
[  866.687340]        [<c029f4c0>] xfs_get_blocks+0x0/0x30
[  866.687340]        [<c0147297>] generic_file_buffered_write+0x117/0x650
[  866.687340]        [<c027a65d>] xfs_ilock+0x6d/0xb0
[  866.687340]        [<c02a73cc>] xfs_write+0x7ac/0x8a0
[  866.687340]        [<c0174ac1>] core_sys_select+0x21/0x350
[  866.687340]        [<c02a32bc>] xfs_file_aio_write+0x5c/0x70
[  866.687340]        [<c0167bf5>] do_sync_write+0xd5/0x120
[  866.687340]        [<c012c630>] autoremove_wake_function+0x0/0x40
[  866.687340]        [<c019cfd5>] dnotify_parent+0x35/0x90
[  866.687340]        [<c0167b20>] do_sync_write+0x0/0x120
[  866.687340]        [<c016846f>] vfs_write+0x9f/0x140
[  866.687340]        [<c0168a21>] sys_write+0x41/0x70
[  866.687340]        [<c0102dee>] sysenter_past_esp+0x5f/0xa5
[  866.687340]        [<ffffffff>] 0xffffffff
[  866.687340] 
[  866.687340] -> #0 (&(&ip->i_iolock)->mr_lock){----}:
[  866.687340]        [<c0136ba0>] print_circular_bug_entry+0x40/0x50

The box was running fine then for ~20 minutes, then it locked up again.

Full dmesg and .config: http://nerdbynature.de/bits/2.6.25-rc5/

Right now I'm back to 2.6.24.3...

Thanks,
Christian.
-- 
BOFH excuse #350:

paradigm shift...without a clutch
