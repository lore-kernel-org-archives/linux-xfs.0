Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o865mLN0157755 for <xfs@oss.sgi.com>; Mon, 6 Sep 2010 00:48:22 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2A18D91858
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 23:00:03 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id t7oD8LEupgmwiVn7 for
	<xfs@oss.sgi.com>; Sun, 05 Sep 2010 23:00:03 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 6036012D
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 07:49:02 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 2AE07401C2E
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 07:49:02 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
Date: Mon, 6 Sep 2010 07:49:00 +0200
References: <20100902145959.GA27887@infradead.org>
	<20100905104739.GC27623@1wt.eu> <20100905130809.GI705@dastard>
In-Reply-To: <20100905130809.GI705@dastard>
MIME-Version: 1.0
Message-Id: <201009060749.01405@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1478691721023739018=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1478691721023739018==
Content-Type: multipart/signed;
  boundary="nextPart1347244.n8PFJfZFbu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1347244.n8PFJfZFbu
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I looked into man mkfs now, which brings up these questions:

On Sonntag, 5. September 2010 Dave Chinner wrote:
>         - relatime,logbufs=3D8,attr=3D2,barrier are all defaults.

Why isn't logbsize=3D256k default, when it's suggested most of the time=20
anyway? On machines with 32MiB or more 32k is the default, but most=20
machines these days have multi-gigabytes of RAM, so at least for=20
RAM>1GiB that could be made default.

>         - largeio only affects stat(2) output if you have
>           sunit/swidth set - unlikely on a laptop drive, and has
>           no effect on unlink performance.
>         - swalloc only affects allocation if sunit/swidth are set
>           and has no effect on unlink performance.

Hm, it seems I don't understand that. I tried now on different servers,=20
using
stat -f /disks/db --format '%s %S'
4096 4096

That filesystems were all created with su=3D64k,swidth=3D(values 4-8=20
depending on RAID). So I retried specifying directly in the mount=20
options: sunit=3D128,swidth=3D512
and it still reports "4096" for %s - or is %s not the value I should=20
look for? Some of the filesystems even have allocsize=3D specified, still=20
always 4096 is given back. Where is my problem?

And while I am at it: Why does "mount" not provide the su=3D/sw=3D options=
=20
that we can use to create a filesystem? Would make life easier, as it's=20
much easier to read su=3D64k,sw=3D7 than sunit=3D128,swidth=3D896.

When I defined su/sw on mkfs, is it enough, or would I always have to=20
specify sunit/swidth with every mount too?

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

--nextPart1347244.n8PFJfZFbu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyEgM0ACgkQzhSR9xwSCbSJxACZARBP0nSjTXPUEFIlAdPhgP6w
X3sAn2nKCQvlfwTxz4BqVLeENsk6i8oA
=46Of
-----END PGP SIGNATURE-----

--nextPart1347244.n8PFJfZFbu--


--===============1478691721023739018==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1478691721023739018==--
