Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KFOUUm027314 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 10:24:30 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D29AC45BE83
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 08:27:28 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id C0xkfv5paH3uxfBD for
	<xfs@oss.sgi.com>; Tue, 20 Jul 2010 08:27:28 -0700 (PDT)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id E28D74C8135
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 17:27:21 +0200 (CEST)
Date: Tue, 20 Jul 2010 17:27:04 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Calculating swidth On A RAID6 Volume
Message-ID: <20100720172704.609477f4@harpe.intellique.com>
In-Reply-To: <201007201700.51977@zmi.at>
References: <3C5E029826A0704DB5998577FCFF46F0094DA1AD69@dagobah>
	<4C45AF09.5090901@dermichi.com>
	<20100720164444.4c1cef88@harpe.intellique.com>
	<201007201700.51977@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1471702551788650080=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1471702551788650080==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HfhqCnERkX6B_ADCKUdN35z"; protocol="application/pgp-signature"

--Sig_/HfhqCnERkX6B_ADCKUdN35z
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Tue, 20 Jul 2010 17:00:51 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> I'd say using su+sw is more future proof than swidth+sunit, as 4K
> sector drives will become standard, and then using 512B units will be
> outdated anyway, right?

Absolutely, and furthermore I'm wondering what's happening in the
case where the drives have 4096 bytes blocks; I suppose then sunit
should be expressed as a number of 4096 bytes blocks, and what about
swidth ? the hell if I know :) This is also probably a nice little nest
of coming filesystem bugs to be hatched :=3D)

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/HfhqCnERkX6B_ADCKUdN35z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkxFwEgACgkQX3jQXNUicVYDrwCgheXbfu1DLRUqWzRHKbhFQJI3
Z78An0Z7f0RNcERCTNVREiQi/5n2Zusk
=I2r7
-----END PGP SIGNATURE-----

--Sig_/HfhqCnERkX6B_ADCKUdN35z--


--===============1471702551788650080==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1471702551788650080==--
