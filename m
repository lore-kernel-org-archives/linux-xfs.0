Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4CFD87F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 05:58:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B1758F8037
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 03:58:00 -0700 (PDT)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id pCRDDYCV6X5XteVn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jul 2015 03:57:56 -0700 (PDT)
Received: by wgjx7 with SMTP id x7so219913173wgj.2
	for <xfs@oss.sgi.com>; Thu, 09 Jul 2015 03:57:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5582DCDA.9070200@sandeen.net>
References: <CA++_uht_4ON49eBqM6eA7oL7iBcxYMwR5ZAQxXmTuNji2XiyBA@mail.gmail.com>
	<20150618133122.GC43254@bfoster.bfoster>
	<CA++_uhuLbTT32v4ZeVkP3WOjBEeMU0O1NZDcv66a67hZ=pj9Sw@mail.gmail.com>
	<5582DCDA.9070200@sandeen.net>
Date: Thu, 9 Jul 2015 18:57:55 +0800
Message-ID: <CA++_uhuFL0DhwH3ENBHmFmzmBm5SGx45P9tqVTEdj-bCsHBSVA@mail.gmail.com>
Subject: Re: Data can't be wrote to XFS RIP [<ffffffffa041a99a>]
	xfs_dir2_sf_get_parent_ino+0xa/0x20
From: Kuo Hugo <tonytkdk@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2550812957980441113=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Hugo Kuo <hugo@swiftstack.com>, Brian Foster <bfoster@redhat.com>, darrell@swiftstack.com, xfs@oss.sgi.com

--===============2550812957980441113==
Content-Type: multipart/alternative; boundary=047d7bfcf2f6b039a0051a6f2092

--047d7bfcf2f6b039a0051a6f2092
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Folks,

As the results of 32 disks with xfs_repair -n seems no any error shows up.
We currently tried to deploy CentOS 6.6 for testing. (The previous kernel
panic was came from Ubuntu).
The CentOS nodes encountered kernel panic with same daemon but the problem
may a bit differ.

   - It was broken on xfs_dir2_sf_get_parent_ino+0xa/0x20 in Ubuntu.
   - Here=E2=80=99s the log in CentOS. It=E2=80=99s broken on
   xfs_dir2_sf_getdents+0x2a0/0x3a0

