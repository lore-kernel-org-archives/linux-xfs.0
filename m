Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55394 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754060AbeAOMDA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jan 2018 07:03:00 -0500
Date: Mon, 15 Jan 2018 07:02:58 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: _xfs_buf_find: Block out of range, then umount hung
Message-ID: <20180115120258.GA44369@bfoster.bfoster>
References: <20180113145228.GA16780@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180113145228.GA16780@onthe.net.au>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Dunlop <chris@onthe.net.au>
Cc: linux-xfs@vger.kernel.org

On Sun, Jan 14, 2018 at 01:52:28AM +1100, Chris Dunlop wrote:
> Hi,
> 
> tl;dr: a filesystem corruption (cause unknown) has produced an unkillable
> umount. Is the only recourse to reboot?
> 

>From this particular state, probably.

> On linux-4.9.76, I had this error crop up:
> 
> Jan 13 19:57:31 b2 kernel: XFS (sdp1): _xfs_buf_find: Block out of range: block 0x837940948, EOFS 0x6f281288
> Jan 13 19:57:31 b2 kernel: ------------[ cut here ]------------
> Jan 13 19:57:31 b2 kernel: WARNING: CPU: 5 PID: 31412 at /home2/chris/git/linux/fs/xfs/xfs_buf.c:535 _xfs_buf_find+0x2ff/0x370 [xfs]
> Jan 13 19:57:31 b2 kernel: Modules linked in: nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace sunrpc ipt_REJECT nf_reject_ipv4 xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_recent xt_multiport iptable_filter ip_tables x_tables iTCO_wdt iTCO_vendor_support intel_powerclamp coretemp kvm_intel kvm irqbypass lpc_ich mfd_core xfs ipmi_ssif i7core_edac edac_core ioatdma shpchp evdev 8250 8250_base serial_core ipmi_si ipmi_msghandler button acpi_cpufreq processor loop fuse autofs4 ext4 crc16 jbd2 mbcache dm_mod bridge stp llc raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 md_mod ses enclosure sg sd_mod hid_generic usbhid hid bnx2x mpt3sas mdio libcrc32c raid_class crc32c_generic ehci_pci psmouse crc32c_intel igb scsi_transport_sas i2c_algo_bit uhci_hcd
> Jan 13 19:57:31 b2 kernel:  ehci_hcd i2c_core scsi_mod dca ptp pps_core
> Jan 13 19:57:31 b2 kernel: CPU: 5 PID: 31412 Comm: tp_fstore_op Not tainted 4.9.76-otn-00021-g2af03421 #1
> Jan 13 19:57:31 b2 kernel: Hardware name: Supermicro X8DTH-i/6/iF/6F/X8DTH, BIOS 2.1a       12/12/11
> Jan 13 19:57:31 b2 kernel:  ffffc900418e3718 ffffffff812a91bb 0000000000000000 0000000000000000
> Jan 13 19:57:31 b2 kernel:  ffffc900418e3758 ffffffff8105ab31 00000217418e3778 ffff8817c62cdc00
> Jan 13 19:57:31 b2 kernel:  0000000000000008 ffff8817c62cdc00 ffffc900418e3848 0000000000000000
> Jan 13 19:57:31 b2 kernel: Call Trace:
> Jan 13 19:57:31 b2 kernel:  [<ffffffff812a91bb>] dump_stack+0x4d/0x72
> Jan 13 19:57:31 b2 kernel:  [<ffffffff8105ab31>] __warn+0xd1/0xf0
> Jan 13 19:57:31 b2 kernel:  [<ffffffff8105ac1d>] warn_slowpath_null+0x1d/0x20
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa0746e6f>] _xfs_buf_find+0x2ff/0x370 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f6824>] ? xfs_alloc_update_counters.isra.13+0x44/0x50 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa0746f0a>] xfs_buf_get_map+0x2a/0x2f0 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f6c12>] ? xfs_free_ag_extent+0x3e2/0x7b0 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa077c7a6>] xfs_trans_get_buf_map+0x126/0x1d0 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa07121ff>] xfs_btree_get_bufs+0x4f/0x60 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f8fa7>] xfs_alloc_fix_freelist+0x1c7/0x390 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffff8108b46f>] ? sched_clock_cpu+0x8f/0xa0
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f98e5>] xfs_free_extent_fix_freelist+0x65/0xa0 [xfs]

