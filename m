Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0HBI8FV151791 for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 05:18:08 -0600
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id EV5iELB6HW88tCid for
	<xfs@oss.sgi.com>; Tue, 17 Jan 2012 03:18:05 -0800 (PST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp4-g21.free.fr (Postfix) with ESMTP id D760F4C81DF
	for <xfs@oss.sgi.com>; Tue, 17 Jan 2012 12:18:00 +0100 (CET)
Date: Tue, 17 Jan 2012 12:17:49 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Optimal XFS formatting options?
Message-ID: <20120117121749.347122b1@harpe.intellique.com>
In-Reply-To: <201201171019.58714@zmi.at>
References: <33140169.post@talk.nabble.com> <20120116231121.GB6922@dastard>
	<4F14EBAF.10808@hardwarefreak.com> <201201171019.58714@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0702125118290407062=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0702125118290407062==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/jqtkFdZbn=wXwex0xwIdbI."; protocol="application/pgp-signature"

--Sig_/jqtkFdZbn=wXwex0xwIdbI.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Tue, 17 Jan 2012 10:19:55 +0100
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> - expand array by factors of two. So if you have 10 data drives, add
> 10 data drives. But that creates other problems (probability of
> single drive failure + time to recover a single broken disk)

=46rom my experience 20 drives is OK for RAID-6. And rebuild time doesn't
change much with array size, anyway.

Misaligned partitions, on the other hand, can easily halve array
throughput from my own measurements.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/jqtkFdZbn=wXwex0xwIdbI.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk8VWN4ACgkQX3jQXNUicVaaLQCg6YnSPq2B//biMLpF/1gf4OrV
cCsAn2fNwVg2Ltms910vos0Hwwo1tb8t
=3RMQ
-----END PGP SIGNATURE-----

--Sig_/jqtkFdZbn=wXwex0xwIdbI.--


--===============0702125118290407062==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0702125118290407062==--