<1>BUG: unable to handle kernel NULL pointer dereference at 000000000000000=
1
<1>IP: [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
<4>PGD 1072327067 PUD 1072328067 PMD 0
<4>Oops: 0000 [#1] SMP
<4>last sysfs file:
/sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:1/expander=
-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/block/sdz/que=
ue/rotational
<4>CPU 17
<4>Modules linked in: xt_conntrack tun xfs exportfs iptable_filter
ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 ip_tables ip_vs ipv6 libcrc32c iTCO_wdt
iTCO_vendor_support ses enclosure igb i2c_algo_bit sb_edac edac_core
i2c_i801 i2c_core sg shpchp lpc_ich mfd_core ixgbe dca ptp pps_core
mdio power_meter acpi_ipmi ipmi_si ipmi_msghandler ext4 jbd2 mbcache
sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_class xhci_hcd ahci
wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
scsi_wait_scan]
<4>
<4>Pid: 4454, comm: swift-object-se Not tainted
2.6.32-504.23.4.el6.x86_64 #1 Silicon Mechanics Storform
R518.v5P/X10DRi-T4+
<4>RIP: 0010:[<ffffffffa0362d60>]  [<ffffffffa0362d60>]
xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
<4>RSP: 0018:ffff880871f6de18  EFLAGS: 00010202
<4>RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
<4>RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007faa74006203
<4>RBP: ffff880871f6de68 R08: 000000032eb04bc9 R09: 0000000000000004
<4>R10: 0000000000008030 R11: 0000000000000246 R12: 0000000000000000
<4>R13: 0000000000000002 R14: ffff88106eff7000 R15: ffff8808715b4580
<4>FS:  00007faa85425700(0000) GS:ffff880028360000(0000) knlGS:000000000000=
0000
<4>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>CR2: 0000000000000001 CR3: 0000001072325000 CR4: 00000000001407e0
<4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
<4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
<4>Process swift-object-se (pid: 4454, threadinfo ffff880871f6c000,
task ffff880860f18ab0)
<4>Stack:
<4> ffff880871f6de28 ffffffff811a4bb0 ffff880871f6df38 ffff880874749cc0
<4><d> 0000000100000103 ffff8802381f8c00 ffff880871f6df38 ffff8808715b4580
<4><d> 0000000000000082 ffff8802381f8d88 ffff880871f6dec8 ffffffffa035ab31
<4>Call Trace:
<4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
<4> [<ffffffffa035ab31>] xfs_readdir+0xe1/0x130 [xfs]
<4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
<4> [<ffffffffa038fe29>] xfs_file_readdir+0x39/0x50 [xfs]
<4> [<ffffffff811a4e30>] vfs_readdir+0xc0/0xe0
<4> [<ffffffff8119bd86>] ? final_putname+0x26/0x50
<4> [<ffffffff811a4fb9>] sys_getdents+0x89/0xf0
<4> [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
<4>Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48 8b 7d c0 ff 55 b8 85 c0
0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f 84 00 00 00 00 00
<41> 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f b6 44 24 03 41 0f b6
<1>RIP  [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
<4> RSP <ffff880871f6de18>
<4>CR2: 0000000000000001

PID: 4454   TASK: ffff880860f18ab0  CPU: 17  COMMAND: "swift-object-se"
ROOT: /    CWD: /
 FD       FILE            DENTRY           INODE       TYPE PATH
  0 ffff881073604900 ffff8810749a9440 ffff8808740b9728 CHR  /dev/null
  1 ffff881073604900 ffff8810749a9440 ffff8808740b9728 CHR  /dev/null
  2 ffff881073604900 ffff8810749a9440 ffff8808740b9728 CHR  /dev/null
  3 ffff881074222840 ffff88106e184980 ffff88106e16cd48 SOCK
  4 ffff881072952c00 ffff88106e1848c0 ffff8810711cca08 SOCK
  5 ffff88087154b2c0 ffff88044f0f1780 ffff880018e51a08 SOCK
  6 ffff8810716f2600 ffff88107122d5c0 ffff881071315cb8 REG  /tmp/ffi1ECJ8Z
  7 ffff88086bd0a6c0 ffff88086fc4b840 ffff88086fc4a100 REG  /tmp/ffiIArHUO
  8 ffff88106f516ec0 ffff881067d9ae00 ffff8808745aa5e8 REG  [eventpoll]
  9 ffff88106ed35b40 ffff88106e15b200 ffff88106e201cc8 SOCK
 10 ffff88106f31ae00 ffff881074ad75c0 ffff88106e169a08 SOCK
 11 ffff88106ede2740 ffff881067f9a8c0 ffff8808745aa5e8 REG  [eventpoll]
 12 ffff880122e8bc80 ffff8808745a8240 ffff881074379d48 CHR  /dev/urandom
 13 ffff88087162e200 ffff88086fd87200 ffff88086fe82748 SOCK
 14 ffff88087135e840 ffff88086fc653c0 ffff88086fe82488 SOCK
 15 ffff88106f36f900 ffff88106e263680 ffff8808745aa5e8 REG  [eventpoll]
 16 ffff8810737f8680 ffff88106e3e9c80 ffff8808745aa5e8 REG  [eventpoll]
 17 ffff881073635540 ffff88106e1f9240 ffff8808745aa5e8 REG  [eventpoll]
 18 ffff88106ef5ba40 ffff88105bb6b080 ffff8808745aa5e8 REG  [eventpoll]
 19 ffff881074222300 ffff88105b975300 ffff8808745aa5e8 REG  [eventpoll]
 20 ffff881073770f00 ffff881013478080 ffff8808745aa5e8 REG  [eventpoll]
 21 ffff8810737f8bc0 ffff88106e3e9500 ffff8808745aa5e8 REG  [eventpoll]
 22 ffff88106ef5bc80 ffff88105bb72e00 ffff8808745aa5e8 REG  [eventpoll]
 23 ffff88106ef25e00 ffff88106e3e9bc0 ffff8808745aa5e8 REG  [eventpoll]
 24 ffff881071950d80 ffff8810383ee980 ffff8808745aa5e8 REG  [eventpoll]
 25 ffff88106ecca600 ffff881067d96840 ffff8808745aa5e8 REG  [eventpoll]
 26 ffff8808737ec740 ffff880855d95cc0 ffff8808745aa5e8 REG  [eventpoll]
 27 ffff88107345d3c0 ffff880fc46160c0 ffff8808745aa5e8 REG  [eventpoll]
 28 ffff88086bf2d600 ffff880777987b00 ffff880159ac0448 SOCK
 29 ffff8808737e9240 ffff880855c80a40 ffff8808745aa5e8 REG  [eventpoll]
 30 ffff88106f5e0140 ffff880ff5752440 ffff8808745aa5e8 REG  [eventpoll]
 31 ffff8808703a19c0 ffff8807847c8e40 ffff8808745aa5e8 REG  [eventpoll]
 32 ffff88086bd738c0 ffff88033be10800 ffff8806b47f2c08 SOCK
 33 ffff88087119eb40 ffff8806916b48c0 ffff8804cd27e648 SOCK
 34 ffff880870aed480 ffff8806b3fc4900 ffff880015583588 REG
/srv/node/d199/objects/12860/2c0/323cc020fd7dbd6c12472cd1c10742c0/143626603=
6.98015.ts
 35 ffff88106eeb0e00 ffff88101347de40 ffff8808745aa5e8 REG  [eventpoll]
 36 ffff8808703ed6c0 ffff88086fd65540 ffff8805eb03ed88 REG
/srv/node/d205/quarantined/objects/cd1d68f515006d443a54ff4f658091bc-a114bba=
1449b45238abf38dc741d7c27/1436254020.89801.ts
 37 ffff8810718343c0 ffff88105b9d32c0 ffff8808745aa5e8 REG  [eventpoll]
 38 ffff8808713da780 ffff880010c9a900 ffff88096368a188 REG
/srv/node/d224/quarantined/objects/b146865bf8034bfc42570b747c341b32/1436266=
042.57775.ts
 39 ffff880871cb03c0 ffff880495a8b380 ffff8808a5e6c988 REG
/srv/node/d224/tmp/tmpSpnrHg
 40 ffff8808715b4540 ffff8804819c58c0 ffff8802381f8d88 DIR
/srv/node/d224/quarantined/objects/b146865bf8034bfc42570b747c341b32
 41 ffff880871fce240 ffff880951136c00 ffff880bacf63d88 DIR
/srv/node/d199/objects/12860/2c0/323cc020fd7dbd6c12472cd1c10742c0

I=E2=80=99ve got the vmcore dump from operator. Does vmcore help for
troubleshooting kind issue ?

Thanks // Hugo
=E2=80=8B

2015-06-18 22:59 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>:

> On 6/18/15 9:29 AM, Kuo Hugo wrote:
> >>- Have you tried an 'xfs_repair -n' of the affected filesystem? Note
> that -n will report problems only and prevent any modification by repair.
> >
> > *We might to to xfs_repair if we can address which disk causes the
> issue. *
>
> If you do, please save the output, and if it finds anything, please
> provide the output in this thread.
>
> Thanks,
> -Eric
>

--047d7bfcf2f6b039a0051a6f2092
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"markdown-here-wrapper" style=3D""><p style=
=3D"margin:0px 0px 1.2em!important">Hi Folks, </p>
<p style=3D"margin:0px 0px 1.2em!important">As the results of 32 disks with=
 <code style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,m=
onospace;margin:0px 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1p=
x solid rgb(234,234,234);border-radius:3px;display:inline;background-color:=
rgb(248,248,248)">xfs_repair -n</code> seems no any error shows up.<br>We c=
urrently tried to deploy CentOS 6.6 for testing. (The previous kernel panic=
 was came from Ubuntu).<br>The CentOS nodes encountered kernel panic with s=
ame daemon but the problem may a bit differ. </p>
<ul style=3D"margin:1.2em 0px;padding-left:2em">
<li style=3D"margin:0.5em 0px">It was broken on <code style=3D"font-size:0.=
85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px 0.15em;p=
adding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234,234);bor=
der-radius:3px;display:inline;background-color:rgb(248,248,248)">xfs_dir2_s=
f_get_parent_ino+0xa/0x20</code> in Ubuntu. </li>
<li style=3D"margin:0.5em 0px">Here=E2=80=99s the log in CentOS. It=E2=80=
=99s broken on <code style=3D"font-size:0.85em;font-family:Consolas,Inconso=
lata,Courier,monospace;margin:0px 0.15em;padding:0px 0.3em;white-space:pre-=
wrap;border:1px solid rgb(234,234,234);border-radius:3px;display:inline;bac=
kground-color:rgb(248,248,248)">xfs_dir2_sf_getdents+0x2a0/0x3a0</code></li=
>
</ul>
<pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mon=
ospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"fon=
t-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px=
 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234=
,234);border-radius:3px;display:inline;background-color:rgb(248,248,248);wh=
ite-space:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,=
204);padding:0.5em 0.7em;display:block!important">&lt;1&gt;BUG: unable to h=
andle kernel NULL pointer dereference at 0000000000000001
&lt;1&gt;IP: [&lt;ffffffffa0362d60&gt;] xfs_dir2_sf_getdents+0x2a0/0x3a0 [x=
fs]
&lt;4&gt;PGD 1072327067 PUD 1072328067 PMD 0
&lt;4&gt;Oops: 0000 [#1] SMP
&lt;4&gt;last sysfs file: /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0=
/host10/port-10:1/expander-10:1/port-10:1:16/end_device-10:1:16/target10:0:=
25/10:0:25:0/block/sdz/queue/rotational
&lt;4&gt;CPU 17
&lt;4&gt;Modules linked in: xt_conntrack tun xfs exportfs iptable_filter ip=
t_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4=
 ip_tables ip_vs ipv6 libcrc32c iTCO_wdt iTCO_vendor_support ses enclosure =
igb i2c_algo_bit sb_edac edac_core i2c_i801 i2c_core sg shpchp lpc_ich mfd_=
core ixgbe dca ptp pps_core mdio power_meter acpi_ipmi ipmi_si ipmi_msghand=
ler ext4 jbd2 mbcache sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_cla=
ss xhci_hcd ahci wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:=
 scsi_wait_scan]
