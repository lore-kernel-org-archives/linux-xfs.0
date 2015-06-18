Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 59D8A7F6B
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 09:29:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 49B888F8035
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 07:29:13 -0700 (PDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
	[209.85.212.181]) by cuda.sgi.com with ESMTP id
	CupVy7mQaEipdPM0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Jun 2015 07:29:10 -0700 (PDT)
Received: by wibdq8 with SMTP id dq8so88880051wib.1
	for <xfs@oss.sgi.com>; Thu, 18 Jun 2015 07:29:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150618133122.GC43254@bfoster.bfoster>
References: <CA++_uht_4ON49eBqM6eA7oL7iBcxYMwR5ZAQxXmTuNji2XiyBA@mail.gmail.com>
	<20150618133122.GC43254@bfoster.bfoster>
Date: Thu, 18 Jun 2015 22:29:09 +0800
Message-ID: <CA++_uhuLbTT32v4ZeVkP3WOjBEeMU0O1NZDcv66a67hZ=pj9Sw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0856738379622962846=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com
Cc: Hugo Kuo <hugo@swiftstack.com>, darrell@swiftstack.com

--===============0856738379622962846==
Content-Type: multipart/alternative; boundary=047d7b4724e26ab5ed0518cba103

--047d7b4724e26ab5ed0518cba103
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,


>- Is this (and how often) reproducible?

*This is the third time happened in three different servers in past 5
days. *

>- Have you identified which directory in your fs that the object server is
attempting to enumerate when this occurs?

*There's multiple object server workers R/W on over 30 XFS disks in a
server.  I don't have clue about which object server request causes the
kernel panic. I'm still investigating. *

>- Do you have any other, related output in /var/log/messages prior to this
event? E.g., corruption messages or anything of that nature?

*Seems no useful information in the /var/log/syslog*

```
Jun 18 06:07:00 r1obj03 ovpn-454f2951-b955-11e4-8034-0cc47a1f36ee[4069]:
Data Channel Decrypt: Using 160 bit message hash 'SHA1' for HMAC
authentication
Jun 18 06:07:00 r1obj03 ovpn-454f2951-b955-11e4-8034-0cc47a1f36ee[4069]:
Control Channel: TLSv1, cipher TLSv1/SSLv3 DHE-RSA-AES256-SHA, 2048 bit RSA
Jun 18 06:10:01 r1obj03 CRON[13595]: (swift) CMD ((date; test -f
/etc/swift/object-server.conf && /opt/ss/bin/swift-recon-cron
/etc/swift/object-server.conf || /opt/ss/bin/swift-recon-cron
/etc/swift/object-server/1.conf) >> /var/log/swift-recon-cron.log 2>&1)
Jun 18 06:10:14 r1obj03 kernel: [7631629.083099] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000001
```

>- Have you tried an 'xfs_repair -n' of the affected filesystem? Note that
-n will report problems only and prevent any modification by repair.

*We might to to xfs_repair if we can address which disk causes the issue. *

Thanks // Hugo Kuo

2015-06-18 21:31 GMT+08:00 Brian Foster <bfoster@redhat.com>:

