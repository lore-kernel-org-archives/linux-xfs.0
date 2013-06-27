Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E6AF97F66
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 22:20:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7BBEDAC001
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 20:20:36 -0700 (PDT)
Received: from mail-vc0-f172.google.com (mail-vc0-f172.google.com
	[209.85.220.172]) by cuda.sgi.com with ESMTP id
	4a6m0csi8rHEcO9B (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 20:20:34 -0700 (PDT)
Received: by mail-vc0-f172.google.com with SMTP id ib11so82185vcb.17
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 20:20:33 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 27 Jun 2013 11:20:33 +0800
Message-ID: <CADFMGu+eJ+skfYHZY8FVV8y2fqjEuRR4LAGPE2BMgYCoMu73wg@mail.gmail.com>
Subject: question about xfs soft lockup stuck
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5318343140260272661=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5318343140260272661==
Content-Type: multipart/alternative; boundary=089e01294132beeba904e01a3eb8

--089e01294132beeba904e01a3eb8
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

Dear Brian and xfs experts,

Recently we have encountered an issue related to xfs. The log reports xfs
soft lockup stuck which is similar to this bug:
http://bugs.centos.org/view.php?id=3D6287

I wan to ask a question. Is this issue already been fixed in kernel 358 or
not(BZ#921961, BZ#896224)?


Thank you very much.

logs:
Jun 26 17:57:06 cqdx kernel: BUG: soft lockup - CPU#0 stuck for 67s!
[xfslogd/0:2014]
Jun 26 17:57:06 cqdx kernel: Modules linked in: fuse ipv6 xfs exportfs
vhost_net macvtap macvlan tun kvm_intel kvm power_meter dcdbas microcode
sb_edac edac_core iTCO_wdt iTCO_vendor_support shpchp igb sg ixgbe dca mdio
ext4 mbcache jbd2 sd_mod crc_t10dif wmi megaraid_sas dm_mirror
dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
Jun 26 17:57:06 cqdx kernel: CPU 0
Jun 26 17:57:06 cqdx kernel: Modules linked in: fuse ipv6 xfs exportfs
vhost_net macvtap macvlan tun kvm_intel kvm power_meter dcdbas microcode
sb_edac edac_core iTCO_wdt iTCO_vendor_support shpchp igb sg ixgbe dca mdio
ext4 mbcache jbd2 sd_mod crc_t10dif wmi megaraid_sas dm_mirror
dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
Jun 26 17:57:06 cqdx kernel:
Jun 26 17:57:06 cqdx kernel: Pid: 2014, comm: xfslogd/0 Not tainted
2.6.32-279.19.1.01.qiyi.el6.x86_64 #1 Dell Inc. PowerEdge R720xd/0T0WRN
Jun 26 17:57:06 cqdx kernel: RIP: 0010:[<ffffffff814ec55c>]
[<ffffffff814ec55c>] _spin_lock+0x1c/0x30
Jun 26 17:57:06 cqdx kernel: RSP: 0000:ffff88101465bd50  EFLAGS: 00000293
Jun 26 17:57:06 cqdx kernel: RAX: 0000000000005468 RBX: ffff88101465bd50
RCX: ffffe8efaf600e88
Jun 26 17:57:06 cqdx kernel: RDX: 0000000000005466 RSI: ffff882011755898
RDI: ffff88201955b100
Jun 26 17:57:06 cqdx kernel: RBP: ffffffff8100bb8e R08: 0000000000000000
R09: 00000000ffffffff
Jun 26 17:57:06 cqdx kernel: R10: 0000000000000000 R11: 0000000000000000
R12: ffff88101465bd70
Jun 26 17:57:06 cqdx kernel: R13: ffffffff8100b9ce R14: 0000000000000400
R15: 0000000000000094
Jun 26 17:57:06 cqdx kernel: FS:  0000000000000000(0000)
GS:ffff880028200000(0000) knlGS:0000000000000000
Jun 26 17:57:06 cqdx kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Jun 26 17:57:06 cqdx kernel: CR2: 00007f9e001dc0a0 CR3: 000000201311e000
CR4: 00000000000406f0
Jun 26 17:57:06 cqdx kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Jun 26 17:57:06 cqdx kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: 0000000000000400
Jun 26 17:57:06 cqdx kernel: Process xfslogd/0 (pid: 2014, threadinfo
ffff88101465a000, task ffff881015b75500)
Jun 26 17:57:06 cqdx kernel: Stack:
Jun 26 17:57:06 cqdx kernel: ffff88101465bd80 ffffffffa02a2b3b
0000000000000001 ffff8820137c7300
Jun 26 17:57:06 cqdx kernel: <d> ffff882016daee40 ffff882017e03800
ffff88101465bda0 ffffffffa02a2adc
Jun 26 17:57:06 cqdx kernel: <d> ffff882016d330a8 ffff882016daee40
ffff88101465be10 ffffffffa02a2d51
Jun 26 17:57:06 cqdx kernel: Call Trace:
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a2b3b>] ?
xfs_buf_iodone+0x2b/0x60 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a2adc>] ?
xfs_buf_do_callbacks+0x3c/0x50 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a2d51>] ?
xfs_buf_iodone_callbacks+0x51/0x270 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02db190>] ?
xfs_buf_iodone_work+0x0/0x50 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02db1b6>] ?
xfs_buf_iodone_work+0x26/0x50 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffff8108b120>] ?
worker_thread+0x170/0x2a0
Jun 26 17:57:06 cqdx kernel: [<ffffffff81090990>] ?
autoremove_wake_function+0x0/0x40
Jun 26 17:57:06 cqdx kernel: [<ffffffff8108afb0>] ? worker_thread+0x0/0x2a0
Jun 26 17:57:06 cqdx kernel: [<ffffffff81090626>] ? kthread+0x96/0xa0
Jun 26 17:57:06 cqdx kernel: [<ffffffff8100c0ca>] ? child_rip+0xa/0x20
Jun 26 17:57:06 cqdx kernel: [<ffffffff81090590>] ? kthread+0x0/0xa0
Jun 26 17:57:06 cqdx kernel: [<ffffffff8100c0c0>] ? child_rip+0x0/0x20
Jun 26 17:57:06 cqdx kernel: Code: 81 2f 00 00 00 01 74 05 e8 72 8c d8 ff
c9 c3 55 48 89 e5 0f 1f 44 00 00 b8 00 00 01 00 f0 0f c1 07 0f b7 d0 c1 e8
10 39 c2 74 0e <f3> 90 0f b7 17 eb f5 83 3f 00 75 f4 eb df c9 c3 0f 1f 40
00 55
Jun 26 17:57:06 cqdx kernel: Call Trace:
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a2b3b>] ?
xfs_buf_iodone+0x2b/0x60 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a2adc>] ?
xfs_buf_do_callbacks+0x3c/0x50 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a2d51>] ?
xfs_buf_iodone_callbacks+0x51/0x270 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02db190>] ?
xfs_buf_iodone_work+0x0/0x50 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02db1b6>] ?
xfs_buf_iodone_work+0x26/0x50 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffff8108b120>] ?
worker_thread+0x170/0x2a0
Jun 26 17:57:06 cqdx kernel: [<ffffffff81090990>] ?
autoremove_wake_function+0x0/0x40
Jun 26 17:57:06 cqdx kernel: [<ffffffff8108afb0>] ? worker_thread+0x0/0x2a0
Jun 26 17:57:06 cqdx kernel: [<ffffffff81090626>] ? kthread+0x96/0xa0
Jun 26 17:57:06 cqdx kernel: [<ffffffff8100c0ca>] ? child_rip+0xa/0x20
Jun 26 17:57:06 cqdx kernel: [<ffffffff81090590>] ? kthread+0x0/0xa0
Jun 26 17:57:06 cqdx kernel: [<ffffffff8100c0c0>] ? child_rip+0x0/0x20
Jun 26 17:57:06 cqdx kernel: BUG: soft lockup - CPU#15 stuck for 67s!
[glusterfsd:3245]
Jun 26 17:57:06 cqdx kernel: Modules linked in: fuse ipv6 xfs exportfs
vhost_net macvtap macvlan tun kvm_intel kvm power_meter dcdbas microcode
sb_edac edac_core iTCO_wdt iTCO_vendor_support shpchp igb sg ixgbe dca mdio
ext4 mbcache jbd2 sd_mod crc_t10dif wmi megaraid_sas dm_mirror
dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
Jun 26 17:57:06 cqdx kernel: CPU 15
Jun 26 17:57:06 cqdx kernel: Modules linked in: fuse ipv6 xfs exportfs
vhost_net macvtap macvlan tun kvm_intel kvm power_meter dcdbas microcode
sb_edac edac_core iTCO_wdt iTCO_vendor_support shpchp igb sg ixgbe dca mdio
ext4 mbcache jbd2 sd_mod crc_t10dif wmi megaraid_sas dm_mirror
dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]
Jun 26 17:57:06 cqdx kernel:
Jun 26 17:57:06 cqdx kernel: Pid: 3245, comm: glusterfsd Not tainted
2.6.32-279.19.1.01.qiyi.el6.x86_64 #1 Dell Inc. PowerEdge R720xd/0T0WRN
Jun 26 17:57:06 cqdx kernel: RIP: 0010:[<ffffffff814ec55e>]
[<ffffffff814ec55e>] _spin_lock+0x1e/0x30
Jun 26 17:57:06 cqdx kernel: RSP: 0018:ffff880dceb5d528  EFLAGS: 00000297
Jun 26 17:57:06 cqdx kernel: RAX: 00000000000087eb RBX: ffff880dceb5d528
RCX: ffff8820137923e0
Jun 26 17:57:06 cqdx kernel: RDX: 00000000000087ea RSI: 0000000000006e5c
RDI: ffff882016d330a8
Jun 26 17:57:06 cqdx kernel: RBP: ffffffff8100bb8e R08: ffff880dceb5d674
R09: ffff880dceb5d670
Jun 26 17:57:06 cqdx kernel: R10: 0000000000000000 R11: 0000000000000000
R12: 0000000000000000
Jun 26 17:57:06 cqdx kernel: R13: 0000000000000cb5 R14: ffff8810788166e8
R15: ffff882016ea9400
Jun 26 17:57:06 cqdx kernel: FS:  00007f6cf3fff700(0000)
GS:ffff8810788e0000(0000) knlGS:0000000000000000
Jun 26 17:57:06 cqdx kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jun 26 17:57:06 cqdx kernel: CR2: 0000000000481046 CR3: 000000201311e000
CR4: 00000000000406e0
Jun 26 17:57:06 cqdx kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Jun 26 17:57:06 cqdx kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: 0000000000000400
Jun 26 17:57:06 cqdx kernel: Process glusterfsd (pid: 3245, threadinfo
ffff880dceb5c000, task ffff8810191ecaa0)
Jun 26 17:57:06 cqdx kernel: Stack:
Jun 26 17:57:06 cqdx kernel: ffff880dceb5d5d8 ffffffffa02c27a8
ffff881078816680 ffff880dceb5d670
Jun 26 17:57:06 cqdx kernel: <d> ffff880dceb5d674 ffff880dceb5d668
00006e5c0000000f 0000000000000001
Jun 26 17:57:06 cqdx kernel: <d> 00000000000172a0 ffff882016d33080
ffff880dceb5d588 0000000000000082
Jun 26 17:57:06 cqdx kernel: Call Trace:
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c27a8>] ?
xlog_state_get_iclog_space+0x68/0x2e0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffff8105f8ac>] ?
try_to_wake_up+0x24c/0x3e0
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c2bf1>] ? xlog_write+0x181/0x6d0
[xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffff8126f9f5>] ? rwsem_wake+0x75/0x170
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c3c41>] ?
xlog_cil_push+0x261/0x3d0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c43a5>] ?
xlog_cil_force_lsn+0x115/0x120 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa029a30d>] ?
xfs_bmap_add_extent+0xad/0x3c0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c2308>] ?
_xfs_log_force+0x68/0x240 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c2718>] ? xfs_log_force+0x18/0x40
[xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02d99d0>] ?
xfs_buf_cond_lock+0x90/0xc0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02dadb3>] ?
_xfs_buf_find+0xe3/0x280 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02dafbb>] ? xfs_buf_get+0x6b/0x1a0
[xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02d16d8>] ?
xfs_trans_get_buf+0xe8/0x180 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a4a67>] ?
xfs_da_do_buf+0x4c7/0x770 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a5fda>] ?
xfs_da_get_buf+0x2a/0x30 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02aa49d>] ?
xfs_dir2_data_init+0x4d/0xf0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02aa49d>] ?
xfs_dir2_data_init+0x4d/0xf0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a8c23>] ?
xfs_dir2_sf_to_block+0xe3/0x5e0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02b5ce6>] ? xfs_iunlock+0x86/0x100
[xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffff8118ecaa>] ? dput+0x9a/0x150
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02b0c18>] ?
xfs_dir2_sf_addname+0x458/0x5b0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02d6687>] ?
kmem_zone_alloc+0x77/0xf0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02a81bc>] ?
xfs_dir_createname+0x14c/0x1b0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02d3390>] ? xfs_link+0x1f0/0x300
[xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffff81195560>] ?
mntput_no_expire+0x30/0x110
Jun 26 17:57:06 cqdx kernel: [<ffffffff8118e7a7>] ? __d_lookup+0xa7/0x150
Jun 26 17:57:06 cqdx kernel: [<ffffffff8107721a>] ? capable+0x2a/0x60
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02e1120>] ? xfs_vn_link+0x40/0x70
[xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffff8118379c>] ? vfs_link+0x11c/0x190
Jun 26 17:57:06 cqdx kernel: [<ffffffff81182aaa>] ? lookup_hash+0x3a/0x50
Jun 26 17:57:06 cqdx kernel: [<ffffffff81186b71>] ? sys_linkat+0x141/0x160
Jun 26 17:57:06 cqdx kernel: [<ffffffff8117b83b>] ? vfs_stat+0x1b/0x20
Jun 26 17:57:06 cqdx kernel: [<ffffffff8117b864>] ? sys_newstat+0x24/0x50
Jun 26 17:57:06 cqdx kernel: [<ffffffff81186bae>] ? sys_link+0x1e/0x20
Jun 26 17:57:06 cqdx kernel: [<ffffffff8100b072>] ?
system_call_fastpath+0x16/0x1b
Jun 26 17:57:06 cqdx kernel: Code: 00 00 00 01 74 05 e8 72 8c d8 ff c9 c3
55 48 89 e5 0f 1f 44 00 00 b8 00 00 01 00 f0 0f c1 07 0f b7 d0 c1 e8 10 39
c2 74 0e f3 90 <0f> b7 17 eb f5 83 3f 00 75 f4 eb df c9 c3 0f 1f 40 00 55
48 89
Jun 26 17:57:06 cqdx kernel: Call Trace:
Jun 26 17:57:06 cqdx kernel: [<ffffffff8106210b>] ?
enqueue_task_fair+0xfb/0x100
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c27a8>] ?
xlog_state_get_iclog_space+0x68/0x2e0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffff8105f8ac>] ?
try_to_wake_up+0x24c/0x3e0
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c2bf1>] ? xlog_write+0x181/0x6d0
[xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffff8126f9f5>] ? rwsem_wake+0x75/0x170
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c3c41>] ?
xlog_cil_push+0x261/0x3d0 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa02c43a5>] ?
xlog_cil_force_lsn+0x115/0x120 [xfs]
Jun 26 17:57:06 cqdx kernel: [<ffffffffa029a30d>] ?
xfs_bmap_add_extent+0xad/0x3c0 [xfs]


