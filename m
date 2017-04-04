Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:22818 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754009AbdDDRnh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 13:43:37 -0400
Date: Tue, 4 Apr 2017 19:43:40 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: "interesting" crash : 3.18.44, huge xfs, nfs
Message-ID: <20170404194340.4733ccb7@harpe.intellique.com>
In-Reply-To: <95e14081-0f1c-7458-cca2-1f33d6662037@sandeen.net>
References: <20170404150202.6c7d032c@harpe.intellique.com>
        <20170404192411.650fb403@harpe.intellique.com>
        <95e14081-0f1c-7458-cca2-1f33d6662037@sandeen.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/KP8f3MCtwXfHfcdWMHLRBS1"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

--Sig_/KP8f3MCtwXfHfcdWMHLRBS1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 4 Apr 2017 12:36:57 -0500
Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:

> >> Context: this is a file server. There was a power failure
> >> yesterday, so there's probably some corruption hidden somewhere
> >> triggering the crash. =20
>=20
> and using filestreams, apparently?

I don't see why or where we'd use filestreams there... What's the use
case actually?
=20
> >=20
> > The machine goes on crashing on disk access... xfs_repair 4.9 is
> > running now, and after that we'll reboot with a current kernel
> > (4.4.59). Any advice? =20
>=20
> Yep, go back in time & get an xfs_metadump before you repair it.  :(

You know how it goes it crashes, users scream, administrator jumps on
xfs_repair, and the rest is history.
=20
> Please do at least capture repair output.
>=20

Well the only thing I know is "there was nothing special in xfs_repair
output"... I'll tell the admin to catch the output next time if
necessary...


--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/KP8f3MCtwXfHfcdWMHLRBS1
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljj20wACgkQX3jQXNUicVZ8GgCguCTKFVUCXuzhAA7Y5nyWVw2C
XlcAn11yPfUL9ekt+uifJhAbjb0224ax
=kda5
-----END PGP SIGNATURE-----

--Sig_/KP8f3MCtwXfHfcdWMHLRBS1--
