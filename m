Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 203D27F55
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 13:56:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A25C4AC00C
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 11:56:40 -0800 (PST)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id IHMtfH3fjlzV6lPC for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 11:56:37 -0800 (PST)
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 9A32C3DB2D
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 20:56:36 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 7B8A33DAAC
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 20:56:36 +0100 (CET)
Date: Thu, 13 Feb 2014 11:56:36 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: 3.14-rc2: RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected
In-Reply-To: <alpine.DEB.2.19.4.1402120008320.6233@trent.utfs.org>
Message-ID: <alpine.DEB.2.19.4.1402131153300.6233@trent.utfs.org>
References: <alpine.DEB.2.19.4.1402120008320.6233@trent.utfs.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Wed, 12 Feb 2014 at 00:11, Christian Kujau wrote:
> After upgrading from 3.13-rc8 to 3.14-rc2 on this PowerPC G4 machine, this 
> happened:

Yesterday a slighly different lockdep warning was printed:

 =========================================================
 [ INFO: possible irq lock inversion dependency detected ]
 3.14.0-rc2 #1 Tainted: G        W   
 ---------------------------------------------------------
 kswapd0/279 just changed the state of lock:
  (&(&ip->i_lock)->mr_lock){++++.?}, at: [<c01c213c>] 
xfs_free_eofblocks+0xe8/0x2e0
 but this lock took another, RECLAIM_FS-unsafe lock in the past:
  (&mm->mmap_sem){++++++}
 
 and interrupts could create inverse lock ordering between them.
 
 
 other info that might help us debug this:
  Possible interrupt unsafe locking scenario:
 
        CPU0                    CPU1
        ----                    ----
   lock(&mm->mmap_sem);
                                local_irq_disable();
                                lock(&(&ip->i_lock)->mr_lock);
                                lock(&mm->mmap_sem);
   <Interrupt>
     lock(&(&ip->i_lock)->mr_lock);
 
  *** DEADLOCK ***
 
 2 locks held by kswapd0/279:
  #0:  (shrinker_rwsem){++++..}, at: [<c00a5218>] shrink_slab+0x40/0x13c
  #1:  (&type->s_umount_key#36){+++++.}, at: [<c00d4840>] grab_super_passive+0x54/0xc0
 the shortest dependencies between 2nd lock and 1st lock:
  -> (&mm->mmap_sem){++++++} ops: 58148911 {
     HARDIRQ-ON-W at:
                       [<c0066b38>] lock_acquire+0x4c/0x68
                       [<c0558724>] down_write+0x4c/0x98
                       [<c00d88fc>] do_execve+0x2dc/0x574
                       [<c000425c>] try_to_run_init_process+0x18/0x58
                       [<c0004a48>] kernel_init+0xac/0x104
                       [<c0010ae4>] ret_from_kernel_thread+0x5c/0x64


...and on it goes, full dmesg: http://nerdbynature.de/bits/3.14-rc2/mm/

Thanks,
Christian.
-- 
BOFH excuse #65:

system needs to be rebooted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
