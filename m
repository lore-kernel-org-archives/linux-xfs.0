Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A0F9529E25
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 15:40:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EB423AC014
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 13:40:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Z2Wl7PiwL51ubY81 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 13:40:43 -0700 (PDT)
Message-ID: <53445EC0.9060707@oracle.com>
Date: Tue, 08 Apr 2014 16:40:32 -0400
From: Sasha Levin <sasha.levin@oracle.com>
MIME-Version: 1.0
Subject: Re: xfs i_lock vs mmap_sem lockdep trace.
References: <20140329223109.GA24098@redhat.com>
	<20140330234335.GB16336@dastard>
	<20140330235717.GO18016@ZenIV.linux.org.uk>
	<20140331004053.GA17603@dastard>
In-Reply-To: <20140331004053.GA17603@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 03/30/2014 08:40 PM, Dave Chinner wrote:
> On Mon, Mar 31, 2014 at 12:57:17AM +0100, Al Viro wrote:
>> > On Mon, Mar 31, 2014 at 10:43:35AM +1100, Dave Chinner wrote:
>>> > > filldir on a directory inode vs page fault on regular file. Known
>>> > > issue, definitely a false positive. We have to change locking
>>> > > algorithms to avoid such deficiencies of lockdep (a case of "lockdep
>>> > > considered harmful", perhaps?) so it's not something I'm about to
>>> > > rush...
>> > 
>> > Give i_lock on directories a separate class, as it's been done for i_mutex...
> Already done that. Commit:
> 
> 93a8614 xfs: fix directory inode iolock lockdep false positive

Hi Dave,

The commit above introduces a new lockdep issue for me:

[ 3162.917171] ======================================================
[ 3162.920402] [ INFO: RECLAIM_FS-READ-safe -> RECLAIM_FS-READ-unsafe lock order detected ]
[ 3162.934790] 3.14.0-next-20140408-sasha-00023-g06962b5 #384 Not tainted
[ 3162.934790] ------------------------------------------------------
[ 3162.934790] trinity-main/17183 [HC0[0]:SC0[0]:HE1:SE1] is trying to acquire:
[ 3162.934790] (&xfs_dir_ilock_class){++++..}, at: xfs_ilock (fs/xfs/mrlock.h:50 fs/xfs/xfs_inode.c:165)
[ 3162.934790]
[ 3162.934790] and this task is already holding:
[ 3162.934790] (sb_internal){.+.+.?}, at: xfs_trans_alloc (fs/xfs/xfs_trans.c:67)
[ 3162.934790] which would create a new lock dependency:
[ 3162.934790]  (sb_internal){.+.+.?} -> (&xfs_dir_ilock_class){++++..}
[ 3162.934790]
[ 3162.934790] but this new dependency connects a RECLAIM_FS-READ-irq-safe lock:
[ 3162.934790]  (sb_internal){.+.+.?}
... which became RECLAIM_FS-READ-irq-safe at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2821 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] __sb_start_write (fs/super.c:1187)
[ 3162.934790] xfs_trans_alloc (fs/xfs/xfs_trans.c:67)
[ 3162.934790] xfs_iomap_write_allocate (fs/xfs/xfs_iomap.c:689)
[ 3162.934790] xfs_map_blocks (fs/xfs/xfs_aops.c:340)
[ 3162.934790] xfs_vm_writepage (fs/xfs/xfs_aops.c:1081)
[ 3162.934790] shrink_page_list (mm/vmscan.c:503 mm/vmscan.c:1015)
[ 3162.934790] shrink_inactive_list (include/linux/spinlock.h:328 mm/vmscan.c:1503)
[ 3162.934790] shrink_lruvec (mm/vmscan.c:1830 mm/vmscan.c:2054)
[ 3162.934790] shrink_zone (mm/vmscan.c:2235)
[ 3162.934790] kswapd_shrink_zone (include/linux/nodemask.h:131 include/linux/nodemask.h:131 mm/vmscan.c:2894)
[ 3162.934790] kswapd (mm/vmscan.c:3080 mm/vmscan.c:3286)
[ 3162.934790] kthread (kernel/kthread.c:210)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]
[ 3162.934790] to a RECLAIM_FS-READ-irq-unsafe lock:
[ 3162.934790]  (&mm->mmap_sem){++++++}
... which became RECLAIM_FS-READ-irq-unsafe at:
[ 3162.934790] ... mark_held_locks (kernel/locking/lockdep.c:2523)
[ 3162.934790] lockdep_trace_alloc (kernel/locking/lockdep.c:2745 kernel/locking/lockdep.c:2760)
[ 3162.934790] __alloc_pages_nodemask (mm/page_alloc.c:2721)
[ 3162.934790] alloc_pages_current (mm/mempolicy.c:2131)
[ 3162.934790] pte_alloc_one (arch/x86/mm/pgtable.c:28)
[ 3162.934790] __pte_alloc (mm/memory.c:557)
[ 3162.934790] move_page_tables (mm/mremap.c:209 (discriminator 1))
[ 3162.934790] shift_arg_pages (fs/exec.c:607)
[ 3162.934790] setup_arg_pages (fs/exec.c:715)
[ 3162.934790] load_elf_binary (fs/binfmt_elf.c:745)
[ 3162.934790] search_binary_handler (fs/exec.c:1392)
[ 3162.934790] do_execve_common.isra.19 (fs/exec.c:1429 fs/exec.c:1525)
[ 3162.934790] do_execve (fs/exec.c:1568)
[ 3162.934790] run_init_process (init/main.c:818)
[ 3162.934790] kernel_init (init/main.c:866)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]
[ 3162.934790] other info that might help us debug this:
[ 3162.934790]
[ 3162.934790] Chain exists of:
sb_internal --> &xfs_dir_ilock_class --> &mm->mmap_sem

