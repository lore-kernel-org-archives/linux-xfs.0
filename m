Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA1EEOJA118451 for <xfs@oss.sgi.com>; Tue, 1 Nov 2011 09:14:24 -0500
Received: from shadbolt.e.decadent.org.uk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1A421F296FC
	for <xfs@oss.sgi.com>; Tue,  1 Nov 2011 07:14:22 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id ioNDighDKlwzRWqP
	for <xfs@oss.sgi.com>; Tue, 01 Nov 2011 07:14:22 -0700 (PDT)
Message-ID: <1320156842.30281.28.camel@deadeye>
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 01 Nov 2011 14:14:02 +0000
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4310900452800099905=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com


--===============4310900452800099905==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fJlQeUrvKum8YH3IBiQ1"


--=-fJlQeUrvKum8YH3IBiQ1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-10-18 at 02:18 -0200, Carlos Maiolino wrote:
> Fixes a possible memory corruption when the link is larger than
> MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
> S_ISLNK assert, since the inode mode is checked previously in
> xfs_readlink_by_handle() and via VFS.
>=20
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_vnodeops.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 51fc429..c3288be 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -123,13 +123,18 @@ xfs_readlink(
> =20
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> =20
> -	ASSERT(S_ISLNK(ip->i_d.di_mode));
> -	ASSERT(ip->i_d.di_size <=3D MAXPATHLEN);
> -
>  	pathlen =3D ip->i_d.di_size;

pathlen is a signed int (32-bit) and di_size has signed 64-bit type.
So, even if di_size was verified to be non-negative earlier (is it?)...

>  	if (!pathlen)
>  		goto out;
> =20
> +	if (pathlen > MAXPATHLEN) {

...pathlen may be negative here and will pass this check.

Ben.

> +		xfs_alert(mp, "%s: inode (%llu) symlink length (%d) too long",
> +			 __func__, (unsigned long long)ip->i_ino, pathlen);
> +		ASSERT(0);
> +		return XFS_ERROR(EFSCORRUPTED);
> +	}
> +
> +
>  	if (ip->i_df.if_flags & XFS_IFINLINE) {
>  		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
>  		link[pathlen] =3D '\0';

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-fJlQeUrvKum8YH3IBiQ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATq/+q+e/yOyVhhEJAQqMTg/9H3hIhbliIi6FQI1N0MqY4Sxmrjr745n0
WYsWL8IyTaPVEUiSlKiS5b/V4Lq7NheDVY32Pa/XroJo8CUZ1/sIlgVBgpYI/Rk0
2ovZ7ebcrNgqnrwTvmg2TdZkAXI083sofaZ7Ni/uAwO/CAf/qWDyym0SmJQ4iuMd
AezzwqJ1XzTxwswasBFOoVDTQaDbMqtiRe8tocXQ4ClaKNvHIqJWra6iwlUb8UKn
r9sqQuagzwy8gZdJT/h59BWAIOVHcjxKYBFXeJ/tAJ8HJ1meukeU4Hva2g1UbRso
tF0PMbXyxIrMV9ugxlrPBkX4c0f/H1j4eWzZlHgYDMiEGANrljvZlh3061VPpuUd
1AB4WKSzd/Fii8rKce+CkJCGYe6HG6n1tA4Yj012zHSJGWiElkkoFR+2wGCvg3aT
9jsuerwjjCnnzLgBzoHtiQ+403vlDIDJI6wnVGvKLTr3RhZNdq4V6CBC6OlNa+Lr
uQkgXaEdXmj5gQZX7PKLPJ6XJ/ijqUCWNr+427mT2y8m+SgBjw/U6eNWCW0lJV42
Tk44/xooP0IejKOj7kCY3i5rqhyJN/kk70p4qYb1+UbCwmGH1z6sdb1qIFZvz11v
y73Wu6DbycX1zZ3p8F/eVt33Hd9tqSg7wuRRqK4aFK5teLoiMrk3uK/n5ZlMX67k
AZ4HtievltQ=
=E102
-----END PGP SIGNATURE-----

--=-fJlQeUrvKum8YH3IBiQ1--


--===============4310900452800099905==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4310900452800099905==--
