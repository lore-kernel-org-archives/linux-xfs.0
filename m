Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:56985 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752582AbeBERIE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 5 Feb 2018 12:08:04 -0500
Date: Mon, 5 Feb 2018 18:08:07 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: xfs_scrub: call for testing
Message-ID: <20180205180807.261e822f@harpe.intellique.com>
In-Reply-To: <61166e99-1195-1192-d229-f7e01f1d52da@sandeen.net>
References: <e0ada9ef-aafb-5179-2729-447d67bd6265@sandeen.net>
        <20180205161049.7e22aa09@harpe.intellique.com>
        <61166e99-1195-1192-d229-f7e01f1d52da@sandeen.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/4p=N_xJYo_D7lJu/3Bl3.gV"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

--Sig_/4p=N_xJYo_D7lJu/3Bl3.gV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 5 Feb 2018 09:49:41 -0600
Eric Sandeen <sandeen@sandeen.net> =C3=A9crivait:

> >=20
> > Wouldn't it be better to remove the parts about repairing the
> > filesystem in the documentation? The man page states that it *can't*
> > repair the filesystem, but nonetheless explains under which
> > circumstances it *won't* be able to repair (in some theoretical
> > future version with repair capabilities, I suppose). Ditto with the
> > -n and -y option, I suppose they're both basically noop at the
> > moment? That's quite unclear what it actually does. =20
>=20
> I'll take another look at the manpage.  The userspace tool today /can/
> do some degree of optimization or repair if the kernel supports it,
> so I was reluctant to suggest removing all such language.
>=20
> So, "-n" is not a no-op, it's a check-only ("scrub") pass vs. the
> default no-argument action of "optimizing," or the extra -y action
> which would repair. If that's not all clear, I'd appreciate
> suggestions to clean it up.
>=20

Now I'm wondering: is the default option of "optimizing" really
useful? Wouldn't it be better to simply have a check-only (-n) version,
and a full-fledged version when given no argument?=20
Or maybe do a simple optimisation, optionally,  when given the '-y' (or
some other flag) option?=20

I say that after having a look at man pages from some comparable
utilities, namely xfs_repair, btrfs_scrub and "zpool scrub", who all
default to "full operation" without options.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/4p=N_xJYo_D7lJu/3Bl3.gV
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlp4j3cACgkQX3jQXNUicVa72QCguLzxKHD7113jR3sO/RWjttVq
9c8An3ML54+FfxEtalYVOHI8x4la5Zhz
=j7uI
-----END PGP SIGNATURE-----

--Sig_/4p=N_xJYo_D7lJu/3Bl3.gV--
