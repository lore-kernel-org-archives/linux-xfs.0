Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 702EC7F37
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 11:25:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5747F304048
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 09:25:45 -0700 (PDT)
Received: from mail-wg0-f53.google.com (mail-wg0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id NJAb9n01gvxSg6Ox
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2015 09:25:42 -0700 (PDT)
Received: by wgmn9 with SMTP id n9so383600wgm.0
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2015 09:25:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA++_uhve5gEuH6K1sFPNrHwi7=FQogM6K4v7dEnUL3SqUYiYMg@mail.gmail.com>
References: <CA++_uht_4ON49eBqM6eA7oL7iBcxYMwR5ZAQxXmTuNji2XiyBA@mail.gmail.com>
	<20150618133122.GC43254@bfoster.bfoster>
	<CA++_uhuLbTT32v4ZeVkP3WOjBEeMU0O1NZDcv66a67hZ=pj9Sw@mail.gmail.com>
	<5582DCDA.9070200@sandeen.net>
	<CA++_uhuFL0DhwH3ENBHmFmzmBm5SGx45P9tqVTEdj-bCsHBSVA@mail.gmail.com>
	<20150709125119.GC63282@bfoster.bfoster>
	<CA++_uhuoQ76uOUikbetw5ocfHDGAFMERcbgX9R4Shha2GUxWmQ@mail.gmail.com>
	<20150709151811.GE63282@bfoster.bfoster>
	<CA++_uhu=VNKtjax_JjsCZwDFT0Vk-CAjS5j=ba5+A5HL4nxpmA@mail.gmail.com>
	<20150709183255.GG63282@bfoster.bfoster>
	<CA++_uht5N6MtqUQfbB9A3R__UvR4aLN2q5-mFKiO__vU-Cxwpw@mail.gmail.com>
	<CA++_uhve5gEuH6K1sFPNrHwi7=FQogM6K4v7dEnUL3SqUYiYMg@mail.gmail.com>
Date: Sat, 11 Jul 2015 00:25:40 +0800
Message-ID: <CA++_uhu6xtRoDZyfrSxNh7H=+jq+QCPGV5zPf_44PJakhcZzkg@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2487153130178042725=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: Hugo Kuo <hugo@swiftstack.com>, Eric Sandeen <sandeen@sandeen.net>, Darrell Bishop <darrell@swiftstack.com>, xfs@oss.sgi.com

--===============2487153130178042725==
Content-Type: multipart/related; boundary=f46d044402b4ab5a24051a87d248

--f46d044402b4ab5a24051a87d248
Content-Type: multipart/alternative; boundary=f46d044402b4ab5a22051a87d246

--f46d044402b4ab5a22051a87d246
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Finally got the results of xfs_repair -n on all disks for this server.
There's no any warning or error from my observation.

https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/r2obj01.burton.com-xf=
s-repair-n.txt

Thanks // Hugo

2015-07-10 18:39 GMT+08:00 Kuo Hugo <tonytkdk@gmail.com>:

> We observed this message this morning on the node. Is it possible a
> related issue?
>
>
> =E2=80=8B
>
> 2015-07-10 13:36 GMT+08:00 Kuo Hugo <tonytkdk@gmail.com>:
>
>> Hi Brain,
>>
>> Is this the file which you need ?
>>
>> https://cloud.swiftstack.com/v1/AUTH_hugo/public/xfs.ko
>>
>> $> modinfo xfs
>>
>> filename: /lib/modules/2.6.32-504.23.4.el6.x86_64/kernel/fs/xfs/xfs.ko
>> license: GPL
>> description: SGI XFS with ACLs, security attributes, large block/inode n=
umbers, no debug enabled
>> author: Silicon Graphics, Inc.
>> srcversion: 0C1B17926BDDA4F121479EE
>> depends: exportfs
>> vermagic: 2.6.32-504.23.4.el6.x86_64 SMP mod_unload modversion
>>
>> Thanks // Hugo
>> =E2=80=8B
>>
>> 2015-07-10 2:32 GMT+08:00 Brian Foster <bfoster@redhat.com>:
>>
>>> On Fri, Jul 10, 2015 at 12:40:00AM +0800, Kuo Hugo wrote:
>>> > Hi Brain,
>>> >
>>> > There you go.
>>> >
>>> > https://cloud.swiftstack.com/v1/AUTH_hugo/public/vmlinux
>>> >
>>> https://cloud.swiftstack.com/v1/AUTH_hugo/public/System.map-2.6.32-504.=
23.4.el6.x86_64
>>> >
>>> > $ md5sum vmlinux
>>> > 82aaa694a174c0a29e78c05e73adf5d8  vmlinux
>>> >
>>> > Yes, I can read it with this vmlinux image. Put all files
>>> > (vmcore,vmlinux,System.map) in a folder and run $crash vmlinux vmcore
>>> >
>>>
>>> Thanks, I can actually load that up now. Note that we'll probably need
>>> the modules and whatnot (xfs.ko) also to be able to look at any XFS
>>> bits. It might be easiest to just tar up and compress whatever director=
y
>>> structure has the debug-enabled vmlinux and all the kernel modules.
>>> Thanks.
>>>
>>> Brian
>>>
>>> > Hugo
>>> > =E2=80=8B
>>> >
>>> > 2015-07-09 23:18 GMT+08:00 Brian Foster <bfoster@redhat.com>:
>>> >
>>> > > On Thu, Jul 09, 2015 at 09:20:00PM +0800, Kuo Hugo wrote:
>>> > > > Hi Brian,
>>> > > >
>>> > > > *Operating System Version:*
>>> > > > Linux-2.6.32-504.23.4.el6.x86_64-x86_64-with-centos-6.6-Final
>>> > > >
>>> > > > *NODE 1*
>>> > > >
>>> > > > https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore
>>> > > >
>>> https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt
>>> > > >
>>> > > >
>>> > > > *NODE 2*
>>> > > >
>>> > > >
>>> https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore_r2obj02
>>> > > >
>>> > >
>>> https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg_r2ob=
j02.txt
>>> > > >
>>> > > >
>>> > > > Any thoughts would be appreciate
>>> > > >
>>> > >
>>> > > I'm not able to fire up crash with these core files and the kernel
>>> debug
>>> > > info from the following centos kernel debuginfo package:
>>> > >
>>> > > kernel-debuginfo-2.6.32-504.23.4.el6.centos.plus.x86_64.rpm
>>> > >
>>> > > It complains about a version mismatch between the vmlinux and core
>>> file.
>>> > > I'm no crash expert... are you sure the cores above correspond to
>>> this
>>> > > kernel? Does crash load up for you on said box if you run something
>>> like
>>> > > the following?
>>> > >
>>> > >         crash /usr/lib/debug/lib/modules/.../vmlinux vmcore
>>> > >
>>> > > Note that you might need to install the above kernel-debuginfo
>>> package
>>> > > to get the debug (vmlinux) file. If so, could you also upload that
>>> > > debuginfo rpm somewhere?
>>> > >
>>> > > Brian
>>> > >
>>> > > > Thanks // Hugo
>>> > > >
>>> > > >
>>> > > > 2015-07-09 20:51 GMT+08:00 Brian Foster <bfoster@redhat.com>:
>>> > > >
>>> > > > > On Thu, Jul 09, 2015 at 06:57:55PM +0800, Kuo Hugo wrote:
>>> > > > > > Hi Folks,
>>> > > > > >
>>> > > > > > As the results of 32 disks with xfs_repair -n seems no any
>>> error
>>> > > shows
>>> > > > > up.
>>> > > > > > We currently tried to deploy CentOS 6.6 for testing. (The
>>> previous
>>> > > kernel
>>> > > > > > panic was came from Ubuntu).
>>> > > > > > The CentOS nodes encountered kernel panic with same daemon bu=
t
>>> the
>>> > > > > problem
>>> > > > > > may a bit differ.
>>> > > > > >
>>> > > > > >    - It was broken on xfs_dir2_sf_get_parent_ino+0xa/0x20 in
>>> Ubuntu.
>>> > > > > >    - Here=E2=80=99s the log in CentOS. It=E2=80=99s broken on
>>> > > > > >    xfs_dir2_sf_getdents+0x2a0/0x3a0
>>> > > > > >
>>> > > > >
>>> > > > > I'd venture to guess it's the same behavior here. The previous
>>> kernel
>>> > > > > had a callback for the parent inode number that was called via
>>> > > > > xfs_dir2_sf_getdents(). Taking a look at a 6.6 kernel, it has a
>>> static
>>> > > > > inline here instead.
>>> > > > >
>>> > > > > > <1>BUG: unable to handle kernel NULL pointer dereference at
>>> > > > > 0000000000000001
>>> > > > > > <1>IP: [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3a0
>>> [xfs]
>>> > > > > > <4>PGD 1072327067 PUD 1072328067 PMD 0
>>> > > > > > <4>Oops: 0000 [#1] SMP
>>> > > > > > <4>last sysfs file:
>>> > > > > >
>>> > > > >
>>> > >
>>> /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:1/expa=
nder-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/block/sdz=
/queue/rotational
>>> > > > > > <4>CPU 17
>>> > > > > > <4>Modules linked in: xt_conntrack tun xfs exportfs
>>> iptable_filter
>>> > > > > > ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrac=
k
>>> > > > > > nf_defrag_ipv4 ip_tables ip_vs ipv6 libcrc32c iTCO_wdt
>>> > > > > > iTCO_vendor_support ses enclosure igb i2c_algo_bit sb_edac
>>> edac_core
>>> > > > > > i2c_i801 i2c_core sg shpchp lpc_ich mfd_core ixgbe dca ptp
>>> pps_core
>>> > > > > > mdio power_meter acpi_ipmi ipmi_si ipmi_msghandler ext4 jbd2
>>> mbcache
>>> > > > > > sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_class
>>> xhci_hcd ahci
>>> > > > > > wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded:
>>> > > > > > scsi_wait_scan]
>>> > > > > > <4>
>>> > > > > > <4>Pid: 4454, comm: swift-object-se Not tainted
>>> > > > > > 2.6.32-504.23.4.el6.x86_64 #1 Silicon Mechanics Storform
>>> > > > > > R518.v5P/X10DRi-T4+
>>> > > > > > <4>RIP: 0010:[<ffffffffa0362d60>]  [<ffffffffa0362d60>]
>>> > > > > > xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]
>>> > > > > > <4>RSP: 0018:ffff880871f6de18  EFLAGS: 00010202
>>> > > > > > <4>RAX: 0000000000000000 RBX: 0000000000000004 RCX:
>>> 0000000000000000
>>> > > > > > <4>RDX: 0000000000000001 RSI: 0000000000000000 RDI:
>>> 00007faa74006203
>>> > > > > > <4>RBP: ffff880871f6de68 R08: 000000032eb04bc9 R09:
>>> 0000000000000004
>>> > > > > > <4>R10: 0000000000008030 R11: 0000000000000246 R12:
>>> 0000000000000000
>>> > > > > > <4>R13: 0000000000000002 R14: ffff88106eff7000 R15:
>>> ffff8808715b4580
>>> > > > > > <4>FS:  00007faa85425700(0000) GS:ffff880028360000(0000)
>>> > > > > knlGS:0000000000000000
>>> > > > > > <4>CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> > > > > > <4>CR2: 0000000000000001 CR3: 0000001072325000 CR4:
>>> 00000000001407e0
>>> > > > > > <4>DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>> 0000000000000000
>>> > > > > > <4>DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>>> 0000000000000400
>>> > > > > > <4>Process swift-object-se (pid: 4454, threadinfo
>>> ffff880871f6c000,
>>> > > > > > task ffff880860f18ab0)
>>> > > > > > <4>Stack:
>>> > > > > > <4> ffff880871f6de28 ffffffff811a4bb0 ffff880871f6df38
>>> > > ffff880874749cc0
>>> > > > > > <4><d> 0000000100000103 ffff8802381f8c00 ffff880871f6df38
>>> > > > > ffff8808715b4580
>>> > > > > > <4><d> 0000000000000082 ffff8802381f8d88 ffff880871f6dec8
>>> > > > > ffffffffa035ab31
>>> > > > > > <4>Call Trace:
>>> > > > > > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
>>> > > > > > <4> [<ffffffffa035ab31>] xfs_readdir+0xe1/0x130 [xfs]
>>> > > > > > <4> [<ffffffff811a4bb0>] ? filldir+0x0/0xe0
>>> > > > > > <4> [<ffffffffa038fe29>] xfs_file_readdir+0x39/0x50 [xfs]
>>> > > > > > <4> [<ffffffff811a4e30>] vfs_readdir+0xc0/0xe0
>>> > > > > > <4> [<ffffffff8119bd86>] ? final_putname+0x26/0x50
>>> > > > > > <4> [<ffffffff811a4fb9>] sys_getdents+0x89/0xf0
>>> > > > > > <4> [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
>>> > > > > > <4>Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48 8b 7d c0 ff 55 b=
8
>>> 85 c0
>>> > > > > > 0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f 84 00 00 0=
0
>>> 00 00
>>> > > > > > <41> 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f b6 44 24 03 41 0f
>>> b6
>>> > > > > > <1>RIP  [<ffffffffa0362d60>] xfs_dir2_sf_getdents+0x2a0/0x3a0
>>> [xfs]
>>> > > > > > <4> RSP <ffff880871f6de18>
>>> > > > > > <4>CR2: 0000000000000001
>>> > > > > >
>>> > > > > ...
>>> > > > > >
>>> > > > > > I=E2=80=99ve got the vmcore dump from operator. Does vmcore h=
elp for
>>> > > > > > troubleshooting kind issue ?
>>> > > > > >
>>> > > > >
>>> > > > > Hmm, well it couldn't hurt. Is the vmcore based on this 6.6
>>> kernel? Can
>>> > > > > you provide the exact kernel version and post the vmcore
>>> somewhere?
>>> > > > >
>>> > > > > Brian
>>> > > > >
>>> > > > > > Thanks // Hugo
>>> > > > > > =E2=80=8B
>>> > > > > >
>>> > > > > > 2015-06-18 22:59 GMT+08:00 Eric Sandeen <sandeen@sandeen.net>=
:
>>> > > > > >
>>> > > > > > > On 6/18/15 9:29 AM, Kuo Hugo wrote:
>>> > > > > > > >>- Have you tried an 'xfs_repair -n' of the affected
>>> filesystem?
>>> > > Note
>>> > > > > > > that -n will report problems only and prevent any
>>> modification by
>>> > > > > repair.
>>> > > > > > > >
>>> > > > > > > > *We might to to xfs_repair if we can address which disk
>>> causes
>>> > > the
>>> > > > > > > issue. *
>>> > > > > > >
>>> > > > > > > If you do, please save the output, and if it finds anything=
,
>>> please
>>> > > > > > > provide the output in this thread.
>>> > > > > > >
>>> > > > > > > Thanks,
>>> > > > > > > -Eric
>>> > > > > > >
>>> > > > >
>>> > > > > > _______________________________________________
>>> > > > > > xfs mailing list
>>> > > > > > xfs@oss.sgi.com
>>> > > > > > http://oss.sgi.com/mailman/listinfo/xfs
>>> > > > >
>>> > > > >
>>> > >
>>>
>>
>>
>

--f46d044402b4ab5a22051a87d246
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Finally got the results of xfs_repair -n on all disks=
 for this server. There&#39;s no any warning or error from my observation.=
=C2=A0</div><div><br></div><a href=3D"https://cloud.swiftstack.com/v1/AUTH_=
burton/brtnswift/r2obj01.burton.com-xfs-repair-n.txt">https://cloud.swiftst=
ack.com/v1/AUTH_burton/brtnswift/r2obj01.burton.com-xfs-repair-n.txt</a><br=
><div><br></div><div>Thanks // Hugo=C2=A0</div></div><div class=3D"gmail_ex=
tra"><br><div class=3D"gmail_quote">2015-07-10 18:39 GMT+08:00 Kuo Hugo <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:tonytkdk@gmail.com" target=3D"_blank">=
tonytkdk@gmail.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div d=
ir=3D"ltr"><div>We observed this message this morning on the node. Is it po=
ssible a related issue?=C2=A0</div><div><br></div><img src=3D"cid:ii_ibxhpv=
g20_14e778b73ba749a4" width=3D"520" height=3D"324"><br>=E2=80=8B<br></div><=
div class=3D"HOEnZb"><div class=3D"h5"><div class=3D"gmail_extra"><br><div =
class=3D"gmail_quote">2015-07-10 13:36 GMT+08:00 Kuo Hugo <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:tonytkdk@gmail.com" target=3D"_blank">tonytkdk@gmail=
.com</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0=
 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><di=
v><p style=3D"margin:0px 0px 1.2em!important">Hi Brain, </p>
<p style=3D"margin:0px 0px 1.2em!important">Is this the file which you need=
  ? </p>
<p style=3D"margin:0px 0px 1.2em!important"><a href=3D"https://cloud.swifts=
tack.com/v1/AUTH_hugo/public/xfs.ko" target=3D"_blank">https://cloud.swifts=
tack.com/v1/AUTH_hugo/public/xfs.ko</a></p>
<p style=3D"margin:0px 0px 1.2em!important">$&gt; modinfo xfs </p>
<pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mon=
ospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"fon=
t-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px=
 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234=
,234);border-radius:3px;display:inline;background-color:rgb(248,248,248);wh=
ite-space:pre-wrap;overflow:auto;border-radius:3px;border:1px solid rgb(204=
,204,204);padding:0.5em 0.7em;display:block!important">filename: /lib/modul=
es/2.6.32-504.23.4.el6.x86_64/kernel/fs/xfs/xfs.ko=20
license: GPL=20
description: SGI XFS with ACLs, security attributes, large block/inode numb=
ers, no debug enabled=20
author: Silicon Graphics, Inc.=20
srcversion: 0C1B17926BDDA4F121479EE=20
depends: exportfs=20
vermagic: 2.6.32-504.23.4.el6.x86_64 SMP mod_unload modversion
</code></pre><p style=3D"margin:0px 0px 1.2em!important">Thanks // Hugo </p=
>
<div title=3D"MDH:SGkgQnJhaW4swqA8ZGl2Pjxicj48L2Rpdj48ZGl2PklzIHRoaXMgdGhlI=
GZpbGUgd2hpY2ggeW91
IG5lZWQgJm5ic3A7PyZuYnNwOzwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+aHR0cHM6Ly9jbG9=
1
ZC5zd2lmdHN0YWNrLmNvbS92MS9BVVRIX2h1Z28vcHVibGljL3hmcy5rbzxicj48L2Rpdj48ZGl=
2
Pjxicj48L2Rpdj4kJmd0OyBtb2RpbmZvIHhmcyA8YnI+PGJyPmBgYDxicj48ZGl2PmZpbGVuYW1=
l
OiAvbGliL21vZHVsZXMvMi42LjMyLTUwNC4yMy40LmVsNi54ODZfNjQva2VybmVsL2ZzL3hmcy9=
4
ZnMua28gPGJyPmxpY2Vuc2U6IEdQTCA8YnI+ZGVzY3JpcHRpb246IFNHSSBYRlMgd2l0aCBBQ0x=
z
LCBzZWN1cml0eSBhdHRyaWJ1dGVzLCBsYXJnZSBibG9jay9pbm9kZSBudW1iZXJzLCBubyBkZWJ=
1
ZyBlbmFibGVkIDxicj5hdXRob3I6IFNpbGljb24gR3JhcGhpY3MsIEluYy4gPGJyPnNyY3ZlcnN=
p
b246IDBDMUIxNzkyNkJEREE0RjEyMTQ3OUVFIDxicj5kZXBlbmRzOiBleHBvcnRmcyA8YnI+dmV=
y
bWFnaWM6IDIuNi4zMi01MDQuMjMuNC5lbDYueDg2XzY0IFNNUCBtb2RfdW5sb2FkIG1vZHZlcnN=
p
b248L2Rpdj48ZGl2PmBgYDwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+VGhhbmtzIC8vIEh1Z28=
m
bmJzcDs8L2Rpdj4=3D" style=3D"min-height:0;width:0;max-height:0;max-width:0;=
overflow:hidden;font-size:0em;padding:0;margin:0">=E2=80=8B</div></div></di=
v><div><div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">2015-=
07-10 2:32 GMT+08:00 Brian Foster <span dir=3D"ltr">&lt;<a href=3D"mailto:b=
foster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;</span>:<br>=
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><span>On Fri, Jul 10, 2015 at 12:40:00AM +08=
00, Kuo Hugo wrote:<br>
&gt; Hi Brain,<br>
&gt;<br>
&gt; There you go.<br>
&gt;<br>
&gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/public/vmlinux" r=
el=3D"noreferrer" target=3D"_blank">https://cloud.swiftstack.com/v1/AUTH_hu=
go/public/vmlinux</a><br>
&gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_hugo/public/System.map=
-2.6.32-504.23.4.el6.x86_64" rel=3D"noreferrer" target=3D"_blank">https://c=
loud.swiftstack.com/v1/AUTH_hugo/public/System.map-2.6.32-504.23.4.el6.x86_=
64</a><br>
&gt;<br>
&gt; $ md5sum vmlinux<br>
&gt; 82aaa694a174c0a29e78c05e73adf5d8=C2=A0 vmlinux<br>
&gt;<br>
&gt; Yes, I can read it with this vmlinux image. Put all files<br>
&gt; (vmcore,vmlinux,System.map) in a folder and run $crash vmlinux vmcore<=
br>
&gt;<br>
<br>
</span>Thanks, I can actually load that up now. Note that we&#39;ll probabl=
y need<br>
the modules and whatnot (xfs.ko) also to be able to look at any XFS<br>
bits. It might be easiest to just tar up and compress whatever directory<br=
>
structure has the debug-enabled vmlinux and all the kernel modules.<br>
Thanks.<br>
<span><font color=3D"#888888"><br>
Brian<br>
</font></span><div><div><br>
&gt; Hugo<br>
&gt; =E2=80=8B<br>
&gt;<br>
&gt; 2015-07-09 23:18 GMT+08:00 Brian Foster &lt;<a href=3D"mailto:bfoster@=
redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;:<br>
&gt;<br>
&gt; &gt; On Thu, Jul 09, 2015 at 09:20:00PM +0800, Kuo Hugo wrote:<br>
&gt; &gt; &gt; Hi Brian,<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; *Operating System Version:*<br>
&gt; &gt; &gt; Linux-2.6.32-504.23.4.el6.x86_64-x86_64-with-centos-6.6-Fina=
l<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; *NODE 1*<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtns=
wift/vmcore" rel=3D"noreferrer" target=3D"_blank">https://cloud.swiftstack.=
com/v1/AUTH_burton/brtnswift/vmcore</a><br>
&gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtns=
wift/vmcore-dmesg.txt" rel=3D"noreferrer" target=3D"_blank">https://cloud.s=
wiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg.txt</a><br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; *NODE 2*<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtns=
wift/vmcore_r2obj02" rel=3D"noreferrer" target=3D"_blank">https://cloud.swi=
ftstack.com/v1/AUTH_burton/brtnswift/vmcore_r2obj02</a><br>
&gt; &gt; &gt;<br>
&gt; &gt; <a href=3D"https://cloud.swiftstack.com/v1/AUTH_burton/brtnswift/=
vmcore-dmesg_r2obj02.txt" rel=3D"noreferrer" target=3D"_blank">https://clou=
d.swiftstack.com/v1/AUTH_burton/brtnswift/vmcore-dmesg_r2obj02.txt</a><br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Any thoughts would be appreciate<br>
&gt; &gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; I&#39;m not able to fire up crash with these core files and the k=
ernel debug<br>
&gt; &gt; info from the following centos kernel debuginfo package:<br>
&gt; &gt;<br>
&gt; &gt; kernel-debuginfo-2.6.32-504.23.4.el6.centos.plus.x86_64.rpm<br>
&gt; &gt;<br>
&gt; &gt; It complains about a version mismatch between the vmlinux and cor=
e file.<br>
&gt; &gt; I&#39;m no crash expert... are you sure the cores above correspon=
d to this<br>
&gt; &gt; kernel? Does crash load up for you on said box if you run somethi=
ng like<br>
&gt; &gt; the following?<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0crash /usr/lib/debug/lib/modules=
/.../vmlinux vmcore<br>
&gt; &gt;<br>
&gt; &gt; Note that you might need to install the above kernel-debuginfo pa=
ckage<br>
&gt; &gt; to get the debug (vmlinux) file. If so, could you also upload tha=
t<br>
&gt; &gt; debuginfo rpm somewhere?<br>
&gt; &gt;<br>
&gt; &gt; Brian<br>
&gt; &gt;<br>
&gt; &gt; &gt; Thanks // Hugo<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; 2015-07-09 20:51 GMT+08:00 Brian Foster &lt;<a href=3D"mailt=
o:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; On Thu, Jul 09, 2015 at 06:57:55PM +0800, Kuo Hugo wrot=
e:<br>
&gt; &gt; &gt; &gt; &gt; Hi Folks,<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; As the results of 32 disks with xfs_repair -n seem=
s no any error<br>
&gt; &gt; shows<br>
&gt; &gt; &gt; &gt; up.<br>
&gt; &gt; &gt; &gt; &gt; We currently tried to deploy CentOS 6.6 for testin=
g. (The previous<br>
&gt; &gt; kernel<br>
&gt; &gt; &gt; &gt; &gt; panic was came from Ubuntu).<br>
&gt; &gt; &gt; &gt; &gt; The CentOS nodes encountered kernel panic with sam=
e daemon but the<br>
&gt; &gt; &gt; &gt; problem<br>
&gt; &gt; &gt; &gt; &gt; may a bit differ.<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 - It was broken on xfs_dir2_sf_get_pa=
rent_ino+0xa/0x20 in Ubuntu.<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 - Here=E2=80=99s the log in CentOS. I=
t=E2=80=99s broken on<br>
&gt; &gt; &gt; &gt; &gt;=C2=A0 =C2=A0 xfs_dir2_sf_getdents+0x2a0/0x3a0<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; I&#39;d venture to guess it&#39;s the same behavior her=
e. The previous kernel<br>
&gt; &gt; &gt; &gt; had a callback for the parent inode number that was cal=
led via<br>
&gt; &gt; &gt; &gt; xfs_dir2_sf_getdents(). Taking a look at a 6.6 kernel, =
it has a static<br>
&gt; &gt; &gt; &gt; inline here instead.<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &lt;1&gt;BUG: unable to handle kernel NULL pointer=
 dereference at<br>
&gt; &gt; &gt; &gt; 0000000000000001<br>
&gt; &gt; &gt; &gt; &gt; &lt;1&gt;IP: [&lt;ffffffffa0362d60&gt;] xfs_dir2_s=
f_getdents+0x2a0/0x3a0 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;PGD 1072327067 PUD 1072328067 PMD 0<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;Oops: 0000 [#1] SMP<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;last sysfs file:<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; /sys/devices/pci0000:80/0000:80:03.2/0000:83:00.0/host10/port-10:=
1/expander-10:1/port-10:1:16/end_device-10:1:16/target10:0:25/10:0:25:0/blo=
ck/sdz/queue/rotational<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;CPU 17<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;Modules linked in: xt_conntrack tun xfs e=
xportfs iptable_filter<br>
&gt; &gt; &gt; &gt; &gt; ipt_REDIRECT iptable_nat nf_nat nf_conntrack_ipv4 =
nf_conntrack<br>
&gt; &gt; &gt; &gt; &gt; nf_defrag_ipv4 ip_tables ip_vs ipv6 libcrc32c iTCO=
_wdt<br>
&gt; &gt; &gt; &gt; &gt; iTCO_vendor_support ses enclosure igb i2c_algo_bit=
 sb_edac edac_core<br>
&gt; &gt; &gt; &gt; &gt; i2c_i801 i2c_core sg shpchp lpc_ich mfd_core ixgbe=
 dca ptp pps_core<br>
&gt; &gt; &gt; &gt; &gt; mdio power_meter acpi_ipmi ipmi_si ipmi_msghandler=
 ext4 jbd2 mbcache<br>
&gt; &gt; &gt; &gt; &gt; sd_mod crc_t10dif mpt3sas scsi_transport_sas raid_=
class xhci_hcd ahci<br>
&gt; &gt; &gt; &gt; &gt; wmi dm_mirror dm_region_hash dm_log dm_mod [last u=
nloaded:<br>
&gt; &gt; &gt; &gt; &gt; scsi_wait_scan]<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;Pid: 4454, comm: swift-object-se Not tain=
ted<br>
&gt; &gt; &gt; &gt; &gt; 2.6.32-504.23.4.el6.x86_64 #1 Silicon Mechanics St=
orform<br>
&gt; &gt; &gt; &gt; &gt; R518.v5P/X10DRi-T4+<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;RIP: 0010:[&lt;ffffffffa0362d60&gt;]=C2=
=A0 [&lt;ffffffffa0362d60&gt;]<br>
&gt; &gt; &gt; &gt; &gt; xfs_dir2_sf_getdents+0x2a0/0x3a0 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;RSP: 0018:ffff880871f6de18=C2=A0 EFLAGS: =
00010202<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;RAX: 0000000000000000 RBX: 00000000000000=
04 RCX: 0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;RDX: 0000000000000001 RSI: 00000000000000=
00 RDI: 00007faa74006203<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;RBP: ffff880871f6de68 R08: 000000032eb04b=
c9 R09: 0000000000000004<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;R10: 0000000000008030 R11: 00000000000002=
46 R12: 0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;R13: 0000000000000002 R14: ffff88106eff70=
00 R15: ffff8808715b4580<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;FS:=C2=A0 00007faa85425700(0000) GS:ffff8=
80028360000(0000)<br>
&gt; &gt; &gt; &gt; knlGS:0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000=
0000080050033<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;CR2: 0000000000000001 CR3: 00000010723250=
00 CR4: 00000000001407e0<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;DR0: 0000000000000000 DR1: 00000000000000=
00 DR2: 0000000000000000<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;DR3: 0000000000000000 DR6: 00000000ffff0f=
f0 DR7: 0000000000000400<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;Process swift-object-se (pid: 4454, threa=
dinfo ffff880871f6c000,<br>
&gt; &gt; &gt; &gt; &gt; task ffff880860f18ab0)<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;Stack:<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; ffff880871f6de28 ffffffff811a4bb0 ffff88=
0871f6df38<br>
&gt; &gt; ffff880874749cc0<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;&lt;d&gt; 0000000100000103 ffff8802381f8c=
00 ffff880871f6df38<br>
&gt; &gt; &gt; &gt; ffff8808715b4580<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;&lt;d&gt; 0000000000000082 ffff8802381f8d=
88 ffff880871f6dec8<br>
&gt; &gt; &gt; &gt; ffffffffa035ab31<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;Call Trace:<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? filldir+0x0=
/0xe0<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffffa035ab31&gt;] xfs_readdir+0=
xe1/0x130 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4bb0&gt;] ? filldir+0x0=
/0xe0<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffffa038fe29&gt;] xfs_file_read=
dir+0x39/0x50 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4e30&gt;] vfs_readdir+0=
xc0/0xe0<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff8119bd86&gt;] ? final_putna=
me+0x26/0x50<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff811a4fb9&gt;] sys_getdents+=
0x89/0xf0<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; [&lt;ffffffff8100b0f2&gt;] system_call_f=
astpath+0x16/0x1b<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;Code: 01 00 00 00 48 c7 c6 38 6b 3a a0 48=
 8b 7d c0 ff 55 b8 85 c0<br>
