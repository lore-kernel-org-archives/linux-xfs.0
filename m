Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o817jPi2115568 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 02:45:26 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A31B21348083
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 00:56:36 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 8Ek7jHu2u1qw5xgA for
	<xfs@oss.sgi.com>; Wed, 01 Sep 2010 00:56:36 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id DBD3417F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 09:46:01 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id A6541401C2F
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 09:46:01 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
Date: Wed, 1 Sep 2010 09:45:58 +0200
References: <201009010130.41500@zmi.at> <4C7DC21B.1040705@hardwarefreak.com>
	<20100901034156.GQ705@dastard>
In-Reply-To: <20100901034156.GQ705@dastard>
MIME-Version: 1.0
Message-Id: <201009010945.59204@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7607459603948428030=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7607459603948428030==
Content-Type: multipart/signed;
  boundary="nextPart3867035.TU2ypBMIjr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3867035.TU2ypBMIjr
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 1. September 2010 Dave Chinner wrote:
> Without delayed logging, 150MB/s is enough for a single threaded
> unlink to consume an entire CPU core on any modern CPU
=20
Just as Stan I'm puzzled by this. Why is it such a hard work for the=20
CPU, what does it do? Is it really about calculating something, or has=20
it to do with lock contention, cold caches, cache line bouncing and=20
other "horrible" things so the CPU can't get it's maximum power? I'm=20
really curious to understand that.

Maybe there should be an extra SSE4 assembler instruction "rm on XFS" so=20
we can delete files faster? ;-)

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

--nextPart3867035.TU2ypBMIjr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx+BLcACgkQzhSR9xwSCbSTCQCfah1m2Dz4K8AsHLePcdxIxQYl
zuoAnRCYly2Fm78UsZCyZtK2IeS7rLWM
=JWNC
-----END PGP SIGNATURE-----

--nextPart3867035.TU2ypBMIjr--


--===============7607459603948428030==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7607459603948428030==--
