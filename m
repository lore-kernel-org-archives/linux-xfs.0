Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KE4cs9232792 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 09:04:38 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 820E552B79E
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 07:04:35 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id WCextyDNikoPZ1yt for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2011 07:04:35 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 30 TB RAID6 + XFS slow write performance
Date: Wed, 20 Jul 2011 16:04:31 +0200
References: <4E24907F.6020903@johnbokma.com> <20110720064419.GG9359@dastard>
	<4E26C5C5.1090802@hardwarefreak.com>
In-Reply-To: <4E26C5C5.1090802@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201107201604.33419@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5818851327307727239=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>, John Bokma <contact@johnbokma.com>

--===============5818851327307727239==
Content-Type: multipart/signed;
  boundary="nextPart1476356.MhkKoegevQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1476356.MhkKoegevQ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 20. Juli 2011 Stan Hoeppner wrote:
> I thought this was packing multiple small files into
> a single stripe write, which you just explained XFS does not do.

This is interesting, I jump in here. Does that mean that if I have a XFS=20
volume with sw=3D14,su=3D64k (14*64=3D896KiB) that when I write 10 small fi=
les=20
in the same dir with 2KB each, each file would be placed at a 896KiB=20
boundary? That way, all stripes of a 1GB partition would be full when=20
there are roughly 1170 files (1170*896KiB ~ 1GB). What would happen when=20
I create other files - is XFS "full" then, or would it start using sub-
stripes? If sub-stripes, would they start at su (=3D64KiB) distances, or=20
at single block (e.g. 4KiB) distances?

I hope I could explain my thoughts in an understandable way ;-)

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1476356.MhkKoegevQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk4m4HEACgkQzhSR9xwSCbQ6MwCePpzSvshA4rTAx82H6H7soUi9
cRoAnRkygjESqHIpLs3gVdBxLPV/HuTl
=UqDL
-----END PGP SIGNATURE-----

--nextPart1476356.MhkKoegevQ--


--===============5818851327307727239==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5818851327307727239==--
