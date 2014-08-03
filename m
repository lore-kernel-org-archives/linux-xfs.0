Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B16497F54
	for <xfs@oss.sgi.com>; Sat,  2 Aug 2014 19:50:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 908F98F8037
	for <xfs@oss.sgi.com>; Sat,  2 Aug 2014 17:50:06 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id RsmMfJegyMMssfIG
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 02 Aug 2014 17:50:00 -0700 (PDT)
Message-ID: <1407026987.30258.60.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH][v3.2.y] xfs: really fix the cursor leak in
	xfs_alloc_ag_vextent_near
From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 03 Aug 2014 01:49:47 +0100
In-Reply-To: <53D91CBC.1000901@canonical.com>
References: <53D91CBC.1000901@canonical.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8452764160888390218=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: linux-kernel@vger.kernel.org, "stable@vger.kernel.org" <stable@vger.kernel.org>, xfs@oss.sgi.com


--===============8452764160888390218==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2k+LEOsAS2On6GRrQsko"


--=-2k+LEOsAS2On6GRrQsko
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-07-30 at 12:26 -0400, Joseph Salisbury wrote:
> Hello,
>    =20
> Please consider including mainline commit
> e3a746f5aab71f2dd0a83116772922fb37ae29d6 in the next v3.2.y release.  It
> was included in the mainline tree as of v3.5.  It has been tested and
> confirmed
> to resolve http://bugs.launchpad.net/bugs/1327360 .
>=20
>=20
> commit e3a746f5aab71f2dd0a83116772922fb37ae29d6
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Thu Jul 12 07:40:42 2012 +1000
>=20
>     xfs: really fix the cursor leak in xfs_alloc_ag_vextent_near

I assume I'm supposed to apply this first:

commit 76d095388b040229ea1aad7dea45be0cfa20f589
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Jun 12 14:20:26 2012 +1000

    xfs: fix allocbt cursor leak in xfs_alloc_ag_vextent_near

So I've queued up both of these.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-2k+LEOsAS2On6GRrQsko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU92HMOe/yOyVhhEJAQrDUg/+N1dtGeuhxC+v5li/Ah4UMK+fVIeUGQ0k
K62Mhb8o0zEm7ZxK6DK7ky+AeMBCesve50FiuiMXFyJyeL+GT+TMrkLcHKN4Ia1H
UlshiZGx68QSU/rL9eAGK/0hwDyfPdWod7rXsNcvZqo11C3lOuoQhrslSfwuVb6L
/e/2eypLmJ47rPIBTMz2AZZLzuZDBHPdd0fK4Kw2FHJw7F7wbJ30Vbpz7EEXZ1V5
Ds4q4dKfOrC/jaQlJO0SbiFC7wvpAmg/dUAU5xLE6SoY0uZDZiqssYpqB4SigUFf
TyxnMKRQ3tc1zDk5vWiMOppKP27SbKHQKd+Od+IVwJBy92+rMLBgj6CuC0QLuVC2
i+x5uXjQ/Oeo6eXVOzT+caAqJ5gnn/k9HN/l3p1imyLovFb62a5dukcpNPapp+FR
V4/j1sTmfXIeGnI+yH693AMy8d5wNgeH4Bqakukr7fEcXOY1Zx11lzqPC3HTQnWI
KkYtHw8VtgXTTdELVcBRphNvAnAsV7aKCiLucQgxkaPvkoDDB3lNalkSdC1WO18b
vR48vNNXL27lJBHoto1MHhJ8BazSI+1Y016gaiql81vX7FO0YkpfiEJMBaIWhymG
cuagIXjKkp/RrnjGH8mL3PcDHq0RqDq1zm/BjAznZZsErPMl/Ol0ylP4xv1Y3Kvq
pwFdY5d/0rE=
=GPx1
-----END PGP SIGNATURE-----

--=-2k+LEOsAS2On6GRrQsko--


--===============8452764160888390218==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8452764160888390218==--
