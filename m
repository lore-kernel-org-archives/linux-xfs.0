Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7BAvOI2219309 for <xfs@oss.sgi.com>; Sat, 11 Aug 2012 05:57:24 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id uwUnlOSaKnOCEnLD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 11 Aug 2012 03:57:22 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair - segemnation fault | git error
Date: Sat, 11 Aug 2012 12:57:21 +0200
Message-ID: <1488479.ZDGdaNpFNb@saturn>
In-Reply-To: <CADcDJaR52zwL+aMaUuQTvbYx2d11LRmzdURE2Ok8z0tKsYTv8A@mail.gmail.com>
References: <CADcDJaR52zwL+aMaUuQTvbYx2d11LRmzdURE2Ok8z0tKsYTv8A@mail.gmail.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4804152890922315483=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Velimir Galic <veli.galic@gmail.com>


--===============4804152890922315483==
Content-Type: multipart/signed; boundary="nextPart2695753.F6Iyytry71"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart2695753.F6Iyytry71
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 10. August 2012, 10:23:03 schrieb Velimir Galic:
> a second disk got lost in the raid. The raidsync wasn't finished and
> now i'm fighting 3 weeks or more i don't no any more :-( to repair
> the file system.=20

How far did the recovery go when it broke? If it was on 10% when the 2n=
d=20
disk broke, you can stop to try to get anything. If it was 90% finished=
,=20
you might have a chance...

> 4x2GB | RAID 5 | Softraid

This is a 6GB net RAID 5 device? Which devices?

> I tried a lot of different versions of xfs_repair

I hope you got a copy of all disks before you even tried to repair?=20
Otherwise it might be too late now, when repair wrote something on that=
=20
device.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart2695753.F6Iyytry71
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlAmOpEACgkQzhSR9xwSCbRnIQCdEsWsFeCXRM0FrURAf37CMhSl
V40An0fWDjIBBK3sFu/ykslgudcIqLIC
=Ytoe
-----END PGP SIGNATURE-----

--nextPart2695753.F6Iyytry71--


--===============4804152890922315483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4804152890922315483==--
