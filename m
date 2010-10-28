Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9S9hOAu006336 for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 04:43:24 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62B371C0622B
	for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 02:44:42 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id SZvZp18BXg7LitOU for
	<xfs@oss.sgi.com>; Thu, 28 Oct 2010 02:44:42 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS journaling position
Date: Thu, 28 Oct 2010 11:44:38 +0200
References: <31c7e56286d37870011c17ee8e002760.squirrel@webmail.ics.forth.gr>
	<alpine.DEB.1.10.1010271011510.27409@castor.opentrend.net>
	<alpine.DEB.1.10.1010271027511.27409@castor.opentrend.net>
In-Reply-To: <alpine.DEB.1.10.1010271027511.27409@castor.opentrend.net>
MIME-Version: 1.0
Message-Id: <201010281144.39307@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6469597216013599787=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Robert Brockway <robert@timetraveller.org>

--===============6469597216013599787==
Content-Type: multipart/signed;
  boundary="nextPart1470681.esQ7nSPqg7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1470681.esQ7nSPqg7
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 27. Oktober 2010 Robert Brockway wrote:
> Similarly virtual hosts have little chance of trying to establish
> the  physical nature of the device holding their filesystems.

Yes, performance optimizations will be fun in the near future. VMs, thin=20
provisioning, NetApps WAFL, LVM, funny disk layouts, all can do things=20
completely different than our "old school" thinking. I wonder when=20
there's gonna be an I/O scheduler that just elevates the I/O from a VM=20
to the real host, so that the host itself can optimize and align. After=20
all, a VM has no idea of the storage. That's why already now you can=20
choose "noop" as the scheduler in a VM. I guess there will be a=20
"virtualized" scheduler once, but we will see.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1470681.esQ7nSPqg7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzJRgcACgkQzhSR9xwSCbTAhACgkbLeYBhEqJSrQSnOfbPDY/0R
UyMAnikbyXdYqWWW273tPrhudb0L1SAl
=0bzX
-----END PGP SIGNATURE-----

--nextPart1470681.esQ7nSPqg7--


--===============6469597216013599787==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6469597216013599787==--
