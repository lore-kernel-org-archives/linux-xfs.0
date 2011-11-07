Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7Ei8Ob062530 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 08:44:08 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6604227CAF
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 06:44:07 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	damAx9YADGZJpm8o for <xfs@oss.sgi.com>;
	Mon, 07 Nov 2011 06:44:07 -0800 (PST)
Received: by iaen33 with SMTP id n33so512051iae.26
	for <xfs@oss.sgi.com>; Mon, 07 Nov 2011 06:44:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAF7KpS_g1Zt9ubuXG3kqoUORUq04FNFwKbSYGKHLxkPWbcyR4A@mail.gmail.com>
References: <CAF7KpS_g1Zt9ubuXG3kqoUORUq04FNFwKbSYGKHLxkPWbcyR4A@mail.gmail.com>
Date: Mon, 7 Nov 2011 15:44:07 +0100
Message-ID: <CAMYYbY5TzxQrsfQ5ghP4VwZoQq62f4+Q4Wti2Zk6HKSWpRG1Ww@mail.gmail.com>
Subject: Re: Advanced format disk
From: Martin Rusko <martin.rusko@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Zhu Han <schumi.han@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Nov 7, 2011 at 3:12 AM, Zhu Han <schumi.han@gmail.com> wrote:
> Hi,
>
> I got several advanced format disk, whose physical size is 4096 bytes, but
> its logical size is 512 bytes:
> $ sudo fdisk -l /dev/sdb
>
> Disk /dev/sdb: 750.2 GB, 750156374016 bytes
> 255 heads, 63 sectors/track, 91201 cylinders
> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>
> Disk /dev/sdb doesn't contain a valid partition table
>
> Is there any special tuning knob I should notice before formating it? IMH=
O,
> set the sector size as 4096 bytes is enough. The default block size is 40=
96
> bytes.
> $ sudo xfs_info /dev/sdb
> meta-data=3D/dev/sdb=A0=A0=A0=A0=A0=A0=A0=A0 isize=3D256=A0=A0=A0 agcount=
=3D4, agsize=3D45785912 blks
> =A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0 =A0 =A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sectsz=3D4096=A0 attr=3D2
> data=A0=A0=A0 =A0 =A0 =A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 bsize=3D4096=A0=A0 blocks=3D183143646,
> imaxpct=3D25
> =A0=A0=A0=A0=A0=A0=A0 =A0 =A0 =A0 =A0 =A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sunit=3D0=A0=A0=A0=A0=A0 swidth=3D0=
 blks
> naming=A0=A0=A0=A0=A0 =3D=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 version 2=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bsiz=
e=3D4096
> ascii-ci=3D0
> log=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3Dinternal=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 bsize=3D4096=A0=A0 blocks=3D89425, version=3D2
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =3D=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sectsz=3D4096=A0 sunit=3D1 bl=
ks,
> lazy-count=3D1
> realtime=A0=A0 =3Dnone=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 extsz=3D4096=A0=A0 blocks=3D0, rtextents=3D0
>
>

One thing is to make sure, that your partitions are aligned to
physical sector size. Recent fdisk will do it properly. See options
'-c' (or 'c' in interactive mode) which sets DOS compatibility mode
and '-u' (or 'u' in interactive mode) which sets units which fdisk
uses. You want no DOS compatibility and units of sectors. Then first
partition starts on 2048 sector (so 1MiB is available for GRUB for
example) and it's gets things nicely aligned ... 2048 logical sectors
=3D 256 physical sectors.

If you are creating more than one partition, use something like +34G
while specifying end of the partition (so the next one is aligned as
well).

Martin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
