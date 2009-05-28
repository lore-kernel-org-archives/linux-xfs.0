Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4S9BLVh245283 for <xfs@oss.sgi.com>; Thu, 28 May 2009 04:11:22 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6A631A34785
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 02:11:33 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id CIclS4VzUa1tIJPn for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 02:11:33 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 9102E53DC
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 11:11:32 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 4D04940DC06
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 11:11:32 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH 7/9] Set default extN mount options
Date: Thu, 28 May 2009 11:11:31 +0200
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-8-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1243450413-12681-8-git-send-email-sandeen@sandeen.net>
MIME-Version: 1.0
Message-Id: <200905281111.32011@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5582885400185823877=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5582885400185823877==
Content-Type: multipart/signed;
  boundary="nextPart9966471.OB3AKUy6Pd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart9966471.OB3AKUy6Pd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch 27 Mai 2009 Eric Sandeen wrote:
> ext2/3/4 don't support acls & attrs w/o specific mount
> options, so make those the default whenever we mount
> these filesystems.

The same for reiserfs, but I don't know if that is wanted/needed.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart9966471.OB3AKUy6Pd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkoeVUQACgkQzhSR9xwSCbQifwCgzIMLdRqSVuOvPW0aPaSbnZtw
OlgAn3VFhAw/7WmTS6SaHum2vpi3kfNb
=LT19
-----END PGP SIGNATURE-----

--nextPart9966471.OB3AKUy6Pd--


--===============5582885400185823877==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5582885400185823877==--
