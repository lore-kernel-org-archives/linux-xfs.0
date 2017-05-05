Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:62684 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750711AbdEEQIs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 12:08:48 -0400
Date: Fri, 5 May 2017 18:08:52 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: XFS and multiple mounts protection (aka preventing multiple
 mounts)
Message-ID: <20170505180852.185f1555@harpe.intellique.com>
In-Reply-To: <c5e42df06ff981bfd6a72cbc12f10d43@assyoma.it>
References: <3cf2f8cd-d18f-2a65-c540-5527a366d2fb@assyoma.it>
        <20170505113219.dovbzhbmt6e3ooem@eorzea.usersys.redhat.com>
        <2e45f5c8-0b8f-ef99-a8a5-cd3ebb89911e@assyoma.it>
        <20170505122547.6gvqmdoxfaqxh3mi@eorzea.usersys.redhat.com>
        <c5e42df06ff981bfd6a72cbc12f10d43@assyoma.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/a.EMmlmCICqgdYz1cCkH6hf"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

--Sig_/a.EMmlmCICqgdYz1cCkH6hf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 05 May 2017 15:19:45 +0200
Gionatan Danti <g.danti@assyoma.it> =C3=A9crivait:

> Il 05-05-2017 14:25 Carlos Maiolino ha scritto:
> >=20
> > As far as I know, don't, I can always be wrong, but, I re-checked
> > xfs superblock, and could not find anything that actually protects
> > it.=20
>=20
> So, how do you protect iSCSI targets from erroneous multiple mount?
> Do you protect them only at the target/lun level (eg: access list on
> the target/lun)?
>=20

Either that, or use a cluster-aware filesystem such as GFS2 or OCFS2.

On Debian systems, setting up OCFS2 is a breeze. Performance is
very good, but the FS lacks extended attributes and ACLs.

On RH-derived systems, clustering is a real PITA (probably a plot to
force you to pay for RedHat Clustering solutions).=20

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/a.EMmlmCICqgdYz1cCkH6hf
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEUEARECAAYFAlkMo5QACgkQX3jQXNUicVZtVgCg62c/KnJOtefr3WP+/PkMFcBj
JAYAlRRDEBgnXI8EbA6vUDRl1W5Ok98=
=3Nsg
-----END PGP SIGNATURE-----

--Sig_/a.EMmlmCICqgdYz1cCkH6hf--
