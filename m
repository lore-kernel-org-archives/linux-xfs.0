Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q72HicDl212701 for <xfs@oss.sgi.com>; Thu, 2 Aug 2012 12:44:38 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id 2kk8HFk05HMU3b91 for <xfs@oss.sgi.com>;
	Thu, 02 Aug 2012 10:44:37 -0700 (PDT)
Message-ID: <501ABC84.6030708@sandeen.net>
Date: Thu, 02 Aug 2012 12:44:36 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: XFS regression: Oops in xfs_buf_do_callbacks on xfstest 137
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>

Putting this on the list for posterity, I'll try to work it out but don't want to lose the issue.

When running w/ slab debugging, particularly memory poisoning, I oops on test 137:


[ 6734.901318] general protection fault: 0000 [#1] SMP 
[ 6734.906337] CPU 1 
[ 6734.908183] Modules linked in:[ 6734.911258]  ext4 jbd2 ext2 xfs sunrpc ip6table_filter ip6_tables binfmt_misc vhost_net macvtap macvlan tun iTCO_wdt iTCO_vendor_support dcdbas microcode i2c_i801 lpc_ich mfd_core tg3 shpchp i3000_edac edac_core ext3 jbd mbcache ata_generic pata_acpi pata_sil680 radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]

[ 6734.942722] Pid: 19860, comm: umount Not tainted 3.5.0-rc6+ #1 Dell Computer Corporation PowerEdge 860/0RH817
[ 6734.952696] RIP: 0010:[<ffffffffa0348780>]  [<ffffffffa0348780>] xfs_buf_do_callbacks+0x20/0x50 [xfs]
[ 6734.962011] RSP: 0018:ffff880058e178f8  EFLAGS: 00010202
[ 6734.967334] RAX: 6b6b6b6b6b6b6b6b RBX: ffff880058088e00 RCX: 00000001001d001b
[ 6734.974472] RDX: 00000001001d001c RSI: ffffea0001603a10 RDI: 0000000000000246
[ 6734.981613] RBP: ffff880058e17908 R08: ffffea0001603a18 R09: 0000000000000000
[ 6734.988752] R10: 0000000000000000 R11: 00000000000000e8 R12: ffff880058088e00
[ 6734.995893] R13: ffffffffa02e8086 R14: 0000000000000000 R15: 0000000000000000
[ 6735.003034] FS:  00007f7a0b77d740(0000) GS:ffff88007d000000(0000) knlGS:0000000000000000
[ 6735.011125] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 6735.016879] CR2: 00007f7a0ade3400 CR3: 000000007991a000 CR4: 00000000000007e0
[ 6735.024017] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 6735.031158] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 6735.038299] Process umount (pid: 19860, threadinfo ffff880058e16000, task ffff8800588ecce0)
[ 6735.046647] Stack:
[ 6735.048676]  ffffffffa03496e4 ffff880058088e00 ffff880058e17938 ffffffffa0348bce
[ 6735.056188]  ffff880058088e30 ffff880058088e00 ffff880058088e00 ffffffffa03496e4
[ 6735.063682]  ffff880058e17958 ffffffffa02e8086 ffff880058e17988 ffff880058088e00
[ 6735.071185] Call Trace:
[ 6735.080337]  [<ffffffffa0348bce>] xfs_buf_iodone_callbacks+0x3e/0x310 [xfs]
[ 6735.093982]  [<ffffffffa02e8086>] xfs_buf_iodone_work+0x26/0x50 [xfs]
[ 6735.100454]  [<ffffffffa02e811b>] xfs_buf_ioend+0x6b/0x1b0 [xfs]
[ 6735.106505]  [<ffffffffa03496e4>] xfs_buf_item_unpin+0x94/0x2e0 [xfs]
[ 6735.118564]  [<ffffffffa034265d>] xfs_trans_committed_bulk+0x1bd/0x2a0 [xfs]
[ 6735.136898]  [<ffffffffa0347add>] xlog_cil_committed+0x3d/0x100 [xfs]
[ 6735.143380]  [<ffffffffa0347edb>] xlog_cil_push+0x33b/0x410 [xfs]
[ 6735.149515]  [<ffffffffa0348617>] xlog_cil_force_lsn+0x167/0x170 [xfs]
[ 6735.156084]  [<ffffffffa034531d>] _xfs_log_force+0x6d/0x250 [xfs]
[ 6735.162216]  [<ffffffffa034569a>] xfs_log_force+0x2a/0x100 [xfs]
[ 6735.168257]  [<ffffffffa02fb323>] xfs_quiesce_data+0x23/0x70 [xfs]
[ 6735.174470]  [<ffffffffa02f8b80>] xfs_fs_sync_fs+0x30/0x60 [xfs]
[ 6735.180486]  [<ffffffff811f5150>] __sync_filesystem+0x30/0x60
[ 6735.186238]  [<ffffffff811f51cb>] sync_filesystem+0x4b/0x70
[ 6735.191821]  [<ffffffff811c4a6b>] generic_shutdown_super+0x3b/0xf0
[ 6735.198011]  [<ffffffff811c4b51>] kill_block_super+0x31/0x80
[ 6735.203680]  [<ffffffff811c50fd>] deactivate_locked_super+0x3d/0xa0
[ 6735.209964]  [<ffffffff811c60ea>] deactivate_super+0x4a/0x70
[ 6735.215631]  [<ffffffff811e3cd2>] mntput_no_expire+0xd2/0x130
[ 6735.221384]  [<ffffffff811e495e>] sys_umount+0x7e/0x3c0
[ 6735.226619]  [<ffffffff816509a9>] system_call_fastpath+0x16/0x1b
[ 6735.232628] Code: 00 90 8b 34 a0 c9 c3 0f 1f 40 00 55 48 89 e5 53 48 83 ec 08 66 66 66 66 90 48 8b 87 d8 01 00 00 48 89 fb 48 85 c0 74 2b 0f 1f 00 <48> 8b 50 38 48 89 c6 48 89 df 48 89 93 d8 01 00 00 48 c7 40 38 
[ 6735.252741] RIP  [<ffffffffa0348780>] xfs_buf_do_callbacks+0x20/0x50 [xfs]
[ 6735.259681]  RSP <ffff880058e178f8>
[ 6735.278084] ---[ end trace a626b9b4cafd61da ]---

