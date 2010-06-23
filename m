Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5NF2HTT028277 for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 10:02:17 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1841515A283A
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 08:09:14 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id zHORR1eQNQKmIqLM for
	<xfs@oss.sgi.com>; Wed, 23 Jun 2010 08:09:14 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 3859917E
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 17:04:56 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 5FA7183C828
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 17:04:33 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS peculiar behavior
Date: Wed, 23 Jun 2010 17:04:55 +0200
References: <4C21B9AF.9010307@ics.forth.gr> <87bpb2avxg.fsf@basil.nowhere.org>
In-Reply-To: <87bpb2avxg.fsf@basil.nowhere.org>
MIME-Version: 1.0
Message-Id: <201006231704.55273@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3637249821368810517=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3637249821368810517==
Content-Type: multipart/signed;
  boundary="nextPart58065848.Qv27cxW9nv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart58065848.Qv27cxW9nv
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 23. Juni 2010 Andi Kleen wrote:
> I don't know if it's the only reason, but XFS does a lot of data
> structure locking and updates per allocation group, so spreading
> to multiple AGs gives better scalability to many CPUs.

This only helps if there are metadata operations, right? So in the case=20
where you have one big database "file" of 50GB, it should be ordered=20
sector-by-sector to get the maximum performance, and minimize disk-head=20
movement.
And I don't believe XFS would scatter a single big file around several=20
AGs, as far as I know even all files within the same dir are grouped=20
within a single AG. The AG "scattering" is done for separate dirs only.
=20
> Also I suppose it's good to avoid hot spots on the underlying=20
> device.

A database file is staying on the same place "forever" and will be=20
overwritten all the time, so it doesn't matter for the "hot spot" case.


=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart58065848.Qv27cxW9nv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwiIpcACgkQzhSR9xwSCbT1OwCcC5gjq/PQFCfsUTTTwUEDqn20
fGwAoOjEw63yGcXpOiiaHoZbE6lC0k9R
=Qi2/
-----END PGP SIGNATURE-----

--nextPart58065848.Qv27cxW9nv--


--===============3637249821368810517==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3637249821368810517==--
