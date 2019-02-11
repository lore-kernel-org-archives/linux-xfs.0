Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:37490 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbfBKQmH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Feb 2019 11:42:07 -0500
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id BC1C3547708
        for <linux-xfs@vger.kernel.org>; Mon, 11 Feb 2019 11:42:06 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 64C4560B03B
        for <linux-xfs@vger.kernel.org>; Mon, 11 Feb 2019 11:42:06 -0500 (EST)
Date: Mon, 11 Feb 2019 17:40:53 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: RAID hiccup, LVM information wiped, XFS FS gone, how to
 proceed?
Message-ID: <20190211174053.7eec6a59@harpe.intellique.com>
In-Reply-To: <20190211172359.71aff9d6@harpe.intellique.com>
References: <20190211172359.71aff9d6@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/PBzNadNStB8M13VUiEoW//r"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS list <linux-xfs@vger.kernel.org>

--Sig_/PBzNadNStB8M13VUiEoW//r
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 11 Feb 2019 17:23:59 +0100
Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:

> (I know, I could simply restore the vgcfgbackup if it existed...
> please let's suppose this command doesn't exist).
>=20

Hum, actually I have a backup of the vg configuration but... it looks
like actually 7 or 8 kB were erased  from the disk. So  no dice, I must
recreate the PV first but wouldn't it wipe everything?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/PBzNadNStB8M13VUiEoW//r
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAlxhpZUACgkQX3jQXNUicVbgawCgo2Lkk/ND2TUfl3GJkf29zMwa
JGsAnRtBlh2QZCpLVfNjERkd4kgfWTSB
=tBVf
-----END PGP SIGNATURE-----

--Sig_/PBzNadNStB8M13VUiEoW//r--