--=20
=B7=FB=D3=C0=CC=CE

--089e01294132beeba904e01a3eb8
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div>Dear Brian and xfs experts,<br><br></div>Recentl=
y we have encountered an issue related to xfs. The log reports xfs soft loc=
kup stuck which is similar to this bug: <br><a href=3D"http://bugs.centos.o=
rg/view.php?id=3D6287">http://bugs.centos.org/view.php?id=3D6287</a><br>
<br></div><div>I wan to ask a question. Is this issue already been fixed in=
 kernel 358 or not(BZ#921961, BZ#896224)?<br>&nbsp;<br><br></div><div>Thank=
 you very much.<br><br></div><div>logs:<br>Jun 26 17:57:06 cqdx kernel: BUG=
: soft lockup - CPU#0 stuck for 67s! [xfslogd/0:2014]<br>
Jun 26 17:57:06 cqdx kernel: Modules linked in: fuse ipv6 xfs exportfs vhos=
t_net macvtap macvlan tun kvm_intel kvm power_meter dcdbas microcode sb_eda=
c edac_core iTCO_wdt iTCO_vendor_support shpchp igb sg ixgbe dca mdio ext4 =
mbcache jbd2 sd_mod crc_t10dif wmi megaraid_sas dm_mirror dm_region_hash dm=
_log dm_mod [last unloaded: scsi_wait_scan]<br>
Jun 26 17:57:06 cqdx kernel: CPU 0<br>Jun 26 17:57:06 cqdx kernel: Modules =
linked in: fuse ipv6 xfs exportfs vhost_net macvtap macvlan tun kvm_intel k=
vm power_meter dcdbas microcode sb_edac edac_core iTCO_wdt iTCO_vendor_supp=
ort shpchp igb sg ixgbe dca mdio ext4 mbcache jbd2 sd_mod crc_t10dif wmi me=
garaid_sas dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wait=
_scan]<br>
Jun 26 17:57:06 cqdx kernel: <br>Jun 26 17:57:06 cqdx kernel: Pid: 2014, co=
mm: xfslogd/0 Not tainted 2.6.32-279.19.1.01.qiyi.el6.x86_64 #1 Dell Inc. P=
owerEdge R720xd/0T0WRN<br>Jun 26 17:57:06 cqdx kernel: RIP: 0010:[&lt;fffff=
fff814ec55c&gt;]&nbsp; [&lt;ffffffff814ec55c&gt;] _spin_lock+0x1c/0x30<br>
Jun 26 17:57:06 cqdx kernel: RSP: 0000:ffff88101465bd50&nbsp; EFLAGS: 00000=
293<br>Jun 26 17:57:06 cqdx kernel: RAX: 0000000000005468 RBX: ffff88101465=
bd50 RCX: ffffe8efaf600e88<br>Jun 26 17:57:06 cqdx kernel: RDX: 00000000000=
05466 RSI: ffff882011755898 RDI: ffff88201955b100<br>
Jun 26 17:57:06 cqdx kernel: RBP: ffffffff8100bb8e R08: 0000000000000000 R0=
9: 00000000ffffffff<br>Jun 26 17:57:06 cqdx kernel: R10: 0000000000000000 R=
11: 0000000000000000 R12: ffff88101465bd70<br>Jun 26 17:57:06 cqdx kernel: =
R13: ffffffff8100b9ce R14: 0000000000000400 R15: 0000000000000094<br>
Jun 26 17:57:06 cqdx kernel: FS:&nbsp; 0000000000000000(0000) GS:ffff880028=
200000(0000) knlGS:0000000000000000<br>Jun 26 17:57:06 cqdx kernel: CS:&nbs=
p; 0010 DS: 0018 ES: 0018 CR0: 000000008005003b<br>Jun 26 17:57:06 cqdx ker=
nel: CR2: 00007f9e001dc0a0 CR3: 000000201311e000 CR4: 00000000000406f0<br>
Jun 26 17:57:06 cqdx kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR=
2: 0000000000000000<br>Jun 26 17:57:06 cqdx kernel: DR3: 0000000000000000 D=
R6: 00000000ffff0ff0 DR7: 0000000000000400<br>Jun 26 17:57:06 cqdx kernel: =
Process xfslogd/0 (pid: 2014, threadinfo ffff88101465a000, task ffff881015b=
75500)<br>
Jun 26 17:57:06 cqdx kernel: Stack:<br>Jun 26 17:57:06 cqdx kernel: ffff881=
01465bd80 ffffffffa02a2b3b 0000000000000001 ffff8820137c7300<br>Jun 26 17:5=
7:06 cqdx kernel: &lt;d&gt; ffff882016daee40 ffff882017e03800 ffff88101465b=
da0 ffffffffa02a2adc<br>
Jun 26 17:57:06 cqdx kernel: &lt;d&gt; ffff882016d330a8 ffff882016daee40 ff=
ff88101465be10 ffffffffa02a2d51<br>Jun 26 17:57:06 cqdx kernel: Call Trace:=
<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02a2b3b&gt;] ? xfs_buf_iodon=
e+0x2b/0x60 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02a2adc&gt;] ? xfs_buf_do_callba=
cks+0x3c/0x50 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02a2d51&g=
t;] ? xfs_buf_iodone_callbacks+0x51/0x270 [xfs]<br>Jun 26 17:57:06 cqdx ker=
nel: [&lt;ffffffffa02db190&gt;] ? xfs_buf_iodone_work+0x0/0x50 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02db1b6&gt;] ? xfs_buf_iodone_wo=
rk+0x26/0x50 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8108b120&gt=
;] ? worker_thread+0x170/0x2a0<br>Jun 26 17:57:06 cqdx kernel: [&lt;fffffff=
f81090990&gt;] ? autoremove_wake_function+0x0/0x40<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8108afb0&gt;] ? worker_thread+0x0=
/0x2a0<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff81090626&gt;] ? kthread=
+0x96/0xa0<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8100c0ca&gt;] ? chi=
ld_rip+0xa/0x20<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff81090590&gt;] ? kthread+0x0/0xa0<=
br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8100c0c0&gt;] ? child_rip+0x0/=
0x20<br>Jun 26 17:57:06 cqdx kernel: Code: 81 2f 00 00 00 01 74 05 e8 72 8c=
 d8 ff c9 c3 55 48 89 e5 0f 1f 44 00 00 b8 00 00 01 00 f0 0f c1 07 0f b7 d0=
 c1 e8 10 39 c2 74 0e &lt;f3&gt; 90 0f b7 17 eb f5 83 3f 00 75 f4 eb df c9 =
