Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 10:25:07 -0700 (PDT)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IHP0bm004676
	for <linux-xfs@oss.sgi.com>; Wed, 18 Jul 2007 10:25:03 -0700
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1IBDGo-00016K-3A
	for linux-xfs@oss.sgi.com; Wed, 18 Jul 2007 19:25:02 +0200
Received: from cpe-74-74-219-54.rochester.res.rr.com ([74.74.219.54])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 18 Jul 2007 19:25:02 +0200
Received: from timotheus by cpe-74-74-219-54.rochester.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Wed, 18 Jul 2007 19:25:02 +0200
From: timotheus <timotheus@tstotts.net>
Subject: tuning XFS for tiny files
Date: Wed, 18 Jul 2007 13:15:38 -0400
Message-ID: <m23azlbpl1.fsf@tstotts.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

--=-=-=
Content-Type: text/plain


Hi. Is there a way to tune XFS filesystem parameters to better address
the usage pattern of 10000s of tiny files in directories such as:
    maildir directory
    mh mail directory
    ccache directory

My understanding is that XFS will always be much slower than reiserfs
with respect to deleting 10000s files; but that XFS might be possible to
tune toward more rapid read access of 10000s of tiny files.

Regards,
-timotheus

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQFGnkq+GWMp0IAo0gsRAjQOAJ9hiqmD/JaBUXigvbG7OyHUNOqQuwCfdBgK
AccPoqN/Y4aPvMjDUXdXsto=
=96Vk
-----END PGP SIGNATURE-----
--=-=-=--
