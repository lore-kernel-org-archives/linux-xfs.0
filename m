Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A3877CA0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 07:40:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 635C8AC001
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 05:40:32 -0700 (PDT)
Received: from relaycp04.dominioabsoluto.net (relaycp04.dominioabsoluto.net
	[217.116.26.100]) by cuda.sgi.com with ESMTP id
	70MVumCiA5VerSeQ for <xfs@oss.sgi.com>;
	Tue, 09 Aug 2016 05:40:28 -0700 (PDT)
Received: from smtp.movistar.es (smtp10.acens.net [86.109.99.134])
	by relaycp04.dominioabsoluto.net (Postfix) with ESMTP id C181464236
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 14:40:27 +0200 (CEST)
Received: from Telcontar.valinor (88.17.65.53) by smtp.movistar.es
	(8.6.122.03) (authenticated as robin.listas2)
	id 57A52DD4001EE1DD for xfs@oss.sgi.com; Tue, 9 Aug 2016 12:40:29 +0000
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id 29B11120AE1
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 14:40:27 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id BZT_NI26Er4m for <xfs@oss.sgi.com>;
	Tue,  9 Aug 2016 14:40:27 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id ED0D8120AE0
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2016 14:40:26 +0200 (CEST)
Subject: Re: Advice needed with file system corruption
References: <5787852A.7030900@st-andrews.ac.uk>
	<20160808161132.1d76eb5c@harpe.intellique.com>
	<1470670691.8958.11.camel@filmlight.ltd.uk>
	<20160808174427.24d8272c@harpe.intellique.com>
	<592673683.10446004.1470715375850.JavaMail.yahoo@mail.yahoo.com>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <7faf941c-2188-589d-b624-9fedb22dee40@telefonica.net>
Date: Tue, 9 Aug 2016 14:40:26 +0200
MIME-Version: 1.0
In-Reply-To: <592673683.10446004.1470715375850.JavaMail.yahoo@mail.yahoo.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6554137430510607536=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mail list <xfs@oss.sgi.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============6554137430510607536==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gC6BxN7Gs4AHu8Uk0JSLdKtnlfxvmMjJq"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gC6BxN7Gs4AHu8Uk0JSLdKtnlfxvmMjJq
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2016-08-09 06:02, Gim Leong Chin wrote:

> Drives connected to RAID controllers with battery backed cache should
> have their caches "disabled" (they are really set to write through mode=

> instead).  By the way, I found out in lab testing that 7200 RPM SATA
> drives suffer a big performance loss when doing sequential writes in
> cache write through mode.<http://oss.sgi.com/mailman/listinfo/xfs>

If you disable the disk internal cache, as a consequence you also
disable the disk internal write optimizations. It has to be much slower
at writing. It seems to me obvious.

--=20
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)


--gC6BxN7Gs4AHu8Uk0JSLdKtnlfxvmMjJq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlepzzoACgkQtTMYHG2NR9U6xACeIjOB+m2DDr67FLIgSWxnfIb/
e+YAn274gwUKmkkcJY/UFNdh6PVrU938
=6zli
-----END PGP SIGNATURE-----

--gC6BxN7Gs4AHu8Uk0JSLdKtnlfxvmMjJq--


--===============6554137430510607536==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6554137430510607536==--