> On Thu, Jun 18, 2015 at 07:56:24PM +0800, Kuo Hugo wrote:
> > Hi folks,
> >
> > Recently we found the following kernel message of XFS. I don=E2=80=99t =
really
> know
> > how to read it in the right way to figure out the problem in the system=
.
> > Is there any known bug for
> > Linux-3.13.0-32-generic-x86_64-with-Ubuntu-14.04-trusty ? Or the proble=
m
> is
> > on the swift-object-se rather than XFS itself ?
> >
>
> Nothing that I know of, but others might have seen something like this.
>
> > swift-object-se means swift-object-server which is a daemon handles dat=
a
> > from http to XFS. I can=E2=80=99t address the problem came from XFS or =
the daemon
> > swift-object-server.
> > Any idea would be appreciated.
> >
> > Jun 15 09:49:30 r1obj02 kernel: [607696.798803] BUG: unable to handle
> > kernel NULL pointer dereference at 0000000000000001
> > Jun 15 09:49:30 r1obj02 kernel: [607696.800582] IP:
> > [<ffffffffa041a99a>] xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]
>
> So that looks like a NULL header down in xfs_dir2_sf_get_ino(), as
> hdr->i8count is at a 1 byte offset in the structure.
>
> > Jun 15 09:49:30 r1obj02 kernel: [607696.802230] PGD 1046c6c067 PUD
> > 1044eba067 PMD 0
> > Jun 15 09:49:30 r1obj02 kernel: [607696.803308] Oops: 0000 [#1] SMP
> > Jun 15 09:49:30 r1obj02 kernel: [607696.804058] Modules linked in:
> > xt_conntrack xfs xt_REDIRECT iptable_nat nf_conntrack_ipv4
> > nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_tcpudp iptable_filter ip_tables
> > x_tables x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
> > crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ip_vs aesni_intel
> > aes_x86_64 gpio_ich lrw nf_conntrack gf128mul libcrc32c mei_me
> > glue_helper sb_edac ablk_helper cryptd edac_core joydev mei lpc_ich
> > ioatdma lp ipmi_si shpchp wmi mac_hid parport ses enclosure
> > hid_generic igb usbhid ixgbe mpt2sas ahci hid i2c_algo_bit libahci dca
> > raid_class ptp mdio scsi_transport_sas pps_core
> > Jun 15 09:49:30 r1obj02 kernel: [607696.817125] CPU: 13 PID: 32401
> > Comm: swift-object-se Not tainted 3.13.0-32-generic #57-Ubuntu
> > Jun 15 09:49:30 r1obj02 kernel: [607696.819020] Hardware name: Silicon
> > Mechanics Storform iServ R518.v4/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b
> > 04/28/2014
> > Jun 15 09:49:30 r1obj02 kernel: [607696.821235] task: ffff880017d68000
> > ti: ffff8808e87e4000 task.ti: ffff8808e87e4000
> > Jun 15 09:49:30 r1obj02 kernel: [607696.822889] RIP:
> > 0010:[<ffffffffa041a99a>] [<ffffffffa041a99a>]
> > xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]
> > Jun 15 09:49:30 r1obj02 kernel: [607696.825117] RSP:
> > 0018:ffff8808e87e5e38 EFLAGS: 00010202
> > Jun 15 09:49:30 r1obj02 kernel: [607696.826296] RAX: ffffffffa0458360
> > RBX: 0000000000000004 RCX: 0000000000000000
> > Jun 15 09:49:30 r1obj02 kernel: [607696.905158] RDX: 0000000000000002
> > RSI: 0000000000000002 RDI: 0000000000000000
> > Jun 15 09:49:30 r1obj02 kernel: [607696.987107] RBP: ffff8808e87e5e88
> > R08: 000000020079e3b9 R09: 0000000000000004
> > Jun 15 09:49:30 r1obj02 kernel: [607697.069214] R10: 00000000000003e0
> > R11: 00000000000005b0 R12: ffff88104d0c0800
> > Jun 15 09:49:30 r1obj02 kernel: [607697.151676] R13: ffff8808e87e5f20
> > R14: ffff88004988f000 R15: 0000000000000000
> > Jun 15 09:49:30 r1obj02 kernel: [607697.234244] FS:
> > 00007fe74c9fb740(0000) GS:ffff88085fce0000(0000)
> > knlGS:0000000000000000
> > Jun 15 09:49:30 r1obj02 kernel: [607697.318842] CS: 0010 DS: 0000 ES:
> > 0000 CR0: 0000000080050033
> > Jun 15 09:49:30 r1obj02 kernel: [607697.361609] CR2: 0000000000000001
> > CR3: 0000000bcb9b1000 CR4: 00000000001407e0
> > Jun 15 09:49:30 r1obj02 kernel: [607697.445360] Stack:
> > Jun 15 09:49:30 r1obj02 kernel: [607697.485796] ffff8808e87e5e88
> > ffffffffa03e2a33 ffff8808e87e5e58 ffffffff817205f9
> > Jun 15 09:49:30 r1obj02 kernel: [607697.567306] ffff8808e87e5eb8
> > ffff88084e1e6700 ffff88004988f000 ffff8808e87e5f20
> > Jun 15 09:49:30 r1obj02 kernel: [607697.648568] 0000000000000082
> > 00007fe7487aa7a6 ffff8808e87e5ec0 ffffffffa03e2e0b
> > Jun 15 09:49:30 r1obj02 kernel: [607697.729785] Call Trace:
> > Jun 15 09:49:30 r1obj02 kernel: [607697.769297] [<ffffffffa03e2a33>] ?
> > xfs_dir2_sf_getdents+0x263/0x2a0 [xfs]
>
> We're called from here attempting to list a directory, which appears to
> be the following block of code:
>
>         ...
>         sfp =3D (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
>         ...
>         if (ctx->pos <=3D dotdot_offset) {
>                 ino =3D dp->d_ops->sf_get_parent_ino(sfp);
>                 ctx->pos =3D dotdot_offset & 0x7fffffff;
>                 if (!dir_emit(ctx, "..", 2, ino, DT_DIR))
>                         return 0;
>         }
>
> It wants to emit the ".." directory entry and apparently the in-core
> data fork is NULL. There's an assertion against that earlier in the
> function so I take it the expectation is that this has been read/set
> beforehand. In fact, if this is a short form directory I also take it
> this should be set to if_inline_data, which appears to be part of the
> fork allocation itself.
>
> It's not immediately clear to me how this could happen. First off, it
> would probably be good to determine whether this is a runtime issue or
> due to some kind of on-disk problem. Some questions:
>
> - Is this (and how often) reproducible?
> - Have you identified which directory in your fs that the object server
>   is attempting to enumerate when this occurs?
> - Do you have any other, related output in /var/log/messages prior to
>   this event? E.g., corruption messages or anything of that nature?
> - Have you tried an 'xfs_repair -n' of the affected filesystem? Note
>   that -n will report problems only and prevent any modification by
>   repair.
>
> Brian
>
> > Jun 15 09:49:30 r1obj02 kernel: [607697.809560] [<ffffffff817205f9>] ?
> > schedule_preempt_disabled+0x29/0x70
> > Jun 15 09:49:30 r1obj02 kernel: [607697.849087] [<ffffffffa03e2e0b>]
> > xfs_readdir+0xeb/0x110 [xfs]
> > Jun 15 09:49:30 r1obj02 kernel: [607697.887918] [<ffffffffa03e4a3b>]
> > xfs_file_readdir+0x2b/0x40 [xfs]
> > Jun 15 09:49:30 r1obj02 kernel: [607697.926061] [<ffffffff811d0035>]
> > iterate_dir+0xa5/0xe0
> > Jun 15 09:49:30 r1obj02 kernel: [607697.963349] [<ffffffff8109ddf4>] ?
> > vtime_account_user+0x54/0x60
> > Jun 15 09:49:30 r1obj02 kernel: [607698.000413] [<ffffffff811d0492>]
> > SyS_getdents+0x92/0x120
> > Jun 15 09:49:30 r1obj02 kernel: [607698.037112] [<ffffffff811d0150>] ?
> > fillonedir+0xe0/0xe0
> > Jun 15 09:49:30 r1obj02 kernel: [607698.072867] [<ffffffff8172c81c>] ?
> > tracesys+0x7e/0xe6
> > Jun 15 09:49:30 r1obj02 kernel: [607698.107679] [<ffffffff8172c87f>]
> > tracesys+0xe1/0xe6
> > Jun 15 09:49:30 r1obj02 kernel: [607698.141543] Code: 00 48 8b 06 48
> > ba ff ff ff ff ff ff ff 00 5d 48 0f c8 48 21 d0 c3 66 66 2e 0f 1f 84
> > 00 00 00 00 00 0f 1f 44 00 00 55 48 8d 77 02 <0f> b6 7f 01 48 89 e5 e8
> > aa ff ff ff 5d c3 0f 1f 84 00 00 00 00
> > Jun 15 09:49:30 r1obj02 kernel: [607698.244881] RIP
> > [<ffffffffa041a99a>] xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]
> > Jun 15 09:49:30 r1obj02 kernel: [607698.310872] RSP <ffff8808e87e5e38>
> > Jun 15 09:49:30 r1obj02 kernel: [607698.343092] CR2: 0000000000000001
> > Jun 15 09:49:30 r1obj02 kernel: [607698.420933] ---[ end trace
> > ba3fdf319346b7e6 ]---
> >
> > Thanks // Hugo Kuo
> > =E2=80=8B
>
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
>

