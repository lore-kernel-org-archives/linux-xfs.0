Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Sep 2006 11:30:12 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8BIU0if006161
	for <linux-xfs@oss.sgi.com>; Mon, 11 Sep 2006 11:30:00 -0700
Subject: Re: Mounting IRIX disk on Linux
From: Russell Cattelan <cattelan@thebarn.com>
In-Reply-To: <45053B2D.50203@crc.dk>
References: <45053B2D.50203@crc.dk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yYy194lQdmz6sZbIXzy2"
Date: Mon, 11 Sep 2006 11:21:55 -0500
Message-Id: <1157991715.3651.14.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mogens Kjaer <mk@crc.dk>
Cc: linux-xfs@oss.sgi.com

--=-yYy194lQdmz6sZbIXzy2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Was this disk cleanly unmounted from the SGI box?

If the log is dirty linux won't be able to mount it since it will be
in the wrong endian format (well assuming you are using a=20
little endian linux box)

If you can cleanly mount and unmount on the sgi box
if that is not possible run xfs_repair -L to clear
the log. But not that will potentially loose important
file system info.


On Mon, 2006-09-11 at 12:32 +0200, Mogens Kjaer wrote:
> When I try to mount a disk from our SGI Origin 200
> machine under Linux (Fedora Core 5), I get the following error message:
>=20
> # mount /dev/sda1 /mnt/sgi
> mount: Function not implemented
>=20
> The partitions are found during boot:
>=20
> ...
> SCSI device sda: 143374738 512-byte hdwr sectors (73408 MB)
> sda: Write Protect is off
> sda: Mode Sense: 9f 00 10 08
> SCSI device sda: drive cache: write back w/ FUA
> SCSI device sda: 143374738 512-byte hdwr sectors (73408 MB)
> sda: Write Protect is off
> sda: Mode Sense: 9f 00 10 08
> SCSI device sda: drive cache: write back w/ FUA
>  sda: sda1 sda2 sda9 sda11
> ...
> # fdisk -l /dev/sda
>=20
> Disk /dev/sda (SGI disk label): 255 heads, 63 sectors, 8924 cylinders
> Units =3D cylinders of 16065 * 512 bytes
>=20
> ----- partitions -----
> Pt#    Device  Info     Start       End   Sectors  Id  System
>  1: /dev/sda1  boot        17      8924 143108498   a  SGI xfs
>  2: /dev/sda2  swap         1        16    262144   3  SGI raw
>  9: /dev/sda3               0         0      4096   0  SGI volhdr
> 11: /dev/sda4               0      8924 143374738   6  SGI volume
> ----- Bootinfo -----
> Bootfile: /unix
> ----- Directory Entries -----
>=20
> The only thing that gets logged during the mount is:
>=20
> SGI XFS with ACLs, security attributes, large block numbers, no debug
> enabled
> SGI XFS Quota Management subsystem
>=20
>=20
> How do I determine which of the requirements
> listed in:
>=20
> http://oss.sgi.com/projects/xfs/faq.html#useirixxfs
>=20
> that hasn't been fulfilled?
>=20
> Mogens

--=-yYy194lQdmz6sZbIXzy2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFBY0jNRmM+OaGhBgRAqyeAJ4un3ZC02TxepQCRCOGkbFx6gEuCgCfTaUK
2SfdjsniqCi5eXriSONVcYQ=
=0x0c
-----END PGP SIGNATURE-----

--=-yYy194lQdmz6sZbIXzy2--
