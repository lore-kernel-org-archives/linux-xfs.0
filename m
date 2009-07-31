Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6V97hWx142309 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 04:07:45 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF18A257F0B
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 02:08:28 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id qDNNp6UVE9QIQva3 for
	<xfs@oss.sgi.com>; Fri, 31 Jul 2009 02:08:28 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs i/O error
Date: Fri, 31 Jul 2009 11:08:22 +0200
References: <24747808.post@talk.nabble.com> <200907310148.52085@zmi.at>
	<4A726711.5050402@sandeen.net>
In-Reply-To: <4A726711.5050402@sandeen.net>
MIME-Version: 1.0
Message-Id: <200907311108.26491@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9193136171524622491=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, rnb <neil.bell@gmail.com>

--===============9193136171524622491==
Content-Type: multipart/signed;
  boundary="nextPart5457195.0b0NmLEpmg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5457195.0b0NmLEpmg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Freitag 31 Juli 2009 Eric Sandeen wrote:
> Read errors can be somewhat recoverable, if you write to that sector
> it will remap if it can.

Yes, but I've never seen a disk who did not get other broken sectors=20
later. When a disk starts to get bad sectors, others will come, just=20
like a virus. Therefore: you get a bad sector -> replace disk. That's by=20
far less pain and cheaper than the other scenario.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart5457195.0b0NmLEpmg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpytIoACgkQzhSR9xwSCbQVvQCeJJbsSsFcsiP9dyrjlqvL5AIJ
58kAoIHIYJwP14t4HeCL73kq4GZFCnKT
=0eBu
-----END PGP SIGNATURE-----

--nextPart5457195.0b0NmLEpmg--


--===============9193136171524622491==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9193136171524622491==--
