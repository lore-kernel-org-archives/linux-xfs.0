Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Mar 2008 01:50:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2K8ob8n009866
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 01:50:40 -0700
Received: from deliver.uni-koblenz.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AABB4B8F103
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 01:51:09 -0700 (PDT)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15]) by cuda.sgi.com with ESMTP id 0WRW50IBdGDv5BuA for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 01:51:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by deliver.uni-koblenz.de (Postfix) with ESMTP id 4D0287855789
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 09:51:09 +0100 (CET)
Received: from bliss.uni-koblenz.de (bliss.uni-koblenz.de [141.26.64.65])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by deliver.uni-koblenz.de (Postfix) with ESMTP id EDC84785578B
	for <xfs@oss.sgi.com>; Thu, 20 Mar 2008 09:51:07 +0100 (CET)
From: Rainer Krienke <krienke@uni-koblenz.de>
Subject: xfs_repair sometimes hangs during repair
Date: Thu, 20 Mar 2008 09:51:03 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2834985.ULnozQbeu3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803200951.07238.krienke@uni-koblenz.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--nextPart2834985.ULnozQbeu3
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

lately I had a problem with a xfs filesystem on a Novell SLES10 SP1 system.=
 I=20
tried to repair the fs using xfs_repair (V2.9.7) but this did not work.=20
xfs_repair failes with an out of memory error. The machine has 6GB of RAM b=
ut=20
is a 32 bit machine and I guess it limits one process to 3GB memory. At lea=
st=20
xfs_repair died when its virtual size was about 3GB. The filesystem is 360G=
B=20
in size and had 6.9 million inodes on it.

This problem is well documented and I got an advice to set the -o=20
bhash=3D<value> in the xfs_repair call.  This basically worked however it=
=20
rquired a lot of trial an error which is not what you want if you need to g=
et=20
your filesystem back online as soon as possible.

In betwenn I created a test filesystem 360GB with 120million inodes on it.=
=20
xfs_repair without options is unable to complete. If I run xfs_repair -o=20
bhash=3D8192 the repair process terminates normally (the filesystem is actu=
ally=20
ok).=20=20

The problem is that if I specify smaller values for bhash, xfs_repair will =
not=20
issue any error or warning or out of memory message but it won't terminate=
=20
either. At some point sometimes in Phase3 sometimes in Phase6 it simply=20
hangs. In this state xfs_repair uses 100% CPU and does no longer access the=
=20
disk with the filesystem to be raired as reported by iostat -d.

This is not really good, because each try to run xfs_repair takes about 90=
=20
minutes until you finally find out, that it does not work (xfs_repair is=20
hanging) and you have to restart xfs_repair using a larger bhash value.=20

Actually I would expect xfs_repair to issue an error or perhaps there shoul=
d=20
at least be some guidlines on how to set bhash depending on the size of the=
=20
filesystem.

Are there any hints on how to set a minimal bhash value for a given filesys=
tem=20
or is there another way to get a larger fs checked on a 32 bit machine?

Thanks in advance
Rainer=20=20
--=20
Rainer Krienke, Uni Koblenz, Rechenzentrum, A22, Universitaetsstrasse  1
56070 Koblenz, http://www.uni-koblenz.de/~krienke, Tel: +49261287 1312
PGP: http://www.uni-koblenz.de/~krienke/mypgp.html,Fax: +49261287 1001312

--nextPart2834985.ULnozQbeu3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBH4iV7aldtjc/KDEoRAtbmAKD7O+LyqtUG1Tz5919MKi7JZX2r9wCeNqT7
8Lob6qFRyObmVB5Ie5BBcOA=
=NYNS
-----END PGP SIGNATURE-----

--nextPart2834985.ULnozQbeu3--