--047d7b4724e26ab5ed0518cba103
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi all,=C2=A0<div><br></div><div><br></div><div><span styl=
e=3D"font-size:14px">&gt;- Is this (and how often) reproducible?</span></di=
v><div><br></div><div><b><font color=3D"#ff9900">This is the third time hap=
pened in three different servers in past 5 days.=C2=A0</font></b></div><div=
><br style=3D"font-size:14px"><span style=3D"font-size:14px">&gt;- Have you=
 identified which directory in your fs that the object server=C2=A0</span><=
span style=3D"font-size:14px">is attempting to enumerate when this occurs?<=
/span></div><div><br></div><div><b><font color=3D"#ff9900">There&#39;s mult=
iple object server workers R/W on over 30 XFS disks in a server.=C2=A0 I do=
n&#39;t have clue about which object server request causes the kernel panic=
. I&#39;m still investigating. </font></b>=C2=A0</div><div><br style=3D"fon=
t-size:14px"><span style=3D"font-size:14px">&gt;- Do you have any other, re=
lated output in /var/log/messages prior to=C2=A0</span><span style=3D"font-=
size:14px">this event? E.g., corruption messages or anything of that nature=
?</span></div><div><br></div><div><font color=3D"#ff9900"><b>Seems no usefu=
l information in the /var/log/syslog</b></font></div><div><br></div><div><f=
ont size=3D"1" face=3D"garamond, serif">```</font></div><div><div><font siz=
e=3D"1" face=3D"garamond, serif">Jun 18 06:07:00 r1obj03 ovpn-454f2951-b955=
-11e4-8034-0cc47a1f36ee[4069]: Data Channel Decrypt: Using 160 bit message =
hash &#39;SHA1&#39; for HMAC authentication</font></div><div><font size=3D"=
1" face=3D"garamond, serif">Jun 18 06:07:00 r1obj03 ovpn-454f2951-b955-11e4=
-8034-0cc47a1f36ee[4069]: Control Channel: TLSv1, cipher TLSv1/SSLv3 DHE-RS=
A-AES256-SHA, 2048 bit RSA</font></div><div><font size=3D"1" face=3D"garamo=
nd, serif">Jun 18 06:10:01 r1obj03 CRON[13595]: (swift) CMD ((date; test -f=
 /etc/swift/object-server.conf &amp;&amp; /opt/ss/bin/swift-recon-cron /etc=
/swift/object-server.conf || /opt/ss/bin/swift-recon-cron /etc/swift/object=
-server/1.conf) &gt;&gt; /var/log/swift-recon-cron.log 2&gt;&amp;1)</font><=
/div><div><font size=3D"1" face=3D"garamond, serif">Jun 18 06:10:14 r1obj03=
 kernel: [7631629.083099] BUG: unable to handle kernel NULL pointer derefer=
ence at 0000000000000001</font></div></div><div><font size=3D"1" face=3D"ga=
ramond, serif">```</font></div><div><br style=3D"font-size:14px"><span styl=
e=3D"font-size:14px">&gt;- Have you tried an &#39;xfs_repair -n&#39; of the=
 affected filesystem? Note=C2=A0</span><span style=3D"font-size:14px">that =
