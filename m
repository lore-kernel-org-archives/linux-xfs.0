Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACDL3xX125169 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 07:21:04 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BFCA172FF1
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 05:22:31 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 5b2Zk3nsBGhlbu1N for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 05:22:31 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair of critical volume
Date: Fri, 12 Nov 2010 14:22:28 +0100
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<4CCD3CE6.8060407@hardwarefreak.com>
	<864DA9C9-B4A4-4B6B-A901-A457E2B9F5A5@ucsc.edu>
In-Reply-To: <864DA9C9-B4A4-4B6B-A901-A457E2B9F5A5@ucsc.edu>
MIME-Version: 1.0
Message-Id: <201011121422.28993@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5689165323632154160=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eli Morris <ermorris@ucsc.edu>

--===============5689165323632154160==
Content-Type: multipart/signed;
  boundary="nextPart1926187.CGDXGOtDsH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1926187.CGDXGOtDsH
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 12. November 2010 Eli Morris wrote:
> The filesystem must be pointing to files that don't exist, or
> something like that. Is there a way to fix that, to say, remove
> files that don't exist anymore, sort of command? I thought that
> xfs_repair would do that, but apparently not in this case.

The filesystem is not optimized for "I replace part of the disk contents=20
with zeroes" and find that errors. You will have to look in each file if=20
it's contents are still valid, or maybe bogus.

I find the robustness of XFS amazing: You overwrote 1/5th of the disk=20
with zeroes, and it still works :-)

Now that you are in this state, I'd recommend you
a) make a *real* *tape* *backup*
You learned it the hard way: a disk copy is no backup, at least I hope=20
you learned that lesson
b) Maybe also copy all your files to another system, or you trust your=20
backup from a) very much
c) reinitialize the full array. Really recreate every array, 2 b sure=20
all your RAIDs work this time.
d) copy your data backup - either from the other copy of b), or from the=20
tape backup in a)

Then you will see a correct view of disk space used and which files are=20
still there. Now you must check every files content, some will have=20
bogus content.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1926187.CGDXGOtDsH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzdP5QACgkQzhSR9xwSCbReMQCbB7XWjcDIlbG32uswpT3TlHp7
yToAnjR4j5moKtp5bQsb5WY6/OZ2KobC
=TTaE
-----END PGP SIGNATURE-----

--nextPart1926187.CGDXGOtDsH--


--===============5689165323632154160==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5689165323632154160==--
