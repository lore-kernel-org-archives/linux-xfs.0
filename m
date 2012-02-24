Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1O7pwqC003257 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 01:51:58 -0600
Date: Fri, 24 Feb 2012 10:53:54 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] xfs: Use memset to initialize structure member.
Message-ID: <20120224075354.GA3649@mwanda>
References: <1330067322-17011-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1330067322-17011-1-git-send-email-santoshprasadnayak@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6326462060407343676=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: elder@kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, bpm@sgi.com


--===============6326462060407343676==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 24, 2012 at 12:38:42PM +0530, santosh nayak wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>=20
> Sparse is giving following warning:
> fs/xfs/xfs_bmap.c:4826:41: warning: Using plain integer as NULL pointer.
>=20

You could just do:
	struct xfs_bmalloca     bma =3D {};

But honestly, I'd just leave this one as is.  The xfs people are
grumpy sorts and it's best to not send them these kinds of patches
that don't address a real bug.

regards,
dan


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPR0IRAAoJEOnZkXI/YHqR/84P/j4f0CsYWMeZkm06V4vIICwt
6yDTBYrqgzegoWrWOO1R4PM3htN4+Pjl2sOhv8lykMiC4gA0Fx7ZhI4F0F4iu/NG
oVWT9zgh321PwZbJMgXIkYdbJfFFToi++c5mLPV6zoEZb0cA5yxWKbXygcxACExx
975KtBZRjoLOK5jqChNL0ZMdE4xCM2n1cXchL7ym8R7WWzroFVKIlFaZxN8MjiR6
nXcqLPIICjyGl5ZmE2LRquL+es2bxlSBwTPOsgzic7fpDkanyBM3BGZBCbtfjoUN
E5k08dJ8DOr4YV1TGIatoekDSuDXGSzlLdUWXGd27L0E+MOv1XM479abDq/YtWxL
EqDyD5yXaebbJ36iYWyM/ydMwvHiJtnAlNYnezG04iJK0KDn1EkWKaBkWhXJ2yMO
ZWASCbZDkFNDesMgaoYtLhmPsSC8CCAo49U4h9TEo4XXKIq1CiF/3/3a2vbE1FhS
YJ2PsCMcAozWW4eLf6r6cIVEwxbm5N/kCLgPO0c//CC542RqkrZu7TNWvarej9Md
Lq65YgjkOeCQI3cXw3NESbbbTnKg6+bnNWWLAdAGtEQMA9lxMqWtvYPJnUWXP84q
TmpdODip7eVkmKfcaO9Dk1J/AUMILuakRvg5lLUaiipOdjrO3w8Kp/a6s1jBkF7D
+Ci39unsMJKpfpjCY/bO
=oEhI
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--


--===============6326462060407343676==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6326462060407343676==--
