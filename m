Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44346 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933404AbeF2GQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jun 2018 02:16:54 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w5T6EAGj040560
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jun 2018 02:16:54 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2jwdh1c7jt-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jun 2018 02:16:53 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 29 Jun 2018 07:16:51 +0100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: xfs: Deadlock between fs_reclaim and sb_internal
Date: Fri, 29 Jun 2018 11:48:39 +0530
In-Reply-To: <ee795573-6ab3-361a-d076-b464293bdcc4@linux.ibm.com>
References: <ee795573-6ab3-361a-d076-b464293bdcc4@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1583499.AKrs7invYa@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: darrick.wong@oracle.com, lkml <linux-kernel@vger.kernel.org>, allison.henderson@oracle.com, hch@lst.de, Michael Ellerman <mpe@ellerman.id.au>, linux-xfs@vger.kernel.org

On Thursday, June 28, 2018 9:31:32 AM IST Ravi Bangoria wrote:
> Hello Darrick,
> 
> Lockdep is reporting a deadlock with following trace. Saw this on my
> powerpc vm with 4GB of ram, running Linus/master kernel. Though, I
> don't have exact testcase to reproduce it. Is this something known?

I am able to recreate this issue on a ppc64le guest. I will debug this
and provide updates.

> 
> 
> [ 1797.620389] ======================================================
> [ 1797.620541] WARNING: possible circular locking dependency detected
> [ 1797.620695] 4.18.0-rc2+ #2 Not tainted
> [ 1797.620791] ------------------------------------------------------
> [ 1797.620942] kswapd0/362 is trying to acquire lock:
> [ 1797.621067] 0000000001ad2774 (sb_internal){.+.+}, at: xfs_trans_alloc+0x284/0x360 [xfs]
> [ 1797.621616] 
> [ 1797.621616] but task is already holding lock:
> [ 1797.621779] 00000000bb0609ea (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x10/0x60
> [ 1797.622090] 
> [ 1797.622090] which lock already depends on the new lock.
> [ 1797.622090] 
> [ 1797.622266] 
> [ 1797.622266] the existing dependency chain (in reverse order) is:
> [ 1797.622440] 
> [ 1797.622440] -> #1 (fs_reclaim){+.+.}:
> [ 1797.622609]        fs_reclaim_acquire.part.22+0x44/0x60
> [ 1797.622764]        kmem_cache_alloc+0x60/0x500
> [ 1797.622983]        kmem_zone_alloc+0xb4/0x168 [xfs]
> [ 1797.623220]        xfs_trans_alloc+0xac/0x360 [xfs]
> [ 1797.623454]        xfs_vn_update_time+0x278/0x420 [xfs]
> [ 1797.623576]        touch_atime+0xfc/0x120
> [ 1797.623668]        generic_file_read_iter+0x95c/0xbd0
> [ 1797.623948]        xfs_file_buffered_aio_read+0x98/0x2e0 [xfs]
> [ 1797.624190]        xfs_file_read_iter+0xac/0x170 [xfs]
> [ 1797.624304]        __vfs_read+0x128/0x1d0
> [ 1797.624388]        vfs_read+0xbc/0x1b0
> [ 1797.624476]        kernel_read+0x60/0xa0
> [ 1797.624562]        prepare_binprm+0xf8/0x1f0
> [ 1797.624676]        __do_execve_file.isra.13+0x7ac/0xc80
> [ 1797.624791]        sys_execve+0x58/0x70
> [ 1797.624880]        system_call+0x5c/0x70
> [ 1797.624965] 
> [ 1797.624965] -> #0 (sb_internal){.+.+}:
> [ 1797.625119]        lock_acquire+0xec/0x310
> [ 1797.625204]        __sb_start_write+0x18c/0x290
> [ 1797.625435]        xfs_trans_alloc+0x284/0x360 [xfs]
> [ 1797.625692]        xfs_iomap_write_allocate+0x230/0x470 [xfs]
> [ 1797.625945]        xfs_map_blocks+0x1a8/0x610 [xfs]
> [ 1797.626181]        xfs_do_writepage+0x1a8/0x9e0 [xfs]
> [ 1797.626414]        xfs_vm_writepage+0x4c/0x78 [xfs]
> [ 1797.626527]        pageout.isra.17+0x180/0x680
> [ 1797.626640]        shrink_page_list+0xe0c/0x1470
> [ 1797.626758]        shrink_inactive_list+0x3a4/0x890
> [ 1797.626872]        shrink_node_memcg+0x268/0x790
> [ 1797.626986]        shrink_node+0x124/0x630
> [ 1797.627089]        balance_pgdat+0x1f0/0x550
> [ 1797.627204]        kswapd+0x214/0x8c0
> [ 1797.627301]        kthread+0x1b8/0x1c0
> [ 1797.627389]        ret_from_kernel_thread+0x5c/0x88
> [ 1797.627509] 
> [ 1797.627509] other info that might help us debug this:
> [ 1797.627509] 
> [ 1797.627684]  Possible unsafe locking scenario:
> [ 1797.627684] 
> [ 1797.627820]        CPU0                    CPU1
> [ 1797.627965]        ----                    ----
> [ 1797.628072]   lock(fs_reclaim);
> [ 1797.628166]                                lock(sb_internal);
> [ 1797.628308]                                lock(fs_reclaim);
> [ 1797.628453]   lock(sb_internal);
> [ 1797.628551] 
> [ 1797.628551]  *** DEADLOCK ***
> [ 1797.628551] 
> [ 1797.628693] 1 lock held by kswapd0/362:
> [ 1797.628779]  #0: 00000000bb0609ea (fs_reclaim){+.+.}, at: __fs_reclaim_acquire+0x10/0x60
> [ 1797.628955] 
> [ 1797.628955] stack backtrace:
> [ 1797.629067] CPU: 18 PID: 362 Comm: kswapd0 Not tainted 4.18.0-rc2+ #2
> [ 1797.629199] Call Trace:
> [ 1797.629311] [c0000000f4ebaff0] [c000000000cc4414] dump_stack+0xe8/0x164 (unreliable)
> [ 1797.629473] [c0000000f4ebb040] [c0000000001a9f54] print_circular_bug.isra.17+0x284/0x3d0
> [ 1797.629639] [c0000000f4ebb0e0] [c0000000001aed58] __lock_acquire+0x1d48/0x2020
> [ 1797.629797] [c0000000f4ebb260] [c0000000001af7cc] lock_acquire+0xec/0x310
> [ 1797.629933] [c0000000f4ebb330] [c000000000454c5c] __sb_start_write+0x18c/0x290
> [ 1797.630191] [c0000000f4ebb380] [d000000009b7896c] xfs_trans_alloc+0x284/0x360 [xfs]
> [ 1797.630443] [c0000000f4ebb3e0] [d000000009b58958] xfs_iomap_write_allocate+0x230/0x470 [xfs]
> [ 1797.630710] [c0000000f4ebb560] [d000000009b2c760] xfs_map_blocks+0x1a8/0x610 [xfs]
> [ 1797.630961] [c0000000f4ebb5d0] [d000000009b2eb20] xfs_do_writepage+0x1a8/0x9e0 [xfs]
> [ 1797.631223] [c0000000f4ebb6b0] [d000000009b2f3a4] xfs_vm_writepage+0x4c/0x78 [xfs]
> [ 1797.631384] [c0000000f4ebb720] [c0000000003692e0] pageout.isra.17+0x180/0x680
> [ 1797.631557] [c0000000f4ebb800] [c00000000036ccfc] shrink_page_list+0xe0c/0x1470
> [ 1797.631730] [c0000000f4ebb920] [c00000000036e064] shrink_inactive_list+0x3a4/0x890
> [ 1797.631912] [c0000000f4ebb9f0] [c00000000036ef48] shrink_node_memcg+0x268/0x790
> [ 1797.632078] [c0000000f4ebbb00] [c00000000036f594] shrink_node+0x124/0x630
> [ 1797.632213] [c0000000f4ebbbd0] [c0000000003714e0] balance_pgdat+0x1f0/0x550
> [ 1797.632350] [c0000000f4ebbcd0] [c000000000371a54] kswapd+0x214/0x8c0
> [ 1797.632488] [c0000000f4ebbdc0] [c0000000001506b8] kthread+0x1b8/0x1c0
> [ 1797.632624] [c0000000f4ebbe30] [c00000000000c3d4] ret_from_kernel_thread+0x5c/0x88
> 
> 
> Thanks,
> Ravi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
chandan

