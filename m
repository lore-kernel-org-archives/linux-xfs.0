Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:26400 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbeJBVUp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Oct 2018 17:20:45 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 2E06E5476BF
        for <linux-xfs@vger.kernel.org>; Tue,  2 Oct 2018 10:37:03 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id E594960B374
        for <linux-xfs@vger.kernel.org>; Tue,  2 Oct 2018 10:37:02 -0400 (EDT)
Date: Tue, 2 Oct 2018 16:37:07 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: [somewhat OT] I just discovered that Stratis uses XFS.
Message-ID: <20181002163707.5452307c@harpe.intellique.com>
In-Reply-To: <20181002162530.42b30c11@harpe.intellique.com>
References: <20181002162530.42b30c11@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/B/RfdDx=hC/.o+MuEojJmos"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

--Sig_/B/RfdDx=hC/.o+MuEojJmos
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 2 Oct 2018 16:25:30 +0200
Emmanuel Florac <eflorac@intellique.com> =C3=A9crivait:

> Hi all,=20
> in fact I just discovered that Stratis exists :)
> (https://stratis-storage.github.io/relnotes/relnotes-1.0.html)
> ( details on https://lwn.net/Articles/755454/)
>=20
> Reading the FAQ (https://stratis-storage.github.io/FAQ.html) I see
> that it uses XFS as a filesystem layer. Furthermore it seems to come
> from RedHat. What are the relations with the future XFS capabilities
> that Dave (IIRC) demonstrated recently?
>=20
> Sorry for the OT message :)

Oh, and what about the probable constant use of xfs_growfs? Stratis
seems to create all filesystems with a size of 1TB, and extends them as
needed from there. However that means that a filesystem could
potentially be expanded many times, which, as I understand it, is very
suboptimal or worse, can lead to problems (inode allocation, AGs
count and structure, etc).

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/B/RfdDx=hC/.o+MuEojJmos
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAluzgpMACgkQX3jQXNUicVYB1wCgpwLePuzHwZhMkTLBZ9pEnmiT
FMcAoPwszFIz+zZUjs3ekcPzUEOzhJD0
=UgnB
-----END PGP SIGNATURE-----

--Sig_/B/RfdDx=hC/.o+MuEojJmos--
