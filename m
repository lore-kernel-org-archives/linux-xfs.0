Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNHGOcP208777 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:16:24 -0600
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36F5921C147
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 09:18:22 -0800 (PST)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id FmQ3gYy3G1scnkzr
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 09:18:22 -0800 (PST)
Received: by bwg12 with SMTP id 12so751221bwg.26
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 09:18:21 -0800 (PST)
Message-ID: <4D138457.8020008@gmail.com>
Date: Thu, 23 Dec 2010 18:18:15 +0100
From: Honza Fikar <j.fikar@gmail.com>
MIME-Version: 1.0
Subject: Re: no rw xfs file systems in mtab: /proc/mounts
References: <AANLkTi=Xes02L3XfZvUu6Yh2yi2FR8GtpVdOGzngVjJk@mail.gmail.com>
	<4D13648B.8000105@sandeen.net>
In-Reply-To: <4D13648B.8000105@sandeen.net>
Reply-To: j.fikar@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5686293171516499897=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============5686293171516499897==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAB09642F972D4CDE6BA7CCED"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAB09642F972D4CDE6BA7CCED
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

> hm that's a little confusing, what it means is it looked
> in /proc/mounts and did not find anything, or so it thought.

I agree that it's confusing, while there are xfs mounted rw in /proc/moun=
ts

> As a result of:
>=20
> 89e4b5bd5615edc584a5111c86f12b4f89f8dd7d xfs_fsr: use /proc/mounts if a=
vailable

I "quickly and dirty" tried to use /etc/mtab instead, but the result is
the same. Even tried some old version (3.0.3), which uses mtab and it's
the same.


> What does your /proc/mounts show?

it shows the lines included in the original e-mail, just here it is
wrapped, i.e. for the not working case:

>> ...
>> /dev/mapper/root / xfs
>> rw,noatime,attr2,inode64,logbufs=3D8,logbsize=3D256k,noquota 0 0
>> ...

and for working case:

>> ...
>> /dev/root / xfs
>> rw,noatime,attr2,delaylog,inode64,logbufs=3D8,logbsize=3D256k,noquota =
0 0
>> /dev/mapper/encrypted /home xfs
>> rw,noatime,attr2,delaylog,inode64,logbufs=3D8,logbsize=3D256k,sunit=3D=
512,swidth=3D1536,noquota
>> 0 0
>> ...

Honza


--------------enigAB09642F972D4CDE6BA7CCED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0ThFoACgkQp4S3GwoQQ3tFAwCeNk5Z7wYGto9EDUIV+bKtOrvP
2ZkAoMNbpAFK4Lg9XlFyC88t+6jpAORJ
=xqkA
-----END PGP SIGNATURE-----

--------------enigAB09642F972D4CDE6BA7CCED--


--===============5686293171516499897==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5686293171516499897==--
