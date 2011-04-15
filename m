Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3F67vh0046611 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 01:07:57 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 00B943E2DAD
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2011 23:11:19 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with SMTP id 1l0K3KtdzT4Wbc3b for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2011 23:11:19 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs stack overrun, unable to handle kernel paging request
Date: Fri, 15 Apr 2011 08:11:16 +0200
References: <201104150631.38169@zmi.at> <20110415060202.GA32250@infradead.org>
In-Reply-To: <20110415060202.GA32250@infradead.org>
MIME-Version: 1.0
Message-Id: <201104150811.16971@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0566340530967614172=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

--===============0566340530967614172==
Content-Type: multipart/signed;
  boundary="nextPart10266128.UHaBj3bTHM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart10266128.UHaBj3bTHM
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 15. April 2011 Christoph Hellwig wrote:
> That's still without the commits I pointed out to avoid direct
> reclaim hitting the filesystem, right?  Unfortunately the stack
> trace is truncate so it's not possible to spot where it originated,
> but I suspect it's the cause for this one as well.

Yes, it's an older server that's going to be replaced by OpenSUSE 11.4=20
anyway. And this crash is seldom enough that I am not urged to update=20
all our servers.
I think I copied all the lines that were visible. I was wondering why=20
the output was so short.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart10266128.UHaBj3bTHM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk2n4YQACgkQzhSR9xwSCbRUdACfdMzpTEN9l7riH2aHkW8/CtPb
mbMAnitFzRDv0Pr6E68Ye7LGENuKwuPR
=GYSv
-----END PGP SIGNATURE-----

--nextPart10266128.UHaBj3bTHM--


--===============0566340530967614172==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0566340530967614172==--
