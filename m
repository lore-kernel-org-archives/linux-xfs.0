Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E73277F56
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 06:56:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E991AC001
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 04:56:28 -0700 (PDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com
	[74.125.82.43]) by cuda.sgi.com with ESMTP id 7qH8fEGCrOSrtPAg
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Jun 2015 04:56:25 -0700 (PDT)
Received: by wgbhy7 with SMTP id hy7so61684846wgb.2
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 04:56:24 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 18 Jun 2015 19:56:24 +0800
Message-ID: <CA++_uht_4ON49eBqM6eA7oL7iBcxYMwR5ZAQxXmTuNji2XiyBA@mail.gmail.com>
Subject: Data can't be wrote to XFS RIP [<ffffffffa041a99a>]
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
Content-Type: multipart/mixed; boundary="===============8514141854886908323=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8514141854886908323==
Content-Type: multipart/alternative; boundary=047d7b4724e226d3c50518c97f21

--047d7b4724e226d3c50518c97f21
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi folks,

Recently we found the following kernel message of XFS. I don=E2=80=99t real=
ly know
how to read it in the right way to figure out the problem in the system.
Is there any known bug for
Linux-3.13.0-32-generic-x86_64-with-Ubuntu-14.04-trusty ? Or the problem is
on the swift-object-se rather than XFS itself ?

swift-object-se means swift-object-server which is a daemon handles data
from http to XFS. I can=E2=80=99t address the problem came from XFS or the =
daemon
swift-object-server.
Any idea would be appreciated.

Jun 15 09:49:30 r1obj02 kernel: [607696.798803] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000001
Jun 15 09:49:30 r1obj02 kernel: [607696.800582] IP:
[<ffffffffa041a99a>] xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]
Jun 15 09:49:30 r1obj02 kernel: [607696.802230] PGD 1046c6c067 PUD
1044eba067 PMD 0
Jun 15 09:49:30 r1obj02 kernel: [607696.803308] Oops: 0000 [#1] SMP
Jun 15 09:49:30 r1obj02 kernel: [607696.804058] Modules linked in:
xt_conntrack xfs xt_REDIRECT iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_tcpudp iptable_filter ip_tables
x_tables x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ip_vs aesni_intel
aes_x86_64 gpio_ich lrw nf_conntrack gf128mul libcrc32c mei_me
glue_helper sb_edac ablk_helper cryptd edac_core joydev mei lpc_ich
ioatdma lp ipmi_si shpchp wmi mac_hid parport ses enclosure
hid_generic igb usbhid ixgbe mpt2sas ahci hid i2c_algo_bit libahci dca
raid_class ptp mdio scsi_transport_sas pps_core
Jun 15 09:49:30 r1obj02 kernel: [607696.817125] CPU: 13 PID: 32401
Comm: swift-object-se Not tainted 3.13.0-32-generic #57-Ubuntu
Jun 15 09:49:30 r1obj02 kernel: [607696.819020] Hardware name: Silicon
Mechanics Storform iServ R518.v4/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b
04/28/2014
Jun 15 09:49:30 r1obj02 kernel: [607696.821235] task: ffff880017d68000
ti: ffff8808e87e4000 task.ti: ffff8808e87e4000
Jun 15 09:49:30 r1obj02 kernel: [607696.822889] RIP:
0010:[<ffffffffa041a99a>] [<ffffffffa041a99a>]
xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]
Jun 15 09:49:30 r1obj02 kernel: [607696.825117] RSP:
0018:ffff8808e87e5e38 EFLAGS: 00010202
Jun 15 09:49:30 r1obj02 kernel: [607696.826296] RAX: ffffffffa0458360
RBX: 0000000000000004 RCX: 0000000000000000
Jun 15 09:49:30 r1obj02 kernel: [607696.905158] RDX: 0000000000000002
RSI: 0000000000000002 RDI: 0000000000000000
Jun 15 09:49:30 r1obj02 kernel: [607696.987107] RBP: ffff8808e87e5e88
R08: 000000020079e3b9 R09: 0000000000000004
Jun 15 09:49:30 r1obj02 kernel: [607697.069214] R10: 00000000000003e0
R11: 00000000000005b0 R12: ffff88104d0c0800
Jun 15 09:49:30 r1obj02 kernel: [607697.151676] R13: ffff8808e87e5f20
R14: ffff88004988f000 R15: 0000000000000000
Jun 15 09:49:30 r1obj02 kernel: [607697.234244] FS:
00007fe74c9fb740(0000) GS:ffff88085fce0000(0000)
knlGS:0000000000000000
Jun 15 09:49:30 r1obj02 kernel: [607697.318842] CS: 0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Jun 15 09:49:30 r1obj02 kernel: [607697.361609] CR2: 0000000000000001
CR3: 0000000bcb9b1000 CR4: 00000000001407e0
Jun 15 09:49:30 r1obj02 kernel: [607697.445360] Stack:
Jun 15 09:49:30 r1obj02 kernel: [607697.485796] ffff8808e87e5e88
ffffffffa03e2a33 ffff8808e87e5e58 ffffffff817205f9
Jun 15 09:49:30 r1obj02 kernel: [607697.567306] ffff8808e87e5eb8
ffff88084e1e6700 ffff88004988f000 ffff8808e87e5f20
Jun 15 09:49:30 r1obj02 kernel: [607697.648568] 0000000000000082
00007fe7487aa7a6 ffff8808e87e5ec0 ffffffffa03e2e0b
Jun 15 09:49:30 r1obj02 kernel: [607697.729785] Call Trace:
Jun 15 09:49:30 r1obj02 kernel: [607697.769297] [<ffffffffa03e2a33>] ?
xfs_dir2_sf_getdents+0x263/0x2a0 [xfs]
Jun 15 09:49:30 r1obj02 kernel: [607697.809560] [<ffffffff817205f9>] ?
schedule_preempt_disabled+0x29/0x70
Jun 15 09:49:30 r1obj02 kernel: [607697.849087] [<ffffffffa03e2e0b>]
xfs_readdir+0xeb/0x110 [xfs]
Jun 15 09:49:30 r1obj02 kernel: [607697.887918] [<ffffffffa03e4a3b>]
xfs_file_readdir+0x2b/0x40 [xfs]
Jun 15 09:49:30 r1obj02 kernel: [607697.926061] [<ffffffff811d0035>]
iterate_dir+0xa5/0xe0
Jun 15 09:49:30 r1obj02 kernel: [607697.963349] [<ffffffff8109ddf4>] ?
vtime_account_user+0x54/0x60
Jun 15 09:49:30 r1obj02 kernel: [607698.000413] [<ffffffff811d0492>]
SyS_getdents+0x92/0x120
Jun 15 09:49:30 r1obj02 kernel: [607698.037112] [<ffffffff811d0150>] ?
fillonedir+0xe0/0xe0
Jun 15 09:49:30 r1obj02 kernel: [607698.072867] [<ffffffff8172c81c>] ?
tracesys+0x7e/0xe6
Jun 15 09:49:30 r1obj02 kernel: [607698.107679] [<ffffffff8172c87f>]
tracesys+0xe1/0xe6
Jun 15 09:49:30 r1obj02 kernel: [607698.141543] Code: 00 48 8b 06 48
ba ff ff ff ff ff ff ff 00 5d 48 0f c8 48 21 d0 c3 66 66 2e 0f 1f 84
00 00 00 00 00 0f 1f 44 00 00 55 48 8d 77 02 <0f> b6 7f 01 48 89 e5 e8
aa ff ff ff 5d c3 0f 1f 84 00 00 00 00
Jun 15 09:49:30 r1obj02 kernel: [607698.244881] RIP
[<ffffffffa041a99a>] xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]
Jun 15 09:49:30 r1obj02 kernel: [607698.310872] RSP <ffff8808e87e5e38>
Jun 15 09:49:30 r1obj02 kernel: [607698.343092] CR2: 0000000000000001
Jun 15 09:49:30 r1obj02 kernel: [607698.420933] ---[ end trace
ba3fdf319346b7e6 ]---

