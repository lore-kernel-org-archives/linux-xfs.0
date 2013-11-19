Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED53E7F5D
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 11:08:37 -0600 (CST)
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1283304067
	for <xfs@oss.sgi.com>; Tue, 19 Nov 2013 09:08:34 -0800 (PST)
Message-Id: <20131119170148.675504461@sgi.com>
Date: Tue, 19 Nov 2013 11:01:25 -0600
From: rjohnston@sgi.com
Subject: [PATCH V2] xfsprogs: update version for 3.2.0-alpha2
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
index 5a292d7..e6d2cbc 100644
--- a/doc/CHANGES
+++ b/doc/CHANGES
@@ -1,6 +1,232 @@
+xfsprogs-3.2.0-alpha2 (18 November 2013)
+	- Alpha release for the purpose of testing the CRC feature during the
+	  v3.12 kernel -rc series.
+	- xfsprogs: Fix stray semicolon in libxfs/rdwr.c
+	- xfs_repair: correct docs for "-t" units
+	- xfs_fsr: fix SWAPEXT failures under selinux
+	- xfs_fsr: extra debugging info
+	- repair: fix leaf node directory data check
+	- repair: Increase default repair parallelism on large filesystems
+	- repair: prefetching is turned off unnecessarily
+	- xfsprogs: kill experimental warnings for v5 filesystems
+	- xfs: support larger inode clusters on v5 filesystems
+	- db: enable metadump on CRC filesystems
+	- libxfs: work around do_div() not handling 32 bit numerators
+	- xfs_db: avoid libxfs buffer lookup warnings
+	- xfs_db: use inode cluster buffers for inode IO
+	- db: re-enable write support for v5 filesystems.
+	- db: add a special attribute buffer verifier
+	- db: add a special directory buffer verifier
+	- db: verify and calculate dquot CRCs
+	- db: verify and calculate inode CRCs
+	- db: indicate if the CRC on a buffer is correct or not
+	- db: introduce verifier support into set_cur
+	- db: rewrite IO engine to use libxfs
+	- libxfs: refactor libxfs_buf_read_map for xfs_db
+	- db: rewrite bbmap to use xfs_buf_map
+	- db: separate out straight buffer IO from map based IO.
+	- libxfs: stop caching inode structures
+	- libxfs: fix root inode handling inconsistencies
+	- xfs: don't emit corruption noise on fs probes
+	- xfs: fix node forward in xfs_node_toosmall
+	- xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
+	- xfs: remove newlines from strings passed to __xfs_printk
+	- libxfs: Minor cleanup and bug fix sync
+	- libxfs: bring across inode buffer readahead verifier changes
+	- libxfs: xfs_rtalloc.c becomes xfs_rtbitmap.c
+	- libxfs: bmap btree owner swap support
+	- libxfs: unify xfs_btree.c with kernel code
+	- xfs: decouple inode and bmap btree header files
+	- xfs: split dquot buffer operations out
+	- xfs: create a shared header file for format-related information
+	- xfs: fix some minor sparse warnings
+	- xfsprogs: fix automatic dependency generation
+	- xfsprogs: remove xfs_check references from fsck.xfs script & manpage
+	- xfsprogs: add generated crc files to .gitignore
+	- xfsprog: add mkfs.xfs sb v4 support for dirent filetype field
+	- xfs_progs: add dirent filetype to xfs_db version
+	- xfsprog: add dirent filetype information for xfs_info
+	- xfsprog: add xfs sb v4 support for dirent filetype field
+	- Revert "xfs: create a shared header file for format-related
+	  information"
+	- Revert "[RESEND, 4/7] xfsprogs: xfsio: add support
+	  FALLOC_FL_COLLAPSE_RANGE for fallocate"
+	- xfs: unify directory/attribute format definitions
+	- xfsprogs: fix resource leak in longform_dir2_rebuild()
+	- xfs_repair: add d_type when moving files to lost+found
+	- xfsprogs: Note projid32bit default change in mkfs.xfs manpage
+	- xfs_repair: test for bad level in dir2 node
+	- xfsprogs: initialize filetype for lost+found creation
+	- xfs_repair: avoid segfault if reporting progress early in repair
+	- xfsprogs: fix a warning in the deb build
+	- Sent: Friday, October 11, 2013 12:38:11 AM
+	- xfsprogs: restrict platform_test_xfs_fd to regular files
+	- xfsprogs: remove incorrect l_sectBBsize assignment in xfs_repair
+	- [RESEND, 4/7] xfsprogs: xfsio: add support FALLOC_FL_COLLAPSE_RANGE
+	  for fallocate
+	- xfsprogs: fix crc32 build on big endian
+	- xfsprogs: handle symlinks etc in fs_table_initialise_mounts()
+	- xfs: create a shared header file for format-related information
+	- xfs: dirent dtype presence is dependent on directory magic numbers
+	- xfs: don't assert fail on bad inode numbers
+	- xfs: ensure we copy buffer type in da btree root splits
+	- xfs: check magic numbers in dir3 leaf verifier first
+	- libxfs: fix missing filetype updates to xfs_dir2.c
+	- xfsprogs: fix return value of verify_set_primary_sb()
+	- [v3, 1/2] xfsprogs: fix potential memory leak in
+	  verify_set_primary_sb()
+	- xfsprogs: fix potential memory leak in repare/sb.c
+	- xfsprogs: initialize filetype for xfs_name_dot
+	- mkfs: add noalign option to usage()
+	- xfsprogs: avoid array overflow in pf_batch_read()
+	- xfsprogs: fix Out-of-bounds access in repair/dinode.c
+
 xfsprogs-3.2.0-alpha1 (26 September 2013)
 	- Alpha release for the purpose of testing the CRC feature during the
 	  v3.12 kernel -rc series.
