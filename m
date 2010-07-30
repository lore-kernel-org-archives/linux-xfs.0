Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o58H2BSJ015187 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 12:02:11 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 776FF480A81
	for <xfs@oss.sgi.com>; Thu, 29 Jul 2010 17:40:02 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id DToYAQJVNIiq6aua for
	<xfs@oss.sgi.com>; Thu, 29 Jul 2010 17:40:02 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: filesystem shrinks after using xfs_repair
Date: Fri, 30 Jul 2010 02:39:55 +0200
References: <F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100729230147.GN655@dastard>
	<04349CE2-CF8B-463C-8B06-5E4E59E869B2@ucsc.edu>
In-Reply-To: <04349CE2-CF8B-463C-8B06-5E4E59E869B2@ucsc.edu>
MIME-Version: 1.0
Message-Id: <201007300239.59574@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1795755423305684290=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eli Morris <ermorris@ucsc.edu>

--===============1795755423305684290==
Content-Type: multipart/signed;
  boundary="nextPart1720842.L9Ubu44vQO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1720842.L9Ubu44vQO
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 30. Juli 2010 Eli Morris wrote:
> Is that something I could do now, or only when the filesystem is
>  created? If I mount it with '-o inode64', can I mount it without
>  that later, or once I write to the filesystem like that, can I not
>  go back to mounting it in 32 bit mode?=20
=20
Once you mount with inode64, you can't go back.

I'm not sure which applications are "broken", but I use inode64 for a=20
backup server where lots of Linux boxes connect to over NFS, and a Samba=20
for Windows PCs which has inode64, and at least didn't see any problem=20
over the years. That doesn't mean there isn't a problem, of course ;-)

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1720842.L9Ubu44vQO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxSH18ACgkQzhSR9xwSCbTx9ACgxEv5/D1aNj5EhphOQ30ST+e1
iX4An2sW95zH6USiJLvNZws8lRJn7ZGe
=ar5P
-----END PGP SIGNATURE-----

--nextPart1720842.L9Ubu44vQO--


--===============1795755423305684290==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1795755423305684290==--