Thanks // Hugo Kuo
=E2=80=8B

--047d7b4724e226d3c50518c97f21
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"markdown-here-wrapper" style><p style=3D"mar=
gin:0px 0px 1.2em!important">Hi folks, </p>
<p style=3D"margin:0px 0px 1.2em!important">Recently we found the following=
 kernel message of XFS. I don=E2=80=99t really know how to read it in the r=
ight way to figure out the problem in the system.<br>Is there any known bug=
 for <code style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Couri=
er,monospace;margin:0px 0.15em;padding:0px 0.3em;white-space:pre-wrap;borde=
r:1px solid rgb(234,234,234);border-radius:3px;display:inline;background-co=
lor:rgb(248,248,248)">Linux-3.13.0-32-generic-x86_64-with-Ubuntu-14.04-trus=
ty</code> ? Or the problem is on the <code style=3D"font-size:0.85em;font-f=
amily:Consolas,Inconsolata,Courier,monospace;margin:0px 0.15em;padding:0px =
0.3em;white-space:pre-wrap;border:1px solid rgb(234,234,234);border-radius:=
3px;display:inline;background-color:rgb(248,248,248)">swift-object-se</code=
> rather than XFS itself ? </p>
<p style=3D"margin:0px 0px 1.2em!important"><code style=3D"font-size:0.85em=
;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px 0.15em;paddi=
ng:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234,234);border-=
radius:3px;display:inline;background-color:rgb(248,248,248)">swift-object-s=
e</code> means swift-object-server which is a daemon handles data from http=
 to XFS. I can=E2=80=99t address the problem came from XFS or the daemon sw=