c3 0f 1f 40 00 55<br>
Jun 26 17:57:06 cqdx kernel: Call Trace:<br>Jun 26 17:57:06 cqdx kernel: [&=
lt;ffffffffa02a2b3b&gt;] ? xfs_buf_iodone+0x2b/0x60 [xfs]<br>Jun 26 17:57:0=
6 cqdx kernel: [&lt;ffffffffa02a2adc&gt;] ? xfs_buf_do_callbacks+0x3c/0x50 =
[xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02a2d51&gt;] ? xfs_buf_iodone_ca=
llbacks+0x51/0x270 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02db=
190&gt;] ? xfs_buf_iodone_work+0x0/0x50 [xfs]<br>Jun 26 17:57:06 cqdx kerne=
l: [&lt;ffffffffa02db1b6&gt;] ? xfs_buf_iodone_work+0x26/0x50 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8108b120&gt;] ? worker_thread+0x1=
70/0x2a0<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff81090990&gt;] ? autor=
emove_wake_function+0x0/0x40<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8=
108afb0&gt;] ? worker_thread+0x0/0x2a0<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff81090626&gt;] ? kthread+0x96/0xa0=
<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8100c0ca&gt;] ? child_rip+0xa=
/0x20<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff81090590&gt;] ? kthread+=
0x0/0xa0<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8100c0c0&gt;] ? child_rip+0x0/0x2=
0<br>Jun 26 17:57:06 cqdx kernel: BUG: soft lockup - CPU#15 stuck for 67s! =
[glusterfsd:3245]<br>Jun 26 17:57:06 cqdx kernel: Modules linked in: fuse i=
pv6 xfs exportfs vhost_net macvtap macvlan tun kvm_intel kvm power_meter dc=
dbas microcode sb_edac edac_core iTCO_wdt iTCO_vendor_support shpchp igb sg=
 ixgbe dca mdio ext4 mbcache jbd2 sd_mod crc_t10dif wmi megaraid_sas dm_mir=
