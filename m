Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7U7tmYI254837 for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 02:55:49 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82624D6C0ED
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 01:06:46 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 3DemFydPCzYEY8L4 for
	<xfs@oss.sgi.com>; Mon, 30 Aug 2010 01:06:46 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 1BC9512D
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 09:56:22 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id BBF48401C2E
	for <xfs@oss.sgi.com>; Mon, 30 Aug 2010 09:56:21 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: 4K drives, sectsz=512, bsize=4096
Date: Mon, 30 Aug 2010 09:56:16 +0200
MIME-Version: 1.0
Message-Id: <201008300956.21264@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3274737005483079433=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3274737005483079433==
Content-Type: multipart/signed;
  boundary="nextPart3248334.JWiSvKbyU8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3248334.JWiSvKbyU8
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I have 2x 2TB 4K sector drives, joined with LVM to RAID-0. On top of=20
that, I created an XFS, but that has sectsz=3D512.

Will there be any real difference if I re-format with sectsz=3D4096?=20
AFAIK, XFS will do I/O based on block size, so the sector size doesn't=20
do any harm. Is that correct?

A question for LVM: Is there anything I need to tell to LVM to let it=20
know that those are 4K sector drives and I/O should be aligned to that?=20
Drives are reported as 512b sectors, but really are 4K. There seems to=20
be no way to instruct the kernel to see those drives as 4K drives.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3248334.JWiSvKbyU8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx7ZCUACgkQzhSR9xwSCbS18QCgxgMlCRj1cG9NPe8Fxnlsi9oi
0bIAoNjONDr0LJagn7EfNgwmCEvZQIuL
=rlfv
-----END PGP SIGNATURE-----

--nextPart3248334.JWiSvKbyU8--


--===============3274737005483079433==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3274737005483079433==--
