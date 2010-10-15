Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9F9CLwP118110 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 04:12:22 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FCE5191EC67
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 02:13:29 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 8pB6DvQA7M4ogVhi for
	<xfs@oss.sgi.com>; Fri, 15 Oct 2010 02:13:29 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: kernel crash 2.6.31.14-0.1-xen from openSUSE 11.2
Date: Fri, 15 Oct 2010 11:13:27 +0200
References: <201010092355.17240@zmi.at> <4CB62DBC.9060808@sandeen.net>
	<201010140718.38589@zmi.at>
In-Reply-To: <201010140718.38589@zmi.at>
MIME-Version: 1.0
Message-Id: <201010151113.27748@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5707852055621090339=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

--===============5707852055621090339==
Content-Type: multipart/signed;
  boundary="nextPart1734835.7qxyg9mSOZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1734835.7qxyg9mSOZ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 14. Oktober 2010 Michael Monnerie wrote:
> On Donnerstag, 14. Oktober 2010 Eric Sandeen wrote:
> > >> [1172140.926859] BUG: unable to handle kernel paging request at
> > >> 00000003d03dd178 [1172140.926877] IP: [<ffffffff80034872>]
> > >> dequeue_task+0x72/0x110 [1172140.926897] PGD 1b54b067 PUD 0
> > >> [1172140.926897] Thread overran stack, or stack corrupted
> > >>=20
> > >                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >=20
> > Awesome, that's the 2nd time in like 4 years I've seen that stack
> > canary I put in actually be useful ;)
>=20
> And both times reported by me :-)
> Not that I'm especially excited to have that problem though :-(
>=20
> What should I report where (upstream?) to get that fixed?

Is it the same bug as here? Then it has been fixed:
https://bugzilla.novell.com/show_bug.cgi?id=3D614670

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1734835.7qxyg9mSOZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky4GzcACgkQzhSR9xwSCbRUaQCgklyPT9SC9VtXJQ8oYcha7UAE
QkoAoIhh06BM4nGUz4Ahe/riNBQAaRS+
=jDP6
-----END PGP SIGNATURE-----

--nextPart1734835.7qxyg9mSOZ--


--===============5707852055621090339==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5707852055621090339==--
