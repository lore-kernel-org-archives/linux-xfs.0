Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B49D429DF5
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 19:03:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93BE2304032
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2016 17:03:16 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id njjjockk0tNjiiBq (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2016 17:03:06 -0800 (PST)
Subject: Bug#766811: spurious library links
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.766811.B766811.145472031712015@bugs.debian.org>
Date: Sat, 6 Feb 2016 01:58:21 +0100
From: Marco d'Itri <md@linux.it>
Message-ID: <20160206005821.GA11551@bongo.bofh.it>
References: <20141026004825.GA27863@bongo.bofh.it>
	<20160124151308.GA7620@jwilk.net>
MIME-Version: 1.0
In-Reply-To: <20160124151308.GA7620@jwilk.net>
Reply-To: Marco d'Itri <md@linux.it>, 766811@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1270083113034280958=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jakub Wilk <jwilk@debian.org>
Cc: 766811@bugs.debian.org


--===============1270083113034280958==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jan 24, Jakub Wilk <jwilk@debian.org> wrote:

> I can still see them in the current version:
You are right, I was fooled because the extra files disappear if you=20
rebuild the package:

md@bongo:/tmp/xfs/xfsprogs-4.3.0+nmu1$ find debian/|grep libhandle
debian/xfslibs-dev/lib/libhandle.so
debian/xfslibs-dev/usr/lib/libhandle.a
debian/xfslibs-dev/usr/lib/libhandle.la
debian/xfsprogs/lib/libhandle.so.1
debian/xfsprogs/lib/libhandle.so.1.0.3

So I wonder if this was a libtool bug and we just need to request=20
a binnmu of the package.

--=20
ciao,
Marco

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQGcBAABCAAGBQJWtUUtAAoJECv1pcEixPekD0cMAL6Xn7kH9iaCFJgnL9M6WFy0
PsX7p117Kk/7KnH7cBoeUhCTgkK+YBggujFWmFOyiEnfSiKnvb1sYh/uCC6ysdME
+t0gb9G/rU6h494qU/HbgOPQ2SQ2GpE0oMGaeb8LCSRd3LtqqED4tcTe7gR7pvrH
z4atW/1cFiUmO1dsmlGCaNrT2FWfGVtoat8NZcII+WBWUnDji7VBsx2T8rMDvdIH
+tozYVhA233qt2MwrVqvKuuXQ2Dopxm33Afc44O8USxOAfwULUi9C6F9lIzCLKFq
c20ZZfLK74KGq7+f1n985M2fNNVAMccOMvcn+T6VgiAzDnJ4lkjt/rrrukDP9q3N
ZtstfhR3BLmEvEI8hTrykZvTktSPsNL1dea/INQCfUmsA10w8U6Ja4xr4IJgaBBa
xr2PkqLgQRkxKfdWfz7+9Esjxc1uLdgvL81pyMr5kR617uEkgmoOzkr1FX3wesbK
V2kFpZfvSIPiUtnRTtQAKvgR87xMXJmcQXD4HicPEw==
=4vZn
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--


--===============1270083113034280958==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1270083113034280958==--
