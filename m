Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6M6IlEG122973 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 01:18:47 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C0451BE3DBB
	for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 23:21:46 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id zOCqozqUL1TRkkyj for
	<xfs@oss.sgi.com>; Wed, 21 Jul 2010 23:21:46 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 34D5C704
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 08:21:45 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 8668283C82A
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 08:20:55 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfsprogs: CFLAGS not passed in
Date: Thu, 22 Jul 2010 08:21:39 +0200
MIME-Version: 1.0
Message-Id: <201007220821.44314@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5654109816018816981=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5654109816018816981==
Content-Type: multipart/signed;
  boundary="nextPart2768252.boLvVLKaT8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2768252.boLvVLKaT8
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I saw Christian Kujau's report yesterday with a quick fix, so maybe my=20
reports of a similar problem have been missed in the thread "rsync and=20
corrupt inodes (was xfs_dump problem)" and this is a repost:

I tried to compile xfsprogs with the "CFLAGS":
CFLAGS=3D"-march=3Dathlon64-sse3 -g -Os" ./configure --prefix=3D/usr

No matter what I use for CFLAGS, the resulting binary repair/xfs_repair=20
is always the same. So it seems to be ignored during compile anyway.=20
Smells like a bug? Because config.status gets the CFLAGS set, it's just=20
not used during compile. Comparing a "config.status" with CFLAGS set and=20
without:

# diff config.status config.status.default
360c360                                                                =20
<   with options \"'--prefix=3D/usr' 'CFLAGS=3D-march=3Dathlon64-sse3 -g -
Os'\"
=2D--
>   with options \"\"
439c439
<   set X '/bin/sh' './configure'  '--prefix=3D/usr' 'CFLAGS=3D-
march=3Dathlon64-sse3 -g -Os' $ac_configure_extra_args --no-create --no-
recursion
=2D--
>   set X '/bin/sh' './configure'  $ac_configure_extra_args --no-create=20
=2D-no-recursion
488c488
< max_cmd_len=3D'1572864'
=2D--
> max_cmd_len=3D'3458764513820540925'
507c507
< CFLAGS=3D'-march=3Dathlon64-sse3 -g -Os'
=2D--
> CFLAGS=3D'-g -O2'
591c591
< LTCFLAGS=3D'-march=3Dathlon64-sse3 -g -Os'
=2D--
> LTCFLAGS=3D'-g -O2'
717c717
< S["have_zipped_manpages"]=3D"true"
=2D--
> S["have_zipped_manpages"]=3D"false"
835c835
< S["CFLAGS"]=3D"-march=3Dathlon64-sse3 -g -Os"
=2D--
> S["CFLAGS"]=3D"-g -O2"


I even set all variables with "GCC" in config.status to random=20
content, and it compiles. Then I found that the one in=20
"include/builddefs" gets always set to this:
GCCFLAGS =3D -funsigned-char -fno-strict-aliasing -Wall

So I changed it manually:
GCCFLAGS =3D -march=3Dathlon64-sse3 -g -Os -funsigned-char -fno-strict-
aliasing -Wall
and now the resulting binary is different. I guess that should not be=20
happening? I'm used to setting "CFLAGS=3D" during configure to have=20
smaller bins, and CFLAGS normally get passed through during compile, but=20
not with xfsprogs. Maybe worth a fix?

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

--nextPart2768252.boLvVLKaT8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxH43gACgkQzhSR9xwSCbQSLQCff93XuIPXI0nncQzEG9iS7p2Z
mSsAoI0Gh2F3PbjWXnGErzPKNepqELqO
=60Sz
-----END PGP SIGNATURE-----

--nextPart2768252.boLvVLKaT8--


--===============5654109816018816981==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5654109816018816981==--
