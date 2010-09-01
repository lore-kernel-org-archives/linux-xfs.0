Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o810QCI7092169 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 19:26:12 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47CCFD72192
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:37:21 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 64h8QU5DcBJS3NhD for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:37:21 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id B1FB5616
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 02:26:47 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 68D48401C2F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 02:26:47 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: broken XFS filesystem not to be repaired by xfs_repair 3.1.2
Date: Wed, 1 Sep 2010 02:26:46 +0200
MIME-Version: 1.0
Message-Id: <201009010226.46771@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1186258595461852956=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1186258595461852956==
Content-Type: multipart/signed;
  boundary="nextPart3361018.U3NooiSBJI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3361018.U3NooiSBJI
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

http://zmi.at/x/big.xfs.metadump.bz2

After I did the big "rm -r" on that 4TB volume, 4 subdirs with a file in=20
each are still left even after 20 "xfsrepair;mount;rm -r;umount" cycles.=20
So I dare to say it can't be repaired here.

It's not directly important as I'm going to format the filesytem now,=20
but I'd like this solved in case it hits me once in a real XFS on a=20
production server.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3361018.U3NooiSBJI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx9ncYACgkQzhSR9xwSCbQfBwCdFUmDlYy3kY0eWlTl8u/fPGH6
nlIAn1DLXDj7jg8iOk/ExvOvWX6zGIRL
=9/MX
-----END PGP SIGNATURE-----

--nextPart3361018.U3NooiSBJI--


--===============1186258595461852956==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1186258595461852956==--
