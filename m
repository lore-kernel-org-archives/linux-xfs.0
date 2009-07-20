Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KBLgfa077352 for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 06:21:42 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09851371CFD
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 04:22:23 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id Tk1QTmb3BIOmF0BW for
	<xfs@oss.sgi.com>; Mon, 20 Jul 2009 04:22:23 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 2DBF44DAF
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:22:55 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 907CC40017E
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:22:22 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: data switchs su,sw and sunit,swidth
Date: Mon, 20 Jul 2009 13:22:21 +0200
References: <4A626EC5.3090100@tlinx.org>
In-Reply-To: <4A626EC5.3090100@tlinx.org>
MIME-Version: 1.0
Message-Id: <200907201322.22102@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8260629242487193609=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8260629242487193609==
Content-Type: multipart/signed;
  boundary="nextPart2080549.len0J7tyI9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2080549.len0J7tyI9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sonntag 19 Juli 2009 Linda Walsh wrote:
> Then, for RAID 1 (mirror) would 'sw'=3D=3D1? =A0Would setting the =A0su/sw
> =A0value for a RAID 1 actually matter in any way? =A0Ie, technically --
> it would fill in numbers for OS book-keeping, but wouldn't change
> anything in terms of performance or layout, vs. 'physically' -- where
> it could change disk layout or performance?
>
> At RAID 0, I'd guess =A0sw=3D=3D2?

Both RAID0 and RAID1 use sw=3D0.

> In RAID 5, would it be =A0 sw =A0=3D=3D #Disks-1? =A0So even w/6 disks, it
> still only uses 1 disk for parity and =A0sw =3D=3D 5?

RAID5: sw =3D #Disks-1 ( so with 8 disks use 7)
RAID6: sw =3D #Disks-2 ( so with 8 disks use 6)

> I wonder what becomes a max-safe RAID 5 size? (or is the number of
> parity disks a settable option with RAID 5?)

RAID5 always only has 1 parity disk (well, technically it's not a=20
physical disk, but the parity is distributed over all disks in the=20
array).
Don't know what you mean by "max-safe" size. The more disks you have,=20
the bigger the chance that a single disk breaks. Also, I tested with=20
Areca controllers, using more than 7 disks in a single RAID array=20
doesn't improve speed anymore. So I use RAID-6 for up to 8 disks, and=20
make it RAID-60 for up to 16 disks (with Areca controllers).

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2080549.len0J7tyI9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpkU24ACgkQzhSR9xwSCbRBHQCdFEiFEEdfQy3ZZ7CfZnTdGF79
lWMAnjDSVCEHFxd3K0cSGqRLCne1H60n
=jLpb
-----END PGP SIGNATURE-----

--nextPart2080549.len0J7tyI9--


--===============8260629242487193609==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8260629242487193609==--