[ 3162.934790]  Possible interrupt unsafe locking scenario:
[ 3162.934790]
[ 3162.934790]        CPU0                    CPU1
[ 3162.934790]        ----                    ----
[ 3162.934790]   lock(&mm->mmap_sem);
[ 3162.934790]                                local_irq_disable();
[ 3162.934790]                                lock(sb_internal);
[ 3162.934790]                                lock(&xfs_dir_ilock_class);
[ 3162.934790]   <Interrupt>
[ 3162.934790]     lock(sb_internal);
[ 3162.934790]
[ 3162.934790]  *** DEADLOCK ***
[ 3162.934790]
[ 3162.934790] 3 locks held by trinity-main/17183:
[ 3162.934790] #0: (&type->i_mutex_dir_key#12){+.+.+.}, at: iterate_dir (fs/readdir.c:35)
[ 3162.934790] #1: (sb_writers#34){.+.+.+}, at: touch_atime (fs/inode.c:1550)
[ 3162.934790] #2: (sb_internal){.+.+.?}, at: xfs_trans_alloc (fs/xfs/xfs_trans.c:67)
[ 3162.934790]
the dependencies between RECLAIM_FS-READ-irq-safe lock and the holding lock:
[ 3162.934790] -> (sb_internal){.+.+.?} ops: 1021 {
[ 3162.934790]    HARDIRQ-ON-R at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2792 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] __sb_start_write (fs/super.c:1187)
[ 3162.934790] xfs_trans_alloc (fs/xfs/xfs_trans.c:67)
[ 3162.934790] xfs_create (fs/xfs/xfs_inode.c:1191)
[ 3162.934790] xfs_vn_mknod (fs/xfs/xfs_iops.c:161)
[ 3162.934790] xfs_vn_create (fs/xfs/xfs_iops.c:204)
[ 3162.934790] vfs_create (fs/namei.c:2505)
[ 3162.934790] do_last (fs/namei.c:2844 fs/namei.c:2929)
[ 3162.934790] path_openat (fs/namei.c:3181)
[ 3162.934790] do_filp_open (fs/namei.c:3230)
[ 3162.934790] do_sys_open (fs/open.c:1014)
[ 3162.934790] SyS_open (fs/open.c:1026)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]    SOFTIRQ-ON-R at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2804 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] __sb_start_write (fs/super.c:1187)
[ 3162.934790] xfs_trans_alloc (fs/xfs/xfs_trans.c:67)
[ 3162.934790] xfs_create (fs/xfs/xfs_inode.c:1191)
[ 3162.934790] xfs_vn_mknod (fs/xfs/xfs_iops.c:161)
[ 3162.934790] xfs_vn_create (fs/xfs/xfs_iops.c:204)
[ 3162.934790] vfs_create (fs/namei.c:2505)
[ 3162.934790] do_last (fs/namei.c:2844 fs/namei.c:2929)
[ 3162.934790] path_openat (fs/namei.c:3181)
[ 3162.934790] do_filp_open (fs/namei.c:3230)
[ 3162.934790] do_sys_open (fs/open.c:1014)
[ 3162.934790] SyS_open (fs/open.c:1026)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]    IN-RECLAIM_FS-R at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2821 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] __sb_start_write (fs/super.c:1187)
[ 3162.934790] xfs_trans_alloc (fs/xfs/xfs_trans.c:67)
[ 3162.934790] xfs_iomap_write_allocate (fs/xfs/xfs_iomap.c:689)
[ 3162.934790] xfs_map_blocks (fs/xfs/xfs_aops.c:340)
[ 3162.934790] xfs_vm_writepage (fs/xfs/xfs_aops.c:1081)
[ 3162.934790] shrink_page_list (mm/vmscan.c:503 mm/vmscan.c:1015)
[ 3162.934790] shrink_inactive_list (include/linux/spinlock.h:328 mm/vmscan.c:1503)
[ 3162.934790] shrink_lruvec (mm/vmscan.c:1830 mm/vmscan.c:2054)
[ 3162.934790] shrink_zone (mm/vmscan.c:2235)
[ 3162.934790] kswapd_shrink_zone (include/linux/nodemask.h:131 include/linux/nodemask.h:131 mm/vmscan.c:2894)
[ 3162.934790] kswapd (mm/vmscan.c:3080 mm/vmscan.c:3286)
[ 3162.934790] kthread (kernel/kthread.c:210)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]    RECLAIM_FS-ON-R at:
[ 3162.934790] mark_held_locks (kernel/locking/lockdep.c:2523)
[ 3162.934790] lockdep_trace_alloc (kernel/locking/lockdep.c:2745 kernel/locking/lockdep.c:2760)
[ 3162.934790] kmem_cache_alloc (mm/slub.c:965 mm/slub.c:2403 mm/slub.c:2476 mm/slub.c:2481)
[ 3162.934790] kmem_zone_alloc (fs/xfs/kmem.c:130)
[ 3162.934790] _xfs_trans_alloc (fs/xfs/xfs_trans.c:87 (discriminator 2))
[ 3162.934790] xfs_trans_alloc (fs/xfs/xfs_trans.c:68)
[ 3162.934790] xfs_create (fs/xfs/xfs_inode.c:1191)
[ 3162.934790] xfs_vn_mknod (fs/xfs/xfs_iops.c:161)
[ 3162.934790] xfs_vn_create (fs/xfs/xfs_iops.c:204)
[ 3162.934790] vfs_create (fs/namei.c:2505)
[ 3162.934790] do_last (fs/namei.c:2844 fs/namei.c:2929)
[ 3162.934790] path_openat (fs/namei.c:3181)
[ 3162.934790] do_filp_open (fs/namei.c:3230)
[ 3162.934790] do_sys_open (fs/open.c:1014)
[ 3162.934790] SyS_open (fs/open.c:1026)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]    INITIAL USE at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:3142)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] __sb_start_write (fs/super.c:1187)
[ 3162.934790] xfs_trans_alloc (fs/xfs/xfs_trans.c:67)
[ 3162.934790] xfs_create (fs/xfs/xfs_inode.c:1191)
[ 3162.934790] xfs_vn_mknod (fs/xfs/xfs_iops.c:161)
[ 3162.934790] xfs_vn_create (fs/xfs/xfs_iops.c:204)
[ 3162.934790] vfs_create (fs/namei.c:2505)
[ 3162.934790] do_last (fs/namei.c:2844 fs/namei.c:2929)
[ 3162.934790] path_openat (fs/namei.c:3181)
[ 3162.934790] do_filp_open (fs/namei.c:3230)
[ 3162.934790] do_sys_open (fs/open.c:1014)
[ 3162.934790] SyS_open (fs/open.c:1026)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]  }
[ 3162.934790] ... key at: xfs_fs_type (??:?)
[ 3162.934790]  ... acquired at:
[ 3162.934790] check_irq_usage (kernel/locking/lockdep.c:1638)
[ 3162.934790] __lock_acquire (kernel/locking/lockdep_states.h:9 kernel/locking/lockdep.c:1844 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_write_nested (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:143)
[ 3162.934790] xfs_ilock (fs/xfs/mrlock.h:50 fs/xfs/xfs_inode.c:165)
[ 3162.934790] xfs_vn_update_time (fs/xfs/xfs_iops.c:944)
[ 3162.934790] update_time (fs/inode.c:1502)
[ 3162.934790] touch_atime (fs/inode.c:1565)
[ 3162.934790] iterate_dir (include/linux/fs.h:1815 fs/readdir.c:43)
[ 3162.934790] SyS_getdents (fs/readdir.c:214 fs/readdir.c:193)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]
[ 3162.934790]
the dependencies between the lock to be acquired and RECLAIM_FS-READ-irq-unsafe lock:
[ 3162.934790]  -> (&mm->mmap_sem){++++++} ops: 217938150 {
[ 3162.934790]     HARDIRQ-ON-W at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2800 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_write (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:50)
[ 3162.934790] do_execve_common.isra.19 (fs/exec.c:259 fs/exec.c:374 fs/exec.c:1496)
[ 3162.934790] do_execve (fs/exec.c:1568)
[ 3162.934790] run_init_process (init/main.c:818)
[ 3162.934790] kernel_init (init/main.c:866)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]     HARDIRQ-ON-R at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2792 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] might_fault (mm/memory.c:4214)
[ 3162.934790] __clear_user (arch/x86/lib/usercopy_64.c:18 arch/x86/lib/usercopy_64.c:21)
[ 3162.934790] clear_user (arch/x86/lib/usercopy_64.c:54)
[ 3162.934790] padzero (fs/binfmt_elf.c:122)
[ 3162.934790] load_elf_binary (fs/binfmt_elf.c:894 (discriminator 1))
[ 3162.934790] search_binary_handler (fs/exec.c:1392)
[ 3162.934790] do_execve_common.isra.19 (fs/exec.c:1429 fs/exec.c:1525)
[ 3162.934790] do_execve (fs/exec.c:1568)
[ 3162.934790] run_init_process (init/main.c:818)
[ 3162.934790] kernel_init (init/main.c:866)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]     SOFTIRQ-ON-W at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2804 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_write (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:50)
[ 3162.934790] do_execve_common.isra.19 (fs/exec.c:259 fs/exec.c:374 fs/exec.c:1496)
[ 3162.934790] do_execve (fs/exec.c:1568)
[ 3162.934790] run_init_process (init/main.c:818)
[ 3162.934790] kernel_init (init/main.c:866)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]     SOFTIRQ-ON-R at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2804 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] might_fault (mm/memory.c:4214)
[ 3162.934790] __clear_user (arch/x86/lib/usercopy_64.c:18 arch/x86/lib/usercopy_64.c:21)
[ 3162.934790] clear_user (arch/x86/lib/usercopy_64.c:54)
[ 3162.934790] padzero (fs/binfmt_elf.c:122)
[ 3162.934790] load_elf_binary (fs/binfmt_elf.c:894 (discriminator 1))
[ 3162.934790] search_binary_handler (fs/exec.c:1392)
[ 3162.934790] do_execve_common.isra.19 (fs/exec.c:1429 fs/exec.c:1525)
[ 3162.934790] do_execve (fs/exec.c:1568)
[ 3162.934790] run_init_process (init/main.c:818)
[ 3162.934790] kernel_init (init/main.c:866)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]     RECLAIM_FS-ON-W at:
[ 3162.934790] mark_held_locks (kernel/locking/lockdep.c:2523)
[ 3162.934790] lockdep_trace_alloc (kernel/locking/lockdep.c:2745 kernel/locking/lockdep.c:2760)
[ 3162.934790] __alloc_pages_nodemask (mm/page_alloc.c:2721)
[ 3162.934790] alloc_pages_current (mm/mempolicy.c:2131)
[ 3162.934790] pte_alloc_one (arch/x86/mm/pgtable.c:28)
[ 3162.934790] __pte_alloc (mm/memory.c:557)
[ 3162.934790] move_page_tables (mm/mremap.c:209 (discriminator 1))
[ 3162.934790] shift_arg_pages (fs/exec.c:607)
[ 3162.934790] setup_arg_pages (fs/exec.c:715)
[ 3162.934790] load_elf_binary (fs/binfmt_elf.c:745)
[ 3162.934790] search_binary_handler (fs/exec.c:1392)
[ 3162.934790] do_execve_common.isra.19 (fs/exec.c:1429 fs/exec.c:1525)
[ 3162.934790] do_execve (fs/exec.c:1568)
[ 3162.934790] run_init_process (init/main.c:818)
[ 3162.934790] kernel_init (init/main.c:866)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]     RECLAIM_FS-ON-R at:
[ 3162.934790] mark_held_locks (kernel/locking/lockdep.c:2523)
[ 3162.934790] lockdep_trace_alloc (kernel/locking/lockdep.c:2745 kernel/locking/lockdep.c:2760)
[ 3162.934790] __alloc_pages_nodemask (mm/page_alloc.c:2721)
[ 3162.934790] alloc_pages_current (mm/mempolicy.c:2131)
[ 3162.934790] __get_free_pages (mm/page_alloc.c:2803)
[ 3162.934790] get_zeroed_page (mm/page_alloc.c:2812)
[ 3162.934790] __pud_alloc (mm/memory.c:3844)
[ 3162.934790] __handle_mm_fault (include/linux/mm.h:1368 mm/memory.c:3728)
[ 3162.934790] handle_mm_fault (mm/memory.c:3819)
[ 3162.934790] __do_page_fault (arch/x86/mm/fault.c:1220)
[ 3162.934790] do_page_fault (arch/x86/mm/fault.c:1272 include/linux/jump_label.h:105 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1273)
[ 3162.934790] do_async_page_fault (arch/x86/kernel/kvm.c:263)
[ 3162.934790] async_page_fault (arch/x86/kernel/entry_64.S:1496)
[ 3162.934790] clear_user (arch/x86/lib/usercopy_64.c:54)
[ 3162.934790] padzero (fs/binfmt_elf.c:122)
[ 3162.934790] load_elf_binary (fs/binfmt_elf.c:894 (discriminator 1))
[ 3162.934790] search_binary_handler (fs/exec.c:1392)
[ 3162.934790] do_execve_common.isra.19 (fs/exec.c:1429 fs/exec.c:1525)
[ 3162.934790] do_execve (fs/exec.c:1568)
[ 3162.934790] run_init_process (init/main.c:818)
[ 3162.934790] kernel_init (init/main.c:866)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]     INITIAL USE at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:3142)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_write (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:50)
[ 3162.934790] do_execve_common.isra.19 (fs/exec.c:259 fs/exec.c:374 fs/exec.c:1496)
[ 3162.934790] do_execve (fs/exec.c:1568)
[ 3162.934790] run_init_process (init/main.c:818)
[ 3162.934790] kernel_init (init/main.c:866)
[ 3162.934790] ret_from_fork (arch/x86/kernel/entry_64.S:555)
[ 3162.934790]   }
[ 3162.934790] ... key at: __key.50836 (??:?)
[ 3162.934790]   ... acquired at:
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] might_fault (mm/memory.c:4214)
[ 3162.934790] filldir (arch/x86/include/asm/uaccess.h:731 fs/readdir.c:176)
[ 3162.934790] xfs_dir2_sf_getdents (fs/xfs/xfs_dir2_readdir.c:131)
[ 3162.934790] xfs_readdir (fs/xfs/xfs_dir2_readdir.c:689)
[ 3162.934790] xfs_file_readdir (fs/xfs/xfs_file.c:977)
[ 3162.934790] iterate_dir (fs/readdir.c:42)
[ 3162.934790] SyS_getdents (fs/readdir.c:214 fs/readdir.c:193)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]
[ 3162.934790] -> (&xfs_dir_ilock_class){++++..} ops: 6 {
[ 3162.934790]    HARDIRQ-ON-W at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2800 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_write_nested (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:143)
[ 3162.934790] xfs_ilock (fs/xfs/mrlock.h:50 fs/xfs/xfs_inode.c:165)
[ 3162.934790] xfs_vn_update_time (fs/xfs/xfs_iops.c:944)
[ 3162.934790] update_time (fs/inode.c:1502)
[ 3162.934790] touch_atime (fs/inode.c:1565)
[ 3162.934790] iterate_dir (include/linux/fs.h:1815 fs/readdir.c:43)
[ 3162.934790] SyS_getdents (fs/readdir.c:214 fs/readdir.c:193)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]    HARDIRQ-ON-R at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2792 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_read_nested (arch/x86/include/asm/rwsem.h:83 kernel/locking/rwsem.c:114)
[ 3162.934790] xfs_ilock (fs/xfs/mrlock.h:43 fs/xfs/xfs_inode.c:167)
[ 3162.934790] xfs_ilock_data_map_shared (fs/xfs/xfs_inode.c:106)
[ 3162.934790] xfs_lookup (fs/xfs/xfs_inode.c:589)
[ 3162.934790] xfs_vn_lookup (fs/xfs/xfs_iops.c:230)
[ 3162.934790] lookup_real (fs/namei.c:1325)
[ 3162.934790] __lookup_hash (fs/namei.c:1343)
[ 3162.934790] lookup_slow (fs/namei.c:1454)
[ 3162.934790] path_lookupat (fs/namei.c:1534 fs/namei.c:1904 fs/namei.c:1938)
[ 3162.934790] filename_lookup (fs/namei.c:1978)
[ 3162.934790] user_path_at_empty (fs/namei.c:2126)
[ 3162.934790] user_path_at (fs/namei.c:2137)
[ 3162.934790] vfs_fstatat (fs/stat.c:107)
[ 3162.934790] vfs_stat (fs/stat.c:124)
[ 3162.934790] SYSC_newstat (fs/stat.c:272)
[ 3162.934790] SyS_newstat (fs/stat.c:267)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]    SOFTIRQ-ON-W at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2804 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_write_nested (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:143)
[ 3162.934790] xfs_ilock (fs/xfs/mrlock.h:50 fs/xfs/xfs_inode.c:165)
[ 3162.934790] xfs_vn_update_time (fs/xfs/xfs_iops.c:944)
[ 3162.934790] update_time (fs/inode.c:1502)
[ 3162.934790] touch_atime (fs/inode.c:1565)
[ 3162.934790] iterate_dir (include/linux/fs.h:1815 fs/readdir.c:43)
[ 3162.934790] SyS_getdents (fs/readdir.c:214 fs/readdir.c:193)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]    SOFTIRQ-ON-R at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:2804 kernel/locking/lockdep.c:3138)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_read_nested (arch/x86/include/asm/rwsem.h:83 kernel/locking/rwsem.c:114)
[ 3162.934790] xfs_ilock (fs/xfs/mrlock.h:43 fs/xfs/xfs_inode.c:167)
[ 3162.934790] xfs_ilock_data_map_shared (fs/xfs/xfs_inode.c:106)
[ 3162.934790] xfs_lookup (fs/xfs/xfs_inode.c:589)
[ 3162.934790] xfs_vn_lookup (fs/xfs/xfs_iops.c:230)
[ 3162.934790] lookup_real (fs/namei.c:1325)
[ 3162.934790] __lookup_hash (fs/namei.c:1343)
[ 3162.934790] lookup_slow (fs/namei.c:1454)
[ 3162.934790] path_lookupat (fs/namei.c:1534 fs/namei.c:1904 fs/namei.c:1938)
[ 3162.934790] filename_lookup (fs/namei.c:1978)
[ 3162.934790] user_path_at_empty (fs/namei.c:2126)
[ 3162.934790] user_path_at (fs/namei.c:2137)
[ 3162.934790] vfs_fstatat (fs/stat.c:107)
[ 3162.934790] vfs_stat (fs/stat.c:124)
[ 3162.934790] SYSC_newstat (fs/stat.c:272)
[ 3162.934790] SyS_newstat (fs/stat.c:267)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]    INITIAL USE at:
[ 3162.934790] __lock_acquire (kernel/locking/lockdep.c:3142)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_read_nested (arch/x86/include/asm/rwsem.h:83 kernel/locking/rwsem.c:114)
[ 3162.934790] xfs_ilock (fs/xfs/mrlock.h:43 fs/xfs/xfs_inode.c:167)
[ 3162.934790] xfs_ilock_data_map_shared (fs/xfs/xfs_inode.c:106)
[ 3162.934790] xfs_lookup (fs/xfs/xfs_inode.c:589)
[ 3162.934790] xfs_vn_lookup (fs/xfs/xfs_iops.c:230)
[ 3162.934790] lookup_real (fs/namei.c:1325)
[ 3162.934790] __lookup_hash (fs/namei.c:1343)
[ 3162.934790] lookup_slow (fs/namei.c:1454)
[ 3162.934790] path_lookupat (fs/namei.c:1534 fs/namei.c:1904 fs/namei.c:1938)
[ 3162.934790] filename_lookup (fs/namei.c:1978)
[ 3162.934790] user_path_at_empty (fs/namei.c:2126)
[ 3162.934790] user_path_at (fs/namei.c:2137)
[ 3162.934790] vfs_fstatat (fs/stat.c:107)
[ 3162.934790] vfs_stat (fs/stat.c:124)
[ 3162.934790] SYSC_newstat (fs/stat.c:272)
[ 3162.934790] SyS_newstat (fs/stat.c:267)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]  }
[ 3162.934790] ... key at: xfs_dir_ilock_class (??:?)
[ 3162.934790]  ... acquired at:
[ 3162.934790] check_irq_usage (kernel/locking/lockdep.c:1638)
[ 3162.934790] __lock_acquire (kernel/locking/lockdep_states.h:9 kernel/locking/lockdep.c:1844 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] down_write_nested (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:143)
[ 3162.934790] xfs_ilock (fs/xfs/mrlock.h:50 fs/xfs/xfs_inode.c:165)
[ 3162.934790] xfs_vn_update_time (fs/xfs/xfs_iops.c:944)
[ 3162.934790] update_time (fs/inode.c:1502)
[ 3162.934790] touch_atime (fs/inode.c:1565)
[ 3162.934790] iterate_dir (include/linux/fs.h:1815 fs/readdir.c:43)
[ 3162.934790] SyS_getdents (fs/readdir.c:214 fs/readdir.c:193)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)
[ 3162.934790]
[ 3162.934790]
[ 3162.934790] stack backtrace:
[ 3162.934790] CPU: 0 PID: 17183 Comm: trinity-main Not tainted 3.14.0-next-20140408-sasha-00023-g06962b5 #384
[ 3162.934790]  ffffffff93a57840 ffff8804c55b5ad8 ffffffff9051ac81 0000000000000000
[ 3162.934790]  ffff8804c6b10d38 ffff8804c55b5be8 ffffffff8d1c0eb5 0000000000000000
[ 3162.934790]  ffff880400000001 0000000000000001 ffff8804c6b10000 ffffffff916c5d62
[ 3162.934790] Call Trace:
[ 3162.934790] dump_stack (lib/dump_stack.c:52)
[ 3162.934790] check_usage (kernel/locking/lockdep.c:1549 kernel/locking/lockdep.c:1580)
[ 3162.934790] ? save_stack_trace (arch/x86/kernel/stacktrace.c:64)
[ 3162.934790] ? check_usage_forwards (kernel/locking/lockdep.c:2371)
[ 3162.934790] check_irq_usage (kernel/locking/lockdep.c:1638)
[ 3162.934790] __lock_acquire (kernel/locking/lockdep_states.h:9 kernel/locking/lockdep.c:1844 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 3162.934790] ? get_parent_ip (kernel/sched/core.c:2471)
[ 3162.934790] ? kmem_cache_alloc (include/linux/kmemleak.h:43 mm/slub.c:975 mm/slub.c:2468 mm/slub.c:2476 mm/slub.c:2481)
[ 3162.934790] ? get_parent_ip (kernel/sched/core.c:2471)
[ 3162.934790] ? preempt_count_sub (kernel/sched/core.c:2526)
[ 3162.934790] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 3162.934790] ? xfs_ilock (fs/xfs/mrlock.h:50 fs/xfs/xfs_inode.c:165)
[ 3162.934790] ? xfs_vn_update_time (fs/xfs/xfs_iops.c:944)
[ 3162.934790] down_write_nested (arch/x86/include/asm/rwsem.h:130 kernel/locking/rwsem.c:143)
[ 3162.934790] ? xfs_ilock (fs/xfs/mrlock.h:50 fs/xfs/xfs_inode.c:165)
[ 3162.934790] ? xfs_trans_reserve (fs/xfs/xfs_trans.c:221)
[ 3162.934790] xfs_ilock (fs/xfs/mrlock.h:50 fs/xfs/xfs_inode.c:165)
[ 3162.934790] xfs_vn_update_time (fs/xfs/xfs_iops.c:944)
[ 3162.934790] update_time (fs/inode.c:1502)
[ 3162.934790] ? __mnt_want_write (arch/x86/include/asm/preempt.h:98 fs/namespace.c:358)
[ 3162.934790] touch_atime (fs/inode.c:1565)
[ 3162.934790] iterate_dir (include/linux/fs.h:1815 fs/readdir.c:43)
[ 3162.934790] SyS_getdents (fs/readdir.c:214 fs/readdir.c:193)
[ 3162.934790] ? iterate_dir (fs/readdir.c:151)
[ 3162.934790] tracesys (arch/x86/kernel/entry_64.S:749)


Thanks,
Sasha

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
