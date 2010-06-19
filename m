Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5J8R5al262088 for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 03:27:05 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5F3003E79B7
	for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 01:29:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id RmwlCwO6GW7hdNF0 for
	<xfs@oss.sgi.com>; Sat, 19 Jun 2010 01:29:41 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 10F8F17A
	for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 10:29:40 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id C666583C829
	for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 10:29:23 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Help with XFS
Date: Sat, 19 Jun 2010 10:29:39 +0200
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
	<201006181843.01755@zmi.at>
	<20100618185223.60119f36@harpe.intellique.com>
In-Reply-To: <20100618185223.60119f36@harpe.intellique.com>
MIME-Version: 1.0
Message-Id: <201006191029.39306@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5386415245663821694=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5386415245663821694==
Content-Type: multipart/signed;
  boundary="nextPart1396635.YvYnXYTL9n";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1396635.YvYnXYTL9n
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Freitag, 18. Juni 2010 Emmanuel Florac wrote:
> > You have the money for a IBM DS4700 (costs with disk >15.000=E2=82=AC),=
 but
> > not for 4 cheap 2TB SATA disks to at least copy the data there?
> > That would have cost <500=E2=82=AC.
>=20
> This isn't very helpful. Advice to everyone : read the tao of backup
> ( http://www.taobackup.com ). Old, funny and still right on.
=20
I didn't say it's a backup solution. It's the simplest form of keeping=20
data, and would have helped here.=20

We tend to do backup-to-disk and then disk-to-tape, which until now is=20
superior to just backup-to-tape. It speeds up backup and restore time,=20
even when "just" using simple 2TB SATA drives (in RAID-5 arrays). The=20
following disk-to-tape runs without any start/stop cycles of the tape=20
(mostly LTO4 now), leading to much longer tape and tape drive lifetimes=20
than before.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1396635.YvYnXYTL9n
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwcf/MACgkQzhSR9xwSCbQU8wCgrXbepOaIzmbxvewy3bx9C9OM
YjcAn1zwQMbqjU16K0kN6azfCEozYsjO
=Ig6/
-----END PGP SIGNATURE-----

--nextPart1396635.YvYnXYTL9n--


--===============5386415245663821694==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5386415245663821694==--
