Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4A31ltk145715 for <xfs@oss.sgi.com>; Wed, 9 May 2012 22:01:48 -0500
Received: from members.tip.net.au (haggis.pcug.org.au [203.10.76.10]) by
	cuda.sgi.com with ESMTP id hDPO141foNogMJs3 for
	<xfs@oss.sgi.com>; Wed, 09 May 2012 20:01:46 -0700 (PDT)
Date: Thu, 10 May 2012 13:01:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the xfs tree
Message-Id: <20120510130134.0efffc5ba1f3a80c614e8f29@canb.auug.org.au>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6376107270270123688=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, David Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org

--===============6376107270270123688==
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_May_2012_13_01_34_+1000_FPATsqTDsb/I5Meq"

--Signature=_Thu__10_May_2012_13_01_34_+1000_FPATsqTDsb/I5Meq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".xfs_extent_busy_trim" [fs/xfs/xfs.ko] undefined!

Caused by commit e459df5b5b93 ("xfs: move busy extent handling to it's
own file") (and aided by 425dcd6c2289 "xfs: clean up busy extent naming").

I have used the xfs tree from next-20120508 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_May_2012_13_01_34_+1000_FPATsqTDsb/I5Meq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPqy+OAAoJEECxmPOUX5FEg74QAJVF0uhoISzQGp4g9eRqPPNG
R+FBKOkg0mFwSJz0LoOke7jM+xrvaYm9qGSVXXJkvp1kl0H0Q+H9If1fnaRKrWHh
ttVWh2RN7FmhvLjDcr+iLJqj4e/sZTfDPlcEb1n1w9P0zV/lIZl3ly6PJT4TbzJ8
kLUGtUwHIKW4BD0GQ4SVppHp10El5Hdlr5iAH8ZuUM0IL6H6oEsZowD2iNWXJu07
OThDTpGQd3MutBtJto/ahXSUmDXLVIF/ZtyAWWXrrDEZZrAef0SYoANRUih8tJyd
HaAFMKW2u22/5tWZxcA5xuSJFYKzWr1i2Y7l7MEiGTS+JW87kgz1XcykLLY1t4zk
4RtkEEif+Rq9fHtASTPWyep68K1xYJaczH63G3/aiAPqMI5H0QHr81m1rWglE/hy
9u+kS3tDMJWQmkGJrCwiWsc/zSWXh1rbuJ5j3FWdCPqiiOuPYusLM256H8AO9I+4
mcUkeGhYT2IjsD5MwFlvSEnOhyELRWIvL6HYwvObZOMtBkhMRRfOByvwasAuw/mV
rP3l+/MfzL1KHjzCPgD8ZAGd1wcFTr30+PvL6libBi4YWjujrpXocrvrEZe0YYEB
pFEVUrENqFmq6Irnq9J2JPf/ygLB3nYvLkbqk8i5mJ8taCcEH+SXhAQ4N71BKeQ7
yhZy1IC1IZwgh2/hWQuh
=QHex
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2012_13_01_34_+1000_FPATsqTDsb/I5Meq--


--===============6376107270270123688==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6376107270270123688==--
