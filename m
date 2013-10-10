Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 91A777F3F
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:16:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53FDB304048
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 18:16:45 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id jgvZq8jl1sYYEyWV for
	<xfs@oss.sgi.com>; Wed, 09 Oct 2013 18:16:44 -0700 (PDT)
Date: Thu, 10 Oct 2013 09:16:40 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010011640.GA5726@localhost>
References: <20131009073910.GA387@localhost>
	<20131010005900.GE2025@devil.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010005900.GE2025@devil.localdomain>
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
To: Dave Chinner <dchinner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 10, 2013 at 11:59:00AM +1100, Dave Chinner wrote:
> [add xfs@oss.sgi.com to cc]

Thanks.

To help debug the problem, I searched XFS in my tests' oops database
and find one kernel that failed 4 times (out of 12 total boots) with
basically the same error:

      4 BUG: sleeping function called from invalid context at kernel/workqueue.c:2810
      1 WARNING: CPU: 1 PID: 372 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
      1 WARNING: CPU: 1 PID: 360 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
      1 WARNING: CPU: 0 PID: 381 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
      1 WARNING: CPU: 0 PID: 361 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()

dmesg-yocto-cairo-28:20131004225501:i386-randconfig-j0-10042023:3.12.0-rc2-next-20130927-03100-ga0cf1ab:3

[   29.709162] qnx6: unable to set blocksize
[   29.716037] ADFS-fs error (device zram0): adfs_fill_super: unable to read superblock
[   29.719395] ------------[ cut here ]------------
[   29.719838] WARNING: CPU: 1 PID: 372 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
[   29.720016] ODEBUG: free active (active state 0) object type: work_struct hint: xfs_buf_iodone_work+0x0/0xfe
[   29.720016] CPU: 1 PID: 372 Comm: mount Not tainted 3.12.0-rc2-next-20130927-03100-ga0cf1ab #3
[   29.720016]  00000000 00000000 8a3efd30 8275c9a2 8a3efd70 00000000 00000104 8a3efd60
[   29.720016]  8103f5e3 8334fafe 8a3efd8c 00000174 8334fb3b 00000104 817001fb 817001fb
[   29.720016]  8a121e90 8355b58c 83323588 8a3efd78 8103f641 00000009 8a3efd70 8334fafe
[   29.720016] Call Trace:
[   29.720016]  [<8275c9a2>] dump_stack+0x7a/0xaa
[   29.720016]  [<8103f5e3>] warn_slowpath_common+0x8c/0xa3
[   29.720016]  [<817001fb>] ? debug_print_object+0x94/0xa2
[   29.720016]  [<817001fb>] ? debug_print_object+0x94/0xa2
[   29.720016]  [<8103f641>] warn_slowpath_fmt+0x2e/0x30
[   29.720016]  [<817001fb>] debug_print_object+0x94/0xa2
[   29.720016]  [<81344703>] ? xfs_buf_unlock+0x17f/0x17f
[   29.720016]  [<81700f1a>] debug_check_no_obj_freed+0xe2/0x1f8
[   29.720016]  [<8115aaa1>] kmem_cache_free+0xfe/0x32b
[   29.720016]  [<81342be0>] xfs_buf_free+0x263/0x26f
[   29.720016]  [<81343a71>] xfs_buf_rele+0x3e0/0x3f0
[   29.720016]  [<813635f6>] ? xfs_readsb+0x25e/0x268
[   29.720016]  [<813635f6>] xfs_readsb+0x25e/0x268
[   29.720016]  [<827243a5>] ? register_cpu_notifier+0x20/0x27
[   29.720016]  [<81367344>] xfs_fs_fill_super+0x27d/0x495
[   29.720016]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   29.720016]  [<811666bf>] mount_bdev+0x1d6/0x256
[   29.720016]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   29.720016]  [<8115a80b>] ? __kmalloc_track_caller+0x21a/0x3b2
[   29.720016]  [<816d87d6>] ? ida_get_new_above+0x24a/0x25b
[   29.720016]  [<81364b69>] xfs_fs_mount+0x1a/0x1f
[   29.720016]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   29.720016]  [<81166a09>] mount_fs+0x38/0x1b3
[   29.720016]  [<811395a4>] ? __alloc_percpu+0xa/0xc
[   29.720016]  [<8118b7ff>] ? alloc_vfsmnt+0x108/0x1d6
[   29.720016]  [<8118ca68>] vfs_kern_mount+0x97/0x123
[   29.720016]  [<8118ef8f>] do_mount+0xc8e/0xe0d
[   29.720016]  [<8118e2e3>] ? copy_mount_string+0x51/0x6f
[   29.720016]  [<8118f1ee>] SyS_mount+0xe0/0x10d
[   29.720016]  [<827889ff>] syscall_call+0x7/0xb
[   29.720016] ---[ end trace dbf8d35123ab64b3 ]---
[   29.720016] BUG: sleeping function called from invalid context at kernel/workqueue.c:2810

