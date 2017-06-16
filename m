Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:64704 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752848AbdFPNPh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 09:15:37 -0400
Date: Fri, 16 Jun 2017 15:15:13 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS Calltraces by using XFS with Ceph
Message-ID: <20170616151451.76d28144@harpe.intellique.com>
In-Reply-To: <7c00729f5554099fcf5eae65ee1cb4a0@jonas-server.de>
References: <ff5af7a48b502752faac6f2bbc1c3bb7@jonas-server.de>
        <20170614120829.GA65212@bfoster.bfoster>
        <b447cdcdc5a7278c6a9cc46627e22c94@jonas-server.de>
        <20170614140732.GA857@bfoster.bfoster>
        <20170614155513.GQ4530@birch.djwong.org>
        <34ddf391569ed02b85a59eff856088ab@jonas-server.de>
        <20170615192009.18ddd3bc@harpe.intellique.com>
        <7c00729f5554099fcf5eae65ee1cb4a0@jonas-server.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/yHX4aJYWOthq.gMEmx=OSFW"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: list@jonas-server.de
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-xfs-owner@vger.kernel.org

--Sig_/yHX4aJYWOthq.gMEmx=OSFW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 16 Jun 2017 07:37:11 +0200
list@jonas-server.de =C3=A9crivait:

> >=20
> > Indeed that matches exactly the crash Darrick mentioned. Looks like
> > you need either a special hand-patched kernel... or wait for an
> > official fix for this one :/ =20
>=20
> When will a fix normally be in the ubuntu kernel? I need to have a=20
> stable distribution kernel, I can not install a patched version.

Difficult to know. From the moment an update is released, I suppose it
makes it to Ubuntu updates in a matter of a few days.=20

But first, we'd need a patch that could be submitted to mainline.=20
the patch needs to be tested under conditions that may trigger the
problem (you seem to be the perfect guinea pig, here), then deemed a
"stable" correction to be applied to all maintained kernels, then
backported to 4.4. The complete process could be quite long indeed.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/yHX4aJYWOthq.gMEmx=OSFW
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAllD2foACgkQX3jQXNUicVYWxACeP4dQt4I3p8iS2M+PcBGULYbi
BvQAn1/jTksI0ZY6hQ6DiqFDQ6DIPXdC
=7XHW
-----END PGP SIGNATURE-----

--Sig_/yHX4aJYWOthq.gMEmx=OSFW--