So for one reason or another, you end up trying to remove a bogus block
number from the AGFL (perhaps the old agfl size issue?).

> Jan 13 19:57:31 b2 kernel:  [<ffffffffa06f996b>] xfs_free_extent+0x4b/0x120 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811b63e3>] ? kmem_cache_alloc+0x1a3/0x1b0
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa077d5ae>] xfs_trans_free_extent+0x6e/0x130 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa077d696>] xfs_extent_free_finish_item+0x26/0x40 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa071dbdc>] xfs_defer_finish+0x16c/0x430 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa06fb0c4>] xfs_attr_leaf_addname+0x3e4/0x400 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa06fb975>] xfs_attr_set+0x245/0x3f0 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffffa07696a2>] xfs_xattr_set+0x52/0xa0 [xfs]
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811fdb8b>] __vfs_setxattr+0x6b/0x90
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811fe5d1>] __vfs_setxattr_noperm+0x51/0xe0
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811fe707>] vfs_setxattr+0xa7/0xb0
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811fe83d>] setxattr+0x12d/0x150
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811f9408>] ? mnt_want_write_file+0x28/0x60
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811d914e>] ? __sb_start_write+0xee/0x1a0
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811f9408>] ? mnt_want_write_file+0x28/0x60
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811f58d5>] ? __fget+0x5/0xe0
> Jan 13 19:57:31 b2 kernel:  [<ffffffff811feaed>] SyS_fsetxattr+0x7d/0xa0
> Jan 13 19:57:31 b2 kernel:  [<ffffffff814ed0e0>] entry_SYSCALL_64_fastpath+0x13/0x99
> Jan 13 19:57:31 b2 kernel: ---[ end trace 144423dbd5ec0057 ]---
> 
> That whole lot repeated again (same call trace), then:
> 
> Jan 13 19:57:31 b2 kernel: XFS (sdp1): xfs_do_force_shutdown(0x8) called from line 236 of file /home2/chris/git/linux/fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa071d787
> Jan 13 19:57:31 b2 kernel: XFS (sdp1): Corruption of in-memory data detected.  Shutting down filesystem
> Jan 13 19:57:31 b2 kernel: XFS (sdp1): Please umount the filesystem and rectify the problem(s)

The filesystem shuts down, as expected.

> Jan 13 19:57:31 b2 kernel:
> Jan 13 19:57:31 b2 kernel: ================================================
> Jan 13 19:57:31 b2 kernel: [ BUG: lock held when returning to user space! ]
> Jan 13 19:57:31 b2 kernel: 4.9.76-otn-00021-g2af03421 #1 Tainted: G        W
> Jan 13 19:57:31 b2 kernel: ------------------------------------------------
> Jan 13 19:57:31 b2 kernel: tp_fstore_op/31412 is leaving the kernel with locks still held!
> Jan 13 19:57:31 b2 kernel: 1 lock held by tp_fstore_op/31412:
> Jan 13 19:57:31 b2 kernel:  #0:  (sb_internal){......}, at: [<ffffffffa07692a3>] xfs_trans_alloc+0xe3/0x130 [xfs]

Though it looks like we return to userspace in transaction context..?
This is the same pid as above and the current code looks like the
transaction should be cancelled in xfs_attr_set(). We're somewhere down
in xfs_attr_leaf_addname(), however. From there, both calls to
xfs_defer_finish() jump to out_defer_cancel on failure, which sets
args->trans = NULL before we return. Hmm, that looks like a bug to me.

Are you able to reproduce this particular hung unmount behavior? If so,
does anything change with something like the appended hunk? Note that
you may have to backport that to v4.9-<whatever> since it appears that
is before out_defer_cancel was created.

Brian

---8<---

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a76914db72ef..e86c51d39e66 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -717,7 +717,6 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
 	return error;
 out_defer_cancel:
 	xfs_defer_cancel(args->dfops);
-	args->trans = NULL;
 	return error;
 }
 
