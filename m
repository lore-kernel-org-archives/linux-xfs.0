Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AAA587F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 11:40:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8EE33304032
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 09:40:04 -0700 (PDT)
Received: from mail-wg0-f48.google.com (mail-wg0-f48.google.com
	[74.125.82.48]) by cuda.sgi.com with ESMTP id DSbLTiStAVHBJwEc
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jul 2015 09:40:01 -0700 (PDT)
Received: by wgjx7 with SMTP id x7so228236167wgj.2
	for <xfs@oss.sgi.com>; Thu, 09 Jul 2015 09:40:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150709151811.GE63282@bfoster.bfoster>
References: <CA++_uht_4ON49eBqM6eA7oL7iBcxYMwR5ZAQxXmTuNji2XiyBA@mail.gmail.com>
	<20150618133122.GC43254@bfoster.bfoster>
	<CA++_uhuLbTT32v4ZeVkP3WOjBEeMU0O1NZDcv66a67hZ=pj9Sw@mail.gmail.com>
	<5582DCDA.9070200@sandeen.net>
	<CA++_uhuFL0DhwH3ENBHmFmzmBm5SGx45P9tqVTEdj-bCsHBSVA@mail.gmail.com>
	<20150709125119.GC63282@bfoster.bfoster>
	<CA++_uhuoQ76uOUikbetw5ocfHDGAFMERcbgX9R4Shha2GUxWmQ@mail.gmail.com>
	<20150709151811.GE63282@bfoster.bfoster>
Date: Fri, 10 Jul 2015 00:40:00 +0800
Message-ID: <CA++_uhu=VNKtjax_JjsCZwDFT0Vk-CAjS5j=ba5+A5HL4nxpmA@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============7643993210350978201=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Hugo Kuo <hugo@swiftstack.com>, Eric Sandeen <sandeen@sandeen.net>, darrell@swiftstack.com, xfs@oss.sgi.com

--===============7643993210350978201==
Content-Type: multipart/alternative; boundary=001a11c23d2a1512f1051a73e855

--001a11c23d2a1512f1051a73e855
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Brain,

There you go.

https://cloud.swiftstack.com/v1/AUTH_hugo/public/vmlinux
https://cloud.swiftstack.com/v1/AUTH_hugo/public/System.map-2.6.32-504.23.4=
.el6.x86_64

$ md5sum vmlinux
82aaa694a174c0a29e78c05e73adf5d8  vmlinux

Yes, I can read it with this vmlinux image. Put all files
(vmcore,vmlinux,System.map) in a folder and run $crash vmlinux vmcore

Hugo
=E2=80=8B

2015-07-09 23:18 GMT+08:00 Brian Foster <bfoster@redhat.com>:

> On Thu, Jul 09, 2015 at 09:20:00PM +0800, Kuo Hugo wrote:
> > Hi Brian,
> >
> > *Operating System Version:*
> > Linux-2.6.32-504.23.4.el6.x86_64-x86_64-with-centos-6.6-Final
> >
> > *NODE 1*
> >
> > https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore
> > https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt
> >
> >
> > *NODE 2*
> >
> > https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore_r2obj02
> >
> https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg_r2obj0=
2.txt
> >
> >
> > Any thoughts would be appreciate
> >
>
> I'm not able to fire up crash with these core files and the kernel debug
> info from the following centos kernel debuginfo package:
>
> kernel-debuginfo-2.6.32-504.23.4.el6.centos.plus.x86_64.rpm
>
> It complains about a version mismatch between the vmlinux and core file.
> I'm no crash expert... are you sure the cores above correspond to this
> kernel? Does crash load up for you on said box if you run something like
> the following?
>
>         crash /usr/lib/debug/lib/modules/.../vmlinux vmcore
>
> Note that you might need to install the above kernel-debuginfo package
> to get the debug (vmlinux) file. If so, could you also upload that
> debuginfo rpm somewhere?
>
> Brian
>
> > Thanks // Hugo
> >
> >
> > 2015-07-09 20:51 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> >
> > > On Thu, Jul 09, 2015 at 06:57:55PM +0800, Kuo Hugo wrote:
> > > > Hi Folks,
> > > >
> > > > As the results of 32 disks with xfs_repair -n seems no any error
> shows
> > > up.
> > > > We currently tried to deploy CentOS 6.6 for testing. (The previous
> kernel
> > > > panic was came from Ubuntu).
> > > > The CentOS nodes encountered kernel panic with same daemon but the
> > > problem
> > > > may a bit differ.
> > > >
> > > >    - It was broken on xfs_dir2_sf_get_parent_ino+0xa/0x20 in Ubuntu=
.
> > > >    - Here=E2=80=99s the log in CentOS. It=E2=80=99s broken on
> > > >    xfs_dir2_sf_getdents+0x2a0/0x3a0
> > > >
> > >
> > > I'd venture to guess it's the same behavior here. The previous kernel
> > > had a callback for the parent inode number that was called via
> > > xfs_dir2_sf_getdents(). Taking a look at a 6.6 kernel, it has a stati=
c
> > > inline here instead.
> > >
> > > > <1>BUG: unable to handle kernel NULL pointer dereference at
> > > 0000000000000001
> > > > <1>IP: [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
> > > > <4>PGD 1072327067 PUD 1072328067 PMD 0
> > > > <4>Oops: 0000 [#1] SMP
> > > > <4>last sysfs file:
> > > >
> > >
> /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:1/expand=
er-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/block/sdz/q=
ueue/rotational
> > > > <4>CPU 17
> > > > <4>Modules linked in: xt_conntrack tun xfs exportfs iptable_filter
> > > > ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
> > > > nf_defrag_ipv4 ip_tables ip_vs ipv6 libcrc32c iTCO_wdt
> > > > iTCO_vendor_support ses enclosure igb i2c_algo_bit sb_edac edac_cor=
e
> > > > i2c_i801 i2c_core sg shpchp lpc_ich mfd_core ixgbe dca ptp pps_core
> > > > mdio power_meter acpi_ipmi ipmi_si ipmi_msghandler ext4 jbd2 mbcach=
e
> > > > sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_class xhci_hcd ah=
ci
> > > > wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
> > > > scsi_wait_scan]
> > > > <4>
> > > > <4>Pid: 4454, comm: swift-object-se Not tainted
> > > > 2.6.32-504.23.4.el6.x86_64 #1 Silicon Mechanics Storform
> > > > R518.v5P/X10DRi-T4+
> > > > <4>RIP: 0010:[<ffffffffa0362d60>]  [<ffffffffa0362d60>]
> > > > xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
> > > > <4>RSP: 0018:ffff880871f6de18  EFLAGS: 00010202
> > > > <4>RAX: 0000000000000000 RBX: 0000000000000004 RCX: 000000000000000=
0
> > > > <4>RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00007faa7400620=
3
> > > > <4>RBP: ffff880871f6de68 R08: 000000032eb04bc9 R09: 000000000000000=
4
> > > > <4>R10: 0000000000008030 R11: 0000000000000246 R12: 000000000000000=
0
> > > > <4>R13: 0000000000000002 R14: ffff88106eff7000 R15: ffff8808715b458=
0
> > > > <4>FS:  00007faa85425700(0000) GS:ffff880028360000(0000)
> > > knlGS:0000000000000000
> > > > <4>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > <4>CR2: 0000000000000001 CR3: 0000001072325000 CR4: 00000000001407e=
0
> > > > <4>DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000000000=
0
> > > > <4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000000040=
0
> > > > <4>Process swift-object-se (pid: 4454, threadinfo ffff880871f6c000,
> > > > task ffff880860f18ab0)
> > > > <4>Stack:
> > > > <4> ffff880871f6de28 ffffffff811a4bb0 ffff880871f6df38
> ffff880874749cc0
> > > > <4><d> 0000000100000103 ffff8802381f8c00 ffff880871f6df38
> > > ffff8808715b4580
> > > > <4><d> 0000000000000082 ffff8802381f8d88 ffff880871f6dec8
> > > ffffffffa035ab31
> > > > <4>Call Trace:
> > > > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
> > > > <4> [<ffffffffa035ab31>] xfs_readdir+0xe1/0x130 [xfs]
> > > > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
> > > > <4> [<ffffffffa038fe29>] xfs_file_readdir+0x39/0x50 [xfs]
> > > > <4> [<ffffffff811a4e30>] vfs_readdir+0xc0/0xe0
> > > > <4> [<ffffffff8119bd86>] ? final_putname+0x26/0x50
> > > > <4> [<ffffffff811a4fb9>] sys_getdents+0x89/0xf0
> > > > <4> [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > > <4>Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48 8b 7d c0 ff 55 b8 85 c=
0
> > > > 0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f 84 00 00 00 00 0=
0
> > > > <41> 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f b6 44 24 03 41 0f b6
> > > > <1>RIP  [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
> > > > <4> RSP <ffff880871f6de18>
> > > > <4>CR2: 0000000000000001
> > > >
> > > ...
> > > >
> > > > I=E2=80=99ve got the vmcore dump from operator. Does vmcore help fo=
r
> > > > troubleshooting kind issue ?
> > > >
> > >
> > > Hmm, well it couldn't hurt. Is the vmcore based on this 6.6 kernel? C=
an
> > > you provide the exact kernel version and post the vmcore somewhere?
> > >
> > > Brian
> > >
> > > > Thanks // Hugo
> > > > =E2=80=8B
> > > >
> > > > 2015-06-18 22:59 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>:
> > > >
> > > > > On 6/18/15 9:29 AM, Kuo Hugo wrote:
> > > > > >>- Have you tried an 'xfs_repair -n' of the affected filesystem?
> Note
> > > > > that -n will report problems only and prevent any modification by
> > > repair.
> > > > > >
> > > > > > *We might to to xfs_repair if we can address which disk causes
> the
> > > > > issue. *
> > > > >
> > > > > If you do, please save the output, and if it finds anything, plea=
se
> > > > > provide the output in this thread.
> > > > >
> > > > > Thanks,
> > > > > -Eric
> > > > >
> > >
> > > > _______________________________________________
> > > > xfs mailing list
> > > > xfs@oss.sgi.com
> > > > http://oss.sgi.com/mailman/listinfo/xfs
> > >
> > >
>

--001a11c23d2a1512f1051a73e855
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"markdown-here-wrapper" style=3D""><p style=
=3D"margin:0px 0px 1.2em!important">Hi Brain, </p>
<p style=3D"margin:0px 0px 1.2em!important">There you go. </p>
<p style=3D"margin:0px 0px 1.2em!important"></p><div class=3D"markdown-here=
-exclude"><p></p><blockquote style=3D"margin:0 0 0 40px;border:none;padding=
:0px"><div><div><a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/public=
/vmlinux">https://cloud.swiftstack.com/v1/AUTH_hugo/public/vmlinux</a></div=
></div><div><div><a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/publi=
c/System.map-2.6.32-504.23.4.el6.x86_64">https://cloud.swiftstack.com/v1/AU=
TH_hugo/public/System.map-2.6.32-504.23.4.el6.x86_64</a></div></div></block=
quote><p></p></div><p style=3D"margin:0px 0px 1.2em!important"></p>
<pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mon=
ospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"fon=
t-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px=
 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234=
,234);border-radius:3px;display:inline;background-color:rgb(248,248,248);wh=
ite-space:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,=
204);padding:0.5em 0.7em;display:block!important">$ md5sum vmlinux
82aaa694a174c0a29e78c05e73adf5d8  vmlinux
</code></pre><p style=3D"margin:0px 0px 1.2em!important">Yes, I can read it=
 with this vmlinux image. Put all files (vmcore,vmlinux,System.map) in a fo=
lder and run <code style=3D"font-size:0.85em;font-family:Consolas,Inconsola=
ta,Courier,monospace;margin:0px 0.15em;padding:0px 0.3em;white-space:pre-wr=
ap;border:1px solid rgb(234,234,234);border-radius:3px;display:inline;backg=
round-color:rgb(248,248,248)">$crash vmlinux vmcore</code></p>
<p style=3D"margin:0px 0px 1.2em!important">Hugo </p>
<div title=3D"MDH:SGkgQnJhaW4swqA8ZGl2Pjxicj48L2Rpdj48ZGl2PlRoZXJlIHlvdSBnb=
y4mbmJzcDs8L2Rpdj48
ZGl2Pjxicj48L2Rpdj48YmxvY2txdW90ZSBzdHlsZT0ibWFyZ2luOiAwIDAgMCA0MHB4OyBib3J=
k
ZXI6IG5vbmU7IHBhZGRpbmc6IDBweDsiPjxkaXY+PGRpdj5odHRwczovL2Nsb3VkLnN3aWZ0c3R=
h
Y2suY29tL3YxL0FVVEhfaHVnby9wdWJsaWMvdm1saW51eDwvZGl2PjwvZGl2PjxkaXY+PGRpdj5=
o
dHRwczovL2Nsb3VkLnN3aWZ0c3RhY2suY29tL3YxL0FVVEhfaHVnby9wdWJsaWMvU3lzdGVtLm1=
h
cC0yLjYuMzItNTA0LjIzLjQuZWw2Lng4Nl82NDwvZGl2PjwvZGl2PjwvYmxvY2txdW90ZT48ZGl=
2
Pjxicj48L2Rpdj48ZGl2PmBgYDwvZGl2PjxkaXY+PGRpdj4kIG1kNXN1bSB2bWxpbnV4PC9kaXY=
+
PGRpdj44MmFhYTY5NGExNzRjMGEyOWU3OGMwNWU3M2FkZjVkOCAmbmJzcDt2bWxpbnV4PC9kaXY=
+
PC9kaXY+PGRpdj5gYGA8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PlllcywgSSBjYW4gcmVhZCB=
p
dCB3aXRoIHRoaXMgdm1saW51eCBpbWFnZS4gUHV0IGFsbCBmaWxlcyAodm1jb3JlLHZtbGludXg=
s
U3lzdGVtLm1hcCkgaW4gYSBmb2xkZXIgYW5kIHJ1biBgJGNyYXNoIHZtbGludXggdm1jb3JlYDw=
v
ZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+SHVnbyZuYnNwOzwvZGl2Pg=3D=3D" style=3D"heig=
ht:0;width:0;max-height:0;max-width:0;overflow:hidden;font-size:0em;padding=
:0;margin:0">=E2=80=8B</div></div></div><div class=3D"gmail_extra"><br><div=
 class=3D"gmail_quote">2015-07-09 23:18 GMT+08:00 Brian Foster <span dir=3D=
"ltr">&lt;<a href=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@r=
edhat.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Thu, Jul 09,=
 2015 at 09:20:00PM +0800, Kuo Hugo wrote:<br>
&gt; Hi Brian,<br>
&gt;<br>
&gt; *Operating System Version:*<br>
&gt; Linux-2.6.32-504.23.4.el6.x86_64-x86_64-with-centos-6.6-Final<br>
&gt;<br>
&gt; *NODE 1*<br>
&gt;<br>
&gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcor=
e" rel=3D"noreferrer" target=3D"_blank">https://cloud.swiftstack.com/v1/AUT=
H_burton/brtnswift/vmcore</a><br>
&gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcor=
e-dmesg.txt" rel=3D"noreferrer" target=3D"_blank">https://cloud.swiftstack.=
com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt</a><br>
&gt;<br>
&gt;<br>
&gt; *NODE 2*<br>
<span class=3D"">&gt;<br>
&gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcor=
e_r2obj02" rel=3D"noreferrer" target=3D"_blank">https://cloud.swiftstack.co=
m/v1/AUTH_burton/brtnswift/vmcore_r2obj02</a><br>
&gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcor=
e-dmesg_r2obj02.txt" rel=3D"noreferrer" target=3D"_blank">https://cloud.swi=
ftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg_r2obj02.txt</a><br>
&gt;<br>
&gt;<br>
&gt; Any thoughts would be appreciate<br>
&gt;<br>
<br>
</span>I&#39;m not able to fire up crash with these core files and the kern=
el debug<br>
info from the following centos kernel debuginfo package:<br>
<br>
kernel-debuginfo-2.6.32-504.23.4.el6.centos.plus.x86_64.rpm<br>
<br>
It complains about a version mismatch between the vmlinux and core file.<br=
>
I&#39;m no crash expert... are you sure the cores above correspond to this<=
br>
kernel? Does crash load up for you on said box if you run something like<br=
>
the following?<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 crash /usr/lib/debug/lib/modules/.../vmlinux vm=
core<br>
<br>
Note that you might need to install the above kernel-debuginfo package<br>
to get the debug (vmlinux) file. If so, could you also upload that<br>
debuginfo rpm somewhere?<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Brian<br>
<br>
&gt; Thanks // Hugo<br>
&gt;<br>
&gt;<br>
&gt; 2015-07-09 20:51 GMT+08:00 Brian Foster &lt;<a href=3D"mailto:bfoster@=
redhat.com">bfoster@redhat.com</a>&gt;:<br>
&gt;<br>
&gt; &gt; On Thu, Jul 09, 2015 at 06:57:55PM +0800, Kuo Hugo wrote:<br>
&gt; &gt; &gt; Hi Folks,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; As the results of 32 disks with xfs_repair -n seems no any e=
rror shows<br>
&gt; &gt; up.<br>
&gt; &gt; &gt; We currently tried to deploy CentOS 6.6 for testing. (The pr=
evious kernel<br>
&gt; &gt; &gt; panic was came from Ubuntu).<br>
&gt; &gt; &gt; The CentOS nodes encountered kernel panic with same daemon b=
ut the<br>
&gt; &gt; problem<br>
&gt; &gt; &gt; may a bit differ.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 - It was broken on xfs_dir2_sf_get_parent_ino+0=
xa/0x20 in Ubuntu.<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 - Here=E2=80=99s the log in CentOS. It=E2=80=99=
s broken on<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 xfs_dir2_sf_getdents+0x2a0/0x3a0<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; I&#39;d venture to guess it&#39;s the same behavior here. The pre=
vious kernel<br>
&gt; &gt; had a callback for the parent inode number that was called via<br=
>
&gt; &gt; xfs_dir2_sf_getdents(). Taking a look at a 6.6 kernel, it has a s=
tatic<br>
&gt; &gt; inline here instead.<br>
&gt; &gt;<br>
&gt; &gt; &gt; &lt;1&gt;BUG: unable to handle kernel NULL pointer dereferen=
ce at<br>
&gt; &gt; 0000000000000001<br>
&gt; &gt; &gt; &lt;1&gt;IP: [&lt;ffffffffa0362d60&gt;] xfs_dir2_sf_getdents=
+0x2a0/0x3a0 [xfs]<br>
&gt; &gt; &gt; &lt;4&gt;PGD 1072327067 PUD 1072328067 PMD 0<br>
&gt; &gt; &gt; &lt;4&gt;Oops: 0000 [#1] SMP<br>
&gt; &gt; &gt; &lt;4&gt;last sysfs file:<br>
&gt; &gt; &gt;<br>
&gt; &gt; /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:=
1/expander-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/blo=
ck/sdz/queue/rotational<br>
&gt; &gt; &gt; &lt;4&gt;CPU 17<br>
&gt; &gt; &gt; &lt;4&gt;Modules linked in: xt_conntrack tun xfs exportfs ip=
table_filter<br>
&gt; &gt; &gt; ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_conntra=
ck<br>
&gt; &gt; &gt; nf_defrag_ipv4 ip_tables ip_vs ipv6 libcrc32c iTCO_wdt<br>
&gt; &gt; &gt; iTCO_vendor_support ses enclosure igb i2c_algo_bit sb_edac e=
dac_core<br>
&gt; &gt; &gt; i2c_i801 i2c_core sg shpchp lpc_ich mfd_core ixgbe dca ptp p=
ps_core<br>
&gt; &gt; &gt; mdio power_meter acpi_ipmi ipmi_si ipmi_msghandler ext4 jbd2=
 mbcache<br>
&gt; &gt; &gt; sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_class xhci=
_hcd ahci<br>
&gt; &gt; &gt; wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:<b=
r>
&gt; &gt; &gt; scsi_wait_scan]<br>
&gt; &gt; &gt; &lt;4&gt;<br>
&gt; &gt; &gt; &lt;4&gt;Pid: 4454, comm: swift-object-se Not tainted<br>
&gt; &gt; &gt; 2.6.32-504.23.4.el6.x86_64 #1 Silicon Mechanics Storform<br>
&gt; &gt; &gt; R518.v5P/X10DRi-T4+<br>
&gt; &gt; &gt; &lt;4&gt;RIP: 0010:[&lt;ffffffffa0362d60&gt;]=C2=A0 [&lt;fff=
fffffa0362d60&gt;]<br>
&gt; &gt; &gt; xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]<br>
&gt; &gt; &gt; &lt;4&gt;RSP: 0018:ffff880871f6de18=C2=A0 EFLAGS: 00010202<b=
r>
&gt; &gt; &gt; &lt;4&gt;RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00=
00000000000000<br>
&gt; &gt; &gt; &lt;4&gt;RDX: 0000000000000001 RSI: 0000000000000000 RDI: 00=
007faa74006203<br>
&gt; &gt; &gt; &lt;4&gt;RBP: ffff880871f6de68 R08: 000000032eb04bc9 R09: 00=
00000000000004<br>
&gt; &gt; &gt; &lt;4&gt;R10: 0000000000008030 R11: 0000000000000246 R12: 00=
00000000000000<br>
&gt; &gt; &gt; &lt;4&gt;R13: 0000000000000002 R14: ffff88106eff7000 R15: ff=
ff8808715b4580<br>
&gt; &gt; &gt; &lt;4&gt;FS:=C2=A0 00007faa85425700(0000) GS:ffff88002836000=
0(0000)<br>
&gt; &gt; knlGS:0000000000000000<br>
&gt; &gt; &gt; &lt;4&gt;CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050=
033<br>
&gt; &gt; &gt; &lt;4&gt;CR2: 0000000000000001 CR3: 0000001072325000 CR4: 00=
000000001407e0<br>
&gt; &gt; &gt; &lt;4&gt;DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00=
00000000000000<br>
&gt; &gt; &gt; &lt;4&gt;DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 00=
00000000000400<br>
&gt; &gt; &gt; &lt;4&gt;Process swift-object-se (pid: 4454, threadinfo ffff=
880871f6c000,<br>
&gt; &gt; &gt; task ffff880860f18ab0)<br>
&gt; &gt; &gt; &lt;4&gt;Stack:<br>
&gt; &gt; &gt; &lt;4&gt; ffff880871f6de28 ffffffff811a4bb0 ffff880871f6df38=
 ffff880874749cc0<br>