dmesg-yocto-cairo-33:20131004225518:i386-randconfig-j0-10042023:3.12.0-rc2-next-20130927-03100-ga0cf1ab:3

[   30.423344] qnx6: unable to set blocksize
[   30.424465] ADFS-fs error (device zram0): adfs_fill_super: unable to read superblock
[   30.428281] ------------[ cut here ]------------
[   30.428765] WARNING: CPU: 0 PID: 381 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
[   30.429826] ODEBUG: free active (active state 0) object type: work_struct hint: xfs_buf_iodone_work+0x0/0xfe
[   30.430014] CPU: 0 PID: 381 Comm: mount Not tainted 3.12.0-rc2-next-20130927-03100-ga0cf1ab #3
[   30.430014]  00000000 00000000 8982dd30 8275c9a2 8982dd70 00000000 00000104 8982dd60
[   30.430014]  8103f5e3 8334fafe 8982dd8c 0000017d 8334fb3b 00000104 817001fb 817001fb
[   30.430014]  8a7ba8c0 8355b58c 83323588 8982dd78 8103f641 00000009 8982dd70 8334fafe
[   30.434063] Call Trace:
[   30.434063]  [<8275c9a2>] dump_stack+0x7a/0xaa
[   30.434063]  [<8103f5e3>] warn_slowpath_common+0x8c/0xa3
[   30.434063]  [<817001fb>] ? debug_print_object+0x94/0xa2
[   30.434063]  [<817001fb>] ? debug_print_object+0x94/0xa2
[   30.434063]  [<8103f641>] warn_slowpath_fmt+0x2e/0x30
[   30.434063]  [<817001fb>] debug_print_object+0x94/0xa2
[   30.434063]  [<81344703>] ? xfs_buf_unlock+0x17f/0x17f
[   30.434063]  [<81700f1a>] debug_check_no_obj_freed+0xe2/0x1f8
[   30.434063]  [<8115aaa1>] kmem_cache_free+0xfe/0x32b
[   30.434063]  [<81342be0>] xfs_buf_free+0x263/0x26f
[   30.434063]  [<81343a71>] xfs_buf_rele+0x3e0/0x3f0
[   30.434063]  [<813635f6>] ? xfs_readsb+0x25e/0x268
[   30.434063]  [<813635f6>] xfs_readsb+0x25e/0x268
[   30.434063]  [<827243a5>] ? register_cpu_notifier+0x20/0x27
[   30.434063]  [<81367344>] xfs_fs_fill_super+0x27d/0x495
[   30.434063]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   30.434063]  [<811666bf>] mount_bdev+0x1d6/0x256
[   30.434063]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   30.434063]  [<8115a80b>] ? __kmalloc_track_caller+0x21a/0x3b2
[   30.434063]  [<816d87d6>] ? ida_get_new_above+0x24a/0x25b
[   30.434063]  [<81364b69>] xfs_fs_mount+0x1a/0x1f
[   30.434063]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   30.434063]  [<81166a09>] mount_fs+0x38/0x1b3
[   30.434063]  [<811395a4>] ? __alloc_percpu+0xa/0xc
[   30.434063]  [<8118b7ff>] ? alloc_vfsmnt+0x108/0x1d6
[   30.434063]  [<8118ca68>] vfs_kern_mount+0x97/0x123
[   30.434063]  [<8118ef8f>] do_mount+0xc8e/0xe0d
[   30.434063]  [<8118e2e3>] ? copy_mount_string+0x51/0x6f
[   30.434063]  [<8118f1ee>] SyS_mount+0xe0/0x10d
[   30.434063]  [<827889ff>] syscall_call+0x7/0xb
[   30.434063] ---[ end trace ea8cda3cc7585b8a ]---
[   30.434063] BUG: sleeping function called from invalid context at kernel/workqueue.c:2810

