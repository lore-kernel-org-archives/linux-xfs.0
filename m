Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:30212 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752006AbeBUQzg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Feb 2018 11:55:36 -0500
Date: Wed, 21 Feb 2018 17:55:40 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS corruption of in-memory data detected with KVM
Message-ID: <20180221175540.618eda28@harpe.intellique.com>
In-Reply-To: <CAJbUkCRN3p-o7qKjad+zOFEJ9cRMoop1TjFhG7pt6ConjdEL5w@mail.gmail.com>
References: <CAJbUkCSw-Cyi1-KkfAtaCWYODZ3jHAsE8coQpMo1qb+SXDsyEw@mail.gmail.com>
        <20180221114627.tbdequwrbmsakvcu@odin.usersys.redhat.com>
        <CAJbUkCRN3p-o7qKjad+zOFEJ9cRMoop1TjFhG7pt6ConjdEL5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/5cy_1GRQ4L7LpUQhoBOuzzm"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrea Mazzocchi <mazzocchiandrea24@gmail.com>
Cc: linux-xfs@vger.kernel.org

--Sig_/5cy_1GRQ4L7LpUQhoBOuzzm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Wed, 21 Feb 2018 16:23:43 +0100
Andrea Mazzocchi <mazzocchiandrea24@gmail.com> =C3=A9crivait:

> > Also, you are running a very old kernel, so, please make sure you
> > try to run a newer xfs_repair. =20
>=20
> We installed yesterday 3.10.0-693.17.1.el7. I know that CentOS and
> RedHat keep old stable kernel version and backport important stuff:
> do you think that upgrading to a more recent kernel (4 and above)
> would be better, even if less stable?

Actually the 3.10 from CentOS 7 has a lot of things backported, for
instance it supports XFS with crc metadata which was introduced in 3.16.

However in the recent year I've never met any reason NOT to use a
recent LTS kernel (like a 4.9 or 4.14). I don't really understand why
RedHat sticks to these absurdly old kernel releases as a basis (and
taking the pain of backporting stuff for years and years).

> > Also, this is more a guess than anything. If you see this happening
> > often (even after xfs_repair), you might want to double-check your
> > storage stack and see if this is not corrupting anything, bad
> > configured storage stacks in virtual environments are very usual
> > culprits on filesystem corruption cases. =20
>=20
> How could we check our storage stack and see if it is the one to
> blame?

Hard to say, what KVM disk format are you using? Raw, qcow2, LVM
volumes? If these are files (raw or qcow2), what kind of filesystem and
hardware stack are they living on? Are there any error on the hosting
system?

At tne VM level, do you see any IO error? Are you using the virtio disk
driver or something else?=20

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/5cy_1GRQ4L7LpUQhoBOuzzm
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlqNpIwACgkQX3jQXNUicVazJACg+E/JswG2Mbi3rLYSw+5wZ6+e
tfwAnRI7XYMNMF3DplupiPMo2eSd6qLV
=Reki
-----END PGP SIGNATURE-----

--Sig_/5cy_1GRQ4L7LpUQhoBOuzzm--
