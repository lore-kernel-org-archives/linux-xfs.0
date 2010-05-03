Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o438qY3l144246 for <xfs@oss.sgi.com>; Mon, 3 May 2010 03:52:34 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BAE5307659
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 01:54:40 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id LHv1InRhONA9ZgBO for
	<xfs@oss.sgi.com>; Mon, 03 May 2010 01:54:40 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id B6B0A800183
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 10:54:39 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 603CB83C823
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 10:54:39 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: read slower than write on "mv"?
Date: Mon, 3 May 2010 10:54:28 +0200
MIME-Version: 1.0
Message-Id: <201005031054.38817@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4658729543072289956=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4658729543072289956==
Content-Type: multipart/signed;
  boundary="nextPart1632245.G5Q5NsuaWY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1632245.G5Q5NsuaWY
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

This is not XFS specific, I see it on every filesys. I do a=20
"mv . /newlocation" and see this with iostat:

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
sz avgqu-sz   await  svctm  %util
xvdb              608,60    2,60 25967,20   102,40    85,31     5,37   =20
8,77   1,58  96,72
xvdg              0,00  608,60     0,00 26532,10    87,19     7,55  =20
12,41   0,12   7,44

Reading takes 97% I/O time, writing 7%. This is on the same raidset, but=20
I see the same when copying between two different single disks also. Or=20
is it just an effect of write caching that writes look faster than=20
reads?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1632245.G5Q5NsuaWY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvej04ACgkQzhSR9xwSCbQgCQCgoJg7TW1o4nZ30FAtCjjFyBht
064AoPOsBCaeZxeUjB2J+Mlsgi0J7nhp
=YbG2
-----END PGP SIGNATURE-----

--nextPart1632245.G5Q5NsuaWY--


--===============4658729543072289956==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4658729543072289956==--
