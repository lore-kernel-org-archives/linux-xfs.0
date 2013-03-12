Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 399D87F51
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 01:07:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 283B2304039
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 23:07:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	rv6wDFl1b2NOKP1p for <xfs@oss.sgi.com>;
	Mon, 11 Mar 2013 23:07:04 -0700 (PDT)
Date: Tue, 12 Mar 2013 17:07:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9-rc2 xfs panic
Message-ID: <20130312060701.GI21651@dastard>
References: <1868681549.12603593.1363061997919.JavaMail.root@redhat.com>
	<782268481.12604851.1363062748244.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <782268481.12604851.1363062748244.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 12, 2013 at 12:32:28AM -0400, CAI Qian wrote:
> Just came across when running xfstests using 3.9-rc2 kernel on a power7
> box with addition of this patch which fixed a known issue,
> http://people.redhat.com/qcai/stable/01-fix-double-fetch-hlist.patch
> 
> The log shows it was happened around test case 370 with
> TEST_PARAM_BLKSIZE = 2048

That doesn't sound like xfstests. it only has 305 tests, and no
parameters like TEST_PARAM_BLKSIZE....

> Some more information:
> xfsprogs version = 3.1.10
> number of CPUs = 32
> Swap Size = 4047 MB
> Mem Size = 4046 M
> 
> Still reproducing and bisecting, so this is just a head-up to see if
> helps.
> 
> CAI Qian
> 
> [31797.113368] XFS (loop1): xfs_trans_ail_delete_bulk: attempting to delete a log item that is not in the AIL 
> [31797.113383] XFS (loop1): xfs_do_force_shutdown(0x2) called from line 743 of file fs/xfs/xfs_trans_ail.c.  Return address = 0xd000000000f22838 

Shutdown for an in-memory problem of some kind....

> [31817.508411] XFS (loop0): Mounting Filesystem 
> [31817.566235] XFS (loop0): Ending clean mount 
> [31819.094713] XFS (loop0): Mounting Filesystem 
> [31819.152248] XFS (loop0): Ending clean mount 
> [31819.348238] XFS (loop1): Mounting Filesystem 
> [31819.349879] XFS (loop1): Ending clean mount 
> [31819.561366] XFS (loop0): Mounting Filesystem 
> [31819.616607] XFS (loop0): Ending clean mount 
> [31819.990833] XFS (loop1): Mounting Filesystem 
> [31819.992652] XFS (loop1): Ending clean mount 
> [31819.992768] XFS (loop1): Quotacheck needed: Please wait. 
> [31820.051134] XFS (loop1): Quotacheck: Done. 
> [31832.534868] Unable to handle kernel paging request for data at address 0x5841474900000001 

