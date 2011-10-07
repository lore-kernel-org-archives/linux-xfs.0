Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97BeTpD235047 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 06:40:30 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EA45B1B57FF
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 04:40:27 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id OeoA520HVd16XMZ3 for
	<xfs@oss.sgi.com>; Fri, 07 Oct 2011 04:40:27 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 05ABE50F
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 13:40:26 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id C7EDFC000AD
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 13:40:25 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Premature "No Space left on device" on XFS
Date: Fri, 7 Oct 2011 13:40:24 +0200
References: <4E8E079B.4040103@birkenwald.de> <20111007013711.GW3159@dastard>
In-Reply-To: <20111007013711.GW3159@dastard>
MIME-Version: 1.0
Message-Id: <201110071340.25077@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0629516026172576743=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0629516026172576743==
Content-Type: multipart/signed;
  boundary="nextPart2489273.u4P8trB9CX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2489273.u4P8trB9CX
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 7. Oktober 2011 Dave Chinner wrote:
> And with 1.7 million inodes in it. That's a lot for a tiny
> filesystem, and not really a use case that XFS is well suited to.
> XFS will work, but it won't age gracefully under these conditions...

But which FS would fit better for that? We have similar usages, so I'm=20
curious.

> As it is, your problem is most likely fragmented free space (an
> aging problem). Inodes are allocated in chunks of 64, so require an
> -aligned- contiguous 16k extent for the default 256 byte inode size.
> If you have no aligned contiguous 16k extents free then inode
> allocation will fail.

Would this be a use case for the "noikeep" mount option?

When would be the time XFS drops inode clusters that are already empty,=20
when I use noikeep on an aged XFS with lots of such unused inode=20
allocations?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart2489273.u4P8trB9CX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk6O5SkACgkQzhSR9xwSCbQp1gCfYFb5FHXbz5PeQDT2kjtvi+oq
fvcAoPWQBclX6r3Gb07Y/7t35fRWm/DU
=cOYU
-----END PGP SIGNATURE-----

--nextPart2489273.u4P8trB9CX--


--===============0629516026172576743==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0629516026172576743==--
