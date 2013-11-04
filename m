Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 956117F6F
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 09:10:57 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 805C28F8065
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 07:10:57 -0800 (PST)
Received: from kazi.fit.vutbr.cz (kazi.fit.vutbr.cz [147.229.8.12]) by
	cuda.sgi.com with ESMTP id yUxC6RghGDvhAEGl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 07:10:55 -0800 (PST)
Date: Mon, 4 Nov 2013 16:10:50 +0100
From: Kasparek Tomas <kasparek@fit.vutbr.cz>
Subject: Re: How to use increased number of ACL entries?
Message-ID: <20131104151050.GS9974@fit.vutbr.cz>
References: <20131103081704.GE9974@fit.vutbr.cz>
	<20131104003915.GN6188@dastard> <5277086E.6030905@sandeen.net>
	<52771FFE.8030009@gmail.com> <5277AE19.0@sandeen.net>
MIME-Version: 1.0
In-Reply-To: <5277AE19.0@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5820507956160425679=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com


--===============5820507956160425679==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3bhLwMadv7h6/J9"
Content-Disposition: inline


--O3bhLwMadv7h6/J9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 04, 2013 at 08:24:25AM -0600, Eric Sandeen wrote:
> > However, it should be dirent (ftype=3D1 in the above output) that keeps=
 a=20
> > vanilla 3.10.17 kernel from mounting the resulting filesystem:
>=20
> I'm sorry, you are right - it hit kernel v3.11:
>=20
> 5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57 xfs: increase number of ACL entr=
ies for V5 superblocks
>=20
> $ git describe --contains 5c87d4bc1a86bd6e6754ac3d6e111d776ddcfe57
> v3.11-rc1~18^2~41

And get to stable 3.10 later.

https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit=
/?id=3D0a8aa1939777dd114479677f0044652c1fd72398

--=20

  Tomas Kasparek               E-mail: kasparek@fit.vutbr.cz
  CVT FIT VUT Brno, L127       Web:    http://www.fit.vutbr.cz/~kasparek
  Bozetechova 1, 612 66        Fax:    +420 54114-1270
  Brno, Czech Republic         Phone:  +420 54114-1220

  jabber: tomas.kasparek@jabber.cz
  GPG:    2F1E 1AAF FD3B CFA3 1537  63BD DCBE 18FF A035 53BC

  May the command line live forever!

--O3bhLwMadv7h6/J9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (FreeBSD)

iEYEARECAAYFAlJ3uPoACgkQFiofPpFRnYgkugCcD+jbRBFSoZZWmCaxLBxWuSId
nA0An1FLgyxNyGz9fSHDUj2kWf8j1j3u
=sUpJ
-----END PGP SIGNATURE-----

--O3bhLwMadv7h6/J9--


--===============5820507956160425679==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5820507956160425679==--
