Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1MKdxUR062854 for <xfs@oss.sgi.com>; Sun, 22 Feb 2009 14:40:00 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6ACC13EF3E
	for <xfs@oss.sgi.com>; Sun, 22 Feb 2009 12:39:27 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id ao15ThI6efrQSmlB for
	<xfs@oss.sgi.com>; Sun, 22 Feb 2009 12:39:27 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: xfsprogs/xfsdump release process
Date: Sun, 22 Feb 2009 15:39:25 -0500
References: <200902221348.51905.vapier@gentoo.org>
In-Reply-To: <200902221348.51905.vapier@gentoo.org>
MIME-Version: 1.0
Message-Id: <200902221539.26143.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5814408495418424219=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============5814408495418424219==
Content-Type: multipart/signed;
  boundary="nextPart2551234.SIliL9oXyZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2551234.SIliL9oXyZ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 22 February 2009 13:48:49 Mike Frysinger wrote:
> how are release tarballs created ?  seems like there's an error in the
> process as the dmapi-2.2.9 contains files it shouldnt.  for example,
> autom4te.cache/, include/builddefs, etc...

in a similar vain, every xfsdump/xfsprogs release has made people run=20
`autoconf` first as the configure script is considered part of the distclea=
n=20
target in general.  i dont think that makes any sense as the configure scri=
pt=20
should be included with every release tarball.
=2Dmike

--nextPart2551234.SIliL9oXyZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJobf+AAoJEEFjO5/oN/WBkLAQANFv1hdvisCagBY7DsYFXqz5
h4LlWhVIN8c9dv2W/aFvNqXvlkzj7GFp4LJPjQ7pxeyeiwtJ/UBHiI6L5bDiSD3n
8Nc83ESyz8DXeqkoVi30i7hdX1BqsQb98hq6Emd7ywu7Qs2ExFHB7eVTyOLZstQ2
dGkZHGUW6qukzLfF6dNuFp5BX+DkjuFJIcRnF+9tPXExhqfx/M626LxcJPMCCCcI
hQQ2/868UAdJE5TK3oLNTahh7nRooY3jCgUFPIzFfZ0zk6/EhGE+rZtxR/+AldAP
iXZTKYQR1M11NiqWSrN/0J6yONhhCKlgrHAsdrhHWKHHDvKIRafbJJ24ZUc/osIa
39aXH0Vl2bLXDnkuj0rVNQipRBEA6gG8J6X1rZpyxpw7fKbjde0a5ztX2INBmeSU
o3k+BMKn5GbXHXGVDf959vFqF4YAsfHmUkYPGyksYuklPVW3pG47r8vQivz1T6qO
3aoRo4THJ+SjjDO9oevxM8RhbZ3MyEdECSrwM/UQjxzRolDzBptFojpWqUSg2Wz4
MLkyQFTMCT1rjJR0wesHt5JmQUG0a/uwfhQVoi/JdU8/YPto2wpzBqrSRrgvem39
7koeBYkzXDtDMTHhUQeab709beNYK0tq3O6mCfjYQpmR7YybAtQSJ54lOoECF6LD
NOQigqSR/k0ipquVcvi6
=Ys3X
-----END PGP SIGNATURE-----

--nextPart2551234.SIliL9oXyZ--


--===============5814408495418424219==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5814408495418424219==--
