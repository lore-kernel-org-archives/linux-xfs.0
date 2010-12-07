Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7CtaG2150672 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 06:55:36 -0600
Received: from mail-iw0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFA491CDA77
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 04:57:23 -0800 (PST)
Received: from mail-iw0-f181.google.com (mail-iw0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	2GbNeLkF4qPrSo0n for <xfs@oss.sgi.com>;
	Tue, 07 Dec 2010 04:57:23 -0800 (PST)
Received: by iwn3 with SMTP id 3so17007803iwn.26
	for <xfs@oss.sgi.com>; Tue, 07 Dec 2010 04:57:23 -0800 (PST)
MIME-Version: 1.0
From: Tharindu Rukshan Bamunuarachchi <btharindu@gmail.com>
Date: Tue, 7 Dec 2010 18:26:52 +0530
Message-ID: <AANLkTi=2WUJGyf-_moOMKWsR1F29a48LgpziXaLNLtxz@mail.gmail.com>
Subject: xfs_count_page_state inside kswapd
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7700997044252950294=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7700997044252950294==
Content-Type: multipart/alternative; boundary=000325576092b36b900496d18bf6

--000325576092b36b900496d18bf6
Content-Type: text/plain; charset=UTF-8

Dear All,

We got following oops in one of our SLES 11 server. This occurred inside
swapd and we running our server swap turned off..

Could this be memory corruption or possible old bug in code ?

Please help.
Thanks

Dec 6 22:55:46 tm-spes-md102 kernel: BUG: unable to handle kernel NULL
pointer dereference at 0000000000000000
Dec 6 22:55:46 tm-spes-md102 kernel: IP: [<ffffffffa0250659>]
xfs_count_page_state+0x25/0x66 [xfs]
Dec 6 22:55:46 tm-spes-md102 kernel: PGD 37dc4e067 PUD 16f631067 PMD 0
Dec 6 22:55:46 tm-spes-md102 kernel: Oops: 0000 [1] SMP
Dec 6 22:55:46 tm-spes-md102 kernel: last sysfs file:
/sys/devices/pci0000:00/0000:00:03.0/0000:15:00.0/infiniband/mlx4_0/node_type

Dec 6 22:55:46 tm-spes-md102 kernel: CPU 2
Dec 6 22:55:46 tm-spes-md102 kernel: Modules linked in: af_packet st
ide_disk ide_cd_mod lp parport_pc ppdev parport nfs lockd nfs_acl
sunrpc ipmi_devintf ipmi_si ipmi_msghandler bonding microcode binfmt_misc
rdma_ucm(N) ib_sdp(N) rdma_cm(N) iw_cm(N) ib_addr(N) ib_ipoib(
N) ib_cm(N) ib_sa(N) ipv6 ib_uverbs(N) ib_umad(N) mlx4_en(N) mlx4_ib(N)
ib_mthca(N) ib_mad(N) ib_core(N) fuse ext2 xfs loop dm_mod joyde
v cdc_ether rtc_cmos usbhid usbnet rtc_core mlx4_core(N) hid shpchp i2c_i801
pci_hotplug button pcspkr mii sr_mod i2c_core rtc_lib ff_me
mless cdrom sg uhci_hcd sd_mod ehci_hcd crc_t10dif usbcore edd ext3 mbcache
jbd fan thermal processor thermal_sys hwmon ide_pci_generic
ide_core ata_generic ata_piix libata dock megaraid_sas scsi_mod [last
unloaded: parport_pc]
Dec 6 22:55:46 tm-spes-md102 kernel: Supported: No, Unsupported modules are
loaded
Dec 6 22:55:46 tm-spes-md102 kernel: Pid: 58, comm: kswapd0 Tainted: G
2.6.27.45-0.1-default #1
Dec 6 22:55:46 tm-spes-md102 kernel: RIP: 0010:[<ffffffffa0250659>]
[<ffffffffa0250659>] xfs_count_page_state+0x25/0x66 [xfs]
Dec 6 22:55:46 tm-spes-md102 kernel: RSP: 0018:ffff88037cdcbbe8 EFLAGS:
00010207
Dec 6 22:55:46 tm-spes-md102 kernel: RAX: ffff88038ceff610 RBX:
ffffe20012c30b40 RCX: ffff88037cdcbc34
Dec 6 22:55:46 tm-spes-md102 kernel: RDX: ffff88037cdcbc38 RSI:
ffff88037cdcbc3c RDI: ffffe20012c30b40
Dec 6 22:55:46 tm-spes-md102 kernel: RBP: 0000000000000000 R08:
0000000000000021 R09: 0000000000000000
Dec 6 22:55:46 tm-spes-md102 kernel: R10: ffff88038ceff678 R11:
ffffffffa0251b18 R12: ffff880517690480
Dec 6 22:55:46 tm-spes-md102 kernel: R13: ffff88037cdcbce0 R14:
00000000002548c2 R15: ffff880517690590
Dec 6 22:55:46 tm-spes-md102 kernel: FS: 0000000000000000(0000)
GS:ffff88037e520e40(0000) knlGS:0000000000000000
Dec 6 22:55:46 tm-spes-md102 kernel: CS: 0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Dec 6 22:55:46 tm-spes-md102 kernel: CR2: 0000000000000000 CR3:
000000016f670000 CR4: 00000000000006e0
Dec 6 22:55:46 tm-spes-md102 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Dec 6 22:55:46 tm-spes-md102 kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Dec 6 22:55:46 tm-spes-md102 kernel: Process kswapd0 (pid: 58, threadinfo
ffff88037cdca000, task ffff88037cdc8780)
Dec 6 22:55:47 tm-spes-md102 kernel: Stack: ffffffffa0251b68
0000000000000000 0000000000000001 0000000000000000
Dec 6 22:55:47 tm-spes-md102 kernel: 0000000000000001 0000000000000000
0000000000000000 0000000000000000
Dec 6 22:55:47 tm-spes-md102 kernel: 0000000000000000 00000000002acfa4
0000000000000000 ffffe20012c30b40
Dec 6 22:55:47 tm-spes-md102 kernel: Call Trace:
Dec 6 22:55:47 tm-spes-md102 kernel: [<ffffffffa0251b68>]
xfs_vm_releasepage+0x50/0xa5 [xfs]
Dec 6 22:55:47 tm-spes-md102 kernel: [<ffffffff8028bf57>]
__invalidate_mapping_pages+0x98/0x12d
Dec 6 22:55:47 tm-spes-md102 kernel: [<ffffffff802c4ca1>]
prune_icache+0xe7/0x1f7
Dec 6 22:55:47 tm-spes-md102 kernel: [<ffffffff802c4dc6>]
shrink_icache_memory+0x15/0x32
Dec 6 22:55:47 tm-spes-md102 kernel: [<ffffffff8028dc59>]
shrink_slab+0xe4/0x157
Dec 6 22:55:47 tm-spes-md102 kernel: [<ffffffff8028e173>]
balance_pgdat+0x292/0x3d6
Dec 6 22:55:53 tm-spes-md102 kernel: [<ffffffff8028e3e1>] kswapd+0x12a/0x12c

Dec 6 22:55:53 tm-spes-md102 kernel: [<ffffffff8024fb2f>] kthread+0x47/0x73
Dec 6 22:55:53 tm-spes-md102 kernel: [<ffffffff8020cfb9>] child_rip+0xa/0x11

Dec 6 22:55:53 tm-spes-md102 kernel:
Dec 6 22:55:53 tm-spes-md102 kernel:
Dec 6 22:55:53 tm-spes-md102 kernel: Code: 1f eb ef 90 90 90 c7 01 00 00 00
00 c7 02 00 00 00 00 c7 06 00 00 00 00 48 8b 07 f6 c4 10 75
04 0f 0b eb fe 48 8b 47 10 49 89 c1 <4d> 8b 01 41 f6 c0 01 74 0e 41 f6 c0 20
75 08 c7 02 01 00 00 00
Dec 6 22:55:53 tm-spes-md102 kernel: RIP [<ffffffffa0250659>]
xfs_count_page_state+0x25/0x66 [xfs]
Dec 6 22:55:53 tm-spes-md102 kernel: RSP <ffff88037cdcbbe8>
Dec 6 22:55:53 tm-spes-md102 kernel: CR2: 0000000000000000

__
Tharindu *R* Bamunuarachchi.

--000325576092b36b900496d18bf6
Content-Type: text/html; charset=UTF-8

Dear All,<br><br>We got following oops in one of our SLES 11 server. This occurred inside swapd and we running our server swap turned off..<br><br>Could this be memory corruption or possible old bug in code ?<br><br>Please help.<br>

Thanks<br><br>Dec 6 22:55:46 tm-spes-md102 kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
<br>Dec 6 22:55:46 tm-spes-md102 kernel: IP: [&lt;ffffffffa0250659&gt;] xfs_count_page_state+0x25/0x66 [xfs]
<br>Dec 6 22:55:46 tm-spes-md102 kernel: PGD 37dc4e067 PUD 16f631067 PMD 0
<br>Dec 6 22:55:46 tm-spes-md102 kernel: Oops: 0000 [1] SMP
<br>Dec 6 22:55:46 tm-spes-md102 kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:15:00.0/infiniband/mlx4_0/node_type
<br>Dec 6 22:55:46 tm-spes-md102 kernel: CPU 2
<br>Dec 6 22:55:46 tm-spes-md102 kernel: Modules linked in: af_packet st ide_disk ide_cd_mod lp parport_pc ppdev parport nfs lockd nfs_acl
<br>sunrpc ipmi_devintf ipmi_si ipmi_msghandler bonding microcode binfmt_misc rdma_ucm(N) ib_sdp(N) rdma_cm(N) iw_cm(N) ib_addr(N) ib_ipoib(
<br>N) ib_cm(N) ib_sa(N) ipv6 ib_uverbs(N) ib_umad(N) mlx4_en(N) mlx4_ib(N) ib_mthca(N) ib_mad(N) ib_core(N) fuse ext2 xfs loop dm_mod joyde
<br>v cdc_ether rtc_cmos usbhid usbnet rtc_core mlx4_core(N) hid shpchp i2c_i801 pci_hotplug button pcspkr mii sr_mod i2c_core rtc_lib ff_me
<br>mless cdrom sg uhci_hcd sd_mod ehci_hcd crc_t10dif usbcore edd ext3 mbcache jbd fan thermal processor thermal_sys hwmon ide_pci_generic
<br>ide_core ata_generic ata_piix libata dock megaraid_sas scsi_mod [last unloaded: parport_pc]
<br>Dec 6 22:55:46 tm-spes-md102 kernel: Supported: No, Unsupported modules are loaded
<br>Dec 6 22:55:46 tm-spes-md102 kernel: Pid: 58, comm: kswapd0 Tainted: G 2.6.27.45-0.1-default #1
<br>Dec 6 22:55:46 tm-spes-md102 kernel: RIP: 0010:[&lt;ffffffffa0250659&gt;] [&lt;ffffffffa0250659&gt;] xfs_count_page_state+0x25/0x66 [xfs]
<br>Dec 6 22:55:46 tm-spes-md102 kernel: RSP: 0018:ffff88037cdcbbe8 EFLAGS: 00010207
<br>Dec 6 22:55:46 tm-spes-md102 kernel: RAX: ffff88038ceff610 RBX: ffffe20012c30b40 RCX: ffff88037cdcbc34
<br>Dec 6 22:55:46 tm-spes-md102 kernel: RDX: ffff88037cdcbc38 RSI: ffff88037cdcbc3c RDI: ffffe20012c30b40
<br>Dec 6 22:55:46 tm-spes-md102 kernel: RBP: 0000000000000000 R08: 0000000000000021 R09: 0000000000000000
<br>Dec 6 22:55:46 tm-spes-md102 kernel: R10: ffff88038ceff678 R11: ffffffffa0251b18 R12: ffff880517690480
<br>Dec 6 22:55:46 tm-spes-md102 kernel: R13: ffff88037cdcbce0 R14: 00000000002548c2 R15: ffff880517690590
<br>Dec 6 22:55:46 tm-spes-md102 kernel: FS: 0000000000000000(0000) GS:ffff88037e520e40(0000) knlGS:0000000000000000
<br>Dec 6 22:55:46 tm-spes-md102 kernel: CS: 0010 DS: 0018 ES: 0018 CR0: 000000008005003b
<br>Dec 6 22:55:46 tm-spes-md102 kernel: CR2: 0000000000000000 CR3: 000000016f670000 CR4: 00000000000006e0
<br>Dec 6 22:55:46 tm-spes-md102 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<br>Dec 6 22:55:46 tm-spes-md102 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<br>Dec 6 22:55:46 tm-spes-md102 kernel: Process kswapd0 (pid: 58, threadinfo ffff88037cdca000, task ffff88037cdc8780)
<br>Dec 6 22:55:47 tm-spes-md102 kernel: Stack: ffffffffa0251b68 0000000000000000 0000000000000001 0000000000000000
<br>Dec 6 22:55:47 tm-spes-md102 kernel: 0000000000000001 0000000000000000 0000000000000000 0000000000000000
<br>Dec 6 22:55:47 tm-spes-md102 kernel: 0000000000000000 00000000002acfa4 0000000000000000 ffffe20012c30b40
<br>Dec 6 22:55:47 tm-spes-md102 kernel: Call Trace:
<br>Dec 6 22:55:47 tm-spes-md102 kernel: [&lt;ffffffffa0251b68&gt;] xfs_vm_releasepage+0x50/0xa5 [xfs]
<br>Dec 6 22:55:47 tm-spes-md102 kernel: [&lt;ffffffff8028bf57&gt;] __invalidate_mapping_pages+0x98/0x12d
<br>Dec 6 22:55:47 tm-spes-md102 kernel: [&lt;ffffffff802c4ca1&gt;] prune_icache+0xe7/0x1f7
<br>Dec 6 22:55:47 tm-spes-md102 kernel: [&lt;ffffffff802c4dc6&gt;] shrink_icache_memory+0x15/0x32
<br>Dec 6 22:55:47 tm-spes-md102 kernel: [&lt;ffffffff8028dc59&gt;] shrink_slab+0xe4/0x157
<br>Dec 6 22:55:47 tm-spes-md102 kernel: [&lt;ffffffff8028e173&gt;] balance_pgdat+0x292/0x3d6
<br>Dec 6 22:55:53 tm-spes-md102 kernel: [&lt;ffffffff8028e3e1&gt;] kswapd+0x12a/0x12c
<br>Dec 6 22:55:53 tm-spes-md102 kernel: [&lt;ffffffff8024fb2f&gt;] kthread+0x47/0x73
<br>Dec 6 22:55:53 tm-spes-md102 kernel: [&lt;ffffffff8020cfb9&gt;] child_rip+0xa/0x11
<br>Dec 6 22:55:53 tm-spes-md102 kernel:
<br>Dec 6 22:55:53 tm-spes-md102 kernel:
<br>Dec 6 22:55:53 tm-spes-md102 kernel: Code: 1f eb ef 90 90 90 c7 01 00 00 00 00 c7 02 00 00 00 00 c7 06 00 00 00 00 48 8b 07 f6 c4 10 75
<br>04 0f 0b eb fe 48 8b 47 10 49 89 c1 &lt;4d&gt; 8b 01 41 f6 c0 01 74 0e 41 f6 c0 20 75 08 c7 02 01 00 00 00
<br>Dec 6 22:55:53 tm-spes-md102 kernel: RIP [&lt;ffffffffa0250659&gt;] xfs_count_page_state+0x25/0x66 [xfs]
<br>Dec 6 22:55:53 tm-spes-md102 kernel: RSP &lt;ffff88037cdcbbe8&gt;
<br>Dec 6 22:55:53 tm-spes-md102 kernel: CR2: 0000000000000000
<br><br clear="all">__<br>Tharindu <i>R</i> Bamunuarachchi.<br><br>

--000325576092b36b900496d18bf6--


--===============7700997044252950294==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7700997044252950294==--
