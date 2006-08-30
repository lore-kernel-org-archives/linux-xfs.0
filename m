Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Aug 2006 09:19:47 -0700 (PDT)
Received: from albatross.madduck.net (armagnac.ifi.unizh.ch [130.60.75.72])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7UGJPDW016697
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 09:19:32 -0700
Received: from localhost (albatross.madduck.net [127.0.0.1])
	by albatross.madduck.net (postfix) with ESMTP id 85433895D7C
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 16:15:45 +0200 (CEST)
Received: from albatross.madduck.net ([127.0.0.1])
	by localhost (albatross.madduck.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 31864-01-7 for <xfs@oss.sgi.com>;
	Wed, 30 Aug 2006 16:15:45 +0200 (CEST)
Received: from wall.oerlikon.madduck.net (84-72-16-26.dclient.hispeed.ch [84.72.16.26])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "wall.oerlikon.madduck.net", Issuer "CAcert Class 3 Root" (verified OK))
	by albatross.madduck.net (postfix) with ESMTP id 4902D895D7A
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 16:15:45 +0200 (CEST)
Received: from piper.oerlikon.madduck.net (piper.oerlikon.madduck.net [192.168.14.3])
	by wall.oerlikon.madduck.net (Postfix) with ESMTP id 2F58E18044B8
	for <xfs@oss.sgi.com>; Wed, 30 Aug 2006 16:15:49 +0200 (CEST)
Date: Wed, 30 Aug 2006 16:15:48 +0200
From: martin f krafft <madduck@madduck.net>
Subject: Re: catch22: xfs_repair fails, tells me to mount, which fails
Message-ID: <20060830141548.GA21325@piper.madduck.net>
References: <20060830082411.GA9986@lapse.madduck.net> <44F597F9.6020803@agami.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <44F597F9.6020803@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Shailendra Tripathi <stripathi@agami.com> [2006.08.30.1551 +020=
0]:
>        By any chance, did you saw any disk I/O error ?

No, definitely not.

> If there is no disk I/O error scenario, following information
> would be more useful.
>=20
> 1. /usr/sbin/xfs_logprint -s 0 -D <device>
> 2. /usr/sbin/xfs_logprint -d <device>

Thanks for the info. I managed to restore the filesystem with
xfs_repair -L in the mean time (see followup post), but this is what
I'll keep in mind for the next time.

Btw: there's the xfs and linux-xfs mailing list, and I am confused
about whether they're separate or merged, and which one I should be
using. If you have any input, I'd love to hear it.

--=20
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
=20
spamtraps: madduck.bogus@madduck.net
=20
no micro$oft components were used
in the creation or posting of this email.
therefore, it is 100% virus free
and does not use html by default (yuck!).

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature (GPG/PGP)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFE9Z2UIgvIgzMMSnURAgW9AJ9Fc+exuzdYd5IDlb85qLVQPb0zoQCfQe9r
u+BB7YT8QsxzPXlRHYCL5k0=
=X5g3
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
