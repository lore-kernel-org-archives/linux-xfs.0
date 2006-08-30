Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Aug 2006 04:41:55 -0700 (PDT)
Received: from albatross.madduck.net (armagnac.ifi.unizh.ch [130.60.75.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7UBfiDW000676
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 04:41:47 -0700
Received: from localhost (albatross.madduck.net [127.0.0.1])
	by albatross.madduck.net (postfix) with ESMTP id 7F642895D84
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 13:41:03 +0200 (CEST)
Received: from albatross.madduck.net ([127.0.0.1])
	by localhost (albatross.madduck.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 24347-01-7 for <xfs@oss.sgi.com>;
	Wed, 30 Aug 2006 13:41:03 +0200 (CEST)
Received: from lapse.madduck.net (84-72-16-26.dclient.hispeed.ch [84.72.16.26])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "lapse.madduck.net", Issuer "CAcert Class 3 Root" (verified OK))
	by albatross.madduck.net (postfix) with ESMTP id 523AE895D82
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 13:41:03 +0200 (CEST)
Date: Wed, 30 Aug 2006 13:41:09 +0200
From: martin f krafft <madduck@madduck.net>
Subject: Re: catch22: xfs_repair fails, tells me to mount, which fails
Message-ID: <20060830114109.GA22450@lapse.madduck.net>
References: <20060830082411.GA9986@lapse.madduck.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20060830082411.GA9986@lapse.madduck.net>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

FYI, here is how I fixed it, using LVM snapshots to ensure that
xfs_repair -L would produce acceptable results:

  http://blog.madduck.net/geek/2006.08.30-lvm-for-filesystem-recovery

I'd still be interested to know how I could have gone about fixing
it in case I could not have afforded to purge the journal.

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
the reason that every major university
maintains a department of mathematics
is that it's cheaper than
institutionalizing all those people.

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFE9XlVIgvIgzMMSnURAlcJAKCXHREzx25C2GVUJgpHE2VOb1AB8QCeL30g
ViVUAGCa6pMJYLWq1dZynV4=
=ViPg
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
