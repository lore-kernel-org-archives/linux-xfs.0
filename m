Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7EpJnv062877 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 08:51:19 -0600
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E7871F2F883
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 06:51:17 -0800 (PST)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	bzALsiieLA9vp3HF for <xfs@oss.sgi.com>;
	Mon, 07 Nov 2011 06:51:17 -0800 (PST)
Received: by gyd10 with SMTP id 10so7530228gyd.26
	for <xfs@oss.sgi.com>; Mon, 07 Nov 2011 06:51:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMYYbY5TzxQrsfQ5ghP4VwZoQq62f4+Q4Wti2Zk6HKSWpRG1Ww@mail.gmail.com>
References: <CAF7KpS_g1Zt9ubuXG3kqoUORUq04FNFwKbSYGKHLxkPWbcyR4A@mail.gmail.com>
	<CAMYYbY5TzxQrsfQ5ghP4VwZoQq62f4+Q4Wti2Zk6HKSWpRG1Ww@mail.gmail.com>
Date: Mon, 7 Nov 2011 22:51:17 +0800
Message-ID: <CAF7KpS-7Vqjn07DvvVgO8xizAGnpLVZkaUNSZQ24+7NviDPO=A@mail.gmail.com>
Subject: Re: Advanced format disk
From: Zhu Han <schumi.han@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3011836099387101356=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Rusko <martin.rusko@gmail.com>
Cc: xfs@oss.sgi.com

--===============3011836099387101356==
Content-Type: multipart/alternative; boundary=20cf303a2d13e92e1704b1262fba

--20cf303a2d13e92e1704b1262fba
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Nov 7, 2011 at 10:44 PM, Martin Rusko <martin.rusko@gmail.com>wrote:

> On Mon, Nov 7, 2011 at 3:12 AM, Zhu Han <schumi.han@gmail.com> wrote:
> > Hi,
> >
> > I got several advanced format disk, whose physical size is 4096 bytes,
> but
> > its logical size is 512 bytes:
> > $ sudo fdisk -l /dev/sdb
> >
> > Disk /dev/sdb: 750.2 GB, 750156374016 bytes
> > 255 heads, 63 sectors/track, 91201 cylinders
> > Units = cylinders of 16065 * 512 = 8225280 bytes
> > Sector size (logical/physical): 512 bytes / 4096 bytes
> > I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> > Disk identifier: 0x00000000
> >
> > Disk /dev/sdb doesn't contain a valid partition table
> >
> > Is there any special tuning knob I should notice before formating it?
> IMHO,
> > set the sector size as 4096 bytes is enough. The default block size is
> 4096
> > bytes.
> > $ sudo xfs_info /dev/sdb
> > meta-data=/dev/sdb         isize=256    agcount=4, agsize=45785912 blks
> >                   =                       sectsz=4096  attr=2
> > data          =                       bsize=4096   blocks=183143646,
> > imaxpct=25
> >                   =                       sunit=0      swidth=0 blks
> > naming      =                        version 2              bsize=4096
> > ascii-ci=0
> > log            =internal               bsize=4096   blocks=89425,
> version=2
> >                  =                       sectsz=4096  sunit=1 blks,
> > lazy-count=1
> > realtime   =none                   extsz=4096   blocks=0, rtextents=0
> >
> >
>
> One thing is to make sure, that your partitions are aligned to
> physical sector size. Recent fdisk will do it properly. See options
> '-c' (or 'c' in interactive mode) which sets DOS compatibility mode
> and '-u' (or 'u' in interactive mode) which sets units which fdisk
> uses. You want no DOS compatibility and units of sectors. Then first
> partition starts on 2048 sector (so 1MiB is available for GRUB for
> example) and it's gets things nicely aligned ... 2048 logical sectors
> = 256 physical sectors.
>

If the whole disk is used for the file system (it is not a bootable disk so
no partition is created), can I ignore these settings safely?


>
> If you are creating more than one partition, use something like +34G
> while specifying end of the partition (so the next one is aligned as
> well).
>
> Martin
>

