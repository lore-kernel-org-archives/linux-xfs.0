Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9FI659D208489 for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 13:06:05 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id W7f2TRg2X6DUqArB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Oct 2012 11:07:39 -0700 (PDT)
Received: from mailsrv.i.zmi.at (mailgate.i.zmi.at [IPv6:2001:470:736a:1::3])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPS id 5A07A1828D8B
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 20:07:38 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [IPv6:2001:470:736a:27::2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id D910FE18C15
	for <xfs@oss.sgi.com>; Mon, 15 Oct 2012 20:06:30 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Usage bigger after copy?
Date: Mon, 15 Oct 2012 20:07:34 +0200
Message-ID: <2368408.eSeMIOhpGu@saturn>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4972630542585366809=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4972630542585366809==
Content-Type: multipart/signed; boundary="nextPart42205340.AXbaF6v4NC"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart42205340.AXbaF6v4NC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

I know that the speculative prealloc of xfs can make files bigger on a=20=

destination, but I thought an "echo 3 >/proc/sys/vm/drop_caches" would=20=

help. I even umounted both filesystems, but the destination is bigger:

sys1 Blocks 8378368 Used 2631368 Avail 5747000
sys2 Blocks 8378368 Used 2966566 Avail 5411812

Both are VMs, have a 16G disk, partitioned same size, both on LVM,=20
copied with rsync. xfs_info show the same for both:

meta-data=3D/dev/mapper/dns1--system-root isize=3D256    agcount=3D4,=20=

agsize=3D524288 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D2097152, ima=
xpct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D2560, versio=
n=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-=
count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0

So why is there such a huge diff in size? 300M, 2.6G:2.9G, is a big=20
number. I found these dirs to be very different:

( I rebooted here compared to results before, but same strangeness )
# du -s /1/usr/lib/locale/* /usr/lib/locale/*|sort -n|grep YU
20      /usr/lib/locale/sh_YU.utf8
1760    /1/usr/lib/locale/sh_YU.utf8

But comparing them directly, they are the same:

# du -s /1/usr/lib/locale/sh_YU.utf8 /usr/lib/locale/sh_YU.utf8
1760    /1/usr/lib/locale/sh_YU.utf8
1760    /usr/lib/locale/sh_YU.utf8

So what makes "du" show a huge different when the dir above gets=20
scanned, versus when you compare dirs directly?

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart42205340.AXbaF6v4NC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlB8UOkACgkQzhSR9xwSCbRO/gCeOnykLqiqy33fbGVVixJsnyrx
FDsAoKpnLlqzP9WUdFsfxJhk0F5wwC4Y
=Pt0K
-----END PGP SIGNATURE-----

--nextPart42205340.AXbaF6v4NC--


--===============4972630542585366809==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4972630542585366809==--