It's dying due to a use after free; RAX / bp->b_fspriv / lip is 0x6b6b6b6.... (POISON_FREE)

STATIC void
xfs_buf_do_callbacks(
        struct xfs_buf          *bp)
{
   712a5:       48 89 fb                mov    %rdi,%rbx
        struct xfs_log_item     *lip;

        while ((lip = bp->b_fspriv) != NULL) {
   712a8:       48 85 c0                test   %rax,%rax
   712ab:       74 2b                   je     712d8 <xfs_buf_do_callbacks+0x48>
   712ad:       0f 1f 00                nopl   (%rax)
                bp->b_fspriv = lip->li_bio_list;
   712b0:       48 8b 50 38             mov    0x38(%rax),%rdx	<--- HERE

The behavior started with:

commit 960c60af8b9481595e68875e79b2602e73169c29
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Apr 23 15:58:38 2012 +1000

    xfs: do not add buffers to the delwri queue until pushed
    
    Instead of adding buffers to the delwri list as soon as they are logged,
    even if they can't be written until commited because they are pinned
    defer adding them to the delwri list until xfsaild pushes them.  This
    makes the code more similar to other log items and prepares for writing
    buffers directly from xfsaild.
    
    The complication here is that we need to fail buffers that were added
    but not logged yet in xfs_buf_item_unpin, borrowing code from
    xfs_bioerror.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

I'm guessing it's a problem w/ the handling in xfs_buf_item_unpin() but not sure yet.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
