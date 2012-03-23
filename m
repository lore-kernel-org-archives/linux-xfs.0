Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2NHhI3n233563 for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 12:43:18 -0500
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F29F1304064
	for <xfs@oss.sgi.com>; Fri, 23 Mar 2012 10:43:14 -0700 (PDT)
Date: Fri, 23 Mar 2012 12:43:27 -0500
From: Ben Myers <bpm@sgi.com>
Subject: BUG in xlog_get_lowest_lsn
Message-ID: <20120323174327.GU7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I just had an interesing crash:

# git describe
v3.3-rc1-51-gc999a22
# quilt applied
patches/v3-xfs-Fix-oops-on-IO-error-during-xlog_recover_process_iunlinks.patch
patches/1-4-xfs-remove-log-item-from-AIL-in-xfs_qm_dqflush-after-a-shutdown.patch
patches/2-4-xfs-remove-log-item-from-AIL-in-xfs_iflush-after-a-shutdown.patch
patches/3-4-xfs-allow-assigning-the-tail-lsn-with-the-AIL-lock-held.patch
patches/4-4-xfs-implement-freezing-by-emptying-the-AIL.patch
patches/3-8-xfs-initialise-xfssync-work-before-running-quotachecks-2.patch
patches/4-8-xfs-remove-MS_ACTIVE-guard-from-inode-reclaim-work.patch
patches/5-8-xfs-don-t-cache-inodes-read-through-bulkstat.patch
patches/6-8-xfs-Account-log-unmount-transaction-correctly.patch
patches/7-8-xfs-fix-fstrim-offset-calculations.patch
patches/8-8-xfs-add-lots-of-attribute-trace-points.patch

