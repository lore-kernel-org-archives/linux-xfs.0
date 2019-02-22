Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tmailer.gwdg.de ([134.76.10.23]:54556 "EHLO tmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbfBVTU4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Feb 2019 14:20:56 -0500
Date: Fri, 22 Feb 2019 20:20:53 +0100
From: Andre Noll <maan@tuebingen.mpg.de>
Subject: Re: [PATCH 1/4] xfs_restore: refactor open-coded file creation code
Message-ID: <20190222192053.GF15048@tuebingen.mpg.de>
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
 <155085404462.5141.11851529133557195388.stgit@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KlAEzMkarCnErv5Q"
Content-Disposition: inline
In-Reply-To: <155085404462.5141.11851529133557195388.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org


--KlAEzMkarCnErv5Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 08:47, Darrick J. Wong wrote
> +	ret =3D ioctl(fd, XFS_IOC_RESVSP64, &fl);
> +	if (ret && errno !=3D ENOTTY)
> +		mlog(MLOG_VERBOSE | MLOG_NOTE,
> +_("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
> +				size, pathname, "XFS_IOC_RESVSP64",
> +				strerror(errno), errno);

The "XFS_IOC_RESVSP64" string literal can be included in the format string.

> +	if (ret =3D=3D 0)
> +		goto done;
> +
> +done:

LOL

> +	return fd;

If you really want to return success even if the ioctl() failed, this might
deserve a comment.

Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--KlAEzMkarCnErv5Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXHBLkgAKCRBa2jVAMQCT
D82KAJ4rTjWBuW1ZEddKkCqJQ1dXbU/JGgCaA1LfzQWVG4zQyly2upJ2ZGFa9x8=
=PDox
-----END PGP SIGNATURE-----

--KlAEzMkarCnErv5Q--
