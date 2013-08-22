Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 992DC7FA4
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 13:28:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B04E8F8033
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 11:28:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id z3ObHfQNKN0XnN9m for
	<xfs@oss.sgi.com>; Thu, 22 Aug 2013 11:28:18 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7MISH1r016407
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 14:28:18 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r7MISHSU010987
	for <xfs@oss.sgi.com>; Thu, 22 Aug 2013 14:28:17 -0400
Message-ID: <52165830.8050006@redhat.com>
Date: Thu, 22 Aug 2013 14:28:00 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length),
	file: fs/xfs/xfs_trans_buf.c, line: 568
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

Hi all,

I hit an assert on a debug kernel while beating on some finobt work and
eventually reproduced it on unmodified/TOT xfs/xfsprogs as of today. I
hit it through a couple different paths, first while running fsstress on
a CRC enabled filesystem (with otherwise default mkfs options):

(These tests are running on a 4p, 4GB VM against a 100GB virtio disk,
hosted on a single spindle desktop box).

crc=1
fsstress -z -fsymlink=1 -n99999999 -p4 -d /mnt/test

XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length),
file: fs/xfs/xfs_trans_buf.c, line: 568
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:108!
invalid opcode: 0000 [#1] SMP
Modules linked in: xfs libcrc32c fuse ebtable_nat
nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE
ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle bnep
nf_conntrack_ipv4 nf_defrag_ipv4 bluetooth xt_conntrack nf_conntrack
rfkill ebtable_filter ebtables ip6table_filter ip6_tables snd_hda_intel
snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc
snd_timer snd joydev soundcore i2c_piix4 pcspkr mperf virtio_balloon
floppy uinput qxl drm_kms_helper ttm drm virtio_blk virtio_net i2c_core
CPU: 0 PID: 1419 Comm: fsstress Not tainted 3.11.0-rc1+ #10
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff8800d65b5dc0 ti: ffff8800d10ba000 task.ti: ffff8800d10ba000
RIP: 0010:[<ffffffffa02b8812>]  [<ffffffffa02b8812>] assfail+0x22/0x30 [xfs]
RSP: 0018:ffff8800d10bb998  EFLAGS: 00010292
RAX: 000000000000006b RBX: ffff8800d67be3a0 RCX: 0000000000000000
RDX: ffff88011fc0ee48 RSI: ffff88011fc0d038 RDI: ffff88011fc0d038
RBP: ffff8800d10bb998 R08: 0000000000000000 R09: 000000000000020a
R10: ffffffff81858260 R11: 0000000000000209 R12: ffff8800d165d500
R13: ffff8800d1158980 R14: 0000000000001007 R15: ffff8800d1cb8300
FS:  00007f1efd2ce740(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1ef80fb018 CR3: 0000000036edb000 CR4: 00000000000006f0
Stack:
 ffff8800d10bb9e8 ffffffffa031d549 000000fc24a6f000 00000e20000000d3
 ffff8800d10bb9f8 ffff8800d67c3040 ffff8800d1cb8208 ffff8800d1cb81e8
 ffff8800d67c3000 ffff8800d1cb8300 ffff8800d10bba48 ffffffffa02e7c1c
Call Trace:
 [<ffffffffa031d549>] xfs_trans_log_buf+0x89/0x1b0 [xfs]
 [<ffffffffa02e7c1c>] xfs_da3_node_add+0x11c/0x210 [xfs]
 [<ffffffffa02ea703>] xfs_da3_node_split+0xc3/0x230 [xfs]
 [<ffffffffa02eaa18>] xfs_da3_split+0x1a8/0x410 [xfs]
 [<ffffffffa02f743f>] xfs_dir2_node_addname+0x47f/0xde0 [xfs]
 [<ffffffffa02ec965>] xfs_dir_createname+0x1d5/0x1e0 [xfs]
 [<ffffffffa02c1607>] ? kmem_alloc+0x67/0xf0 [xfs]
 [<ffffffffa02becb9>] xfs_symlink+0x619/0xa20 [xfs]
 [<ffffffff811abad6>] ? _d_rehash+0x36/0x40
 [<ffffffff8119f498>] ? __lookup_hash+0x38/0x50
 [<ffffffff8119f4c9>] ? lookup_hash+0x19/0x20
 [<ffffffff811a21ee>] ? kern_path_create+0x8e/0x170
 [<ffffffffa02b5e5c>] xfs_vn_symlink+0x5c/0xe0 [xfs]
 [<ffffffff811a3939>] vfs_symlink+0x99/0x100
 [<ffffffff811a59d6>] SyS_symlinkat+0x66/0xd0
 [<ffffffff811a5a56>] SyS_symlink+0x16/0x20
 [<ffffffff81645442>] system_call_fastpath+0x16/0x1b
Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48
c7 c6 70 50 33 a0 48 89 fa 31 c0 48 89 e5 31 ff e8 de fb ff ff <0f> 0b
66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
RIP  [<ffffffffa02b8812>] assfail+0x22/0x30 [xfs]
 RSP <ffff8800d10bb998>
---[ end trace 9578edaae955ff56 ]---

I repeated the test on a crc=0 fs (with -isize=512) and could not
reproduce during fsstress. I let it populate to about 10GB and
ultimately hit the same assert on unlink during a post-test cleanup:

crc=0
rm -rf /mnt/test

XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length),
file: fs/xfs/xfs_trans_buf.c, line: 568
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:108!
invalid opcode: 0000 [#1] SMP
Modules linked in: xfs libcrc32c fuse ebtable_nat
nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MASQUERADE
ip6table_nat nf_nat_ipv6 ip6table_mangle ip6t_REJECT nf_conntrack_ipv6
nf_defrag_ipv6 iptable_nat nf_nat_ipv4 nf_nat iptable_mangle
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
ebtable_filter ebtables bnep bluetooth rfkill ip6table_filter ip6_tables
snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm
snd_page_alloc snd_timer snd soundcore joydev pcspkr virtio_balloon
i2c_piix4 floppy mperf uinput qxl drm_kms_helper ttm drm virtio_net
virtio_blk i2c_core
CPU: 1 PID: 2198 Comm: rm Not tainted 3.11.0-rc1+ #10
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
task: ffff8801161ec650 ti: ffff8800c803e000 task.ti: ffff8800c803e000
RIP: 0010:[<ffffffffa02c6812>]  [<ffffffffa02c6812>] assfail+0x22/0x30 [xfs]
RSP: 0018:ffff8800c803fa98  EFLAGS: 00010292
RAX: 000000000000006b RBX: ffff8801029a6e80 RCX: 0000000000000000
RDX: ffff88011fc8ee48 RSI: ffff88011fc8d038 RDI: ffff88011fc8d038
RBP: ffff8800c803fa98 R08: 0000000000000000 R09: 0000000000000209
R10: ffffffff81858260 R11: 0000000000000208 R12: ffff8800302bd200
R13: ffff8800d25e0850 R14: 000000000000122f R15: ffff8800d271f010
FS:  00007f28ef9bf740(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000153a000 CR3: 00000000b1fd3000 CR4: 00000000000006e0
Stack:
 ffff8800c803fae8 ffffffffa032b549 00800201008006cc 000000100185febe
 ffffffffa033fcb0 ffff8800ade0c010 ffff8800ade0c000 ffff8800d3c2b9e0
 ffff8800d25e0850 ffff8800d271f010 ffff8800c803fb58 ffffffffa02f61ff
Call Trace:
 [<ffffffffa032b549>] xfs_trans_log_buf+0x89/0x1b0 [xfs]
 [<ffffffffa02f61ff>] xfs_da3_node_unbalance+0xef/0x1d0 [xfs]
 [<ffffffffa02f98b0>] xfs_da3_join+0x240/0x290 [xfs]
 [<ffffffffa030659b>] xfs_dir2_node_removename+0x69b/0x8b0 [xfs]
 [<ffffffffa02e16ce>] ? xfs_bmap_last_extent+0x6e/0xb0 [xfs]
 [<ffffffffa02fa5b5>] xfs_dir_removename+0x195/0x1a0 [xfs]
 [<ffffffffa0310b69>] xfs_remove+0x2a9/0x410 [xfs]
 [<ffffffffa02c3ca2>] xfs_vn_unlink+0x52/0xa0 [xfs]
 [<ffffffff811a260e>] vfs_unlink+0x9e/0x110
 [<ffffffff811a2821>] do_unlinkat+0x1a1/0x230
 [<ffffffff811a592b>] SyS_unlinkat+0x1b/0x40
 [<ffffffff81645442>] system_call_fastpath+0x16/0x1b
Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48
c7 c6 70 30 34 a0 48 89 fa 31 c0 48 89 e5 31 ff e8 de fb ff ff <0f> 0b
66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
RIP  [<ffffffffa02c6812>] assfail+0x22/0x30 [xfs]
 RSP <ffff8800c803fa98>
---[ end trace 3ef54f36db3ba0c5 ]---

Info on the crc=0 fs is as follows:

meta-data=/dev/vdb               isize=512    agcount=4, agsize=6553600 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=26214400, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=12800, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
