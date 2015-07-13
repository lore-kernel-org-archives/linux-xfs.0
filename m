Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9EDB77F5F
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 09:06:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B78E304062
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 07:06:43 -0700 (PDT)
Received: from mail-wi0-f170.google.com (mail-wi0-f170.google.com
	[209.85.212.170]) by cuda.sgi.com with ESMTP id
	BB2oNz86NKynvCrl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jul 2015 07:06:40 -0700 (PDT)
Received: by wibud3 with SMTP id ud3so30810667wib.1
	for <xfs@oss.sgi.com>; Mon, 13 Jul 2015 07:06:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150713125214.GA50787@bfoster.bfoster>
References: <20150618133122.GC43254@bfoster.bfoster>
	<CA++_uhuLbTT32v4ZeVkP3WOjBEeMU0O1NZDcv66a67hZ=pj9Sw@mail.gmail.com>
	<5582DCDA.9070200@sandeen.net>
	<CA++_uhuFL0DhwH3ENBHmFmzmBm5SGx45P9tqVTEdj-bCsHBSVA@mail.gmail.com>
	<20150709125119.GC63282@bfoster.bfoster>
	<CA++_uhuoQ76uOUikbetw5ocfHDGAFMERcbgX9R4Shha2GUxWmQ@mail.gmail.com>
	<20150709151811.GE63282@bfoster.bfoster>
	<CA++_uhu=VNKtjax_JjsCZwDFT0Vk-CAjS5j=ba5+A5HL4nxpmA@mail.gmail.com>
	<20150709183255.GG63282@bfoster.bfoster>
	<CA++_uht5N6MtqUQfbB9A3R__UvR4aLN2q5-mFKiO__vU-Cxwpw@mail.gmail.com>
	<20150713125214.GA50787@bfoster.bfoster>
Date: Mon, 13 Jul 2015 22:06:39 +0800
Message-ID: <CA++_uhvrDBuP9nANTc0ZxZudDriYKrrtnaQUZzXPRLs0otD22w@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6298729062421663666=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Hugo Kuo <hugo@swiftstack.com>, Eric Sandeen <sandeen@sandeen.net>, darrell@swiftstack.com, xfs@oss.sgi.com

--===============6298729062421663666==
Content-Type: multipart/alternative; boundary=047d7bfcf2f605e065051ac23bc2

--047d7bfcf2f605e065051ac23bc2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Brain,

Sorry for the wrong file in previous message. I believe this the right one.

https://cloud.swiftstack.com/v1/AUTH_hugo/public/xfs.ko.debug

/usr/lib/debug/lib/modules/2.6.32-504.23.4.el6.x86_64/kernel/fs/xfs/xfs.ko.=
debug

MD5 : 27829c9c55f4f5b095d29a7de7c27254

Thanks // Hugo
=E2=80=8B

2015-07-13 20:52 GMT+08:00 Brian Foster <bfoster@redhat.com>:

> On Fri, Jul 10, 2015 at 01:36:41PM +0800, Kuo Hugo wrote:
> > Hi Brain,
> >
> > Is this the file which you need ?
> >
> > https://cloud.swiftstack.com/v1/AUTH_hugo/public/xfs.ko
> >
> > $> modinfo xfs
> >
> > filename: /lib/modules/2.6.32-504.23.4.el6.x86_64/kernel/fs/xfs/xfs.ko
> > license: GPL
> > description: SGI XFS with ACLs, security attributes, large block/inode
> > numbers, no debug enabled
> > author: Silicon Graphics, Inc.
> > srcversion: 0C1B17926BDDA4F121479EE
> > depends: exportfs
> > vermagic: 2.6.32-504.23.4.el6.x86_64 SMP mod_unload modversion
> >
>
> No, this isn't the debug version. We need the one from the debug package
> that was installed (/usr/lib/debug?).
>
> Brian
>
> > Thanks // Hugo
> > =E2=80=8B
> >
> > 2015-07-10 2:32 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> >
> > > On Fri, Jul 10, 2015 at 12:40:00AM +0800, Kuo Hugo wrote:
> > > > Hi Brain,
> > > >
> > > > There you go.
> > > >
> > > > https://cloud.swiftstack.com/v1/AUTH_hugo/public/vmlinux
> > > >
> > >
> https://cloud.swiftstack.com/v1/AUTH_hugo/public/System.map-2.6.32-504.23=
.4.el6.x86_64
> > > >
> > > > $ md5sum vmlinux
> > > > 82aaa694a174c0a29e78c05e73adf5d8  vmlinux
> > > >
> > > > Yes, I can read it with this vmlinux image. Put all files
> > > > (vmcore,vmlinux,System.map) in a folder and run $crash vmlinux vmco=
re
> > > >
> > >
> > > Thanks, I can actually load that up now. Note that we'll probably nee=
d
> > > the modules and whatnot (xfs.ko) also to be able to look at any XFS
> > > bits. It might be easiest to just tar up and compress whatever
> directory
> > > structure has the debug-enabled vmlinux and all the kernel modules.
> > > Thanks.
> > >
> > > Brian
> > >
> > > > Hugo
> > > > =E2=80=8B
> > > >
> > > > 2015-07-09 23:18 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> > > >
> > > > > On Thu, Jul 09, 2015 at 09:20:00PM +0800, Kuo Hugo wrote:
> > > > > > Hi Brian,
> > > > > >
> > > > > > *Operating System Version:*
> > > > > > Linux-2.6.32-504.23.4.el6.x86_64-x86_64-with-centos-6.6-Final
> > > > > >
> > > > > > *NODE 1*
> > > > > >
> > > > > > https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore
> > > > > >
> > > https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.tx=
t
> > > > > >
> > > > > >
> > > > > > *NODE 2*
> > > > > >
> > > > > >
> https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore_r2obj02
> > > > > >
> > > > >
> > >
> https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg_r2obj0=
2.txt
> > > > > >
> > > > > >
> > > > > > Any thoughts would be appreciate
> > > > > >
> > > > >
> > > > > I'm not able to fire up crash with these core files and the kerne=
l
> > > debug
> > > > > info from the following centos kernel debuginfo package:
> > > > >
> > > > > kernel-debuginfo-2.6.32-504.23.4.el6.centos.plus.x86_64.rpm
> > > > >
> > > > > It complains about a version mismatch between the vmlinux and cor=
e
> > > file.
> > > > > I'm no crash expert... are you sure the cores above correspond to
> this
> > > > > kernel? Does crash load up for you on said box if you run somethi=
ng
> > > like
> > > > > the following?
> > > > >
> > > > >         crash /usr/lib/debug/lib/modules/.../vmlinux vmcore
> > > > >
> > > > > Note that you might need to install the above kernel-debuginfo
> package
> > > > > to get the debug (vmlinux) file. If so, could you also upload tha=
t
> > > > > debuginfo rpm somewhere?
> > > > >
> > > > > Brian
> > > > >
> > > > > > Thanks // Hugo
> > > > > >
> > > > > >
> > > > > > 2015-07-09 20:51 GMT+08:00 Brian Foster <bfoster@redhat.com>:
> > > > > >
> > > > > > > On Thu, Jul 09, 2015 at 06:57:55PM +0800, Kuo Hugo wrote:
> > > > > > > > Hi Folks,
> > > > > > > >
> > > > > > > > As the results of 32 disks with xfs_repair -n seems no any
> error
> > > > > shows
> > > > > > > up.
> > > > > > > > We currently tried to deploy CentOS 6.6 for testing. (The
> > > previous
> > > > > kernel
> > > > > > > > panic was came from Ubuntu).
> > > > > > > > The CentOS nodes encountered kernel panic with same daemon
> but
> > > the
> > > > > > > problem
> > > > > > > > may a bit differ.
> > > > > > > >
> > > > > > > >    - It was broken on xfs_dir2_sf_get_parent_ino+0xa/0x20 i=
n
> > > Ubuntu.
> > > > > > > >    - Here=E2=80=99s the log in CentOS. It=E2=80=99s broken =
on
> > > > > > > >    xfs_dir2_sf_getdents+0x2a0/0x3a0
> > > > > > > >
> > > > > > >
> > > > > > > I'd venture to guess it's the same behavior here. The previou=
s
> > > kernel
> > > > > > > had a callback for the parent inode number that was called vi=
a
> > > > > > > xfs_dir2_sf_getdents(). Taking a look at a 6.6 kernel, it has=
 a
