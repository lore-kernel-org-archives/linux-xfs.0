Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:45650 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751120AbdBCRKt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Feb 2017 12:10:49 -0500
Date: Fri, 3 Feb 2017 18:10:51 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Safe XFS limits (100TB+)
Message-ID: <20170203181051.7bb33e7e@harpe.intellique.com>
In-Reply-To: <CAL8yqih36vWy-Z1PESVZOqDEoW8G9=k5LBM0aToe4JhBM755bA@mail.gmail.com>
References: <CAL8yqihyYEaCEzWJLqAKsw1BBOQDm-AYR2dCUeN-X-449jCwzQ@mail.gmail.com>
        <20170202191627.42c50e67@harpe.intellique.com>
        <CAL8yqih36vWy-Z1PESVZOqDEoW8G9=k5LBM0aToe4JhBM755bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SQfh.UUSvZPdXPPpqN4mvFv"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fuser ct1 <fuserct1@gmail.com>, linux-xfs@vger.kernel.org

--Sig_/SQfh.UUSvZPdXPPpqN4mvFv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 2 Feb 2017 18:48:50 +0000
fuser ct1 <fuserct1@gmail.com> =C3=A9crivait:

> >I manage and support several hosts I built and set up, some running
> >for many years, with very large XFS volumes.
> >Recent XFS volumes with XFS v5 seem to promise even more robustness,
> >thanks to metadata checksums. =20
>=20
> Thanks this is good to know, although I think the distributions I use
> are at latest running 4.3.0+nmu1ubuntu1 for Ubuntu 16.04. Might go
> fishing in backports though.

4.3 should be good. XFS v5 requires at least x3.16.

> The checksum idea is interesting, I'll have a read - having worked
> with ZFS for some time too, it'll be interesting to see how this
> feature compares.

It's only metadata checksumming in XFS. Much faster (but of course less
safe; however you can scrub using the RAID controller, instead).

> >Currently in use under heavy load machines with the following usable
> >volumes, almost all of them using RAID 60 (21 to 28 drives x 2 or
> >x3):
> >
> >1 490 TB volume
> >3 390 TB volumes
> >1 240 TB volume
> >2 180 TB volumes
> >5 160 TB volumes
> >11 120 TB volumes
> >4 90 TB volumes
> >14 77 TB volumes
> >many, many 50 and 40 TB volumes. =20
>=20
> The 390TB thing looks tempting. With this LSI one could probably do 1x
> logical volume comprised of two spans of 22x R60, which would yield
> something like 288TB usable.

No, these are USABLE volumes. 390 TB is the usable volume of a 60
8TB drives chassis (480 TB), splitted in 2 x 29 drives + 2 spares.=20

On most systems I use 2 controllers (one per array) for higher
performance (though it doesn't make that much of a difference with the
last generation).

> >2x22 disks Raid 60 is perfectly OK, as long as you're using good
> >disks. I only use HGST, and have a failure rate so low I don't even
> >bother tracking it precisely anymore (like 2 or 3 failures a year
> >among the couple thousands disks listed above). =20
>=20
> I've planned for 7K6 Ultrastar's. The HGST never give me much trouble.
> Sometimes I've had dead ones upon init, but that pretty normal I
> guess.

As the latest Backblaze report shows, not all Seagate drives are
bad, however all terrible hard disks  models come from Seagate...

> >Use recent xfs progs and kernel, use xfs v5 if possible. Don't forget
> >proper optimisations (use noop scheduler, enlarge nr_requests and
> >read_ahead_kb a lot) for high sequential throughput (video is all
> >about sequential throughput) and you should be happy and safe. =20
>=20
> Normally using NOOP, 1024 nr_requests and 8196 read ahead.

Good :)

> >xfs_repair on a filled fast 100 TB volume only needs 15 minutes or
> >so. And it was after a very, very bad power event (someone connected
> >a studio light to the UPS and brought everything down literally in
> >flames). =20
>=20
> Thanks that's really helpful to have a frame of reference!

It used to be much worse a few years back when xfs_repair demanded
gobbled RAM. I remember setting up additional swap space on USB drives
to be able to repair... That was wayyyyy slower back then :)

Given you have enough memory (32G or more), nowadays xfs_repair on a
huge filesystem is a breeze, even with gazillions of files (like DPX
or EXR images sequences....).

[I'm cc'ing  to the list because the information may help someone else
someday :)=20

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/SQfh.UUSvZPdXPPpqN4mvFv
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAliUuZsACgkQX3jQXNUicVbBGwCg/FrkAv/7J/XtEo4jY+yhn2/i
yJ0AnAhPf1Y1ALxHykKDX3Kg24EZFxsE
=vlwv
-----END PGP SIGNATURE-----

--Sig_/SQfh.UUSvZPdXPPpqN4mvFv--
