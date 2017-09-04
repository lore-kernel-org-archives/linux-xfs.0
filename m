Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout01-q01.e.movistar.es ([86.109.101.141]:53369 "EHLO
        relayout01-q01.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753050AbdIDAOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2017 20:14:40 -0400
Received: from relayout01-redir.e.movistar.es (unknown [86.109.101.201])
        by relayout01-out.e.movistar.es (Postfix) with ESMTP id 3xlr272L0wzjYYG
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2017 02:14:39 +0200 (CEST)
Received: from Telcontar.valinor (240.red-83-33-32.dynamicip.rima-tde.net [83.33.32.240])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2)
        by relayout01.e.movistar.es (Postfix) with ESMTPSA id 3xlr25212MzfZy5
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2017 02:14:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 78BCB12091F
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2017 02:14:34 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id Olkpjt64YMsH for <linux-xfs@vger.kernel.org>;
        Mon,  4 Sep 2017 02:14:34 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 540F4120901
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2017 02:14:33 +0200 (CEST)
Subject: Re: What is the proper way to remove an xfs partition?
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
 <7887d301-c849-e740-57ef-39d9221fcc86@zoho.com>
 <3e4309b6-f84a-abcc-c075-76e798c70154@telefonica.net>
 <4741099f-1dcc-acff-46e1-61cd29ecf198@zoho.com>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <6bae012e-5ac7-16d7-7ee6-da7b3729aa72@telefonica.net>
Date: Mon, 4 Sep 2017 02:14:32 +0200
MIME-Version: 1.0
In-Reply-To: <4741099f-1dcc-acff-46e1-61cd29ecf198@zoho.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gvGmdpqB4QpJobp8P9bLl8wqTVucIKaqp"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gvGmdpqB4QpJobp8P9bLl8wqTVucIKaqp
Content-Type: multipart/mixed; boundary="LP2cfRKb5uGTGE5cvuOrk3Koc8Amev8He";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <6bae012e-5ac7-16d7-7ee6-da7b3729aa72@telefonica.net>
Subject: Re: What is the proper way to remove an xfs partition?
References: <837b6a2a-5989-385a-88e3-158f8b614637@zoho.com>
 <7887d301-c849-e740-57ef-39d9221fcc86@zoho.com>
 <3e4309b6-f84a-abcc-c075-76e798c70154@telefonica.net>
 <4741099f-1dcc-acff-46e1-61cd29ecf198@zoho.com>
In-Reply-To: <4741099f-1dcc-acff-46e1-61cd29ecf198@zoho.com>

--LP2cfRKb5uGTGE5cvuOrk3Koc8Amev8He
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 2017-09-04 02:03, ToddAndMargo wrote:
> On 09/03/2017 05:34 AM, Carlos E. R. wrote:


>> So this is not a problem with XFS, but a problem caused by gparted
>> (feature needed). You have to manually destroy key areas manually,
>> probably just a few sectors at partition start.
>>
>>
>=20
> Thank you!  And something for 1478707 to reproduce!

If you are interested, these are the openSUSE bugzillas:

https://bugzilla.opensuse.org/show_bug.cgi?id=3D1046268
USB Keys are mis-identified by device notifier

https://bugzilla.opensuse.org/show_bug.cgi?id=3D1046096
Can't mount fat32 USB stick: issue on the partition table

--=20
Cheers / Saludos,

		Carlos E. R.
		(from 42.2 x86_64 "Malachite" at Telcontar)


--LP2cfRKb5uGTGE5cvuOrk3Koc8Amev8He--

--gvGmdpqB4QpJobp8P9bLl8wqTVucIKaqp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlmsmukACgkQtTMYHG2NR9UUvwCeJC88jIpwu4Du4uWaVUrGVf9z
RjUAnAxNfJlYvQPpQ64+sKbX0Q4ARKke
=8SOg
-----END PGP SIGNATURE-----

--gvGmdpqB4QpJobp8P9bLl8wqTVucIKaqp--
