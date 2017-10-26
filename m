Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:34737 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932127AbdJZPUj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 11:20:39 -0400
Date: Thu, 26 Oct 2017 17:20:41 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Possible to mount this XFS at least temporarily to retrieve
 files?
Message-ID: <20171026172041.0fe9d394@harpe.intellique.com>
In-Reply-To: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
References: <dd004707-cd48-adb8-1429-37867360594e@aei.mpg.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/YjP6.iy2geZBbdZ.Xxy3kOr"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
Cc: linux-xfs@vger.kernel.org

--Sig_/YjP6.iy2geZBbdZ.Xxy3kOr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Wed, 25 Oct 2017 09:20:03 +0200
Carsten Aulbert <carsten.aulbert@aei.mpg.de> =C3=A9crivait:

> On a Debian Jessie machine installed back in October 2016 there a re a
> bunch of 3TB disks behind an Adaptec ASR-6405[1] in RAID6
> configuration. Yesterday, one of the disks failed and was
> subsequently replace. About an hour into the rebuild the 28TB xfs on
> this block device gave up:

This is a common problem with old adaptec RAID controllers. Don't do
any IO while it's rebuilding, else it may corrupt data. After rebuild
is complete, the volume will probably be easily repairable.

DON'T DO ANYTHING UNTIL REBUILD IS COMPLETE. Particularly don't try
running xfs_repair.

Afterwards, install the very latest firmware for the controller, go in
"Serial select" utility in BIOS and deactivate Disk write cache (this
is the individual disks write caching). It will (mostly) avoid the
problem in the future.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/YjP6.iy2geZBbdZ.Xxy3kOr
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlnx/UoACgkQX3jQXNUicVYmTwCeJuPp0TI5BGRBV2KBE/GgDEX9
F/kAoIZ2BKBULpjaJsbStSSAymK1uvFo
=Wmlc
-----END PGP SIGNATURE-----

--Sig_/YjP6.iy2geZBbdZ.Xxy3kOr--