&lt;4&gt;
&lt;4&gt;Pid: 4454, comm: swift-object-se Not tainted 2.6.32-504.23.4.el6.x=
86_64 #1 Silicon Mechanics Storform R518.v5P/X10DRi-T4+
&lt;4&gt;RIP: 0010:[&lt;ffffffffa0362d60&gt;]  [&lt;ffffffffa0362d60&gt;] x=
fs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
&lt;4&gt;RSP: 0018:ffff880871f6de18  EFLAGS: 00010202
&lt;4&gt;RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
&lt;4&gt;RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007faa74006203
&lt;4&gt;RBP: ffff880871f6de68 R08: 000000032eb04bc9 R09: 0000000000000004
&lt;4&gt;R10: 0000000000008030 R11: 0000000000000246 R12: 0000000000000000
&lt;4&gt;R13: 0000000000000002 R14: ffff88106eff7000 R15: ffff8808715b4580
&lt;4&gt;FS:  00007faa85425700(0000) GS:ffff880028360000(0000) knlGS:000000=
0000000000
&lt;4&gt;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
&lt;4&gt;CR2: 0000000000000001 CR3: 0000001072325000 CR4: 00000000001407e0
&lt;4&gt;DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
&lt;4&gt;DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
&lt;4&gt;Process swift-object-se (pid: 4454, threadinfo ffff880871f6c000, t=
ask ffff880860f18ab0)
&lt;4&gt;Stack:
&lt;4&gt; ffff880871f6de28 ffffffff811a4bb0 ffff880871f6df38 ffff880874749c=
c0
&lt;4&gt;&lt;d&gt; 0000000100000103 ffff8802381f8c00 ffff880871f6df38 ffff8=
808715b4580
&lt;4&gt;&lt;d&gt; 0000000000000082 ffff8802381f8d88 ffff880871f6dec8 fffff=
fffa035ab31
&lt;4&gt;Call Trace:
&lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? filldir+0x0/0xe0
&lt;4&gt; [&lt;ffffffffa035ab31&gt;] xfs_readdir+0xe1/0x130 [xfs]
&lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? filldir+0x0/0xe0
&lt;4&gt; [&lt;ffffffffa038fe29&gt;] xfs_file_readdir+0x39/0x50 [xfs]
&lt;4&gt; [&lt;ffffffff811a4e30&gt;] vfs_readdir+0xc0/0xe0
&lt;4&gt; [&lt;ffffffff8119bd86&gt;] ? final_putname+0x26/0x50
&lt;4&gt; [&lt;ffffffff811a4fb9&gt;] sys_getdents+0x89/0xf0
&lt;4&gt; [&lt;ffffffff8100b0f2&gt;] system_call_fastpath+0x16/0x1b
&lt;4&gt;Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48 8b 7d c0 ff 55 b8 85 c0 =
0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f 84 00 00 00 00 00 &lt;41=
&gt; 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f b6 44 24 03 41 0f b6
&lt;1&gt;RIP  [&lt;ffffffffa0362d60&gt;] xfs_dir2_sf_getdents+0x2a0/0x3a0 [=
xfs]
&lt;4&gt; RSP &lt;ffff880871f6de18&gt;
&lt;4&gt;CR2: 0000000000000001
</code></pre><pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolat=
a,Courier,monospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code=
 style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospa=
ce;margin:0px 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px soli=
d rgb(234,234,234);border-radius:3px;display:inline;background-color:rgb(24=
8,248,248);white-space:pre;overflow:auto;border-radius:3px;border:1px solid=
 rgb(204,204,204);padding:0.5em 0.7em;display:block!important">PID: 4454   =
TASK: ffff880860f18ab0  CPU: 17  COMMAND: &quot;swift-object-se&quot;
ROOT: /    CWD: /
 FD       FILE            DENTRY           INODE       TYPE PATH
  0 ffff881073604900 ffff8810749a9440 ffff8808740b9728 CHR  /dev/null
  1 ffff881073604900 ffff8810749a9440 ffff8808740b9728 CHR  /dev/null
  2 ffff881073604900 ffff8810749a9440 ffff8808740b9728 CHR  /dev/null
  3 ffff881074222840 ffff88106e184980 ffff88106e16cd48 SOCK
  4 ffff881072952c00 ffff88106e1848c0 ffff8810711cca08 SOCK
  5 ffff88087154b2c0 ffff88044f0f1780 ffff880018e51a08 SOCK
  6 ffff8810716f2600 ffff88107122d5c0 ffff881071315cb8 REG  /tmp/ffi1ECJ8Z
  7 ffff88086bd0a6c0 ffff88086fc4b840 ffff88086fc4a100 REG  /tmp/ffiIArHUO
  8 ffff88106f516ec0 ffff881067d9ae00 ffff8808745aa5e8 REG  [eventpoll]
  9 ffff88106ed35b40 ffff88106e15b200 ffff88106e201cc8 SOCK
 10 ffff88106f31ae00 ffff881074ad75c0 ffff88106e169a08 SOCK
 11 ffff88106ede2740 ffff881067f9a8c0 ffff8808745aa5e8 REG  [eventpoll]
 12 ffff880122e8bc80 ffff8808745a8240 ffff881074379d48 CHR  /dev/urandom
 13 ffff88087162e200 ffff88086fd87200 ffff88086fe82748 SOCK
 14 ffff88087135e840 ffff88086fc653c0 ffff88086fe82488 SOCK
 15 ffff88106f36f900 ffff88106e263680 ffff8808745aa5e8 REG  [eventpoll]
 16 ffff8810737f8680 ffff88106e3e9c80 ffff8808745aa5e8 REG  [eventpoll]
 17 ffff881073635540 ffff88106e1f9240 ffff8808745aa5e8 REG  [eventpoll]
 18 ffff88106ef5ba40 ffff88105bb6b080 ffff8808745aa5e8 REG  [eventpoll]
 19 ffff881074222300 ffff88105b975300 ffff8808745aa5e8 REG  [eventpoll]
 20 ffff881073770f00 ffff881013478080 ffff8808745aa5e8 REG  [eventpoll]
 21 ffff8810737f8bc0 ffff88106e3e9500 ffff8808745aa5e8 REG  [eventpoll]
 22 ffff88106ef5bc80 ffff88105bb72e00 ffff8808745aa5e8 REG  [eventpoll]
 23 ffff88106ef25e00 ffff88106e3e9bc0 ffff8808745aa5e8 REG  [eventpoll]
 24 ffff881071950d80 ffff8810383ee980 ffff8808745aa5e8 REG  [eventpoll]
 25 ffff88106ecca600 ffff881067d96840 ffff8808745aa5e8 REG  [eventpoll]
 26 ffff8808737ec740 ffff880855d95cc0 ffff8808745aa5e8 REG  [eventpoll]
 27 ffff88107345d3c0 ffff880fc46160c0 ffff8808745aa5e8 REG  [eventpoll]
 28 ffff88086bf2d600 ffff880777987b00 ffff880159ac0448 SOCK
 29 ffff8808737e9240 ffff880855c80a40 ffff8808745aa5e8 REG  [eventpoll]
 30 ffff88106f5e0140 ffff880ff5752440 ffff8808745aa5e8 REG  [eventpoll]
 31 ffff8808703a19c0 ffff8807847c8e40 ffff8808745aa5e8 REG  [eventpoll]
 32 ffff88086bd738c0 ffff88033be10800 ffff8806b47f2c08 SOCK
 33 ffff88087119eb40 ffff8806916b48c0 ffff8804cd27e648 SOCK
 34 ffff880870aed480 ffff8806b3fc4900 ffff880015583588 REG  /srv/node/d199/=
