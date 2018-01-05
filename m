Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38182 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbeAEEfu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 23:35:50 -0500
Date: Fri, 5 Jan 2018 12:35:49 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2 6/8] fsstress: implement the clonerange/deduperange
 ioctls
Message-ID: <20180105043549.GF5123@eguan.usersys.redhat.com>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
 <151314503583.18893.15475795025536691678.stgit@magnolia>
 <20171215020731.GM6896@magnolia>
 <20180103084801.GX5123@eguan.usersys.redhat.com>
 <20180103171211.GB16402@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180103171211.GB16402@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jan 03, 2018 at 09:12:11AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 03, 2018 at 04:48:01PM +0800, Eryu Guan wrote:
> > On Thu, Dec 14, 2017 at 06:07:31PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Mix it up a bit by reflinking and deduping data blocks when possible.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > This looks fine overall, but I noticed a soft lockup bug in generic/083
> > and generic/269 (both test exercise ENOSPC behavior), test config is
> > reflink+rmapbt XFS with 4k block size. Not sure if the soft lockup is
> > related to the clonerange/deduperange ops in fsstress yet, will confirm
> > without clone/dedupe ops.

More testings showed that this may have something to do with the
deduperange operations. (I was testing with Fedora rawhide with
v4.15-rc5 kernel, I didn't see hang nor soft lockup with my RHEL7 base
host, because there's no FIDEDUPERANGE defined there).

I reverted the whole clonerange/deduperange support and retested for two
rounds of full '-g auto' run without hitting any hang or soft lockup.
Then I commented out the deduperange ops and left clonerange ops there,
no hang/lockup either. At last I commented out the clonerange ops but
left deduperange ops there, I hit a different hang in generic/270 (still
a ENOSPC test). I pasted partial sysrq-w output here, if full output is
needed please let me know.

[79200.901901] 14266.fsstress. D12200 14533  14460 0x00000000
[79200.902419] Call Trace:
[79200.902655]  ? __schedule+0x2e3/0xb90
[79200.902969]  ? _raw_spin_unlock_irqrestore+0x32/0x60
[79200.903442]  schedule+0x2f/0x90   
[79200.903727]  schedule_timeout+0x1dd/0x540
[79200.904114]  ? __next_timer_interrupt+0xc0/0xc0
[79200.904535]  xfs_inode_ag_walk.isra.12+0x3cc/0x670 [xfs]
[79200.905009]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
[79200.905563]  ? kvm_clock_read+0x21/0x30
[79200.905891]  ? sched_clock+0x5/0x10
[79200.906243]  ? sched_clock_local+0x12/0x80
[79200.906598]  ? kvm_clock_read+0x21/0x30
[79200.906920]  ? sched_clock+0x5/0x10
[79200.907273]  ? sched_clock_local+0x12/0x80
[79200.907636]  ? __lock_is_held+0x59/0xa0
[79200.907988]  ? xfs_inode_ag_iterator_tag+0x46/0xb0 [xfs]
[79200.908497]  ? rcu_read_lock_sched_held+0x6b/0x80
[79200.908926]  ? xfs_perag_get_tag+0x28b/0x2f0 [xfs]
[79200.909416]  ? __xfs_inode_clear_blocks_tag+0x120/0x120 [xfs]
[79200.909922]  xfs_inode_ag_iterator_tag+0x73/0xb0 [xfs]
[79200.910446]  xfs_file_buffered_aio_write+0x348/0x370 [xfs]
[79200.910948]  xfs_file_write_iter+0x99/0x140 [xfs]
[79200.911400]  __vfs_write+0xfc/0x170
[79200.911726]  vfs_write+0xc1/0x1b0
[79200.912063]  SyS_write+0x55/0xc0
[79200.912347]  entry_SYSCALL_64_fastpath+0x1f/0x96

Seems other hangning fsstress processes were all waiting for io
completion of writeback (sleeping in wb_wait_for_completion).

> > 
> > [12968.100008] watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [fsstress:6903]
> > [12968.100038] Modules linked in: loop dm_flakey xfs ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables sunrpc 8139too 8139cp i2c_piix4 joydev mii pcspkr virtio_balloon virtio_pci serio_raw virtio_ring virtio floppy ata_generic pata_acpi
> > [12968.104043] irq event stamp: 23222196
> > [12968.104043] hardirqs last  enabled at (23222195): [<000000007d0c2e75>] restore_regs_and_return_to_kernel+0x0/0x2e
> > [12968.105111] hardirqs last disabled at (23222196): [<000000008f80dc57>] apic_timer_interrupt+0xa7/0xc0
> > [12968.105111] softirqs last  enabled at (877594): [<0000000034c53d5e>] __do_softirq+0x392/0x502
> > [12968.105111] softirqs last disabled at (877585): [<000000003f4d9e0b>] irq_exit+0x102/0x110
> > [12968.105111] CPU: 2 PID: 6903 Comm: fsstress Tainted: G        W    L   4.15.0-rc5 #10
> > [12968.105111] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> > [12968.108043] RIP: 0010:xfs_bmapi_update_map+0xc/0xc0 [xfs]
> 
> Hmmm, I haven't seen such a hang; I wonder if we're doing something
> we shouldn't be doing and looping in bmapi_write.  In any case it's
> a bug with xfs, not fsstress.

Agreed, I'm planning to pull this patch in this week's update, with the
following fix

- inode_info(inoinfo2, sizeof(inoinfo2), &stat2, v1);
+ inode_info(inoinfo2, sizeof(inoinfo2), &stat2, v2);

Also I'd follow Dave's suggestion on xfs/068 fix, move the
FSSTRESS_AVOID handling to common/dump on commit. Please let me know if
you have a different plan now.

Thanks,
Eryu