&gt; &gt; &gt; &gt; &gt; 0f 85 af 00 00 00 49 8b 37 e9 ec fd ff ff 66 0f 1f=
 84 00 00 00 00 00<br>
&gt; &gt; &gt; &gt; &gt; &lt;41&gt; 80 7c 24 01 00 0f 84 9c 00 00 00 45 0f =
b6 44 24 03 41 0f b6<br>
&gt; &gt; &gt; &gt; &gt; &lt;1&gt;RIP=C2=A0 [&lt;ffffffffa0362d60&gt;] xfs_=
dir2_sf_getdents+0x2a0/0x3a0 [xfs]<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt; RSP &lt;ffff880871f6de18&gt;<br>
&gt; &gt; &gt; &gt; &gt; &lt;4&gt;CR2: 0000000000000001<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; ...<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; I=E2=80=99ve got the vmcore dump from operator. Do=
es vmcore help for<br>
&gt; &gt; &gt; &gt; &gt; troubleshooting kind issue ?<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Hmm, well it couldn&#39;t hurt. Is the vmcore based on =
this 6.6 kernel? Can<br>
&gt; &gt; &gt; &gt; you provide the exact kernel version and post the vmcor=
e somewhere?<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; Brian<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; Thanks // Hugo<br>
&gt; &gt; &gt; &gt; &gt; =E2=80=8B<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; 2015-06-18 22:59 GMT+08:00 Eric Sandeen &lt;<a hre=
f=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&=
gt;:<br>
&gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; On 6/18/15 9:29 AM, Kuo Hugo wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;&gt;- Have you tried an &#39;xfs_repair -=
n&#39; of the affected filesystem?<br>
&gt; &gt; Note<br>
&gt; &gt; &gt; &gt; &gt; &gt; that -n will report problems only and prevent=
 any modification by<br>
