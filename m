Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:26868 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdFOR05 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Jun 2017 13:26:57 -0400
Date: Thu, 15 Jun 2017 19:20:09 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS Calltraces by using XFS with Ceph
Message-ID: <20170615192009.18ddd3bc@harpe.intellique.com>
In-Reply-To: <34ddf391569ed02b85a59eff856088ab@jonas-server.de>
References: <ff5af7a48b502752faac6f2bbc1c3bb7@jonas-server.de>
        <20170614120829.GA65212@bfoster.bfoster>
        <b447cdcdc5a7278c6a9cc46627e22c94@jonas-server.de>
        <20170614140732.GA857@bfoster.bfoster>
        <20170614155513.GQ4530@birch.djwong.org>
        <34ddf391569ed02b85a59eff856088ab@jonas-server.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/XsQS+ZCY9_5HYXcSQkklG6g"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: list@jonas-server.de
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-xfs-owner@vger.kernel.org

--Sig_/XsQS+ZCY9_5HYXcSQkklG6g
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 15 Jun 2017 07:55:12 +0200
list@jonas-server.de =C3=A9crivait:

> > Looking at the new Elixir[1], it looks like we're trying to deref
> > ((*bpp)->b_addr)->magic, so that might explain the crash you see.
> >=20
> > --D
> >=20
> > [1]
> > http://elixir.free-electrons.com/linux/v4.4.72/source/fs/xfs/libxfs/xfs=
_da_btree.c#L270
> >  =20
> >>=20

Indeed that matches exactly the crash Darrick mentioned. Looks like you
need either a special hand-patched kernel... or wait for an official
fix for this one :/

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/XsQS+ZCY9_5HYXcSQkklG6g
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAllCwcoACgkQX3jQXNUicVb9eQCgnhc+m6NeXq85OvxBqUHVNngb
lSQAnivkznRdJ39JuJM9cm+HLJ+tk4Gj
=Ptrq
-----END PGP SIGNATURE-----

--Sig_/XsQS+ZCY9_5HYXcSQkklG6g--