objects/12860/2c0/323cc020fd7dbd6c12472cd1c10742c0/1436266036.98015.ts
 35 ffff88106eeb0e00 ffff88101347de40 ffff8808745aa5e8 REG  [eventpoll]
 36 ffff8808703ed6c0 ffff88086fd65540 ffff8805eb03ed88 REG  /srv/node/d205/=
quarantined/objects/cd1d68f515006d443a54ff4f658091bc-a114bba1449b45238abf38=
dc741d7c27/1436254020.89801.ts
 37 ffff8810718343c0 ffff88105b9d32c0 ffff8808745aa5e8 REG  [eventpoll]
 38 ffff8808713da780 ffff880010c9a900 ffff88096368a188 REG  /srv/node/d224/=
quarantined/objects/b146865bf8034bfc42570b747c341b32/1436266042.57775.ts
 39 ffff880871cb03c0 ffff880495a8b380 ffff8808a5e6c988 REG  /srv/node/d224/=
tmp/tmpSpnrHg
 40 ffff8808715b4540 ffff8804819c58c0 ffff8802381f8d88 DIR  /srv/node/d224/=
quarantined/objects/b146865bf8034bfc42570b747c341b32
 41 ffff880871fce240 ffff880951136c00 ffff880bacf63d88 DIR  /srv/node/d199/=
