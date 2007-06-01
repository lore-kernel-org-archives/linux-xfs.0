Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Jun 2007 10:06:32 -0700 (PDT)
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.227])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l51H6QWt007883
	for <xfs@oss.sgi.com>; Fri, 1 Jun 2007 10:06:27 -0700
Received: by wr-out-0506.google.com with SMTP id i22so545183wra
        for <xfs@oss.sgi.com>; Fri, 01 Jun 2007 10:06:26 -0700 (PDT)
Subject: XFS shrink functionality
From: Ruben Porras <nahoo82@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cNVvu74QiAC041q1y3BN"
Date: Fri, 01 Jun 2007 18:39:34 +0200
Message-Id: <1180715974.10796.46.camel@localhost>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: iusty@k1024.org, cw@f00f.org

--=-cNVvu74QiAC041q1y3BN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hello,=20

I'm investigating the possibility to write myself the necessary code to
shrink an xfs filesystem (I'd be able to dedicate a day/week). Trying to
know if something is already done I came across the mails of a previous
intent [0], [1] (I'm cc'ing the people involved).=20

At a first glance the patch is a little outdated and will no more apply
(as of linux 2.16.18, which is the last customised kernel that I was
able to run under a XEN environment), because at least the function
xfs_fs_geometry is changed.=20

I'm really curious about what happened to this patches and why they were
discontinued. The second part never was made public, and there was also
no answer. Was there any flaw in any of the posted code or anything in
XFS that makes it especially hard to shrink [3] that discouraged the
development?

After that, the first questions that arouse are,
would there be some assistance/groove in from the developers?=20
How doable is it?
What are the programmers requirements from your point of view?

Thank you.

[1] http://oss.sgi.com/archives/xfs/2005-08/msg00142.html
[2] http://oss.sgi.com/archives/xfs/2005-09/msg00038.html
[3] the only limitation that I might think of is not being able to
shrink past the internal journal.

--=-cNVvu74QiAC041q1y3BN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGYEvGYubrKblAx+oRAhjZAJ4terI47D96a4JX8wsyge5iA/f6nQCgkTeN
3qlB2vKeB7015poCrDexuWQ=
=7rZq
-----END PGP SIGNATURE-----

--=-cNVvu74QiAC041q1y3BN--
