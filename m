Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6ODlT7r130957 for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 08:47:29 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0DAD10B86C1
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 06:56:35 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id MZ7nEBXKulfXCBXf for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2009 06:56:35 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 63ECE53F0
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 15:48:36 +0200 (CEST)
Received: from saturn.localnet (unknown [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 57AB9400166
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2009 15:48:10 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: umount xfs filesystem
Date: Fri, 24 Jul 2009 15:48:09 +0200
References: <4A66C5E7.7050408@readytec.it>
	<bzytz12kztx.fsf@fransum.emea.sgi.com>
In-Reply-To: <bzytz12kztx.fsf@fransum.emea.sgi.com>
MIME-Version: 1.0
Message-Id: <200907241548.09961@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5696817931328506463=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5696817931328506463==
Content-Type: multipart/signed;
  boundary="nextPart1457420.WZiSFGVdXm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1457420.WZiSFGVdXm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Freitag 24 Juli 2009 Olaf Weber wrote:
> On unmount the system has flush all dirty data to disk. =A0Depending on
> the amount of data in memory, this might take a while.
>
> I'm not claiming this is definitely the case here, but it is an
> obvious candidate.

The OP should try
sync
umount
then he could see if sync takes long or umount

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1457420.WZiSFGVdXm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkppu5kACgkQzhSR9xwSCbRe8QCfaCxwYhaQtqP+1+7O0/k1JLLu
y7UAoMBa/LxC7+r9uTTR5dTHrqMhBHM4
=Cdqm
-----END PGP SIGNATURE-----

--nextPart1457420.WZiSFGVdXm--


--===============5696817931328506463==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5696817931328506463==--
