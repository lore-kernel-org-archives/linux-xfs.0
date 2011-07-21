Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6L6K64w010880 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 01:20:07 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85EEEEEB9E0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 23:20:03 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 4elnZBu5NItL159s for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2011 23:20:03 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 30 TB RAID6 + XFS slow write performance
Date: Thu, 21 Jul 2011 08:19:54 +0200
References: <4E24907F.6020903@johnbokma.com> <201107201604.33419@zmi.at>
	<20110720230126.GH9359@dastard>
In-Reply-To: <20110720230126.GH9359@dastard>
MIME-Version: 1.0
Message-Id: <201107210820.01019@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5027125400273231426=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>, John Bokma <contact@johnbokma.com>

--===============5027125400273231426==
Content-Type: multipart/signed;
  boundary="nextPart1350430.ads9QgJ9c0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1350430.ads9QgJ9c0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 21. Juli 2011 Dave Chinner wrote:
> No, they'll get sunit aligned but default, which would be on 64k
> boundaries.

OK, so only when <quote Dave> "swalloc mount option set and the=20
allocation is for more than a swidth of space it will align to swidth=20
rather than sunit" </quote Dave>.

So even when I specify swalloc but a file is generated with only 4KB, it=20
will very probably be sunit aligned on disk.
=20
> > That way, all stripes of a 1GB partition would be full when=20
> > there are roughly 1170 files (1170*896KiB ~ 1GB). What would happen
> > when  I create other files - is XFS "full" then, or would it start
> > using sub- stripes? If sub-stripes, would they start at su
> > (=3D64KiB) distances, or at single block (e.g. 4KiB) distances?
>=20
> It starts packing files tightly into remaining free space when no
> free aligned extents are availble for allocation in the AG.

That means for above example, that 16384 x 2KiB files could be created,=20
and each be sunit aligned on disk. Then all sunit start blocks are full,=20
so additional files will be sub-sunit "packed", is it this?

That would mean fragmentation is likely to occur from that moment, if=20
there are files that grow. And files >64KiB are immediately fragmented=20
then. At this time, there are only 16384 * 2KiB =3D 32MiB used, which is=20
3,125% of the disk. I can't believe my numbers, are they true?
OK, this is a worst case scenario, and as you've said before, any=20
filesystem can be considered full at 85% fill grade. But it's incredible=20
how quickly you could fuck up a filesystem when using su/sw and writing=20
small files.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1350430.ads9QgJ9c0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk4nxRAACgkQzhSR9xwSCbR4CgCdFRbImmZWLg/zY6CB3g5oKXw8
V7gAnRuhMeUEsKy16Zt8UCew9Gboswig
=u5r+
-----END PGP SIGNATURE-----

--nextPart1350430.ads9QgJ9c0--


--===============5027125400273231426==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5027125400273231426==--
