Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o09M25Sa204916 for <xfs@oss.sgi.com>; Sat, 9 Jan 2010 16:02:05 -0600
Received: from mail.SerNet.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8577E1C3EA0E
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2010 14:02:57 -0800 (PST)
Received: from mail.SerNet.de (mail.SerNet.de [193.175.80.2]) by cuda.sgi.com
	with ESMTP id JOYbyyVb4pIHtjlh for <xfs@oss.sgi.com>;
	Sat, 09 Jan 2010 14:02:57 -0800 (PST)
Received: from intern.SerNet.DE by mail.SerNet.DE with esmtp (Exim 4.63 #1)
	for xfs@oss.sgi.com
	id 1NTjOZ-00045W-Sm; Sat, 09 Jan 2010 23:02:55 +0100
Received: from bjacke by pell.sernet.de with local (Exim 4.69)
	(envelope-from <bjacke@sernet.de>) id 1NTjOV-0004oI-H9
	for xfs@oss.sgi.com; Sat, 09 Jan 2010 23:02:51 +0100
Date: Sat, 9 Jan 2010 23:02:51 +0100
From: =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@sernet.de>
Subject: library to speed up posix_fallocate for XFS
MIME-Version: 1.0
Message-Id: <E1NTjOZ-001wx2-Iz@intern.SerNet.DE>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2085746635492730077=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2085746635492730077==
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

some of you might be interested in this little LD_PRELOAD'able library, whi=
ch
makes posix_fallocate() use XFS' unwritten extents via xfsctl:

http://repo.or.cz/w/libposix_fallocate_xfs.git

You won't need this if you have Kernel 2.6.25 and glibc 2.10 - in that case
kernel, glibc and filesystem work well together. If you don't have such an
up-to-date system libposix_fallocate_xfs can help you to improve this call.=
 It
works exactly like posix_fallocate() should do but it maps that funktion to
much more efficient code adapted for XFS.

Cheers
Bj=F6rn

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEAREDAAYFAktI/QsACgkQdoo0s+hIejls/QCg21flioD5LfJWNneF5KkXoHRh
m2gAnizx3zHhxstyIknBOhyGJx2aeVGX
=pheo
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--


--===============2085746635492730077==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2085746635492730077==--