-n will report problems only and prevent any modification by=C2=A0</span><s=
pan style=3D"font-size:14px">repair.</span><br></div><div><span style=3D"fo=
nt-size:14px"><br></span></div><div><span style=3D"font-size:14px"><b><font=
 color=3D"#ff9900">We might to to xfs_repair if we can address which disk c=
auses the issue.=C2=A0</font></b></span></div><div><span style=3D"font-size=
:14px"><br></span></div><div><span style=3D"font-size:14px">Thanks // Hugo =
Kuo</span></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_qu=
ote">2015-06-18 21:31 GMT+08:00 Brian Foster <span dir=3D"ltr">&lt;<a href=
=3D"mailto:bfoster@redhat.com" target=3D"_blank">bfoster@redhat.com</a>&gt;=
</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Thu, Jun 18,=
 2015 at 07:56:24PM +0800, Kuo Hugo wrote:<br>
&gt; Hi folks,<br>
&gt;<br>
&gt; Recently we found the following kernel message of XFS. I don=E2=80=99t=
 really know<br>
&gt; how to read it in the right way to figure out the problem in the syste=
m.<br>
&gt; Is there any known bug for<br>
&gt; Linux-3.13.0-32-generic-x86_64-with-Ubuntu-14.04-trusty ? Or the probl=
em is<br>
&gt; on the swift-object-se rather than XFS itself ?<br>
&gt;<br>
<br>
</span>Nothing that I know of, but others might have seen something like th=
is.<br>
<span class=3D""><br>
&gt; swift-object-se means swift-object-server which is a daemon handles da=
ta<br>
&gt; from http to XFS. I can=E2=80=99t address the problem came from XFS or=
 the daemon<br>
