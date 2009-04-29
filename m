Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3T4SOsU145216 for <xfs@oss.sgi.com>; Tue, 28 Apr 2009 23:28:24 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 215C824AA59
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2009 21:28:22 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id VCAyXtVTIYWwuatQ for
	<xfs@oss.sgi.com>; Tue, 28 Apr 2009 21:28:22 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217107103.dyn.cm.kabsi.at
	[81.217.107.103])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 6DBE553C7
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 06:28:22 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 8C84340017B
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 06:28:21 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair Input/output error
Date: Wed, 29 Apr 2009 06:28:16 +0200
References: <ff2243530904282040i1bb2cf12v3a329b045edf2f50@mail.gmail.com>
In-Reply-To: <ff2243530904282040i1bb2cf12v3a329b045edf2f50@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200904290628.20924@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7513553217805091747=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7513553217805091747==
Content-Type: multipart/signed;
  boundary="nextPart2291964.UTdqCAq2Qg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2291964.UTdqCAq2Qg
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch 29 April 2009 Cory Coager wrote:
> When attempting to mount the partition the drive makes some funny
> noises and these messages spit out on the console:
>
> hda: dma_intr: status=3D0x51 { DriveReady SeekComplete Error }
> hda: dma_intr: error=3D0x40 { UncorrectableError }, LBAsect=3D268552872,
> high=3D16, low=3D117416, sector=3D268552868
> ide: failed opcode was: unknown
> end_request: I/O error, dev hda, sector 268552868

This is definitely your drive gone bad.

> I believe the drive is fine because check_ide_smart reports:

If the drive "makes funny noises" and I/O errors are logged, it has bad=20
sectors. Try with
# smartctl -a /dev/sda
and look for a line like this:
5 Reallocated_Sector_Ct 0x0033 100 100 036 Pre-fail Always  -  0

If the last number is >0, your drive has problems - replace it!

=46or a full SMART check, please try:
smartctl --smart=3Don --offlineauto=3Don --saveauto=3Don --test=3Dlong /dev=
/sda

This tells your drive to make a long selftest. It prints the estimated=20
time for the test to run (usually 1-3h). Then check your smart values=20
again. You should try to not use your drive during this time.

> I can xxd and dd this partition without getting any console errors.=20

It is possible the drive remapped the bad sectors itself.

> I can also mount the partition with -o ro,norecovery.  How do I repair
> this and recover my data?

Plug in new drive.
Boot from recovery cd
dd if=3D/dev/sda of=3D/dev/sdb=20
remove old drive
xfs_repair
enjoy

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart2291964.UTdqCAq2Qg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkn312QACgkQzhSR9xwSCbT+3ACeKSP5IOT3Fszjqn/XR1k0bLl2
ZrkAoKRI3d09rq/HtzK+2bP+yDxynhDG
=amuQ
-----END PGP SIGNATURE-----

--nextPart2291964.UTdqCAq2Qg--


--===============7513553217805091747==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7513553217805091747==--
