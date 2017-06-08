Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751439AbdFHC1k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Jun 2017 22:27:40 -0400
Date: Thu, 8 Jun 2017 10:27:37 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [v4.12-rc1 regression] nfs server crashed in fstests run
Message-ID: <20170608022737.GA19952@eguan.usersys.redhat.com>
References: <20170602060457.GG23805@eguan.usersys.redhat.com>
 <20170607033357.GW19952@eguan.usersys.redhat.com>
 <20170607155356.GA26995@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170607155356.GA26995@fieldses.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Jun 07, 2017 at 11:53:56AM -0400, J. Bruce Fields wrote:
> On Wed, Jun 07, 2017 at 11:33:57AM +0800, Eryu Guan wrote:
> > On Fri, Jun 02, 2017 at 02:04:57PM +0800, Eryu Guan wrote:
> > > Hi all,
> > > 
> > > Starting from 4.12-rc1 kernel, I saw Linux nfs server crashes all the
> > > time in my fstests (xfstests) runs, I appended the console log of an
> > > NFSv3 crash to the end of this mail.
> > > 
> > > I was exporting a directory resided on XFS, and loopback mounted the NFS
> > > export on localhost. Both NFSv3 and NFSv4 could hit this crash. The
> > 
> > I did more test runs with ext4 exported, seems it's only reproducible
> > when the exported local filesystem is XFS, ext4 survived 20 rounds of
> > fstests runs auto group tests.
> > 
> > And this crash can still be seen with 4.12-rc4 kernel.
> 
> So this sounds a little more likely to be an xfs bug.  I also don't see
> any likely looking nfsd commits in the v4.11..v4.12-rc1 range.
> 
> But I take it you can't reproduce when running directly on xfs with no
> NFS involvement?

Correct, I don't see any xfs crashes in fstests run without nfs.

> 
> Not knowing this code well I don't know what to suggest other than the
> long painful bisect.

Bisect is still running, automatically. I guess it still needs several
days to finish.

Thanks for looking at it!

Eryu

