Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EAB4A7F5F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 00:57:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F402AC00E
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 22:57:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ID2joV8BWOKJeCwr for <xfs@oss.sgi.com>;
	Thu, 15 May 2014 22:57:05 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WlB8U-0002MK-Ed
	for xfs@oss.sgi.com; Fri, 16 May 2014 15:56:50 +1000
Date: Fri, 16 May 2014 15:56:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v3.2.0 released!
Message-ID: <20140516055650.GF26353@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2422346542353528709=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============2422346542353528709==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JbKQpFqZXJ2T76Sg"
Content-Disposition: inline


--JbKQpFqZXJ2T76Sg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

It is my pleasure to announce the release of v3.2.0 of the xfsprogs
package. This release has been a long time in the making with a lot
of effort from many people:

	- just over a year since v3.1.11 was released
	- 323 commits
	- 17 contributors
	- 10 code reviewers
	- 232 files changed
	- +29549/-24432 lines of code

The major feature that this release brings is support for the
version 5 on-disk format. This new format provides significant
reliability enhancements such as metadata CRCs, object back owner
references and improved crash recovery reliability.

The next kernel to be released (v3.15) will also be the first kernel
to support this new on-disk format for production workloads: the
kernel no longer considers this new format experimental as of
v3.15-rc5.

There are many other enhancements:

	- xfs_repair has significantly improved multithreading
	  scalability
	- xfs_db now uses the common libxfs IO engine
	- xfs_db validates the metadata it reads from disk
	- xfs_io has support for a wide range of new kernel features
	- xfs_metadump has much improved obfuscation support
	- libxfs has significanty fewer differences to the kernel
	  code it is derived from

The source code can be accessed via git using this URL:

	git://oss.sgi.com/xfs/cmds/xfsprogs.git

A signed gzipped-tar archive of the source code is available here:

	ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.0.tar.gz
	ftp://oss.sgi.com/projects/xfs/cmd_tars/xfsprogs-3.2.0.tar.gz.sign

Problems, issues, questions and general discussion about the release
should be directed to the XFS mailing list (xfs@oss.sgi.com).

A summary of the changes during development of this release (taken
=66rom doc/CHANGES) is as follows:

xfsprogs-3.2.0 (16 May 2014)
        - First release with full support of CRC enabled filesystems
        - No code changes from 3.2.0-rc3

xfsprogs-3.2.0-rc3 (9 May 2014)
        - Third release candidate for full support of CRC enabled filesyste=
ms
        - Updated Debian change logs in preparation for release (Nathan Sco=
tt)
        - Build warning fixes (Nathan Scott)
        - xfs_repair prefetch fix (Eric Sandeen)
        - xfs_repair block tracking scalability fix

xfsprogs-3.2.0-rc2 (2 May 2014)
        - Second release candidate for full support of CRC enabled filesyst=
ems
        - xfs_repair has full CRC validation and repair
        - Coverity related cleanups and fixes

xfsprogs-3.2.0-rc1 (14 April 2014)
        - First release candidate for full support of CRC enabled filesyste=
ms
        - Large number of Coverity related fixes and cleanups
        - disambiguous of CRC validation errors from IO errors.
        - Improved dangerous mode handling in repair
        - repair handles garbage in zeroed areas of superblocks better
        - repair validates dirent ftype field fully
        - metadump fully supports discontiguous directory blocks
        - metadump only recalculates CRCs on metadata it obfuscates so as to
          preserve errors in the metadata where possible.
        - default log size that mkfs creates is now reverted to the same si=
ze
          as 3.1.x releases create.
        - mkfs sets the ftype on directory entries correctly during protofi=
le
          population
        - xfs_io support O_TMPFILE, flink, FALLOC_FL_ZERO_RANGE and
          FALLOC_FL_COLLAPSE_RANGE,
        - logprint handles split entries better