dmesg-yocto-jaketown-25:20131004225448:i386-randconfig-j0-10042023:3.12.0-rc2-next-20130927-03100-ga0cf1ab:3

[   35.635867] qnx6: unable to set blocksize
[   35.638410] ADFS-fs error (device zram0): adfs_fill_super: unable to read superblock
[   35.662564] ------------[ cut here ]------------
[   35.664652] WARNING: CPU: 0 PID: 361 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
[   35.669001] ODEBUG: free active (active state 0) object type: work_struct hint: xfs_buf_iodone_work+0x0/0xfe
[   35.670149] CPU: 0 PID: 361 Comm: mount Not tainted 3.12.0-rc2-next-20130927-03100-ga0cf1ab #3
[   35.670149]  00000000 00000000 8a299d30 8275c9a2 8a299d70 00000000 00000104 8a299d60
[   35.670149]  8103f5e3 8334fafe 8a299d8c 00000169 8334fb3b 00000104 817001fb 817001fb
[   35.670149]  8a73ebd8 8355b58c 83323588 8a299d78 8103f641 00000009 8a299d70 8334fafe
[   35.670149] Call Trace:
[   35.670149]  [<8275c9a2>] dump_stack+0x7a/0xaa
[   35.670149]  [<8103f5e3>] warn_slowpath_common+0x8c/0xa3
[   35.670149]  [<817001fb>] ? debug_print_object+0x94/0xa2
[   35.670149]  [<817001fb>] ? debug_print_object+0x94/0xa2
[   35.670149]  [<8103f641>] warn_slowpath_fmt+0x2e/0x30
[   35.670149]  [<817001fb>] debug_print_object+0x94/0xa2
[   35.670149]  [<81344703>] ? xfs_buf_unlock+0x17f/0x17f
[   35.670149]  [<81700f1a>] debug_check_no_obj_freed+0xe2/0x1f8
[   35.670149]  [<8115aaa1>] kmem_cache_free+0xfe/0x32b
[   35.670149]  [<81342be0>] xfs_buf_free+0x263/0x26f
[   35.670149]  [<81343a71>] xfs_buf_rele+0x3e0/0x3f0
[   35.670149]  [<813635f6>] ? xfs_readsb+0x25e/0x268
[   35.670149]  [<813635f6>] xfs_readsb+0x25e/0x268
[   35.670149]  [<827243a5>] ? register_cpu_notifier+0x20/0x27
[   35.670149]  [<81367344>] xfs_fs_fill_super+0x27d/0x495
[   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   35.670149]  [<811666bf>] mount_bdev+0x1d6/0x256
[   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   35.670149]  [<8115a80b>] ? __kmalloc_track_caller+0x21a/0x3b2
[   35.670149]  [<816d87d6>] ? ida_get_new_above+0x24a/0x25b
[   35.670149]  [<81364b69>] xfs_fs_mount+0x1a/0x1f
[   35.670149]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   35.670149]  [<81166a09>] mount_fs+0x38/0x1b3
[   35.670149]  [<811395a4>] ? __alloc_percpu+0xa/0xc
[   35.670149]  [<8118b7ff>] ? alloc_vfsmnt+0x108/0x1d6
[   35.670149]  [<8118ca68>] vfs_kern_mount+0x97/0x123
[   35.670149]  [<8118ef8f>] do_mount+0xc8e/0xe0d
[   35.670149]  [<8118e2e3>] ? copy_mount_string+0x51/0x6f
[   35.670149]  [<8118f1ee>] SyS_mount+0xe0/0x10d
[   35.670149]  [<827889ff>] syscall_call+0x7/0xb
[   35.670149] ---[ end trace d814169ab0ed4dd3 ]---
[   35.670149] BUG: sleeping function called from invalid context at kernel/workqueue.c:2810