&gt; &gt; &gt; &gt; repair.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; *We might to to xfs_repair if we can add=
ress which disk causes<br>
&gt; &gt; the<br>
&gt; &gt; &gt; &gt; &gt; &gt; issue. *<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; If you do, please save the output, and if it =
finds anything, please<br>
&gt; &gt; &gt; &gt; &gt; &gt; provide the output in this thread.<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; &gt; Thanks,<br>
&gt; &gt; &gt; &gt; &gt; &gt; -Eric<br>
&gt; &gt; &gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt; &gt; _______________________________________________<br=
>
&gt; &gt; &gt; &gt; &gt; xfs mailing list<br>
&gt; &gt; &gt; &gt; &gt; <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blan=
k">xfs@oss.sgi.com</a><br>
&gt; &gt; &gt; &gt; &gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs=
" rel=3D"noreferrer" target=3D"_blank">http://oss.sgi.com/mailman/listinfo/=
xfs</a><br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt; &gt; &gt;<br>
&gt; &gt;<br>
</div></div></blockquote></div><br></div>
</div></div></blockquote></div><br></div>
</div></div></blockquote></div><br></div>

--f46d044402b4ab5a22051a87d246--

--f46d044402b4ab5a24051a87d248
Content-Type: image/png; name="r2obj01_sdh_xfs_error.png"
Content-Disposition: inline; filename="r2obj01_sdh_xfs_error.png"
Content-Transfer-Encoding: base64
Content-ID: <ii_ibxhpvg20_14e778b73ba749a4>
X-Attachment-Id: ii_ibxhpvg20_14e778b73ba749a4

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
Dueoz/VBp1bywvgnrIpQv7Erl89xcKtO0PPfFZnukupbcqrPCPqBVP/tI6k+k/lHQV7Pzqq2587K
clLd6j2S6hwtx4bYx89BoNEG+3v1+Sr6XpPq5nFYKN9+/uv/eP9xI2Ijyj//+88fPmgXuvxhO9Vj
9uPJ3V8/bmi0d1GO/n2SqWSxK4uI2BIevxuy+672excXeu67MQ80zhpnYeA5GHiK0K5TL85SM275
vpPJsNeftH12X/2vRqr/55v7sfqsXsjsbZDDY6SaSMzv/T+vHn7+i08fc6o3f4xY2zv27nMAoXek
SB4xgGhwi47+03dEJj3a2yKF3zln4jsyxhpX2QVhQBh4jRj40NI/NlIvXiJ/G2VYfVYv+Nsnv2iH
V7xhUm31Wb1oQ5fDKhfbUkrwPX7nz07yuLPjkeVwINXWuN/9v18960fkWCRBGBAGhAFhQBgQBoSB
N4eBj/7y0we7+c8it2/qx+qzejHOP/87O8CiBWNboPZN/Vh9Xm84LG+DHIJUv7lw/ZtcGlBdGldh
QBgQBoQBYUAYuGcMWP6zEUqL1L6pH6vP6oVcLYJtBNcix2/qx+qzensb3gI5iFS/wfyfe57U6puM
ljAgDAgDwoAwIAx8lzHwSKptx6Z+JANhQBgQBoQBYUAYEAaEAWHgWRgQqRZwngUcOWFyRIUBYUAY
EAaEAWFAGHjCQCfVs+sq9bkkIAlIApKAJCAJSAKSgCQgCawlIFIthEgCkoAkIAlIApKAJCAJSAIX
JfBEqv+/VpJ+JANhQBgQBoQBYUAYEAaEAWHgZgyIVAs0N4NGzpccUGFAGBAGhAFhQBgQBkYMiFSL
VItUCwPCgDAgDAgDwoAwIAxcxEAn1b/5zW8e9CMZCAPCgDAgDAgDwoAwIAwIA7dj4AZS/dXDx3/w
7sO7v/P+w2cDAf/s4f3faZ//wccPX/3y/fb9uw/v/3LRkH/9+OG9H392jcDP6rGyrS32Q3V89uP4
7Hfee/j4X28T0uO70eed/r20c8J9Qt/av+/95VfXZHixnYNcLpbVJ+5rGL+3TSk8YfERkzeNI8+d
bwKLzx3nGFfu61d/+V7r/+3z8bbxDN1U6Ztb5PcSOotklzGw1Je7Mn/hNt4m55lODfmT3roZ87v9
v/DcWzcet2Bzt9+lHdmYf7ktbyXObrPpL4Nt1Sk51hh4ItX/uz1w8vPVX5ghbKT57+nZf3kksu/9
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
--f46d044402b4ab5a24051a87d248--


--===============2487153130178042725==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2487153130178042725==--