xfsprogs-3.2.0-alpha2 (25 November 2013)
        - Alpha release for the purpose of testing the CRC feature in
          kernels 3.10 and newer.
        - Enable xfs_db write support and xfs_metadump support for CRC
          enabled filesystems.
        - Add directory entry filetype support for non-CRC filesystems.
        - Remove experimental warnings for CRC filesystems.
        - Ensure all inodes created by xfs_repair have a proper d_type set.
        - Fix build on big endian machines.
        - Properly handle symlinks to devices on various tool commandlines.
        - Fix xfs_repair's dirty log detection for 4k sector logs, broken
          in Alpha1.
        - Fix a potential segfault in xfs_repair when issuing progress
          reports.
        - Fix potential xfs_fsr failures when running w/ selinux.
        - Update config.guess/config.sub for arm64, thanks to Colin Watson.
        - Stop wasting memory by caching inode structures in xfs_repair -
          they are never re-used.  Thanks to Christoph Hellwig.
        - Fix several Coverity-found defects, thanks to Li Zhong.
        - Fix platform_test_xfs_fd to return false on special files which
          cannot take an xfs ioctl.
        - Sync up libxfs with kernel code.
        - Improved xfs_repair performance on large filesystems
          (always use prefetch and strided AG scanning functionality)


xfsprogs-3.2.0-alpha1 (26 September 2013)
        - Alpha release for the purpose of testing the CRC feature in
          kernels 3.10 and newer.
        - Remove all vestiges of old, unsupported version 1 directory code.
        - Add a "readdir" command to xfs_io, thanks to Brian Foster.
        - Fix potential segfault in xfs_repair when creating lost+found.
        - Zero out unused parts of on-disk superblocks during repair, to
          avoid metadata verifier failures at runtime.
        - Add directory entry type support to mkfs.xfs and xfs_db.
        - Add the icreate transaction to xfs_logprint, and fix continuation
          transactions.
        - Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
        - Print all AGI unlinked buckets in xfs_logprint.
        - Fix mkfs.xfs ENOSPC with protofile which creates a very large
          directory.
        - Fix several Coverity-found defects, thanks to Li Zhong.
        - Do all file reads in xfs_fsr using O_DIRECT.
        - Sync up libxfs with kernel code.
        - Add support for concurrent group and project quota usage on CRC
          enabled filesystems.
        - Ensure mkfs creates log sizes that are always large enough for
          the configured fileystem geometry.

--=20
Dave Chinner
david@fromorbit.com

--JbKQpFqZXJ2T76Sg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdaihAAoJEK3oKUf0dfodbpsQAI7/kRglsvgJXQzf7VQrx3op
o6mD1V5IERwJYJcChdBJ+VLAR+bqf1mXDe/aybPNQYlwwU09+BKTe2UC6NpwRhzE
ma9/DdvEhjg2UlCt0SKaQX8FtmzKZLjp/tALLOR56kl/PCXvJubV5+fAhkAZO5cQ
19muNulMIPsbbziUM0cLg5X3Fo9XVM2hekWF5IrUcmd4RoAzn84hMmB3Fc9rwRa/
jHX8FaKy5JT+lC00yMC3135fMYagjFPSHa2lnmBC3PrMsd34WPRtVAMEHrdsSuUR
CmpM7nvssMEXNcURfofIOygX01K/uPVQtW+shUXVFWW7ngTWq8O4IT8q3JaPjT3n
6Ifratzq9JlhY+g6HyC0lrTci9JTedlMZKA9b4zcUaZfDf5ii4AxIRMhl+YyiJrv
KEGjs+9arbxz5QH52V10hKazOWByE1jcovDPmLRSlqYuPjNi33Av3gbxGf8Sbbb9
a2P4egEfnRP1jUgk1g3nkQxEO6Xa7iS7kmzK9xN4WbDhvlkuTecM5IU19rc+Dkq5
qc1Dls7jaQX1lp3zWez0i/KoAHN6gbXSQfbXMCtyFbc9W00giVg9zHrs4Im5QV3d
+Vxm6XCntJGNJ4GSZU0pDyYJKGB2kGg9qrJkpp3c0Hb/KySMvNf8vXliIHRy4WIi
DzBmO7gQ+wF/JXs9Q4vt
=Ijkz
-----END PGP SIGNATURE-----

--JbKQpFqZXJ2T76Sg--


--===============2422346542353528709==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2422346542353528709==--