[21607.920067] BUG: unable to handle kernel paging request at ffffc9001c970010
[21607.924031] IP: [<ffffffffa04b06d0>] xlog_get_lowest_lsn+0x30/0x80 [xfs]
[21607.924031] PGD 22f05f067 PUD 22f060067 PMD 1d0cd3067 PTE 0
[21607.924031] Oops: 0000 [#1] SMP
[21607.924031] CPU 1
[21607.924031] Modules linked in: xfs(O) exportfs af_packet microcode fuse loop dm_mod e1000 tpm_tis shpchp iTCO_wdt tpm sg i2c_i801 iTCO_vendor_support i2c_core pci_hotplug sr_mod e752x
_edac pcspkr edac_core floppy intel_rng tpm_bios cdrom container serio_raw button uhci_hcd ehci_hcd sd_mod crc_t10dif usbcore usb_common edd ext3 mbcache jbd fan processor ide_pci_generi
c piix ide_core ata_generic ata_piix libata aic79xx scsi_transport_spi scsi_mod thermal thermal_sys hwmon [last unloaded: xfs]
[21607.924031]
[21607.924031] Pid: 4062, comm: kworker/1:0 Tainted: G           O 3.3.0-rc1-0.7-default+ #13 Supermicro X6DHR-8G/X6DHR-8GS/X6DHR-8G/X6DHR-8GS
[21607.924031] RIP: 0010:[<ffffffffa04b06d0>]  [<ffffffffa04b06d0>] xlog_get_lowest_lsn+0x30/0x80 [xfs]
[21607.924031] RSP: 0018:ffff8801f8917d10  EFLAGS: 00010246
[21607.924031] RAX: ffffc9001c970000 RBX: ffff8802204d84c0 RCX: ffff8802204d84c0
[21607.924031] RDX: ffff8802243a5cc0 RSI: 0000000000000000 RDI: 0000000000000000
[21607.924031] RBP: ffff8801f8917d10 R08: ffff8802204d8dc0 R09: 0000000000000000
[21607.924031] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8802243a5c00
[21607.924031] R13: ffff8802204d84c0 R14: 0000000000000000 R15: ffff88022fc963d5
[21607.924031] FS:  0000000000000000(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
[21607.924031] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b 
[21607.924031] CR2: ffffc9001c970010 CR3: 000000014e09e000 CR4: 00000000000006e0
[21607.924031] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[21607.924031] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[21607.924031] Process kworker/1:0 (pid: 4062, threadinfo ffff8801f8916000, task ffff880220fb60c0)
[21607.924031] Stack:
[21607.924031]  ffff8801f8917d90 ffffffffa04b0f46 0000000300000000 ffff8802204d84c0
[21607.924031]  ffff8802243a5c00 ffff8802204d8dc0 0000000000000286 0000000000000000
[21607.924031]  0000000100000000 ffff8802243a5ca8 ffff8802243a5cc0 ffff8802204d84c0
[21607.924031] Call Trace:
[21607.924031]  [<ffffffffa04b0f46>] xlog_state_do_callback+0xa6/0x3a0 [xfs]
[21607.924031]  [<ffffffffa04b1328>] xlog_state_done_syncing+0xe8/0x110 [xfs]
[21607.924031]  [<ffffffffa04b1b1e>] xlog_iodone+0x7e/0x100 [xfs]
[21607.924031]  [<ffffffffa0450d31>] xfs_buf_iodone_work+0x21/0x50 [xfs]
[21607.924031]  [<ffffffff8104b78b>] process_one_work+0x12b/0x3f0
[21607.924031]  [<ffffffffa0450d10>] ? xfs_buf_rele+0x180/0x180 [xfs]
[21607.924031]  [<ffffffff8104e333>] worker_thread+0x183/0x430
[21607.924031]  [<ffffffff8104e1b0>] ? manage_workers+0x210/0x210
[21607.924031]  [<ffffffff81052bee>] kthread+0x9e/0xb0
[21607.924031]  [<ffffffff813ab124>] kernel_thread_helper+0x4/0x10
[21607.924031]  [<ffffffff81052b50>] ? kthread_freezable_should_stop+0x70/0x70
[21607.924031]  [<ffffffff813ab120>] ? gs_change+0x13/0x13
[21607.924031] Code: 00 00 00 31 ff 48 89 e5 4c 89 c1 eb 0f 66 0f 1f 44 00 00 48 8b 49 30 49 39 c8 74 40 0f b7 41 5c a8 41 75 ef 48 8b 81 c8 00 00 00 <48> 8b 70 10 48 0f ce 48 85 f6 74 0
5 48 85 ff 74 14 48 89 f2 48
[21607.924031] RIP  [<ffffffffa04b06d0>] xlog_get_lowest_lsn+0x30/0x80 [xfs]
[21607.924031]  RSP <ffff8801f8917d10>
[21607.924031] CR2: ffffc9001c970010

0xffffffffa04b06a0 <xlog_get_lowest_lsn>:       push   %rbp
0xffffffffa04b06a1 <xlog_get_lowest_lsn+0x1>:   mov    0xa0(%rdi),%r8           * rdi is xlog_t, offset 0xa0 is l_iclog, lsn_log in r8
0xffffffffa04b06a8 <xlog_get_lowest_lsn+0x8>:   xor    %edi,%edi
0xffffffffa04b06aa <xlog_get_lowest_lsn+0xa>:   mov    %rsp,%rbp
0xffffffffa04b06ad <xlog_get_lowest_lsn+0xd>:   mov    %r8,%rcx                 * (xlog_in_core_t)lsn_log in rcx
0xffffffffa04b06b0 <xlog_get_lowest_lsn+0x10>:  jmp    0xffffffffa04b06c1 <xlog_get_lowest_lsn+0x21>
0xffffffffa04b06b2 <xlog_get_lowest_lsn+0x12>:  nopw   0x0(%rax,%rax,1)
0xffffffffa04b06b8 <xlog_get_lowest_lsn+0x18>:  mov    0x30(%rcx),%rcx          * [0x30] struct xlog_in_core *ic_next;  now in rcx
0xffffffffa04b06bc <xlog_get_lowest_lsn+0x1c>:  cmp    %rcx,%r8
0xffffffffa04b06bf <xlog_get_lowest_lsn+0x1f>:  je     0xffffffffa04b0701 <xlog_get_lowest_lsn+0x61>
0xffffffffa04b06c1 <xlog_get_lowest_lsn+0x21>:  movzwl 0x5c(%rcx),%eax          * [0x5c] short unsigned int ic_state;

#define XLOG_STATE_ACTIVE    0x0001 /* Current IC log being written to */
#define XLOG_STATE_DONE_SYNC 0x0008 /* Done syncing to disk */
#define XLOG_STATE_DIRTY     0x0040 /* Dirty IC log, not ready for ACTIVE status*/

0xffffffffa04b06c5 <xlog_get_lowest_lsn+0x25>:  test   $0x41,%al                * XLOG_STATE_ACTIVE|XLOG_STATE_SYNCING
0xffffffffa04b06c7 <xlog_get_lowest_lsn+0x27>:  jne    0xffffffffa04b06b8 <xlog_get_lowest_lsn+0x18>    * loop
0xffffffffa04b06c9 <xlog_get_lowest_lsn+0x29>:  mov    0xc8(%rcx),%rax          * [0xc8] xlog_in_core_2_t *ic_data;
0xffffffffa04b06d0 <xlog_get_lowest_lsn+0x30>:  mov    0x10(%rax),%rsi          * [0x10] __be64 h_lsn;

crash> xlog_in_core_t ffff8802204d84c0 | grep ic_state
  ic_state = 0x8, 		* XLOG_STATE_DONE_SYNC

It seems like we have an iclog with a bad ic_data pointer:

crash> xlog_rec_header_t ffffc9001c970000
struct xlog_rec_header_t struct: invalid kernel virtual address: ffffc9001c970000  type: "gdb_readmem_callback"
Cannot access memory at address 0xffffc9001c970000

A use after free?

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
