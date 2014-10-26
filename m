Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF1407F4E
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 19:51:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD35C8F8039
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 17:51:30 -0700 (PDT)
Received: from buxtehude.debian.org (buxtehude.debian.org [140.211.166.26]) by
	cuda.sgi.com with ESMTP id E20F9tzJiavV7RcR (version=TLSv1
	cipher=AES128-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Oct 2014 17:51:28 -0700 (PDT)
Subject: Bug#766811: spurious library links
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.766811.B.141428452927228@bugs.debian.org>
Date: Sun, 26 Oct 2014 02:48:25 +0200
From: "Marco d'Itri" <md@linux.it>
Message-ID: <20141026004825.GA27863@bongo.bofh.it>
MIME-Version: 1.0
Reply-To: "Marco d'Itri" <md@linux.it>, 766811@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8135333999913387880=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Debian Bug Tracking System <submit@bugs.debian.org>


--===============8135333999913387880==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Package: xfslibs-dev
Version: 3.2.1
Severity: normal

These links do not appear to have any purpose and should be removed:

/lib/libhandle.a -> /usr/lib/libhandle.a
/lib/libhandle.la -> /usr/lib/libhandle.la
/usr/lib/libhandle.so -> /lib/libhandle.so

Also, policy forbids to thip the .la files at all for normal libraries.

--=20
ciao,
Marco

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQGcBAEBCAAGBQJUTETZAAoJECv1pcEixPekDUAL/1ZETnJTeLt6DTKimbHXxsJW
gXC5vyI9/x50gPeGZM0QZDeoOqXkmn2NHww24ljtlar7SjyyKcsHVvWQ3e6h2GoW
vrfTfpAmsFNlx9QqolFiiLFExJbPVUFLTuINWTzDIPR+UjMlz3k0H1x5adrRbmmX
7KfscCiEVBbo+QSdFFVd3oiBriwsBLPhLxIEVwBOvBKzG5Vx+SIfPIcbS1VMMi3L
895Xj2cq4ZCOMb7bCOFybRUm6lpzK9y5gvkW7JyF56KHCr+wzXqy+NXmv6IbyoA5
G63gITsd9lwZ+f3kTYAFgZvirSVKt30deotZTmo0L8uFjMfvN4RcaeH7JP9pN37k
xgKoHeJRYPfI/scpQqNVBrGhrNke9FSbBpZt0qKBUg7NBuuncy4c1c8OUWCxehP5
iVzkTCMHzii1BtqjqiVhuwj6LZTj2hR170O1Sw2uRVFO++YVpyaQWt+zYSZkEptZ
5qQ3RGngc5ddu1V9SxTldZR0RoB/KvGruCzecNewBw==
=1jn8
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--


--===============8135333999913387880==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8135333999913387880==--