> > > static
> > > > > > > inline here instead.
> > > > > > >
> > > > > > > > <1>BUG: unable to handle kernel NULL pointer dereference at
> > > > > > > 0000000000000001
> > > > > > > > <1>IP: [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3a=
0
> > > [xfs]
> > > > > > > > <4>PGD 1072327067 PUD 1072328067 PMD 0
> > > > > > > > <4>Oops: 0000 [#1] SMP
> > > > > > > > <4>last sysfs file:
> > > > > > > >
> > > > > > >
> > > > >
> > >
> /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:1/expand=
er-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/block/sdz/q=
ueue/rotational
> > > > > > > > <4>CPU 17
> > > > > > > > <4>Modules linked in: xt_conntrack tun xfs exportfs
> > > iptable_filter
> > > > > > > > ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4
> nf_conntrack
> > > > > > > > nf_defrag_ipv4 ip_tables ip_vs ipv6 libcrc32c iTCO_wdt
> > > > > > > > iTCO_vendor_support ses enclosure igb i2c_algo_bit sb_edac
> > > edac_core
> > > > > > > > i2c_i801 i2c_core sg shpchp lpc_ich mfd_core ixgbe dca ptp
> > > pps_core
> > > > > > > > mdio power_meter acpi_ipmi ipmi_si ipmi_msghandler ext4 jbd=
2
> > > mbcache
> > > > > > > > sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_class
> xhci_hcd
> > > ahci
> > > > > > > > wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
> > > > > > > > scsi_wait_scan]
> > > > > > > > <4>
> > > > > > > > <4>Pid: 4454, comm: swift-object-se Not tainted
> > > > > > > > 2.6.32-504.23.4.el6.x86_64 #1 Silicon Mechanics Storform
> > > > > > > > R518.v5P/X10DRi-T4+
> > > > > > > > <4>RIP: 0010:[<ffffffffa0362d60>]  [<ffffffffa0362d60>]
> > > > > > > > xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
> > > > > > > > <4>RSP: 0018:ffff880871f6de18  EFLAGS: 00010202
> > > > > > > > <4>RAX: 0000000000000000 RBX: 0000000000000004 RCX:
> > > 0000000000000000
> > > > > > > > <4>RDX: 0000000000000001 RSI: 0000000000000000 RDI:
> > > 00007faa74006203
> > > > > > > > <4>RBP: ffff880871f6de68 R08: 000000032eb04bc9 R09:
> > > 0000000000000004
> > > > > > > > <4>R10: 0000000000008030 R11: 0000000000000246 R12:
> > > 0000000000000000
> > > > > > > > <4>R13: 0000000000000002 R14: ffff88106eff7000 R15:
> > > ffff8808715b4580
> > > > > > > > <4>FS:  00007faa85425700(0000) GS:ffff880028360000(0000)
> > > > > > > knlGS:0000000000000000
> > > > > > > > <4>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > > > > <4>CR2: 0000000000000001 CR3: 0000001072325000 CR4:
> > > 00000000001407e0
> > > > > > > > <4>DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > 0000000000000000
> > > > > > > > <4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > > 0000000000000400
> > > > > > > > <4>Process swift-object-se (pid: 4454, threadinfo
> > > ffff880871f6c000,
> > > > > > > > task ffff880860f18ab0)
> > > > > > > > <4>Stack:
> > > > > > > > <4> ffff880871f6de28 ffffffff811a4bb0 ffff880871f6df38
> > > > > ffff880874749cc0
> > > > > > > > <4><d> 0000000100000103 ffff8802381f8c00 ffff880871f6df38
> > > > > > > ffff8808715b4580
> > > > > > > > <4><d> 0000000000000082 ffff8802381f8d88 ffff880871f6dec8
> > > > > > > ffffffffa035ab31
> > > > > > > > <4>Call Trace:
> > > > > > > > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
> > > > > > > > <4> [<ffffffffa035ab31>] xfs_readdir+0xe1/0x130 [xfs]
> > > > > > > > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
> > > > > > > > <4> [<ffffffffa038fe29>] xfs_file_readdir+0x39/0x50 [xfs]
> > > > > > > > <4> [<ffffffff811a4e30>] vfs_readdir+0xc0/0xe0
> > > > > > > > <4> [<ffffffff8119bd86>] ? final_putname+0x26/0x50
> > > > > > > > <4> [<ffffffff811a4fb9>] sys_getdents+0x89/0xf0
> > > > > > > > <4> [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
> > > > > > > > <4>Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48 8b 7d c0 ff 55
> b8
> > > 85 c0
> > > > > > > > 0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f 84 00 00
> 00
> > > 00 00
> > > > > > > > <41> 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f b6 44 24 03 41
> 0f b6
> > > > > > > > <1>RIP  [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3=
a0
> > > [xfs]
> > > > > > > > <4> RSP <ffff880871f6de18>
> > > > > > > > <4>CR2: 0000000000000001
> > > > > > > >
> > > > > > > ...
> > > > > > > >
> > > > > > > > I=E2=80=99ve got the vmcore dump from operator. Does vmcore=
 help for
> > > > > > > > troubleshooting kind issue ?
> > > > > > > >
> > > > > > >
> > > > > > > Hmm, well it couldn't hurt. Is the vmcore based on this 6.6
> > > kernel? Can
> > > > > > > you provide the exact kernel version and post the vmcore
> somewhere?
> > > > > > >
> > > > > > > Brian
> > > > > > >
> > > > > > > > Thanks // Hugo
> > > > > > > > =E2=80=8B
> > > > > > > >
> > > > > > > > 2015-06-18 22:59 GMT+08:00 Eric Sandeen <sandeen@sandeen.ne=
t
> >:
> > > > > > > >
> > > > > > > > > On 6/18/15 9:29 AM, Kuo Hugo wrote:
> > > > > > > > > >>- Have you tried an 'xfs_repair -n' of the affected
> > > filesystem?
> > > > > Note
> > > > > > > > > that -n will report problems only and prevent any
> modification
> > > by
> > > > > > > repair.
> > > > > > > > > >
> > > > > > > > > > *We might to to xfs_repair if we can address which disk
> > > causes
> > > > > the
> > > > > > > > > issue. *
> > > > > > > > >
> > > > > > > > > If you do, please save the output, and if it finds
> anything,
> > > please
> > > > > > > > > provide the output in this thread.
> > > > > > > > >
> > > > > > > > > Thanks,
> > > > > > > > > -Eric
> > > > > > > > >
> > > > > > >
> > > > > > > > _______________________________________________
> > > > > > > > xfs mailing list
> > > > > > > > xfs@oss.sgi.com
> > > > > > > > http://oss.sgi.com/mailman/listinfo/xfs
> > > > > > >
> > > > > > >
> > > > >
> > >
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--047d7bfcf2f605e065051ac23bc2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"markdown-here-wrapper" style=3D""><p style=
=3D"margin:0px 0px 1.2em!important">Hi Brain, </p>
<p style=3D"margin:0px 0px 1.2em!important">Sorry for the wrong file in pre=
vious message. I believe this the right one. </p>
<p style=3D"margin:0px 0px 1.2em!important"><a href=3D"https://cloud.swifts=
tack.com/v1/AUTH_hugo/public/xfs.ko.debug">https://cloud.swiftstack.com/v1/=
AUTH_hugo/public/xfs.ko.debug</a></p>
<pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mon=
ospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"fon=
t-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px=
 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234=
,234);border-radius:3px;display:inline;background-color:rgb(248,248,248);wh=
ite-space:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,=
204);padding:0.5em 0.7em;display:block!important">/usr/lib/debug/lib/module=
s/2.6.32-504.23.4.el6.x86_64/kernel/fs/xfs/xfs.ko.debug
</code></pre><p style=3D"margin:0px 0px 1.2em!important">MD5 : 27829c9c55f4=
f5b095d29a7de7c27254</p>
<p style=3D"margin:0px 0px 1.2em!important">Thanks // Hugo</p>
<div title=3D"MDH:SGkgQnJhaW4swqA8ZGl2Pjxicj48L2Rpdj48ZGl2PlNvcnJ5IGZvciB0a=
GUgd3JvbmcgZmlsZSBp
biBwcmV2aW91cyBtZXNzYWdlLiBJIGJlbGlldmUgdGhpcyB0aGUgcmlnaHQgb25lLiZuYnNwOzw=
v
ZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+aHR0cHM6Ly9jbG91ZC5zd2lmdHN0YWNrLmNvbS92MS9=
B
VVRIX2h1Z28vcHVibGljL3hmcy5rby5kZWJ1Zzxicj48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl=
2
PmBgYDwvZGl2PjxkaXY+L3Vzci9saWIvZGVidWcvbGliL21vZHVsZXMvMi42LjMyLTUwNC4yMy4=
0
LmVsNi54ODZfNjQva2VybmVsL2ZzL3hmcy94ZnMua28uZGVidWc8YnI+PC9kaXY+PGRpdj5gYGA=
8
L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2Pk1ENSA6Jm5ic3A7Mjc4MjljOWM1NWY0ZjViMDk1ZDI=
5
YTdkZTdjMjcyNTQ8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PlRoYW5rcyAvLyBIdWdvPC9kaXY=
+
PGRpdj48YnI+PC9kaXY+PGRpdj48YnI+PC9kaXY+" style=3D"height:0;width:0;max-hei=
ght:0;max-width:0;overflow:hidden;font-size:0em;padding:0;margin:0">=E2=80=
=8B</div></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">2015-07-13 20:52 GMT+08:00 Brian Foster <span dir=3D"ltr">&lt;<a href=
=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;=
</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Fri, Jul 10,=
 2015 at 01:36:41PM +0800, Kuo Hugo wrote:<br>
&gt; Hi Brain,<br>
&gt;<br>
</span><span class=3D"">&gt; Is this the file which you need ?<br>
&gt;<br>
&gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/public/xfs.ko" re=
l=3D"noreferrer" target=3D"_blank">https://cloud.swiftstack.com/v1/AUTH_hug=
o/public/xfs.ko</a><br>
&gt;<br>
&gt; $&gt; modinfo xfs<br>
&gt;<br>
&gt; filename: /lib/modules/2.6.32-504.23.4.el6.x86_64/kernel/fs/xfs/xfs.ko=
<br>
&gt; license: GPL<br>
&gt; description: SGI XFS with ACLs, security attributes, large block/inode=
<br>
&gt; numbers, no debug enabled<br>
&gt; author: Silicon Graphics, Inc.<br>
&gt; srcversion: 0C1B17926BDDA4F121479EE<br>
&gt; depends: exportfs<br>
&gt; vermagic: 2.6.32-504.23.4.el6.x86_64 SMP mod_unload modversion<br>
&gt;<br>
<br>
</span>No, this isn&#39;t the debug version. We need the one from the debug=
 package<br>
that was installed (/usr/lib/debug?).<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Brian<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Thanks // Hugo<br>
&gt; =E2=80=8B<br>
&gt;<br>
&gt; 2015-07-10 2:32 GMT+08:00 Brian Foster &lt;<a href=3D"mailto:bfoster@r=
edhat.com">bfoster@redhat.com</a>&gt;:<br>
&gt;<br>
&gt; &gt; On Fri, Jul 10, 2015 at 12:40:00AM +0800, Kuo Hugo wrote:<br>
&gt; &gt; &gt; Hi Brain,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; There you go.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/public/=
vmlinux" rel=3D"noreferrer" target=3D"_blank">https://cloud.swiftstack.com/=
v1/AUTH_hugo/public/vmlinux</a><br>
&gt; &gt; &gt;<br>
&gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/public/Syste=
m.map-2.6.32-504.23.4.el6.x86_64" rel=3D"noreferrer" target=3D"_blank">http=
s://cloud.swiftstack.com/v1/AUTH_hugo/public/System.map-2.6.32-504.23.4.el6=
.x86_64</a><br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; $ md5sum vmlinux<br>
&gt; &gt; &gt; 82aaa694a174c0a29e78c05e73adf5d8=C2=A0 vmlinux<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Yes, I can read it with this vmlinux image. Put all files<br=
>
&gt; &gt; &gt; (vmcore,vmlinux,System.map) in a folder and run $crash vmlin=
ux vmcore<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; Thanks, I can actually load that up now. Note that we&#39;ll prob=
ably need<br>
&gt; &gt; the modules and whatnot (xfs.ko) also to be able to look at any X=
FS<br>
&gt; &gt; bits. It might be easiest to just tar up and compress whatever di=
rectory<br>
&gt; &gt; structure has the debug-enabled vmlinux and all the kernel module=
s.<br>
&gt; &gt; Thanks.<br>
&gt; &gt;<br>
&gt; &gt; Brian<br>
&gt; &gt;<br>
&gt; &gt; &gt; Hugo<br>
&gt; &gt; &gt; =E2=80=8B<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; 2015-07-09 23:18 GMT+08:00 Brian Foster &lt;<a href=3D"mailt=
o:bfoster@redhat.com">bfoster@redhat.com</a>&gt;:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; On Thu, Jul 09, 2015 at 09:20:00PM +0800, Kuo Hugo wrot=
e:<br>
&gt; &gt; &gt; &gt; &gt; Hi Brian,<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; *Operating System Version:*<br>
&gt; &gt; &gt; &gt; &gt; Linux-2.6.32-504.23.4.el6.x86_64-x86_64-with-cento=
s-6.6-Final<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; *NODE 1*<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_bu=
rton/brtnswift/vmcore" rel=3D"noreferrer" target=3D"_blank">https://cloud.s=
wiftstack.com/v1/AUTH_burton/brtnswift/vmcore</a><br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/=
vmcore-dmesg.txt" rel=3D"noreferrer" target=3D"_blank">https://cloud.swifts=
tack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt</a><br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; *NODE 2*<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_bu=
rton/brtnswift/vmcore_r2obj02" rel=3D"noreferrer" target=3D"_blank">https:/=
/cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore_r2obj02</a><br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/=
vmcore-dmesg_r2obj02.txt" rel=3D"noreferrer" target=3D"_blank">https://clou=
d.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg_r2obj02.txt</a><br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Any thoughts would be appreciate<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; I&#39;m not able to fire up crash with these core files=
 and the kernel<br>
&gt; &gt; debug<br>
&gt; &gt; &gt; &gt; info from the following centos kernel debuginfo package=
:<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; kernel-debuginfo-2.6.32-504.23.4.el6.centos.plus.x86_64=
.rpm<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; It complains about a version mismatch between the vmlin=
ux and core<br>
&gt; &gt; file.<br>
&gt; &gt; &gt; &gt; I&#39;m no crash expert... are you sure the cores above=
 correspond to this<br>
&gt; &gt; &gt; &gt; kernel? Does crash load up for you on said box if you r=
un something<br>
&gt; &gt; like<br>
&gt; &gt; &gt; &gt; the following?<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0crash /usr/lib/debug/l=
ib/modules/.../vmlinux vmcore<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Note that you might need to install the above kernel-de=
buginfo package<br>
&gt; &gt; &gt; &gt; to get the debug (vmlinux) file. If so, could you also =
upload that<br>
&gt; &gt; &gt; &gt; debuginfo rpm somewhere?<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Brian<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Thanks // Hugo<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; 2015-07-09 20:51 GMT+08:00 Brian Foster &lt;<a hre=
f=3D"mailto:bfoster@redhat.com">bfoster@redhat.com</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; On Thu, Jul 09, 2015 at 06:57:55PM +0800, Kuo=
 Hugo wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Hi Folks,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; As the results of 32 disks with xfs_repa=
ir -n seems no any error<br>
&gt; &gt; &gt; &gt; shows<br>
&gt; &gt; &gt; &gt; &gt; &gt; up.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; We currently tried to deploy CentOS 6.6 =
for testing. (The<br>
&gt; &gt; previous<br>
&gt; &gt; &gt; &gt; kernel<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; panic was came from Ubuntu).<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; The CentOS nodes encountered kernel pani=
c with same daemon but<br>
&gt; &gt; the<br>
&gt; &gt; &gt; &gt; &gt; &gt; problem<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; may a bit differ.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 - It was broken on xfs_dir2=
_sf_get_parent_ino+0xa/0x20 in<br>
&gt; &gt; Ubuntu.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 - Here=E2=80=99s the log in=
 CentOS. It=E2=80=99s broken on<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 xfs_dir2_sf_getdents+0x2a0/=
0x3a0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; I&#39;d venture to guess it&#39;s the same be=
havior here. The previous<br>
&gt; &gt; kernel<br>
&gt; &gt; &gt; &gt; &gt; &gt; had a callback for the parent inode number th=
at was called via<br>
&gt; &gt; &gt; &gt; &gt; &gt; xfs_dir2_sf_getdents(). Taking a look at a 6.=
6 kernel, it has a<br>
&gt; &gt; static<br>
&gt; &gt; &gt; &gt; &gt; &gt; inline here instead.<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;1&gt;BUG: unable to handle kernel NU=
LL pointer dereference at<br>
&gt; &gt; &gt; &gt; &gt; &gt; 0000000000000001<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;1&gt;IP: [&lt;ffffffffa0362d60&gt;] =
xfs_dir2_sf_getdents+0x2a0/0x3a0<br>
&gt; &gt; [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;PGD 1072327067 PUD 1072328067 P=
MD 0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Oops: 0000 [#1] SMP<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;last sysfs file:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:=
1/expander-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/blo=
ck/sdz/queue/rotational<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;CPU 17<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Modules linked in: xt_conntrack=
 tun xfs exportfs<br>
&gt; &gt; iptable_filter<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; ipt_REDIRECT iptable_nat nf_nat nf_connt=
rack_ipv4 nf_conntrack<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; nf_defrag_ipv4 ip_tables ip_vs ipv6 libc=
rc32c iTCO_wdt<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; iTCO_vendor_support ses enclosure igb i2=
c_algo_bit sb_edac<br>
&gt; &gt; edac_core<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; i2c_i801 i2c_core sg shpchp lpc_ich mfd_=
core ixgbe dca ptp<br>
&gt; &gt; pps_core<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; mdio power_meter acpi_ipmi ipmi_si ipmi_=
msghandler ext4 jbd2<br>
&gt; &gt; mbcache<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; sd_mod crc_t10dif mpt3sas scsi_transport=
_sas raid_class xhci_hcd<br>
&gt; &gt; ahci<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; wmi dm_mirror dm_region_hash dm_log dm_m=
od [last unloaded:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; scsi_wait_scan]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Pid: 4454, comm: swift-object-s=
e Not tainted<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; 2.6.32-504.23.4.el6.x86_64 #1 Silicon Me=
chanics Storform<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; R518.v5P/X10DRi-T4+<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RIP: 0010:[&lt;ffffffffa0362d60=
&gt;]=C2=A0 [&lt;ffffffffa0362d60&gt;]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]<b=
r>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RSP: 0018:ffff880871f6de18=C2=
=A0 EFLAGS: 00010202<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RAX: 0000000000000000 RBX: 0000=
000000000004 RCX:<br>
&gt; &gt; 0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RDX: 0000000000000001 RSI: 0000=
000000000000 RDI:<br>
&gt; &gt; 00007faa74006203<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;RBP: ffff880871f6de68 R08: 0000=
00032eb04bc9 R09:<br>
&gt; &gt; 0000000000000004<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;R10: 0000000000008030 R11: 0000=
000000000246 R12:<br>
&gt; &gt; 0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;R13: 0000000000000002 R14: ffff=
88106eff7000 R15:<br>
&gt; &gt; ffff8808715b4580<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;FS:=C2=A0 00007faa85425700(0000=
) GS:ffff880028360000(0000)<br>
&gt; &gt; &gt; &gt; &gt; &gt; knlGS:0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;CS:=C2=A0 0010 DS: 0000 ES: 000=
0 CR0: 0000000080050033<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;CR2: 0000000000000001 CR3: 0000=
001072325000 CR4:<br>
&gt; &gt; 00000000001407e0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;DR0: 0000000000000000 DR1: 0000=
000000000000 DR2:<br>
&gt; &gt; 0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;DR3: 0000000000000000 DR6: 0000=
0000ffff0ff0 DR7:<br>
&gt; &gt; 0000000000000400<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Process swift-object-se (pid: 4=
454, threadinfo<br>
&gt; &gt; ffff880871f6c000,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; task ffff880860f18ab0)<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Stack:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; ffff880871f6de28 ffffffff811a4=
bb0 ffff880871f6df38<br>
&gt; &gt; &gt; &gt; ffff880874749cc0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;&lt;d&gt; 0000000100000103 ffff=
8802381f8c00 ffff880871f6df38<br>
&gt; &gt; &gt; &gt; &gt; &gt; ffff8808715b4580<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;&lt;d&gt; 0000000000000082 ffff=
8802381f8d88 ffff880871f6dec8<br>
&gt; &gt; &gt; &gt; &gt; &gt; ffffffffa035ab31<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Call Trace:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? f=
illdir+0x0/0xe0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffffa035ab31&gt;] xfs=
_readdir+0xe1/0x130 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? f=
illdir+0x0/0xe0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffffa038fe29&gt;] xfs=
_file_readdir+0x39/0x50 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4e30&gt;] vfs=
_readdir+0xc0/0xe0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff8119bd86&gt;] ? f=
inal_putname+0x26/0x50<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4fb9&gt;] sys=
_getdents+0x89/0xf0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff8100b0f2&gt;] sys=
tem_call_fastpath+0x16/0x1b<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;Code: 01 00 00 00 48 c7 c6 38 6=
b 3a a0 48 8b 7d c0 ff 55 b8<br>
&gt; &gt; 85 c0<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; 0f 85 af 00 00 00 49 8b 37 e9 ec fd ff f=
f 66 0f 1f 84 00 00 00<br>
&gt; &gt; 00 00<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;41&gt; 80 7c 24 01 00 0f 84 9c 00 00=
 00 45 0f b6 44 24 03 41 0f b6<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;1&gt;RIP=C2=A0 [&lt;ffffffffa0362d60=
&gt;] xfs_dir2_sf_getdents+0x2a0/0x3a0<br>
&gt; &gt; [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt; RSP &lt;ffff880871f6de18&gt;<b=
r>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &lt;4&gt;CR2: 0000000000000001<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; ...<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; I=E2=80=99ve got the vmcore dump from op=
erator. Does vmcore help for<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; troubleshooting kind issue ?<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Hmm, well it couldn&#39;t hurt. Is the vmcore=
 based on this 6.6<br>
&gt; &gt; kernel? Can<br>
&gt; &gt; &gt; &gt; &gt; &gt; you provide the exact kernel version and post=
 the vmcore somewhere?<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Brian<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Thanks // Hugo<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; =E2=80=8B<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; 2015-06-18 22:59 GMT+08:00 Eric Sandeen =
&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; On 6/18/15 9:29 AM, Kuo Hugo wrote:=
<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;&gt;- Have you tried an &#39;xf=
s_repair -n&#39; of the affected<br>
&gt; &gt; filesystem?<br>
&gt; &gt; &gt; &gt; Note<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; that -n will report problems only a=
nd prevent any modification<br>
&gt; &gt; by<br>
&gt; &gt; &gt; &gt; &gt; &gt; repair.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; *We might to to xfs_repair if =
we can address which disk<br>
&gt; &gt; causes<br>
&gt; &gt; &gt; &gt; the<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; issue. *<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; If you do, please save the output, =
and if it finds anything,<br>
&gt; &gt; please<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; provide the output in this thread.<=
br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt; -Eric<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; ________________________________________=
_______<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; xfs mailing list<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@o=
ss.sgi.com</a><br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; <a href=3D"http://oss.sgi.com/mailman/li=
stinfo/xfs" rel=3D"noreferrer" target=3D"_blank">http://oss.sgi.com/mailman=
/listinfo/xfs</a><br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt;<br>
<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</div></div></blockquote></div><br></div>

--047d7bfcf2f605e065051ac23bc2--


--===============6298729062421663666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6298729062421663666==--
