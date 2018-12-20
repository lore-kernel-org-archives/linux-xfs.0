Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout03-q02.e.movistar.es ([86.109.101.162]:40911 "EHLO
        relayout03-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728324AbeLTSrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Dec 2018 13:47:35 -0500
Received: from relayout03-redir.e.movistar.es (relayout03-redir.e.movistar.es [86.109.101.203])
        by relayout03-out.e.movistar.es (Postfix) with ESMTP id 43LLNN537mzQkMw
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 19:47:32 +0100 (CET)
Received: from Telcontar.valinor (105.red-79-146-214.dynamicip.rima-tde.net [79.146.214.105])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout03.e.movistar.es (Postfix) with ESMTPSA id 43LLNM0hCTzMlZb
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 19:47:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 9B3DD32060A
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 19:47:30 +0100 (CET)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id aerBMctm0XYR for <linux-xfs@vger.kernel.org>;
        Thu, 20 Dec 2018 19:47:30 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 7A92B320608
        for <linux-xfs@vger.kernel.org>; Thu, 20 Dec 2018 19:47:30 +0100 (CET)
Subject: Re: Same size drive has less usable space
References: <20181220131305.2a84b717@lud1.home>
 <6ab0a568-4732-905a-d45d-209f4bb0cfb0@sandeen.net>
 <20181220145529.1292ec61@lud1.home>
 <710b005e-0738-b793-3014-2234fcee84ad@sandeen.net>
 <20181220163943.5d8c6c2c@lud1.home>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <89b5b424-01a0-5369-963f-8adc044b5f2c@telefonica.net>
Date: Thu, 20 Dec 2018 19:47:21 +0100
MIME-Version: 1.0
In-Reply-To: <20181220163943.5d8c6c2c@lud1.home>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="2FcNxBx2BO3eb9srVozL4V8iuQdTd3ddk"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2FcNxBx2BO3eb9srVozL4V8iuQdTd3ddk
Content-Type: multipart/mixed; boundary="y1vYluhJcTlkKcZPsMVInkdE5yEPrIpbh";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <89b5b424-01a0-5369-963f-8adc044b5f2c@telefonica.net>
Subject: Re: Same size drive has less usable space
References: <20181220131305.2a84b717@lud1.home>
 <6ab0a568-4732-905a-d45d-209f4bb0cfb0@sandeen.net>
 <20181220145529.1292ec61@lud1.home>
 <710b005e-0738-b793-3014-2234fcee84ad@sandeen.net>
 <20181220163943.5d8c6c2c@lud1.home>
In-Reply-To: <20181220163943.5d8c6c2c@lud1.home>

--y1vYluhJcTlkKcZPsMVInkdE5yEPrIpbh
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 20/12/2018 19.39, Luciano ES wrote:
> On Thu, 20 Dec 2018 11:32:33 -0600, Eric Sandeen wrote:
>=20
>> but ok, I missed that you had 2k blocks on your backup disk.... I
>> don't really know what you're trying to do here, TBH.
>=20
> Smaller blocks waste less space. In ext3/4, I've always used 2k or=20
> even 1k blocks. It does save space. Doesn't it in XFS too?

Depends. Not always "smaller blocks waste less space". It depends on the
mix of filesizes. If most files are big, then no.

Consider, for instance, that in a filesystem with a fixed number of
inodes (like ext2/3/4), when using small blocks the structures that list
the blocks are larger, simply because there are more blocks.

--=20
Cheers / Saludos,

		Carlos E. R.
		(from 42.3 x86_64 "Malachite" at Telcontar)


--y1vYluhJcTlkKcZPsMVInkdE5yEPrIpbh--

--2FcNxBx2BO3eb9srVozL4V8iuQdTd3ddk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlwb48IACgkQtTMYHG2NR9VE9ACfftUvudHqRRUaFRVMZPhmw0cF
3EsAn2cE/IyUopodwQ0Krnus7w4ir2Pt
=ucvi
-----END PGP SIGNATURE-----

--2FcNxBx2BO3eb9srVozL4V8iuQdTd3ddk--