&gt; swift-object-server.<br>
&gt; Any idea would be appreciated.<br>
&gt;<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.798803] BUG: unable to handle<=
br>
&gt; kernel NULL pointer dereference at 0000000000000001<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.800582] IP:<br>
&gt; [&lt;ffffffffa041a99a&gt;] xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]<b=
r>
<br>
</span>So that looks like a NULL header down in xfs_dir2_sf_get_ino(), as<b=
r>
hdr-&gt;i8count is at a 1 byte offset in the structure.<br>
<div><div class=3D"h5"><br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.802230] PGD 1046c6c067 PUD<br>
&gt; 1044eba067 PMD 0<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.803308] Oops: 0000 [#1] SMP<br=
>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.804058] Modules linked in:<br>
&gt; xt_conntrack xfs xt_REDIRECT iptable_nat nf_conntrack_ipv4<br>
&gt; nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_tcpudp iptable_filter ip_tables<b=
r>
&gt; x_tables x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm<=
br>
&gt; crct10dif_pclmul crc32_pclmul ghash_clmulni_intel ip_vs aesni_intel<br=
>
&gt; aes_x86_64 gpio_ich lrw nf_conntrack gf128mul libcrc32c mei_me<br>
&gt; glue_helper sb_edac ablk_helper cryptd edac_core joydev mei lpc_ich<br=
>
&gt; ioatdma lp ipmi_si shpchp wmi mac_hid parport ses enclosure<br>
&gt; hid_generic igb usbhid ixgbe mpt2sas ahci hid i2c_algo_bit libahci dca=
<br>
&gt; raid_class ptp mdio scsi_transport_sas pps_core<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.817125] CPU: 13 PID: 32401<br>
&gt; Comm: swift-object-se Not tainted 3.13.0-32-generic #57-Ubuntu<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.819020] Hardware name: Silicon=
<br>
&gt; Mechanics Storform iServ R518.v4/X9DRH-7TF/7F/iTF/iF, BIOS 3.0b<br>
&gt; 04/28/2014<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.821235] task: ffff880017d68000=
<br>
&gt; ti: ffff8808e87e4000 task.ti: ffff8808e87e4000<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.822889] RIP:<br>
&gt; 0010:[&lt;ffffffffa041a99a&gt;] [&lt;ffffffffa041a99a&gt;]<br>
&gt; xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.825117] RSP:<br>
&gt; 0018:ffff8808e87e5e38 EFLAGS: 00010202<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.826296] RAX: ffffffffa0458360<=
br>
&gt; RBX: 0000000000000004 RCX: 0000000000000000<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.905158] RDX: 0000000000000002<=
br>
&gt; RSI: 0000000000000002 RDI: 0000000000000000<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607696.987107] RBP: ffff8808e87e5e88<=
br>
&gt; R08: 000000020079e3b9 R09: 0000000000000004<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.069214] R10: 00000000000003e0<=
br>
&gt; R11: 00000000000005b0 R12: ffff88104d0c0800<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.151676] R13: ffff8808e87e5f20<=
br>
&gt; R14: ffff88004988f000 R15: 0000000000000000<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.234244] FS:<br>
&gt; 00007fe74c9fb740(0000) GS:ffff88085fce0000(0000)<br>
&gt; knlGS:0000000000000000<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.318842] CS: 0010 DS: 0000 ES:<=
br>
&gt; 0000 CR0: 0000000080050033<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.361609] CR2: 0000000000000001<=
br>
&gt; CR3: 0000000bcb9b1000 CR4: 00000000001407e0<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.445360] Stack:<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.485796] ffff8808e87e5e88<br>
&gt; ffffffffa03e2a33 ffff8808e87e5e58 ffffffff817205f9<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.567306] ffff8808e87e5eb8<br>
&gt; ffff88084e1e6700 ffff88004988f000 ffff8808e87e5f20<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.648568] 0000000000000082<br>
&gt; 00007fe7487aa7a6 ffff8808e87e5ec0 ffffffffa03e2e0b<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.729785] Call Trace:<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.769297] [&lt;ffffffffa03e2a33&=
gt;] ?<br>
&gt; xfs_dir2_sf_getdents+0x263/0x2a0 [xfs]<br>
<br>
</div></div>We&#39;re called from here attempting to list a directory, whic=
h appears to<br>
be the following block of code:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ...<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 sfp =3D (xfs_dir2_sf_hdr_t *)dp-&gt;i_df.if_u1.=
if_data;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ...<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ctx-&gt;pos &lt;=3D dotdot_offset) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ino =3D dp-&gt;d_op=
s-&gt;sf_get_parent_ino(sfp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctx-&gt;pos =3D dot=
dot_offset &amp; 0x7fffffff;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!dir_emit(ctx, =
&quot;..&quot;, 2, ino, DT_DIR))<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
It wants to emit the &quot;..&quot; directory entry and apparently the in-c=
ore<br>
data fork is NULL. There&#39;s an assertion against that earlier in the<br>
function so I take it the expectation is that this has been read/set<br>
beforehand. In fact, if this is a short form directory I also take it<br>
this should be set to if_inline_data, which appears to be part of the<br>
fork allocation itself.<br>
<br>
It&#39;s not immediately clear to me how this could happen. First off, it<b=
r>
would probably be good to determine whether this is a runtime issue or<br>
due to some kind of on-disk problem. Some questions:<br>
<br>
- Is this (and how often) reproducible?<br>
- Have you identified which directory in your fs that the object server<br>
=C2=A0 is attempting to enumerate when this occurs?<br>
- Do you have any other, related output in /var/log/messages prior to<br>
=C2=A0 this event? E.g., corruption messages or anything of that nature?<br=
>
- Have you tried an &#39;xfs_repair -n&#39; of the affected filesystem? Not=
e<br>
=C2=A0 that -n will report problems only and prevent any modification by<br=
>
=C2=A0 repair.<br>
<br>
Brian<br>
<div><div class=3D"h5"><br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.809560] [&lt;ffffffff817205f9&=
gt;] ?<br>
&gt; schedule_preempt_disabled+0x29/0x70<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.849087] [&lt;ffffffffa03e2e0b&=
gt;]<br>
&gt; xfs_readdir+0xeb/0x110 [xfs]<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.887918] [&lt;ffffffffa03e4a3b&=
gt;]<br>
&gt; xfs_file_readdir+0x2b/0x40 [xfs]<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.926061] [&lt;ffffffff811d0035&=
gt;]<br>
&gt; iterate_dir+0xa5/0xe0<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607697.963349] [&lt;ffffffff8109ddf4&=
gt;] ?<br>
&gt; vtime_account_user+0x54/0x60<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607698.000413] [&lt;ffffffff811d0492&=
gt;]<br>
&gt; SyS_getdents+0x92/0x120<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607698.037112] [&lt;ffffffff811d0150&=
gt;] ?<br>
&gt; fillonedir+0xe0/0xe0<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607698.072867] [&lt;ffffffff8172c81c&=
gt;] ?<br>
&gt; tracesys+0x7e/0xe6<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607698.107679] [&lt;ffffffff8172c87f&=
gt;]<br>
&gt; tracesys+0xe1/0xe6<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607698.141543] Code: 00 48 8b 06 48<b=
r>
&gt; ba ff ff ff ff ff ff ff 00 5d 48 0f c8 48 21 d0 c3 66 66 2e 0f 1f 84<b=
r>
&gt; 00 00 00 00 00 0f 1f 44 00 00 55 48 8d 77 02 &lt;0f&gt; b6 7f 01 48 89=
 e5 e8<br>
&gt; aa ff ff ff 5d c3 0f 1f 84 00 00 00 00<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607698.244881] RIP<br>
&gt; [&lt;ffffffffa041a99a&gt;] xfs_dir2_sf_get_parent_ino+0xa/0x20 [xfs]<b=
r>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607698.310872] RSP &lt;ffff8808e87e5e=
38&gt;<br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607698.343092] CR2: 0000000000000001<=
br>
&gt; Jun 15 09:49:30 r1obj02 kernel: [607698.420933] ---[ end trace<br>
&gt; ba3fdf319346b7e6 ]---<br>
&gt;<br>
&gt; Thanks // Hugo Kuo<br>
&gt; =E2=80=8B<br>
<br>
</div></div>&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer"=
 target=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
<br>
</blockquote></div><br></div>

--047d7b4724e26ab5ed0518cba103--


--===============0856738379622962846==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0856738379622962846==--
