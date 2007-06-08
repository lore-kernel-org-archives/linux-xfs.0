Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 08 Jun 2007 01:52:12 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.168])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l588q6Wt022501
	for <xfs@oss.sgi.com>; Fri, 8 Jun 2007 01:52:08 -0700
Received: by ug-out-1314.google.com with SMTP id 74so1052176ugb
        for <xfs@oss.sgi.com>; Fri, 08 Jun 2007 01:52:06 -0700 (PDT)
Subject: Re: XFS shrink functionality
From: Ruben Porras <nahoo82@gmail.com>
In-Reply-To: <20070604084154.GA8273@teal.hq.k1024.org>
References: <1180715974.10796.46.camel@localhost>
	 <20070604001632.GA86004887@sgi.com>
	 <20070604084154.GA8273@teal.hq.k1024.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LdQDPymmi+rBggGPnr8T"
Date: Fri, 08 Jun 2007 10:23:53 +0200
Message-Id: <1181291033.7510.40.camel@localhost>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Iustin Pop <iusty@k1024.org>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, cw@f00f.org

--=-LdQDPymmi+rBggGPnr8T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Montag, den 04.06.2007, 10:41 +0200 schrieb Iustin Pop:
> Good to know. If there is at least more documentation about the
> internals, I could try to find some time to work on this again.

there is now a document explaining the XFS on disk format [0] and some
presentations for training courses, I think none of this were available
at the time you made the first try. Although they are not enough for our
purpose.=20

> My suggestion would be to start implementing these steps in reverse. 4)
> is the most important as it touches the entire FS. If 4) is working
> correctly, then 1) would be simpler (I think)

Why do you think that 1) would be simpler after 4)? For what I
understand, they are independent.

3) worries me, if walking the entire filesystem is needed, it want
scale...
=20=20
Since I don't know yet the xfs code I would like to begin with 1), I see
it independent from the other parts, and I can then learn more about the
transactions, allocators, and walking through the xfs structures. As you
did 4) one time, maybe you could try with this part of the problem if
you find the needed time, taking David's suggestions into account.

[0] http://oss.sgi.com/projects/xfs/papers/xfs_filesystem_structure.pdf

Cheers

--
Ruben Porras
LinWorks GmbH

--=-LdQDPymmi+rBggGPnr8T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGaRIZYubrKblAx+oRAgScAJ908dJzI9U9BLjh5ePQZkp6AfjSSgCgh6gL
5ON+D15BpF2nkNqM/LCiM8w=
=b01I
-----END PGP SIGNATURE-----

--=-LdQDPymmi+rBggGPnr8T--
