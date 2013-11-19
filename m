Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 92D067F60
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 11:18:37 -0600 (CST)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6659F8F804B
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 09:18:34 -0800 (PST)
Message-Id: <20131119171527.125924934@sgi.com>
Date: Tue, 19 Nov 2013 11:14:54 -0600
From: rjohnston@sgi.com
Subject: [PATCH V3] xfsprogs: update version for 3.2.0-alpha2
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Update the VERSION, configure.ac and doc/CHANGES file for alpha
release, 3.2.0-alpha2

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---
V2
  - Add alpha1 and alpha2 content details
V3
  - Shorten content details (sent wrong version in V2)

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
index 5a292d7..3006efd 100644
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,6 +1,96 @@
+xfsprogs-3.2.0-alpha2 (19 November 2013)
+	- Alpha release for the purpose of testing the CRC feature during the
+	  v3.12 kernel -rc series.
+	- xfsprogs: fix Out-of-bounds access in repair/dinode.c
+	- xfsprogs: avoid array overflow in pf_batch_read()
+	- mkfs: add noalign option to usage()
+	- xfsprogs: initialize filetype for xfs_name_dot
+	- xfsprogs: fix potential memory leak in repare/sb.c
+	- xfsprogs: fix potential memory leak in verify_set_primary_sb()
+	- xfsprogs: fix return value of verify_set_primary_sb()
+	- libxfs: fix missing filetype updates to xfs_dir2.c
+	- xfs: check magic numbers in dir3 leaf verifier first
+	- xfs: ensure we copy buffer type in da btree root splits
+	- xfs: don't assert fail on bad inode numbers
+	- xfs: dirent dtype presence is dependent on directory magic numbers
+	- xfsprogs: handle symlinks etc in fs_table_initialise_mounts()
+	- xfsprogs: fix crc32 build on big endian
+	- xfsprogs: remove incorrect l_sectBBsize assignment in xfs_repair
+	- xfsprogs: restrict platform_test_xfs_fd to regular files
+	- Bug#725971: xfsprogs: config.guess/config.sub out of date for arm64
+	- xfsprogs: fix a warning in the deb build
+	- xfs_repair: avoid segfault if reporting progress early in repair
+	- xfsprogs: initialize filetype for lost+found creation
+	- xfs_repair: test for bad level in dir2 node
+	- xfsprogs: Note projid32bit default change in mkfs.xfs manpage
+	- xfs_repair: add d_type when moving files to lost+found
+	- xfsprogs: fix resource leak in longform_dir2_rebuild()
+	- xfs: unify directory/attribute format definitions
+	- xfsprog: add xfs sb v4 support for dirent filetype field
+	- xfsprog: add dirent filetype information for xfs_info
+	- xfs_progs: add dirent filetype to xfs_db version
+	- xfsprog: add mkfs.xfs sb v4 support for dirent filetype field
+	- xfsprogs: add generated crc files to .gitignore
+	- xfsprogs: remove xfs_check references from fsck.xfs script & manpage
+	- xfsprogs: fix automatic dependency generation
+	- xfs: create a shared header file for format-related information
+	- xfs: split dquot buffer operations out
+	- xfs: decouple inode and bmap btree header files
+	- libxfs: unify xfs_btree.c with kernel code
+	- libxfs: bmap btree owner swap support
+	- xfs: remove newlines from strings passed to __xfs_printk
+	- xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
+	- xfs: fix node forward in xfs_node_toosmall
+	- xfs: don't emit corruption noise on fs probes
+	- libxfs: fix root inode handling inconsistencies
+	- libxfs: stop caching inode structures
+	- db: introduce verifier support into set_cur
+	- db: re-enable write support for v5 filesystems.
+	- xfs_db: use inode cluster buffers for inode IO
+	- xfs_db: avoid libxfs buffer lookup warnings
+	- libxfs: work around do_div() not handling 32 bit numerators
+	- db: enable metadump on CRC filesystems
+	- xfs: support larger inode clusters on v5 filesystems
+	- xfsprogs: kill experimental warnings for v5 filesystems
+	- repair: prefetching is turned off unnecessarily
+	- repair: Increase default repair parallelism on large filesystems
+	- xfs_fsr: fix SWAPEXT failures under selinux
+	- xfs_repair: correct docs for "-t" units
+
 xfsprogs-3.2.0-alpha1 (26 September 2013)
 	- Alpha release for the purpose of testing the CRC feature during the
 	  v3.12 kernel -rc series.
+	- xfs_logprint: print all AGI unlinked buckets
+	- xfs_fsr: file reads should be O_DIRECT
+	- xfsprogs: Die dir1 Die!
+	- xfsprogs: add CRC32c infrastructure
+	- xfsprogs: updata libxlog to current kernel code
+	- xfs_logprint: fix continuation transactions
+	- xfsprogs: define umode_t for build if not defined already
+	- xfsprogs: fix make deb
+	- mkfs: add missing noalign suboption information
+	- mkfs: fix realtime device initialisation
+	- xfs_metadump: manpage fix regarding frozen fs
+	- logprint: fix wrapped log dump issue
+	- libxfs: add crc format changes to generic btrees
+	- xfsprogs: fixes and updates to current kernel code tarball
+		http://oss.sgi.com/archives/xfs/2013-05/msg00013.html
+	- xfsprogs: add recent kernel CRC fixes (12 part patchset)
+		http://oss.sgi.com/archives/xfs/2013-06/msg00201.html
+	- mkfs.xfs: fix protofile name create block reservation
+	- xfsprogs/io: add readdir command
+	- xfsprogs: Various Coverity bug fixes
+	- xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
+	- xfsprogs: Start using pquotaino from on-disk superblock
+	- xfsprogs: fix inode crash in xfs_repair
+	- xfsprogs: fix Out-of-bounds access in repair/dinode.c
+	- xfs_repair: add prototype for alloc_ex_data()
+	- xfs_repair: zero out unused parts of superblocks
+	- xfs_db: add header to freesp -d output
+	- xfs_io: v8 add the lseek() SEEK_DATA/SEEK_HOLE support
+	- xfsprogs: bring code up to date with kernel (55 part series)
+       		updated version of the patchset posted here: 
+		http://oss.sgi.com/archives/xfs/2013-07/msg00454.html
 
 xfsprogs-3.1.11 (8 May 2013)
 	- Support for relative paths in xfs_quota thanks to Satoru Takeuchi.
@@ -35,8 +125,8 @@ xfsprogs-3.1.11 (8 May 2013)
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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