&gt; &gt; &gt; &lt;4&gt;&lt;d&gt; 0000000100000103 ffff8802381f8c00 ffff880=
871f6df38<br>
&gt; &gt; ffff8808715b4580<br>
&gt; &gt; &gt; &lt;4&gt;&lt;d&gt; 0000000000000082 ffff8802381f8d88 ffff880=
871f6dec8<br>
&gt; &gt; ffffffffa035ab31<br>
&gt; &gt; &gt; &lt;4&gt;Call Trace:<br>
&gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? filldir+0x0/0xe0<br>
&gt; &gt; &gt; &lt;4&gt; [&lt;ffffffffa035ab31&gt;] xfs_readdir+0xe1/0x130 =
[xfs]<br>
&gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? filldir+0x0/0xe0<br>
&gt; &gt; &gt; &lt;4&gt; [&lt;ffffffffa038fe29&gt;] xfs_file_readdir+0x39/0=
x50 [xfs]<br>
&gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4e30&gt;] vfs_readdir+0xc0/0xe0<b=
r>
&gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff8119bd86&gt;] ? final_putname+0x26/0x=
50<br>
&gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4fb9&gt;] sys_getdents+0x89/0xf0<=
br>
&gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff8100b0f2&gt;] system_call_fastpath+0x=
16/0x1b<br>
&gt; &gt; &gt; &lt;4&gt;Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48 8b 7d c0 =
ff 55 b8 85 c0<br>
&gt; &gt; &gt; 0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f 84 00 00 =
00 00 00<br>
&gt; &gt; &gt; &lt;41&gt; 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f b6 44 24 0=
3 41 0f b6<br>
&gt; &gt; &gt; &lt;1&gt;RIP=C2=A0 [&lt;ffffffffa0362d60&gt;] xfs_dir2_sf_ge=
tdents+0x2a0/0x3a0 [xfs]<br>
&gt; &gt; &gt; &lt;4&gt; RSP &lt;ffff880871f6de18&gt;<br>
&gt; &gt; &gt; &lt;4&gt;CR2: 0000000000000001<br>
&gt; &gt; &gt;<br>
&gt; &gt; ...<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I=E2=80=99ve got the vmcore dump from operator. Does vmcore =
help for<br>
&gt; &gt; &gt; troubleshooting kind issue ?<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; Hmm, well it couldn&#39;t hurt. Is the vmcore based on this 6.6 k=
ernel? Can<br>
&gt; &gt; you provide the exact kernel version and post the vmcore somewher=
e?<br>
&gt; &gt;<br>
&gt; &gt; Brian<br>
&gt; &gt;<br>
&gt; &gt; &gt; Thanks // Hugo<br>
&gt; &gt; &gt; =E2=80=8B<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; 2015-06-18 22:59 GMT+08:00 Eric Sandeen &lt;<a href=3D"mailt=
o:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; On 6/18/15 9:29 AM, Kuo Hugo wrote:<br>
&gt; &gt; &gt; &gt; &gt;&gt;- Have you tried an &#39;xfs_repair -n&#39; of =
the affected filesystem? Note<br>
&gt; &gt; &gt; &gt; that -n will report problems only and prevent any modif=
ication by<br>
&gt; &gt; repair.<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; *We might to to xfs_repair if we can address which=
 disk causes the<br>
&gt; &gt; &gt; &gt; issue. *<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; If you do, please save the output, and if it finds anyt=
hing, please<br>
&gt; &gt; &gt; &gt; provide the output in this thread.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt; &gt; -Eric<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; &gt; _______________________________________________<br>
&gt; &gt; &gt; xfs mailing list<br>
&gt; &gt; &gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; &gt; &gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"n=
oreferrer" target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br=
>
&gt; &gt;<br>
&gt; &gt;<br>
</div></div></blockquote></div><br></div>

--001a11c23d2a1512f1051a73e855--


--===============7643993210350978201==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7643993210350978201==--
