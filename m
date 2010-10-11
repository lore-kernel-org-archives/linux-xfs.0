Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9B4uwC9172548 for <xfs@oss.sgi.com>; Sun, 10 Oct 2010 23:56:59 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C924418ECE45
	for <xfs@oss.sgi.com>; Sun, 10 Oct 2010 21:58:03 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id CNDFhY1y6JGVmmDj for
	<xfs@oss.sgi.com>; Sun, 10 Oct 2010 21:58:03 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: kernel crash 2.6.31.14-0.1-xen from openSUSE 11.2
Date: Mon, 11 Oct 2010 06:57:55 +0200
References: <201010092355.17240@zmi.at> <20101010015628.GL4681@dastard>
In-Reply-To: <20101010015628.GL4681@dastard>
MIME-Version: 1.0
Message-Id: <201010110658.00379@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4105655982038360903=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4105655982038360903==
Content-Type: multipart/signed;
  boundary="nextPart1393302.Eep37k4lRq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1393302.Eep37k4lRq
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sonntag, 10. Oktober 2010 Dave Chinner wrote:
> > [1172140.926859] BUG: unable to handle kernel paging request at
> > 00000003d03dd178 [1172140.926877] IP: [<ffffffff80034872>]
> > dequeue_task+0x72/0x110 [1172140.926897] PGD 1b54b067 PUD 0
> > [1172140.926897] Thread overran stack, or stack corrupted
>=20
>                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> The stack trace shows pdflush doing writeback, and way down the
> stack doing a memory allocation that triggered direct reclaim, which
> caused writeback to occur, which blew the stack.....

Thanks. So what? Didn't we have this before? I sent a mail on May 21,=20
2010, with subject "kernel crash: scheduling while atomic". Eric Sandeen=20
said "I'm guessing you blew the stack".

So what should I do about it? I think I read about a patch that should=20
fix this. Seems Novell/openSUSE didn't backport it, so could someone=20
please guide me where to find it? And I guess I should report upstream,=20
right?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1393302.Eep37k4lRq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkyymVgACgkQzhSR9xwSCbTKzwCg7/BDOpHhhdP7zJRFGLSOTT7K
dx8AoKNMNR1H7DvBEzb5rvbir/sc+A9U
=XjpO
-----END PGP SIGNATURE-----

--nextPart1393302.Eep37k4lRq--


--===============4105655982038360903==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4105655982038360903==--
