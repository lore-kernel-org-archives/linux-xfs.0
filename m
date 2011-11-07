Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7EauHB062068 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 08:36:57 -0600
Received: from mailout-de.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 372211CEB4F3
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 06:36:54 -0800 (PST)
Received: from mailout-de.gmx.net (mailout-de.gmx.net [213.165.64.22]) by
	cuda.sgi.com with SMTP id yH4TfrR9SqsCX1FT for
	<xfs@oss.sgi.com>; Mon, 07 Nov 2011 06:36:54 -0800 (PST)
Message-ID: <1320676611.3192.36.camel@AlfLaptop>
Subject: Crash with XFS
From: Alexander Naumann <alexandernaumann@gmx.de>
Date: Mon, 07 Nov 2011 15:36:51 +0100
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0377321821474700515=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0377321821474700515==
Content-Type: multipart/alternative; boundary="=-BD+yAaNRJCDVYep6RroT"


--=-BD+yAaNRJCDVYep6RroT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi!

I would be glad if anybody can give me any hint on the following
subject.
I have a linux server running formatted with XFS. Afer a couple of days
(about 6 or 7) I get the following crash:


Nov  6 15:44:03 archive kernel: BUG: unable to handle kernel NULL
pointer dereference at 0000000000000044
Nov  6 15:44:03 archive kernel: IP: [<ffffffff811d3248>]
xfs_inode_ag_iterator+0x4a/0xce
Nov  6 15:44:03 archive kernel: PGD 0
Nov  6 15:44:03 archive kernel: Oops: 0000 [#1] SMP
Nov  6 15:44:03 archive kernel: last sysfs
file: /sys/devices/pci0000:00/0000:00:1c.0/0000:08:00.1/host2/rport-2:0-0/target2:0:0/fc_transport/target2:0:0/port_name
Nov  6 15:44:03 archive kernel: CPU 13
Nov  6 15:44:03 archive kernel: Modules linked in: iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi wcte11xp wctc4xxp wct4xxp
wct1xxp wcte12xp dahdi_voicebus dahdi_transcode dahdi dm_round_robin
qla2xxx scsi_dh_rdac scsi_dh_emc scsi_
dh_alua scsi_dh_hp_sw af_packet ipt_REDIRECT iptable_nat nf_nat
ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state
nf_conntrack iptable_filter ip_tables x_tables ipmi_si ipmi_watchdog
ipmi_devintf ipmi_msghandler fan ac ipv6
fuse dm_multipath scsi_dh psmouse usbhid hid evdev ehci_hcd uhci_hcd
iTCO_wdt rtc_cmos pcspkr serio_raw iTCO_vendor_support usbcore thermal
bnx2 rtc_core rtc_lib button processor thermal_sys unix
Nov  6 15:44:03 archive kernel:
Nov  6 15:44:03 archive kernel: Pid: 659, comm: kswapd0 Not tainted
2.6.34.7-64bit #9 0P658H/PowerEdge R910
Nov  6 15:44:03 archive kernel: RIP: 0010:[<ffffffff811d3248>]
[<ffffffff811d3248>] xfs_inode_ag_iterator+0x4a/0xce
Nov  6 15:44:03 archive kernel: RSP: 0018:ffff88085eb1bcb0  EFLAGS:
00010282
Nov  6 15:44:03 archive kernel: RAX: 0000000000000000 RBX:
ffff88085841b800 RCX: 0000000000000000
Nov  6 15:44:03 archive kernel: RDX: 0000000000000001 RSI:
0000000000000000 RDI: 0000000000000000
Nov  6 15:44:03 archive kernel: RBP: ffff88085eb1bd10 R08:
0000000000000001 R09: ffff88085eb1bd24
Nov  6 15:44:03 archive kernel: R10: ffffffffff000000 R11:
ffff88047d42b0e8 R12: ffff88085eb1bd24
Nov  6 15:44:03 archive kernel: R13: 0000000000000000 R14:
ffff88085eb1bd24 R15: 0000000000000000
Nov  6 15:44:03 archive kernel: FS:  0000000000000000(0000)
GS:ffff8800023a0000(0000) knlGS:0000000000000000
Nov  6 15:44:03 archive kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Nov  6 15:44:03 archive kernel: CR2: 0000000000000044 CR3:
00000000016cb000 CR4: 00000000000006a0
Nov  6 15:44:03 archive kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Nov  6 15:44:03 archive kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Nov  6 15:44:03 archive kernel: Process kswapd0 (pid: 659, threadinfo
ffff88085eb1a000, task ffff88085f4706b0)
Nov  6 15:44:03 archive kernel: Stack:
Nov  6 15:44:03 archive kernel:  ffff88085eb1bce4 000000018102914a
0000000000000000 ffffffff811d268f
Nov  6 15:44:03 archive kernel: <0> ffff88085841b800 0000000000000000
0000005500000283 ffff88085841b800
Nov  6 15:44:03 archive kernel: <0> ffff88085eb1bd24 00000000ffffffff
00000000000002bc 00000000000000d0
Nov  6 15:44:03 archive kernel: Call Trace:
Nov  6 15:44:03 archive kernel:  [<ffffffff811d268f>] ?
xfs_reclaim_inode+0x0/0x212
Nov  6 15:44:03 archive kernel:  [<ffffffff811d332d>]
xfs_reclaim_inode_shrink+0x61/0x123
Nov  6 15:44:03 archive kernel:  [<ffffffff81075f45>] shrink_slab
+0xd8/0x148
Nov  6 15:44:03 archive kernel:  [<ffffffff810765da>] kswapd+0x625/0x89d
Nov  6 15:44:03 archive kernel:  [<ffffffff8107445f>] ?
isolate_pages_global+0x0/0x23f
Nov  6 15:44:03 archive kernel:  [<ffffffff81040882>] ?
autoremove_wake_function+0x0/0x38
Nov  6 15:44:03 archive kernel:  [<ffffffff81075fb5>] ? kswapd+0x0/0x89d
Nov  6 15:44:03 archive kernel:  [<ffffffff81040472>] kthread+0x7d/0x85
Nov  6 15:44:03 archive kernel:  [<ffffffff81002c74>]
kernel_thread_helper+0x4/0x10
Nov  6 15:44:03 archive kernel:  [<ffffffff810403f5>] ? kthread+0x0/0x85
Nov  6 15:44:03 archive kernel:  [<ffffffff81002c70>] ?
kernel_thread_helper+0x0/0x10
Nov  6 15:44:03 archive kernel: Code: c0 48 89 75 b8 89 55 b4 89 4d b0
44 89 45 ac 74 03 41 8b 01 89 45 d4 45 31 ff 45 31 ed eb 69 48 8b 7d c0
44 89 ee e8 2d d1 fe ff <83> 78 44 00 49 89 c4 75 0a 48 89 c7 e8 ad c2
fe ff eb 47 44 8b
Nov  6 15:44:03 archive kernel: RIP  [<ffffffff811d3248>]
xfs_inode_ag_iterator+0x4a/0xce
Nov  6 15:44:03 archive kernel:  RSP <ffff88085eb1bcb0>
Nov  6 15:44:03 archive kernel: CR2: 0000000000000044
Nov  6 15:44:03 archive kernel: ---[ end trace 3bcf38b06227bae0 ]---


Or like this:
Oct 22 08:30:05 archive kernel: BUG: unable to handle kernel NULL
pointer dereference at 0000000000000044
Oct 22 08:30:05 archive kernel: IP: [<ffffffff811d338f>]
xfs_reclaim_inode_shrink+0xc3/0x123

Oct 22 08:30:05 archive kernel:  [<ffffffff81075f38>] shrink_slab
+0xcb/0x148
Oct 22 08:30:05 archive kernel:  [<ffffffff810765da>] kswapd+0x625/0x89d
Oct 22 08:30:05 archive kernel:  [<ffffffff8107445f>] ?
isolate_pages_global+0x0/0x23f
Oct 22 08:30:05 archive kernel:  [<ffffffff81040882>] ?
autoremove_wake_function+0x0/0x38
Oct 22 08:30:05 archive kernel:  [<ffffffff81075fb5>] ? kswapd+0x0/0x89d
Oct 22 08:30:05 archive kernel:  [<ffffffff81040472>] kthread+0x7d/0x85
Oct 22 08:30:05 archive kernel:  [<ffffffff81002c74>]
kernel_thread_helper+0x4/0x10
Oct 22 08:30:05 archive kernel:  [<ffffffff810403f5>] ? kthread+0x0/0x85
Oct 22 08:30:05 archive kernel:  [<ffffffff81002c70>] ?
kernel_thread_helper+0x0/0x10

The system is a Dell R910 (Intek Xeon CPU E7530, 24 cores (with
hyperthreading).
32GB Ram, Raid Controller is Perc H700, SAS discs, Raid 5 with 1.7TB,
formatted with XFS.
Kernel version 2.6.34.7 is running (64bit kernel on a 32bit system,
Debian packages).
There is a multipathing fibrechannel conenction to an external storage,
which partition is also formatted with XFS.
xfs-tools are version 3.0.4.
Host 2 is one of the FC connections.

Does anybody has a hint to this crash?
I could not find any solution in any bugtracker so I am not sure if it
is already fixed.

The system itself is under load (Load-Average is about 20 / 18 / 17).

Are any other informations needed?

Local filesystem informations:
xfs_info  /
meta-data=/dev/root              isize=256    agcount=32,
agsize=13683646 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=437876672,
imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0



Thanks in advance
Alex


--=-BD+yAaNRJCDVYep6RroT
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 TRANSITIONAL//EN">
<HTML>
<HEAD>
  <META HTTP-EQUIV="Content-Type" CONTENT="text/html; CHARSET=UTF-8">
  <META NAME="GENERATOR" CONTENT="GtkHTML/4.1.92">
</HEAD>
<BODY>
<TT>Hi!</TT><BR>
<BR>
<TT>I would be glad if anybody can give me any hint on the following subject.</TT><BR>
<TT>I have a linux server running formatted with XFS. Afer a couple of days (about 6 or 7) I get the following crash:</TT><BR>
<BR>
<BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000044</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: IP: [&lt;ffffffff811d3248&gt;] xfs_inode_ag_iterator+0x4a/0xce</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: PGD 0</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: Oops: 0000 [#1] SMP</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:08:00.1/host2/rport-2:0-0/target2:0:0/fc_transport/target2:0:0/port_name</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: CPU 13</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: Modules linked in: iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi wcte11xp wctc4xxp wct4xxp wct1xxp wcte12xp dahdi_voicebus dahdi_transcode dahdi dm_round_robin qla2xxx scsi_dh_rdac scsi_dh_emc scsi_</TT><BR>
<TT>dh_alua scsi_dh_hp_sw af_packet ipt_REDIRECT iptable_nat nf_nat ipt_REJECT xt_tcpudp nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables ipmi_si ipmi_watchdog ipmi_devintf ipmi_msghandler fan ac ipv6</TT><BR>
<TT>fuse dm_multipath scsi_dh psmouse usbhid hid evdev ehci_hcd uhci_hcd iTCO_wdt rtc_cmos pcspkr serio_raw iTCO_vendor_support usbcore thermal bnx2 rtc_core rtc_lib button processor thermal_sys unix</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: Pid: 659, comm: kswapd0 Not tainted 2.6.34.7-64bit #9 0P658H/PowerEdge R910</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: RIP: 0010:[&lt;ffffffff811d3248&gt;]&nbsp; [&lt;ffffffff811d3248&gt;] xfs_inode_ag_iterator+0x4a/0xce</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: RSP: 0018:ffff88085eb1bcb0&nbsp; EFLAGS: 00010282</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: RAX: 0000000000000000 RBX: ffff88085841b800 RCX: 0000000000000000</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: RBP: ffff88085eb1bd10 R08: 0000000000000001 R09: ffff88085eb1bd24</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: R10: ffffffffff000000 R11: ffff88047d42b0e8 R12: ffff88085eb1bd24</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: R13: 0000000000000000 R14: ffff88085eb1bd24 R15: 0000000000000000</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: FS:&nbsp; 0000000000000000(0000) GS:ffff8800023a0000(0000) knlGS:0000000000000000</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: CS:&nbsp; 0010 DS: 0000 ES: 0000 CR0: 000000008005003b</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: CR2: 0000000000000044 CR3: 00000000016cb000 CR4: 00000000000006a0</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: Process kswapd0 (pid: 659, threadinfo ffff88085eb1a000, task ffff88085f4706b0)</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: Stack:</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; ffff88085eb1bce4 000000018102914a 0000000000000000 ffffffff811d268f</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: &lt;0&gt; ffff88085841b800 0000000000000000 0000005500000283 ffff88085841b800</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: &lt;0&gt; ffff88085eb1bd24 00000000ffffffff 00000000000002bc 00000000000000d0</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: Call Trace:</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff811d268f&gt;] ? xfs_reclaim_inode+0x0/0x212</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff811d332d&gt;] xfs_reclaim_inode_shrink+0x61/0x123</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff81075f45&gt;] shrink_slab+0xd8/0x148</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff810765da&gt;] kswapd+0x625/0x89d</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff8107445f&gt;] ? isolate_pages_global+0x0/0x23f</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff81040882&gt;] ? autoremove_wake_function+0x0/0x38</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff81075fb5&gt;] ? kswapd+0x0/0x89d</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff81040472&gt;] kthread+0x7d/0x85</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff81002c74&gt;] kernel_thread_helper+0x4/0x10</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff810403f5&gt;] ? kthread+0x0/0x85</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; [&lt;ffffffff81002c70&gt;] ? kernel_thread_helper+0x0/0x10</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: Code: c0 48 89 75 b8 89 55 b4 89 4d b0 44 89 45 ac 74 03 41 8b 01 89 45 d4 45 31 ff 45 31 ed eb 69 48 8b 7d c0 44 89 ee e8 2d d1 fe ff &lt;83&gt; 78 44 00 49 89 c4 75 0a 48 89 c7 e8 ad c2 fe ff eb 47 44 8b</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: RIP&nbsp; [&lt;ffffffff811d3248&gt;] xfs_inode_ag_iterator+0x4a/0xce</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel:&nbsp; RSP &lt;ffff88085eb1bcb0&gt;</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: CR2: 0000000000000044</TT><BR>
<TT>Nov&nbsp; 6 15:44:03 archive kernel: ---[ end trace 3bcf38b06227bae0 ]---</TT><BR>
<BR>
<BR>
<TT>Or like this:</TT><BR>
<TT>Oct 22 08:30:05 archive kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000044</TT><BR>
<TT>Oct 22 08:30:05 archive kernel: IP: [&lt;ffffffff811d338f&gt;] xfs_reclaim_inode_shrink+0xc3/0x123</TT><BR>
<BR>
<TT>Oct 22 08:30:05 archive kernel:&nbsp; [&lt;ffffffff81075f38&gt;] shrink_slab+0xcb/0x148</TT><BR>
<TT>Oct 22 08:30:05 archive kernel:&nbsp; [&lt;ffffffff810765da&gt;] kswapd+0x625/0x89d</TT><BR>
<TT>Oct 22 08:30:05 archive kernel:&nbsp; [&lt;ffffffff8107445f&gt;] ? isolate_pages_global+0x0/0x23f</TT><BR>
<TT>Oct 22 08:30:05 archive kernel:&nbsp; [&lt;ffffffff81040882&gt;] ? autoremove_wake_function+0x0/0x38</TT><BR>
<TT>Oct 22 08:30:05 archive kernel:&nbsp; [&lt;ffffffff81075fb5&gt;] ? kswapd+0x0/0x89d</TT><BR>
<TT>Oct 22 08:30:05 archive kernel:&nbsp; [&lt;ffffffff81040472&gt;] kthread+0x7d/0x85</TT><BR>
<TT>Oct 22 08:30:05 archive kernel:&nbsp; [&lt;ffffffff81002c74&gt;] kernel_thread_helper+0x4/0x10</TT><BR>
<TT>Oct 22 08:30:05 archive kernel:&nbsp; [&lt;ffffffff810403f5&gt;] ? kthread+0x0/0x85</TT><BR>
<TT>Oct 22 08:30:05 archive kernel:&nbsp; [&lt;ffffffff81002c70&gt;] ? kernel_thread_helper+0x0/0x10</TT><BR>
<BR>
<TT>The system is a Dell R910 (Intek Xeon CPU E7530, 24 cores (with hyperthreading).</TT><BR>
<TT>32GB Ram, Raid Controller is Perc H700, SAS discs, Raid 5 with 1.7TB, formatted with XFS.</TT><BR>
<TT>Kernel version 2.6.34.7 is running (64bit kernel on a 32bit system, Debian packages).</TT><BR>
<TT>There is a multipathing fibrechannel conenction to an external storage, which partition is also formatted with XFS.</TT><BR>
<TT>xfs-tools are version 3.0.4.</TT><BR>
<TT>Host 2 is one of the FC connections.</TT><BR>
<BR>
<TT>Does anybody has a hint to this crash?</TT><BR>
<TT>I could not find any solution in any bugtracker so I am not sure if it is already fixed.</TT><BR>
<BR>
<TT>The system itself is under load (Load-Average is about 20 / 18 / 17).</TT><BR>
<BR>
<TT>Are any other informations needed?</TT><BR>
<BR>
<TT>Local filesystem informations:</TT><BR>
<TT>xfs_info&nbsp; /</TT><BR>
<TT>meta-data=/dev/root&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; isize=256&nbsp;&nbsp;&nbsp; agcount=32, agsize=13683646 blks</TT><BR>
<TT>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; attr=0</TT><BR>
<TT>data&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=437876672, imaxpct=25</TT><BR>
<TT>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sunit=0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; swidth=0 blks</TT><BR>
<TT>naming&nbsp;&nbsp; =version 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; ascii-ci=0</TT><BR>
<TT>log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =internal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=4096&nbsp;&nbsp; blocks=32768, version=1</TT><BR>
<TT>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=512&nbsp;&nbsp; sunit=0 blks, lazy-count=0</TT><BR>
<TT>realtime =none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; extsz=65536&nbsp; blocks=0, rtextents=0</TT><BR>
<BR>
<BR>
<BR>
<TT>Thanks in advance</TT><BR>
<TT>Alex</TT><BR>
<BR>
</BODY>
</HTML>

--=-BD+yAaNRJCDVYep6RroT--


--===============0377321821474700515==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0377321821474700515==--
