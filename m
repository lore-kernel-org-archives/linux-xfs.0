Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932812AbeALDcd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 22:32:33 -0500
Date: Fri, 12 Jan 2018 11:32:31 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] xfs: recheck reflink / dirty page status before freeing
 CoW reservations
Message-ID: <20180112033231.GM5123@eguan.usersys.redhat.com>
References: <20180110220336.GU5602@magnolia>
 <20180111075441.GH5123@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180111075441.GH5123@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Jan 11, 2018 at 03:54:41PM +0800, Eryu Guan wrote:
> On Wed, Jan 10, 2018 at 02:03:36PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Eryu Guan reported seeing occasional hangs when running generic/269 with
> > a new fsstress that supports clonerange/deduperange.  The cause of this
> > hang is an infinite loop when we convert the CoW fork extents from
> > unwritten to real just prior to writing the pages out; the infinite
> > loop happens because there's nothing in the CoW fork to convert, and so
> > it spins forever.
> > 
> > The underlying issue here is that when we go to perform these CoW fork
> > conversions, we're supposed to have an extent waiting for us, but the
> > low space CoW reaper has snuck in and blown them away!  There are four
> > conditions that can dissuade the reaper from touching our file -- no
> > reflink iflag; dirty page cache; writeback in progress; or directio in
> > progress.  We check the four conditions prior to taking the locks, but
> > we neglect to recheck them once we have the locks, which is how we end
> > up whacking the writeback that's in progress.
> > 
> > Therefore, refactor the four checks into a helper function and call it
> > once again once we have the locks to make sure we really want to reap
> > the inode.  While we're at it, add an ASSERT for this weird condition so
> > that we'll fail noisily if we ever screw this up again.
> > 
> > Reported-by: Eryu Guan <eguan@redhat.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I applied this patch on top of v4.15-rc5 kernel, and ran generic/083
> generic/269 and generic/270 (where I hit the soft lockup and hang before)
> multiple times and tests all passed. I also ran all tests in 'enospc'
> group on 1k/2k/4k XFS with reflink enabled, tests passed too. So
> 
> Tested-by: Eryu Guan <eguan@redhat.com>

Sorry, I have to withdraw this tag for now.. I'm seeing soft lockup
again in generic/269 run with the patched kernel. I'll do more testings
to confirm, paste the soft lockup info here for now:

[596580.126008] watchdog: BUG: soft lockup - CPU#3 stuck for 22s! [fsstress:30037]
[596580.126008] Modules linked in: xfs dm_delay btrfs xor zstd_compress raid6_pq zstd_decompress xxhash dm_thin_pool dm_persistent_data dm_bio_prison dm_flakey loop ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables sunrpc joydev i2c_piix4 8139too virtio_balloon pcspkr 8139cp mii virtio_pci virtio_ring virtio serio_raw floppy ata_generic pata_acpi [last unloaded: scsi_debug]
[596580.129050] irq event stamp: 174005460
[596580.129050] hardirqs last  enabled at (174005459): [<000000004aebc6cd>] restore_regs_and_return_to_kernel+0x0/0x2e
[596580.129050] hardirqs last disabled at (174005460): [<0000000084598378>] apic_timer_interrupt+0xa7/0xc0
[596580.132071] softirqs last  enabled at (79644030): [<000000009174d1b7>] __do_softirq+0x392/0x502
[596580.133052] softirqs last disabled at (79644019): [<000000002b9518d7>] irq_exit+0x102/0x110
[596580.133052] CPU: 3 PID: 30037 Comm: fsstress Tainted: G        W  OEL   4.15.0-rc5 #10
[596580.133052] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[596580.133052] RIP: 0010:xfs_bmapi_convert_unwritten+0xb/0x1b0 [xfs]
[596580.133052] RSP: 0000:ffffbb8643d538d0 EFLAGS: 00000287 ORIG_RAX: ffffffffffffff11
[596580.133052] RAX: 000ffffffffe0000 RBX: 0000000000000a40 RCX: 0000000000000a40
[596580.136071] RDX: 0000000000000080 RSI: ffffbb8643d53aa8 RDI: ffffbb8643d53980
[596580.136071] RBP: ffffbb8643d53a68 R08: 0000000000000080 R09: 0000000000000000
[596580.137053] R10: 0000000000000000 R11: fed20f5f8482504e R12: ffffbb8643d53980
[596580.137053] R13: ffffbb8643d539c0 R14: 0000000000000080 R15: 0000000000000001
[596580.137053] FS:  00007fca843b1b80(0000) GS:ffff9c29d7400000(0000) knlGS:0000000000000000
[596580.137053] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[596580.137053] CR2: 00007fca843a8000 CR3: 00000001070f5000 CR4: 00000000000006e0
[596580.137053] Call Trace:
[596580.137053]  xfs_bmapi_write+0x301/0xcc0 [xfs]
[596580.140071]  ? sched_clock+0x5/0x10
[596580.140071]  xfs_reflink_convert_cow+0x8c/0xc0 [xfs]
[596580.140071]  ? __test_set_page_writeback+0x18b/0x3c0
[596580.141051]  xfs_submit_ioend+0x18f/0x1f0 [xfs]
[596580.141051]  xfs_do_writepage+0x39d/0x7e0 [xfs]
[596580.141051]  write_cache_pages+0x1d0/0x550
[596580.141051]  ? xfs_vm_readpage+0x130/0x130 [xfs]
[596580.141051]  xfs_vm_writepages+0xb1/0xd0 [xfs]
[596580.141051]  do_writepages+0x48/0xf0
[596580.141051]  ? __filemap_fdatawrite_range+0xb4/0x100
[596580.141051]  ? __filemap_fdatawrite_range+0xc1/0x100
[596580.141051]  __filemap_fdatawrite_range+0xc1/0x100
[596580.144072]  xfs_release+0x11c/0x160 [xfs]
[596580.144072]  __fput+0xe6/0x1f0
[596580.144072]  task_work_run+0x82/0xb0
[596580.145050]  exit_to_usermode_loop+0xa8/0xb0
[596580.145050]  syscall_return_slowpath+0x153/0x160
[596580.145050]  entry_SYSCALL_64_fastpath+0x94/0x96
[596580.145050] RIP: 0033:0x7fca83b87cb1
[596580.145050] RSP: 002b:00007ffdd89b8368 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
[596580.145050] RAX: 0000000000000000 RBX: 000000000000031a RCX: 00007fca83b87cb1
[596580.145050] RDX: 0000000001a675f0 RSI: 0000000001a55010 RDI: 0000000000000003
[596580.145050] RBP: 000000000001146a R08: 0000000000000006 R09: 00007fca83b71d00
[596580.148070] R10: 0000000001a55010 R11: 0000000000000246 R12: 0000000000000003
[596580.148070] R13: 0000000000174143 R14: 0000000001aad800 R15: 0000000000000000
[596580.149050] Code: e9 58 f4 ff ff e8 c6 a8 a9 c9 4c 8b 4d 08 41 b8 99 09 00 00 e9 44 f4 ff ff 0f 1f 80 00 00 00 00 0f 1f 44 00 00 41 57 41 56 41 55 <41> 54 49 89 d5 55 53 89 cd 48 89 fb 49 89 f4 48 83 ec 10 48 8b

Thanks,
Eryu