ror dm_region_hash dm_log dm_mod [last unloaded: scsi_wait_scan]<br>
Jun 26 17:57:06 cqdx kernel: CPU 15<br>Jun 26 17:57:06 cqdx kernel: Modules=
 linked in: fuse ipv6 xfs exportfs vhost_net macvtap macvlan tun kvm_intel =
kvm power_meter dcdbas microcode sb_edac edac_core iTCO_wdt iTCO_vendor_sup=
port shpchp igb sg ixgbe dca mdio ext4 mbcache jbd2 sd_mod crc_t10dif wmi m=
egaraid_sas dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_wai=
t_scan]<br>
Jun 26 17:57:06 cqdx kernel: <br>Jun 26 17:57:06 cqdx kernel: Pid: 3245, co=
mm: glusterfsd Not tainted 2.6.32-279.19.1.01.qiyi.el6.x86_64 #1 Dell Inc. =
PowerEdge R720xd/0T0WRN<br>Jun 26 17:57:06 cqdx kernel: RIP: 0010:[&lt;ffff=
ffff814ec55e&gt;]&nbsp; [&lt;ffffffff814ec55e&gt;] _spin_lock+0x1e/0x30<br>
Jun 26 17:57:06 cqdx kernel: RSP: 0018:ffff880dceb5d528&nbsp; EFLAGS: 00000=
297<br>Jun 26 17:57:06 cqdx kernel: RAX: 00000000000087eb RBX: ffff880dceb5=
d528 RCX: ffff8820137923e0<br>Jun 26 17:57:06 cqdx kernel: RDX: 00000000000=
087ea RSI: 0000000000006e5c RDI: ffff882016d330a8<br>
Jun 26 17:57:06 cqdx kernel: RBP: ffffffff8100bb8e R08: ffff880dceb5d674 R0=
9: ffff880dceb5d670<br>Jun 26 17:57:06 cqdx kernel: R10: 0000000000000000 R=
11: 0000000000000000 R12: 0000000000000000<br>Jun 26 17:57:06 cqdx kernel: =
R13: 0000000000000cb5 R14: ffff8810788166e8 R15: ffff882016ea9400<br>
Jun 26 17:57:06 cqdx kernel: FS:&nbsp; 00007f6cf3fff700(0000) GS:ffff881078=
8e0000(0000) knlGS:0000000000000000<br>Jun 26 17:57:06 cqdx kernel: CS:&nbs=
p; 0010 DS: 0000 ES: 0000 CR0: 0000000080050033<br>Jun 26 17:57:06 cqdx ker=
nel: CR2: 0000000000481046 CR3: 000000201311e000 CR4: 00000000000406e0<br>
Jun 26 17:57:06 cqdx kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR=
2: 0000000000000000<br>Jun 26 17:57:06 cqdx kernel: DR3: 0000000000000000 D=
R6: 00000000ffff0ff0 DR7: 0000000000000400<br>Jun 26 17:57:06 cqdx kernel: =
Process glusterfsd (pid: 3245, threadinfo ffff880dceb5c000, task ffff881019=
1ecaa0)<br>
Jun 26 17:57:06 cqdx kernel: Stack:<br>Jun 26 17:57:06 cqdx kernel: ffff880=
dceb5d5d8 ffffffffa02c27a8 ffff881078816680 ffff880dceb5d670<br>Jun 26 17:5=
7:06 cqdx kernel: &lt;d&gt; ffff880dceb5d674 ffff880dceb5d668 00006e5c00000=
00f 0000000000000001<br>
Jun 26 17:57:06 cqdx kernel: &lt;d&gt; 00000000000172a0 ffff882016d33080 ff=
ff880dceb5d588 0000000000000082<br>Jun 26 17:57:06 cqdx kernel: Call Trace:=
<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02c27a8&gt;] ? xlog_state_ge=
t_iclog_space+0x68/0x2e0 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8105f8ac&gt;] ? try_to_wake_up+0x=
24c/0x3e0<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02c2bf1&gt;] ? xlog=
_write+0x181/0x6d0 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8126f=
9f5&gt;] ? rwsem_wake+0x75/0x170<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02c3c41&gt;] ? xlog_cil_push+0x2=
61/0x3d0 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02c43a5&gt;] ?=
 xlog_cil_force_lsn+0x115/0x120 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;=
