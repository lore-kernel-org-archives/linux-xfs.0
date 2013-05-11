Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 289817F37
	for <xfs@oss.sgi.com>; Sat, 11 May 2013 07:09:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1859130405F
	for <xfs@oss.sgi.com>; Sat, 11 May 2013 05:09:47 -0700 (PDT)
Received: from mail-la0-f42.google.com (mail-la0-f42.google.com
	[209.85.215.42]) by cuda.sgi.com with ESMTP id yNj571Fpq0mljDTg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 11 May 2013 05:09:45 -0700 (PDT)
Received: by mail-la0-f42.google.com with SMTP id er20so1966224lab.29
	for <xfs@oss.sgi.com>; Sat, 11 May 2013 05:09:44 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
In-Reply-To: <20130507133707.GA18301@redhat.com>
References: <20130507133707.GA18301@redhat.com>
Date: Sat, 11 May 2013 16:09:40 +0400
Message-ID: <87k3n5en0b.fsf@openvz.org>
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
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: xfs@oss.sgi.com

On Tue, 7 May 2013 09:37:07 -0400, Dave Jones <davej@redhat.com> wrote:
> started compiling a kernel, and then...
> 
I've bisected this one.
commit 666d644cd72a9ec58b353209ff191d7430f3b357
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Apr 3 14:09:21 2013 +1100

    xfs: don't free EFIs before the EFDs are committed

#xfstests  ./check generic/007 generic/007 generic/007

