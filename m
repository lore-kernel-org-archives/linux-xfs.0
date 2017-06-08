Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750725AbdFHFhx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Jun 2017 01:37:53 -0400
Date: Thu, 8 Jun 2017 13:37:50 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [v4.12-rc1 regression] nfs server crashed in fstests run
Message-ID: <20170608053750.GE19952@eguan.usersys.redhat.com>
References: <20170602060457.GG23805@eguan.usersys.redhat.com>
 <20170607192338.GG4530@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607192338.GG4530@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jun 07, 2017 at 12:23:38PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 02, 2017 at 02:04:57PM +0800, Eryu Guan wrote:
> > Hi all,
> > 
> > Starting from 4.12-rc1 kernel, I saw Linux nfs server crashes all the
> > time in my fstests (xfstests) runs, I appended the console log of an
> > NFSv3 crash to the end of this mail.
> > 
> > I was exporting a directory resided on XFS, and loopback mounted the NFS
> > export on localhost. Both NFSv3 and NFSv4 could hit this crash. The
> > crash usually happens when running test case generic/029 or generic/095.
> > 
> > But the problem is, there's no easy and efficient way to reproduce it, I
> > tried run only generic/029 and generic/095 in a loop for 1000 times but
> > failed, I also tried run the 'quick' group tests only for 50 iterations
> > but failed again. It seems that the only reliable way to reproduce it is
> > run the 'auto' group tests for 20 iterations.
> > 
> > 	i=0
> > 	while [ $i -lt 20 ]; do
> > 		./check -nfs -g auto
> > 		((i++))
> > 	done
> > 
> > And usually server crashed within 5 iterations, but at times it could
> > survive 10 iterations and only crashed if you left it running for more
> > iterations. This makes it hard to bisect and bisecting is very
> > time-consuming.
> > 
> > (The bisecting is running now, it needs a few days to finish. My first
> > two attempts pointed first bad commit to some mm patches, but reverting
> > that patch didn't prevent server from crashing, so I enlarged the loop
> > count and started bisecting for the third time).
> > 
> > If more info is needed please let me know.
> > 
> > Thanks,
> > Eryu
> > 
> > 
> > [88895.796834] run fstests generic/028 at 2017-06-01 00:43:18
> > [88900.945420] run fstests generic/029 at 2017-06-01 00:43:23
> > [88901.127315] BUG: unable to handle kernel paging request at ffffffffc0360e12
> > [88901.135095] IP: report_bug+0x64/0x100
> > [88901.139177] PGD 3b7c0c067
> > [88901.139177] P4D 3b7c0c067
> > [88901.142194] PUD 3b7c0e067
> > [88901.145209] PMD 469e33067
> > [88901.148225] PTE 80000004675f4161
> > [88901.151240]
> > [88901.156497] Oops: 0003 [#1] SMP
> > [88901.159997] Modules linked in: loop dm_mod nfsv3 nfs fscache ext4 jbd2 mbcache intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm nfsd irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc ipmi_ssif cdc_ether aesni_intel iTCO_wdt usbnet crypto_simd ipmi_si glue_helper sg iTCO_vendor_support wmi mii cryptd ipmi_devintf ipmi_msghandler auth_rpcgss shpchp i2c_i801 pcspkr ioatdma lpc_ich nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops igb ttm drm ptp pps_core dca megaraid_sas crc32c_intel i2c_algo_bit i2c_core
> > [88901.221606] CPU: 9 PID: 3278 Comm: nfsd Not tainted 4.12.0-rc3 #42
> > [88901.228500] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS -[VVE124AUS-1.30]- 11/21/2012
> > [88901.238885] task: ffffa10062d12d00 task.stack: ffffc2820478c000
> > [88901.245488] RIP: 0010:report_bug+0x64/0x100
> > [88901.250153] RSP: 0018:ffffc2820478f598 EFLAGS: 00010202
> > [88901.255980] RAX: ffffffffc0360e08 RBX: ffffffffc0301cdc RCX: 0000000000000001
> > [88901.263940] RDX: 0000000000000907 RSI: ffffffffc038bc80 RDI: ffffffffffff0d22
> > [88901.271901] RBP: ffffc2820478f5b8 R08: 0000000000000001 R09: 00000000000001cc
> > [88901.279861] R10: ffffffffb6a36f67 R11: 0000000000000000 R12: ffffc2820478f6e8
> > [88901.287821] R13: ffffffffc0351b2a R14: 00000000000003fb R15: 0000000000000004
> > [88901.295783] FS:  0000000000000000(0000) GS:ffffa1007f6c0000(0000) knlGS:0000000000000000
> > [88901.304818] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [88901.311227] CR2: ffffffffc0360e12 CR3: 00000003b7c09000 CR4: 00000000000406e0
> > [88901.319188] Call Trace:
> > [88901.321920]  do_trap+0x16a/0x190
> > [88901.325519]  do_error_trap+0x89/0x110
> > [88901.329652]  ? xfs_do_writepage+0x65c/0x680 [xfs]
> 
> Hmm, does gdb think this address is at:
> 
> (gdb) l *(xfs_do_writepage+0x65c)
> 0x7c17c is in xfs_do_writepage (/storage/home/djwong/cdev/work/linux-xfs/include/linux/highmem.h:77).

I managed to reproduce again with 4.12-rc4 kernel, call trace is

[  704.811107] Call Trace:
[  704.811107]  do_trap+0x16a/0x190
[  704.811107]  do_error_trap+0x89/0x110
[  704.811107]  ? xfs_do_writepage+0x6c7/0x6d0 [xfs]
[  704.811107]  ? check_preempt_curr+0x7d/0x90
[  704.811107]  ? ttwu_do_wakeup+0x1e/0x150
[  704.811107]  do_invalid_op+0x20/0x30
[  704.811107]  invalid_op+0x1e/0x30

and xfs_do_writepage+0x6c7 is

(gdb) l *(xfs_do_writepage+0x6c7)
0x679e7 is in xfs_do_writepage (fs/xfs/xfs_aops.c:850).
845             int                     error = 0;
846             int                     count = 0;
847             int                     uptodate = 1;
848             unsigned int            new_type;
849
850             bh = head = page_buffers(page);
851             offset = page_offset(page);
852             do {
853                     if (offset >= end_offset)
854                             break;

Full console log appended at the end for reference.

Thanks,
Eryu

[  704.560907] run fstests generic/014 at 2017-06-08 13:21:04
[  704.807749] BUG: unable to handle kernel paging request at ffffffffa06884c2
[  704.808362] IP: report_bug+0x64/0x100
[  704.808362] PGD 1c0c067
[  704.808362] P4D 1c0c067
[  704.808362] PUD 1c0d063
[  704.808362] PMD 1f40ce067
[  704.811107] PTE 80000001f405f161
[  704.811107]
[  704.811107] Oops: 0003 [#1] SMP
[  704.811107] Modules linked in: xfs rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache ip6t_rpfilter ipt_REJECT ip6t_REJECT xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter btrfs xor raid6_pq ppdev i2c_piix4 parport_pc i2c_core parport virtio_balloon pcspkr nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 jbd2 mbcache ata_generic pata_acpi virtio_blk virtio_net ata_piix libata virtio_pci serio_raw virtio_ring virtio floppy
[  704.811107] CPU: 1 PID: 1443 Comm: nfsd Not tainted 4.12.0-rc4 #42
[  704.811107] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[  704.811107] task: ffff880210ed8000 task.stack: ffffc900016b4000
[  704.811107] RIP: 0010:report_bug+0x64/0x100
[  704.811107] RSP: 0018:ffffc900016b75b8 EFLAGS: 00010202
[  704.811107] RAX: ffffffffa06884b8 RBX: ffffffffa06119b7 RCX: 0000000000000001
[  704.811107] RDX: 0000000000000907 RSI: ffffffffa06b2c00 RDI: fffffffffffe4f3c
[  704.811107] RBP: ffffc900016b75d8 R08: 0000000000000001 R09: 0000000000000204
[  704.811107] R10: ffffffff81a27c2f R11: 0000000000000000 R12: ffffc900016b7708
[  704.811107] R13: ffffffffa066d3f4 R14: 00000000000003fb R15: 0000000000000004
[  704.811107] FS:  0000000000000000(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
[  704.811107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  704.811107] CR2: ffffffffa06884c2 CR3: 0000000001c09000 CR4: 00000000000006e0
[  704.811107] Call Trace:
[  704.811107]  do_trap+0x16a/0x190
[  704.811107]  do_error_trap+0x89/0x110
[  704.811107]  ? xfs_do_writepage+0x6c7/0x6d0 [xfs]
[  704.811107]  ? check_preempt_curr+0x7d/0x90
[  704.811107]  ? ttwu_do_wakeup+0x1e/0x150
[  704.811107]  do_invalid_op+0x20/0x30
[  704.811107]  invalid_op+0x1e/0x30
[  704.811107] RIP: 0010:xfs_do_writepage+0x6c7/0x6d0 [xfs]
[  704.811107] RSP: 0018:ffffc900016b77b8 EFLAGS: 00010206
[  704.811107] RAX: 0000000000340140 RBX: ffffc900016b78d8 RCX: ffff88020f82d400
[  704.811107] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffea0007a991c0
[  704.811107] RBP: ffffc900016b7858 R08: 0000000000000002 R09: 000000000001fec8
[  704.811107] R10: ffff88021ffd8d00 R11: 0000000000000000 R12: ffffc900016b7980
[  704.811107] R13: ffffea0007a991c0 R14: 0000000000004326 R15: ffff880213a00168
[  704.811107]  ? page_mkclean+0x69/0xb0
[  704.811107]  ? invalid_page_referenced_vma+0x90/0x90
[  704.811107]  write_cache_pages+0x26f/0x510
[  704.811107]  ? xfs_aops_discard_page+0x140/0x140 [xfs]
[  704.811107]  ? generic_write_end+0x7e/0xc0
[  704.811107]  xfs_vm_writepages+0xb6/0xd0 [xfs]
[  704.811107]  do_writepages+0x1c/0x70
[  704.811107]  __filemap_fdatawrite_range+0xc6/0x100
[  704.811107]  filemap_write_and_wait_range+0x41/0x90
[  704.811107]  xfs_file_fsync+0x63/0x1d0 [xfs]
[  704.811107]  vfs_fsync_range+0x3d/0xb0
[  704.811107]  xfs_file_write_iter+0x121/0x140 [xfs]
[  704.811107]  __do_readv_writev+0x2d3/0x360
[  704.811107]  do_readv_writev+0x76/0xb0
[  704.811107]  ? __wake_up+0x44/0x50
[  704.811107]  ? nfs4_put_stid+0x78/0x90 [nfsd]
[  704.811107]  vfs_writev+0x3c/0x50
[  704.811107]  nfsd_vfs_write+0xd0/0x360 [nfsd]
[  704.811107]  nfsd4_write+0x1a3/0x1d0 [nfsd]
[  704.811107]  nfsd4_proc_compound+0x3b6/0x710 [nfsd]
[  704.811107]  nfsd_dispatch+0xce/0x270 [nfsd]
[  704.811107]  svc_process_common+0x387/0x740 [sunrpc]
[  704.811107]  svc_process+0x105/0x1c0 [sunrpc]
[  704.811107]  nfsd+0xe9/0x160 [nfsd]
[  704.811107]  kthread+0x109/0x140
[  704.811107]  ? nfsd_destroy+0x60/0x60 [nfsd]
[  704.811107]  ? kthread_park+0x60/0x60
[  704.811107]  ret_from_fork+0x25/0x30
[  704.811107] Code: 63 78 04 44 0f b7 70 08 41 89 d0 4c 8d 2c 38 41 83 e0 01 f6 c2 02 74 17 66 45 85 c0 74 11 f6 c2 04 b9 01 00 00 00 75 bb 83 ca 04 <66> 89 50 0a 66 45 85 c0 74 52 0f b6 48 0b 41 0f b7 f6 4d 89 e0
[  704.811107] RIP: report_bug+0x64/0x100 RSP: ffffc900016b75b8
[  704.811107] CR2: ffffffffa06884c2
[  704.811107] ---[ end trace a44b2c0cad7f2afe ]---
[  704.811107] Kernel panic - not syncing: Fatal exception
[  704.811107] Kernel Offset: disabled
[  704.811107] ---[ end Kernel panic - not syncing: Fatal exception
