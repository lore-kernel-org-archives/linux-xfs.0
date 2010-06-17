Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5HFCmei181517 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 10:12:49 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EAFE51E1062B
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 08:15:25 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id XkXMfbFA1G5d1pau for
	<xfs@oss.sgi.com>; Thu, 17 Jun 2010 08:15:25 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 9DB9017A
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 17:15:23 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 650BD83C829
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 17:15:10 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Help with XFS
Date: Thu, 17 Jun 2010 17:15:22 +0200
References: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
In-Reply-To: <OF4967B99D.609CC213-ONC1257745.0048E646-C1257745.004919A3@bergenofs.no>
MIME-Version: 1.0
Message-Id: <201006171715.22933@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3868615489052227906=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3868615489052227906==
Content-Type: multipart/signed;
  boundary="nextPart10146408.0gHbBgKp89";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart10146408.0gHbBgKp89
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 17. Juni 2010 Thomas F=C3=B8rde wrote:
> when i try to mount the XFS filesystem of 10TB, my 7.8 TB of data is
>  now  gone.
=20
Do you have any logs in /var/log/warn about errors before that crash?
How long had that machine been up?
What kernel version?
How many files/dirs have there been?

I'm not a dev, but I guess running xfs_metadump, zipping the outcome and=20
putting it on a website would be a good preparation.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart10146408.0gHbBgKp89
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwaPAoACgkQzhSR9xwSCbTZNwCeN2NaJIPsZ0OTfb57SPhCJHeL
ZI4AoJwBkxWWQMG4RQ5PXYVlKJG+49bF
=h4JM
-----END PGP SIGNATURE-----

--nextPart10146408.0gHbBgKp89--


--===============3868615489052227906==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3868615489052227906==--
