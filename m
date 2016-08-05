Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B4CBF7CA0
	for <xfs@oss.sgi.com>; Fri,  5 Aug 2016 00:17:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 762C7304032
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 22:16:57 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	a0eV3PEt7y5msZ1U for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2016 22:16:53 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1bVXV5-0004FU-8J
	for xfs@oss.sgi.com; Fri, 05 Aug 2016 15:16:51 +1000
Date: Fri, 5 Aug 2016 15:16:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.7.0 released
Message-ID: <20160805051651.GE16044@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0743964746880918091=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0743964746880918091==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qrgsu6vtpU/OV/zm"
Content-Disposition: inline


--Qrgsu6vtpU/OV/zm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repositories have just been updated and tagged with the
v4.7.0 release tag. It can be found here:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git v4.7.0
git://oss.sgi.com/xfs/cmds/xfsprogs.git v4.7.0

A signed gzipped-tar archive of the source code is available here:

ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.7.0.tar.gz
ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-4.7.0.tar.gz.sign

The archive is signed with my gpg key (the same one that this
release announcement is signed with).

Many thanks go to all the contributors to this release. The summary
of changes since v4.5.0 can be found listed in doc/CHANGES, which I
have reproduced in part below.

-Dave.

xfsprogs-4.7.0 (5 Aug 2016)
	- xfs_io: man page for copy_file_range (Anna Schumaker)
	- xfs_quota: handle XFS_GETNEXTQUOTA failure sanely (Zorro Lang)
	- mkfs: remove old glibc build failure workaround (Felix Janda)

xfsprogs-4.7.0-rc2 (20 Jul 2016)
	- xfs_io: add support for copy_file_range (Anna Schumaker)
	- repair: fix exit value after low memory is detected (Zorro Lang)
	- repair: fix quota inode detection issue (Eric Sandeen)
	- fix coverity issues from 4.7-rc1 (Bill O'Donnell)

xfsprogs-4.7.0-rc1 (22 Jun 2016)
	- libxfs kernel sync up to 4.7-rc1
	- quota: new efficient iteration mechanism (Eric Sandeen)
	- quota: support usernames starting with digits (Zorro Lang)
	- xfs_io: mmap/mremap fixes (Zorro Lang)
	- build/translation fixes (Mike Frysinger)
	- repair: error messge cleanups (Eric Sandeen)
	- mkfs: table based option parsing (Jan Tulak, Eric Sandeen)
	- metadump: sector size support fixes (Eric Sandeen)
	- db: unaligned acces fixes (Eric Sandeen)
	- db: add CRC recalculation for corrupt blocks
	- db: fix array notation handling in print commands
	- db: Note that fragmenation factor is meaningless (Eric Sandeen)
	- repair: more efficient secondary superblock search (Bill O'Donnell)
	- quota: timer reporting corner case fixes (Eric Sandeen)
	- headers: struct fsxattr redifinition fixes (Christoph Hellwig)
	- man page updates (Eric Sandeen, Jan Tulak, Zorro Lang)
	- repair: RT summary inode rebuild fix (Eric Sandeen)
	- db: sparse inode check fixes (Brian Foster)


The new head of the master branch is commit:

d7e1f5f xfsprogs: Release v4.7

New Commits:

Anna Schumaker (1):
      [8f05294] xfs_io: Update man page for copy_range command

Dave Chinner (1):
      [d7e1f5f] xfsprogs: Release v4.7

Felix Janda (1):
      [ab870d0] mkfs: Remove workaround for getsubopt() on older glibc

Zorro Lang (1):
      [52e81d7] xfs_quota: fall back silently if XFS_GETNEXTQUOTA fails


Code Diffstat:

 VERSION               |  2 +-
 configure.ac          |  2 +-
 debian/changelog      |  6 ++++++
 doc/CHANGES           | 22 ++++++++++++++--------
 include/darwin.h      |  1 -
 include/freebsd.h     |  2 --
 include/gnukfreebsd.h |  2 --
 include/irix.h        |  2 --
 include/linux.h       |  6 ------
 man/man8/xfs_io.8     | 33 +++++++++++++++++++++++++++++++++
 mkfs/xfs_mkfs.c       | 24 ++++++++----------------
 quota/report.c        |  8 ++++++--
 repair/xfs_repair.c   |  4 ++--
 13 files changed, 71 insertions(+), 43 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--Qrgsu6vtpU/OV/zm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXpCFCAAoJEK3oKUf0dfod2ZkQAJdW+2ToMyhNpjv1QecQn8EC
qmDp8Pr4rs8yrsFUI/47s+cqSLYmkFFwIhRw9pSQXdxVLufcTjQxRSQrlynMQBkC
c+XR0alcgSCmYYpYcQxHZskPTynJ6Z0Nyt1rbSdu5KjdRX7MLUvqVkw5tcpjnEqP
VUfCVgTLqwlpYrEvKrXd0im7q4ib0f7yE7r/iXDsoD3/GOTl39MFG8MB7YXc3aMk
kZetPyv0nBZ2zUCiv6U6BveSDdtF1oMBTjn5+DHgAEF9sHqsSHxW4+0ce/hhtO+D
+Idn2ibpo+82hcj8WsM2llQNPttUjPl3Op14YcM304R1yBw37whMZT9MDj7cD9bh
uzn9Oj6X+/eGYozvaXe13HA3ZDMT3QCccicofPEWbewHd3/UuAK8VCdnGIkXBNBE
mg2x6ZxzCTxen/cmAx96TajqfVUccTCe7ODlV/kR2wPD+QSZpwJuDApXL1FBxUEC
oxpn1XWBeRe2A8mfiQTLruHeJziIXB5ZlKsxCEaN1zYpyQcyxBurig8z/LlUOSZy
ir+M2hhDDrS+NZK3SGFfbYMEjv9lYrKyheqG1DMGwXfUF6W7M1fn1MDRn2BzeCXp
+4IePaAZAMHg3gQvJzR35oBMukV901Om25jzBUk7pI8jTmagL6V8xHtNFxIx5SyL
HXS0JWPm9xyDd694bz8W
=9wyv
-----END PGP SIGNATURE-----

--Qrgsu6vtpU/OV/zm--


--===============0743964746880918091==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0743964746880918091==--