--20cf303a2d13e92e1704b1262fba
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br>
<br><br><div class=3D"gmail_quote">On Mon, Nov 7, 2011 at 10:44 PM, Martin =
Rusko <span dir=3D"ltr">&lt;<a href=3D"mailto:martin.rusko@gmail.com">marti=
n.rusko@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div><div></div><div class=3D"h5">On Mon, Nov 7, 2011 at 3:12 AM, Zhu Han &=
lt;<a href=3D"mailto:schumi.han@gmail.com">schumi.han@gmail.com</a>&gt; wro=
te:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I got several advanced format disk, whose physical size is 4096 bytes,=
 but<br>
&gt; its logical size is 512 bytes:<br>
&gt; $ sudo fdisk -l /dev/sdb<br>
&gt;<br>
&gt; Disk /dev/sdb: 750.2 GB, 750156374016 bytes<br>
&gt; 255 heads, 63 sectors/track, 91201 cylinders<br>
&gt; Units =3D cylinders of 16065 * 512 =3D 8225280 bytes<br>
&gt; Sector size (logical/physical): 512 bytes / 4096 bytes<br>
&gt; I/O size (minimum/optimal): 4096 bytes / 4096 bytes<br>
&gt; Disk identifier: 0x00000000<br>
&gt;<br>
&gt; Disk /dev/sdb doesn&#39;t contain a valid partition table<br>
&gt;<br>
&gt; Is there any special tuning knob I should notice before formating it? =
IMHO,<br>
&gt; set the sector size as 4096 bytes is enough. The default block size is=
 4096<br>
&gt; bytes.<br>
&gt; $ sudo xfs_info /dev/sdb<br>
&gt; meta-data=3D/dev/sdb=A0=A0=A0=A0=A0=A0=A0=A0 isize=3D256=A0=A0=A0 agco=
unt=3D4, agsize=3D45785912 blks<br>
&gt; =A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0 =A0 =A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sectsz=3D4096=A0 attr=3D2<br>
&gt; data=A0=A0=A0 =A0 =A0 =A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 bsize=3D4096=A0=A0 blocks=3D183143646,<br>
&gt; imaxpct=3D25<br>
&gt; =A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0 =A0 =A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sunit=3D0=A0=A0=A0=A0=A0 swidth=
=3D0 blks<br>
&gt; naming=A0=A0=A0=A0=A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 version 2=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 b=
size=3D4096<br>
&gt; ascii-ci=3D0<br>
&gt; log=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3Dinternal=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 bsize=3D4096=A0=A0 blocks=3D89425, version=3D2<br>
&gt; =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sectsz=3D4096=A0 sunit=3D1=
 blks,<br>
&gt; lazy-count=3D1<br>
&gt; realtime=A0=A0 =3Dnone=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 extsz=3D4096=A0=A0 blocks=3D0, rtextents=3D0<br>
&gt;<br>
&gt;<br>
<br>
</div></div>One thing is to make sure, that your partitions are aligned to<=
br>
physical sector size. Recent fdisk will do it properly. See options<br>
&#39;-c&#39; (or &#39;c&#39; in interactive mode) which sets DOS compatibil=
ity mode<br>
and &#39;-u&#39; (or &#39;u&#39; in interactive mode) which sets units whic=
h fdisk<br>
uses. You want no DOS compatibility and units of sectors. Then first<br>
partition starts on 2048 sector (so 1MiB is available for GRUB for<br>
example) and it&#39;s gets things nicely aligned ... 2048 logical sectors<b=
r>
=3D 256 physical sectors.<br></blockquote><div><br>If the whole disk is use=
d for the file system (it is not a bootable disk so no partition is created=
), can I ignore these settings safely?<br>=A0<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rg=
b(204, 204, 204); padding-left: 1ex;">

<br>
If you are creating more than one partition, use something like +34G<br>
while specifying end of the partition (so the next one is aligned as<br>
well).<br>
<font color=3D"#888888"><br>
Martin<br>
</font></blockquote></div><br>

--20cf303a2d13e92e1704b1262fba--


--===============3011836099387101356==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3011836099387101356==--
