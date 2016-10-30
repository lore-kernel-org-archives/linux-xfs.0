Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp22.acens.net ([86.109.99.146]:38331 "EHLO smtp.movistar.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751438AbcJ3UwL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 30 Oct 2016 16:52:11 -0400
Received: from Telcontar.valinor (88.20.238.12) by smtp.movistar.es (8.6.122.03) (authenticated as robin.listas2)
        id 57A446BD045D75D1 for linux-xfs@vger.kernel.org; Sun, 30 Oct 2016 20:45:13 +0000
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 2310B120AE1
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2016 21:45:16 +0100 (CET)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id d2Xb_buCencr for <linux-xfs@vger.kernel.org>;
        Sun, 30 Oct 2016 21:45:16 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 0A1FA120AE0
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2016 21:45:16 +0100 (CET)
Subject: Re: mounting a xfs file system gives the message: "failure code
 -3003" and "structure needs cleaning"
References: <CAPvv1vytjK-n7Z3=Zi+vScuV-ej3CagQ5rFc9ppVC8JEihZPkQ@mail.gmail.com>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <8bd7b65f-d85d-2958-dd7d-ba97c91ac9ea@telefonica.net>
Date: Sun, 30 Oct 2016 21:45:15 +0100
MIME-Version: 1.0
In-Reply-To: <CAPvv1vytjK-n7Z3=Zi+vScuV-ej3CagQ5rFc9ppVC8JEihZPkQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="VV49jXRnjJ1O9eGEQbbXJN4NMV3ugvfSp"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VV49jXRnjJ1O9eGEQbbXJN4NMV3ugvfSp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2016-10-30 21:36, Steffen D. wrote:
> Hello list!
>=20
> I'll try to explain my problem:
>=20

> "inux-ibbi:/home/steffen # xfs_repair /dev/sda4
> Phase 1 - Superblock finden und =3DC3=3DBCberpr=3DC3=3DBCfen...
> Phase 2 - ein internes Protokoll benutzen

I don't know if it is too late, but to make things easier for the
experts here, it is better to run the command in English. Like this:

LANG=3Den_US.UTF-8 LC_ALL=3Den_US.UTF-8 xfs_repair /dev/sda4


I have a script for convenience:


cer@Telcontar:~> cat /usr/local/bin/ingles
#!/bin/sh

LANG=3Den_US.UTF-8 \
  LC_ALL=3Den_US.UTF-8 \
  DICTIONARY=3Denglish \
  KDE_LANG=3Den_US.UTF-8 \
  exec "$@"

cer@Telcontar:~>



--=20
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)


--VV49jXRnjJ1O9eGEQbbXJN4NMV3ugvfSp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlgWW9sACgkQtTMYHG2NR9UVUACdEMrgEzWiBu4MOJl6DUxTkXZd
iA0AoIyUVGtgGN0rWfWLc2PnTSbzopUh
=/OjS
-----END PGP SIGNATURE-----

--VV49jXRnjJ1O9eGEQbbXJN4NMV3ugvfSp--
