Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:37802 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751770AbdDKM53 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 08:57:29 -0400
Date: Tue, 11 Apr 2017 14:57:21 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: allow mounting w/crc-checking disabled? (was Re: filesystem
 dead, xfs_repair won't help)
Message-ID: <20170411145721.7d3676a1@harpe.intellique.com>
In-Reply-To: <58EBC972.6040509@tlinx.org>
References: <CAF950WLvp7SWnDHU_AY+j3CYtCDWYLdN=AkNZgNB2yU3sVxsJQ@mail.gmail.com>
        <58EB53CA.7030608@tlinx.org>
        <8b9b764e-8fb5-af30-f135-be51b6a67558@sandeen.net>
        <58EBC972.6040509@tlinx.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_lqG+sS0D2hhzX8FELnaiAF"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: L A Walsh <xfs@tlinx.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

--Sig_/_lqG+sS0D2hhzX8FELnaiAF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 10 Apr 2017 11:05:38 -0700
L A Walsh <xfs@tlinx.org> =C3=A9crivait:

> 	I'm sure it wouldn't be trivial, but creating a separate
> file system, "XFS2" from the original XFS sources that responded
> to data or metadata corruption by returning empty data where
> it was impossible to return anything useful instead of flagging
> the disk as "bad", would be a way to allow data recovery to
> the extent that it made sense (assuming the original sources
> couldn't do the same toggling off a config-flag).

It would probably much easier to add an option to mount the filesystem
without crc, similar to "norecovery", that doesn't replay the journal.
It would be of course read-only, but in a similar case it would be much
easier and practical for everyone.

So far I believed that metadata CRCs were a promise of safer
filesystems; now that I've setup several multi-hundred terabytes
volumes with CRC enabled, I'm getting nervous...

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/_lqG+sS0D2hhzX8FELnaiAF
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAljs0rEACgkQX3jQXNUicVatFQCghGXNvLnjs8++jNhyeGmssDdg
cboAoIdBT41ANPPyzf437jrkTvnzeE6a
=aHsZ
-----END PGP SIGNATURE-----

--Sig_/_lqG+sS0D2hhzX8FELnaiAF--