> 
> --b.
> 
> > Thanks,
> > Eryu
> > 
> > > crash usually happens when running test case generic/029 or generic/095.
> > > 
> > > But the problem is, there's no easy and efficient way to reproduce it, I
> > > tried run only generic/029 and generic/095 in a loop for 1000 times but
> > > failed, I also tried run the 'quick' group tests only for 50 iterations
> > > but failed again. It seems that the only reliable way to reproduce it is
> > > run the 'auto' group tests for 20 iterations.
> > > 
> > > 	i=0
> > > 	while [ $i -lt 20 ]; do
> > > 		./check -nfs -g auto
> > > 		((i++))
> > > 	done
> > > 
> > > And usually server crashed within 5 iterations, but at times it could
> > > survive 10 iterations and only crashed if you left it running for more
> > > iterations. This makes it hard to bisect and bisecting is very
> > > time-consuming.
> > > 
> > > (The bisecting is running now, it needs a few days to finish. My first
> > > two attempts pointed first bad commit to some mm patches, but reverting
> > > that patch didn't prevent server from crashing, so I enlarged the loop
> > > count and started bisecting for the third time).
> > > 
> > > If more info is needed please let me know.
> > > 
> > > Thanks,
> > > Eryu
> > > 
> > > 
> > > [88895.796834] run fstests generic/028 at 2017-06-01 00:43:18
> > > [88900.945420] run fstests generic/029 at 2017-06-01 00:43:23
> > > [88901.127315] BUG: unable to handle kernel paging request at ffffffffc0360e12
> > > [88901.135095] IP: report_bug+0x64/0x100
> > > [88901.139177] PGD 3b7c0c067
> > > [88901.139177] P4D 3b7c0c067
> > > [88901.142194] PUD 3b7c0e067
> > > [88901.145209] PMD 469e33067
> > > [88901.148225] PTE 80000004675f4161
> > > [88901.151240]
> > > [88901.156497] Oops: 0003 [#1] SMP
> > > [88901.159997] Modules linked in: loop dm_mod nfsv3 nfs fscache ext4 jbd2 mbcache intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm nfsd irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc ipmi_ssif cdc_ether aesni_intel iTCO_wdt usbnet crypto_simd ipmi_si glue_helper sg iTCO_vendor_support wmi mii cryptd ipmi_devintf ipmi_msghandler auth_rpcgss shpchp i2c_i801 pcspkr ioatdma lpc_ich nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops igb ttm drm ptp pps_core dca megaraid_sas crc32c_intel i2c_algo_bit i2c_core
> > > [88901.221606] CPU: 9 PID: 3278 Comm: nfsd Not tainted 4.12.0-rc3 #42
> > > [88901.228500] Hardware name: IBM System x3650 M4 -[7915ON3]-/00J6520, BIOS -[VVE124AUS-1.30]- 11/21/2012
> > > [88901.238885] task: ffffa10062d12d00 task.stack: ffffc2820478c000
> > > [88901.245488] RIP: 0010:report_bug+0x64/0x100
> > > [88901.250153] RSP: 0018:ffffc2820478f598 EFLAGS: 00010202
> > > [88901.255980] RAX: ffffffffc0360e08 RBX: ffffffffc0301cdc RCX: 0000000000000001
> > > [88901.263940] RDX: 0000000000000907 RSI: ffffffffc038bc80 RDI: ffffffffffff0d22
> > > [88901.271901] RBP: ffffc2820478f5b8 R08: 0000000000000001 R09: 00000000000001cc
> > > [88901.279861] R10: ffffffffb6a36f67 R11: 0000000000000000 R12: ffffc2820478f6e8
> > > [88901.287821] R13: ffffffffc0351b2a R14: 00000000000003fb R15: 0000000000000004
> > > [88901.295783] FS:  0000000000000000(0000) GS:ffffa1007f6c0000(0000) knlGS:0000000000000000
> > > [88901.304818] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [88901.311227] CR2: ffffffffc0360e12 CR3: 00000003b7c09000 CR4: 00000000000406e0
> > > [88901.319188] Call Trace:
> > > [88901.321920]  do_trap+0x16a/0x190
> > > [88901.325519]  do_error_trap+0x89/0x110
> > > [88901.329652]  ? xfs_do_writepage+0x65c/0x680 [xfs]
> > > [88901.334917]  ? _xfs_buf_find+0x2a2/0x510 [xfs]
> > > [88901.339875]  ? kmem_cache_alloc+0x194/0x1a0
> > > [88901.344561]  ? kmem_zone_alloc+0x96/0x100 [xfs]
> > > [88901.349615]  do_invalid_op+0x20/0x30
> > > [88901.353604]  invalid_op+0x1e/0x30
> > > [88901.357318] RIP: 0010:xfs_do_writepage+0x65c/0x680 [xfs]
> > > [88901.363242] RSP: 0018:ffffc2820478f790 EFLAGS: 00010206
> > > [88901.369069] RAX: 0000000000340140 RBX: ffffc2820478f8b8 RCX: 0000000000000000
> > > [88901.377030] RDX: 0000000000000000 RSI: ffffc2820478f9f8 RDI: fffffc2be1095400
> > > [88901.384991] RBP: ffffc2820478f838 R08: 0000000000000002 R09: 000000000001ff20
> > > [88901.392950] R10: ffffa1007ffd1d00 R11: 0000000000000000 R12: ffffa10053c2ea58
> > > [88901.400911] R13: fffffc2be1095400 R14: ffffc2820478f960 R15: ffffc2820478f9f8
> > > [88901.408876]  ? page_mkclean+0x69/0xb0
> > > [88901.412960]  ? invalid_page_referenced_vma+0x90/0x90
> > > [88901.418500]  write_cache_pages+0x26f/0x510
> > > [88901.423085]  ? xfs_vm_set_page_dirty+0x1d0/0x1d0 [xfs]
> > > [88901.428819]  ? block_write_end+0x36/0x80
> > > [88901.433193]  ? generic_write_end+0x54/0xc0
> > > [88901.437791]  xfs_vm_writepages+0xb6/0xd0 [xfs]
> > > [88901.442741]  do_writepages+0x1c/0x70
> > > [88901.446727]  __filemap_fdatawrite_range+0xc6/0x100
> > > [88901.452071]  filemap_write_and_wait_range+0x41/0x90
> > > [88901.457532]  xfs_file_fsync+0x63/0x1d0 [xfs]
> > > [88901.462294]  vfs_fsync_range+0x3d/0xb0
> > > [88901.466491]  xfs_file_write_iter+0x121/0x140 [xfs]
> > > [88901.471835]  __do_readv_writev+0x2d3/0x360
> > > [88901.476402]  do_readv_writev+0x76/0xb0
> > > [88901.480582]  ? do_dentry_open+0x261/0x310
> > > [88901.485069]  ? xfs_extent_busy_ag_cmp+0x20/0x20 [xfs]
> > > [88901.490704]  vfs_writev+0x3c/0x50
> > > [88901.494409]  nfsd_vfs_write+0xd0/0x360 [nfsd]
> > > [88901.499271]  ? ima_file_check+0x20/0x30
> > > [88901.503553]  nfsd_write+0x15a/0x210 [nfsd]
> > > [88901.508116]  nfsd3_proc_write+0x9d/0x130 [nfsd]
> > > [88901.513172]  nfsd_dispatch+0xce/0x270 [nfsd]
> > > [88901.517950]  svc_process_common+0x387/0x740 [sunrpc]
> > > [88901.523492]  svc_process+0xfc/0x1c0 [sunrpc]
> > > [88901.528248]  nfsd+0xe9/0x160 [nfsd]
> > > [88901.532137]  kthread+0x109/0x140
> > > [88901.535740]  ? nfsd_destroy+0x60/0x60 [nfsd]
> > > [88901.540501]  ? kthread_park+0x60/0x60
> > > [88901.544586]  ret_from_fork+0x25/0x30
> > > [88901.548572] Code: 63 78 04 44 0f b7 70 08 41 89 d0 4c 8d 2c 38 41 83 e0 01 f6 c2 02 74 17 66 45 85 c0 74 11 f6 c2 04 b9 01 00 00 00 75 bb 83 ca 04 <66> 89 50 0a 66 45 85 c0 74 52 0f b6 48 0b 41 0f b7 f6 4d 89 e0
> > > [88901.569642] RIP: report_bug+0x64/0x100 RSP: ffffc2820478f598
> > > [88901.575955] CR2: ffffffffc0360e12
> > > [88901.579663] ---[ end trace 62c63b9fb594e7f4 ]---
> > > [88901.584811] Kernel panic - not syncing: Fatal exception
> > > [88901.590694] Kernel Offset: 0x35000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> > > [88901.602731] Rebooting in 3 seconds..
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
