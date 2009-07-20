Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KBDYPc075583 for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 06:13:34 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D177A9A1DA
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 04:22:17 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id CVFdk9CFZITtvwQd for
	<xfs@oss.sgi.com>; Mon, 20 Jul 2009 04:22:17 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id A6CAA4DAF
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:14:42 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 14F9440017E
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 13:14:10 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: does XFS support block sizes other than 512 bytes?
Date: Mon, 20 Jul 2009 13:14:09 +0200
References: <4A6119B5.6000706@tlinx.org>
In-Reply-To: <4A6119B5.6000706@tlinx.org>
MIME-Version: 1.0
Message-Id: <200907201314.09615@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6572752258791627075=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6572752258791627075==
Content-Type: multipart/signed;
  boundary="nextPart2412106.dS2Xou9ea9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2412106.dS2Xou9ea9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Samstag 18 Juli 2009 Linda A. Walsh wrote:
> This one's a bit more specific than the last. =A0If memory serves me,
> XFS supported differing block sizes (which you could do on a hardware
> format of a SCSI drive) back on IRIX. =A0But when first ported to Linux
> it didn't work. =A0Was that ever fixed? =A0I seem to remember that going
> to 1-2K block sizes gave and extra 10%, and it almost seems logical
> that going to a 4kK block size would be ideal for xfs (presuming your
> disk doesn't start getting errors, then it might get harder to remap
> sectors and you'd hit hard disk failure (w/o remappable sectors)
> sooner.
>
> But at least 1K might be a reasonable tradeoff? =A0Been quite a while
> since I tried it and don't even know if the SAS drives allow it (if
> they do, I wonder if the newer SATA drives do?)

XFS can only use sector sizes that the hard disks provide. There will be=20
4K drives from vendors "soon", and XFS is prepared to use that.=20

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2412106.dS2Xou9ea9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpkUYEACgkQzhSR9xwSCbRGagCg9WRCoLYWP3tgm0aAfjhdoKPX
1uEAoIHDy5vkl1cWj2ROwcblaZXonml3
=V2bs
-----END PGP SIGNATURE-----

--nextPart2412106.dS2Xou9ea9--


--===============6572752258791627075==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6572752258791627075==--
