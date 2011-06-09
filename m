Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p59ACfgd164354 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 05:12:41 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9808816D65C0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2011 03:12:38 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id DczSY8jHLRfp2Mzx for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2011 03:12:38 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Defragging XFS File Systems
Date: Thu, 9 Jun 2011 12:12:35 +0200
References: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
	<201106090749.37745@zmi.at> <4DF080AC.2090507@hardwarefreak.com>
In-Reply-To: <4DF080AC.2090507@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201106091212.36227@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4108305498299273908=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Kenneth Emerson <kenneth.emerson@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>

--===============4108305498299273908==
Content-Type: multipart/signed;
  boundary="nextPart42198277.cYIGmQy3Xf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart42198277.cYIGmQy3Xf
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 9. Juni 2011 Stan Hoeppner wrote:
> When is running xfs_fsr recommended?

Good question. One case that comes to my mind is a filesystem that was=20
used a long time when filled >85%, which has now either been expanded or=20
files removed so you have a lot of space again, and you want to defrag=20
all those files that have been badly fragmented.
=20
> I scheduled it twice a week some time ago due to a filesystem
> containing active mbox files.  I did so because they became so
> heavily fragmented in short order, especially those swallowing
> copious amounts of list mail.  Before cron'ing xfs_fsr I was seeing
> mbox files with over 1000 fragmented extents, and increasing MUA
> latency as the files became more fragmented.  The filesystem is
> currently 90% free.

This is also an example where defrag may help. You have 10% usage, so=20
there's enough space. Maybe your usage fits the mount option=20
"allocsize", so that you keep room for file append. But newer kernels=20
changed behaviour of XFS, so I'm not sure up to which kernel version its=20
good. Maybe Dave Chinner can chime in here. BTW, maybe this behaviour=20
should be documented in the FAQ so we can reference it.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart42198277.cYIGmQy3Xf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3wnJQACgkQzhSR9xwSCbTbTwCePKjbhwNORPr2xVzuRMkGgaBo
vkEAnA86GGsja8JLKQGSgwlDyNpYH9et
=R8hY
-----END PGP SIGNATURE-----

--nextPart42198277.cYIGmQy3Xf--


--===============4108305498299273908==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4108305498299273908==--