+	- xfsprogs: cleanup miscellaneous merge faults
+	- repair: fix segv on directory block read failure
+	- xfs: inode log reservations are too small
+	- xfs: btree block LSN escaping to disk uninitialised
+	- xfs: fix calculation of the number of node entries in a dir3 node
+	- xfs: di_flushiter considered harmful
+	- xfsprogs: add dtype support to mkfs and db
+	- xfs: Add write support for dirent filetype field
+	- [47/55,V2] xfs: Add read-only support for dirent filetype field
+	- xfs: Add xfs_log_rlimit.c
+	- xfs: Get rid of all XFS_XXX_LOG_RES() macro
+	- xfs: refactor xfs_trans_reserve() interface
+	- xfs: Make writeid transaction use tr_writeid
+	- xfs: Introduce tr_fsyncts to m_reservation
+	- xfs: Introduce a new structure to hold transaction reservation items
+	- xfs: make struct xfs_perag kernel only
+	- xfs: move kernel specific type definitions to xfs.h
+	- xfs: remove __KERNEL__ check from xfs_dir2_leaf.c
+	- xfs: remove __KERNEL__ from debug code
+	- xfs: kill __KERNEL__ check for debug code in allocation code
+	- xfs: move swap extent code to xfs_extent_ops
+	- xfs: don't special case shared superblock mounts
+	- xfsprogs: sync minor kernel header differences
+	- xfs: create xfs_bmap_util.[ch]
+	- libxfs: switch over to xfs_sb.c and remove xfs_mount.c
+	- xfs: split out the remote symlink handling
+	- xfs: introduce xfs_inode_buf.c for inode buffer operations
+	- xfs: move unrealted definitions out of xfs_inode.h
+	- xfs: move inode fork definitions to a new header file
+	- libxfs: move transaction code to trans.c
+	- libxfs: introduce xfs_trans_resv.c
+	- xfs: introduce xfs_quota_defs.h
+	- xfs: introduce xfs_rtalloc_defs.h
+	- xfs: split out on-disk transaction definitions
+	- xfs: separate icreate log format definitions from xfs_icreate_item.h
+	- xfs: separate dquot on disk format definitions out of xfs_quota.h
+	- xfs: split out inode log item format definition
+	- xfs: split out buf log item format definitions
+	- xfs: split out inode log item format definition
+	- xfs: separate out log format definitions
+	- libxfs: local to remote format support of remote symlinks
+	- xfs: remove local fork format handling from xfs_bmapi_write()
+	- libxfs: fix compile warnings
+	- xfsprogs: define min/max once and use them everywhere
+	- libxfs: sync xfs_ialloc.c to the kernel code
+	- libxfs: sync dir2 kernel differences
+	- libxfs: sync attr code with kernel
+	- libxfs: update xfs_alloc to current kernel version
+	- libxfs: sync xfs_da_btree.c
+	- libxfs: fix byte swapping on constants
+	- libxfs: ensure btree root split sets blkno correctly
+	- libxfs: fix directory/attribute format issues
+	- xfsprogs: teach logprint about icreate transaction
+	- xfsprogs: port inode create transaction changes
+	- xfsprogs: introduce xfs_icreate.h
+	- xfs_io: v8 add the lseek() SEEK_DATA/SEEK_HOLE support
+	- xfs_db: add header to freesp -d output
+	- xfs_repair: zero out unused parts of superblocks
+	- xfs_repair: add prototype for alloc_ex_data()
+	- xfsprogs: fix Out-of-bounds access in repair/dinode.c
+	- xfsprogs: fix inode crash in xfs_repair
+	- xfsprogs: Start using pquotaino from on-disk superblock
+	- xfsprogs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
+	- xfsprogs: fix unint var in repair phase6
+	- xfsprogs: fix agcnts leak in xfs_repair's scan_ags
+	- xfsprogs:free bp in xlog_find_tail() error path
+	- xfsprogs: free bp in xlog_find_zeroed() error path
+	- xfsprogs: fix buffer leak in xlog_print_find_oldest
+	- xfsprogs: avoid double-free in xfs_attr_node_addname
+	- xfsprogs/io: add readdir command
+	- mkfs.xfs: fix protofile name create block reservation
+	- xfs: don't emit v5 superblock warnings on write
+	- xfs: rework remote attr CRCs
+	- xfs: fully initialise temp leaf in xfs_attr3_leaf_compact
+	- xfs: fully initialise temp leaf in xfs_attr3_leaf_unbalance
+	- xfs: correctly map remote attr buffers during removal
+	- xfs: remote attribute tail zeroing does too much
+	- xfs: remote attribute read too short
+	- xfs: remote attribute allocation may be contiguous
+	- xfs: remote attribute lookups require the value length
+	- xfs: xfs_attr_shortform_allfit() does not handle attr3 format.
+	- xfs: Remote attr validation fixes and optimisations
+	- xfs: fix da node magic number mismatches
+	- xfs_repair: support CRC enabled remote symlinks
+	- libxfs: fix dir3 freespace block corruption
+	- xfs_repair: fix btree block magic number mapping
+	- xfs_db: add support for CRC format remote symlinks
+	- xfs_repair: drop buffer reference on symlink error
+	- xfs_metadump: requires some object CRC recalculation
+	- xfs_mdrestore: recalculate sb CRC before writing
+	- xfsprogs: support CRC enabled filesystem detection
+	- mkfs.xfs: validate options for CRCs up front.
+	- xfs_db: add CRC support for attribute fork structures.
+	- xfs_db: add CRC information to dquot output
+	- xfs_repair: make directory freespace table CRC format aware.
+	- xfs_repair: convert directory parsing to use libxfs structure
+	- xfs_db: update field printing for dir crc format changes.
+	- xfs_db: factor some common dir2 field parsing code.
+	- xfs_db: convert directory parsing to use libxfs structure
+	- xfs_repair: always use incore header for directory block checks
+	- xfsprogs: add crc format support to db
+	- xfs_db: support version 5 superblock in versionnum command
+	- libxfs: determine inode size from version number, not struct
+	  xfs_dinode
+	- xfs_db: disable modification for CRC enabled filessytems.
+	- xfsprogs: disable xfs_check for CRC enabled filesystems
+	- xfs_repair: update for dir/attr crc format changes.
+	- xfsprogs: add crc format support to repair
+	- xfsprogs: introduce CRC support into mkfs.xfs
+	- xfsprogs: Add verifiers to libxfs buffer interfaces.
+	- xfs: implement extended feature masks
+	- xfs: add CRC checks to the superblock
+	- xfs: buffer type overruns blf_flags field
+	- xfs: add buffer types to directory and attribute buffers
+	- xfs: add CRC protection to remote attributes
+	- xfs: split remote attribute code out
+	- xfs: add CRCs to attr leaf blocks
+	- xfs: add CRCs to dir2/da node blocks
+	- xfs: shortform directory offsets change for dir3 format
+	- xfs: add CRC checking to dir2 leaf blocks
+	- xfs: add CRC checking to dir2 data blocks
+	- xfs: add CRC checking to dir2 free blocks
+	- xfs: add CRC checks to block format directory blocks
+	- libxfs: add support for crc headers on remote symlinks
+	- libxfs: add version 3 inode support
+	- libxfs: change quota buffer formats
+	- xfsprogs: Support new AGFL format
+	- xfsprogs: add crc format changes to ag headers
+	- libxfs: add crc format changes to generic btrees
+	- logprint: fix wrapped log dump issue
+	- xfs_metadump: manpage fix regarding frozen fs
+	- mkfs: fix realtime device initialisation
+	- mkfs: add missing noalign suboption information
+	- xfsprogs: fix make deb
+	- xfsprogs: define umode_t for build if not defined already
+	- xfs_logprint: fix continuation transactions
+	- xfsprogs: updata libxlog to current kernel code
+	- xfsprogs: add CRC32c infrastructure
+	- xfsprogs: update libxfs to 3.9-rc1 + xfsdev
+	- xfsprogs: sync code to current kernel code
+	- xfsprogs: Die dir1 Die!
+	- xfs_fsr: file reads should be O_DIRECT
+	- xfs_logprint: print all AGI unlinked buckets
 
 xfsprogs-3.1.11 (8 May 2013)
 	- Support for relative paths in xfs_quota thanks to Satoru Takeuchi.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
