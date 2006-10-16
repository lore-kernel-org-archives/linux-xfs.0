Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 03:51:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9GApHaG020018
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 03:51:18 -0700
Received: from albatross.madduck.net (armagnac.ifi.unizh.ch [130.60.75.72])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA06F4AB901
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 02:52:15 -0700 (PDT)
Received: from localhost (albatross.madduck.net [127.0.0.1])
	by albatross.madduck.net (postfix) with ESMTP id EE13C895D7D
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 11:52:02 +0200 (CEST)
Received: from albatross.madduck.net ([127.0.0.1])
	by localhost (albatross.madduck.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 07409-02 for <xfs@oss.sgi.com>;
	Mon, 16 Oct 2006 11:52:02 +0200 (CEST)
Received: from wall.oerlikon.madduck.net (84-72-16-145.dclient.hispeed.ch [84.72.16.145])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "wall.oerlikon.madduck.net", Issuer "CAcert Class 3 Root" (verified OK))
	by albatross.madduck.net (postfix) with ESMTP id A866F895D79
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 11:52:02 +0200 (CEST)
Received: from piper.oerlikon.madduck.net (piper.oerlikon.madduck.net [192.168.14.3])
	by wall.oerlikon.madduck.net (Postfix) with ESMTP id A78F3403C
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 11:52:07 +0200 (CEST)
Date: Mon, 16 Oct 2006 11:52:05 +0200
From: martin f krafft <madduck@madduck.net>
Subject: Re: FS corruption and repair problem
Message-ID: <20061016095205.GA9000@piper.madduck.net>
References: <20061016082532.GA5574@jdc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <20061016082532.GA5574@jdc>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Jason White <jasonjgw@internode.on.net> [2006.10.16.1025 +0200]:
> The file system was shut down during a Debian package upgrade while tryin=
g to
> access apt-related files. I booted into an old 2.4 kernel on a separate
> partition and ran an old version of xfs_repair. The output is attached.
> Xfs_repair terminated abnormally (see the end of the output).

FYI:

  http://blog.madduck.net/geek/2006.08.09-through-with-xfs
  http://blog.madduck.net/geek/2006.08.11-xfs-zeroes
  http://blog.madduck.net/geek/2006.08.30-lvm-for-filesystem-recovery

You may be able to rescue the filesystem with xfs_dump and
xfs_restore via a separate storage medium.

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
http://lavender.cime.net/~ricky/badgers.txt

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFM1ZFIgvIgzMMSnURAstjAJ0RJsKeSF1PURiHwXuH8nOU5skL6gCgrbxR
fwF/h4VvomC3WBk2yqRcKhI=
=L+KK
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
