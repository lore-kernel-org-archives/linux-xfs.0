Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7JNHs5T203868 for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 18:17:54 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26556CF6186
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 16:27:47 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id W5Smbf0cvqICVNlv for
	<xfs@oss.sgi.com>; Thu, 19 Aug 2010 16:27:47 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id BE56617A
	for <xfs@oss.sgi.com>; Fri, 20 Aug 2010 01:18:19 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 726F7401C3A
	for <xfs@oss.sgi.com>; Fri, 20 Aug 2010 01:18:19 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Question about XFS recovery and error
Date: Fri, 20 Aug 2010 01:18:18 +0200
References: <AANLkTi=prcC7ky3ikNTJ+py8XnALGf4THSOCUwqYhxaq@mail.gmail.com>
In-Reply-To: <AANLkTi=prcC7ky3ikNTJ+py8XnALGf4THSOCUwqYhxaq@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201008200118.18306@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6431227131805028527=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6431227131805028527==
Content-Type: multipart/signed;
  boundary="nextPart5590563.RSI40aLk2m";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5590563.RSI40aLk2m
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Freitag, 20. August 2010 Mike Gao wrote:
> Should XFS recovery this at the beginning when mounting?
=20
I've had this several times. XFS doesn't normally detect errors during=20
mount, because it doesn't run fsck - no filesystem does that. So you'll=20
trip over errors as you use the files involved - like this one.

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

--nextPart5590563.RSI40aLk2m
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxtu7oACgkQzhSR9xwSCbR6mACgr+RrV14pWu0kLx0NV+DJaQuY
0lcAoKYnOtGGBnU4eRQe4F02lmqSZRFr
=/ZOW
-----END PGP SIGNATURE-----

--nextPart5590563.RSI40aLk2m--


--===============6431227131805028527==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6431227131805028527==--