ift-object-server.<br>Any idea would be appreciated. </p>
<pre style=3D"font-size:0.85em;font-family:Consolas,Inconsolata,Courier,mon=
ospace;font-size:1em;line-height:1.2em;margin:1.2em 0px"><code style=3D"fon=
t-size:0.85em;font-family:Consolas,Inconsolata,Courier,monospace;margin:0px=
 0.15em;padding:0px 0.3em;white-space:pre-wrap;border:1px solid rgb(234,234=
,234);border-radius:3px;display:inline;background-color:rgb(248,248,248);wh=
ite-space:pre;overflow:auto;border-radius:3px;border:1px solid rgb(204,204,=
204);padding:0.5em 0.7em;display:block!important">Jun 15 09:49:30 r1obj02 k=
ernel: [607696.798803] BUG: unable to handle kernel NULL pointer dereferenc=
e at 0000000000000001=20
Jun 15 09:49:30 r1obj02 kernel: [607696.800582] IP: [&lt;ffffffffa041a99a&g=
t;] xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]=20
Jun 15 09:49:30 r1obj02 kernel: [607696.802230] PGD 1046c6c067 PUD 1044eba0=
67 PMD 0=20
Jun 15 09:49:30 r1obj02 kernel: [607696.803308] Oops: 0000 [#1] SMP=20
Jun 15 09:49:30 r1obj02 kernel: [607696.804058] Modules linked in: xt_connt=
rack xfs xt_REDIRECT iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ip=
v4 nf_nat xt_tcpudp iptable_filter ip_tables x_tables x86_pkg_temp_thermal =
intel_powerclamp coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash=
_clmulni_intel ip_vs aesni_intel aes_x86_64 gpio_ich lrw nf_conntrack gf128=
mul libcrc32c mei_me glue_helper sb_edac ablk_helper cryptd edac_core joyde=
v mei lpc_ich ioatdma lp ipmi_si shpchp wmi mac_hid parport ses enclosure h=
id_generic igb usbhid ixgbe mpt2sas ahci hid i2c_algo_bit libahci dca raid_=
class ptp mdio scsi_transport_sas pps_core=20
Jun 15 09:49:30 r1obj02 kernel: [607696.817125] CPU: 13 PID: 32401 Comm: sw=
ift-object-se Not tainted 3.13.0-32-generic #57-Ubuntu=20
Jun 15 09:49:30 r1obj02 kernel: [607696.819020] Hardware name: Silicon Mech=
anics Storform iServ R518.v4/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b 04/28/2014=20
Jun 15 09:49:30 r1obj02 kernel: [607696.821235] task: ffff880017d68000 ti: =
ffff8808e87e4000 task.ti: ffff8808e87e4000=20
Jun 15 09:49:30 r1obj02 kernel: [607696.822889] RIP: 0010:[&lt;ffffffffa041=
a99a&gt;] [&lt;ffffffffa041a99a&gt;] xfs_dir2_sf_get_parent_ino+0xa/0x20 [x=
fs]=20
Jun 15 09:49:30 r1obj02 kernel: [607696.825117] RSP: 0018:ffff8808e87e5e38 =
EFLAGS: 00010202=20
Jun 15 09:49:30 r1obj02 kernel: [607696.826296] RAX: ffffffffa0458360 RBX: =
0000000000000004 RCX: 0000000000000000=20
Jun 15 09:49:30 r1obj02 kernel: [607696.905158] RDX: 0000000000000002 RSI: =
0000000000000002 RDI: 0000000000000000=20
Jun 15 09:49:30 r1obj02 kernel: [607696.987107] RBP: ffff8808e87e5e88 R08: =
000000020079e3b9 R09: 0000000000000004=20
Jun 15 09:49:30 r1obj02 kernel: [607697.069214] R10: 00000000000003e0 R11: =
00000000000005b0 R12: ffff88104d0c0800=20
Jun 15 09:49:30 r1obj02 kernel: [607697.151676] R13: ffff8808e87e5f20 R14: =
ffff88004988f000 R15: 0000000000000000=20
Jun 15 09:49:30 r1obj02 kernel: [607697.234244] FS: 00007fe74c9fb740(0000) =
GS:ffff88085fce0000(0000) knlGS:0000000000000000=20
Jun 15 09:49:30 r1obj02 kernel: [607697.318842] CS: 0010 DS: 0000 ES: 0000 =
CR0: 0000000080050033=20
Jun 15 09:49:30 r1obj02 kernel: [607697.361609] CR2: 0000000000000001 CR3: =
0000000bcb9b1000 CR4: 00000000001407e0=20
Jun 15 09:49:30 r1obj02 kernel: [607697.445360] Stack:=20
Jun 15 09:49:30 r1obj02 kernel: [607697.485796] ffff8808e87e5e88 ffffffffa0=
3e2a33 ffff8808e87e5e58 ffffffff817205f9=20
Jun 15 09:49:30 r1obj02 kernel: [607697.567306] ffff8808e87e5eb8 ffff88084e=
1e6700 ffff88004988f000 ffff8808e87e5f20=20
Jun 15 09:49:30 r1obj02 kernel: [607697.648568] 0000000000000082 00007fe748=
7aa7a6 ffff8808e87e5ec0 ffffffffa03e2e0b=20
Jun 15 09:49:30 r1obj02 kernel: [607697.729785] Call Trace:=20
Jun 15 09:49:30 r1obj02 kernel: [607697.769297] [&lt;ffffffffa03e2a33&gt;] =
? xfs_dir2_sf_getdents+0x263/0x2a0 [xfs]=20
Jun 15 09:49:30 r1obj02 kernel: [607697.809560] [&lt;ffffffff817205f9&gt;] =
? schedule_preempt_disabled+0x29/0x70=20
Jun 15 09:49:30 r1obj02 kernel: [607697.849087] [&lt;ffffffffa03e2e0b&gt;] =
xfs_readdir+0xeb/0x110 [xfs]=20
Jun 15 09:49:30 r1obj02 kernel: [607697.887918] [&lt;ffffffffa03e4a3b&gt;] =
xfs_file_readdir+0x2b/0x40 [xfs]=20
Jun 15 09:49:30 r1obj02 kernel: [607697.926061] [&lt;ffffffff811d0035&gt;] =
iterate_dir+0xa5/0xe0=20
Jun 15 09:49:30 r1obj02 kernel: [607697.963349] [&lt;ffffffff8109ddf4&gt;] =
? vtime_account_user+0x54/0x60=20
Jun 15 09:49:30 r1obj02 kernel: [607698.000413] [&lt;ffffffff811d0492&gt;] =
SyS_getdents+0x92/0x120=20
Jun 15 09:49:30 r1obj02 kernel: [607698.037112] [&lt;ffffffff811d0150&gt;] =
? fillonedir+0xe0/0xe0=20
Jun 15 09:49:30 r1obj02 kernel: [607698.072867] [&lt;ffffffff8172c81c&gt;] =
? tracesys+0x7e/0xe6=20
Jun 15 09:49:30 r1obj02 kernel: [607698.107679] [&lt;ffffffff8172c87f&gt;] =
tracesys+0xe1/0xe6=20
Jun 15 09:49:30 r1obj02 kernel: [607698.141543] Code: 00 48 8b 06 48 ba ff =
ff ff ff ff ff ff 00 5d 48 0f c8 48 21 d0 c3 66 66 2e 0f 1f 84 00 00 00 00 =
00 0f 1f 44 00 00 55 48 8d 77 02 &lt;0f&gt; b6 7f 01 48 89 e5 e8 aa ff ff f=
f 5d c3 0f 1f 84 00 00 00 00=20
Jun 15 09:49:30 r1obj02 kernel: [607698.244881] RIP [&lt;ffffffffa041a99a&g=
t;] xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]=20
Jun 15 09:49:30 r1obj02 kernel: [607698.310872] RSP &lt;ffff8808e87e5e38&gt=
;=20
Jun 15 09:49:30 r1obj02 kernel: [607698.343092] CR2: 0000000000000001=20
Jun 15 09:49:30 r1obj02 kernel: [607698.420933] ---[ end trace ba3fdf319346=
b7e6 ]---
</code></pre><p style=3D"margin:0px 0px 1.2em!important">Thanks // Hugo Kuo=
</p>
<div title=3D"MDH:SGkgZm9sa3MswqA8ZGl2Pjxicj48L2Rpdj48ZGl2PlJlY2VudGx5IHdlI=
GZvdW5kIHRoZSBmb2xs
b3dpbmcga2VybmVsIG1lc3NhZ2Ugb2YgWEZTLiBJIGRvbid0IHJlYWxseSBrbm93IGhvdyB0byB=
y
ZWFkIGl0IGluIHRoZSByaWdodCB3YXkgdG8gZmlndXJlIG91dCB0aGUgcHJvYmxlbSBpbiB0aGU=
g
c3lzdGVtLiZuYnNwOzwvZGl2PjxkaXY+SXMgdGhlcmUgYW55IGtub3duIGJ1ZyBmb3IgYExpbnV=
4
LTMuMTMuMC0zMi1nZW5lcmljLXg4Nl82NC13aXRoLVVidW50dS0xNC4wNC10cnVzdHlgID8gT3I=
g
dGhlIHByb2JsZW0gaXMgb24gdGhlIGBzd2lmdC1vYmplY3Qtc2VgIHJhdGhlciB0aGFuIFhGUyB=
p
dHNlbGYgPyZuYnNwOzwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+YHN3aWZ0LW9iamVjdC1zZWA=
g
bWVhbnMgc3dpZnQtb2JqZWN0LXNlcnZlciB3aGljaCBpcyBhIGRhZW1vbiBoYW5kbGVzIGRhdGE=
g
ZnJvbSBodHRwIHRvIFhGUy4gSSBjYW4ndCBhZGRyZXNzIHRoZSBwcm9ibGVtIGNhbWUgZnJvbSB=
Y
RlMgb3IgdGhlIGRhZW1vbiBzd2lmdC1vYmplY3Qtc2VydmVyLiZuYnNwOzwvZGl2PjxkaXY+QW5=
5
IGlkZWEgd291bGQgYmUgYXBwcmVjaWF0ZWQuJm5ic3A7PC9kaXY+PGRpdj48YnI+PC9kaXY+PGR=
p
dj48YnI+PC9kaXY+PGRpdj5gYGA8L2Rpdj48ZGl2PjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg=
1
LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5=
p
Y29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1=
z
aXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp1biAxNSAwOTo0OTozMCByMW9iajAyIGt=
l
cm5lbDogWzYwNzY5Ni43OTg4MDNdIEJVRzogdW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgTlVMTCB=
w
b2ludGVyIGRlcmVmZXJlbmNlIGF0IDAwMDAwMDAwMDAwMDAwMDEmbmJzcDs8L3NwYW4+PGJyIHN=
0
eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGU=
n
LCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSw=
g
c2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPjxzcGFuIHN=
0
eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGU=
n
LCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSw=
g
c2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp1biAxNSA=
w
OTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ni44MDA1ODJdIElQOiBbJmx0O2ZmZmZmZmZ=
m
YTA0MWE5OWEmZ3Q7XSB4ZnNfZGlyMl9zZl9nZXRfcGFyZW50X2lubysweGEvMHgyMCBbeGZzXSZ=
u
YnNwOzwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx=
5
OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJyw=
g
VmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h=
0
OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx=
5
OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJyw=
g
VmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h=
0
OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2JqMDIga2VybmVsOiBbNjA3Njk2LjgwMjIzMF0=
g
UEdEIDEwNDZjNmMwNjcgUFVEIDEwNDRlYmEwNjcgUE1EIDAmbmJzcDs8L3NwYW4+PGJyIHN0eWx=
l
PSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCA=
n
THVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2F=
u
cy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPjxzcGFuIHN0eWx=
l
PSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCA=
n
THVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2F=
u
cy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp1biAxNSAwOTo=
0
OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ni44MDMzMDhdIE9vcHM6IDAwMDAgWyMxXSBTTVA=
m
bmJzcDs8L3NwYW4+PGJyIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWl=
s
eTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2Fucyc=
s
IFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWd=
o
dDogMThweDsiPjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWl=
s
eTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2Fucyc=
s
IFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWd=
o
dDogMThweDsiPkp1biAxNSAwOTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ni44MDQwNTh=
d
IE1vZHVsZXMgbGlua2VkIGluOiB4dF9jb25udHJhY2sgeGZzIHh0X1JFRElSRUNUIGlwdGFibGV=
f
bmF0IG5mX2Nvbm50cmFja19pcHY0IG5mX2RlZnJhZ19pcHY0IG5mX25hdF9pcHY0IG5mX25hdCB=
4
dF90Y3B1ZHAgaXB0YWJsZV9maWx0ZXIgaXBfdGFibGVzIHhfdGFibGVzIHg4Nl9wa2dfdGVtcF9=
0
aGVybWFsIGludGVsX3Bvd2VyY2xhbXAgY29yZXRlbXAga3ZtX2ludGVsIGt2bSBjcmN0MTBkaWZ=
f
cGNsbXVsIGNyYzMyX3BjbG11bCBnaGFzaF9jbG11bG5pX2ludGVsIGlwX3ZzIGFlc25pX2ludGV=
s
IGFlc194ODZfNjQgZ3Bpb19pY2ggbHJ3IG5mX2Nvbm50cmFjayBnZjEyOG11bCBsaWJjcmMzMmM=
g
bWVpX21lIGdsdWVfaGVscGVyIHNiX2VkYWMgYWJsa19oZWxwZXIgY3J5cHRkIGVkYWNfY29yZSB=
q
b3lkZXYgbWVpIGxwY19pY2ggaW9hdGRtYSBscCBpcG1pX3NpIHNocGNocCB3bWkgbWFjX2hpZCB=
w
YXJwb3J0IHNlcyBlbmNsb3N1cmUgaGlkX2dlbmVyaWMgaWdiIHVzYmhpZCBpeGdiZSBtcHQyc2F=
z
IGFoY2kgaGlkIGkyY19hbGdvX2JpdCBsaWJhaGNpIGRjYSByYWlkX2NsYXNzIHB0cCBtZGlvIHN=
j
c2lfdHJhbnNwb3J0X3NhcyBwcHNfY29yZSZuYnNwOzwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiB=
y
Z2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2F=
u
cyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyB=
m
b250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiB=
y
Z2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2F=
u
cyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyB=
m
b250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2J=
q
MDIga2VybmVsOiBbNjA3Njk2LjgxNzEyNV0gQ1BVOiAxMyBQSUQ6IDMyNDAxIENvbW06IHN3aWZ=
0
LW9iamVjdC1zZSBOb3QgdGFpbnRlZCAzLjEzLjAtMzItZ2VuZXJpYyZuYnNwOzwvc3Bhbj48YSB=
0
YXJnZXQ9Il9ibGFuayIgaHJlZj0iaHR0cHM6Ly9zd2lmdHN0YWNrLnplbmRlc2suY29tL2FnZW5=
0
L3RpY2tldHMvNTciIHN0eWxlPSJjb2xvcjogcmdiKDAsIDEzNiwgMjA0KTsgdGV4dC1kZWNvcmF=
0
aW9uOiBub25lOyBtYXJnaW46IDBweDsgcGFkZGluZzogMHB4OyBmb250LXNpemU6IDEycHg7IHZ=
l
cnRpY2FsLWFsaWduOiBiYXNlbGluZTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x=
1
Y2lkYSBTYW5zIFVuaWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnM=
t
c2VyaWY7IGxpbmUtaGVpZ2h0OiAxOHB4OyBiYWNrZ3JvdW5kLWltYWdlOiBpbml0aWFsOyBiYWN=
r
Z3JvdW5kLXJlcGVhdDogaW5pdGlhbDsiPiM1NzwvYT48c3BhbiBzdHlsZT0iY29sb3I6IHJnYig=
4
NSwgODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x1Y2lkYSBTYW5zIFV=
u
aWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnMtc2VyaWY7IGZvbnQ=
t
c2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij4tVWJ1bnR1Jm5ic3A7PC9zcGFuPjxiciB=
z
dHlsZT0iY29sb3I6IHJnYig4NSwgODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmR=
l
JywgJ0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWE=
s
IHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij48c3BhbiB=
z
dHlsZT0iY29sb3I6IHJnYig4NSwgODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmR=
l
JywgJ0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWE=
s
IHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij5KdW4gMTU=
g
MDk6NDk6MzAgcjFvYmowMiBrZXJuZWw6IFs2MDc2OTYuODE5MDIwXSBIYXJkd2FyZSBuYW1lOiB=
T
aWxpY29uIE1lY2hhbmljcyBTdG9yZm9ybSBpU2VydiBSNTE4LnY0L1g5RFJILTdURi83Ri9pVEY=
v
aUYsIEJJT1MgMy4wYiAwNC8yOC8yMDE0Jm5ic3A7PC9zcGFuPjxiciBzdHlsZT0iY29sb3I6IHJ=
n
Yig4NSwgODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x1Y2lkYSBTYW5=
z
IFVuaWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnMtc2VyaWY7IGZ=
v
bnQtc2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij48c3BhbiBzdHlsZT0iY29sb3I6IHJ=
n
Yig4NSwgODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x1Y2lkYSBTYW5=
z
IFVuaWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnMtc2VyaWY7IGZ=
v
bnQtc2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij5KdW4gMTUgMDk6NDk6MzAgcjFvYmo=
w
MiBrZXJuZWw6IFs2MDc2OTYuODIxMjM1XSB0YXNrOiBmZmZmODgwMDE3ZDY4MDAwIHRpOiBmZmZ=
m
ODgwOGU4N2U0MDAwIHRhc2sudGk6IGZmZmY4ODA4ZTg3ZTQwMDAmbmJzcDs8L3NwYW4+PGJyIHN=
0
eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGU=
n
LCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSw=
g
c2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPjxzcGFuIHN=
0
eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGU=
n
LCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSw=
g
c2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp1biAxNSA=
w
OTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ni44MjI4ODldIFJJUDogMDAxMDpbJmx0O2Z=
m
ZmZmZmZmYTA0MWE5OWEmZ3Q7XSBbJmx0O2ZmZmZmZmZmYTA0MWE5OWEmZ3Q7XSB4ZnNfZGlyMl9=
z
Zl9nZXRfcGFyZW50X2lubysweGEvMHgyMCBbeGZzXSZuYnNwOzwvc3Bhbj48YnIgc3R5bGU9ImN=
v
bG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWN=
p
ZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXN=
l
cmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImN=
v
bG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWN=
p
ZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXN=
l
cmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjM=
w
IHIxb2JqMDIga2VybmVsOiBbNjA3Njk2LjgyNTExN10gUlNQOiAwMDE4OmZmZmY4ODA4ZTg3ZTV=
l
MzggRUZMQUdTOiAwMDAxMDIwMiZuYnNwOzwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiByZ2IoODU=
s
IDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbml=
j
b2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXN=
p
emU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2IoODU=
s
IDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbml=
j
b2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXN=
p
emU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2JqMDIga2V=
y
bmVsOiBbNjA3Njk2LjgyNjI5Nl0gUkFYOiBmZmZmZmZmZmEwNDU4MzYwIFJCWDogMDAwMDAwMDA=
w
MDAwMDAwNCBSQ1g6IDAwMDAwMDAwMDAwMDAwMDAmbmJzcDs8L3NwYW4+PGJyIHN0eWxlPSJjb2x=
v
cjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWR=
h
IFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJ=
p
ZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPjxzcGFuIHN0eWxlPSJjb2x=
v
cjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWR=
h
IFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJ=
p
ZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp1biAxNSAwOTo0OTozMCB=
y
MW9iajAyIGtlcm5lbDogWzYwNzY5Ni45MDUxNThdIFJEWDogMDAwMDAwMDAwMDAwMDAwMiBSU0k=
6
IDAwMDAwMDAwMDAwMDAwMDIgUkRJOiAwMDAwMDAwMDAwMDAwMDAwJm5ic3A7PC9zcGFuPjxiciB=
z
dHlsZT0iY29sb3I6IHJnYig4NSwgODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmR=
l
JywgJ0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWE=
s
IHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij48c3BhbiB=
z
dHlsZT0iY29sb3I6IHJnYig4NSwgODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmR=
l
JywgJ0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWE=
s
IHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij5KdW4gMTU=
g
MDk6NDk6MzAgcjFvYmowMiBrZXJuZWw6IFs2MDc2OTYuOTg3MTA3XSBSQlA6IGZmZmY4ODA4ZTg=
3
ZTVlODggUjA4OiAwMDAwMDAwMjAwNzllM2I5IFIwOTogMDAwMDAwMDAwMDAwMDAwNCZuYnNwOzw=
v
c3Bhbj48YnIgc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHV=
j
aWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGF=
u
YSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB=
4
OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHV=
j
aWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGF=
u
YSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB=
4
OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2JqMDIga2VybmVsOiBbNjA3Njk3LjA2OTIxNF0gUjEwOiA=
w
MDAwMDAwMDAwMDAwM2UwIFIxMTogMDAwMDAwMDAwMDAwMDViMCBSMTI6IGZmZmY4ODEwNGQwYzA=
4
MDAmbmJzcDs8L3NwYW4+PGJyIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZ=
h
bWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2F=
u
cycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWh=
l
aWdodDogMThweDsiPjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZ=
h
bWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2F=
u
cycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWh=
l
aWdodDogMThweDsiPkp1biAxNSAwOTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ny4xNTE=
2
NzZdIFIxMzogZmZmZjg4MDhlODdlNWYyMCBSMTQ6IGZmZmY4ODAwNDk4OGYwMDAgUjE1OiAwMDA=
w
MDAwMDAwMDAwMDAwJm5ic3A7PC9zcGFuPjxiciBzdHlsZT0iY29sb3I6IHJnYig4NSwgODUsIDg=
1
KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCA=
n
THVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJ=
w
eDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij48c3BhbiBzdHlsZT0iY29sb3I6IHJnYig4NSwgODUsIDg=
1
KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCA=
n
THVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJ=
w
eDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij5KdW4gMTUgMDk6NDk6MzAgcjFvYmowMiBrZXJuZWw6IFs=
2
MDc2OTcuMjM0MjQ0XSBGUzogMDAwMDdmZTc0YzlmYjc0MCgwMDAwKSBHUzpmZmZmODgwODVmY2U=
w
MDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAwMDAmbmJzcDs8L3NwYW4+PGJyIHN0eWxlPSJ=
j
b2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHV=
j
aWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1=
z
ZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPjxzcGFuIHN0eWxlPSJ=
j
b2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHV=
j
aWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1=
z
ZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp1biAxNSAwOTo0OTo=
z
MCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ny4zMTg4NDJdIENTOiAwMDEwIERTOiAwMDAwIEVTOiA=
w
MDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMyZuYnNwOzwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiB=
y
Z2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2F=
u
cyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyB=
m
b250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiB=
y
Z2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2F=
u
cyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyB=
m
b250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2J=
q
MDIga2VybmVsOiBbNjA3Njk3LjM2MTYwOV0gQ1IyOiAwMDAwMDAwMDAwMDAwMDAxIENSMzogMDA=
w
MDAwMGJjYjliMTAwMCBDUjQ6IDAwMDAwMDAwMDAxNDA3ZTAmbmJzcDs8L3NwYW4+PGJyIHN0eWx=
l
PSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCA=
n
THVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2F=
u
cy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPjxzcGFuIHN0eWx=
l
PSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCA=
n
THVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2F=
u
cy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp1biAxNSAwOTo=
0
OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ny40NDUzNjBdIFN0YWNrOiZuYnNwOzwvc3Bhbj4=
8
YnIgc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEd=
y
YW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGF=
o
b21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+PHN=
w
YW4gc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEd=
y
YW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGF=
o
b21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+SnV=
u
IDE1IDA5OjQ5OjMwIHIxb2JqMDIga2VybmVsOiBbNjA3Njk3LjQ4NTc5Nl0gZmZmZjg4MDhlODd=
l
NWU4OCBmZmZmZmZmZmEwM2UyYTMzIGZmZmY4ODA4ZTg3ZTVlNTggZmZmZmZmZmY4MTcyMDVmOSZ=
u
YnNwOzwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx=
5
OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJyw=
g
VmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h=
0
OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx=
5
OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJyw=
g
VmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h=
0
OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2JqMDIga2VybmVsOiBbNjA3Njk3LjU2NzMwNl0=
g
ZmZmZjg4MDhlODdlNWViOCBmZmZmODgwODRlMWU2NzAwIGZmZmY4ODAwNDk4OGYwMDAgZmZmZjg=
4
MDhlODdlNWYyMCZuYnNwOzwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk=
7
IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x=
1
Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg=
7
IGxpbmUtaGVpZ2h0OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk=
7
IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x=
1
Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg=
7
IGxpbmUtaGVpZ2h0OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2JqMDIga2VybmVsOiBbNjA=
3
Njk3LjY0ODU2OF0gMDAwMDAwMDAwMDAwMDA4MiAwMDAwN2ZlNzQ4N2FhN2E2IGZmZmY4ODA4ZTg=
3
ZTVlYzAgZmZmZmZmZmZhMDNlMmUwYiZuYnNwOzwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiByZ2I=
o
ODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyB=
V
bmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb25=
0
LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2I=
o
ODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyB=
V
bmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb25=
0
LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2JqMDI=
g
a2VybmVsOiBbNjA3Njk3LjcyOTc4NV0gQ2FsbCBUcmFjZTombmJzcDs8L3NwYW4+PGJyIHN0eWx=
l
PSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCA=
n
THVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2F=
u
cy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPjxzcGFuIHN0eWx=
l
PSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCA=
n
THVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2F=
u
cy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp1biAxNSAwOTo=
0
OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ny43NjkyOTddIFsmbHQ7ZmZmZmZmZmZhMDNlMmE=
z
MyZndDtdID8geGZzX2RpcjJfc2ZfZ2V0ZGVudHMrMHgyNjMvMHgyYTAgW3hmc10mbmJzcDs8L3N=
w
YW4+PGJyIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2l=
k
YSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmE=
s
IFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDs=
i
PjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2l=
k
YSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmE=
s
IFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDs=
i
Pkp1biAxNSAwOTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ny44MDk1NjBdIFsmbHQ7ZmZ=
m
ZmZmZmY4MTcyMDVmOSZndDtdID8gc2NoZWR1bGVfcHJlZW1wdF9kaXNhYmxlZCsweDI5LzB4NzA=
m
bmJzcDs8L3NwYW4+PGJyIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWl=
s
eTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2Fucyc=
s
IFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWd=
o
dDogMThweDsiPjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWl=
s
eTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2Fucyc=
s
IFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWd=
o
dDogMThweDsiPkp1biAxNSAwOTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ny44NDkwODd=
d
IFsmbHQ7ZmZmZmZmZmZhMDNlMmUwYiZndDtdIHhmc19yZWFkZGlyKzB4ZWIvMHgxMTAgW3hmc10=
m
bmJzcDs8L3NwYW4+PGJyIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWl=
s
eTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2Fucyc=
s
IFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWd=
o
dDogMThweDsiPjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWl=
s
eTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2Fucyc=
s
IFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWd=
o
dDogMThweDsiPkp1biAxNSAwOTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ny44ODc5MTh=
d
IFsmbHQ7ZmZmZmZmZmZhMDNlNGEzYiZndDtdIHhmc19maWxlX3JlYWRkaXIrMHgyYi8weDQwIFt=
4
ZnNdJm5ic3A7PC9zcGFuPjxiciBzdHlsZT0iY29sb3I6IHJnYig4NSwgODUsIDg1KTsgZm9udC1=
m
YW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCAnTHVjaWRhIFN=
h
bnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJweDsgbGluZS1=
o
ZWlnaHQ6IDE4cHg7Ij48c3BhbiBzdHlsZT0iY29sb3I6IHJnYig4NSwgODUsIDg1KTsgZm9udC1=
m
YW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCAnTHVjaWRhIFN=
h
bnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJweDsgbGluZS1=
o
ZWlnaHQ6IDE4cHg7Ij5KdW4gMTUgMDk6NDk6MzAgcjFvYmowMiBrZXJuZWw6IFs2MDc2OTcuOTI=
2
MDYxXSBbJmx0O2ZmZmZmZmZmODExZDAwMzUmZ3Q7XSBpdGVyYXRlX2RpcisweGE1LzB4ZTAmbmJ=
z
cDs8L3NwYW4+PGJyIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTo=
g
J0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZ=
l
cmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDo=
g
MThweDsiPjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTo=
g
J0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZ=
l
cmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDo=
g
MThweDsiPkp1biAxNSAwOTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5Ny45NjMzNDldIFs=
m
bHQ7ZmZmZmZmZmY4MTA5ZGRmNCZndDtdID8gdnRpbWVfYWNjb3VudF91c2VyKzB4NTQvMHg2MCZ=
u
YnNwOzwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx=
5
OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJyw=
g
VmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h=
0
OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx=
5
OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJyw=
g
VmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h=
0
OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2JqMDIga2VybmVsOiBbNjA3Njk4LjAwMDQxM10=
g
WyZsdDtmZmZmZmZmZjgxMWQwNDkyJmd0O10gU3lTX2dldGRlbnRzKzB4OTIvMHgxMjAmbmJzcDs=
8
L3NwYW4+PGJyIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x=
1
Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmR=
h
bmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMTh=
w
eDsiPjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x=
1
Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmR=
h
bmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMTh=
w
eDsiPkp1biAxNSAwOTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5OC4wMzcxMTJdIFsmbHQ=
7
ZmZmZmZmZmY4MTFkMDE1MCZndDtdID8gZmlsbG9uZWRpcisweGUwLzB4ZTAmbmJzcDs8L3NwYW4=
+
PGJyIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSB=
H
cmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFR=
h
aG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPjx=
z
cGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSB=
H
cmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFR=
h
aG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp=
1
biAxNSAwOTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5OC4wNzI4NjddIFsmbHQ7ZmZmZmZ=
m
ZmY4MTcyYzgxYyZndDtdID8gdHJhY2VzeXMrMHg3ZS8weGU2Jm5ic3A7PC9zcGFuPjxiciBzdHl=
s
ZT0iY29sb3I6IHJnYig4NSwgODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJyw=
g
J0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHN=
h
bnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij48c3BhbiBzdHl=
s
ZT0iY29sb3I6IHJnYig4NSwgODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJyw=
g
J0x1Y2lkYSBTYW5zIFVuaWNvZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHN=
h
bnMtc2VyaWY7IGZvbnQtc2l6ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij5KdW4gMTUgMDk=
6
NDk6MzAgcjFvYmowMiBrZXJuZWw6IFs2MDc2OTguMTA3Njc5XSBbJmx0O2ZmZmZmZmZmODE3MmM=
4
N2YmZ3Q7XSB0cmFjZXN5cysweGUxLzB4ZTYmbmJzcDs8L3NwYW4+PGJyIHN0eWxlPSJjb2xvcjo=
g
cmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFN=
h
bnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjs=
g
Zm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPjxzcGFuIHN0eWxlPSJjb2xvcjo=
g
cmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFN=
h
bnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjs=
g
Zm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDogMThweDsiPkp1biAxNSAwOTo0OTozMCByMW9=
i
ajAyIGtlcm5lbDogWzYwNzY5OC4xNDE1NDNdIENvZGU6IDAwIDQ4IDhiIDA2IDQ4IGJhIGZmIGZ=
m
IGZmIGZmIGZmIGZmIGZmIDAwIDVkIDQ4IDBmIGM4IDQ4IDIxIGQwIGMzIDY2IDY2IDJlIDBmIDF=
m
IDg0IDAwIDAwIDAwIDAwIDAwIDBmIDFmIDQ0IDAwIDAwIDU1IDQ4IDhkIDc3IDAyICZsdDswZiZ=
n
dDsgYjYgN2YgMDEgNDggODkgZTUgZTggYWEgZmYgZmYgZmYgNWQgYzMgMGYgMWYgODQgMDAgMDA=
g
MDAgMDAmbmJzcDs8L3NwYW4+PGJyIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb25=
0
LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGE=
g
U2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5=
l
LWhlaWdodDogMThweDsiPjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb25=
0
LWZhbWlseTogJ0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGE=
g
U2FucycsIFZlcmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5=
l
LWhlaWdodDogMThweDsiPkp1biAxNSAwOTo0OTozMCByMW9iajAyIGtlcm5lbDogWzYwNzY5OC4=
y
NDQ4ODFdIFJJUCBbJmx0O2ZmZmZmZmZmYTA0MWE5OWEmZ3Q7XSB4ZnNfZGlyMl9zZl9nZXRfcGF=
y
ZW50X2lubysweGEvMHgyMCBbeGZzXSZuYnNwOzwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiByZ2I=
o
ODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyB=
V
bmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb25=
0
LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2I=
o
ODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyB=
V
bmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb25=
0
LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2JqMDI=
g
a2VybmVsOiBbNjA3Njk4LjMxMDg3Ml0gUlNQICZsdDtmZmZmODgwOGU4N2U1ZTM4Jmd0OyZuYnN=
w
Ozwvc3Bhbj48YnIgc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiA=
n
THVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmV=
y
ZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiA=
x
OHB4OyI+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiA=
n
THVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmV=
y
ZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiA=
x
OHB4OyI+SnVuIDE1IDA5OjQ5OjMwIHIxb2JqMDIga2VybmVsOiBbNjA3Njk4LjM0MzA5Ml0gQ1I=
y
OiAwMDAwMDAwMDAwMDAwMDAxJm5ic3A7PC9zcGFuPjxiciBzdHlsZT0iY29sb3I6IHJnYig4NSw=
g
ODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x1Y2lkYSBTYW5zIFVuaWN=
v
ZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnMtc2VyaWY7IGZvbnQtc2l=
6
ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij48c3BhbiBzdHlsZT0iY29sb3I6IHJnYig4NSw=
g
ODUsIDg1KTsgZm9udC1mYW1pbHk6ICdMdWNpZGEgR3JhbmRlJywgJ0x1Y2lkYSBTYW5zIFVuaWN=
v
ZGUnLCAnTHVjaWRhIFNhbnMnLCBWZXJkYW5hLCBUYWhvbWEsIHNhbnMtc2VyaWY7IGZvbnQtc2l=
6
ZTogMTJweDsgbGluZS1oZWlnaHQ6IDE4cHg7Ij5KdW4gMTUgMDk6NDk6MzAgcjFvYmowMiBrZXJ=
u
ZWw6IFs2MDc2OTguNDIwOTMzXSAtLS1bIGVuZCB0cmFjZSBiYTNmZGYzMTkzNDZiN2U2IF0tLS0=
8
L3NwYW4+PGJyPjwvZGl2PjxkaXY+PHNwYW4gc3R5bGU9ImNvbG9yOiByZ2IoODUsIDg1LCA4NSk=
7
IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWNpZGEgU2FucyBVbmljb2RlJywgJ0x=
1
Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDEycHg=
7
IGxpbmUtaGVpZ2h0OiAxOHB4OyI+YGBgPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4gc3R5bGU9ImN=
v
bG9yOiByZ2IoODUsIDg1LCA4NSk7IGZvbnQtZmFtaWx5OiAnTHVjaWRhIEdyYW5kZScsICdMdWN=
p
ZGEgU2FucyBVbmljb2RlJywgJ0x1Y2lkYSBTYW5zJywgVmVyZGFuYSwgVGFob21hLCBzYW5zLXN=
l
cmlmOyBmb250LXNpemU6IDEycHg7IGxpbmUtaGVpZ2h0OiAxOHB4OyI+PGJyPjwvc3Bhbj48L2R=
p
dj48ZGl2PjxzcGFuIHN0eWxlPSJjb2xvcjogcmdiKDg1LCA4NSwgODUpOyBmb250LWZhbWlseTo=
g
J0x1Y2lkYSBHcmFuZGUnLCAnTHVjaWRhIFNhbnMgVW5pY29kZScsICdMdWNpZGEgU2FucycsIFZ=
l
cmRhbmEsIFRhaG9tYSwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxMnB4OyBsaW5lLWhlaWdodDo=
g
MThweDsiPlRoYW5rcyAvLyBIdWdvIEt1bzwvc3Bhbj48L2Rpdj4=3D" style=3D"height:0;w=
idth:0;max-height:0;max-width:0;overflow:hidden;font-size:0em;padding:0;mar=
gin:0">=E2=80=8B</div></div></div>

--047d7b4724e226d3c50518c97f21--


--===============8514141854886908323==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8514141854886908323==--