objects/12860/2c0/323cc020fd7dbd6c12472cd1c10742c0
</code></pre><p style=3D"margin:0px 0px 1.2em!important">I=E2=80=99ve got t=
he vmcore dump from operator. Does vmcore help for troubleshooting kind iss=
ue ? </p>
<p style=3D"margin:0px 0px 1.2em!important">Thanks // Hugo </p>
<div title=3D"MDH:SGkgRm9sa3MswqA8ZGl2Pjxicj48L2Rpdj48ZGl2PkFzIHRoZSByZXN1b=
HRzIG9mIDMyIGRpc2tz
IHdpdGggYHhmc19yZXBhaXIgLW4gYCBzZWVtcyBubyBhbnkgZXJyb3Igc2hvd3MgdXAuJm5ic3A=
7
PC9kaXY+PGRpdj5XZSBjdXJyZW50bHkgdHJpZWQgdG8gZGVwbG95IENlbnRPUyA2LjYgZm9yIHR=
l
c3RpbmcuIChUaGUgcHJldmlvdXMga2VybmVsIHBhbmljIHdhcyBjYW1lIGZyb20gVWJ1bnR1KS4=
m
bmJzcDs8L2Rpdj48ZGl2PlRoZSBDZW50T1Mgbm9kZXMgZW5jb3VudGVyZWQga2VybmVsIHBhbml=
j
IHdpdGggc2FtZSBkYWVtb24gYnV0IHRoZSBwcm9ibGVtIG1heSBhIGJpdCBkaWZmZXIuJm5ic3A=
7
PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj4qIEl0IHdhcyBicm9rZW4gb24gYDxzcGFuIHN0eWx=
l
PSJjb2xvcjogcmdiKDgwLCAwLCA4MCk7IGZvbnQtc2l6ZTogMTRweDsiPnhmc19kaXIyX3NmX2d=
l
dF9wYXJlbnRfaW5vKzwvc3Bhbj48d2JyIHN0eWxlPSJjb2xvcjogcmdiKDgwLCAwLCA4MCk7IGZ=
v
bnQtc2l6ZTogMTRweDsiPjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDgwLCAwLCA4MCk7IGZvbnQ=
t
c2l6ZTogMTRweDsiPjB4YS8weDIwYCBpbiBVYnVudHUuJm5ic3A7PC9zcGFuPjwvZGl2PjxkaXY=
+
PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2IoODAsIDAsIDgwKTsgZm9udC1zaXplOiAxNHB4OyI+KiB=
I
ZXJlJ3MgdGhlIGxvZyBpbiBDZW50T1MuIEl0J3MgYnJva2VuIG9uIGA8L3NwYW4+eGZzX2RpcjJ=
f
c2ZfZ2V0ZGVudHMrMHgyYTAvMHgzYTBgPGJyPjwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+YGB=
g
PC9kaXY+PGRpdj48ZGl2PiZsdDsxJmd0O0JVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlV=
M
TCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDAwMDAwMDAwMDE8L2Rpdj48ZGl2PiZsdDs=
x
Jmd0O0lQOiBbJmx0O2ZmZmZmZmZmYTAzNjJkNjAmZ3Q7XSB4ZnNfZGlyMl9zZl9nZXRkZW50cys=
w
eDJhMC8weDNhMCBbeGZzXTwvZGl2PjxkaXY+Jmx0OzQmZ3Q7UEdEIDEwNzIzMjcwNjcgUFVEIDE=
w
NzIzMjgwNjcgUE1EIDA8L2Rpdj48ZGl2PiZsdDs0Jmd0O09vcHM6IDAwMDAgWyMxXSBTTVA8L2R=
p
dj48ZGl2PiZsdDs0Jmd0O2xhc3Qgc3lzZnMgZmlsZTogL3N5cy9kZXZpY2VzL3BjaTAwMDA6ODA=
v
MDAwMDo4MDowMy4yLzAwMDA6ODM6MDAuMC9ob3N0MTAvcG9ydC0xMDoxL2V4cGFuZGVyLTEwOjE=
v
cG9ydC0xMDoxOjE2L2VuZF9kZXZpY2UtMTA6MToxNi90YXJnZXQxMDowOjI1LzEwOjA6MjU6MC9=
i
bG9jay9zZHovcXVldWUvcm90YXRpb25hbDwvZGl2PjxkaXY+Jmx0OzQmZ3Q7Q1BVIDE3PC9kaXY=
+
PGRpdj4mbHQ7NCZndDtNb2R1bGVzIGxpbmtlZCBpbjogeHRfY29ubnRyYWNrIHR1biB4ZnMgZXh=
w
b3J0ZnMgaXB0YWJsZV9maWx0ZXIgaXB0X1JFRElSRUNUIGlwdGFibGVfbmF0IG5mX25hdCBuZl9=
j
b25udHJhY2tfaXB2NCBuZl9jb25udHJhY2sgbmZfZGVmcmFnX2lwdjQgaXBfdGFibGVzIGlwX3Z=
z
IGlwdjYgbGliY3JjMzJjIGlUQ09fd2R0IGlUQ09fdmVuZG9yX3N1cHBvcnQgc2VzIGVuY2xvc3V=
y
ZSBpZ2IgaTJjX2FsZ29fYml0IHNiX2VkYWMgZWRhY19jb3JlIGkyY19pODAxIGkyY19jb3JlIHN=
n
IHNocGNocCBscGNfaWNoIG1mZF9jb3JlIGl4Z2JlIGRjYSBwdHAgcHBzX2NvcmUgbWRpbyBwb3d=
l
cl9tZXRlciBhY3BpX2lwbWkgaXBtaV9zaSBpcG1pX21zZ2hhbmRsZXIgZXh0NCBqYmQyIG1iY2F=
j
aGUgc2RfbW9kIGNyY190MTBkaWYgbXB0M3NhcyBzY3NpX3RyYW5zcG9ydF9zYXMgcmFpZF9jbGF=
z
cyB4aGNpX2hjZCBhaGNpIHdtaSBkbV9taXJyb3IgZG1fcmVnaW9uX2hhc2ggZG1fbG9nIGRtX21=
v
ZCBbbGFzdCB1bmxvYWRlZDogc2NzaV93YWl0X3NjYW5dPC9kaXY+PGRpdj4mbHQ7NCZndDs8L2R=
p
dj48ZGl2PiZsdDs0Jmd0O1BpZDogNDQ1NCwgY29tbTogc3dpZnQtb2JqZWN0LXNlIE5vdCB0YWl=
u
dGVkIDIuNi4zMi01MDQuMjMuNC5lbDYueDg2XzY0ICMxIFNpbGljb24gTWVjaGFuaWNzIFN0b3J=
m
b3JtIFI1MTgudjVQL1gxMERSaS1UNCs8L2Rpdj48ZGl2PiZsdDs0Jmd0O1JJUDogMDAxMDpbJmx=
0
O2ZmZmZmZmZmYTAzNjJkNjAmZ3Q7XSAmbmJzcDtbJmx0O2ZmZmZmZmZmYTAzNjJkNjAmZ3Q7XSB=
4
ZnNfZGlyMl9zZl9nZXRkZW50cysweDJhMC8weDNhMCBbeGZzXTwvZGl2PjxkaXY+Jmx0OzQmZ3Q=
7
UlNQOiAwMDE4OmZmZmY4ODA4NzFmNmRlMTggJm5ic3A7RUZMQUdTOiAwMDAxMDIwMjwvZGl2Pjx=
k
aXY+Jmx0OzQmZ3Q7UkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDAwNCB=
S
Q1g6IDAwMDAwMDAwMDAwMDAwMDA8L2Rpdj48ZGl2PiZsdDs0Jmd0O1JEWDogMDAwMDAwMDAwMDA=
w
MDAwMSBSU0k6IDAwMDAwMDAwMDAwMDAwMDAgUkRJOiAwMDAwN2ZhYTc0MDA2MjAzPC9kaXY+PGR=
p
dj4mbHQ7NCZndDtSQlA6IGZmZmY4ODA4NzFmNmRlNjggUjA4OiAwMDAwMDAwMzJlYjA0YmM5IFI=
w
OTogMDAwMDAwMDAwMDAwMDAwNDwvZGl2PjxkaXY+Jmx0OzQmZ3Q7UjEwOiAwMDAwMDAwMDAwMDA=
4
MDMwIFIxMTogMDAwMDAwMDAwMDAwMDI0NiBSMTI6IDAwMDAwMDAwMDAwMDAwMDA8L2Rpdj48ZGl=
2
PiZsdDs0Jmd0O1IxMzogMDAwMDAwMDAwMDAwMDAwMiBSMTQ6IGZmZmY4ODEwNmVmZjcwMDAgUjE=
1
OiBmZmZmODgwODcxNWI0NTgwPC9kaXY+PGRpdj4mbHQ7NCZndDtGUzogJm5ic3A7MDAwMDdmYWE=
4
NTQyNTcwMCgwMDAwKSBHUzpmZmZmODgwMDI4MzYwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDA=
w
MDAwMDA8L2Rpdj48ZGl2PiZsdDs0Jmd0O0NTOiAmbmJzcDswMDEwIERTOiAwMDAwIEVTOiAwMDA=
w
IENSMDogMDAwMDAwMDA4MDA1MDAzMzwvZGl2PjxkaXY+Jmx0OzQmZ3Q7Q1IyOiAwMDAwMDAwMDA=
w
MDAwMDAxIENSMzogMDAwMDAwMTA3MjMyNTAwMCBDUjQ6IDAwMDAwMDAwMDAxNDA3ZTA8L2Rpdj4=
8
ZGl2PiZsdDs0Jmd0O0RSMDogMDAwMDAwMDAwMDAwMDAwMCBEUjE6IDAwMDAwMDAwMDAwMDAwMDA=
g
RFIyOiAwMDAwMDAwMDAwMDAwMDAwPC9kaXY+PGRpdj4mbHQ7NCZndDtEUjM6IDAwMDAwMDAwMDA=
w
MDAwMDAgRFI2OiAwMDAwMDAwMGZmZmYwZmYwIERSNzogMDAwMDAwMDAwMDAwMDQwMDwvZGl2Pjx=
k
aXY+Jmx0OzQmZ3Q7UHJvY2VzcyBzd2lmdC1vYmplY3Qtc2UgKHBpZDogNDQ1NCwgdGhyZWFkaW5=
m
byBmZmZmODgwODcxZjZjMDAwLCB0YXNrIGZmZmY4ODA4NjBmMThhYjApPC9kaXY+PGRpdj4mbHQ=
7
NCZndDtTdGFjazo8L2Rpdj48ZGl2PiZsdDs0Jmd0OyBmZmZmODgwODcxZjZkZTI4IGZmZmZmZmZ=
m
ODExYTRiYjAgZmZmZjg4MDg3MWY2ZGYzOCBmZmZmODgwODc0NzQ5Y2MwPC9kaXY+PGRpdj4mbHQ=
7
NCZndDsmbHQ7ZCZndDsgMDAwMDAwMDEwMDAwMDEwMyBmZmZmODgwMjM4MWY4YzAwIGZmZmY4ODA=
4
NzFmNmRmMzggZmZmZjg4MDg3MTViNDU4MDwvZGl2PjxkaXY+Jmx0OzQmZ3Q7Jmx0O2QmZ3Q7IDA=
w
MDAwMDAwMDAwMDAwODIgZmZmZjg4MDIzODFmOGQ4OCBmZmZmODgwODcxZjZkZWM4IGZmZmZmZmZ=
m
YTAzNWFiMzE8L2Rpdj48ZGl2PiZsdDs0Jmd0O0NhbGwgVHJhY2U6PC9kaXY+PGRpdj4mbHQ7NCZ=
n
dDsgWyZsdDtmZmZmZmZmZjgxMWE0YmIwJmd0O10gPyBmaWxsZGlyKzB4MC8weGUwPC9kaXY+PGR=
p
dj4mbHQ7NCZndDsgWyZsdDtmZmZmZmZmZmEwMzVhYjMxJmd0O10geGZzX3JlYWRkaXIrMHhlMS8=
w
eDEzMCBbeGZzXTwvZGl2PjxkaXY+Jmx0OzQmZ3Q7IFsmbHQ7ZmZmZmZmZmY4MTFhNGJiMCZndDt=
d
ID8gZmlsbGRpcisweDAvMHhlMDwvZGl2PjxkaXY+Jmx0OzQmZ3Q7IFsmbHQ7ZmZmZmZmZmZhMDM=
4
ZmUyOSZndDtdIHhmc19maWxlX3JlYWRkaXIrMHgzOS8weDUwIFt4ZnNdPC9kaXY+PGRpdj4mbHQ=
7
NCZndDsgWyZsdDtmZmZmZmZmZjgxMWE0ZTMwJmd0O10gdmZzX3JlYWRkaXIrMHhjMC8weGUwPC9=
k
aXY+PGRpdj4mbHQ7NCZndDsgWyZsdDtmZmZmZmZmZjgxMTliZDg2Jmd0O10gPyBmaW5hbF9wdXR=
u
YW1lKzB4MjYvMHg1MDwvZGl2PjxkaXY+Jmx0OzQmZ3Q7IFsmbHQ7ZmZmZmZmZmY4MTFhNGZiOSZ=
n
dDtdIHN5c19nZXRkZW50cysweDg5LzB4ZjA8L2Rpdj48ZGl2PiZsdDs0Jmd0OyBbJmx0O2ZmZmZ=
m
ZmZmODEwMGIwZjImZ3Q7XSBzeXN0ZW1fY2FsbF9mYXN0cGF0aCsweDE2LzB4MWI8L2Rpdj48ZGl=
2
PiZsdDs0Jmd0O0NvZGU6IDAxIDAwIDAwIDAwIDQ4IGM3IGM2IDM4IDZiIDNhIGEwIDQ4IDhiIDd=
k
IGMwIGZmIDU1IGI4IDg1IGMwIDBmIDg1IGFmIDAwIDAwIDAwIDQ5IDhiIDM3IGU5IGVjIGZkIGZ=
m
IGZmIDY2IDBmIDFmIDg0IDAwIDAwIDAwIDAwIDAwICZsdDs0MSZndDsgODAgN2MgMjQgMDEgMDA=
g
MGYgODQgOWMgMDAgMDAgMDAgNDUgMGYgYjYgNDQgMjQgMDMgNDEgMGYgYjY8L2Rpdj48ZGl2PiZ=
s
dDsxJmd0O1JJUCAmbmJzcDtbJmx0O2ZmZmZmZmZmYTAzNjJkNjAmZ3Q7XSB4ZnNfZGlyMl9zZl9=
n
ZXRkZW50cysweDJhMC8weDNhMCBbeGZzXTwvZGl2PjxkaXY+Jmx0OzQmZ3Q7IFJTUCAmbHQ7ZmZ=
m
Zjg4MDg3MWY2ZGUxOCZndDs8L2Rpdj48ZGl2PiZsdDs0Jmd0O0NSMjogMDAwMDAwMDAwMDAwMDA=
w
MTwvZGl2PjwvZGl2PjxkaXY+YGBgPC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5gYGA8L2Rpdj4=
8
ZGl2PjxkaXY+UElEOiA0NDU0ICZuYnNwOyBUQVNLOiBmZmZmODgwODYwZjE4YWIwICZuYnNwO0N=
Q
VTogMTcgJm5ic3A7Q09NTUFORDogInN3aWZ0LW9iamVjdC1zZSI8L2Rpdj48ZGl2PlJPT1Q6IC8=
g
Jm5ic3A7ICZuYnNwO0NXRDogLzwvZGl2PjxkaXY+Jm5ic3A7RkQgJm5ic3A7ICZuYnNwOyAmbmJ=
z
cDsgRklMRSAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwO0RFTlRSWSA=
m
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IElOT0RFICZuYnNwOyAmbmJzcDsgJm5=
i
c3A7IFRZUEUgUEFUSDwvZGl2PjxkaXY+Jm5ic3A7IDAgZmZmZjg4MTA3MzYwNDkwMCBmZmZmODg=
x
MDc0OWE5NDQwIGZmZmY4ODA4NzQwYjk3MjggQ0hSICZuYnNwOy9kZXYvbnVsbDwvZGl2PjxkaXY=
+
Jm5ic3A7IDEgZmZmZjg4MTA3MzYwNDkwMCBmZmZmODgxMDc0OWE5NDQwIGZmZmY4ODA4NzQwYjk=
3
MjggQ0hSICZuYnNwOy9kZXYvbnVsbDwvZGl2PjxkaXY+Jm5ic3A7IDIgZmZmZjg4MTA3MzYwNDk=
w
MCBmZmZmODgxMDc0OWE5NDQwIGZmZmY4ODA4NzQwYjk3MjggQ0hSICZuYnNwOy9kZXYvbnVsbDw=
v
ZGl2PjxkaXY+Jm5ic3A7IDMgZmZmZjg4MTA3NDIyMjg0MCBmZmZmODgxMDZlMTg0OTgwIGZmZmY=
4
ODEwNmUxNmNkNDggU09DSzwvZGl2PjxkaXY+Jm5ic3A7IDQgZmZmZjg4MTA3Mjk1MmMwMCBmZmZ=
m
ODgxMDZlMTg0OGMwIGZmZmY4ODEwNzExY2NhMDggU09DSzwvZGl2PjxkaXY+Jm5ic3A7IDUgZmZ=
m
Zjg4MDg3MTU0YjJjMCBmZmZmODgwNDRmMGYxNzgwIGZmZmY4ODAwMThlNTFhMDggU09DSzwvZGl=
2
PjxkaXY+Jm5ic3A7IDYgZmZmZjg4MTA3MTZmMjYwMCBmZmZmODgxMDcxMjJkNWMwIGZmZmY4ODE=
w
NzEzMTVjYjggUkVHICZuYnNwOy90bXAvZmZpMUVDSjhaPC9kaXY+PGRpdj4mbmJzcDsgNyBmZmZ=
m
ODgwODZiZDBhNmMwIGZmZmY4ODA4NmZjNGI4NDAgZmZmZjg4MDg2ZmM0YTEwMCBSRUcgJm5ic3A=
7
L3RtcC9mZmlJQXJIVU88L2Rpdj48ZGl2PiZuYnNwOyA4IGZmZmY4ODEwNmY1MTZlYzAgZmZmZjg=
4
MTA2N2Q5YWUwMCBmZmZmODgwODc0NWFhNWU4IFJFRyAmbmJzcDtbZXZlbnRwb2xsXTwvZGl2Pjx=
k
aXY+Jm5ic3A7IDkgZmZmZjg4MTA2ZWQzNWI0MCBmZmZmODgxMDZlMTViMjAwIGZmZmY4ODEwNmU=
y
MDFjYzggU09DSzwvZGl2PjxkaXY+Jm5ic3A7MTAgZmZmZjg4MTA2ZjMxYWUwMCBmZmZmODgxMDc=
0
YWQ3NWMwIGZmZmY4ODEwNmUxNjlhMDggU09DSzwvZGl2PjxkaXY+Jm5ic3A7MTEgZmZmZjg4MTA=
2
ZWRlMjc0MCBmZmZmODgxMDY3ZjlhOGMwIGZmZmY4ODA4NzQ1YWE1ZTggUkVHICZuYnNwO1tldmV=
u
dHBvbGxdPC9kaXY+PGRpdj4mbmJzcDsxMiBmZmZmODgwMTIyZThiYzgwIGZmZmY4ODA4NzQ1YTg=
y
NDAgZmZmZjg4MTA3NDM3OWQ0OCBDSFIgJm5ic3A7L2Rldi91cmFuZG9tPC9kaXY+PGRpdj4mbmJ=
z
cDsxMyBmZmZmODgwODcxNjJlMjAwIGZmZmY4ODA4NmZkODcyMDAgZmZmZjg4MDg2ZmU4Mjc0OCB=
T
T0NLPC9kaXY+PGRpdj4mbmJzcDsxNCBmZmZmODgwODcxMzVlODQwIGZmZmY4ODA4NmZjNjUzYzA=
g
ZmZmZjg4MDg2ZmU4MjQ4OCBTT0NLPC9kaXY+PGRpdj4mbmJzcDsxNSBmZmZmODgxMDZmMzZmOTA=
w
IGZmZmY4ODEwNmUyNjM2ODAgZmZmZjg4MDg3NDVhYTVlOCBSRUcgJm5ic3A7W2V2ZW50cG9sbF0=
8
L2Rpdj48ZGl2PiZuYnNwOzE2IGZmZmY4ODEwNzM3Zjg2ODAgZmZmZjg4MTA2ZTNlOWM4MCBmZmZ=
m
ODgwODc0NWFhNWU4IFJFRyAmbmJzcDtbZXZlbnRwb2xsXTwvZGl2PjxkaXY+Jm5ic3A7MTcgZmZ=
m
Zjg4MTA3MzYzNTU0MCBmZmZmODgxMDZlMWY5MjQwIGZmZmY4ODA4NzQ1YWE1ZTggUkVHICZuYnN=
w
O1tldmVudHBvbGxdPC9kaXY+PGRpdj4mbmJzcDsxOCBmZmZmODgxMDZlZjViYTQwIGZmZmY4ODE=
w
NWJiNmIwODAgZmZmZjg4MDg3NDVhYTVlOCBSRUcgJm5ic3A7W2V2ZW50cG9sbF08L2Rpdj48ZGl=
2
PiZuYnNwOzE5IGZmZmY4ODEwNzQyMjIzMDAgZmZmZjg4MTA1Yjk3NTMwMCBmZmZmODgwODc0NWF=
h
NWU4IFJFRyAmbmJzcDtbZXZlbnRwb2xsXTwvZGl2PjxkaXY+Jm5ic3A7MjAgZmZmZjg4MTA3Mzc=
3
MGYwMCBmZmZmODgxMDEzNDc4MDgwIGZmZmY4ODA4NzQ1YWE1ZTggUkVHICZuYnNwO1tldmVudHB=
v
bGxdPC9kaXY+PGRpdj4mbmJzcDsyMSBmZmZmODgxMDczN2Y4YmMwIGZmZmY4ODEwNmUzZTk1MDA=
g
ZmZmZjg4MDg3NDVhYTVlOCBSRUcgJm5ic3A7W2V2ZW50cG9sbF08L2Rpdj48ZGl2PiZuYnNwOzI=
y
IGZmZmY4ODEwNmVmNWJjODAgZmZmZjg4MTA1YmI3MmUwMCBmZmZmODgwODc0NWFhNWU4IFJFRyA=
m
bmJzcDtbZXZlbnRwb2xsXTwvZGl2PjxkaXY+Jm5ic3A7MjMgZmZmZjg4MTA2ZWYyNWUwMCBmZmZ=
m
ODgxMDZlM2U5YmMwIGZmZmY4ODA4NzQ1YWE1ZTggUkVHICZuYnNwO1tldmVudHBvbGxdPC9kaXY=
+
PGRpdj4mbmJzcDsyNCBmZmZmODgxMDcxOTUwZDgwIGZmZmY4ODEwMzgzZWU5ODAgZmZmZjg4MDg=
3
NDVhYTVlOCBSRUcgJm5ic3A7W2V2ZW50cG9sbF08L2Rpdj48ZGl2PiZuYnNwOzI1IGZmZmY4ODE=
w
NmVjY2E2MDAgZmZmZjg4MTA2N2Q5Njg0MCBmZmZmODgwODc0NWFhNWU4IFJFRyAmbmJzcDtbZXZ=
l
bnRwb2xsXTwvZGl2PjxkaXY+Jm5ic3A7MjYgZmZmZjg4MDg3MzdlYzc0MCBmZmZmODgwODU1ZDk=
1
Y2MwIGZmZmY4ODA4NzQ1YWE1ZTggUkVHICZuYnNwO1tldmVudHBvbGxdPC9kaXY+PGRpdj4mbmJ=
z
cDsyNyBmZmZmODgxMDczNDVkM2MwIGZmZmY4ODBmYzQ2MTYwYzAgZmZmZjg4MDg3NDVhYTVlOCB=
S
RUcgJm5ic3A7W2V2ZW50cG9sbF08L2Rpdj48ZGl2PiZuYnNwOzI4IGZmZmY4ODA4NmJmMmQ2MDA=
g
ZmZmZjg4MDc3Nzk4N2IwMCBmZmZmODgwMTU5YWMwNDQ4IFNPQ0s8L2Rpdj48ZGl2PiZuYnNwOzI=
5
IGZmZmY4ODA4NzM3ZTkyNDAgZmZmZjg4MDg1NWM4MGE0MCBmZmZmODgwODc0NWFhNWU4IFJFRyA=
m
bmJzcDtbZXZlbnRwb2xsXTwvZGl2PjxkaXY+Jm5ic3A7MzAgZmZmZjg4MTA2ZjVlMDE0MCBmZmZ=
m
ODgwZmY1NzUyNDQwIGZmZmY4ODA4NzQ1YWE1ZTggUkVHICZuYnNwO1tldmVudHBvbGxdPC9kaXY=
+
PGRpdj4mbmJzcDszMSBmZmZmODgwODcwM2ExOWMwIGZmZmY4ODA3ODQ3YzhlNDAgZmZmZjg4MDg=
3
NDVhYTVlOCBSRUcgJm5ic3A7W2V2ZW50cG9sbF08L2Rpdj48ZGl2PiZuYnNwOzMyIGZmZmY4ODA=
4
NmJkNzM4YzAgZmZmZjg4MDMzYmUxMDgwMCBmZmZmODgwNmI0N2YyYzA4IFNPQ0s8L2Rpdj48ZGl=
2
PiZuYnNwOzMzIGZmZmY4ODA4NzExOWViNDAgZmZmZjg4MDY5MTZiNDhjMCBmZmZmODgwNGNkMjd=
l
NjQ4IFNPQ0s8L2Rpdj48ZGl2PiZuYnNwOzM0IGZmZmY4ODA4NzBhZWQ0ODAgZmZmZjg4MDZiM2Z=
j
NDkwMCBmZmZmODgwMDE1NTgzNTg4IFJFRyAmbmJzcDsvc3J2L25vZGUvZDE5OS9vYmplY3RzLzE=
y
ODYwLzJjMC8zMjNjYzAyMGZkN2RiZDZjMTI0NzJjZDFjMTA3NDJjMC8xNDM2MjY2MDM2Ljk4MDE=
1
LnRzPC9kaXY+PGRpdj4mbmJzcDszNSBmZmZmODgxMDZlZWIwZTAwIGZmZmY4ODEwMTM0N2RlNDA=
g
ZmZmZjg4MDg3NDVhYTVlOCBSRUcgJm5ic3A7W2V2ZW50cG9sbF08L2Rpdj48ZGl2PiZuYnNwOzM=
2
IGZmZmY4ODA4NzAzZWQ2YzAgZmZmZjg4MDg2ZmQ2NTU0MCBmZmZmODgwNWViMDNlZDg4IFJFRyA=
m
bmJzcDsvc3J2L25vZGUvZDIwNS9xdWFyYW50aW5lZC9vYmplY3RzL2NkMWQ2OGY1MTUwMDZkNDQ=
z
YTU0ZmY0ZjY1ODA5MWJjLWExMTRiYmExNDQ5YjQ1MjM4YWJmMzhkYzc0MWQ3YzI3LzE0MzYyNTQ=
w
MjAuODk4MDEudHM8L2Rpdj48ZGl2PiZuYnNwOzM3IGZmZmY4ODEwNzE4MzQzYzAgZmZmZjg4MTA=
1
YjlkMzJjMCBmZmZmODgwODc0NWFhNWU4IFJFRyAmbmJzcDtbZXZlbnRwb2xsXTwvZGl2PjxkaXY=
+
Jm5ic3A7MzggZmZmZjg4MDg3MTNkYTc4MCBmZmZmODgwMDEwYzlhOTAwIGZmZmY4ODA5NjM2OGE=
x
ODggUkVHICZuYnNwOy9zcnYvbm9kZS9kMjI0L3F1YXJhbnRpbmVkL29iamVjdHMvYjE0Njg2NWJ=
m
ODAzNGJmYzQyNTcwYjc0N2MzNDFiMzIvMTQzNjI2NjA0Mi41Nzc3NS50czwvZGl2PjxkaXY+Jm5=
i
c3A7MzkgZmZmZjg4MDg3MWNiMDNjMCBmZmZmODgwNDk1YThiMzgwIGZmZmY4ODA4YTVlNmM5ODg=
g
UkVHICZuYnNwOy9zcnYvbm9kZS9kMjI0L3RtcC90bXBTcG5ySGc8L2Rpdj48ZGl2PiZuYnNwOzQ=
w
IGZmZmY4ODA4NzE1YjQ1NDAgZmZmZjg4MDQ4MTljNThjMCBmZmZmODgwMjM4MWY4ZDg4IERJUiA=
m
bmJzcDsvc3J2L25vZGUvZDIyNC9xdWFyYW50aW5lZC9vYmplY3RzL2IxNDY4NjViZjgwMzRiZmM=
0
MjU3MGI3NDdjMzQxYjMyPC9kaXY+PGRpdj4mbmJzcDs0MSBmZmZmODgwODcxZmNlMjQwIGZmZmY=
4
ODA5NTExMzZjMDAgZmZmZjg4MGJhY2Y2M2Q4OCBESVIgJm5ic3A7L3Nydi9ub2RlL2QxOTkvb2J=
q
ZWN0cy8xMjg2MC8yYzAvMzIzY2MwMjBmZDdkYmQ2YzEyNDcyY2QxYzEwNzQyYzA8L2Rpdj48L2R=
p
dj48ZGl2PmBgYDwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+SSd2ZSBnb3QgdGhlIHZtY29yZSB=
k
dW1wIGZyb20gb3BlcmF0b3IuIERvZXMgdm1jb3JlIGhlbHAgZm9yIHRyb3VibGVzaG9vdGluZyB=
r
aW5kIGlzc3VlID8mbmJzcDs8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PlRoYW5rcyAvLyBIdWd=
v
Jm5ic3A7PC9kaXY+" style=3D"height:0;width:0;max-height:0;max-width:0;overfl=
ow:hidden;font-size:0em;padding:0;margin:0">=E2=80=8B</div></div></div><div=
 class=3D"gmail_extra"><br><div class=3D"gmail_quote">2015-06-18 22:59 GMT+=
08:00 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.=
net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span>:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex"><span class=3D"">On 6/18/15 9:29 AM, Kuo Hugo wrote:<br>
&gt;&gt;- Have you tried an &#39;xfs_repair -n&#39; of the affected filesys=
tem? Note that -n will report problems only and prevent any modification by=
 repair.<br>
&gt;<br>
</span>&gt; *We might to to xfs_repair if we can address which disk causes =
the issue. *<br>
<br>
If you do, please save the output, and if it finds anything, please provide=
 the output in this thread.<br>
<br>
Thanks,<br>
-Eric<br>
</blockquote></div><br></div>

--047d7bfcf2f6b039a0051a6f2092--


--===============2550812957980441113==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2550812957980441113==--
