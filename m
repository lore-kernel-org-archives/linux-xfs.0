Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C7BC47F91
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 20:36:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 97FE58F804C
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 18:36:32 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	EGLVcjvoEXxmUw7r for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 18:36:28 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZKclm-0006tg-Up
	for xfs@oss.sgi.com; Thu, 30 Jul 2015 11:36:27 +1000
Date: Thu, 30 Jul 2015 11:36:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v3.2.4 released
Message-ID: <20150730013626.GL16638@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4041097608587914749=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4041097608587914749==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All.

xfsprogs v3.2.4 has just been released. This release contains only
changes to xfs_metadump to address the information leaks disclosed
in CVE-2012-2150 here:

https://marc.info/?l=3Doss-security&m=3D143766249112576&w=3D2

Many thanks go to Eric Sandeen for doing all the work to address
these issues, and to Brian Foster, Christoph Hellwig and Darrick
Wong for reviewing the changes.

The source code can be accessed via git using either of these URLs:

git://oss.sgi.com/xfs/cmds/xfsprogs.git
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

and the release is tagged with the "v3.2.4" tag to make it easy to
check out the exact source used for the release.

A signed gzipped-tar archive of the source code is available
here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.4.tar.gz
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.4.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

Problems, issues, questions and general discussion about the release
should be directed to the XFS mailing list (xfs@oss.sgi.com).

-Dave.

The new head of the master branch is commit:

4a2f31a xfsprogs: Release v3.2.4

New Commits:

Dave Chinner (1):
      [4a2f31a] xfsprogs: Release v3.2.4

Eric Sandeen (19):
      [7ac353a] libxlog: add xlog_is_empty() helper
      [ffc56f1] metadump: rename dont_obfuscate variable
      [190df61] metadump: zero out clean log
      [37a7818] xfs_metadump: don't zero log if not obfuscating
      [80917c1] xfs_metadump: obfuscate remote symlinks on CRC filesystems
      [8085336] metadump: obfuscate attrs on CRC fs
      [1941482] metadump: Fill attribute values with 'v' rather than NUL
      [8927d44] metadump: Obfuscate the filesystem label
      [aad766a] metadump: handle multi-block directories
      [b09e839] metadump: Add option to copy metadata blocks intact
      [75333d2] metadump: Copy the log if not obfuscating or zeroing
      [18cdb61] metadump: Zero out unused portion of the AGFL
      [27499a0] metadump: Zero literal area of unused inodes
      [87c955c] metadump: Zero unused portions of inode literal area
      [6d34e8b] metadump: Zero sparse/unused regions of dir2
      [23b2ae2] metadump: Zero unused tail of symlink blocks
      [70099c8] metadump: Zero unused portions of attribute blocks
      [c83c169] metadump: Zero unused portions of DA_NODE blocks
      [20f35ef] metadump: Zero unused portions of inode, BMAP, and allocati=
on btree blocks


Code Diffstat:

 VERSION                 |   2 +-
 db/metadump.c           | 475 +++++++++++++++++++++++++++++++++++++++++---=
----
 db/sb.c                 |  25 +--
 db/type.c               |   3 +
 db/type.h               |   2 +-
 db/xfs_metadump.sh      |   5 +-
 debian/changelog        |   7 +
 doc/CHANGES             |   3 +
 include/libxlog.h       |   2 +
 libxlog/util.c          |  56 ++++++
 man/man8/xfs_metadump.8 |  10 +-
 11 files changed, 499 insertions(+), 91 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVuX+aAAoJEK3oKUf0dfodnNMQAJQ1dLZI8YXokvbNH892dCbA
zmELTKlpwN/FBjeX1o8NOmptef/ErN+7IbumB2xW8WalLdtTTy2+wLkz1iU9d/lJ
O2rgC9juzEOGVM3Z1fhVk4pWK47x9VGvkuHOXeR2z3kVn1fdVwsT++6xn3qmC9UC
b/FYcax4eoRZZ+Dk6N37DxMozlIQ9rGe2KpbI07TVwte04w5P00Ugc4J4Xch0xQg
l9gIUwDhZZNjWflmrzx9RpeZ1pKVh3my2zkpU6boIqt5ZFOHNQa14+Jn2JmpeGxQ
S1wNROf4lDyN05eVE85lb2Fq0iIzjhhVyLIr5Q7o12ugYW+Q9r7tg4QH80YPQE6s
gtydzsNQg9e1XYVCMmfivCkqzCe6kNeXjC4TCo+zrNcUfBosZ65J9HxHSQyOuYIS
TCj1A0ovrlnpAeT/q6dj0dhWXAW8a+ng1jOkj6tbIJVCBTa1yxZXK/4IKPhh8+pE
FZwu3+tz8pX9x0bzBU0ErvWyF6nKeoaMPT9Q5klpPhaiyyXPbp8OFEeiA9ZPD0ir
RtHNuYRL1V9Suhk6IsPZhaIYd49PXQg5Q4RbCfx4BD9H2Es/T1xaczz5wE03okA3
NQFd1sT7iR6/F6sT1CPhfar3Tv1M72ten1TzKbHApCnMfpyeg3b4q5D7FPsOueX2
CES1I5mM5jF47wUNMM6S
=e5Ja
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--


--===============4041097608587914749==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4041097608587914749==--
