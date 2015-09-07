Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E66507F4E
	for <xfs@oss.sgi.com>; Mon,  7 Sep 2015 00:26:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4795304039
	for <xfs@oss.sgi.com>; Sun,  6 Sep 2015 22:26:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	sHPwI6RAL2UMQz0t for <xfs@oss.sgi.com>;
	Sun, 06 Sep 2015 22:26:26 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZYowh-000655-Mf
	for xfs@oss.sgi.com; Mon, 07 Sep 2015 15:26:23 +1000
Date: Mon, 7 Sep 2015 15:26:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.2.0 released
Message-ID: <20150907052623.GE3902@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3770355245318954336=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3770355245318954336==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oPmsXEqKQNHCSXW7"
Content-Disposition: inline


--oPmsXEqKQNHCSXW7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The xfsprogs repositories have just been updated and tagged with the
v4.2.0 release tag. It can be found here:

git://oss.sgi.com/xfs/cmds/xfsprogs.git v4.2.0
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git v4.2.0

A signed gzipped-tar archive of the source code is available
here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.2.0.tar.gz
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.2.0.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

There has been a large amount of change since v3.2.4:

 297 files changed, 12703 insertions(+), 11987 deletions(-)

and so many thanks go out to all the contributors to this release
(in no particular order):

	Theodore Ts'o
	Roger Willcocks
	Mike Grant
	Lucas Stach
	Jan Tulak
	Jan Kara
	George Wang
	Eryu Guan
	Eric Sandeen
	Darrick J. Wong
	Christoph Hellwig
	Brian Foster

The main driver for the all this change has been to get the shared
libxfs code up to the same base as the released 4.2 kernel codebase
and to put tools and processes in place to easily maintain the
shared libxfs code base in future.

The numbering of this release should now be obvious - it matches the
version of the kernel that shares the same libxfs/ code. In future,
the major/minor release numbers for xfsprogs will follow the version
of the shared libxfs code. This makes it easy to work out what
version of xfsprogs supports the features of a given kernel - if the
xfsprogs version is the same or higher than the kernel version, then
it will support all the features of the kernel that is running.

Problems, issues, questions and general discussion about the release
should be directed to the XFS mailing list (xfs@oss.sgi.com).

-Dave.


The new head of the master branch is commit:

28f55cc xfsprogs: Release v4.2.0

New Commits since 4.2.0-rc3:

Brian Foster (1):
      [350f962] xfs_repair: update btree ptr when attr node level moves to =
next buffer

Darrick J. Wong (7):
      [7fc5180] libxfs: verifier should set buffer error when da block has =
a bad magic number
      [1f2ace6] libxfs: fix XFS_WANT_CORRUPTED_* macros to return negative =
error codes
      [e8ecd76] libxfs: clear buffer state flags in libxfs_getbuf and varia=
nts
      [aedb9c1] xfs_repair: ignore "repaired" flag after we decide to clear=
 xattr block
      [1c8e2f0] xfs_repair: check v5 filesystem attr block header sanity
      [43ba186] xfs_repair: force not-so-bad bmbt blocks back through the v=
erifier
      [f625305] xfs_repair: release corrupt directory node buffer

Dave Chinner (1):
      [28f55cc] xfsprogs: Release v4.2.0

Eric Sandeen (2):
      [fe0591e] xfs_repair: set args.geo in dir2_kill_block
      [a545950] xfs_repair: set args.geo in longform_dir2_entry_check_data

Lucas Stach (1):
      [f4a2ea0] progs: use CURDIR instead of relative paths for header syml=
inks


Code Diffstat:

 VERSION               |  2 +-
 configure.ac          |  2 +-
 debian/changelog      |  6 +++++
 doc/CHANGES           |  9 ++++++++
 include/Makefile      |  2 +-
 libxfs/Makefile       |  2 +-
 libxfs/libxfs_priv.h  |  7 +++---
 libxfs/rdwr.c         | 47 +++++++++++++++++++++++++++++++++-----
 libxfs/xfs_da_btree.c |  1 +
 repair/attr_repair.c  | 62 +++++++++++++++++++++++++++++++++++++++++++++++=
++--
 repair/dir2.c         |  1 +
 repair/phase6.c       |  2 ++
 repair/prefetch.c     | 12 ++++++++++
 13 files changed, 139 insertions(+), 16 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--oPmsXEqKQNHCSXW7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV7R//AAoJEK3oKUf0dfodRXAQAMBHwR6kaImDGqHfFFoO9eWH
RQtTyjT4tvFZWkqZ/LiwcDFuNk1nfG/1cSgvzJ0OdVfzcMgVH0sQCS/LQCMZn/Lo
a80bGiP1m40gjVjj+BpbGEj7aDlPEPrG6MOT0xBo2MUqg3HONB6EpqmbtfmYZVGL
dDtmeryUe+QuZzOcQ0ys92DLsf1VoMhn9wB8PnWqtCfCIe+lCNjNdeyxVkpciVij
9GrwufKQSUSTf7vsdzVwWHzwG37PNk13pBKlfoohe8aPGaSuPjsh3gHOF6VBDsQh
Wzci/m2SVrFLVjc/K3tOuH3mookmlqsrTL3sHESCA5Wsiqmdn8tn/PVNkPGRWj7r
lQGYJ6tzU+Q+Zjv41WmGVZ/0Us0uerMlTt2drbxsdnwAOWHlXK4lBMIqvKa3p5H7
p7LThhpbrgwrp+I2CROaOaBR3aRiVtiOLzNYEiDrg3ZT0WwUpfrhxeqBgVZg30KB
zokiXhyoL4YE67zJAlnJZB+hpAHO54uyt74Pa+P8eVQCd3xp662t7hEnKHi8q3Pn
I0ywVawM1g7/RN/lxbJ0Up0TLalJ9PeNh6msKKK9fjx+SLyaLJbdnMO6Z96joxZI
3OiSaRAZ+uxbYFEv/BKneSR1A1XV9wHpZC/qpd+JQgkAuQ8GupkmbOuJVSe8o1Qj
PmEDH3ChLVMMnGTSiinF
=m3JI
-----END PGP SIGNATURE-----

--oPmsXEqKQNHCSXW7--


--===============3770355245318954336==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3770355245318954336==--
