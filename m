Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A4E977F6D
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 08:20:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39088AC005
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 06:20:00 -0800 (PST)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id eA9HBpFExvducZ0k for
	<xfs@oss.sgi.com>; Thu, 23 Jan 2014 06:19:54 -0800 (PST)
Date: Thu, 23 Jan 2014 15:19:43 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Weird XFS Corruption Error
Message-ID: <20140123151943.281baa04@harpe.intellique.com>
In-Reply-To: <CDBC891F-BCF6-4B9B-ADDB-9E143973D188@inovex.de>
References: <CDBC891F-BCF6-4B9B-ADDB-9E143973D188@inovex.de>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1439744459026444205=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sascha Askani <saskani@inovex.de>
Cc: xfs@oss.sgi.com

--===============1439744459026444205==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//IsVBLCDX1E5Gr4hMKdOlw."; protocol="application/pgp-signature"

--Sig_//IsVBLCDX1E5Gr4hMKdOlw.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Wed, 22 Jan 2014 17:09:10 +0100
Sascha Askani <saskani@inovex.de> =E9crivait:

> Internal error xfs_bmbt_read_verify at line 789=20
...
> metadata I/O error: block 0x1f0 ("xfs_trans_read_buf_map") error 117
> numblks 8


A quick glance at the source code seems to indicate that there was an
actual CRC error (on disk) at this point, so that could be a RAID
problem;

OTOH it looks really similar to an older bug :

http://oss.sgi.com/archives/xfs/2013-02/msg00482.html

AFAIK this one could be related to the current Ubuntu LTS lvm stack...
We need Dave's advice on this one.

Was there nothing in the xfs_repair output? nothing in lost+found
either?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_//IsVBLCDX1E5Gr4hMKdOlw.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlLhJP8ACgkQX3jQXNUicVY6mACWKs1UPu0Nli8MqwrQ4rhvUFxP
3ACg7DBJoisPj0jo3I3C00iN0UO1z7M=
=LE3c
-----END PGP SIGNATURE-----

--Sig_//IsVBLCDX1E5Gr4hMKdOlw.--


--===============1439744459026444205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1439744459026444205==--
