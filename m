Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9OGtE4r091094 for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 11:55:15 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEC041537A99
	for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 09:55:12 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id JuIKeqZbyGvNS3Xr for
	<xfs@oss.sgi.com>; Mon, 24 Oct 2011 09:55:12 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair v3.1.6 - Segmentation fault AND XFS internal error
	xfs_btree_check_sblock
Date: Mon, 24 Oct 2011 18:55:08 +0200
References: <4E9C3EEF.5080609@cape-horn-eng.com>
	<20111017225223.GU3159@dastard>
	<4E9D4DE3.5080304@cape-horn-eng.com>
In-Reply-To: <4E9D4DE3.5080304@cape-horn-eng.com>
MIME-Version: 1.0
Message-Id: <201110241855.10235@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0144367649400439054=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Richard Ems <richard.ems@cape-horn-eng.com>

--===============0144367649400439054==
Content-Type: multipart/signed;
  boundary="nextPart1992814.b16DN3StYD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1992814.b16DN3StYD
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 18. Oktober 2011 Richard Ems wrote:
> We had a hard disc failure on an Areca 1680 RAID controller, RAID 6.
> I checked the firmware and the last available version is already
> installed.

Did you check your disks are compatible? Areca's 1680 is pretty hard=20
about disks firmware, we've had bad behaviour if drive+firmware were not=20
in the support list.

If disks are compatible, and one broke, it could well be it behaved very=20
bad and wrote different things than it read back. If you rebuilt your=20
raid, let it check again to confirm it's good now. We've had that error=20
once... finally we rebuilt the whole damn raid from scratch.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1992814.b16DN3StYD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk6lmG4ACgkQzhSR9xwSCbTFjQCfWobhHZM3d9ERfzgGvmTYcFU+
a1kAmwfnhyzVJ6H0ZhsfvPukbe8SleTv
=UEka
-----END PGP SIGNATURE-----

--nextPart1992814.b16DN3StYD--


--===============0144367649400439054==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0144367649400439054==--
