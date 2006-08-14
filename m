Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Aug 2006 02:56:42 -0700 (PDT)
Received: from dmz.tecosim.de (dmz.tecosim.com [195.135.152.162])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7E9uRDW005996
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 02:56:27 -0700
Subject: Re: Negligible improvement when using su/sw for hardware RAID5,
	expected?
From: utz lehmann <u.lehmann@de.tecosim.com>
In-Reply-To: <44DD46A5.7010308@comcast.net>
References: <44DD46A5.7010308@comcast.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fuAbNIqoNHd6p7/e6F08"
Date: Mon, 14 Aug 2006 10:51:34 +0200
Message-Id: <1155545494.1238.11.camel@donner.tecosim.de>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brian Davis <bridavis@comcast.net>
Cc: xfs@oss.sgi.com

--=-fuAbNIqoNHd6p7/e6F08
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi

You are using a partition. Is it correctly aligned? Usually the first
partition starts at sector 63. Which is in the middle of your stripe.
Use the whole disk (/dev/sda) or align the start of the partition to a
multiple of the stripe size.
But i doubt you will see a performance improvement with such a simple
test (single threaded sequential read/ write).


utz=20

On Fri, 2006-08-11 at 23:10 -0400, Brian Davis wrote:
> Is this expected? I thought I would see more improvement when tweaking=20
> my su/sw values for hardware RAID 5.
>=20
> Details, 3x300GB drives, 3Ware 7506-4LP Hardware RAID 5 using a 64K=20
> stripe size (non-configurable on this card).
>=20
> FS creation and Bonnie++ results:
>=20
> Untweaked:---------------------------------------------------------------=
-------=20
>=20
>=20
> localhost / # mkfs.xfs -f /dev/sda1
> meta-data=3D/dev/sda1              isize=3D256    agcount=3D32, agsize=3D=
4578999=20
> blks
>         =3D                       sectsz=3D512   attr=3D0
> data     =3D                       bsize=3D4096   blocks=3D146527968, ima=
xpct=3D25
>         =3D                       sunit=3D0      swidth=3D0 blks, unwritt=
en=3D1
> naming   =3Dversion 2              bsize=3D4096
> log      =3Dinternal log           bsize=3D4096   blocks=3D32768, version=
=3D1
>         =3D                       sectsz=3D512   sunit=3D0 blks
> realtime =3Dnone                   extsz=3D65536  blocks=3D0, rtextents=
=3D0
> localhost / # mount -t xfs /dev/sda1 /raid
> localhost / # cd /raid
> localhost raid # bonnie++ -n0 -u0 -r 768 -s 30720 -b -f
> Using uid:0, gid:0.
> Writing intelligently...done
> Rewriting...done
> Reading intelligently...done
> start 'em...done...done...done...done...done...
> Version 1.93c       ------Sequential Output------ --Sequential Input-=20
> --Random-
> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--=20
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP=20=
=20
> /sec %CP
> localhost       30G           27722  40 23847  37           98367  99=20=
=20
> 88.6  11
> Latency                         891ms     693ms             16968us=20=20=
=20=20=20
> 334ms
>=20
> Tweaked:-----------------------------------------------------------------=
--------=20
>=20
>=20
> localhost / # mkfs.xfs -f -d sw=3D2,su=3D64k /dev/sda1
> meta-data=3D/dev/sda1              isize=3D256    agcount=3D32, agsize=3D=
4578992=20
> blks
>         =3D                       sectsz=3D512   attr=3D0
> data     =3D                       bsize=3D4096   blocks=3D146527744, ima=
xpct=3D25
>         =3D                       sunit=3D16     swidth=3D32 blks, unwrit=
ten=3D1
> naming   =3Dversion 2              bsize=3D4096
> log      =3Dinternal log           bsize=3D4096   blocks=3D32768, version=
=3D1
>         =3D                       sectsz=3D512   sunit=3D0 blks
> realtime =3Dnone                   extsz=3D65536  blocks=3D0, rtextents=
=3D0
> localhost / # mount -t xfs /dev/sda1 /raid
> localhost / # cd /raid
> localhost raid # bonnie++ -n0 -u0 -r 768 -s 30720 -b -f
> Using uid:0, gid:0.
> Writing intelligently...done
> Rewriting...done
> Reading intelligently...done
> start 'em...done...done...done...done...done...
> Version 1.93c       ------Sequential Output------ --Sequential Input-=20
> --Random-
> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--=20
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP=20=
=20
> /sec %CP
> localhost       30G           27938  43 23880  40           98066  99=20=
=20
> 91.8   9
> Latency                         772ms     584ms             19889us=20=20=
=20=20=20
> 340ms
>=20
--=20
    <>        utz lehmann
  <>  <>      u.lehmann@de.tecosim.com
<>  <>  <>    TECOSIM GmbH / IT
  <>  <>      +49(0)-6142-82720
    <>        http://www.tecosim.com/


--=-fuAbNIqoNHd6p7/e6F08
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBE4DmW7OmPIkYy5+4RAsUpAKCAhrRtilHrKspv9qaSKCvKL6SwcQCfUig2
TGU7L3/8iIytRMflps/Ukoc=
=txA+
-----END PGP SIGNATURE-----

--=-fuAbNIqoNHd6p7/e6F08--
