Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B07997F3F
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 12:22:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3723AAC002
	for <xfs@oss.sgi.com>; Mon, 31 Mar 2014 10:22:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EiKNqSVS9S5RM1L0 for
	<xfs@oss.sgi.com>; Mon, 31 Mar 2014 10:22:47 -0700 (PDT)
Date: Mon, 31 Mar 2014 13:22:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC, PATCH 0/6] xfs: delalloc, DIO and corruption....
Message-ID: <20140331172243.GB63718@bfoster.bfoster>
References: <1395396710-3824-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1395396710-3824-1-git-send-email-david@fromorbit.com>
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
Cc: Al@disappointment.disaster, Viro@disappointment.disaster, viro@ZenIV.linux.org.uk, xfs@oss.sgi.com

On Fri, Mar 21, 2014 at 09:11:44PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> This patch series mostly shuts a can of worms that Al opened when he
> found the cause of the generic/263 fsx failures. The fix for that is
> patch 6 of this series, but, well, there are a bunch of other
> problems that need to be fixed before making that change.
> 
> Basically, the direct Io block mapping behaviour was covering up a
> bunch of other bugs in the delayed allocation extent/page cache
> state coherency mappings. Essentially, we punch out the page cache
> in quite a few places without first cleaning up delayed allocation
> extents over that range and that exposes all sorts of nasty issues
> once the direct IO mapping changes are made.  All of these are
> existing problems, most of them are very unlikely to be seen in the
> wild.
> 
> This patch set passes xfstests on a 4k block size/4k page size
> config with out problems. However, there is still a fsx failure in
> generic/127 on 1k block size/4k page size configurations that I
> haven't yet tracked down. That test was failing occasionally before
> this patch set as well, so it may be a completely unrelated problem.
> 
> The sad fact of this patchset is it is mostly playing whack-a-mole
> with visible symptoms of bugs.  It drives home the fact that
> bufferheads and the keeping of internal filesystem state attached to
> the page cache simply isn't a verifiable architecture.  After
> spending several days of doing nothing else but tracking down these
> inconsistencies i can only conclude that the code is complex,
> fragile and extremely difficult to verify that behaviour is correct.
> As such, I doubt that the fixes are entirely correct, so I'm left
> with using fsx and fsstress to tell me if I've broken anything.
> 
> Eyeballs appreciated, as is test results.
> 

I had an xfstests running against this (on for-next) over the weekend
and it hit the following bug on xfs/297:

[ 6408.168767] kernel BUG at fs/xfs/xfs_aops.c:1336!
[ 6408.169542] invalid opcode: 0000 [#1] SMP 
[ 6408.169542] Modules linked in: loop xfs libcrc32c ip6t_rpfilter ip6t_REJECT xt_conntrack cfg80211 rfkill ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ppdev snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device microcode snd_pcm serio_raw virtio_balloon virtio_console snd_timer snd parport_pc parport soundcore i2c_piix4 nfsd auth_rpcgss nfs_acl lockd sunrpc virtio_blk virtio_net qxl drm_kms_helper ttm drm i2c_core ata_generic virtio_pci virtio_ring virtio pata_acpi [last unloaded: scsi_debug]
[ 6408.169542] CPU: 0 PID: 28956 Comm: fsstress Not tainted 3.14.0-rc1+ #11
[ 6408.169542] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[ 6408.169542] task: ffff880074860000 ti: ffff880074868000 task.ti: ffff880074868000
[ 6408.169542] RIP: 0010:[<ffffffffa041a4b0>]  [<ffffffffa041a4b0>] __xfs_get_blocks+0x7f0/0x800 [xfs]
[ 6408.169542] RSP: 0018:ffff880074869a00  EFLAGS: 00010202
[ 6408.169542] RAX: ffffffffffffffff RBX: 00000000000fa000 RCX: 00000000000000fa
[ 6408.169542] RDX: ffff8800d5686cc0 RSI: 0000000000000001 RDI: 0000000000000246
[ 6408.169542] RBP: ffff880074869a78 R08: 0000000000000113 R09: 0000000000000000
[ 6408.169542] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000019000
[ 6408.169542] R13: ffff8800a38b9350 R14: ffff8800aa62e7b0 R15: ffff880074869b80
[ 6408.169542] FS:  00007f3ddd3bd740(0000) GS:ffff88011ae00000(0000) knlGS:0000000000000000
[ 6408.169542] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6408.169542] CR2: 00007f3dd801c000 CR3: 0000000077977000 CR4: 00000000000006f0
[ 6408.169542] Stack:
[ 6408.169542]  00007f3d00000000 00007f3d00000008 ffffff01000f18cd 00000000000000fa
[ 6408.169542]  ffff8800a38b9080 00000001aab24840 00000000000000c3 ffffffffffffffff
[ 6408.169542]  000000000000003d ffff880000000000 0000000000000e00 0000000000000003
[ 6408.169542] Call Trace:
[ 6408.169542]  [<ffffffffa041a4f4>] xfs_get_blocks_direct+0x14/0x20 [xfs]
[ 6408.169542]  [<ffffffff81263194>] do_blockdev_direct_IO+0x10e4/0x2ad0
[ 6408.169542]  [<ffffffff811a1355>] ? find_get_pages_tag+0x25/0x310
[ 6408.169542]  [<ffffffffa041a4e0>] ? xfs_get_blocks+0x20/0x20 [xfs]
[ 6408.169542]  [<ffffffff81264bd5>] __blockdev_direct_IO+0x55/0x60
[ 6408.169542]  [<ffffffffa041a4e0>] ? xfs_get_blocks+0x20/0x20 [xfs]
[ 6408.169542]  [<ffffffffa0418512>] xfs_vm_direct_IO+0x152/0x170 [xfs]
[ 6408.169542]  [<ffffffffa041a4e0>] ? xfs_get_blocks+0x20/0x20 [xfs]
[ 6408.169542]  [<ffffffff811a365d>] generic_file_aio_read+0x6fd/0x760
[ 6408.169542]  [<ffffffff8178219e>] ? mutex_unlock+0xe/0x10
[ 6408.169542]  [<ffffffff811ce998>] ? unmap_mapping_range+0x88/0x170
[ 6408.169542]  [<ffffffff810f18cd>] ? trace_hardirqs_on+0xd/0x10
[ 6408.169542]  [<ffffffffa042847c>] xfs_file_aio_read+0x14c/0x3b0 [xfs]
[ 6408.169542]  [<ffffffff8121e85a>] do_sync_read+0x5a/0x90
[ 6408.169542]  [<ffffffff8121ef1e>] vfs_read+0x9e/0x170
[ 6408.169542]  [<ffffffff8121fa1c>] SyS_read+0x4c/0xa0
[ 6408.169542]  [<ffffffff8114a2cc>] ? __audit_syscall_entry+0x9c/0xf0
[ 6408.169542]  [<ffffffff8178eda9>] system_call_fastpath+0x16/0x1b
[ 6408.169542] Code: 85 2e fd ff ff e9 10 ff ff ff 48 c7 c7 e0 11 c5 81 4c 89 55 90 e8 81 47 cd e0 85 c0 4c 8b 55 90 0f 85 e2 fd ff ff e9 7a ff ff ff <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 
[ 6408.200988] RIP  [<ffffffffa041a4b0>] __xfs_get_blocks+0x7f0/0x800 [xfs]
[ 6408.200988]  RSP <ffff880074869a00>
[ 6408.203708] ---[ end trace 40a923b54ddca373 ]---

Brian

> Cheers,
> 
> Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
