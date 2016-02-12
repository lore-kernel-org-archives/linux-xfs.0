Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67E337CA2
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 21:34:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DE26BAC003
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 19:33:57 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7rSGHO35uWyy6iMP for <xfs@oss.sgi.com>;
	Thu, 11 Feb 2016 19:33:53 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1aU4Ta-0001tU-QU
	for xfs@oss.sgi.com; Fri, 12 Feb 2016 14:32:58 +1100
Date: Fri, 12 Feb 2016 14:32:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 1b9fecf
Message-ID: <20160212033258.GN19486@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5036899805406533667=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5036899805406533667==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated. This contains all the current development,
and will be the basis of the upcoming 4.5 release. Still pending is
a user/kernel libxfs sync, so there will still be a few changes to
come from that before a 4.5-rc1 is tagged.

-Dave.

The new head of the master branch is commit:

1b9fecf libxfs: reset dirty buffer priority on lookup

New Commits:

Carlos Maiolino (1):
      [feb3d9c] include: Minor whitespace cleanup

Darrick J. Wong (4):
      [9a5fc88] libxfs: move struct xfs_attr_shortform to xfs_da_format.h
      [bcb416e] xfs_io: print dedupe errors to stderr, not stdout
      [00d5042] xfs_io: detect the '-R' option in getopt
      [e50c637] mkfs: factor finobt changes into min log size when formatti=
ng

Dave Chinner (10):
      [a7302f8] metadump: clean up btree block region zeroing
      [6058426] metadump: bounds check btree block regions being zeroed
      [c1c3d92] xfs_mdrestore: correctly account bytes read
      [e161d4a] repair: parallelise phase 7
      [8100dd7] repair: parallelise uncertin inode processing in phase 3
      [4280e59] libxfs: directory node splitting does not have an extra blo=
ck
      [0a7942b] libxfs: don't discard dirty buffers
      [e8f1e8a] libxfs: don't repeatedly shake unwritable buffers
      [aef29e1] libxfs: keep unflushable buffers off the cache MRUs
      [1b9fecf] libxfs: reset dirty buffer priority on lookup

Eric Sandeen (8):
      [11202ec] libxfs: don't pass negative errnos to strerror()
      [513fc42] xfs_quota: define Q_XGETNEXTQUOTA
      [cc15c8c] xfs_quota: make report_mount() & dump_file() take an "outpu=
t id"
      [6a9a085] xfs_quota: use Q_XGETNEXTQUOTA for report and dump
      [75005bf] mkfs.xfs.8: Clarify mkfs vs. mount block size limits.
      [add8ff6] xfs_repair: Fix untranslatable strings
      [d1fe6ff] xfs_quota: remove extra 30 seconds from time limit reporting
      [75f7058] xfs_quota: fix up timer command help

Felix Janda (3):
      [0e2fb84] xfs_fsr: Include <paths.h> for _PATH_MOUNTED
      [cb898f1] linux.h: Use off64_t instead of loff_t
      [7c66b2f] include/linux.h: Include <stdio.h> for fprintf and stderr

Joshua Kinard (2):
      [0caa2ba] configure: remove aio.h check
      [ad0a1e9] xfs_copy: use POSIX signal API


Code Diffstat:

 configure.ac              |   6 +--
 copy/xfs_copy.c           |  16 ++++--
 db/metadump.c             |  93 +++++++++++++++++++++--------------
 fsr/xfs_fsr.c             |   1 +
 include/cache.h           |  17 +++++--
 include/linux.h           |   3 +-
 include/xqm.h             |  11 +++--
 io/pwrite.c               |   2 +-
 io/reflink.c              |   6 ++-
 libxfs/cache.c            |  97 ++++++++++++++++++++++++++++--------
 libxfs/rdwr.c             |  75 ++++++++++++++++------------
 libxfs/xfs_attr_sf.h      |  16 ------
 libxfs/xfs_da_btree.c     |  59 +++++++++++-----------
 libxfs/xfs_da_format.h    |  16 ++++++
 libxfs/xfs_inode_fork.c   |   1 +
 m4/Makefile               |   1 -
 m4/package_aiodev.m4      |  36 --------------
 man/man8/mkfs.xfs.8       |   5 +-
 mdrestore/xfs_mdrestore.c |   4 +-
 mkfs/maxtrres.c           |   5 +-
 mkfs/xfs_mkfs.c           |   2 +-
 mkfs/xfs_mkfs.h           |   2 +-
 quota/edit.c              |   4 +-
 quota/linux.c             |   2 +
 quota/quota.h             |   3 ++
 quota/report.c            | 122 ++++++++++++++++++++++++++++++++++++------=
----
 quota/util.c              |   2 -
 repair/phase3.c           |  59 ++++++++++++++++++----
 repair/phase7.c           |  75 ++++++++++++++++++----------
 repair/progress.c         |   4 +-
 repair/protos.h           |   4 +-
 repair/versions.c         |  13 +++--
 repair/xfs_repair.c       |   4 +-
 33 files changed, 495 insertions(+), 271 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWvVJqAAoJEK3oKUf0dfodnW8P/AuE9Zjv5obHnMPVG0BNPhlZ
vVRLe82hyMQ7d1CYyw7YKopXnoT5rTuRTS5sfuc8lBVzxKcjWKpAIHnuA8borwd7
sPFoob5mVbAYzvRE8cixJslj42FNm6vU9x3eswz/VPrzjmy6AXxyY1TXreludXak
c20LGx4mMH1QK2BXSh/b+FtbAzbmPnucD08unnP6xVMgPMwkTXQX1AVUadrvbNSj
GORDuuyGsvmU4JhWvuse11BZCgagvX+c2D5dcXNOHsJ6dxHiAT0g4SeppEAaVwLs
8hQsefUuqnxvGWbEnxqn4DiRhnG1blNPsamTukFm6MHudcaG2tm+nkWFyYzmkVhl
QIxWnovlBlRZGoZy6k8IMljlbARXTnmKEplp8pOEurNOJYdm7Y13OG4tlpcdZD/J
JeUKn9nfEuv/8QOR5nhPNolTOt1h3zpjgdyRQCxy73aeyT3HDtHg16qxM567T8bV
a0RvUC5j5BB219gSv0QtP2p7XWc1lUSWyzlmSlvZHgBGILQNx+3MYStx1NbCFk78
yU1tUEZVhtKwLz2BiI4/zlMANXYqnfADMOAvhKIABYU/7M2zgkf/4rNuJN4ZWyLc
Opn15HNQalftb1YGTkeY0zBE96EkDk0TySqjN/2cqtXzh1YzoYg3OYlT7A2eUOaQ
Glqqy5mRSFYIrlyt3VM8
=GNJR
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--


--===============5036899805406533667==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5036899805406533667==--
