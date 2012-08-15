Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7F8xdC4102606 for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 03:59:40 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Lqoy8qvsYGA9FG0C (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Aug 2012 01:59:36 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: howto keep xfs directory searches fast for a long time
Date: Wed, 15 Aug 2012 10:59:33 +0200
Message-ID: <2157104.ZTCJzWD7Ip@saturn>
In-Reply-To: <502A83F2.6070805@hardwarefreak.com>
References: <6344220.LKveJofnHA@saturn> <1888734.iS4pqoU89M@saturn>
	<502A83F2.6070805@hardwarefreak.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3537487168944218100=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com


--===============3537487168944218100==
Content-Type: multipart/signed; boundary="nextPart74728469.WUJyWP6KQ2"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart74728469.WUJyWP6KQ2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Dienstag, 14. August 2012, 11:59:30 schrieb Stan Hoeppner:
> All the media players have playlist and index features.  So there's
> little need for searching an entire Samba share is there?

Media Players usually connect to a Samba/NFS share, and read contents.=20=

Some even search for index JPGs, and present that for a sub-dir so you=20=

have a preview. All that is directory access.

> What you apparently require is not something that can be addressed or=

> optimized by filesystem or kernel tweaks.  As Dave pointed out with
> the 'locate' example in a CLI, this kind of thing is precisely what
> databases were designed for.

Yes, I use locate on that server of course, when I have shell access=20=

that's just fine. The "best effort" I can do now is to run the find=20
service for locate daily morning, so inodes get pre-cached, and tune=20=

vm.vfs_cache_pressure =3D 10 to keep them in the cache. This works rath=
er=20
good. I just tried a "du -s /bigdir" again, it runs within a very short=
=20
time (<4s) even 4h after the locate run, this is good enough. Customer=20=

will be happy. On the old server this took >3m, on the same hardware. A=
=20
speedup of at least 45x is what I call efficient tuning ;-)

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart74728469.WUJyWP6KQ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlArZPUACgkQzhSR9xwSCbQLIACeLrR/VOuK5rjtnHl8BkIoWWYs
x/AAnjXY4gRIbW5x0bn1wu2Ef0+Umwkg
=MEbW
-----END PGP SIGNATURE-----

--nextPart74728469.WUJyWP6KQ2--


--===============3537487168944218100==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3537487168944218100==--
