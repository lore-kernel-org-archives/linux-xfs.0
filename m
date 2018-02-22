Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:46582 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753521AbeBVLeT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Feb 2018 06:34:19 -0500
Date: Thu, 22 Feb 2018 12:33:51 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS corruption of in-memory data detected with KVM
Message-ID: <20180222123351.256227f2@harpe.intellique.com>
In-Reply-To: <CAJbUkCQd_TOOSxVwWzDca7Do6_g+dMsKU3fObMig4gG_0HHg-w@mail.gmail.com>
References: <CAJbUkCSw-Cyi1-KkfAtaCWYODZ3jHAsE8coQpMo1qb+SXDsyEw@mail.gmail.com>
        <20180221114627.tbdequwrbmsakvcu@odin.usersys.redhat.com>
        <CAJbUkCRN3p-o7qKjad+zOFEJ9cRMoop1TjFhG7pt6ConjdEL5w@mail.gmail.com>
        <20180221175540.618eda28@harpe.intellique.com>
        <CAJbUkCQd_TOOSxVwWzDca7Do6_g+dMsKU3fObMig4gG_0HHg-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cVbxXcgU.Uq+ObmdXSx1hq1"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Andrea Mazzocchi <mazzocchiandrea24@gmail.com>

--Sig_/cVbxXcgU.Uq+ObmdXSx1hq1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 22 Feb 2018 10:11:08 +0100
Andrea Mazzocchi <mazzocchiandrea24@gmail.com> =C3=A9crivait:

Please keep the list cc'ed, in case someone comes with another idea.

> > Hard to say, what KVM disk format are you using? Raw, qcow2, LVM
> > volumes? If these are files (raw or qcow2), what kind of filesystem
> > and hardware stack are they living on? Are there any error on the
> > hosting system? =20
>=20
> Software configuration of provider's hypervisor host nodes is held in
> confidentiality:
> I can't know KVM version and configurations, unless something is
> shown in dmesg.

Hum, so we can't know for sure if something went wrong outside the VM,
annoying.

> > At tne VM level, do you see any IO error? Are you using the virtio
> > disk driver or something else? =20
>=20
> The errors we saw were: we failed to establish an SSH connection,
> so we went to the provider's console of the VPS and the dmesg was
> shown: the log seemed all fine until "systemd[1]: found device
> /dev/mapper/centos-root"
> (which is where it begins the dmesg I posted).
> We are using virtio disk driver.

I see. Now you'll need to boot the VM from some rescue system (possibly
the installation image of CentOS) to run xfs_repair before going any
further, unfortunately.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/cVbxXcgU.Uq+ObmdXSx1hq1
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlqOqrwACgkQX3jQXNUicVZ+VwCg8XpYyQNf7lI62scPrTSh+ZNk
g+AAnicSUO2kjFmJa8HMciUCrAi+gKFu
=fa+9
-----END PGP SIGNATURE-----

--Sig_/cVbxXcgU.Uq+ObmdXSx1hq1--
