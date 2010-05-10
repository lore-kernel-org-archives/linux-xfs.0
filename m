Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AMbBvL036568 for <xfs@oss.sgi.com>; Mon, 10 May 2010 17:37:11 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED56F120F227
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 15:39:42 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id rt6H5p7ED9DT8hiI for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 15:39:42 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id B924E800186
	for <xfs@oss.sgi.com>; Tue, 11 May 2010 00:39:19 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 2F4AE83C823
	for <xfs@oss.sgi.com>; Tue, 11 May 2010 00:39:19 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_fsr question for improvement
Date: Tue, 11 May 2010 00:39:00 +0200
References: <201004161043.11243@zmi.at> <201005030849.47591@zmi.at>
	<20100503121716.GF2591@dastard>
In-Reply-To: <20100503121716.GF2591@dastard>
MIME-Version: 1.0
Message-Id: <201005110039.18561@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7024874387172342112=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7024874387172342112==
Content-Type: multipart/signed;
  boundary="nextPart4697389.uZdSOWQasN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4697389.uZdSOWQasN
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 3. Mai 2010 Dave Chinner wrote:
> Many have. Find and tar have resisted attempts to optimise them over
> the years, so stuff like this:
>=20
> http://oss.oracle.com/~mason/acp/
> grows on the interwebs all over the place... ;)

Uh, that makes a nice 3818 IOPS with 161MB/s:
xvdb              3818,16    0,80 161449,90    35,13    84,57    10,75   =20
2,30   0,26  99,88
And even saw >4kIOPS an 180MB/s. Nice.

The tool gave me an idea:
lvchange -r 1024 /dev/all_my_lvm_stores

And this boots copy performance a lot: With the default "-r 128" I had=20
around 10-30MB/s, now 30-100MB/s. Of course this depends on the type of=20
access and so on, but at least during moving back all the data from the=20
backup lvm to the re-created original lvm it's a drastic speedup.

> > # time find /mountpoint/ -inum 107901420
> > real    0m30.113s
> > user    0m0.540s
> > sys     0m9.813s
> >
> > Caching helps the 2nd time :-)
>=20
> That still seems rather slow traversing 750,000 cached directory
> entries. My laptop (1.3GHz CULV core2 CPU) does 465,000 directory
> entries in:
>=20
> $ time sudo find / -mount -inum 123809285
>=20
> real    0m2.196s
> user    0m0.384s
> sys     0m1.464s

So why was it so slow here?
As soon as moving back all data is finished, I can retry if search speed=20
increased.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart4697389.uZdSOWQasN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvoixYACgkQzhSR9xwSCbQ1fQCeJDFHy1vxRI/lGqd/3F1K2hHd
UA0An0plJ8UlMsJ7iuMSHhl4Ixg3OkaJ
=mujS
-----END PGP SIGNATURE-----

--nextPart4697389.uZdSOWQasN--


--===============7024874387172342112==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7024874387172342112==--
