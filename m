Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1PA1Vip198672
	for <linux-xfs@oss.sgi.com>; Wed, 25 Feb 2009 04:01:32 -0600
Received: from amanpulo.fs3.ph (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 10C8519A70B0
	for <linux-xfs@oss.sgi.com>; Wed, 25 Feb 2009 02:00:59 -0800 (PST)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [202.81.162.101]) by
	cuda.sgi.com with ESMTP id 7pNYx5BFU69GDkli for
	<linux-xfs@oss.sgi.com>; Wed, 25 Feb 2009 02:00:59 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 5DB673031823D
	for <linux-xfs@oss.sgi.com>; Wed, 25 Feb 2009 18:00:56 +0800 (PHT)
Received: from amanpulo.fs3.ph ([127.0.0.1])
	by localhost (amanpulo.fs3.ph [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id 7pxLBmfUQVgc for <linux-xfs@oss.sgi.com>;
	Wed, 25 Feb 2009 18:00:56 +0800 (PHT)
Received: from [10.37.1.117] (unknown [10.37.1.117])
	(using SSLv3 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by amanpulo.fs3.ph (Postfix) with ESMTP id EAB3A30317947
	for <linux-xfs@oss.sgi.com>; Wed, 25 Feb 2009 18:00:55 +0800 (PHT)
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
From: Federico Sevilla III <jijo@fs3.ph>
In-Reply-To: <20090224224636.GF26138@disturbed>
References: <1235480661.17293.28.camel@disciplina.fs3.ph>
	<20090224224636.GF26138@disturbed>
Date: Wed, 25 Feb 2009 18:00:51 +0800
Message-Id: <1235556051.17569.4.camel@disciplina.fs3.ph>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1259320596917856552=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux XFS <linux-xfs@oss.sgi.com>


--===============1259320596917856552==
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+6h+eZ9RJAnSfFqG2PNj"


--=-+6h+eZ9RJAnSfFqG2PNj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-25 at 09:46 +1100, Dave Chinner wrote:
> On Tue, Feb 24, 2009 at 09:04:21PM +0800, Federico Sevilla III wrote:
> > Hi,
> >=20
> > Recently, we had two file servers crash during periods of increased loa=
d
> > (increased access from workstations in the LAN). After the crash, the
> > XFS file systems would no longer mount. The mount process would just
> > stay in state D, with no progress, and no significant disk activity.
>=20
> What was the cause of the crash?

The engineers on site were unable to copy the exact error message, but
whatever could be read of a photograph of the screen seems to point to
similar issues with xfs_trans_read_buf error 5 as we're beginning to see
now.

We are unsure of the cause of the crash but know that the system load
was higher than usual because of some larger files that people were busy
working on at the time.

> >         attempt to access beyond end of device
> >         sda7: rw=3D0, want=3D154858897362229008, limit=3D3885978852
> >         I/O error in filesystem ("sda7") meta-data dev sda7 block 0x226=
2b58bf959708       ("xfs_trans_read_buf") error 5 buf count 4096
>=20
> A corrupted extent pointer of some kind. xfs_repair should have
> found this. Can you run xfs_repair again? If it doesn't find
> anything, please upgrade xfs_repair to the latest version and
> try again.

Will do, and will revert to the list again with the results.

> > Both servers use CentOS5 with the Linux 2.6.18-92.1.22.el5 kernel. For
>=20
> Oh. XFS is not really supported on that platform because it is pretty muc=
h
> completely untested on RHEL based kernels.

What would be the "community endorsed" approach to using our favorite
file system on CentOS 5? Would you recommend we go with the CentOSPlus
kernels instead?

Thank you very much.

Cheers!

--=20
Federico Sevilla III
F S 3 Consulting Inc.
http://www.fs3.ph

--=-+6h+eZ9RJAnSfFqG2PNj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJpRbT5rCBSJO3Rr4RAv+TAJ9M+ULxSLb3TdG2dGkwXuEXZfOkbgCeOVqG
JOf8oiBjEZU6T2jXPahgrzA=
=fLWb
-----END PGP SIGNATURE-----

--=-+6h+eZ9RJAnSfFqG2PNj--


--===============1259320596917856552==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1259320596917856552==--
