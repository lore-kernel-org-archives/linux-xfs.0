Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E4D0429DF5
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 22:57:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C38AA304032
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 20:57:25 -0800 (PST)
Received: from buxtehude.debian.org (buxtehude.debian.org [206.12.19.147]) by
	cuda.sgi.com with ESMTP id bUKQLa6FEMKTmsaV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 20:57:18 -0800 (PST)
Subject: Bug#766811: spurious library links
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.766811.B766811.14518831228992@bugs.debian.org>
Date: Mon, 4 Jan 2016 05:41:36 +0100
From: Marco d'Itri <md@linux.it>
Message-ID: <20160104044136.GD11738@bongo.bofh.it>
References: <20141026004825.GA27863@bongo.bofh.it>
MIME-Version: 1.0
In-Reply-To: <20141026004825.GA27863@bongo.bofh.it>
Reply-To: Marco d'Itri <md@linux.it>, 766811@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3432837324973389613=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: 766811@bugs.debian.org
Cc: 766811-submitter@bugs.debian.org


--===============3432837324973389613==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Oct 26, Marco d'Itri <md@linux.it> wrote:

> These links do not appear to have any purpose and should be removed:
>=20
> /lib/libhandle.a -> /usr/lib/libhandle.a
> /lib/libhandle.la -> /usr/lib/libhandle.la
> /usr/lib/libhandle.so -> /lib/libhandle.so
>=20
> Also, policy forbids to thip the .la files at all for normal libraries.
This is an obvious bug and I have not heard back from you in over one
year, what are your plans about fixing this? Do you need help?

--=20
ciao,
Marco

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQGcBAABCAAGBQJWifgAAAoJECv1pcEixPek0JAL/ivJ8g5KklMSzitaMhhBqkw2
I2BJ5hb3PIyBxqRWqzwrdHyGUJX8rkyJz+bFxYcUi9a0+/CYx7KYkqjkHGPiXiA7
WWOQdCp8IPMdmR4QpY3KkamoGODvXJplSJvYeZd7wKWNfvznU+XsoREaXMm48vu4
Xvyi76vYXxN9Gt0fRJ12K1Tsw5wSV2bxZollaHSyShIDEW8aR955O77gYQmnc6xW
RTeM79ZkRBEEPhOgFw3wu1pjORUVAIPnNTIwXnMGxOgLLnxuoN6wfkcVMuYhCBK+
8vUEgo+YezaMFxVEU/5+ew0C55RobZoSNTVTcNwrTSuSc974Y+W+Nxvb8/U6buDi
JEVLea/aIzugUT9NmQ/UwtcdDClX2QY5G5XaFP8oniLI4NCQBPM3WRoi4kpjtkbc
FVtdn/kjOIKVwIe5xYzwhczfp6YP1mm6Cr8a8ZJdK+o/LhUi41H/O4PyR6e+spoI
2TV8F5j4guNpVCdTJzpzij1K7kzC3HcZQVDreCGwcA==
=p1lD
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--


--===============3432837324973389613==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3432837324973389613==--
