Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D743E7CBF
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 08:52:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 48BCDAC002
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 06:52:24 -0700 (PDT)
Received: from mail-ie0-f169.google.com (mail-ie0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	ABcF0Jo6t5ZjfBR0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Apr 2013 06:52:19 -0700 (PDT)
Received: by mail-ie0-f169.google.com with SMTP id ar20so103913iec.14
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 06:52:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130410121025.78a42b22@harpe.intellique.com>
References: <CADFMGuJm5bPPwbbUtYwrCVDL23KExJTw_-VRX2UEEdZjo+i5oA@mail.gmail.com>
	<CADFMGu+=MM2yc=_peboV7JTNJ8F05TJfexmEErzcf0D8mAWFRg@mail.gmail.com>
	<CADFMGuKqkPbpcU=taqjTR4sA3o=w1LLAnKoEuj=OhJqEbQVijw@mail.gmail.com>
	<20130409145238.GE22182@sgi.com>
	<CADFMGuJaiH0wuxOHrDjDn7qRVH+vQkLOOSPUyqSdXnLcS47t3w@mail.gmail.com>
	<CADFMGu+TdyjTjMTWMwpdHqmszhpCU162UA4Y-njARwSEjM1xNw@mail.gmail.com>
	<20130410121025.78a42b22@harpe.intellique.com>
Date: Wed, 10 Apr 2013 21:52:19 +0800
Message-ID: <CADFMGu+yCg4ux0n6S98bqm_cXc=VCcijVBTqwRxvxmtKt_JO-A@mail.gmail.com>
Subject: Re: need help how to debug xfs crash issue xfs_iunlink_remove:
	xfs_inotobp() returned error 22
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4073388981736794205=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Ben Myers <bpm@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============4073388981736794205==
Content-Type: multipart/alternative; boundary=14dae9340ee78447c804da01fa81

--14dae9340ee78447c804da01fa81
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

The storage info is as following:
RAID-6
SATA HDD
Controller: PERC H710P Mini (Embedded)
Disk /dev/sdb: 30000.3 GB, 30000346562560 bytes
255 heads, 63 sectors/track, 3647334 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

sd 0:2:1:0: [sdb] 58594426880 512-byte logical blocks: (30.0 TB/27.2 TiB)
sd 0:2:1:0: [sdb] Write Protect is off
sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08
sd 0:2:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:2:1:0: [sdb] Attached SCSI disk

*-storage
       description: RAID bus controller
       product: MegaRAID SAS 2208 [Thunderbolt]
       vendor: LSI Logic / Symbios Logic
       physical id: 0
       bus info: pci@0000:02:00.0
       logical name: scsi0
       version: 01
       width: 64 bits
       clock: 33MHz
       capabilities: storage pm pciexpress vpd msi msix bus_master cap_list
rom
       configuration: driver=3Dmegaraid_sas latency=3D0
       resources: irq:42 ioport:fc00(size=3D256) memory:dd7fc000-dd7fffff
memory:dd780000-dd7bffff memory:dc800000-dc81ffff(prefetchable)
     *-disk:0
          description: SCSI Disk
          product: PERC H710P
          vendor: DELL
          physical id: 2.0.0
          bus info: scsi@0:2.0.0
          logical name: /dev/sda
          version: 3.13
          serial: 0049d6ce1d9f2035180096fde490f648
          size: 558GiB (599GB)
          capabilities: partitioned partitioned:dos
          configuration: ansiversion=3D5 signature=3D000aa336
     *-disk:1
          description: SCSI Disk
          product: PERC H710P
          vendor: DELL
          physical id: 2.1.0
          bus info: scsi@0:2.1.0
          logical name: /dev/sdb
          logical name: /mnt/xfsd
          version: 3.13
          serial: 003366f71da22035180096fde490f648
          size: 27TiB (30TB)
          configuration: ansiversion=3D5 mount.fstype=3Dxfs
mount.options=3Drw,relatime,attr2,delaylog,logbsize=3D64k,sunit=3D128,swidt=
h=3D1280,noquota
state=3Dmounted

Thank you.


2013/4/10 Emmanuel Florac <eflorac@intellique.com>

> Le Tue, 9 Apr 2013 23:10:03 +0800
> =B7=FB=D3=C0=CC=CE <yongtaofu@gmail.com> =A8=A6crivait:
>
> > > Apr  9 11:01:30 cqdx kernel: XFS (sdb): I/O Error Detected.
> > > Shutting down filesystem
>
> This. I/O error detected. That means that at some point the underlying
> device (disk, RAID array, SAN volume) couldn't be reached. So this
> could very well be a case of a flakey drive, array, cable or SCSI
> driver.
>
> What's the storage setup here?
>
> --
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
>



--=20
=B7=FB=D3=C0=CC=CE

--14dae9340ee78447c804da01fa81
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The storage info is as following:<div><span style=3D"color=
:rgb(51,51,51);font-family:arial,verdana,sans-serif;font-size:12px;line-hei=
ght:20px">RAID-6</span><br></div><div><span style=3D"color:rgb(51,51,51);fo=
nt-family:arial,verdana,sans-serif;font-size:12px;line-height:20px">SATA HD=
D</span><span style=3D"color:rgb(51,51,51);font-family:arial,verdana,sans-s=
erif;font-size:12px;line-height:20px"><br>
</span></div><div style><span style=3D"color:rgb(51,51,51);font-family:aria=
l,verdana,sans-serif;font-size:12px;line-height:20px">Controller:&nbsp;</sp=
an><font color=3D"#333333" face=3D"arial, verdana, sans-serif"><span style=
=3D"font-size:12px;line-height:20px">PERC H710P Mini (Embedded)</span></fon=
t></div>
<div style><font color=3D"#333333" face=3D"arial, verdana, sans-serif"><spa=
n style=3D"font-size:12px;line-height:20px"><div>Disk /dev/sdb: 30000.3 GB,=
 30000346562560 bytes</div><div>255 heads, 63 sectors/track, 3647334 cylind=
ers</div>
<div>Units =3D cylinders of 16065 * 512 =3D 8225280 bytes</div><div>Sector =
size (logical/physical): 512 bytes / 512 bytes</div><div>I/O size (minimum/=
optimal): 512 bytes / 512 bytes</div><div>Disk identifier: 0x00000000</div>
<div><br></div><div><div>sd 0:2:1:0: [sdb] 58594426880 512-byte logical blo=
cks: (30.0 TB/27.2 TiB)</div><div>sd 0:2:1:0: [sdb] Write Protect is off</d=
iv><div>sd 0:2:1:0: [sdb] Mode Sense: 1f 00 00 08</div><div>sd 0:2:1:0: [sd=
b] Write cache: enabled, read cache: enabled, doesn&#39;t support DPO or FU=
A</div>
<div>sd 0:2:1:0: [sdb] Attached SCSI disk</div></div><div><br></div><div><d=
iv>*-storage &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</div><d=
iv>&nbsp; &nbsp; &nbsp; &nbsp;description: RAID bus controller</div><div>&n=
bsp; &nbsp; &nbsp; &nbsp;product: MegaRAID SAS 2208 [Thunderbolt]</div><div=
>
&nbsp; &nbsp; &nbsp; &nbsp;vendor: LSI Logic / Symbios Logic</div><div>&nbs=
p; &nbsp; &nbsp; &nbsp;physical id: 0</div><div>&nbsp; &nbsp; &nbsp; &nbsp;=
bus info: pci@0000:02:00.0</div><div>&nbsp; &nbsp; &nbsp; &nbsp;logical nam=
e: scsi0</div><div>&nbsp; &nbsp; &nbsp; &nbsp;version: 01</div><div>&nbsp; =
&nbsp; &nbsp; &nbsp;width: 64 bits</div><div>
&nbsp; &nbsp; &nbsp; &nbsp;clock: 33MHz</div><div>&nbsp; &nbsp; &nbsp; &nbs=
p;capabilities: storage pm pciexpress vpd msi msix bus_master cap_list rom<=
/div><div>&nbsp; &nbsp; &nbsp; &nbsp;configuration: driver=3Dmegaraid_sas l=
atency=3D0</div><div>&nbsp; &nbsp; &nbsp; &nbsp;resources: irq:42 ioport:fc=
00(size=3D256) memory:dd7fc000-dd7fffff memory:dd780000-dd7bffff memory:dc8=
00000-dc81ffff(prefetchable)</div>
<div>&nbsp; &nbsp; &nbsp;*-disk:0</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; description: SCSI Disk</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; pro=
duct: PERC H710P</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; vendor: DELL<=
/div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; physical id: 2.0.0</div><div>&=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bus info: scsi@0:2.0.0</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /dev/sda</div><div>&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; version: 3.13</div><div>&nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; serial: 0049d6ce1d9f2035180096fde490f648</div><div>&nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; size: 558GiB (599GB)</div><div>&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; capabilities: partitioned partitioned:dos</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; configuration: ansiversion=3D5 sign=
ature=3D000aa336</div><div>&nbsp; &nbsp; &nbsp;*-disk:1</div><div>&nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; description: SCSI Disk</div><div>&nbsp; &nbsp; &n=
bsp; &nbsp; &nbsp; product: PERC H710P</div><div>&nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; vendor: DELL</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; physical=
 id: 2.1.0</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bus info: scsi@0:2.1.0</div><div>&n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; logical name: /dev/sdb</div><div>&nbsp; &n=
bsp; &nbsp; &nbsp; &nbsp; logical name: /mnt/xfsd</div><div>&nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; version: 3.13</div><div>&nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; serial: 003366f71da22035180096fde490f648</div>
<div>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; size: 27TiB (30TB)</div><div>&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp; configuration: ansiversion=3D5 mount.fstype=3D=
xfs mount.options=3Drw,relatime,attr2,delaylog,logbsize=3D64k,sunit=3D128,s=
width=3D1280,noquota state=3Dmounted</div></div><div><br></div>
<div style>Thank you.</div></span></font></div></div><div class=3D"gmail_ex=
tra"><br><br><div class=3D"gmail_quote">2013/4/10 Emmanuel Florac <span dir=
=3D"ltr">&lt;<a href=3D"mailto:eflorac@intellique.com" target=3D"_blank">ef=
lorac@intellique.com</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Le Tue, 9 Apr 2013 23:10:03 +0800<br>
=B7=FB=D3=C0=CC=CE &lt;<a href=3D"mailto:yongtaofu@gmail.com">yongtaofu@gma=
il.com</a>&gt; =A8=A6crivait:<br>
<div class=3D"im"><br>
&gt; &gt; Apr &nbsp;9 11:01:30 cqdx kernel: XFS (sdb): I/O Error Detected.<=
br>
&gt; &gt; Shutting down filesystem<br>
<br>
</div>This. I/O error detected. That means that at some point the underlyin=
g<br>
device (disk, RAID array, SAN volume) couldn&#39;t be reached. So this<br>
could very well be a case of a flakey drive, array, cable or SCSI<br>
driver.<br>
<br>
What&#39;s the storage setup here?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
------------------------------------------------------------------------<br=
>
Emmanuel Florac &nbsp; &nbsp; | &nbsp; Direction technique<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nb=
sp; Intellique<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nb=
sp; &lt;<a href=3D"mailto:eflorac@intellique.com">eflorac@intellique.com</a=
>&gt;<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | &nb=
sp; +33 1 78 94 84 02<br>
------------------------------------------------------------------------<br=
>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r>=B7=FB=D3=C0=CC=CE
</div>

--14dae9340ee78447c804da01fa81--


--===============4073388981736794205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4073388981736794205==--
