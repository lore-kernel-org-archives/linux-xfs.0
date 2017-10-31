Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail1.g1.pair.com ([66.39.3.162]:22028 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750848AbdJaLGQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Oct 2017 07:06:16 -0400
Date: Tue, 31 Oct 2017 12:06:17 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: RAID6 + XFS + Application Workload write performance question
Message-ID: <20171031120617.015f383c@harpe.intellique.com>
In-Reply-To: <8BB5896C-2789-4EB6-9B1B-7DFD4DA9101B@fireeye.com>
References: <8BB5896C-2789-4EB6-9B1B-7DFD4DA9101B@fireeye.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/cSZp2Oya3tVwTpk1vM8=e_N"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kyle Ames <kyle.ames@FireEye.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

--Sig_/cSZp2Oya3tVwTpk1vM8=e_N
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Mon, 30 Oct 2017 16:43:15 +0000
Kyle Ames <kyle.ames@FireEye.com> =C3=A9crivait:

> OS: CentOS 7.3
> Kernel: 3.10.0-693.2.2.el7.x86_64
> RAID: LSI RAID controller - RAID 6 with 10 disks - Strip Size 128
> (and thus a stripe size of 1MB if I understand correctly) LVM: One
> PV, VG, and LV is built on top of the RAID6. The output is below.
>=20
> RAID output:
> -----------------------------------------------------------------
> DG/VD TYPE  State Access Consist Cache Cac sCC      Size Name
> -----------------------------------------------------------------
> 0/0   RAID6 Optl  RW     No      RAWBD -   ON  72.761 TB DATA
>=20
> -------------------------------------------------------------------------=
---
> EID:Slt DID State DG     Size Intf Med SED PI SeSz Model
> Sp Type
> -------------------------------------------------------------------------=
---
> 18:0     35 Onln   0 9.094 TB SAS  HDD N   N  512B ST10000NM0096
> U  - 18:1     39 Onln   0 9.094 TB SAS  HDD N   N  512B
> ST10000NM0096    U  -

Please note that 10TB disks are using 4k blocks. It's not the culprit
here, but using 512b emulated definitely isn't optimal for RAID
performance.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/cSZp2Oya3tVwTpk1vM8=e_N
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAln4WSkACgkQX3jQXNUicVbL5QCg+Y1E/wEgEnunq+5eVBSnM9pc
bxAAnj8Aht4YwO4Tw51EAZP37bmhj3R8
=4Jt2
-----END PGP SIGNATURE-----

--Sig_/cSZp2Oya3tVwTpk1vM8=e_N--
