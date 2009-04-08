Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n383v3Db059095 for <xfs@oss.sgi.com>; Tue, 7 Apr 2009 22:57:20 -0500
Received: from smtp.nchc.org.tw (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 417D21402412
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2009 20:58:12 -0700 (PDT)
Received: from smtp.nchc.org.tw (smtp.nchc.org.tw [140.110.16.10]) by
	cuda.sgi.com with ESMTP id NmSwMoECdPKchJoC for
	<xfs@oss.sgi.com>; Tue, 07 Apr 2009 20:58:12 -0700 (PDT)
Date: Wed, 8 Apr 2009 11:56:48 +0800
From: Thomas Tsai <thomas@nchc.org.tw>
Subject: Re: Build xfs 3.0 deb problem
Message-Id: <20090408115648.efaee933.thomas@nchc.org.tw>
In-Reply-To: <732332763.3161411239158784001.JavaMail.root@mail-au.aconex.com>
References: <20090408100545.2354f572.thomas@nchc.org.tw>
	<732332763.3161411239158784001.JavaMail.root@mail-au.aconex.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1228218892373370388=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

--===============1228218892373370388==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Apr_2009_11_56_48_+0800_Gfi2XFHPDXIwPYcd"

--Signature=_Wed__8_Apr_2009_11_56_48_+0800_Gfi2XFHPDXIwPYcd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

tkx for reply soon.

My package name is partclone(partclone.org), like partimage, but I used lib=
xfs to check bitmap/super block and backup xfs partition. It's GPL licensed.

We need GPL tool to backup XFS partition. The partimage can do that but get=
 some problems(not based on the xfs library).
The xfs library you maintained well, and it's why I use xfslibs-dev's liarb=
ry to write backup tool, "partclone.xfs" .

so..., may I use xfslibs-dev to build partclone?
or stop it and remove?

tkx.

Thomas

On Wed, 8 Apr 2009 12:46:24 +1000 (EST)
Nathan Scott <nscott@aconex.com> wrote:

>=20
> ----- "Thomas Tsai" <thomas@nchc.org.tw> wrote:
>=20
> > Hello xfs,
> >=20
> > I get the source tarball and easy run Makepkgs debian
> > The build result look fine but lose some library files like
> > libxfs.a....
> >=20
> > I really need libxfs-dev to build my package.
> > Please give me a hand, tkx.
>=20
> What is your package, and what libxfs calls does it make?
> libxfs.a was never intended as a published API, and nothing
> outside xfsprogs should be using it.
>=20
> cheers.
>=20
> --=20
> Nathan


--=20
Thomas Tsai <thomas@nchc.org.tw>

--Signature=_Wed__8_Apr_2009_11_56_48_+0800_Gfi2XFHPDXIwPYcd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ3CCBXpcitEY3ms8RAiPaAKCFvHXN8YHFHa6++Wk9ezydG3wndACg3/H6
i7vm09poO//2YAp1iAOBd6g=
=XDKj
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Apr_2009_11_56_48_+0800_Gfi2XFHPDXIwPYcd--


--===============1228218892373370388==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1228218892373370388==--
