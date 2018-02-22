Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:21099 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932491AbeBVNub (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Feb 2018 08:50:31 -0500
Date: Thu, 22 Feb 2018 14:50:33 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS corruption of in-memory data detected with KVM
Message-ID: <20180222145033.31efc367@harpe.intellique.com>
In-Reply-To: <CAJbUkCTeO6_0Xu5-UbuF_tj1GP2PZF6YP91BsKJuQ=T65cdj9w@mail.gmail.com>
References: <CAJbUkCSw-Cyi1-KkfAtaCWYODZ3jHAsE8coQpMo1qb+SXDsyEw@mail.gmail.com>
        <20180221114627.tbdequwrbmsakvcu@odin.usersys.redhat.com>
        <CAJbUkCRN3p-o7qKjad+zOFEJ9cRMoop1TjFhG7pt6ConjdEL5w@mail.gmail.com>
        <20180221175540.618eda28@harpe.intellique.com>
        <20180222102249.kpaqec37ejrrmown@odin.usersys.redhat.com>
        <CAJbUkCTeO6_0Xu5-UbuF_tj1GP2PZF6YP91BsKJuQ=T65cdj9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ACXFdNK/tgrUz.YCoCckw3D"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrea Mazzocchi <mazzocchiandrea24@gmail.com>
Cc: linux-xfs@vger.kernel.org

--Sig_/ACXFdNK/tgrUz.YCoCckw3D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 22 Feb 2018 12:31:28 +0100
Andrea Mazzocchi <mazzocchiandrea24@gmail.com> =C3=A9crivait:

> In 3.10.0-693.17.1.el7 changelog there are at least 1400 entries for
> "XFS" (http://rpmfind.net/linux/RPM/centos/updates/7.4.1708/x86_64/Packag=
es/kernel-devel-3.10.0-693.17.1.el7.x86_64.html):
> how could I see what kernel would be the best?
> Do I have to manually check the XFS bug fixes between
> 3.10.0-693.17.1.el7 and 4.14.20
> (https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commi=
t/?id=3D5791577963426c5a2db51fff57e9fcd72061e2c3)
> to see what best suits us?

So far I haven't run the 4.14 extensively, but the 4.9 is really safe.
You should definitely give it a try. Could you repair your root FS?

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/ACXFdNK/tgrUz.YCoCckw3D
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlqOyqkACgkQX3jQXNUicVZjgwCg/LZvUIaK1Q+lW82YWEEGYj5r
PJIAoIePc1uzwcCu39IBoxr1eGzGmUOe
=nTuq
-----END PGP SIGNATURE-----

--Sig_/ACXFdNK/tgrUz.YCoCckw3D--
