Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:46118 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966087AbeFSQGg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jun 2018 12:06:36 -0400
Date: Tue, 19 Jun 2018 18:00:27 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Mounting xfs filesystem takes long time
Message-ID: <20180619180027.723d1779@harpe.intellique.com>
In-Reply-To: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
References: <2a9a023d-fa37-59dc-caf2-c7c4167d3c75@levigo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/OT8FEjY=1mPg4cpLGXlWI1M"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "swadmin - levigo.de" <swadmin@levigo.de>
Cc: linux-xfs@vger.kernel.org

--Sig_/OT8FEjY=1mPg4cpLGXlWI1M
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 19 Jun 2018 14:27:29 +0200
"swadmin - levigo.de" <swadmin@levigo.de> =C3=A9crivait:

> can anyone help me or know a kind of these problem. What else to try
> out?
>=20

Maybe you have very high IO pressure on the underlying devices? Try
this:

in a window, run "iostat -x 2" Look at the numbers for the device
you'll be using. Particularly look at the "% use" and "IO wait" values.
They should be at zero, or close.

Now in another window mount the volume. See what happens in the output
of iostat. Do you see any change? Aren't some devices receiving an high
load? is the IO wait value up?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/OT8FEjY=1mPg4cpLGXlWI1M
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlspKJwACgkQX3jQXNUicVZSTwCg8FRCRk1MvdhhoZaXZBoDVXX6
SyoAnRKZuYp50PNiD/ivkwUXxsq43QSr
=u5hg
-----END PGP SIGNATURE-----

--Sig_/OT8FEjY=1mPg4cpLGXlWI1M--
