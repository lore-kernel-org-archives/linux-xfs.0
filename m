Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout01-q01.e.movistar.es ([86.109.101.141]:48393 "EHLO
        relayout01-q01.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751611AbdICMfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 08:35:01 -0400
Received: from relayout01-redir.e.movistar.es (unknown [86.109.101.201])
        by relayout01-out.e.movistar.es (Postfix) with ESMTP id 3xlXVq3JqMzjYT8
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:34:59 +0200 (CEST)
Received: from Telcontar.valinor (130.red-79-146-117.dynamicip.rima-tde.net [79.146.117.130])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2)
        by relayout01.e.movistar.es (Postfix) with ESMTPSA id 3xlXVn34xBzfZkq
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:34:57 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id C8A5412094D
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:34:54 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id PfIKvPrDrNZt for <linux-xfs@vger.kernel.org>;
        Sun,  3 Sep 2017 14:34:54 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 9F751120946
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:34:54 +0200 (CEST)
Subject: Re: What is the proper way to remove an xfs partition?
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
 <7887d301-c849-e740-57ef-39d9221fcc86@zoho.com>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <3e4309b6-f84a-abcc-c075-76e798c70154@telefonica.net>
Date: Sun, 3 Sep 2017 14:34:54 +0200
MIME-Version: 1.0
In-Reply-To: <7887d301-c849-e740-57ef-39d9221fcc86@zoho.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DL4X3OHvLFAGLuNPqTBr1jUGqA30JqSsV"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DL4X3OHvLFAGLuNPqTBr1jUGqA30JqSsV
Content-Type: multipart/mixed; boundary="frC8037Oq3MasAmgB8xtKuX7RDL2PEQJi";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <3e4309b6-f84a-abcc-c075-76e798c70154@telefonica.net>
Subject: Re: What is the proper way to remove an xfs partition?
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
 <7887d301-c849-e740-57ef-39d9221fcc86@zoho.com>
In-Reply-To: <7887d301-c849-e740-57ef-39d9221fcc86@zoho.com>

--frC8037Oq3MasAmgB8xtKuX7RDL2PEQJi
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 2017-09-02 02:34, ToddAndMargo wrote:

>=20
> I don't know if you guys care about such things, but I just
> request that gparted do a disk blank
>=20
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1487807

It is a known issue with gparted that when you reformat a partition or
disk with something else, it doesn't properly erase at least the
critical areas of the previous filesystem, causing problems.

One that has been noticed more than once at openSUSE is this:

- 'dd' a CD image on an USB stick for operating system installation. For
instance, openSUSE-Leap-42.2-NET-x86_64.iso install disk.

- Afterwards, use gparted to remove partitions on the stick, create a
new partition, format it as FAT32 (with a label).

Tumbleweed (at some version) thought the USB to still be a CD (printing
its old label) and failed to mount it (because it is FAT).

The code detecting filesystem type had to be changed on Tumbleweed, but
the cause of the issue is that gparted did not erase the areas at the
start of the disk with that information, and the FAT format did not
write on them.



So this is not a problem with XFS, but a problem caused by gparted
(feature needed). You have to manually destroy key areas manually,
probably just a few sectors at partition start.


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 42.2 x86_64 "Malachite" at Telcontar)


--frC8037Oq3MasAmgB8xtKuX7RDL2PEQJi--

--DL4X3OHvLFAGLuNPqTBr1jUGqA30JqSsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlmr9u4ACgkQtTMYHG2NR9V7zgCgiLp4YB30fcwrFVUltBdx4jQq
Bl4An1THyxkvrOCKd7jX9qjJ3SICW04I
=LNCL
-----END PGP SIGNATURE-----

--DL4X3OHvLFAGLuNPqTBr1jUGqA30JqSsV--
