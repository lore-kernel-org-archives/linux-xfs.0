Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 955357F88
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2015 00:48:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 843618F8066
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2015 22:48:34 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qTfvJVjrcTrpPgFZ for <xfs@oss.sgi.com>;
	Tue, 09 Jun 2015 22:48:28 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1Z2YsD-0000SL-Ez
	for xfs@oss.sgi.com; Wed, 10 Jun 2015 15:48:25 +1000
Date: Wed, 10 Jun 2015 15:48:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v3.2.3 released
Message-ID: <20150610054825.GU9143@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1368332606976230540=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1368332606976230540==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

xfsprogs v3.2.3 has just been released. This is mainly a bugfix
release (see below for a summary). There is a notable change in
defaults for mkfs.xfs - it will now make CRC enabled filesystems by
default, and you will need to use "mkfs.xfs -m crc=3D0" to make
filesystems compatible with production kernels older than 3.15.

The source code can be accessed via git using either of these URLs:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
git://oss.sgi.com/xfs/cmds/xfsprogs.git

and the release is tagged with the "v3.2.3" tag to make it easy to
check out the exact source used for the release.

A signed gzipped-tar archive of the source code is available
here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.3.tar.gz
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.3.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

Problems, issues, questions and general discussion about the release
should be directed to the XFS mailing list (xfs@oss.sgi.com).

A summary of the changes during development of this release (taken
=66rom doc/CHANGES) is as follows:

- Debian packaging updates (Nathan Scott)
- xfs_repair: handle speciall atribute names correctly (Eric Sandeen)
- xfs_repair: handle v5 format feature flags correctly (Darrick Wong)
- xfs_repair: Better v5 format validation for directories
  (Darrick Wong)
- mkfs.xfs: enable metadata CRCs by default
- mkfs.xfs: enable free inode btrees by default
- build: glibc support updates (Jan Tulak)
- man page updates (Sage Weil, Namjae Jeon, Eric Sandeen)
- xfs_admin: Changing UUIDs disable for CRC enabled filesystems
  (Eric Sandeen)
- xfs_repair: Separate pquota inode fixes (Brian Foster)
- xfs_db: inode alignment fixes (Brian Foster)
- mkfs.xfs: fix failures creating file images (Brian Foster)
- libxfs: zero new buffers before use (Darrick J. Wong)
- xfs_repair: handle directory leaf CRC errors gracefully
  (Darrick J.  Wong)
- xfs_repair: validate and repair inode CRCs (Eric Sandeen)
- xfs_repair: lots of broken directory repair fixes (Eric Sandeen)
- xfs_db: handle v3 inodes properly (Eric Sandeen)
- xfs_db: allow writing corrupted metadata on CRC enabled filesystems
  (Eric Sandeen)
- xfs_repair: gracefully handle > 512 byte sector superblocks
- mkfs.xfs: take into acocunt log stripe unit when sizing log
- xfs_metadump: inode alignment and null inode fixes (Brian Foster)
- xfs_io: FALLOC_FL_INSERT_RANGE support (Namjae Jeon)
- build: libtool static library build fixes (Romain Naour)
- mkfs.xfs: large block size inode alignment fixes (Brian Foster)
- xfs_repair: secondary superblock scan fixes (Brian Foster)
- xfs_repair: don't care about symlink compenent lengths
  (Eric Sandeen)

--=20
Dave Chinner
david@fromorbit.com

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVd8+oAAoJEK3oKUf0dfodO8oP/R7b1xQ0GkZ3V4TyF7F6+bP8
sa6CneNSpGZbNUWU5buCVESdUJU9TQOFB6l7LcBhvmFZ2Vy8FNahgEwVBoPC6FoN
or/MytBzdGfkb8IqdRzIQRc6YA3Wr9jXZ5I0+0VgiyifBI9o6kMOEEZoLnCEUjAZ
c2CkehiFCPbqBQRBuVD+k7h4boNkImVMWWTsoaCpIQwC4QdaHbtHuqYdv5UfocvF
/GhjkJ0lefmFskZ1w8Zo+9DJ+57hEqm0vFTR0R1JqrWIRpim9J83U+HVX3bbgnTi
CDYIRgeTCoBN1CU57u3GkfIWNy94Axxe+3JICHOmLB9r1K5/RmV5X56EjbOakGv6
trv9+4Ly/zpckW18/Sn60l+RD9+H3ALNdJgiCD8h7edLLmqE/tFOIQbvo+P1Qpkc
Lp3CsVHcf9ICLiZOevljoal84kEY3eakjJh6eqLtMR8gdxfRBHLvCU4LNoR3+dpn
x9iq1ixdP4wQWggu505JpcIFGQq8aqy5TYadyO3jOIduSYjwyt+CxO0VsXLvgwhx
wxrQTQYsY4BBao44IDvGvn9oB5mj8H3NJx9bJFRptul3LrM+rh47ncoaHEvM9TRh
qdPIF2PgA+gzT6btzo/uI3lYYxdJ3OI/LbecJi3qV6I5Gm0QyU7Vc8qa/gF0Olms
btQBkWzlcSrn0LaAY7gX
=FMX5
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--


--===============1368332606976230540==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1368332606976230540==--
