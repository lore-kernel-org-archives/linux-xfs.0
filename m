Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o437d3RT140627 for <xfs@oss.sgi.com>; Mon, 3 May 2010 02:39:03 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2767C3074EE
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 00:41:09 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 3PEIhcojGMXEqJsH for
	<xfs@oss.sgi.com>; Mon, 03 May 2010 00:41:09 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 05734800112
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 09:41:08 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id A6F1883C823
	for <xfs@oss.sgi.com>; Mon,  3 May 2010 09:41:07 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_fsr question for improvement
Date: Mon, 3 May 2010 09:41:06 +0200
References: <201004161043.11243@zmi.at> <20100417012415.GE2493@dastard>
	<201005030849.47591@zmi.at>
In-Reply-To: <201005030849.47591@zmi.at>
MIME-Version: 1.0
Message-Id: <201005030941.07109@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3995949306097392346=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3995949306097392346==
Content-Type: multipart/signed;
  boundary="nextPart2279591.YjFnkzqt7e";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2279591.YjFnkzqt7e
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Montag, 3. Mai 2010 Michael Monnerie wrote:
> When I created that XFS, I took two 2TB partitions, did pvcreate,
> vgcreate and lvcreate. Could it be that lvcreate automatically
>  thought it should do a RAID-0? Because all reads are equally split
>  between the two volumes. After a while, I added the 3rd 2TB volume,
>  and I can't see that behaviour there. So maybe this is the source of
>  all evil.

I found that lvcreate really is too smart:
       -i, --stripes Stripes
              Gives the number of stripes.  This is equal to the number=20
of physical volumes to scatter the logical volume.

So it seems lvcreate did know that the VG was split among 2 "disks", and=20
therefore used -i2 while I wanted -i1.

> reldiratime

Should be nodiratime, of course.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2279591.YjFnkzqt7e
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvefhMACgkQzhSR9xwSCbQKcQCfSDUqQ+GXWWECSu7Y9CYUOTTn
c3cAnRl5Q9y0xbtZ9KaUKQIQc976+mFO
=Wm7W
-----END PGP SIGNATURE-----

--nextPart2279591.YjFnkzqt7e--


--===============3995949306097392346==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3995949306097392346==--
