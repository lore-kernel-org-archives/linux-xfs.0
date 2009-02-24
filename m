Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OF6LAw150192 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 09:06:22 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86C691994BC7
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:05:51 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id uzARaMq2v0gdpyLB for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:05:51 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: xfsprogs/xfsdump release process
Date: Tue, 24 Feb 2009 10:05:48 -0500
References: <200902221348.51905.vapier@gentoo.org>
	<200902221539.26143.vapier@gentoo.org>
In-Reply-To: <200902221539.26143.vapier@gentoo.org>
MIME-Version: 1.0
Message-Id: <200902241005.49414.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6225238398943948862=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============6225238398943948862==
Content-Type: multipart/signed;
  boundary="nextPart2515353.JvuoFKJtNU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2515353.JvuoFKJtNU
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 22 February 2009 15:39:25 Mike Frysinger wrote:
> On Sunday 22 February 2009 13:48:49 Mike Frysinger wrote:
> > how are release tarballs created ?  seems like there's an error in the
> > process as the dmapi-2.2.9 contains files it shouldnt.  for example,
> > autom4te.cache/, include/builddefs, etc...
>
> in a similar vain, every xfsdump/xfsprogs release has made people run
> `autoconf` first as the configure script is considered part of the
> distclean target in general.  i dont think that makes any sense as the
> configure script should be included with every release tarball.

so how are release tarballs made ?  i dont see a "dist" target or anything ...
-mike

--nextPart2515353.JvuoFKJtNU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJpAzNAAoJEEFjO5/oN/WBsQgQALC2X+88rO0UmzyE8sEtU4A+
Hl4tT41bwIicxxGrqVKvvMLCkf9EuDh0T4t4IpFZ87NnnnvOpunO3cZ8zn/7kXPY
5aTCMOEfJ9fDYyh8h1rGWqUW2nYQKbaWjBpC73PrY9ntJljUZKhtca/F78hlpYeX
Ahq2rpglx22k6gd+4/vh0m50rxyn6IAyGt7JH7/Bd2S7uLkI/FWl4hL+g55l4IRr
P23xJ57UvjxdHitrQAbvUT2bI6J8UtWtJqDdnVueTeSjJJCatfypyVEIfmjLsa5D
tGilJc9YlI24xLKbt/EKTuRzkyN+eeV2zaW3junAv5xIXkN2Sf9ow+xEbUzoRCNZ
mG+6dBZunr8eIbnr9+ZFazS/DbhhgbM9wQkEtC7Rj7A+8Zy2STbBZ/+C/NpuGckJ
Lm3dLU3QaahYn6kpVwp89/kxrk3aLoumYAValqnY+usUlNT3bjnPUoxIamO41Iym
2UybX+NPESdsYxqzWH09BZrzXPMaGJMtunidKlJiqg2cQhqdATivFYR89Eg/YCRU
DBCqRSVE/vkjXQ+azzpqX3wOtqTx4CLMTV4w6DWvMNcj4SfmodgzAq//4Ol9oziZ
1DXEzIUD6xdHNxJ+Qx4y9Qc0tO9Bb2zI9GVU6pt9rlJ7sjeb4JjZYem9k7ofRITS
ms+P5nGpQtjQEtZT2zIv
=rFNQ
-----END PGP SIGNATURE-----

--nextPart2515353.JvuoFKJtNU--


--===============6225238398943948862==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6225238398943948862==--
