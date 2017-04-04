Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:51205 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932351AbdDDSHH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Apr 2017 14:07:07 -0400
Date: Tue, 4 Apr 2017 20:07:11 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: "interesting" crash : 3.18.44, huge xfs, nfs
Message-ID: <20170404200711.088a3c58@harpe.intellique.com>
In-Reply-To: <889a3521-9f9d-59fd-8592-06ba40869e8f@sandeen.net>
References: <20170404150202.6c7d032c@harpe.intellique.com>
        <20170404192411.650fb403@harpe.intellique.com>
        <95e14081-0f1c-7458-cca2-1f33d6662037@sandeen.net>
        <20170404194340.4733ccb7@harpe.intellique.com>
        <889a3521-9f9d-59fd-8592-06ba40869e8f@sandeen.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/wazrU3iMyS7DfVUrqCpoMgK"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

--Sig_/wazrU3iMyS7DfVUrqCpoMgK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 4 Apr 2017 12:45:07 -0500
Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:

> >=20
> > I don't see why or where we'd use filestreams there... What's the
> > use case actually? =20
>=20
> well, it's in your crash backtrace, so you tell me ;)
>=20

I remember now... There writing files in long sequences, so that's what
the filestream option is for. It worked fine for a few months though...

> >>>
> >>> The machine goes on crashing on disk access... xfs_repair 4.9 is
> >>> running now, and after that we'll reboot with a current kernel
> >>> (4.4.59). Any advice?   =20
> >>
> >> Yep, go back in time & get an xfs_metadump before you repair
> >> it.  :( =20
> >=20
> > You know how it goes it crashes, users scream, administrator jumps
> > on xfs_repair, and the rest is history.
> >   =20
> >> Please do at least capture repair output.
> >> =20
> >=20
> > Well the only thing I know is "there was nothing special in
> > xfs_repair output"... I'll tell the admin to catch the output next
> > time if necessary... =20
>=20
> So it crashed on every access, and repair fixed it, but repair said
> "nothing special" in the process?  :(
>=20

It crashes, it reboots without complaining, so there aren't any grave
obvious upfront problems at least...

Well we'll see if it crashes again with a 4.4.59... Just in case we
removed the filestreams option in the fstab.


--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/wazrU3iMyS7DfVUrqCpoMgK
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljj4NAACgkQX3jQXNUicVaAQQCgo9xr1Ibt/PiHDSG1b/C/AjTm
zjQAnR5j85O8Iv/7tArP4LEHpiksBVxN
=vvUb
-----END PGP SIGNATURE-----

--Sig_/wazrU3iMyS7DfVUrqCpoMgK--
