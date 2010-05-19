Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JBiMvF126061 for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:44:22 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5E0C359D43
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 04:46:40 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id EWAt5XD7WJYTzzO9 for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 04:46:40 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: rsync from xfs to nfs+xfs and ACL problems
Date: Wed, 19 May 2010 13:46:38 +0200
References: <201005181350.15308@zmi.at> <201005191304.42314@zmi.at>
	<20100519112034.GA29064@infradead.org>
In-Reply-To: <20100519112034.GA29064@infradead.org>
MIME-Version: 1.0
Message-Id: <201005191346.38699@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5136552703720770437=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

--===============5136552703720770437==
Content-Type: multipart/signed;
  boundary="nextPart14486152.hTmOFNolno";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart14486152.hTmOFNolno
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 19. Mai 2010 Christoph Hellwig wrote:
> XFS stores ACLs different than other Linux filesystems because it's
> on-disk compatible to IRIX.  While the other filesystems store the
>  ACL in the same format that is used for the user interface XFS
>  stores it in a separate trusted extended attribute.  rsync should
>  and
> traditionally has ignored those attributes, but it seems something in
> rsync changed recently so that it tries to copy these attributes in
> the trusted.* namespace, which fails on NFS.
=20
Thank you. Does that mean I can simply ignore that errors, and that=20
everything is OK even over NFS?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart14486152.hTmOFNolno
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvzz54ACgkQzhSR9xwSCbToYACfZCfVVotIH8DOuhe5/3OfPWXl
deIAoOXNiBlN0UBJQ5N7JnK7mFiFNDrM
=xRXb
-----END PGP SIGNATURE-----

--nextPart14486152.hTmOFNolno--


--===============5136552703720770437==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5136552703720770437==--
