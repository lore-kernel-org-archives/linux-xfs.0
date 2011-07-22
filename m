Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6M6A7rw068326 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 01:10:07 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B3D48CE1A
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 23:10:04 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 6YrQnwnwdNIEDf7w for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 23:10:04 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 30 TB RAID6 + XFS slow write performance
Date: Fri, 22 Jul 2011 08:10:00 +0200
References: <4E24907F.6020903@johnbokma.com> <201107210820.01019@zmi.at>
	<20110721064838.GA13963@dastard>
In-Reply-To: <20110721064838.GA13963@dastard>
MIME-Version: 1.0
Message-Id: <201107220810.01889@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3615817310793328324=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>, John Bokma <contact@johnbokma.com>

--===============3615817310793328324==
Content-Type: multipart/signed;
  boundary="nextPart5729045.t7mSBjdUt8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5729045.t7mSBjdUt8
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 21. Juli 2011 Dave Chinner wrote:
> If you are writing files that grow like this, then you are doing
> something wrong. If the app can't do it's IO differently, then this
> is exactly the reason we have userspace-controlled preallocation
> interfaces.
>=20
> Filesystems cannot prevent user stupidity from screwing something
> up....

This can happen if you copy a syslog server over to a new disk, then let=20
it start it's work again. Many files that start small and grow. Luckily,=20
the logs are rotated latest monthly, so it shouldn't be too bad.
=20
> > And files >64KiB are immediately fragmented
> > then. At this time, there are only 16384 * 2KiB =3D 32MiB used, which
> > is 3,125% of the disk. I can't believe my numbers, are they true?
>=20
> No, because most filesystems have a 4k block size.=20

I just meant pure disk usage. Of 1GB, only 32MB are used, and this worst=20
case example hits us badly.

> Not to mention
> that fragmentation is likely to be limited to the single AG the files
> in the directory belong to. i.e. even if we can't allocation a sunit
> aligned chunk in an AG, we won't switch to another AG just to do
> sunit aligned allocation.

This is good to know also, thanks.
=20
> > OK, this is a worst case scenario, and as you've said before, any
> > filesystem can be considered full at 85% fill grade. But it's
> > incredible how quickly you could fuck up a filesystem when using
> > su/sw and writing small files.
>=20
> Well, don't use a filesystem that is optimised for storing large
> sizes, large files and high bandwidth for storing lots of small
> files, then.  Indeed, the point of not packing the files is so they
> -don't fragemnt as they grow-. XFS is not designed to be optimal
> for small filesystems or small files. In most cases it will deal
> with them just fine, so in reality your concerns are mostly
> unfounded...

Yes, I just wanted to know about the corner cases, and how XFS behaves.=20
Actually, we're changing over to using NetApps, and with their WAFL=20
anyway I should drop all su/sw usage and just use 4KB blocks.

And even when XFS is optimized for large files, there are often small=20
ones. Think of a mysql server with hundreds of DBs and=20
innodb_file_per_table set. Even when some DBs are large, there are many=20
small files.

But this thread has drifted a bit. XFS does great work, and now I=20
understand the background a bit more. Thanks, Dave.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart5729045.t7mSBjdUt8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk4pFDkACgkQzhSR9xwSCbRW8ACfY0yQ7V1jodyIujcoJIylzA+M
aS4AoKMkdMiebpTo3bz5zHxQluo8tvG4
=3h4T
-----END PGP SIGNATURE-----

--nextPart5729045.t7mSBjdUt8--


--===============3615817310793328324==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3615817310793328324==--
