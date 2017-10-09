Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from relayout02-q02.e.movistar.es ([86.109.101.152]:48429 "EHLO
        relayout02-q02.e.movistar.es" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754986AbdJIPPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 11:15:06 -0400
Received: from relayout02-redir.e.movistar.es (unknown [86.109.101.202])
        by relayout02-out.e.movistar.es (Postfix) with ESMTP id 3y9kBt6KYlzhYJm
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2017 17:08:06 +0200 (CEST)
Received: from Telcontar.valinor (25.red-79-147-98.dynamicip.rima-tde.net [79.147.98.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: robin.listas2@telefonica.net)
        by relayout02.e.movistar.es (Postfix) with ESMTPSA id 3y9kBt3sBzzdbFy
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2017 17:08:06 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id 09EA532060E
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2017 17:08:06 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
        by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id YVqMBwyxNCnR for <linux-xfs@vger.kernel.org>;
        Mon,  9 Oct 2017 17:08:05 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by Telcontar.valinor (Postfix) with ESMTP id DE44032060D
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2017 17:08:05 +0200 (CEST)
Subject: Re: Questions about backups with XFS
References: <20171007114343.3bd42f98@lubh.lubhome>
 <20171009084451.yj7fvv6wqra27vuo@hades.localdomain>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <ec2fb542-c178-f17d-648e-4d9c4b34f280@telefonica.net>
Date: Mon, 9 Oct 2017 17:08:05 +0200
MIME-Version: 1.0
In-Reply-To: <20171009084451.yj7fvv6wqra27vuo@hades.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tblM6tO6dPg5ErUvN66nDcsRC6CiGlN72"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tblM6tO6dPg5ErUvN66nDcsRC6CiGlN72
Content-Type: multipart/mixed; boundary="7rtdP9JF8BmjlhAC5jgHQfla5Odl4iB47";
 protected-headers="v1"
From: "Carlos E. R." <robin.listas@telefonica.net>
To: Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Message-ID: <ec2fb542-c178-f17d-648e-4d9c4b34f280@telefonica.net>
Subject: Re: Questions about backups with XFS
References: <20171007114343.3bd42f98@lubh.lubhome>
 <20171009084451.yj7fvv6wqra27vuo@hades.localdomain>
In-Reply-To: <20171009084451.yj7fvv6wqra27vuo@hades.localdomain>

--7rtdP9JF8BmjlhAC5jgHQfla5Odl4iB47
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: quoted-printable

On 2017-10-09 10:44, Carlos Maiolino wrote:
> Hi.
>=20
>=20
> On Sat, Oct 07, 2017 at 02:43:43PM +0000, Luciano ES wrote:

=2E..

> Regarding the "restore everything and expect the system to boot", I thi=
nk you
> are forgetting a few things here:
>=20
> 	1 - xfsdump will backup the filesystem, not the device, so, MBR for
> 	    example is not backed up

The MBR is outside of the device holding the XFS filesystem, if by
device you mean something like /dev/sdXY. Another question would be the B=
R.

> 	2 - Is a bad idea to try to backup /dev for several reasons, like devi=
ce
> 	    names can change.

On some distros /dev is populated dynamically. For instance, on
openSUSE, it is a tmpfs, so there is no purpose on backing it. It
actually does not exist on the root disk, so the xfs tools will not see
it either, only the mount point.

--=20
Cheers / Saludos,

		Carlos E. R.
		(from 42.2 x86_64 "Malachite" at Telcontar)


--7rtdP9JF8BmjlhAC5jgHQfla5Odl4iB47--

--tblM6tO6dPg5ErUvN66nDcsRC6CiGlN72
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAlnbkNUACgkQtTMYHG2NR9X2YgCggfcc2h7/b05IQInMLiFr/v4H
41cAn0nhwavG2eWxhlH/gnzqA9BLL0bw
=ObEm
-----END PGP SIGNATURE-----

--tblM6tO6dPg5ErUvN66nDcsRC6CiGlN72--
