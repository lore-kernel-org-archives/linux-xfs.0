Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Sep 2006 22:45:37 -0700 (PDT)
Received: from albatross.madduck.net (armagnac.ifi.unizh.ch [130.60.75.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k865jRDW027334
	for <linux-xfs@oss.sgi.com>; Tue, 5 Sep 2006 22:45:32 -0700
Date: Wed, 6 Sep 2006 05:40:27 +0200
From: martin f krafft <madduck@madduck.net>
Subject: Re: XFS Journal on md device
Message-ID: <20060906034027.GA7393@piper.madduck.net>
References: <2260b150609051640y288629cbtcbc133d05b2b40dd@mail.gmail.com> <44FE28A8.5000803@oss.sgi.com> <2260b150609051853w1286eda7ve59a5df2c7e0ae1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <2260b150609051853w1286eda7ve59a5df2c7e0ae1c@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Seufert <seufert@gmail.com>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Chris Seufert <seufert@gmail.com> [2006.09.06.0353 +0200]:
> However on reboot xfs does a journal rebuild/repair. and the md
> does a re-sync of the md device.

Which distro?

I am the Debian maintainer for mdadm and have run into the problem
that the array used for / cannot be stopped until after / is
unmounted, at which point nothing stops the array for there is no
shutdownramfs.

However, we (Debian) remount / read-only and I never see
a filesystem check on reboot.

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
the micro$oft hoover: finally, a product that's supposed to suck!

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFE/kMrIgvIgzMMSnURAoSgAJ4mQ8a1RH6sYd7VRn4yZsRNKxbeSACdEGFv
HeWvLK1N+R1nvxMfeqlDZk8=
=LyfV
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--
