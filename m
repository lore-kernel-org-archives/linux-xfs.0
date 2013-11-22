Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 713867F3F
	for <xfs@oss.sgi.com>; Fri, 22 Nov 2013 12:43:55 -0600 (CST)
Message-Id: <20131122183757.113479216@sgi.com>
Date: Fri, 22 Nov 2013 12:37:43 -0600
From: rjohnston@sgi.com
Subject: [PATCH V4] xfsprogs: update version for 3.2.0-alpha2
References: <20131118150313.940966335@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8910923203114204581=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@redhat.com>

--===============8910923203114204581==
Content-Type: text/plain

Update the VERSION, configure.ac and doc/CHANGES file for alpha
release, 3.2.0-alpha2

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Rich Johnston <rjohnston@sgi.com>
---
V4
Updated doc/CHANGES per suggestions by Eric and Dave.
Added SOB by Eric

diff --git a/VERSION b/VERSION
index f4ab52c..f3b53c1 100644
--- a/VERSION
+++ b/VERSION
@@ -3,5 +3,5 @@
 #
 PKG_MAJOR=3
 PKG_MINOR=2
-PKG_REVISION=0-alpha1
+PKG_REVISION=0-alpha2
 PKG_BUILD=1
diff --git a/configure.ac b/configure.ac
index 949dd06..ae17c68 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,4 +1,4 @@
-AC_INIT([xfsprogs], [3.2.0-alpha1])
+AC_INIT([xfsprogs], [3.2.0-alpha2])
 AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
diff --git a/doc/CHANGES b/doc/CHANGES
index 5a292d7..95c1d74 100644
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,6 +1,51 @@
+xfsprogs-3.2.0-alpha2 (19 November 2013)
+	- Alpha release for the purpose of testing the CRC feature in
+	  kernels 3.10 and newer.
+	- Enable xfs_db write support and xfs_metadump support for CRC
+	  enabled filesystems.
+	- Add directory entry filetype support for non-CRC filesystems.
+	- Remove experimental warnings for CRC filesystems.
+	- Ensure all inodes created by xfs_repair have a proper d_type set.
+	- Fix build on big endian machines.
+	- Properly handle symlinks to devices on various tool commandlines.
+	- Fix xfs_repair's dirty log detection for 4k sector logs, broken
+	  in Alpha1.
+	- Fix a potential segfault in xfs_repair when issuing progress 
+	  reports.
+	- Fix potential xfs_fsr failures when running w/ selinux.
+	- Update config.guess/config.sub for arm64, thanks to Colin Watson.
+	- Stop wasting memory by caching inode structures in xfs_repair -
+	  they are never re-used.  Thanks to Christoph Hellwig.
+	- Fix several Coverity-found defects, thanks to Li Zhong.
+	- Fix platform_test_xfs_fd to return false on special files which
+	  cannot take an xfs ioctl.
+	- Sync up libxfs with kernel code.
+	- Improved xfs_repair performance on large filesystems
+	  (always use prefetch and strided AG scanning functionality)
+
+
 xfsprogs-3.2.0-alpha1 (26 September 2013)
-	- Alpha release for the purpose of testing the CRC feature during the
-	  v3.12 kernel -rc series.
+	- Alpha release for the purpose of testing the CRC feature in
+	  kernels 3.10 and newer.
+	- Remove all vestiges of old, unsupported version 1 directory code.
+	- Add a “readdir” command to xfs_io, thanks to Brian Foster.
+	- Fix potential segfault in xfs_repair when creating lost+found.
+	- Zero out unused parts of on-disk superblocks during repair, to
+	  avoid metadata verifier failures at runtime.
+	- Add directory entry type support to mkfs.xfs and xfs_db.
+	- Add the icreate transaction to xfs_logprint, and fix continuation
+	  transactions.
+	- Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
+	- Print all AGI unlinked buckets in xfs_logprint.
+	- Fix mkfs.xfs ENOSPC with protofile which creates a very large
+	  directory.
+	- Fix several Coverity-found defects, thanks to Li Zhong.
+	- Do all file reads in xfs_fsr using O_DIRECT.
+	- Sync up libxfs with kernel code.
+	- Add support for concurrent group and project quota usage on CRC
+	  enabled filesystems.
+	- Ensure mkfs creates log sizes that are always large enough for
+	  the configured fileystem geometry.
 
 xfsprogs-3.1.11 (8 May 2013)
 	- Support for relative paths in xfs_quota thanks to Satoru Takeuchi.
@@ -35,8 +80,8 @@ xfsprogs-3.1.11 (8 May 2013)
 	- Remove unconditional ASSERT(0) in xfs_repair.
 	- Reduce bb_numrecs in bno/cnt btrees when log consumes all agf space.
 	- Add depraction message for xfs_check.
-	- xfs_quota allow user or group names beginning with digits reported by
-	  James Carter.
+	- xfs_quota allow user or group names beginning with digits reported
+	  by James Carter.
 	- Fix manpages and usage() spelling, errors and omissions.
 	- Validate the extent count is at least within the positive
 	  range of a signed 32 bit integer before using it.



--===============8910923203114204581==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8910923203114204581==--