ffffffffa029a30d&gt;] ? xfs_bmap_add_extent+0xad/0x3c0 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02c2308&gt;] ? _xfs_log_force+0x=
68/0x240 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02c2718&gt;] ?=
 xfs_log_force+0x18/0x40 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;fffffff=
fa02d99d0&gt;] ? xfs_buf_cond_lock+0x90/0xc0 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02dadb3&gt;] ? _xfs_buf_find+0xe=
3/0x280 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02dafbb&gt;] ? =
xfs_buf_get+0x6b/0x1a0 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa=
02d16d8&gt;] ? xfs_trans_get_buf+0xe8/0x180 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02a4a67&gt;] ? xfs_da_do_buf+0x4=
c7/0x770 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02a5fda&gt;] ?=
 xfs_da_get_buf+0x2a/0x30 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffff=
ffa02aa49d&gt;] ? xfs_dir2_data_init+0x4d/0xf0 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02aa49d&gt;] ? xfs_dir2_data_ini=
t+0x4d/0xf0 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02a8c23&gt;=
] ? xfs_dir2_sf_to_block+0xe3/0x5e0 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [=
&lt;ffffffffa02b5ce6&gt;] ? xfs_iunlock+0x86/0x100 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8118ecaa&gt;] ? dput+0x9a/0x150<b=
r>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02b0c18&gt;] ? xfs_dir2_sf_add=
name+0x458/0x5b0 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02d668=
7&gt;] ? kmem_zone_alloc+0x77/0xf0 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02a81bc&gt;] ? xfs_dir_createnam=
e+0x14c/0x1b0 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02d3390&g=
t;] ? xfs_link+0x1f0/0x300 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;fffff=
fff81195560&gt;] ? mntput_no_expire+0x30/0x110<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8118e7a7&gt;] ? __d_lookup+0xa7/0=
x150<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8107721a&gt;] ? capable+0=
x2a/0x60<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02e1120&gt;] ? xfs_v=
n_link+0x40/0x70 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8118379c&gt;] ? vfs_link+0x11c/0x=
190<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff81182aaa&gt;] ? lookup_has=
h+0x3a/0x50<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff81186b71&gt;] ? sy=
s_linkat+0x141/0x160<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8117b83b&gt;] ? vfs_stat+0x1b/0x2=
0<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8117b864&gt;] ? sys_newstat+=
0x24/0x50<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff81186bae&gt;] ? sys_=
link+0x1e/0x20<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8100b072&gt;] ? system_call_fastp=
ath+0x16/0x1b<br>Jun 26 17:57:06 cqdx kernel: Code: 00 00 00 01 74 05 e8 72=
 8c d8 ff c9 c3 55 48 89 e5 0f 1f 44 00 00 b8 00 00 01 00 f0 0f c1 07 0f b7=
 d0 c1 e8 10 39 c2 74 0e f3 90 &lt;0f&gt; b7 17 eb f5 83 3f 00 75 f4 eb df =
