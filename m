Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 453027CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 08:38:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 04E06304048
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 06:38:49 -0700 (PDT)
Received: from mail.somenet.org (mail.somenet.org [213.143.98.34]) by
	cuda.sgi.com with ESMTP id XJo3i0Z5kNez1FwH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 06:38:47 -0700 (PDT)
Subject: Re: remounting with "errors=remount-ro" in fstab fails.
References: <5746FBD1.8010605@jvales.net>
From: Jan Vales <jan@jvales.net>
Message-ID: <5746FC64.3010703@jvales.net>
Date: Thu, 26 May 2016 15:38:44 +0200
MIME-Version: 1.0
In-Reply-To: <5746FBD1.8010605@jvales.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2666852352630477338=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============2666852352630477338==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="hLgW1om0LtsdWm0DfxgNnBvLJobki0ElI"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--hLgW1om0LtsdWm0DfxgNnBvLJobki0ElI
Content-Type: multipart/mixed; boundary="WISkRLW8v250n21hgr68SaRNX8Hsm3SNt"
From: Jan Vales <jan@jvales.net>
To: xfs@oss.sgi.com
Message-ID: <5746FC64.3010703@jvales.net>
Subject: Re: remounting with "errors=remount-ro" in fstab fails.
References: <5746FBD1.8010605@jvales.net>
In-Reply-To: <5746FBD1.8010605@jvales.net>

--WISkRLW8v250n21hgr68SaRNX8Hsm3SNt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 05/26/2016 03:36 PM, Jan Vales wrote:
> Hi there,
>=20
> I just updated to 4.6 kernel, and now i cannot remount / rw anymore.
>=20
> root@... # mount / -o remount,rw
> mount: / not mounted or bad option
>=20
> root@... # dmesg
> [...]
> XFS (md2): unknown mount option [errors=3Dremount-ro].
> [...]
>=20
> root@... # cat /etc/fstab
> [...]
> /dev/sda / xfs ro,noatime,logbufs=3D8,errors=3Dremount-ro,inode64 0 1
> [...]
/dev/md2, my fail, I removed the uuid here for readability.

>=20
> Was that change intentional?
> As in: shall i remove errors=3D... from fstab or is it a mistake?
>=20

cheers,
Jan Vales
--
I only read plaintext emails.


--WISkRLW8v250n21hgr68SaRNX8Hsm3SNt--

--hLgW1om0LtsdWm0DfxgNnBvLJobki0ElI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXRvxlAAoJEERD22thjA7qHNgP/R/luIJWPabN06PSDKDOXg9D
EhUaFvLswIB1uHOC5nn8dJczoq/x0lls6iOWgQzZO6aBVQTXdpG3+oIG7IbffEo6
uGoTr4JF1n/kTROxFs4Qnow5h9riTVwbbNhh6QcPBuQIJPddoeHfNa18zOllYGq1
zgo20InMhHm5u0bs3dmBzbBjOw/fmav38eNBSgyj6WokFDLlchPF+iQxze008Hxn
2QIrKxymdqmN0B3M5KL8aOVKenZ+JwyOhEMx12psRriSL2w2VmXiip1fDobyfh5V
gwjAnzPly3iEMShskSUsi3lmLjknsIWgZaeOg1vp2uDGmrNCKpSHrjrybQZACFr8
wX8ipSNHkwg6OeM5xc6I/hgvElm2UquFUL5UA3U1YAa2u3CFvOIH0ljx00Kk5A1q
4C4IM87IH4MhIDNyGmPF6E8azJ7IeyifTr6NTxb1Iw/kU3hqt1LlhTyD5f+b3CZ+
daAJ6QbNAGdYOkuq9lKBFg9M8Y/5DgwOntiYy6Y541yIgJCRP0hqx4bF+8W+K6O5
UdM8J2NRrKjyJ20oiWHIyHmHcLAW+MWLLKiR2OX0UctQpkML4bW99Wevlo1Y5DHE
I3nKS8nHzpMEyPSj76X2XZAc3JDA2ruMu41zKPv+UN4oCTwRmR8FmGi6eiC1075L
eCumm/YVedDKCEiEdbTg
=GHHk
-----END PGP SIGNATURE-----

--hLgW1om0LtsdWm0DfxgNnBvLJobki0ElI--


--===============2666852352630477338==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2666852352630477338==--
