Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4U8rM6g089221 for <xfs@oss.sgi.com>; Sun, 30 May 2010 03:53:22 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 88F67384C23
	for <xfs@oss.sgi.com>; Sun, 30 May 2010 01:55:45 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id RmMA4DeVARUT5EJE for
	<xfs@oss.sgi.com>; Sun, 30 May 2010 01:55:45 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 43CA4800184
	for <xfs@oss.sgi.com>; Sun, 30 May 2010 10:55:44 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id F3DC883C825
	for <xfs@oss.sgi.com>; Sun, 30 May 2010 10:55:43 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: puzzling error: XenServer, LVM and XFS
Date: Sun, 30 May 2010 10:55:43 +0200
References: <201005270857.39048@zmi.at> <20100527115153.GB13112@infradead.org>
In-Reply-To: <20100527115153.GB13112@infradead.org>
MIME-Version: 1.0
Message-Id: <201005301055.43430@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8313823174340020454=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8313823174340020454==
Content-Type: multipart/signed;
  boundary="nextPart1719874.pVEGPVWJrK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1719874.pVEGPVWJrK
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 27. Mai 2010 Christoph Hellwig wrote:
> This looks like the Xen block device code is buggy and doesn't handle
> the I/O pattern XFS throws at it.  A sector 0 error during mount
>  usually is the superblock barrier test write.  To verify that
>  assumptions try mounting the XFS filesystems with -o nobarrier and
>  see if it goes away.  Note that this is only for testing, and I
>  would not recommend it for production use.  If it makes the error go
>  away please file a bug with the Xen guys to fix their barrier
>  support by either implementing it properly or not advertizing it.
=20
You're right! As this does not happen with normal partitions but only=20
LVM volumes, there must be some problem in the combination of XenServer,=20
LVM and XFS.
There is nothing I can do to report this to Citrix, at least I didn't=20
find a bug report facility for that, so it won't be fixed but now we=20
know it.
This was XenServer 5.5

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1719874.pVEGPVWJrK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwCKA8ACgkQzhSR9xwSCbTt6ACgopcSvsRgHRiG4ojF3tU4TvlY
P3sAn00WqWwuNyQuyjwDKVBxBDSBsFTM
=KyR2
-----END PGP SIGNATURE-----

--nextPart1719874.pVEGPVWJrK--


--===============8313823174340020454==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8313823174340020454==--
