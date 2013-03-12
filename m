Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5617C7F4E
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 23:32:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BAEFAAC002
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 21:32:30 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id lcTroT9RJXVu0N2I for
	<xfs@oss.sgi.com>; Mon, 11 Mar 2013 21:32:28 -0700 (PDT)
Received: from zmail14.collab.prod.int.phx2.redhat.com
	(zmail14.collab.prod.int.phx2.redhat.com [10.5.83.16])
	by mx4-phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r2C4WS6b012270
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 00:32:28 -0400
Date: Tue, 12 Mar 2013 00:32:28 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <782268481.12604851.1363062748244.JavaMail.root@redhat.com>
In-Reply-To: <1868681549.12603593.1363061997919.JavaMail.root@redhat.com>
Subject: 3.9-rc2 xfs panic
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

Just came across when running xfstests using 3.9-rc2 kernel on a power7
box with addition of this patch which fixed a known issue,
http://people.redhat.com/qcai/stable/01-fix-double-fetch-hlist.patch

The log shows it was happened around test case 370 with
TEST_PARAM_BLKSIZE = 2048

Some more information:
xfsprogs version = 3.1.10
number of CPUs = 32
Swap Size = 4047 MB
Mem Size = 4046 M

Still reproducing and bisecting, so this is just a head-up to see if
helps.

CAI Qian

