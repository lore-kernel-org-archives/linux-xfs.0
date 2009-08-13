Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DNmK4a058481 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:48:35 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6D0D3CA6D8
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 16:48:33 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id Qv5qpoPAuME6kLlI for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 16:48:33 -0700 (PDT)
Received: from mailsrv.i.zmi.at (unknown [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 45AD2498A
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 01:48:29 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 4782D400174
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2009 01:48:29 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Resizing XFS on GPT partition
Date: Fri, 14 Aug 2009 01:48:24 +0200
MIME-Version: 1.0
Message-Id: <200908140148.28810@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3275122478182594527=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3275122478182594527==
Content-Type: multipart/signed;
  boundary="nextPart1331764.dXdeGpVVYs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1331764.dXdeGpVVYs
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I've had a XEN VM with a 90GB disk, increased it to 250GB.
Then I had the problem that I used GPT partitioning, meaning only=20
"parted" being usable. parted doesn't support resizing partitions for=20
xfs and refuses to do it.

The simple thing is to delete and recreate with bigger size that=20
partition. Later mount the partition and run xfs_growfs.

I don't understand why parted doesn't support that, just resizing the=20
partition and not refusing it. :-(

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1331764.dXdeGpVVYs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkqEpkwACgkQzhSR9xwSCbRpmQCdEgQkRTpNxGQx3YpOWyuMueUV
UZYAn10KKeRTwEHxBairGgbuTSuHozQC
=Kr4N
-----END PGP SIGNATURE-----

--nextPart1331764.dXdeGpVVYs--


--===============3275122478182594527==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3275122478182594527==--
