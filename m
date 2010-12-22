Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM836pu203351 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 02:03:06 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 308B7216381
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 00:04:59 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id oF5lZBFcNO6s0AUa for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 00:04:59 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS hangs
Date: Wed, 22 Dec 2010 09:04:56 +0100
References: <AANLkTikOcJA5a6u2YDXVGAEY0CqKiATTF02VeBsSKtU0@mail.gmail.com>
	<20101222060254.GH4907@dastard>
In-Reply-To: <20101222060254.GH4907@dastard>
MIME-Version: 1.0
Message-Id: <201012220904.56914@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4583673354065737665=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, Amit Sahrawat <amit.sahrawat83@gmail.com>

--===============4583673354065737665==
Content-Type: multipart/signed;
  boundary="nextPart2388745.nWRAbCaOEZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2388745.nWRAbCaOEZ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 22. Dezember 2010 Dave Chinner wrote:
> For future reference, when you are reporting a problem you need to
> be specific about what you were doing to cause the problem you are
> reporting.  Describe your kernel, your storage, your test case, any
> errors that occurred before the problem you are reporting, etc.
>=20
> We need this information to make any sense of your bug report, but
> I'm getting tired of having to ask for it every time you report a
> problem. The more information you put in your bug report, the more
> likely we are to be able to help you. We don't have unlimited
> amounts of time (or patience) to drag all the basic details of your
> problem out of you over 3 or 4 emails, so including it up front will
> help a lot....

Should I update this section?

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_=
reporting_a_problem.3F

We should probably just send that link to people so you don't have to=20
write long texts all the time.

Maybe above section should be updated to:

Things to include are what version of XFS you are using and version of=20
the kernel. If you have problems with userland packages please report=20
the version of the package you are using.

If the problem relates to a particular filesystem, the output from the=20
xfs_info(8) command and any mount(8) options in use will also be useful=20
to the developers.

If you experience an oops, please run it through ksymoops so that it can=20
be interpreted. Also describe what you were doing, if you can repeat it,=20
and describe you kernel, storage, test case, if there was a hardware=20
problem before, etc.

If you have a filesystem that cannot be repaired, make sure you have=20
xfsprogs 3.1.x or later and run xfs_metadump(8) to capture the metadata=20
(which obfuscates filenames and attributes to protect your privacy) and=20
make the dump available for someone to analyse.=20

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

--nextPart2388745.nWRAbCaOEZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0RsSgACgkQzhSR9xwSCbSALQCfQnX6mVVFVcPWbPMsZRgj2mU0
0UwAn1EL03pnMs6KxzVr+z1ztu40xOXP
=oz/Z
-----END PGP SIGNATURE-----

--nextPart2388745.nWRAbCaOEZ--


--===============4583673354065737665==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4583673354065737665==--
