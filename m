Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jul 2007 00:42:59 -0700 (PDT)
Received: from ipmail01.adl2.internode.on.net (ipmail01.adl2.internode.on.net [203.16.214.140])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6U7gpbm023220
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2007 00:42:55 -0700
Subject: Re: REVIEW: Make xfs_metadump more robust against bad extents
From: Stewart Smith <stewart@flamingspork.com>
In-Reply-To: <op.tv9flnkx3jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.tv9flnkx3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NgKXeHTmeFvk3SSqvcTf"
Date: Mon, 30 Jul 2007 07:26:04 +0000
Message-Id: <1185780364.20232.184.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

--=-NgKXeHTmeFvk3SSqvcTf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-07-30 at 14:18 +1000, Barry Naujok wrote:
> @@ -76,9 +77,10 @@ metadump_help(void)
>  " The 'metadump' command dumps the known metadata to a compact file
> suitable\n"
>  " for compressing and sending to an XFS maintainer for corruption
> analysis \n"
>  " or xfs_repair failures.\n\n"
> -" There are 3 options:\n"
> +" Options:\n"
>  "   -e -- Ignore read errors and keep going\n"
>  "   -g -- Display dump progress\n"
> +"   -m -- Specify max extent size limit to copy for metadata (default
> =3D 100)\n"

maybe "max extent size (blocks)" and "default =3D 100 blocks"?
--=20
Stewart Smith (stewart@flamingspork.com)
http://www.flamingspork.com/


--=-NgKXeHTmeFvk3SSqvcTf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQIVAwUARq2SjL3yNwHyU3DLAQISLxAAmHu4KSd0EIFTgHlLiRUPWee2mlx302+z
NWQ6AM6jW8ABC+SVSQ+rJmKisgdFMGDLtxe9gXbjmenfOiIXDxx/Z+x1+6jrRWNn
5DjNln4Wn5SQs4NnnBzbxRsVCkW25J1r87ed2DFSQDk5fbxxHrZE6pQ5V2L2nPb1
8BranI2626iClgc5X4xrVPxCyPOj80AyhQ9wqNB128eHnK3cH02oCQeyZLp55lmH
gg8haOSluPAvCrp3IkF2tFwnN4XhBdM0cC16/w5gewToB+GM76HUM1pGXFGsfy2H
8emXlImz4eAhSvAZ8/AGofvV3RE6VfF5ysIJ9H3n3Fzo2gM+NuB5w5Or5+NzA5/I
/rnUj8I3L+DMtS+YKrtD39Ifmzm44Rf5uzbFOAv+KTBJgDKi3Bw0K+hspOQlD6kf
LEixewRUEqPIhH9k1xxEPSWmciXcTbSOvHuE17bdsWbUhAdQxllafmqdH/uLUDzF
QDVAQWNhyXUR8Xvo3fJSSSTS0z13BbWOr+Zct+j1/rOUffCb0kvizH5LCkNiUqZA
VSK/gkf6nQ0VU/AjtVmcfct7Qtb+jFz1kcsp3B5DnnT+MdoftAXNWwCzdFXgPs21
JejnkGoeZ4iDoW5pBYiwlbtWhzz+mTlpEUqiq8RdpEqLPfTnjf4POA7IBBauy1Hx
ncIbPBlpReo=
=/nhn
-----END PGP SIGNATURE-----

--=-NgKXeHTmeFvk3SSqvcTf--
