Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout03-q02.e.movistar.es ([86.109.101.162]:50773 "EHLO
        relayout03-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751611AbdICMPH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 08:15:07 -0400
Received: from relayout03-redir.e.movistar.es (relayout03-redir.e.movistar.es [86.109.101.203])
        by relayout03-out.e.movistar.es (Postfix) with ESMTP id 3xlWtS3ZkPzQlF6
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:06:56 +0200 (CEST)
Received: from Telcontar.valinor (130.red-79-146-117.dynamicip.rima-tde.net [79.146.117.130])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2)
        by relayout03.e.movistar.es (Postfix) with ESMTPSA id 3xlWtS0jCnzMl4B
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:06:55 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 48F6012094D
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:06:53 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id SN-yk7b3gbCw for <linux-xfs@vger.kernel.org>;
        Sun,  3 Sep 2017 14:06:53 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 199B2120946
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2017 14:06:53 +0200 (CEST)
Subject: Re: How do I stop the roll backs?
References: <15e3d125e44.1006338d5356.4004547008347294090@zoho.com>
 <20170901113853.27txrjvdcnc7gcgb@hades.localdomain>
 <52e5faf2-9e64-17e1-c368-38d193ffeb86@zoho.com>
 <CAAxjCEzzYJ3z2pNMQ=vm+aAFdLOpKKuN0buQcvQk7ApVFF+kXQ@mail.gmail.com>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <fc1fbac5-803c-fb11-6175-e17f87d36d95@telefonica.net>
Date: Sun, 3 Sep 2017 14:06:52 +0200
MIME-Version: 1.0
In-Reply-To: <CAAxjCEzzYJ3z2pNMQ=vm+aAFdLOpKKuN0buQcvQk7ApVFF+kXQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nIMDw44VcHoILFK1lpbJBIurrt6O3QWVu"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nIMDw44VcHoILFK1lpbJBIurrt6O3QWVu
Content-Type: multipart/mixed; boundary="NnWn2qBKsqBgRF7kkRIFEKLKslv68Xlrp";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <fc1fbac5-803c-fb11-6175-e17f87d36d95@telefonica.net>
Subject: Re: How do I stop the roll backs?
References: <15e3d125e44.1006338d5356.4004547008347294090@zoho.com>
 <20170901113853.27txrjvdcnc7gcgb@hades.localdomain>
 <52e5faf2-9e64-17e1-c368-38d193ffeb86@zoho.com>
 <CAAxjCEzzYJ3z2pNMQ=vm+aAFdLOpKKuN0buQcvQk7ApVFF+kXQ@mail.gmail.com>
In-Reply-To: <CAAxjCEzzYJ3z2pNMQ=vm+aAFdLOpKKuN0buQcvQk7ApVFF+kXQ@mail.gmail.com>

--NnWn2qBKsqBgRF7kkRIFEKLKslv68Xlrp
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 2017-09-02 09:55, Stefan Ring wrote:
> On Sat, Sep 2, 2017 at 1:41 AM, ToddAndMargo <> wrote:
>>
>> For the full run down and details on this stinker, see
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1483279
>> It includes a full hardware and OS list.
>=20
> TBH, I've never heard of SATA hotplug and would not in my wildest
> dreams expect it to work, let alone put it to work at a customer site.

I have been using SATA hotplug for years, and it works reliably.

However, the OS disk can not be swapped, and I have not tested it with
RAID components.

I use it to connect backup or extra data disks, usually with a single
big XFS partition on them, sometimes encrypted with LUKS.

It doesn't work on all firmware: for instance on the desktop computer
I'm using now, there are two SATA connectors that can't hotswap.

https://en.wikipedia.org/wiki/Serial_ATA

=C2=ABThe Serial ATA Spec includes logic for SATA device hotplugging. Dev=
ices
and motherboards that meet the interoperability specification are
capable of hot plugging.

Unlike PATA, both SATA and eSATA support hot swapping by design.
However, this feature requires proper support at the host, device
(drive), and operating-system levels. In general, all SATA devices
(drives) support hot swapping (due to the requirements on the
device-side), also most SATA host adapters support this command.[1]=C2=BB=


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 42.2 x86_64 "Malachite" at Telcontar)


--NnWn2qBKsqBgRF7kkRIFEKLKslv68Xlrp--

--nIMDw44VcHoILFK1lpbJBIurrt6O3QWVu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlmr8FwACgkQtTMYHG2NR9W4DgCgk1tNZg9/r4lYwwlnh6/EnaeX
LuYAnRhaa7Jp7LL+ANP+UGhHz0ZJh6tF
=D+7I
-----END PGP SIGNATURE-----

--nIMDw44VcHoILFK1lpbJBIurrt6O3QWVu--