dmesg-yocto-jaketown-26:20131004225504:i386-randconfig-j0-10042023:3.12.0-rc2-next-20130927-03100-ga0cf1ab:3

[   32.274597] qnx6: unable to set blocksize
[   32.279268] ADFS-fs error (device zram0): adfs_fill_super: unable to read superblock
[   32.295808] ------------[ cut here ]------------
[   32.297779] WARNING: CPU: 1 PID: 360 at lib/debugobjects.c:260 debug_print_object+0x94/0xa2()
[   32.300113] ODEBUG: free active (active state 0) object type: work_struct hint: xfs_buf_iodone_work+0x0/0xfe
[   32.300113] CPU: 1 PID: 360 Comm: mount Not tainted 3.12.0-rc2-next-20130927-03100-ga0cf1ab #3
[   32.300113]  00000000 00000000 8a34fd30 8275c9a2 8a34fd70 00000000 00000104 8a34fd60
[   32.300113]  8103f5e3 8334fafe 8a34fd8c 00000168 8334fb3b 00000104 817001fb 817001fb
[   32.300113]  8a7b1b00 8355b58c 83323588 8a34fd78 8103f641 00000009 8a34fd70 8334fafe
[   32.300113] Call Trace:
[   32.300113]  [<8275c9a2>] dump_stack+0x7a/0xaa
[   32.300113]  [<8103f5e3>] warn_slowpath_common+0x8c/0xa3
[   32.300113]  [<817001fb>] ? debug_print_object+0x94/0xa2
[   32.300113]  [<817001fb>] ? debug_print_object+0x94/0xa2
[   32.300113]  [<8103f641>] warn_slowpath_fmt+0x2e/0x30
[   32.300113]  [<817001fb>] debug_print_object+0x94/0xa2
[   32.300113]  [<81344703>] ? xfs_buf_unlock+0x17f/0x17f
[   32.300113]  [<81700f1a>] debug_check_no_obj_freed+0xe2/0x1f8
[   32.300113]  [<8115aaa1>] kmem_cache_free+0xfe/0x32b
[   32.300113]  [<81342be0>] xfs_buf_free+0x263/0x26f
[   32.300113]  [<81343a71>] xfs_buf_rele+0x3e0/0x3f0
[   32.300113]  [<813635f6>] ? xfs_readsb+0x25e/0x268
[   32.300113]  [<813635f6>] xfs_readsb+0x25e/0x268
[   32.300113]  [<827243a5>] ? register_cpu_notifier+0x20/0x27
[   32.300113]  [<81367344>] xfs_fs_fill_super+0x27d/0x495
[   32.300113]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   32.300113]  [<811666bf>] mount_bdev+0x1d6/0x256
[   32.300113]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   32.300113]  [<8115a80b>] ? __kmalloc_track_caller+0x21a/0x3b2
[   32.300113]  [<816d87d6>] ? ida_get_new_above+0x24a/0x25b
[   32.300113]  [<81364b69>] xfs_fs_mount+0x1a/0x1f
[   32.300113]  [<813670c7>] ? xfs_finish_flags+0x24e/0x24e
[   32.300113]  [<81166a09>] mount_fs+0x38/0x1b3
[   32.300113]  [<811395a4>] ? __alloc_percpu+0xa/0xc
[   32.300113]  [<8118b7ff>] ? alloc_vfsmnt+0x108/0x1d6
[   32.300113]  [<8118ca68>] vfs_kern_mount+0x97/0x123
[   32.300113]  [<8118ef8f>] do_mount+0xc8e/0xe0d
[   32.300113]  [<8118e2e3>] ? copy_mount_string+0x51/0x6f
[   32.300113]  [<8118f1ee>] SyS_mount+0xe0/0x10d
[   32.300113]  [<827889ff>] syscall_call+0x7/0xb
[   32.300113] ---[ end trace 53e0053082cb2d71 ]---
[   32.300113] BUG: sleeping function called from invalid context at kernel/workqueue.c:2810

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
