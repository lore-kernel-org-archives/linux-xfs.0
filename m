Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:59804 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752479AbdI1KxJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Sep 2017 06:53:09 -0400
Date: Thu, 28 Sep 2017 12:53:10 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Rationale for hardware RAID 10 su, sw values in FAQ
Message-ID: <20170928125310.5687097e@harpe.intellique.com>
In-Reply-To: <c7ade829-9385-c517-581b-8dc73def5693@mcneill.gen.nz>
References: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
        <20170927004302.GB3666@dastard>
        <db821c38-1307-0681-ffc2-4400ffd8d27a@mcneill.gen.nz>
        <20170927043308.GC3666@dastard>
        <c7ade829-9385-c517-581b-8dc73def5693@mcneill.gen.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/kePR=KP.MWDMw5oA/sfNm9U"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ewen McNeill <xfs@ewen.mcneill.gen.nz>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

--Sig_/kePR=KP.MWDMw5oA/sfNm9U
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 28 Sep 2017 12:36:39 +1300
Ewen McNeill <xfs@ewen.mcneill.gen.nz> =C3=A9crivait:

> I'm obviously not an expert in filesystem layout optimisation.  But I=20
> have many years sysadmin experience dealing with lots of types of=20
> storage, and can write a couple of pages of text on the "background"=20
> bits next time I have a free moment.  The more advanced tunables
> could remain "todo" until there's time for the perfect version...
>=20

As you're at it, please mention the potential problems with 512e (512
bytes blocks emulated) disks, which are the vast majority of shipped
disks nowadays. Doing RAID with these can lead to all sort of trouble
by worsening the read/modify/write problem.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/kePR=KP.MWDMw5oA/sfNm9U
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlnM1JYACgkQX3jQXNUicVbnfwCg8++jHbB/Y86PvBNRKCejN2G4
2kwAniN48rVrrIZlznF2AS2pjXZEnGGT
=5Qy/
-----END PGP SIGNATURE-----

--Sig_/kePR=KP.MWDMw5oA/sfNm9U--
