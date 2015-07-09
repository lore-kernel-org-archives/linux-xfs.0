Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B9317F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 08:20:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EEFFA8F8035
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 06:20:03 -0700 (PDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	TBc1xazwq5GIwDdn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 06:20:01 -0700 (PDT)
Received: by wiwl6 with SMTP id l6so18582793wiw.0
	for <xfs@oss.sgi.com>; Thu, 09 Jul 2015 06:20:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150709125119.GC63282@bfoster.bfoster>
References: <CA++_uht_4ON49eBqM6eA7oL7iBcxYMwR5ZAQxXmTuNji2XiyBA@mail.gmail.com>
	<20150618133122.GC43254@bfoster.bfoster>
	<CA++_uhuLbTT32v4ZeVkP3WOjBEeMU0O1NZDcv66a67hZ=pj9Sw@mail.gmail.com>
	<5582DCDA.9070200@sandeen.net>
	<CA++_uhuFL0DhwH3ENBHmFmzmBm5SGx45P9tqVTEdj-bCsHBSVA@mail.gmail.com>
	<20150709125119.GC63282@bfoster.bfoster>
Date: Thu, 9 Jul 2015 21:20:00 +0800
Message-ID: <CA++_uhuoQ76uOUikbetw5ocfHDGAFMERcbgX9R4Shha2GUxWmQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============3593431590360515185=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Hugo Kuo <hugo@swiftstack.com>, Eric Sandeen <sandeen@sandeen.net>, darrell@swiftstack.com, xfs@oss.sgi.com

--===============3593431590360515185==
Content-Type: multipart/alternative; boundary=047d7b4724e2cc2a84051a711c61

--047d7b4724e2cc2a84051a711c61
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Brian,

*Operating System Version:*
Linux-2.6.32-504.23.4.el6.x86_64-x86_64-with-centos-6.6-Final

*NODE 1*

https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore
https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt


*NODE 2*

https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore_r2obj02
https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg_r2obj02.=
txt


Any thoughts would be appreciate

Thanks // Hugo


2015-07-09 20:51 GMT+08:00 Brian Foster <bfoster@redhat.com>:

> On Thu, Jul 09, 2015 at 06:57:55PM +0800, Kuo Hugo wrote:
> > Hi Folks,
> >
> > As the results of 32 disks with xfs_repair -n seems no any error shows
> up.
> > We currently tried to deploy CentOS 6.6 for testing. (The previous kern=
el
> > panic was came from Ubuntu).
> > The CentOS nodes encountered kernel panic with same daemon but the
> problem
> > may a bit differ.
> >
> >    - It was broken on xfs_dir2_sf_get_parent_ino+0xa/0x20 in Ubuntu.
> >    - Here=E2=80=99s the log in CentOS. It=E2=80=99s broken on
> >    xfs_dir2_sf_getdents+0x2a0/0x3a0
> >
>
> I'd venture to guess it's the same behavior here. The previous kernel
> had a callback for the parent inode number that was called via
> xfs_dir2_sf_getdents(). Taking a look at a 6.6 kernel, it has a static
> inline here instead.
>
> > <1>BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000001
> > <1>IP: [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
> > <4>PGD 1072327067 PUD 1072328067 PMD 0
> > <4>Oops: 0000 [#1] SMP
> > <4>last sysfs file:
> >
> /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:1/expand=
er-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/block/sdz/q=
ueue/rotational
> > <4>CPU 17
> > <4>Modules linked in: xt_conntrack tun xfs exportfs iptable_filter
> > ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
> > nf_defrag_ipv4 ip_tables ip_vs ipv6 libcrc32c iTCO_wdt
> > iTCO_vendor_support ses enclosure igb i2c_algo_bit sb_edac edac_core
> > i2c_i801 i2c_core sg shpchp lpc_ich mfd_core ixgbe dca ptp pps_core
> > mdio power_meter acpi_ipmi ipmi_si ipmi_msghandler ext4 jbd2 mbcache
> > sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_class xhci_hcd ahci
> > wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
> > scsi_wait_scan]
> > <4>
> > <4>Pid: 4454, comm: swift-object-se Not tainted
> > 2.6.32-504.23.4.el6.x86_64 #1 Silicon Mechanics Storform
> > R518.v5P/X10DRi-T4+
> > <4>RIP: 0010:[<ffffffffa0362d60>]  [<ffffffffa0362d60>]
> > xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
> > <4>RSP: 0018:ffff880871f6de18  EFLAGS: 00010202
> > <4>RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000000
> > <4>RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007faa74006203
> > <4>RBP: ffff880871f6de68 R08: 000000032eb04bc9 R09: 0000000000000004
> > <4>R10: 0000000000008030 R11: 0000000000000246 R12: 0000000000000000
> > <4>R13: 0000000000000002 R14: ffff88106eff7000 R15: ffff8808715b4580
> > <4>FS:  00007faa85425700(0000) GS:ffff880028360000(0000)
> knlGS:0000000000000000
> > <4>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > <4>CR2: 0000000000000001 CR3: 0000001072325000 CR4: 00000000001407e0
> > <4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > <4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > <4>Process swift-object-se (pid: 4454, threadinfo ffff880871f6c000,
> > task ffff880860f18ab0)
> > <4>Stack:
> > <4> ffff880871f6de28 ffffffff811a4bb0 ffff880871f6df38 ffff880874749cc0
> > <4><d> 0000000100000103 ffff8802381f8c00 ffff880871f6df38
> ffff8808715b4580
> > <4><d> 0000000000000082 ffff8802381f8d88 ffff880871f6dec8
> ffffffffa035ab31
> > <4>Call Trace:
> > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
> > <4> [<ffffffffa035ab31>] xfs_readdir+0xe1/0x130 [xfs]
> > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
> > <4> [<ffffffffa038fe29>] xfs_file_readdir+0x39/0x50 [xfs]
> > <4> [<ffffffff811a4e30>] vfs_readdir+0xc0/0xe0
> > <4> [<ffffffff8119bd86>] ? final_putname+0x26/0x50
> > <4> [<ffffffff811a4fb9>] sys_getdents+0x89/0xf0
> > <4> [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > <4>Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48 8b 7d c0 ff 55 b8 85 c0
> > 0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f 84 00 00 00 00 00
> > <41> 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f b6 44 24 03 41 0f b6
> > <1>RIP  [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
> > <4> RSP <ffff880871f6de18>
> > <4>CR2: 0000000000000001
> >
> ...
> >
> > I=E2=80=99ve got the vmcore dump from operator. Does vmcore help for
> > troubleshooting kind issue ?
> >
>
> Hmm, well it couldn't hurt. Is the vmcore based on this 6.6 kernel? Can
> you provide the exact kernel version and post the vmcore somewhere?
>
> Brian
>
> > Thanks // Hugo
> > =E2=80=8B
> >
> > 2015-06-18 22:59 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>:
> >
> > > On 6/18/15 9:29 AM, Kuo Hugo wrote:
> > > >>- Have you tried an 'xfs_repair -n' of the affected filesystem? Not=
e
> > > that -n will report problems only and prevent any modification by
> repair.
> > > >
> > > > *We might to to xfs_repair if we can address which disk causes the
> > > issue. *
> > >
> > > If you do, please save the output, and if it finds anything, please
> > > provide the output in this thread.
> > >
> > > Thanks,
> > > -Eric
> > >
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--047d7b4724e2cc2a84051a711c61
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Brian,=C2=A0<div><br></div><div><div><b>Operating Syste=
m Version:</b>=C2=A0 Linux-2.6.32-504.23.4.el6.x86_64-x86_64-with-centos-6.=
6-Final</div></div><div><br></div><div><b>NODE 1</b></div><blockquote style=
=3D"margin:0 0 0 40px;border:none;padding:0px"><div><div><a href=3D"https:/=
/cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore">https://cloud.swifts=
tack.com/v1/AUTH_burton/brtnswift/vmcore</a></div></div><div><div><a href=
=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt"=
>https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt</a>=
</div></div></blockquote><div><div><br></div><div><b>NODE 2</b>=C2=A0</div>=
</div><blockquote style=3D"margin:0 0 0 40px;border:none;padding:0px"><div>=
<div><a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcor=
e_r2obj02">https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore_r2o=
bj02</a></div></div><div><div><a href=3D"https://cloud.swiftstack.com/v1/AU=
TH_burton/brtnswift/vmcore-dmesg_r2obj02.txt">https://cloud.swiftstack.com/=
v1/AUTH_burton/brtnswift/vmcore-dmesg_r2obj02.txt</a></div></div></blockquo=
te><div><div><br></div><div>Any thoughts would be appreciate</div><div><br>=
</div><div>Thanks // Hugo</div><div><br></div></div></div><div class=3D"gma=
il_extra"><br><div class=3D"gmail_quote">2015-07-09 20:51 GMT+08:00 Brian F=
oster <span dir=3D"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D=
"_blank">bfoster@redhat.com</a>&gt;</span>:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x"><span class=3D"">On Thu, Jul 09, 2015 at 06:57:55PM +0800, Kuo Hugo wrot=
e:<br>
&gt; Hi Folks,<br>
&gt;<br>
&gt; As the results of 32 disks with xfs_repair -n seems no any error shows=
 up.<br>
&gt; We currently tried to deploy CentOS 6.6 for testing. (The previous ker=
nel<br>
&gt; panic was came from Ubuntu).<br>
&gt; The CentOS nodes encountered kernel panic with same daemon but the pro=
blem<br>
&gt; may a bit differ.<br>
&gt;<br>
</span>&gt;=C2=A0 =C2=A0 - It was broken on xfs_dir2_sf_get_parent_ino+0xa/=
0x20 in Ubuntu.<br>
&gt;=C2=A0 =C2=A0 - Here=E2=80=99s the log in CentOS. It=E2=80=99s broken o=
n<br>
&gt;=C2=A0 =C2=A0 xfs_dir2_sf_getdents+0x2a0/0x3a0<br>
&gt;<br>
<br>
I&#39;d venture to guess it&#39;s the same behavior here. The previous kern=
el<br>
had a callback for the parent inode number that was called via<br>
xfs_dir2_sf_getdents(). Taking a look at a 6.6 kernel, it has a static<br>
inline here instead.<br>
<div><div class=3D"h5"><br>
&gt; &lt;1&gt;BUG: unable to handle kernel NULL pointer dereference at 0000=
000000000001<br>
&gt; &lt;1&gt;IP: [&lt;ffffffffa0362d60&gt;] xfs_dir2_sf_getdents+0x2a0/0x3=
a0 [xfs]<br>
&gt; &lt;4&gt;PGD 1072327067 PUD 1072328067 PMD 0<br>
&gt; &lt;4&gt;Oops: 0000 [#1] SMP<br>
&gt; &lt;4&gt;last sysfs file:<br>
&gt; /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:1/exp=
ander-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/block/sd=
z/queue/rotational<br>
&gt; &lt;4&gt;CPU 17<br>
&gt; &lt;4&gt;Modules linked in: xt_conntrack tun xfs exportfs iptable_filt=
er<br>
&gt; ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack<br>
&gt; nf_defrag_ipv4 ip_tables ip_vs ipv6 libcrc32c iTCO_wdt<br>
&gt; iTCO_vendor_support ses enclosure igb i2c_algo_bit sb_edac edac_core<b=
r>
&gt; i2c_i801 i2c_core sg shpchp lpc_ich mfd_core ixgbe dca ptp pps_core<br=
>
&gt; mdio power_meter acpi_ipmi ipmi_si ipmi_msghandler ext4 jbd2 mbcache<b=
r>
&gt; sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_class xhci_hcd ahci<=
br>
&gt; wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:<br>
&gt; scsi_wait_scan]<br>
&gt; &lt;4&gt;<br>
&gt; &lt;4&gt;Pid: 4454, comm: swift-object-se Not tainted<br>
&gt; 2.6.32-504.23.4.el6.x86_64 #1 Silicon Mechanics Storform<br>
&gt; R518.v5P/X10DRi-T4+<br>
&gt; &lt;4&gt;RIP: 0010:[&lt;ffffffffa0362d60&gt;]=C2=A0 [&lt;ffffffffa0362=
d60&gt;]<br>
&gt; xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]<br>
&gt; &lt;4&gt;RSP: 0018:ffff880871f6de18=C2=A0 EFLAGS: 00010202<br>
&gt; &lt;4&gt;RAX: 0000000000000000 RBX: 0000000000000004 RCX: 000000000000=
0000<br>
&gt; &lt;4&gt;RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007faa7400=
6203<br>
&gt; &lt;4&gt;RBP: ffff880871f6de68 R08: 000000032eb04bc9 R09: 000000000000=
0004<br>
&gt; &lt;4&gt;R10: 0000000000008030 R11: 0000000000000246 R12: 000000000000=
0000<br>
&gt; &lt;4&gt;R13: 0000000000000002 R14: ffff88106eff7000 R15: ffff8808715b=
4580<br>
&gt; &lt;4&gt;FS:=C2=A0 00007faa85425700(0000) GS:ffff880028360000(0000) kn=
lGS:0000000000000000<br>
&gt; &lt;4&gt;CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033<br>
&gt; &lt;4&gt;CR2: 0000000000000001 CR3: 0000001072325000 CR4: 000000000014=
07e0<br>
&gt; &lt;4&gt;DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000=
0000<br>
&gt; &lt;4&gt;DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000000=
0400<br>
&gt; &lt;4&gt;Process swift-object-se (pid: 4454, threadinfo ffff880871f6c0=
00,<br>
&gt; task ffff880860f18ab0)<br>
&gt; &lt;4&gt;Stack:<br>
&gt; &lt;4&gt; ffff880871f6de28 ffffffff811a4bb0 ffff880871f6df38 ffff88087=
4749cc0<br>
&gt; &lt;4&gt;&lt;d&gt; 0000000100000103 ffff8802381f8c00 ffff880871f6df38 =
ffff8808715b4580<br>
&gt; &lt;4&gt;&lt;d&gt; 0000000000000082 ffff8802381f8d88 ffff880871f6dec8 =
ffffffffa035ab31<br>
&gt; &lt;4&gt;Call Trace:<br>
&gt; &lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? filldir+0x0/0xe0<br>
&gt; &lt;4&gt; [&lt;ffffffffa035ab31&gt;] xfs_readdir+0xe1/0x130 [xfs]<br>
&gt; &lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? filldir+0x0/0xe0<br>
&gt; &lt;4&gt; [&lt;ffffffffa038fe29&gt;] xfs_file_readdir+0x39/0x50 [xfs]<=
br>
&gt; &lt;4&gt; [&lt;ffffffff811a4e30&gt;] vfs_readdir+0xc0/0xe0<br>
&gt; &lt;4&gt; [&lt;ffffffff8119bd86&gt;] ? final_putname+0x26/0x50<br>
&gt; &lt;4&gt; [&lt;ffffffff811a4fb9&gt;] sys_getdents+0x89/0xf0<br>
&gt; &lt;4&gt; [&lt;ffffffff8100b0f2&gt;] system_call_fastpath+0x16/0x1b<br=
>
&gt; &lt;4&gt;Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48 8b 7d c0 ff 55 b8 8=
5 c0<br>
&gt; 0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f 84 00 00 00 00 00<b=
r>
&gt; &lt;41&gt; 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f b6 44 24 03 41 0f b6=
<br>
&gt; &lt;1&gt;RIP=C2=A0 [&lt;ffffffffa0362d60&gt;] xfs_dir2_sf_getdents+0x2=
a0/0x3a0 [xfs]<br>
&gt; &lt;4&gt; RSP &lt;ffff880871f6de18&gt;<br>
&gt; &lt;4&gt;CR2: 0000000000000001<br>
&gt;<br>
</div></div>...<br>
<span class=3D"">&gt;<br>
&gt; I=E2=80=99ve got the vmcore dump from operator. Does vmcore help for<b=
r>
&gt; troubleshooting kind issue ?<br>
&gt;<br>
<br>
</span>Hmm, well it couldn&#39;t hurt. Is the vmcore based on this 6.6 kern=
el? Can<br>
you provide the exact kernel version and post the vmcore somewhere?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Brian<br>
</font></span><span class=3D"im HOEnZb"><br>
&gt; Thanks // Hugo<br>
&gt; =E2=80=8B<br>
&gt;<br>
&gt; 2015-06-18 22:59 GMT+08:00 Eric Sandeen &lt;<a href=3D"mailto:sandeen@=
sandeen.net">sandeen@sandeen.net</a>&gt;:<br>
&gt;<br>
&gt; &gt; On 6/18/15 9:29 AM, Kuo Hugo wrote:<br>
&gt; &gt; &gt;&gt;- Have you tried an &#39;xfs_repair -n&#39; of the affect=
ed filesystem? Note<br>
&gt; &gt; that -n will report problems only and prevent any modification by=
 repair.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; *We might to to xfs_repair if we can address which disk caus=
es the<br>
&gt; &gt; issue. *<br>
&gt; &gt;<br>
&gt; &gt; If you do, please save the output, and if it finds anything, plea=
se<br>
&gt; &gt; provide the output in this thread.<br>
&gt; &gt;<br>
&gt; &gt; Thanks,<br>
&gt; &gt; -Eric<br>
&gt; &gt;<br>
<br>
</span><div class=3D"HOEnZb"><div class=3D"h5">&gt; _______________________=
________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</div></div></blockquote></div><br></div>

--047d7b4724e2cc2a84051a711c61--


--===============3593431590360515185==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3593431590360515185==--
