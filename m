Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 10 Dec 2006 08:47:42 -0800 (PST)
Received: from deliver.uni-koblenz.de (deliver.uni-koblenz.de [141.26.64.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBAGlZqw017349
	for <linux-xfs@oss.sgi.com>; Sun, 10 Dec 2006 08:47:36 -0800
Received: from localhost (localhost [127.0.0.1])
	by deliver.uni-koblenz.de (Postfix) with ESMTP id AEC50B93FAC
	for <linux-xfs@oss.sgi.com>; Sun, 10 Dec 2006 17:21:06 +0100 (CET)
Received: from deliver.uni-koblenz.de ([127.0.0.1])
 by localhost (deliver [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 25138-07 for <linux-xfs@oss.sgi.com>;
 Sun, 10 Dec 2006 17:21:04 +0100 (CET)
Received: from robotnik.home.krienke.org (C6c87.c.strato-dslnet.de [62.104.108.135])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by deliver.uni-koblenz.de (Postfix) with ESMTP id 916BAB92110
	for <linux-xfs@oss.sgi.com>; Sun, 10 Dec 2006 17:21:04 +0100 (CET)
From: Rainer Krienke <krienke@uni-koblenz.de>
Subject: Hints to create the optimal xfs filesystem
Date: Sun, 10 Dec 2006 17:20:53 +0100
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2252995.ph6jNzc5xy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200612101720.58144.krienke@uni-koblenz.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

--nextPart2252995.ph6jNzc5xy
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I am running a fileserver with SuSE SLES10 on it that has a 5TB RAID6 devic=
e=20
attached to it. The RAID has 1GB cache memory (battery backed up). Ob this=
=20
raid device I use EVMS to manage the space available. There will be several=
=20
evms volumes with xfs on them on this raid and I ask myself if there are an=
y=20
hints how to create the optimal filesystem with high read and write=20
performace. Or is it sufficient to stay with the defaults mkfs.xfs provides?

The filesystem have a size that range from 50GB to 500GB and mostly contain=
=20
user home directories, i.e. they will probably contain a lot of small files.

One point I think about is if it would make sense to create the xfs=20
filesystems using an external logging device. Does anyone have experience i=
n=20
this? How big should the log be compared to the filesystem? Is it possible =
to=20
change the loggining mode of an existing XFS filesystem from internal to an=
=20
external device without recreating (destroying) it?

Can anyone comment on this?

Thanks
Rainer Krienke
--=20
---------------------------------------------------------------------------
Rainer Krienke, Universitaet Koblenz, Rechenzentrum, Raum A022
Universitaetsstrasse 1, 56070 Koblenz, Tel: +49 261287 -1312, Fax: -1001312
Mail: krienke@uni-koblenz.de, Web: http://www.uni-koblenz.de/~krienke
Get my public PGP key: http://www.uni-koblenz.de/~krienke/mypgp.html
---------------------------------------------------------------------------

--nextPart2252995.ph6jNzc5xy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBFfDPqaldtjc/KDEoRAslIAKDJN87goaBT259ZYz9VIydJc90/tgCfctOW
n/JdxpiTxe8h5mH2qghpLQ4=
=ZM4d
-----END PGP SIGNATURE-----

--nextPart2252995.ph6jNzc5xy--