> [  172.233200] =============================================================================
> [  172.233205] BUG xfs_efi_item (Not tainted): Poison overwritten
> [  172.233207] -----------------------------------------------------------------------------
> 
> [  172.233210] Disabling lock debugging due to kernel taint
> [  172.233213] INFO: 0xffff8800aaac4ea8-0xffff8800aaac4ea8. First byte 0x6a instead of 0x6b
> [  172.233235] INFO: Allocated in kmem_zone_alloc+0x67/0xf0 [xfs] age=29290 cpu=1 pid=1357
> [  172.233239] 	__slab_alloc+0x468/0x52c
> [  172.233243] 	kmem_cache_alloc+0x2b4/0x320
> [  172.233256] 	kmem_zone_alloc+0x67/0xf0 [xfs]
> [  172.233269] 	kmem_zone_zalloc+0x14/0x40 [xfs]
> [  172.233287] 	xfs_efi_init+0x41/0xa0 [xfs]
> [  172.233305] 	xfs_trans_get_efi+0x58/0x90 [xfs]
> [  172.233320] 	xfs_bmap_finish+0x76/0x1b0 [xfs]
> [  172.233338] 	xfs_itruncate_extents+0x2cd/0x610 [xfs]
> [  172.233353] 	xfs_inactive+0x401/0x530 [xfs]
> [  172.233367] 	xfs_fs_evict_inode+0x8c/0x1b0 [xfs]
> [  172.233370] 	evict+0xa3/0x1a0
> [  172.233372] 	iput+0xf5/0x180
> [  172.233374] 	dput+0x208/0x2f0
> [  172.233378] 	SYSC_renameat+0x3be/0x430
> [  172.233380] 	SyS_renameat+0xe/0x10
> [  172.233383] 	SyS_rename+0x1b/0x20
> [  172.233399] INFO: Freed in xfs_efi_item_free+0x21/0x40 [xfs] age=27303 cpu=1 pid=177
> [  172.233402] 	__slab_free+0x41/0x39f
> [  172.233405] 	kmem_cache_free+0x326/0x370
> [  172.233420] 	xfs_efi_item_free+0x21/0x40 [xfs]
> [  172.233435] 	__xfs_efi_release+0x4e/0x60 [xfs]
> [  172.233449] 	xfs_efi_release+0x50/0x70 [xfs]
> [  172.233463] 	xfs_efd_item_committed+0x22/0x40 [xfs]
> [  172.233479] 	xfs_trans_committed_bulk+0xcf/0x290 [xfs]
> [  172.233494] 	xlog_cil_committed+0x37/0x110 [xfs]
> [  172.233510] 	xlog_state_do_callback+0x1b8/0x3f0 [xfs]
> [  172.233525] 	xlog_state_done_syncing+0xf2/0x110 [xfs]
> [  172.233539] 	xlog_iodone+0x87/0x110 [xfs]
> [  172.233550] 	xfs_buf_iodone_work+0x5e/0xd0 [xfs]
> [  172.233554] 	process_one_work+0x211/0x700
> [  172.233556] 	worker_thread+0x11d/0x3a0
> [  172.233559] 	kthread+0xed/0x100
> [  172.233562] 	ret_from_fork+0x7c/0xb0
> [  172.233565] INFO: Slab 0xffffea0002aab100 objects=22 used=22 fp=0x          (null) flags=0x20000000004080
> [  172.233567] INFO: Object 0xffff8800aaac4e38 @offset=3640 fp=0xffff8800aaac7058
> 
> [  172.233570] Bytes b4 ffff8800aaac4e28: 07 a2 fd ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
> [  172.233573] Object ffff8800aaac4e38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233575] Object ffff8800aaac4e48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233577] Object ffff8800aaac4e58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233579] Object ffff8800aaac4e68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233581] Object ffff8800aaac4e78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233583] Object ffff8800aaac4e88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233586] Object ffff8800aaac4e98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233588] Object ffff8800aaac4ea8: 6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  jkkkkkkkkkkkkkkk
> [  172.233590] Object ffff8800aaac4eb8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233592] Object ffff8800aaac4ec8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233594] Object ffff8800aaac4ed8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233597] Object ffff8800aaac4ee8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233599] Object ffff8800aaac4ef8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233601] Object ffff8800aaac4f08: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233603] Object ffff8800aaac4f18: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233605] Object ffff8800aaac4f28: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233608] Object ffff8800aaac4f38: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233610] Object ffff8800aaac4f48: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233612] Object ffff8800aaac4f58: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233614] Object ffff8800aaac4f68: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233616] Object ffff8800aaac4f78: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233618] Object ffff8800aaac4f88: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233620] Object ffff8800aaac4f98: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233622] Object ffff8800aaac4fa8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [  172.233625] Object ffff8800aaac4fb8: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> [  172.233627] Redzone ffff8800aaac4fc8: bb bb bb bb bb bb bb bb                          ........
> [  172.233629] Padding ffff8800aaac5108: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> [  172.233632] CPU: 1 PID: 1658 Comm: gcc Tainted: G    B        3.9.0+ #1 [loadavg: 0.68 0.43 0.17 4/333 1660]
> [  172.233636] Hardware name: LENOVO 2356JK8/2356JK8, BIOS G7ET92WW (2.52 ) 02/18/2013
> [  172.233638]  ffffea0002aab100 ffff8800a4b03918 ffffffff815f5588 ffff8800a4b03968
> [  172.233644]  ffffffff81185944 0000000000000008 ffff880000000001 ffffffff81078016
> [  172.233648]  ffff8800aaac4ea8 ffff8800aaac4ea9 ffff880115937cc0 000000000000006b
> [  172.233653] Call Trace:
> [  172.233658]  [<ffffffff815f5588>] dump_stack+0x19/0x1b
> [  172.233662]  [<ffffffff81185944>] print_trailer+0x154/0x210
> [  172.233666]  [<ffffffff81078016>] ? perf_trace_sched_process_template+0xe6/0x100
> [  172.233669]  [<ffffffff81185b3f>] check_bytes_and_report+0xcf/0x110
> [  172.233673]  [<ffffffff81187037>] check_object+0x1e7/0x260
> [  172.233676]  [<ffffffff811864f7>] ? check_slab+0x87/0x130
> [  172.233691]  [<ffffffffa0543fa7>] ? kmem_zone_alloc+0x67/0xf0 [xfs]
> [  172.233694]  [<ffffffff815f2ea3>] alloc_debug_processing+0x76/0x118
> [  172.233697]  [<ffffffff815f3b8d>] __slab_alloc+0x468/0x52c
> [  172.233716]  [<ffffffffa0592787>] ? xfs_iext_bno_to_ext+0x97/0x180 [xfs]
> [  172.233731]  [<ffffffffa0543fa7>] ? kmem_zone_alloc+0x67/0xf0 [xfs]
> [  172.233735]  [<ffffffff8118a754>] kmem_cache_alloc+0x2b4/0x320
> [  172.233748]  [<ffffffffa0543fa7>] ? kmem_zone_alloc+0x67/0xf0 [xfs]
> [  172.233762]  [<ffffffffa0543fa7>] kmem_zone_alloc+0x67/0xf0 [xfs]
> [  172.233776]  [<ffffffffa0544044>] kmem_zone_zalloc+0x14/0x40 [xfs]
> [  172.233792]  [<ffffffffa05ae031>] xfs_efi_init+0x41/0xa0 [xfs]
> [  172.233809]  [<ffffffffa05b32b8>] xfs_trans_get_efi+0x58/0x90 [xfs]
> [  172.233825]  [<ffffffffa055a0a6>] xfs_bmap_finish+0x76/0x1b0 [xfs]
> [  172.233844]  [<ffffffffa058ef0d>] xfs_itruncate_extents+0x2cd/0x610 [xfs]
> [  172.233859]  [<ffffffffa0540e41>] xfs_inactive+0x401/0x530 [xfs]
> [  172.233874]  [<ffffffffa053dbec>] xfs_fs_evict_inode+0x8c/0x1b0 [xfs]
> [  172.233877]  [<ffffffff811c1033>] evict+0xa3/0x1a0
> [  172.233880]  [<ffffffff811c19c5>] iput+0xf5/0x180
> [  172.233883]  [<ffffffff811bcf18>] dput+0x208/0x2f0
> [  172.233887]  [<ffffffff811b43ae>] SYSC_renameat+0x3be/0x430
> [  172.233892]  [<ffffffff810ad32e>] ? lock_release_holdtime.part.30+0xee/0x170
> [  172.233895]  [<ffffffff8107c18d>] ? get_parent_ip+0xd/0x50
> [  172.233899]  [<ffffffff810afe7d>] ? trace_hardirqs_on+0xd/0x10
> [  172.233904]  [<ffffffff8100e358>] ? syscall_trace_enter+0x18/0x230
> [  172.233907]  [<ffffffff811b67fe>] SyS_renameat+0xe/0x10
> [  172.233911]  [<ffffffff811b681b>] SyS_rename+0x1b/0x20
> [  172.233914]  [<ffffffff816051d4>] tracesys+0xdd/0xe2
> [  172.233917] FIX xfs_efi_item: Restoring 0xffff8800aaac4ea8-0xffff8800aaac4ea8=0x6b
> [  172.233919] FIX xfs_efi_item: Marking all objects used
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