c9 c3 0f 1f 40 00 55 48 89<br>
Jun 26 17:57:06 cqdx kernel: Call Trace:<br>Jun 26 17:57:06 cqdx kernel: [&=
lt;ffffffff8106210b&gt;] ? enqueue_task_fair+0xfb/0x100<br>Jun 26 17:57:06 =
cqdx kernel: [&lt;ffffffffa02c27a8&gt;] ? xlog_state_get_iclog_space+0x68/0=
x2e0 [xfs]<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8105f8ac&gt;] ? try_to_wake_up+0x=
24c/0x3e0<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02c2bf1&gt;] ? xlog=
_write+0x181/0x6d0 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffff8126f=
9f5&gt;] ? rwsem_wake+0x75/0x170<br>
Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02c3c41&gt;] ? xlog_cil_push+0x2=
61/0x3d0 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;ffffffffa02c43a5&gt;] ?=
 xlog_cil_force_lsn+0x115/0x120 [xfs]<br>Jun 26 17:57:06 cqdx kernel: [&lt;=
ffffffffa029a30d&gt;] ? xfs_bmap_add_extent+0xad/0x3c0 [xfs]<br>
<br> </div><div><div><div><div><div><br>-- <br>=B7=FB=D3=C0=CC=CE
</div></div></div></div></div></div>

--089e01294132beeba904e01a3eb8--


--===============5318343140260272661==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5318343140260272661==--
