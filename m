Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:16514 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750878AbdBBSVt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Feb 2017 13:21:49 -0500
Date: Thu, 2 Feb 2017 19:16:27 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Safe XFS limits (100TB+)
Message-ID: <20170202191627.42c50e67@harpe.intellique.com>
In-Reply-To: <CAL8yqihyYEaCEzWJLqAKsw1BBOQDm-AYR2dCUeN-X-449jCwzQ@mail.gmail.com>
References: <CAL8yqihyYEaCEzWJLqAKsw1BBOQDm-AYR2dCUeN-X-449jCwzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/AOaSbFz7lCyOhUpOOczQljH"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fuser ct1 <fuserct1@gmail.com>
Cc: linux-xfs@vger.kernel.org

--Sig_/AOaSbFz7lCyOhUpOOczQljH
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 2 Feb 2017 16:46:09 +0000
fuser ct1 <fuserct1@gmail.com> =C3=A9crivait:

> Hello list.
>=20
> Despite searching I couldn't find guidance, or many use cases,
> regarding XFS beyond 100TB.
>=20
> Of course the filesystem limits are way beyond this, but I was
> looking for real world experiences...

I manage and support several hosts I built and set up, some running for
many years, with very large XFS volumes.
Recent XFS volumes with XFS v5 seem to promise even more robustness,
thanks to metadata checksums.

Currently in use under heavy load machines with the following usable
volumes, almost all of them using RAID 60 (21 to 28 drives x 2 or x3):

1 490 TB volume
3 390 TB volumes
1 240 TB volume=20
2 180 TB volumes=20
5 160 TB volumes=20
11 120 TB volumes
4 90 TB volumes
14 77 TB volumes
many, many 50 and 40 TB volumes.

2x22 disks Raid 60 is perfectly OK, as long as you're using good disks.
I only use HGST, and have a failure rate so low I don't even bother
tracking it precisely anymore (like 2 or 3 failures a year among the
couple thousands disks listed above).=20

Use recent xfs progs and kernel, use xfs v5 if possible. Don't forget
proper optimisations (use noop scheduler, enlarge nr_requests and
read_ahead_kb a lot) for high sequential throughput (video is all about
sequential throughput) and you should be happy and safe.

xfs_repair on a filled fast 100 TB volume only needs 15 minutes or so.
And it was after a very, very bad power event (someone connected a
studio light to the UPS and brought everything down literally in
flames).

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/AOaSbFz7lCyOhUpOOczQljH
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAliTd3wACgkQX3jQXNUicVbf6ACglOffk/IojbQ1PHvtNwlnePrh
MQQAn213DNiMUAmkIdl8r08pRHr2QxyJ
=7Qex
-----END PGP SIGNATURE-----

--Sig_/AOaSbFz7lCyOhUpOOczQljH--