And after remounting the filesystemi a couple of times, it's tried
to follow an AGI buffer header (magic # XAGI, seqno = 1) as though
it was a pointer. I can't think of why that would be
executed....

> [31832.534881] Faulting instruction address: 0xc0000000001f8070 
> [31832.534888] Oops: Kernel access of bad area, sig: 11 [#1] 
> [31832.534891] SMP NR_CPUS=1024 NUMA pSeries 
> [31832.534899] Modules linked in: tun(F) binfmt_misc(F) hidp(F) cmtp(F) kernelcapi(F) rfcomm(F) l2tp_ppp(F) l2tp_netlink(F) l2tp_core(F) bnep(F) nfc(F) af_802154(F) pppoe(F) pppox(F) ppp_generic(F) slhc(F) rds(F) af_key(F) atm(F) sctp(F) ip6table_filter(F) ip6_tables(F) iptable_filter(F) ip_tables(F) btrfs(F) raid6_pq(F) xor(F) vfat(F) fat(F) nfsv3(F) nfs_acl(F) nfnetlink_log(F) nfnetlink(F) bluetooth(F) rfkill(F) nfsv2(F) nfs(F) dns_resolver(F) lockd(F) sunrpc(F) fscache(F) nf_tproxy_core(F) nls_koi8_u(F) nls_cp932(F) ts_kmp(F) fuse(F) sg(F) ibmveth(F) xfs(F) libcrc32c(F) sd_mod(F) crc_t10dif(F) ibmvscsi(F) scsi_transport_srp(F) scsi_tgt(F) dm_mirror(F) dm_region_hash(F) dm_log(F) dm_mod(F) [last unloaded: ipt_REJECT] 
> [31832.534978] NIP: c0000000001f8070 LR: c000000000192f6c CTR: c000000000192f50 
> [31832.534984] REGS: c0000000f1c125f0 TRAP: 0300   Tainted: GF       W     (3.9.0-rc2+) 
> [31832.534989] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 24022024  XER: 20000001 
> [31832.535003] SOFTE: 0 
> [31832.535006] CFAR: c000000000005f1c 
> [31832.535009] DAR: 5841474900000001, DSISR: 40000000 
> [31832.535013] TASK = c00000003f0111c0[16795] 'loop1' THREAD: c0000000f1c10000 CPU: 30 
> GPR00: c000000000192f6c c0000000f1c12870 c0000000010f3a48 c0000000fe015a00  
> GPR04: 0000000000011220 0000000000000080 00000000000f3aaf c0000000018d5840  
> GPR08: 0000000000000000 0000000000000000 0000000000000000 c0000000004e3300  
> GPR12: 0000000044024024 c00000000f247800 c0000000010d01b0 0000000000000000  
> GPR16: 0000000000000001 0000000000000000 c0000000009d9020 c0000000009d9060  
> GPR20: c0000000009d9048 0000000000000020 000000000000007f 0000000000000000  
> GPR24: 0000000000000fe0 c0000000010d1020 c0000000fe015a00 0000000000000000  
> GPR28: c000000000192f6c 0000000000011220 5841474900000001 c0000000fe015a00  
> [31832.535086] NIP [c0000000001f8070] .kmem_cache_alloc+0xb0/0x2d0 
> [31832.535092] LR [c000000000192f6c] .mempool_alloc_slab+0x1c/0x30 
> [31832.535096] Call Trace: 
> [31832.535101] [c0000000f1c12870] [0000000000016ac3] 0x16ac3 (unreliable) 
> [31832.535108] [c0000000f1c12920] [c000000000192f6c] .mempool_alloc_slab+0x1c/0x30 
> [31832.535114] [c0000000f1c12990] [c000000000193108] .mempool_alloc+0x88/0x1c0 
> [31832.535122] [c0000000f1c12a80] [c0000000004e1824] .scsi_sg_alloc+0x64/0xc0 
> [31832.535129] [c0000000f1c12af0] [c0000000003e09f8] .__sg_alloc_table+0xa8/0x190 
> [31832.535135] [c0000000f1c12bc0] [c0000000004e15f0] .scsi_alloc_sgtable+0x40/0x90 
> [31832.535142] [c0000000f1c12c40] [c0000000004e1668] .scsi_init_sgtable+0x28/0x90 
> [31832.535148] [c0000000f1c12cc0] [c0000000004e19e0] .scsi_init_io+0x40/0x1a0 
> [31832.535157] [c0000000f1c12d60] [d000000000c02e78] .sd_prep_fn+0x128/0xac0 [sd_mod] 
> [31832.535164] [c0000000f1c12e20] [c0000000003a611c] .blk_peek_request+0xfc/0x2d0 
> [31832.535171] [c0000000f1c12eb0] [c0000000004e2c08] .scsi_request_fn+0xb8/0x6d0 
> [31832.535178] [c0000000f1c12fa0] [c00000000039d7c0] .__blk_run_queue+0x50/0x80 
> [31832.535184] [c0000000f1c13020] [c0000000003a2184] .queue_unplugged+0xe4/0x100 
> [31832.535190] [c0000000f1c130c0] [c0000000003a67d8] .blk_flush_plug_list+0x248/0x2e0 
> [31832.535197] [c0000000f1c13180] [c0000000003a6bcc] .blk_queue_bio+0x2fc/0x490 
> [31832.535203] [c0000000f1c13230] [c0000000003a436c] .generic_make_request+0x11c/0x180 
> [31832.535210] [c0000000f1c132c0] [c0000000003a4484] .submit_bio+0xb4/0x1e0 
> [31832.535245] [c0000000f1c13380] [d000000000eaffa0] .xfs_submit_ioend_bio.isra.10+0x70/0x90 [xfs] 
> [31832.535286] [c0000000f1c133f0] [d000000000eb00f0] .xfs_submit_ioend+0x130/0x190 [xfs] 
> [31832.535343] [c0000000f1c134a0] [d000000000eb045c] .xfs_vm_writepage+0x30c/0x670 [xfs] 
> [31832.535349] [c0000000f1c135d0] [c00000000019d050] .__writepage+0x30/0x90 
> [31832.535356] [c0000000f1c13650] [c00000000019d728] .write_cache_pages+0x208/0x4f0 
> [31832.535362] [c0000000f1c137e0] [c00000000019da5c] .generic_writepages+0x4c/0xa0 
> [31832.535395] [c0000000f1c138a0] [d000000000eaea10] .xfs_vm_writepages+0x60/0x90 [xfs] 
> [31832.535411] [c0000000f1c13930] [c00000000019ee7c] .do_writepages+0x3c/0x70 
> [31832.535424] [c0000000f1c139a0] [c0000000001914b8] .__filemap_fdatawrite_range+0x68/0x80 
> [31832.535430] [c0000000f1c13a40] [c000000000191610] .filemap_write_and_wait_range+0x70/0xc0 
> [31832.535463] [c0000000f1c13ad0] [d000000000eb7970] .xfs_file_fsync+0x60/0x250 [xfs] 
> [31832.535479] [c0000000f1c13b90] [c00000000024c278] .vfs_fsync+0x48/0x70 
> [31832.535497] [c0000000f1c13c00] [c0000000004d299c] .loop_thread+0x3ec/0x5b0 
> [31832.535503] [c0000000f1c13d30] [c0000000000b58c8] .kthread+0xe8/0xf0 
> [31832.535510] [c0000000f1c13e30] [c000000000009f64] .ret_from_kernel_thread+0x64/0x80 

So, looks like memory corruption - a corrupted slab, perhaps? Can
you turn on memory poisoning, debugging, etc?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
