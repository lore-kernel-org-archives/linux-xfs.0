Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BC2077F37
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 21:44:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9EF58304067
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 19:44:40 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id 5N6PHoZETCtVKPtg for
	<xfs@oss.sgi.com>; Tue, 12 Mar 2013 19:44:39 -0700 (PDT)
Date: Tue, 12 Mar 2013 22:44:36 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <1063371063.191362.1363142676803.JavaMail.root@redhat.com>
In-Reply-To: <20130312074608.GL21651@dastard>
Subject: Re: 3.9-rc2 xfs panic
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Eek, got another NULL pointer on an x64 system also. Looks like from
xfstests case 110. Same user-space version as the one in the ppc64
case. Still trying to reproduce and without more debugging options
enabled if possible.

Swap Size               = 7983 MB
Mem Size                = 7852 MB
Number of Processors    = 16

meta-data=/dev/loop0             isize=256    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=2048   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=2048   blocks=5120, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

CAI Qian

[30706.240701] XFS (loop1): xfs_trans_ail_delete_bulk: attempting to delete a log item that is not in the AIL 
[30706.242124] XFS (loop1): xfs_do_force_shutdown(0x2) called from line 743 of file fs/xfs/xfs_trans_ail.c.  Return address = 0xffffffffa03c03ef 
[30706.245280] XFS (loop1): Log I/O Error Detected.  Shutting down filesystem 
[30706.246311] XFS (loop1): Please umount the filesystem and rectify the problem(s) 
[30707.279880] XFS (loop0): Mounting Filesystem 
[30707.290512] XFS (loop0): Ending clean mount 
[30708.966751] XFS (loop1): xfs_log_force: error 5 returned. 
[30708.977075] XFS (loop1): xfs_log_force: error 5 returned. 
[30708.978074] BUG: unable to handle kernel NULL pointer dereference at 0000000000000230 
[30708.979629] IP: [<ffffffffa03655e7>] xfs_bdstrat_cb+0x27/0xd0 [xfs] 
[30708.980846] PGD 0  
[30708.981354] Oops: 0000 [#1] SMP  
[30708.982012] Modules linked in: fuse(F) scsi_transport_iscsi(F) tun(F) ipt_ULOG(F) binfmt_misc(F) bnep(F) hidp(F) nfc(F) af_802154(F) pppoe(F) pppox(F) ppp_generic(F) slhc(F) rds(F) af_key(F) atm(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) btrfs(F) zlib_deflate(F) raid6_pq(F) xor(F) vfat(F) fat(F) nfsv3(F) nfs_acl(F) nfsv2(F) nfs(F) lockd(F) sunrpc(F) dns_resolver(F) fscache(F) nfnetlink_log(F) nfnetlink(F) bluetooth(F) rfkill(F) nf_tproxy_core(F) nls_koi8_u(F) nls_cp932(F) ts_kmp(F) sctp(F) sg(F) ipmi_si(F) kvm_amd(F) bnx2(F) hpwdt(F) ipmi_msghandler(F) hpilo(F) kvm(F) amd64_edac_mod(F) serio_raw(F) edac_mce_amd(F) pcspkr(F) shpchp(F) edac_core(F) microcode(F) k10temp(F) xfs(F) libcrc32c(F) hpsa(F) sr_mod(F) cdrom(F) ata_generic(F) radeon(F) i2c_algo_bit(F) pata_acpi(F) qla2xxx(F) drm_kms_helper(F) ttm(F) pata_amd(F) scsi_transport_fc(F) drm(F) scsi_tgt(F) libata(F) cciss(F) i2c_core(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) [last unloade
 d: ipt_REJECT] 
[30709.000425] CPU 11  
[30709.000749] Pid: 29444, comm: xfsaild/loop1 Tainted: GF       W    3.9.0-rc2+ #1 HP ProLiant DL585 G5    
[30709.002464] RIP: 0010:[<ffffffffa03655e7>]  [<ffffffffa03655e7>] xfs_bdstrat_cb+0x27/0xd0 [xfs] 
[30709.004076] RSP: 0018:ffff8801f8d21d18  EFLAGS: 00010286 
[30709.005089] RAX: 0000000000000000 RBX: ffff88017c672b80 RCX: dead000000200200 
[30709.006415] RDX: ffff88017c670df8 RSI: 00000000802a0013 RDI: ffff88017c670d80 
[30709.007791] RBP: ffff8801f8d21d38 R08: ffff88017c670df8 R09: 0000000000000001 
[30709.009274] R10: ffffea0009e43c00 R11: ffffffffa037b055 R12: ffff88017c670d80 
[30709.010597] R13: ffff8801f8d21dd8 R14: ffff88025cfba5e0 R15: ffff88017c672b80 
[30709.011973] FS:  00007fdebffff700(0000) GS:ffff88027fb00000(0000) knlGS:00000000f75736c0 
[30709.013575] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[30709.014760] CR2: 0000000000000230 CR3: 000000010ac7b000 CR4: 00000000000007e0 
[30709.016188] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 
[30709.017571] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 
[30709.018957] Process xfsaild/loop1 (pid: 29444, threadinfo ffff8801f8d20000, task ffff8801e2ea65c0) 
[30709.020766] Stack: 
[30709.021198]  0000000000000000 ffff88017c672b80 0000000000000000 ffff8801f8d21dd8 
[30709.022712]  ffff8801f8d21dc8 ffffffffa0365801 ffff88017c670df8 ffff88025cfba658 
[30709.024102]  00000000f8d21d78 ffffffffa03661b0 ffff88017c670d80 0000000091827364 
[30709.025480] Call Trace: 
[30709.025938]  [<ffffffffa0365801>] __xfs_buf_delwri_submit+0x171/0x1e0 [xfs] 
[30709.027202]  [<ffffffffa03661b0>] ? xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs] 
[30709.028519]  [<ffffffffa03bf800>] ? xfs_trans_ail_cursor_done+0x20/0x30 [xfs] 
[30709.029824]  [<ffffffffa03661b0>] xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs] 
[30709.031223]  [<ffffffffa03bfae2>] xfsaild+0x222/0x5e0 [xfs] 
[30709.032291]  [<ffffffffa03bf8c0>] ? xfs_trans_ail_cursor_first+0xb0/0xb0 [xfs] 
[30709.033661]  [<ffffffff81086a50>] kthread+0xc0/0xd0 
[30709.034644]  [<ffffffff81086990>] ? kthread_create_on_node+0x120/0x120 
[30709.035870]  [<ffffffff8162fb6c>] ret_from_fork+0x7c/0xb0 
[30709.036932]  [<ffffffff81086990>] ? kthread_create_on_node+0x120/0x120 
[30709.038184] Code: 1f 44 00 00 66 66 66 66 90 55 48 89 e5 48 83 ec 20 4c 89 65 f0 48 89 5d e8 49 89 fc 4c 89 6d f8 48 8b 87 90 00 00 00 48 8b 40 18 <f6> 80 30 02 00 00 10 74 30 4c 8b 6d 08 66 66 66 66 90 49 83 bc  
[30709.042158] RIP  [<ffffffffa03655e7>] xfs_bdstrat_cb+0x27/0xd0 [xfs] 
[30709.043486]  RSP <ffff8801f8d21d18> 
[30709.044224] CR2: 0000000000000230 
[30709.060200] ---[ end trace e0ed74f75ad92c73 ]--- 
[30734.047588] XFS (loop1): xfs_log_force: error 5 returned. 
[30764.108856] XFS (loop1): xfs_log_force: error 5 returned. 
[30794.170118] XFS (loop1): xfs_log_force: error 5 returned. 
[30824.231359] XFS (loop1): xfs_log_force: error 5 returned. 
[30854.292624] XFS (loop1): xfs_log_force: error 5 returned. 
[-- MARK -- Tue Mar 12 09:30:00 2013] 
[30884.353854] XFS (loop1): xfs_log_force: error 5 returned. 
[30914.415138] XFS (loop1): xfs_log_force: error 5 returned. 
[30944.476396] XFS (loop1): xfs_log_force: error 5 returned. 
[30974.537638] XFS (loop1): xfs_log_force: error 5 returned. 
[31004.598901] XFS (loop1): xfs_log_force: error 5 returned. 
[31034.660150] XFS (loop1): xfs_log_force: error 5 returned. 
[31064.721412] XFS (loop1): xfs_log_force: error 5 returned. 
[31094.782674] XFS (loop1): xfs_log_force: error 5 returned. 
[31124.843915] XFS (loop1): xfs_log_force: error 5 returned. 
[31154.905174] XFS (loop1): xfs_log_force: error 5 returned. 
[-- MARK -- Tue Mar 12 09:35:00 2013] 
[31184.966422] XFS (loop1): xfs_log_force: error 5 returned. 
[31215.027675] XFS (loop1): xfs_log_force: error 5 returned. 
[31245.088943] XFS (loop1): xfs_log_force: error 5 returned. 
[31275.150185] XFS (loop1): xfs_log_force: error 5 returned. 
[31305.211448] XFS (loop1): xfs_log_force: error 5 returned. 
[31335.272787] XFS (loop1): xfs_log_force: error 5 returned.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
