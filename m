Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CEHcbV080772 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 09:17:58 -0500
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E8E11C3915A
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 07:17:15 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id HXyeHnC5HfW0EOwk for
	<xfs@oss.sgi.com>; Thu, 12 Mar 2009 07:17:15 -0700 (PDT)
Received: from shambhala.lichtvoll.home
	(DSL01.83.171.186.52.ip-pool.NEFkom.net [83.171.186.52])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 121B15ADB7
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 15:17:14 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: LWN article: 4K disk sectors
Date: Thu, 12 Mar 2009 15:17:47 +0100
References: <200903121258.51497@zmi.at> <49B909CC.7080402@sandeen.net>
	<200903121452.16419@zmi.at> (sfid-20090312_151032_516649_56909F94)
In-Reply-To: <200903121452.16419@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903121517.48426.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com

Am Donnerstag 12 M=E4rz 2009 schrieb Michael Monnerie:
> On Donnerstag 12 M=E4rz 2009 Eric Sandeen wrote:
> > Take a look at the mkfs.xfs man page:
> >
> > =A0 =A0 =A0 =A0-s sector_size
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 This option specifies the fundamental =A0se=
ctor =A0size =A0of
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 the filesystem. =A0The sector_size is speci=
fied either as
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 a value in bytes with size=3Dvalue or as a =
base two loga-
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 rithm value with log=3Dvalue. =A0The defaul=
t sector_size is
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 512 bytes. The minimum value for sector =A0=
size =A0is =A0512;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 the =A0maximum is 32768 (32 KiB). The secto=
r_size must be
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 a power of 2 size and cannot be made =A0lar=
ger =A0than =A0the
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 filesystem block size.
>
> Ugh, I felt so good this morning, until you responded ... ;-)
>
> I thought that it's a limitation of the Linux kernel in more parts than
> just the filesystem (like block cache), that sector sizes must be 512B.
> If I had a 4K drive, would that be usable with XFS already?

I have an USB stick with 2KB hardware sector size. It worked nicely when =

using fdisk instead of cfdisk which only supports 512 byte sectors. Dunno =

remember exactly which filesystems I tried back then.

And first I wondered why it had a partition in the first quarter of it and =

then empty space. I thought it might have been a fake 1 GB stick, but =

still just deleted the partition and made it size the whole disk in =

cfdisk - well at least I thought I did. The Linux kernel complained about =

writing beyond end of device while mkfsing, I think it was an ext3.

-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
