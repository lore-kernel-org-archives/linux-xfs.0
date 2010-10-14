Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9E5HZ6p217662 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 00:17:35 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72A5113A9866
	for <xfs@oss.sgi.com>; Wed, 13 Oct 2010 22:18:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Ccup1rTKSCMdRmPO for
	<xfs@oss.sgi.com>; Wed, 13 Oct 2010 22:18:41 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: kernel crash 2.6.31.14-0.1-xen from openSUSE 11.2
Date: Thu, 14 Oct 2010 07:18:37 +0200
References: <201010092355.17240@zmi.at> <20101010015628.GL4681@dastard>
	<4CB62DBC.9060808@sandeen.net>
In-Reply-To: <4CB62DBC.9060808@sandeen.net>
MIME-Version: 1.0
Message-Id: <201010140718.38589@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7732066924539583199=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

--===============7732066924539583199==
Content-Type: multipart/signed;
  boundary="nextPart3902100.kuyI8rs0qb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3902100.kuyI8rs0qb
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 14. Oktober 2010 Eric Sandeen wrote:
> >> [1172140.926859] BUG: unable to handle kernel paging request at
> >> 00000003d03dd178 [1172140.926877] IP: [<ffffffff80034872>]
> >> dequeue_task+0x72/0x110 [1172140.926897] PGD 1b54b067 PUD 0
> >> [1172140.926897] Thread overran stack, or stack corrupted
> >
> >                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> Awesome, that's the 2nd time in like 4 years I've seen that stack
> canary I put in actually be useful ;)

And both times reported by me :-)
Not that I'm especially excited to have that problem though :-(

What should I report where (upstream?) to get that fixed?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3902100.kuyI8rs0qb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky2kq4ACgkQzhSR9xwSCbSh1QCdHuyuCWREo7CTwVaYsAlBFeHv
jDkAnjEBaxfzScr4l5ZWw8M+xCL+VO1z
=l9CV
-----END PGP SIGNATURE-----

--nextPart3902100.kuyI8rs0qb--


--===============7732066924539583199==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7732066924539583199==--