[31797.113368] XFS (loop1): xfs_trans_ail_delete_bulk: attempting to delete a log item that is not in the AIL 
[31797.113383] XFS (loop1): xfs_do_force_shutdown(0x2) called from line 743 of file fs/xfs/xfs_trans_ail.c.  Return address = 0xd000000000f22838 
[31797.113430] Buffer I/O error on device loop1, logical block 66965 
[31797.113440] lost page write due to I/O error on loop1 
[31797.113446] Buffer I/O error on device loop1, logical block 66966 
[31797.113450] lost page write due to I/O error on loop1 
[31797.113456] Buffer I/O error on device loop1, logical block 66967 
[31797.113461] lost page write due to I/O error on loop1 
[31797.113466] Buffer I/O error on device loop1, logical block 66968 
[31797.113472] lost page write due to I/O error on loop1 
[31797.113477] Buffer I/O error on device loop1, logical block 66969 
[31797.113482] lost page write due to I/O error on loop1 
[31797.113881] XFS (loop1): Log I/O Error Detected.  Shutting down filesystem 
[31797.113887] XFS (loop1): Please umount the filesystem and rectify the problem(s) 
[31797.114000] XFS (loop1): metadata I/O error: block 0xc0002 ("xfs_trans_read_buf_map") error 5 numblks 1 
[31797.114048] XFS (loop1): metadata I/O error: block 0xc0002 ("xfs_trans_read_buf_map") error 5 numblks 1 
[31797.150364] Buffer I/O error on device loop1, logical block 33940 
[31797.150380] lost page write due to I/O error on loop1 
[31797.150389] Buffer I/O error on device loop1, logical block 33941 
[31797.150395] lost page write due to I/O error on loop1 
[31797.150403] Buffer I/O error on device loop1, logical block 33942 
[31797.150408] lost page write due to I/O error on loop1 
[31797.150415] Buffer I/O error on device loop1, logical block 33943 
[31797.150421] lost page write due to I/O error on loop1 
[31797.150429] Buffer I/O error on device loop1, logical block 33944 
[31797.150436] lost page write due to I/O error on loop1 
[-- MARK -- Mon Mar 11 14:15:00 2013] 
[31817.159550] XFS (loop1): xfs_log_force: error 5 returned. 
[31817.166204] XFS (loop1): xfs_log_force: error 5 returned. 
[31817.166551] XFS (loop1): xfs_log_force: error 5 returned. 
[31817.508411] XFS (loop0): Mounting Filesystem 
[31817.566235] XFS (loop0): Ending clean mount 
[31819.094713] XFS (loop0): Mounting Filesystem 
[31819.152248] XFS (loop0): Ending clean mount 
[31819.348238] XFS (loop1): Mounting Filesystem 
[31819.349879] XFS (loop1): Ending clean mount 
[31819.561366] XFS (loop0): Mounting Filesystem 
[31819.616607] XFS (loop0): Ending clean mount 
[31819.990833] XFS (loop1): Mounting Filesystem 
[31819.992652] XFS (loop1): Ending clean mount 
[31819.992768] XFS (loop1): Quotacheck needed: Please wait. 
[31820.051134] XFS (loop1): Quotacheck: Done. 
[31832.534868] Unable to handle kernel paging request for data at address 0x5841474900000001 
[31832.534881] Faulting instruction address: 0xc0000000001f8070 
[31832.534888] Oops: Kernel access of bad area, sig: 11 [#1] 
[31832.534891] SMP NR_CPUS=1024 NUMA pSeries 
[31832.534899] Modules linked in: tun(F) binfmt_misc(F) hidp(F) cmtp(F) kernelcapi(F) rfcomm(F) l2tp_ppp(F) l2tp_netlink(F) l2tp_core(F) bnep(F) nfc(F) af_802154(F) pppoe(F) pppox(F) ppp_generic(F) slhc(F) rds(F) af_key(F) atm(F) sctp(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) btrfs(F) raid6_pq(F) xor(F) vfat(F) fat(F) nfsv3(F) nfs_acl(F) nfnetlink_log(F) nfnetlink(F) bluetooth(F) rfkill(F) nfsv2(F) nfs(F) dns_resolver(F) lockd(F) sunrpc(F) fscache(F) nf_tproxy_core(F) nls_koi8_u(F) nls_cp932(F) ts_kmp(F) fuse(F) sg(F) ibmveth(F) xfs(F) libcrc32c(F) sd_mod(F) crc_t10dif(F) ibmvscsi(F) scsi_transport_srp(F) scsi_tgt(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) [last unloaded: ipt_REJECT] 
[31832.534978] NIP: c0000000001f8070 LR: c000000000192f6c CTR: c000000000192f50 
[31832.534984] REGS: c0000000f1c125f0 TRAP: 0300   Tainted: GF       W     (3.9.0-rc2+) 
[31832.534989] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 24022024  XER: 20000001 
[31832.535003] SOFTE: 0 
[31832.535006] CFAR: c000000000005f1c 
[31832.535009] DAR: 5841474900000001, DSISR: 40000000 
[31832.535013] TASK = c00000003f0111c0[16795] 'loop1' THREAD: c0000000f1c10000 CPU: 30 
GPR00: c000000000192f6c c0000000f1c12870 c0000000010f3a48 c0000000fe015a00  
GPR04: 0000000000011220 0000000000000080 00000000000f3aaf c0000000018d5840  
GPR08: 0000000000000000 0000000000000000 0000000000000000 c0000000004e3300  
GPR12: 0000000044024024 c00000000f247800 c0000000010d01b0 0000000000000000  
GPR16: 0000000000000001 0000000000000000 c0000000009d9020 c0000000009d9060  
GPR20: c0000000009d9048 0000000000000020 000000000000007f 0000000000000000  
GPR24: 0000000000000fe0 c0000000010d1020 c0000000fe015a00 0000000000000000  
GPR28: c000000000192f6c 0000000000011220 5841474900000001 c0000000fe015a00  
[31832.535086] NIP [c0000000001f8070] .kmem_cache_alloc+0xb0/0x2d0 
[31832.535092] LR [c000000000192f6c] .mempool_alloc_slab+0x1c/0x30 
[31832.535096] Call Trace: 
[31832.535101] [c0000000f1c12870] [0000000000016ac3] 0x16ac3 (unreliable) 
[31832.535108] [c0000000f1c12920] [c000000000192f6c] .mempool_alloc_slab+0x1c/0x30 
[31832.535114] [c0000000f1c12990] [c000000000193108] .mempool_alloc+0x88/0x1c0 
[31832.535122] [c0000000f1c12a80] [c0000000004e1824] .scsi_sg_alloc+0x64/0xc0 
[31832.535129] [c0000000f1c12af0] [c0000000003e09f8] .__sg_alloc_table+0xa8/0x190 
[31832.535135] [c0000000f1c12bc0] [c0000000004e15f0] .scsi_alloc_sgtable+0x40/0x90 
[31832.535142] [c0000000f1c12c40] [c0000000004e1668] .scsi_init_sgtable+0x28/0x90 
[31832.535148] [c0000000f1c12cc0] [c0000000004e19e0] .scsi_init_io+0x40/0x1a0 
[31832.535157] [c0000000f1c12d60] [d000000000c02e78] .sd_prep_fn+0x128/0xac0 [sd_mod] 
[31832.535164] [c0000000f1c12e20] [c0000000003a611c] .blk_peek_request+0xfc/0x2d0 
[31832.535171] [c0000000f1c12eb0] [c0000000004e2c08] .scsi_request_fn+0xb8/0x6d0 
[31832.535178] [c0000000f1c12fa0] [c00000000039d7c0] .__blk_run_queue+0x50/0x80 
[31832.535184] [c0000000f1c13020] [c0000000003a2184] .queue_unplugged+0xe4/0x100 
[31832.535190] [c0000000f1c130c0] [c0000000003a67d8] .blk_flush_plug_list+0x248/0x2e0 
[31832.535197] [c0000000f1c13180] [c0000000003a6bcc] .blk_queue_bio+0x2fc/0x490 
[31832.535203] [c0000000f1c13230] [c0000000003a436c] .generic_make_request+0x11c/0x180 
[31832.535210] [c0000000f1c132c0] [c0000000003a4484] .submit_bio+0xb4/0x1e0 
[31832.535245] [c0000000f1c13380] [d000000000eaffa0] .xfs_submit_ioend_bio.isra.10+0x70/0x90 [xfs] 
[31832.535286] [c0000000f1c133f0] [d000000000eb00f0] .xfs_submit_ioend+0x130/0x190 [xfs] 
[31832.535343] [c0000000f1c134a0] [d000000000eb045c] .xfs_vm_writepage+0x30c/0x670 [xfs] 
[31832.535349] [c0000000f1c135d0] [c00000000019d050] .__writepage+0x30/0x90 
[31832.535356] [c0000000f1c13650] [c00000000019d728] .write_cache_pages+0x208/0x4f0 
[31832.535362] [c0000000f1c137e0] [c00000000019da5c] .generic_writepages+0x4c/0xa0 
[31832.535395] [c0000000f1c138a0] [d000000000eaea10] .xfs_vm_writepages+0x60/0x90 [xfs] 
[31832.535411] [c0000000f1c13930] [c00000000019ee7c] .do_writepages+0x3c/0x70 
[31832.535424] [c0000000f1c139a0] [c0000000001914b8] .__filemap_fdatawrite_range+0x68/0x80 
[31832.535430] [c0000000f1c13a40] [c000000000191610] .filemap_write_and_wait_range+0x70/0xc0 
[31832.535463] [c0000000f1c13ad0] [d000000000eb7970] .xfs_file_fsync+0x60/0x250 [xfs] 
[31832.535479] [c0000000f1c13b90] [c00000000024c278] .vfs_fsync+0x48/0x70 
[31832.535497] [c0000000f1c13c00] [c0000000004d299c] .loop_thread+0x3ec/0x5b0 
[31832.535503] [c0000000f1c13d30] [c0000000000b58c8] .kthread+0xe8/0xf0 
[31832.535510] [c0000000f1c13e30] [c000000000009f64] .ret_from_kernel_thread+0x64/0x80 
[31832.535516] Instruction dump: 
[31832.535519] 4be17f11 60000000 e93f0000 e94d0040 7ce95214 e8c70008 7fc9502a 2fbe0000  
[31832.535532] 41de01fc e95f0022 e93f0000 79290720 <7f3e502a> 0b090000 0b1b0000 39200000  
[31832.535557] ---[ end trace 8bfd449aae38f917 ]--- 
[31832.536965]  
[31892.635116] INFO: rcu_sched detected stalls on CPUs/tasks: { 30 31} (detected by 28, t=6002 jiffies, g=390021, c=390020, q=417) 
[31892.635141] Task dump for CPU 30: 
[31892.635146] loop1           R  running task        0 16795      2 0x00000884 
[31892.635155] Call Trace: 
[31892.635176] [c0000000f1c12f10] [0000000000000001] 0x1 (unreliable) 
[31892.635183] Task dump for CPU 31: 
[31892.635187] swapper/31      R  running task        0     0      1 0x00000804 
[31892.635194] Call Trace: 
[32072.684667] INFO: rcu_sched detected stalls on CPUs/tasks: { 30 31} (detected by 28, t=24007 jiffies, g=390021, c=390020, q=580) 
[32072.684694] Task dump for CPU 30: 
[32072.684700] loop1           R  running task        0 16795      2 0x00000884 
[32072.684708] Call Trace: 
[32072.684729] [c0000000f1c12f10] [0000000000000001] 0x1 (unreliable) 
[32072.684737] Task dump for CPU 31: 
[32072.684741] swapper/31      R  running task        0     0      1 0x00000804 
[32072.684748] Call Trace: 
[-- MARK -- Mon Mar 11 14:20:00 2013] 
[32252.734223] INFO: rcu_sched detected stalls on CPUs/tasks: { 30 31} (detected by 22, t=42012 jiffies, g=390021, c=390020, q=619) 
[32252.734248] Task dump for CPU 30: 
[32252.734254] loop1           R  running task        0 16795      2 0x00000884 
[32252.734262] Call Trace: 
[32252.734282] [c0000000f1c12f10] [0000000000000001] 0x1 (unreliable) 
[32252.734289] Task dump for CPU 31: 
[32252.734293] swapper/31      R  running task        0     0      1 0x00000804 
[32252.734300] Call Trace: 
[-- MARK -- Mon Mar 11 14:25:00 2013] 
[32432.783781] INFO: rcu_sched detected stalls on CPUs/tasks: { 30 31} (detected by 28, t=60017 jiffies, g=390021, c=390020, q=630) 
[32432.783809] Task dump for CPU 30: 
[32432.783815] loop1           R  running task        0 16795      2 0x00000884 
[32432.783823] Call Trace: 
[32432.783845] [c0000000f1c12f10] [0000000000000001] 0x1 (unreliable) 
[32432.783852] Task dump for CPU 31: 
[32432.783856] swapper/31      R  running task        0     0      1 0x00000804 
[32432.783864] Call Trace: 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
