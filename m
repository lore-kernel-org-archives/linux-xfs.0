Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 387BA7CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 22:28:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 07B958F8039
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 20:28:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EOuctNThzLbP1aEW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 20:28:44 -0700 (PDT)
Date: Fri, 8 Apr 2016 11:28:41 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/6 v2] xfs: xfs_iflush_cluster vs xfs_reclaim_inode
Message-ID: <20160408032841.GW10345@eguan.usersys.redhat.com>
References: <1460072271-23923-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460072271-23923-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 08, 2016 at 09:37:45AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This is the second version of this patch set, first posted and
> described here:
> 
> http://oss.sgi.com/archives/xfs/2016-04/msg00069.html

Just a quick note here, I'm testing the v1 patchset right now, v4.6-rc2
kernel + v1 patch, config file is based on rhel7 debug kernel config.

The test is the same as the original reproducer (long term fsstress run
on XFS, exported from NFS). The test on x86_64 host has been running for
two days and everything looks fine. Test on ppc64 host has been running
for a few hours and I noticed a lock issue and a few warnings, not sure
if it's related to the patches or even to XFS yet(I need to run test on
stock -rc2 kernel to be sure), but just post the logs here for reference

[ 1911.626286] ======================================================
[ 1911.626291] [ INFO: possible circular locking dependency detected ]
[ 1911.626297] 4.6.0-rc2.debug+ #1 Not tainted
[ 1911.626301] -------------------------------------------------------
[ 1911.626306] nfsd/7402 is trying to acquire lock:
[ 1911.626311]  (&s->s_sync_lock){+.+.+.}, at: [<c0000000003585f0>] .sync_inodes_sb+0xe0/0x230
[ 1911.626327]
[ 1911.626327] but task is already holding lock:
[ 1911.626333]  (sb_internal){.+.+.+}, at: [<c00000000031a780>] .__sb_start_write+0x90/0x130
[ 1911.626346]
[ 1911.626346] which lock already depends on the new lock.
[ 1911.626346]
[ 1911.626353]
[ 1911.626353] the existing dependency chain (in reverse order) is:
[ 1911.626358]
-> #1 (sb_internal){.+.+.+}:
[ 1911.626368]        [<c00000000013947c>] .__lock_acquire+0x3fc/0xee0
[ 1911.626377]        [<c00000000013a998>] .lock_acquire+0xf8/0x360
[ 1911.626384]        [<c00000000013116c>] .percpu_down_read+0x5c/0x110
[ 1911.626392]        [<c00000000031a7f0>] .__sb_start_write+0x100/0x130
[ 1911.626399]        [<d0000000066e706c>] .xfs_trans_alloc+0x2c/0x70 [xfs]
[ 1911.626461]        [<d0000000066d9bfc>] .xfs_inactive_truncate+0x2c/0x1a0 [xfs]
[ 1911.626521]        [<d0000000066da618>] .xfs_inactive+0x218/0x260 [xfs]
[ 1911.626581]        [<d0000000066e25dc>] .xfs_fs_evict_inode+0x14c/0x370 [xfs]
[ 1911.626640]        [<c00000000033c84c>] .evict+0xdc/0x1f0
[ 1911.626647]        [<c000000000358698>] .sync_inodes_sb+0x188/0x230
[ 1911.626654]        [<c000000000362fcc>] .sync_inodes_one_sb+0x1c/0x30
[ 1911.626661]        [<c00000000031c09c>] .iterate_supers+0x17c/0x190
[ 1911.626668]        [<c000000000363498>] .sys_sync+0x48/0xd0
[ 1911.626675]        [<c000000000009210>] system_call+0x38/0xec
[ 1911.626682]
-> #0 (&s->s_sync_lock){+.+.+.}:
[ 1911.626692]        [<c000000000137b88>] .validate_chain.isra.35+0x918/0xc70
[ 1911.626699]        [<c00000000013947c>] .__lock_acquire+0x3fc/0xee0
[ 1911.626706]        [<c00000000013a998>] .lock_acquire+0xf8/0x360
[ 1911.626713]        [<c000000000922830>] .mutex_lock_nested+0xb0/0x5e0
[ 1911.626721]        [<c0000000003585f0>] .sync_inodes_sb+0xe0/0x230
[ 1911.626728]        [<d0000000066e48f8>] .xfs_flush_inodes+0x38/0x60 [xfs]
[ 1911.626787]        [<d0000000066d85c8>] .xfs_create+0x898/0xb30 [xfs]
[ 1911.626847]        [<d0000000066d0ac8>] .xfs_generic_create+0x208/0x3a0 [xfs]
[ 1911.626907]        [<c0000000003293fc>] .vfs_create+0x15c/0x1f0
[ 1911.626913]        [<d00000000a60d7e4>] .do_nfsd_create+0x444/0x580 [nfsd]
[ 1911.626942]        [<d00000000a61e0b8>] .nfsd4_open+0x388/0xa00 [nfsd]
[ 1911.626972]        [<d00000000a61eb5c>] .nfsd4_proc_compound+0x42c/0x720 [nfsd]
[ 1911.626998]        [<d00000000a603178>] .nfsd_dispatch+0x118/0x2d0 [nfsd]
[ 1911.627024]        [<d000000006dfde90>] .svc_process_common+0x550/0x8b0 [sunrpc]
[ 1911.627056]        [<d000000006dfe33c>] .svc_process+0x14c/0x610 [sunrpc]
[ 1911.627088]        [<d00000000a602268>] .nfsd+0x238/0x380 [nfsd]
[ 1911.627113]        [<c0000000000e9ac4>] .kthread+0x114/0x140
[ 1911.627120]        [<c000000000009578>] .ret_from_kernel_thread+0x58/0x60
[ 1911.627127]
[ 1911.627127] other info that might help us debug this:
[ 1911.627127]
[ 1911.627134]  Possible unsafe locking scenario:
[ 1911.627134]
[ 1911.627139]        CPU0                    CPU1
[ 1911.627143]        ----                    ----
[ 1911.627147]   lock(sb_internal);
[ 1911.627153]                                lock(&s->s_sync_lock);
[ 1911.627160]                                lock(sb_internal);
[ 1911.627166]   lock(&s->s_sync_lock);
[ 1911.627172]
[ 1911.627172]  *** DEADLOCK ***
[ 1911.627172]
[ 1911.627179] 4 locks held by nfsd/7402:
[ 1911.627183]  #0:  (sb_writers#8){.+.+.+}, at: [<c00000000031a7f0>] .__sb_start_write+0x100/0x130
[ 1911.627198]  #1:  (&type->i_mutex_dir_key#3/1){+.+.+.}, at: [<d00000000a60d5c4>] .do_nfsd_create+0x224/0x580 [nfsd]
[ 1911.627234]  #2:  (sb_internal){.+.+.+}, at: [<c00000000031a780>] .__sb_start_write+0x90/0x130
[ 1911.627248]  #3:  (&type->s_umount_key#44){++++++}, at: [<d0000000066e48e4>] .xfs_flush_inodes+0x24/0x60 [xfs]
[ 1911.627316]
[ 1911.627316] stack backtrace:
[ 1911.627323] CPU: 1 PID: 7402 Comm: nfsd Not tainted 4.6.0-rc2.debug+ #1
[ 1911.627328] Call Trace:
[ 1911.627333] [c0000005f2c36d10] [c000000000938df8] .dump_stack+0xe0/0x14c (unreliable)
[ 1911.627342] [c0000005f2c36da0] [c00000000092fd28] .print_circular_bug+0x354/0x388
[ 1911.627350] [c0000005f2c36e50] [c000000000137260] .check_prev_add+0x8d0/0x8e0
[ 1911.627357] [c0000005f2c36f60] [c000000000137b88] .validate_chain.isra.35+0x918/0xc70
[ 1911.627365] [c0000005f2c37050] [c00000000013947c] .__lock_acquire+0x3fc/0xee0
[ 1911.627372] [c0000005f2c37170] [c00000000013a998] .lock_acquire+0xf8/0x360
[ 1911.627379] [c0000005f2c37250] [c000000000922830] .mutex_lock_nested+0xb0/0x5e0
[ 1911.627386] [c0000005f2c37360] [c0000000003585f0] .sync_inodes_sb+0xe0/0x230
[ 1911.627445] [c0000005f2c37460] [d0000000066e48f8] .xfs_flush_inodes+0x38/0x60 [xfs]
[ 1911.627505] [c0000005f2c374e0] [d0000000066d85c8] .xfs_create+0x898/0xb30 [xfs]
[ 1911.627565] [c0000005f2c37600] [d0000000066d0ac8] .xfs_generic_create+0x208/0x3a0 [xfs]
[ 1911.627573] [c0000005f2c376d0] [c0000000003293fc] .vfs_create+0x15c/0x1f0
[ 1911.627599] [c0000005f2c37770] [d00000000a60d7e4] .do_nfsd_create+0x444/0x580 [nfsd]
[ 1911.627625] [c0000005f2c37850] [d00000000a61e0b8] .nfsd4_open+0x388/0xa00 [nfsd]
[ 1911.627651] [c0000005f2c37910] [d00000000a61eb5c] .nfsd4_proc_compound+0x42c/0x720 [nfsd]
[ 1911.627677] [c0000005f2c379f0] [d00000000a603178] .nfsd_dispatch+0x118/0x2d0 [nfsd]
[ 1911.627709] [c0000005f2c37a90] [d000000006dfde90] .svc_process_common+0x550/0x8b0 [sunrpc]
[ 1911.627741] [c0000005f2c37b70] [d000000006dfe33c] .svc_process+0x14c/0x610 [sunrpc]
[ 1911.627768] [c0000005f2c37c10] [d00000000a602268] .nfsd+0x238/0x380 [nfsd]
[ 1911.627775] [c0000005f2c37cb0] [c0000000000e9ac4] .kthread+0x114/0x140
[ 1911.627782] [c0000005f2c37e30] [c000000000009578] .ret_from_kernel_thread+0x58/0x60
[ 2046.852739] kworker/dying (399) used greatest stack depth: 4352 bytes left
[ 2854.687381] XFS: Assertion failed: buffer_mapped(bh), file: fs/xfs/xfs_aops.c, line: 780
[ 2854.687434] ------------[ cut here ]------------
[ 2854.687488] WARNING: CPU: 5 PID: 28924 at fs/xfs/xfs_message.c:105 .asswarn+0x2c/0x40 [xfs]
[ 2854.687493] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache dm_mod loop sg pseries_rng nfsd auth_rpcgss nfs_acl lockd sunrpc grace ip_tables xfs libcrc32c sd_mod ibmvscsi ibmveth scsi_transport_srp
[ 2854.687530] CPU: 5 PID: 28924 Comm: kworker/u32:4 Not tainted 4.6.0-rc2.debug+ #1
[ 2854.687538] Workqueue: writeback .wb_workfn (flush-253:0)
[ 2854.687545] task: c0000001e6d28380 ti: c0000000fe3ac000 task.ti: c0000000fe3ac000
[ 2854.687549] NIP: d0000000066ddafc LR: d0000000066ddafc CTR: c0000000004dd880
[ 2854.687554] REGS: c0000000fe3aeeb0 TRAP: 0700   Not tainted  (4.6.0-rc2.debug+)
[ 2854.687558] MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI,TM[E]>  CR: 28002048  XER: 0000000d
[ 2854.687577] CFAR: d0000000066dd890 SOFTE: 1
GPR00: d0000000066ddafc c0000000fe3af130 d000000006765850 ffffffffffffffea
GPR04: 000000000000000a c0000000fe3aef50 00000000000000d1 ffffffffffffffc0
GPR08: 0000000000000000 0000000000000021 00000000ffffffd1 d000000006741dc0
GPR12: c0000000004dd880 c00000000e822d00 c0000000fe3af4e0 0000000000000001
GPR16: c0000000fe3af6f0 0000000000000002 0000000000000000 0000000000000007
GPR20: 0000000000000003 c0000000fe3af4f0 0000000000000000 c0000000fe3af210
GPR24: 0000000000000004 0000000000001000 0000000000160000 f000000000f0e100
GPR28: c0000004055d18c8 c000000016cde430 0000000000157000 c0000004055d15f0
[ 2854.687694] NIP [d0000000066ddafc] .asswarn+0x2c/0x40 [xfs]
[ 2854.687742] LR [d0000000066ddafc] .asswarn+0x2c/0x40 [xfs]
[ 2854.687746] Call Trace:
[ 2854.687793] [c0000000fe3af130] [d0000000066ddafc] .asswarn+0x2c/0x40 [xfs] (unreliable)
[ 2854.687846] [c0000000fe3af1a0] [d0000000066a9104] .xfs_do_writepage+0x414/0x930 [xfs]
[ 2854.687854] [c0000000fe3af2b0] [c00000000025df6c] .write_cache_pages+0x5fc/0x820
[ 2854.687905] [c0000000fe3af470] [d0000000066a8a5c] .xfs_vm_writepages+0x8c/0xd0 [xfs]
[ 2854.687912] [c0000000fe3af540] [c00000000025f62c] .do_writepages+0x3c/0x70
[ 2854.687918] [c0000000fe3af5b0] [c00000000035b1ec] .__writeback_single_inode+0x5bc/0xd50
[ 2854.687924] [c0000000fe3af680] [c00000000035c3c0] .writeback_sb_inodes+0x380/0x730
[ 2854.687930] [c0000000fe3af7f0] [c00000000035ca44] .wb_writeback+0x194/0x920
[ 2854.687935] [c0000000fe3af960] [c00000000035ddcc] .wb_workfn+0x19c/0xa40
[ 2854.687943] [c0000000fe3afad0] [c0000000000dfc74] .process_one_work+0x264/0x8f0
[ 2854.687949] [c0000000fe3afbc0] [c0000000000e0388] .worker_thread+0x88/0x520
[ 2854.687955] [c0000000fe3afcb0] [c0000000000e9ac4] .kthread+0x114/0x140
[ 2854.687961] [c0000000fe3afe30] [c000000000009578] .ret_from_kernel_thread+0x58/0x60
[ 2854.687966] Instruction dump:
[ 2854.687970] 60420000 7c0802a6 3d420000 7c691b78 7c862378 e88abe38 7ca72b78 38600000
[ 2854.687983] 7d254b78 f8010010 f821ff91 4bfffcf9 <0fe00000> 38210070 e8010010 7c0803a6
[ 2854.687997] ---[ end trace 872ac2709186f780 ]---
[ 2854.688001] XFS: Assertion failed: buffer_mapped(bh), file: fs/xfs/xfs_aops.c, line: 780
[ 2854.688022] ------------[ cut here ]------------
[ 2854.688072] WARNING: CPU: 5 PID: 28924 at fs/xfs/xfs_message.c:105 .asswarn+0x2c/0x40 [xfs]
[ 2854.688076] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache dm_mod loop sg pseries_rng nfsd auth_rpcgss nfs_acl lockd sunrpc grace ip_tables xfs libcrc32c sd_mod ibmvscsi ibmveth scsi_transport_srp
[ 2854.688110] CPU: 5 PID: 28924 Comm: kworker/u32:4 Tainted: G        W       4.6.0-rc2.debug+ #1
[ 2854.688116] Workqueue: writeback .wb_workfn (flush-253:0)
[ 2854.688121] task: c0000001e6d28380 ti: c0000000fe3ac000 task.ti: c0000000fe3ac000
[ 2854.688126] NIP: d0000000066ddafc LR: d0000000066ddafc CTR: c0000000004dd880
[ 2854.688131] REGS: c0000000fe3aeeb0 TRAP: 0700   Tainted: G        W        (4.6.0-rc2.debug+)
[ 2854.688135] MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI,TM[E]>  CR: 48002048  XER: 0000000d
[ 2854.688153] CFAR: d0000000066dd890 SOFTE: 1
GPR00: d0000000066ddafc c0000000fe3af130 d000000006765850 ffffffffffffffea
GPR04: 000000000000000a c0000000fe3aef50 00000000000000d1 ffffffffffffffc0
GPR08: 0000000000000000 0000000000000021 00000000ffffffd1 d000000006741dc0
GPR12: c0000000004dd880 c00000000e822d00 c0000000fe3af4e0 0000000000000001
GPR16: c0000000fe3af6f0 0000000000000002 0000000000000000 0000000000000007
GPR20: 0000000000000003 c0000000fe3af4f0 0000000000000000 c0000000fe3af210
GPR24: 0000000000000004 0000000000001000 0000000000160000 f000000000f0e100
GPR28: c0000004055d18c8 c000000016cde430 0000000000158000 c0000004055d1588
[ 2854.688268] NIP [d0000000066ddafc] .asswarn+0x2c/0x40 [xfs]
[ 2854.688318] LR [d0000000066ddafc] .asswarn+0x2c/0x40 [xfs]
[ 2854.688321] Call Trace:
[ 2854.688369] [c0000000fe3af130] [d0000000066ddafc] .asswarn+0x2c/0x40 [xfs] (unreliable)
[ 2854.688423] [c0000000fe3af1a0] [d0000000066a9104] .xfs_do_writepage+0x414/0x930 [xfs]
[ 2854.688430] [c0000000fe3af2b0] [c00000000025df6c] .write_cache_pages+0x5fc/0x820
[ 2854.688481] [c0000000fe3af470] [d0000000066a8a5c] .xfs_vm_writepages+0x8c/0xd0 [xfs]
[ 2854.688487] [c0000000fe3af540] [c00000000025f62c] .do_writepages+0x3c/0x70
[ 2854.688493] [c0000000fe3af5b0] [c00000000035b1ec] .__writeback_single_inode+0x5bc/0xd50
[ 2854.688499] [c0000000fe3af680] [c00000000035c3c0] .writeback_sb_inodes+0x380/0x730
[ 2854.688505] [c0000000fe3af7f0] [c00000000035ca44] .wb_writeback+0x194/0x920
[ 2854.688510] [c0000000fe3af960] [c00000000035ddcc] .wb_workfn+0x19c/0xa40
[ 2854.688516] [c0000000fe3afad0] [c0000000000dfc74] .process_one_work+0x264/0x8f0
[ 2854.688522] [c0000000fe3afbc0] [c0000000000e0388] .worker_thread+0x88/0x520
[ 2854.688528] [c0000000fe3afcb0] [c0000000000e9ac4] .kthread+0x114/0x140
[ 2854.688534] [c0000000fe3afe30] [c000000000009578] .ret_from_kernel_thread+0x58/0x60
[ 2854.688539] Instruction dump:
[ 2854.688543] 60420000 7c0802a6 3d420000 7c691b78 7c862378 e88abe38 7ca72b78 38600000
[ 2854.688555] 7d254b78 f8010010 f821ff91 4bfffcf9 <0fe00000> 38210070 e8010010 7c0803a6
[ 2854.688568] ---[ end trace 872ac2709186f781 ]---

[then the XFS warning repeated for a few times triggered by different
pid]

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
