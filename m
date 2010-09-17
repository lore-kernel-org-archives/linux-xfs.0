Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8H7rKMF051686 for <xfs@oss.sgi.com>; Fri, 17 Sep 2010 02:53:20 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E33C14F4C86
	for <xfs@oss.sgi.com>; Fri, 17 Sep 2010 01:06:09 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id HhvpVzo31tQH9b1f for
	<xfs@oss.sgi.com>; Fri, 17 Sep 2010 01:06:09 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: LWN.net article: creating 1 billion files -> Tests we did
Date: Fri, 17 Sep 2010 09:54:02 +0200
References: <201008191312.49346@zmi.at>
	<20100916121350.3ab30ca5@harpe.intellique.com>
	<4C9291C3.7000709@hardwarefreak.com>
In-Reply-To: <4C9291C3.7000709@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201009170954.06482@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9151832515910876548=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>

--===============9151832515910876548==
Content-Type: multipart/signed;
  boundary="nextPart3941347.PX5st216nC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3941347.PX5st216nC
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 16. September 2010 Stan Hoeppner wrote:
> So, are you saying I should be able to duplicate your results with
>  that dual Opty system, but using an md RAID0 stripe over 8x2TB SATA
>  disks connected to two $60 4 port SiI 3124 PCIe x1 cards?
=20
According to Dave, with his patches you should even outperform that if=20
you got faster CPUs :-)

Emmanuel, where is the "mk1BFiles" Benchmark? We're planning for a new=20
hardware this year, so this would be a good time to run it.  Could I=20
have the script?

The output misses the time "ls" took, but I can one can calculate that=20
from the next test start, so 9:30-7:20 =3D 2:10, is that correct? Two=20
hours to just see all files, ugh. I guess it will take some years until=20
we want to have such a filesystem. Either hardware must become quicker,=20
or another wonderful new patch is needed.

=2D-=20
// Michael Monnerie, Ing.BSc.
=2D---------------------------------
Sorcerers have their magic wands:
  powerful, potentially dangerous tools with a life of their own.
Witches have their familiars:
  creatures disguised as household beasts that could,
  if they choose, wreak the witches' havoc.
Mystics have their golems:
  beings built of wood and tin brought to life to do their
  masters' bidding.
I have Linux.
=2D---------------------------------

--nextPart3941347.PX5st216nC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyTHp4ACgkQzhSR9xwSCbSpsQCeMxDrVJ5ZpckxeDVX1WiCpL0m
Z5IAn3UJnuvvGhhLuRce19tM5TUv8/FX
=1biZ
-----END PGP SIGNATURE-----

--nextPart3941347.PX5st216nC--


--===============9151832515910876548==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9151832515910876548==--
