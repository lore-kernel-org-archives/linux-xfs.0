Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NN4DPP168598 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 18:04:14 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2D85A1411B5D
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 16:09:48 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id zbIjJrQSFQzIdvmf for
	<xfs@oss.sgi.com>; Fri, 23 Sep 2011 16:09:48 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH 2/2] Add test 257: Check proper FITRIM argument handling
Date: Sat, 24 Sep 2011 01:04:07 +0200
References: <1316787311-23428-1-git-send-email-lczerner@redhat.com>
	<1316787311-23428-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1316787311-23428-2-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Message-Id: <201109240104.08410@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9111166624764453189=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Lukas Czerner <lczerner@redhat.com>, aelder@sgi.com

--===============9111166624764453189==
Content-Type: multipart/signed;
  boundary="nextPart7029757.ghD0Q1Fo3l";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart7029757.ghD0Q1Fo3l
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 23. September 2011 Lukas Czerner wrote:
> +# FS QA Test No. 251
> +#
> +# This test was created in order to verify filesystem FITRIM
> implementation. +# By many concurrent copy and remove operations and
> checking that files +# does not change after copied into SCRATCH_MNT
> test if FITRIM implementation +# corrupts the filesystem
> (data/metadata).

This is a bit misspelled and (for me being non-native english) hard to=20
understand. I guess it should be

This test was created in order to verify the filesystem FITRIM=20
implementation by doing many concurrent copy and remove operations and
checking that files do not change after being copied into SCRATCH_MNT.
Test if FITRIM implementation corrupts the filesystem (data/metadata).

(Where I'm not sure if the last sentence belongs there, or in a separate=20
paragraph, or is redundant to the first sentence)

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart7029757.ghD0Q1Fo3l
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk59EGgACgkQzhSR9xwSCbR+SQCg3ouOCVgkdgCXBfr5JiwP8pVO
3eoAnjQEzbG0miwhH0ubTDvyplFokjEg
=jzWU
-----END PGP SIGNATURE-----

--nextPart7029757.ghD0Q1Fo3l--


--===============9111166624764453189==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9111166624764453189==--
