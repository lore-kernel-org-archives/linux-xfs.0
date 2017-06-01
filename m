Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39283 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751078AbdFAQus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2017 12:50:48 -0400
Date: Thu, 1 Jun 2017 09:50:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs/040: use compare-libxfs in xfsprogs
Message-ID: <20170601165035.GJ4514@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

xfsprogs now ships with a tool to compare its libxfs against a kernel
libxfs.  Since the old srcdiff tool assumes dmapi.h (IRIX only) and the
pre-libxfs directory tree layout, fix the test and remove the old tool.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/040      |   30 ++---
 tests/xfs/040.good |   16 ---
 tests/xfs/040.out  |  171 ++++++++++++++++++++++++++++
 tools/srcdiff      |  316 ----------------------------------------------------
 4 files changed, 184 insertions(+), 349 deletions(-)
 delete mode 100644 tests/xfs/040.good
 delete mode 100755 tools/srcdiff

diff --git a/tests/xfs/040 b/tests/xfs/040
index 7c2a008..fadb888 100755
--- a/tests/xfs/040
+++ b/tests/xfs/040
@@ -1,7 +1,7 @@
 #! /bin/bash
 # FS QA Test No. 040
 #
-# srcdiff test
+# compare-libxfs test
 #
 #-----------------------------------------------------------------------
 # Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
@@ -36,25 +36,23 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common/filter
 
 [ -z "$KWORKAREA" ] && \
-	_notrun "Can't run srcdiff without KWORKAREA set"
+	_notrun "Can't run libxfs-diff without KWORKAREA set"
 [ -d "$KWORKAREA/fs/xfs" ] || \
 	_notrun "Can't find XFS source under \"$KWORKAREA\""
 
 [ -z "$WORKAREA" ] && \
-	_notrun "Can't run srcdiff without WORKAREA set"
-[ -f "$WORKAREA/xfstests/tools/srcdiff" ] || \
-	_notrun "Can't find srcdiff tool under \"$WORKAREA\""
-[ -d "$WORKAREA/xfsprogs/include" ] || \
-	_notrun "Can't find XFS command headers under \"$WORKAREA\""
-
-# real QA test starts here
-cd "$WORKAREA/xfstests"
-echo Silence is golden.
-perl tools/srcdiff -q >$seqres.full
-if ! diff $seqres.full $seq.good >/dev/null; then
-    echo "FAILED: srcdiff output $seqres.full differs to $seq.good"
-    exit 1
-fi
+	_notrun "Can't run libxfs-diff without WORKAREA set"
+[ -f "$WORKAREA/tools/libxfs-diff" ] || \
+	_notrun "Can't find libxfs-diff tool under \"$WORKAREA\""
+
+filter_libxfs_diff() {
+	sed -e 's/^--- libxfs/--- xfsprogs\/libxfs/g' \
+	    -e 's/^+++ .*libxfs/+++ kernel\/libxfs/g' \
+	    -e 's/^@@.*$/@@ -XXXX,X +YYYY,Y @@/g'
+}
+
+# Compare the two libxfses
+(cd "$WORKAREA" ; ./tools/libxfs-diff "$KWORKAREA/fs/xfs/libxfs") | filter_libxfs_diff | tee -a $seqres.full
 
 # success, all done
 status=0
diff --git a/tests/xfs/040.good b/tests/xfs/040.good
deleted file mode 100644
index 6df7788..0000000
--- a/tests/xfs/040.good
+++ /dev/null
@@ -1,16 +0,0 @@
-
-=== Checking attr package ===
-
-=== Checking acl package ===
-
-=== Checking dmapi package ===
-
-=== Checking xfsdump package ===
-
-=== Checking xfsprogs package ===
-
-=== Checking headers ===
-
-=== Checking libxfs code ===
-
-=== Checking libxlog code ===
diff --git a/tests/xfs/040.out b/tests/xfs/040.out
index 45b1dea..1e4fb1e 100644
--- a/tests/xfs/040.out
+++ b/tests/xfs/040.out
@@ -1,2 +1,171 @@
 QA output created by 040
-Silence is golden.
+--- xfsprogs/libxfs/xfs_alloc.c
++++ kernel/libxfs/xfs_alloc.c
+@@ -XXXX,X +YYYY,Y @@
+ 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
+ 		spin_lock_init(&pag->pagb_lock);
+ 		pag->pagb_count = 0;
+-		/* XXX: pagb_tree doesn't exist in userspace */
+-		//pag->pagb_tree = RB_ROOT;
++		pag->pagb_tree = RB_ROOT;
+ 		pag->pagf_init = 1;
+ 	}
+ #ifdef DEBUG
+--- xfsprogs/libxfs/xfs_btree.c
++++ kernel/libxfs/xfs_btree.c
+@@ -XXXX,X +YYYY,Y @@
+ 	return error;
+ }
+ 
+-#ifdef __KERNEL__
+ struct xfs_btree_split_args {
+ 	struct xfs_btree_cur	*cur;
+ 	int			level;
+@@ -XXXX,X +YYYY,Y @@
+ 	destroy_work_on_stack(&args.work);
+ 	return args.result;
+ }
+-#else /* !KERNEL */
+-#define xfs_btree_split	__xfs_btree_split
+-#endif
+ 
+ 
+ /*
+--- xfsprogs/libxfs/xfs_dir2_sf.c
++++ kernel/libxfs/xfs_dir2_sf.c
+@@ -XXXX,X +YYYY,Y @@
+ 		 * Calculate the new size, see if we should give up yet.
+ 		 */
+ 		size = xfs_dir2_sf_hdr_size(i8count) +	/* header */
+-		       count * 3 * sizeof(__u8) +	/* namelen + offset */
++		       count * 3 * sizeof(u8) +		/* namelen + offset */
+ 		       namelen +			/* name */
+ 		       (i8count ?			/* inumber */
+ 				count * XFS_INO64_SIZE :
+--- xfsprogs/libxfs/xfs_fs.h
++++ kernel/libxfs/xfs_fs.h
+@@ -XXXX,X +YYYY,Y @@
+ #endif
+ 
+ /*
+- * Flags for the bs_xflags/fsx_xflags field in XFS_IOC_FS[GS]ETXATTR[A]
+- * These are for backwards compatibility only. New code should
+- * use the kernel [4.5 onwards] defined FS_XFLAG_* definitions directly.
+- */
+-#define	XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
+-#define	XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
+-#define	XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE
+-#define	XFS_XFLAG_APPEND	FS_XFLAG_APPEND
+-#define	XFS_XFLAG_SYNC		FS_XFLAG_SYNC
+-#define	XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME
+-#define	XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP
+-#define	XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT
+-#define	XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT
+-#define	XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS
+-#define	XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE
+-#define	XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT
+-#define	XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG
+-#define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
+-#define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
+-
+-/*
+  * Structure for XFS_IOC_GETBMAP.
+  * On input, fill in bmv_offset and bmv_length of the first structure
+  * to indicate the area of interest in the file, and bmv_entries with
+@@ -XXXX,X +YYYY,Y @@
+ #define XFS_IOC_GET_AG_RESBLKS	     _IOR ('X', 126, struct xfs_fsop_ag_resblks)
+ /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
+ 
+-/* reflink ioctls; these MUST match the btrfs ioctl definitions */
+-/* from struct btrfs_ioctl_clone_range_args */
+-struct xfs_clone_args {
+-	__s64 src_fd;
+-	__u64 src_offset;
+-	__u64 src_length;
+-	__u64 dest_offset;
+-};
+-
+-/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
+-#define XFS_EXTENT_DATA_SAME	0
+-#define XFS_EXTENT_DATA_DIFFERS	1
+-
+-/* from struct btrfs_ioctl_file_extent_same_info */
+-struct xfs_extent_data_info {
+-	__s64 fd;		/* in - destination file */
+-	__u64 logical_offset;	/* in - start of extent in destination */
+-	__u64 bytes_deduped;	/* out - total # of bytes we were able
+-				 * to dedupe from this file */
+-	/* status of this dedupe operation:
+-	 * < 0 for error
+-	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
+-	 * == XFS_EXTENT_DATA_DIFFERS if data differs
+-	 */
+-	__s32 status;		/* out - see above description */
+-	__u32 reserved;
+-};
+-
+-/* from struct btrfs_ioctl_file_extent_same_args */
+-struct xfs_extent_data {
+-	__u64 logical_offset;	/* in - start of extent in source */
+-	__u64 length;		/* in - length of extent */
+-	__u16 dest_count;	/* in - total elements in info array */
+-	__u16 reserved1;
+-	__u32 reserved2;
+-	struct xfs_extent_data_info info[0];
+-};
+-
+-#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
+-#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
+-#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
+ 
+ #ifndef HAVE_BBMACROS
+ /*
+--- xfsprogs/libxfs/xfs_inode_fork.c
++++ kernel/libxfs/xfs_inode_fork.c
+@@ -XXXX,X +YYYY,Y @@
+ 	xfs_ifork_t	*ifp,		/* inode fork pointer */
+ 	int		new_size)	/* new indirection array size */
+ {
+-#ifdef DEBUG
+ 	int		nlists;		/* number of irec's (ex lists) */
+ 	int		size;		/* current indirection array size */
+ 
+@@ -XXXX,X +YYYY,Y @@
+ 	size = nlists * sizeof(xfs_ext_irec_t);
+ 	ASSERT(ifp->if_real_bytes);
+ 	ASSERT((new_size >= 0) && (new_size != size));
+-#endif
+ 	if (new_size == 0) {
+ 		xfs_iext_destroy(ifp);
+ 	} else {
+--- xfsprogs/libxfs/xfs_sb.c
++++ kernel/libxfs/xfs_sb.c
+@@ -XXXX,X +YYYY,Y @@
+ 	}
+ 
+ 	/*
++	 * Until this is fixed only page-sized or smaller data blocks work.
++	 */
++	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
++		xfs_warn(mp,
++		"File system with blocksize %d bytes. "
++		"Only pagesize (%ld) or less will currently work.",
++				sbp->sb_blocksize, PAGE_SIZE);
++		return -ENOSYS;
++	}
++
++	/*
+ 	 * Currently only very few inode sizes are supported.
+ 	 */
+ 	switch (sbp->sb_inodesize) {
+@@ -XXXX,X +YYYY,Y @@
+ 		return -EFBIG;
+ 	}
+ 
++	if (check_inprogress && sbp->sb_inprogress) {
++		xfs_warn(mp, "Offline file system operation in progress!");
++		return -EFSCORRUPTED;
++	}
+ 	return 0;
+ }
+ 
diff --git a/tools/srcdiff b/tools/srcdiff
deleted file mode 100755
index e490dfd..0000000
--- a/tools/srcdiff
+++ /dev/null
@@ -1,316 +0,0 @@
-#!/usr/bin/perl -w
-#
-# Copyright (c) 2001-2008 Silicon Graphics, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#
-#
-# srcdiff is used to compare current user level code with the current
-# kernel code and advise of any differences between files which are
-# sharing some or all of their content.
-#
-# There are two classes of sharing which we will check - header files
-# in the include directory, which must be exactly the same (use diff)
-# and source files which contain routines which must be exactly the
-# same (but the userland file is always a subset of the kernel file,
-# and hence a more flexible mechanism to "diff" is required).
-#
-# NB: to cross check that srcdiff is finding all the functions in the
-#     user source file, providing you have "mkproto" installed, you
-#     can "cd xfsprogs/libxfs" and cut&paste this in a bourne shell:
-#     $ for file in xfs_*.c; do
-#     > mkproto -nps < $file | perl -ne '
-#     > END { print "    $count\t- " }
-#     > s/^.* (xfs\w+|\*xfs\w+|xlog\w+|\*xlog\w+) \(.*/\1/ && { $count++ }'
-#     > echo $file
-#     > done
-# (compare this to "srcdiff | fgrep Total:")
-#
-
-use strict;
-
-die "WORKAREA not set" unless defined $ENV{'WORKAREA'};
-die "KWORKAREA not set" unless defined $ENV{'KWORKAREA'};
-die "DMWORKAREA not set" unless defined $ENV{'DMWORKAREA'};
-chdir $ENV{'WORKAREA'};
-my $dmworkarea = $ENV{'DMWORKAREA'};
-my $kworkarea = $ENV{'KWORKAREA'};
-my $xdiff = $ENV{'XDIFF'};
-my $quiet = 0;
-my $usage = 0;
-
-if ( ! -f "$kworkarea/xfs_fs.h" ) {
-	$kworkarea .= '/fs/xfs';
-	die "Cannot find XFS in KWORKAREA" unless -f "$kworkarea/xfs_fs.h";
-}
-die "Cannot find DMAPI in DMWORKAREA" unless -f "$dmworkarea/dmapi.h";
-
-foreach (@ARGV) {
-	if (/^-q$/) {
-		$quiet++;
-	} else {
-		print STDERR "Illegal option $_\n";
-		$usage++;
-	}
-}
-
-if ($usage) {
-    print STDERR "Usage: $0 [-q]\n";
-    exit 1;
-}
-
-my @pkglist = qw( xfstests attr acl dmapi xfsdump xfsprogs );
-my @difflist = qw(
-	xfs_ag.h  xfs_alloc.h  xfs_alloc_btree.h xfs_arch.h
-	xfs_attr_leaf.h  xfs_attr_sf.h  xfs_bit.h  xfs_bmap.h
-	xfs_bmap_btree.h  xfs_btree.h  xfs_buf_item.h
-	xfs_da_btree.h  xfs_dfrag.h  xfs_dinode.h
-	xfs_dir2.h  xfs_dir2_block.h  xfs_dir2_data.h
-	xfs_dir2_leaf.h  xfs_dir2_node.h  xfs_dir2_sf.h
-	xfs_extfree_item.h  xfs_ialloc.h
-	xfs_imap.h  xfs_ialloc_btree.h  xfs_inode.h  xfs_inode_item.h
-	xfs_inum.h  xfs_log.h  xfs_log_priv.h  xfs_log_recover.h
-	xfs_mount.h  xfs_quota.h  xfs_rtalloc.h
-	xfs_sb.h  xfs_trans.h  xfs_trans_space.h  xfs_types.h  xfs_fs.h
-);
-
-sub straightdiff {
-	my ( $file, $prefix1, $prefix2 ) = @_;
-
-	`diff $prefix1/$file $prefix2/$file >/dev/null 2>&1`;
-	if (!$quiet) {
-		print sprintf("\t%-35s ... ", $file);
-		if ($? != 0)	{ printf("FAILED\n(%s/%s differs to %s/%s)\n",
-					 $prefix1, $file, $prefix2, $file); }
-		else		{ print "ok\n"; }
-	} elsif ($? != 0) {
-	        printf("\t%-35s ... FAILED\n(%s/%s differs to %s/%s)\n",
-			$file, $prefix1, $file, $prefix2, $file);
-		if (defined($xdiff)) {
-			`$xdiff $prefix1/$file $prefix2/$file`;
-		}
-	}
-}
-
-#
-# xfstests directory m4 directory is a repository of all of the
-# custom m4 macros used in the packages we look after.
-#
-sub m4macrodiff {
-	my ( $package ) = @_;
-
-	foreach (`ls $package/m4/*.m4`) {
-		my $m4 = `basename $_`;
-		chomp($m4);
-		straightdiff $m4, "$package/m4", "xfstests/m4";
-	}
-}
-
-my $first = shift @pkglist;
-foreach (@pkglist) {
-	print "\n=== Checking $_ package ===\n";
-	m4macrodiff $_;
-	straightdiff 'buildrules', "$first/include", "$_/include";
-	straightdiff 'buildmacros', "$first/include", "$_/include";
-	straightdiff 'Makefile', "$first/build", "$_/build";
-	straightdiff 'Makefile', "$first/build/rpm", "$_/build/rpm";
-	straightdiff 'Makefile', "$first/build/tar", "$_/build/tar";
-}
-print "\n=== Checking headers ===\n";
-foreach (@difflist) {
-	straightdiff $_, 'xfsprogs/include', "$kworkarea";
-}
-straightdiff 'dmapi_kern.h', 'dmapi/include', "$dmworkarea";
-straightdiff 'dmapi.h', 'dmapi/include', "$dmworkarea";
-
-#
-# setstate
-# Implements a tri-state FSA, see comments for state transitions
-#  (knows about the way the XFS kernel code is written, & makes
-#   some assumptions so as to not need to parse generic C code).
-# Accepts one line at a time from a source file, picking out the
-#   function bodies so they can be subsequently compared.
-#
-
-my $line;	# line number in current source file
-my $state;	# current FSA state
-my $funcbody;	# current function body (contents)
-
-sub setstate {
-	my ( $newline ) = @_;
-	$line++;
-
-	# - state 0:
-	#	if line looks like start of a function, transition to 1
-	#		& squirrel line away as line 1 of current function
-	if ($state == 0) {
-		if ($newline =~ m/^[xfs|xlog]/) {
-			$state = 1;
-			$funcbody = $newline;
-		}
-	}
-
-	# - state 1:
-	#	if line looks like start of a function, stay here
-	#		& squirrel line away as line 1 of current function
-	#	otherwise if line isn't start of function body,
-	#		squirrel line away as next line of current function
-	#		(args/..., but not sure this is a real function yet)
-	#	otherwise (start of function)
-	#		squirrel line away as next line of current function
-	#		transition to state 2
-	elsif ($state == 1) {
-		if ($newline =~ m/^[xfs|xlog]/) {
-			$funcbody = $newline;
-		}
-		elsif ($newline =~ m/^\{/) {
-			$state = 2;
-			$funcbody .= $newline;
-		}
-	}
-
-	# - state 2:
-	#	if line looks like end of function body,
-	#		squirrel line away as last line of current function
-	#		tell someone we have a complete function ready
-	#		transition to state 0
-	#	otherwise
-	#		squirrel line away as next line of current function
-	elsif ($state == 2) {
-		$funcbody .= $newline;
-		if ($newline =~ m/^\}/) {
-			$state = 0;
-			return $funcbody;
-		}
-	}
-
-	else {
-		die "unknown state transition";
-	}
-	return undef;	# i.e. not at end of a function
-}
-
-sub listfuncs {
-	my ( $file ) = @_;
-	my @funcs;
-
-	$funcbody = '';
-	$state = $line = 0;
-
-	open(USER, "$file") || die "cannot open $file";
-	while (<USER>) {
-		my $func = setstate($_);
-		push @funcs, $func if (defined($func));	# store function away
-	}
-	close USER;
-	return @funcs;
-}
-
-sub hashfuncs {
-	my ( $file ) = @_;
-	my %funcs;
-
-	$funcbody = '';
-	$state = $line = 0;
-
-	open(KERN, "$file") || die "cannot open $file";
-	while (<KERN>) {
-		my $func = setstate($_);
-		if (defined($func)) {
-			$func =~ m/^([xfs|xlog]\w+)\s*\(/;
-			next unless defined($1);
-			my $name = $1;
-			if (defined($func)) {
-				$funcs{$name} = $func;	# store function away
-			}
-		}
-	}
-	close KERN;
-	return %funcs;
-}
-
-sub diffme {
-	my ( $sa, $sb ) = @_;
-
-	return unless defined($xdiff);
-
-	open(FILEA, "> /tmp/diff.user.$$") || die "cannot write to /tmp/diff.user.$$";
-	open(FILEB, "> /tmp/diff.kern.$$") || die "cannot write to /tmp/diff.kern.$$";
-	print FILEA $sa;
-	print FILEB $sb;
-	close FILEA;
-	close FILEB;
-	`$xdiff /tmp/diff.user.$$ /tmp/diff.kern.$$`;
-        unlink ("/tmp/diff.user.$$","/tmp/diff.kern.$$");
-}
-
-sub functiondiff {
-	my ( $file, $prefix1, $prefix2 ) = @_;
-	my $plural = '';
-	my $count = 0;
-	my $name;
-        my $found = 0;
-
-	print "\n=== Checking $file routines ===\n" unless ($quiet);
-
-	# iterate over user funcs, match up to kernel funcs
-	#
-	my @user = listfuncs "$prefix1/$file";
-	my %kern = hashfuncs "$prefix2/$file";
-
-	foreach my $userfunc (@user) {
-
-		$userfunc =~ m/^([xfs|xlog]\w+)\s*\(/;
-		next unless (defined($1));
-		$name = $1;
-		$count++;
-
-		if (exists($kern{$name})) {
-			if ($userfunc ne $kern{$name}) {
-	                        print "\n=== $file routines ===\n"
-                                    if (!$found++ && $quiet);
-
-			        printf("\t%-35s ... ", $name);
-				print "FAILED\n";
-				diffme $userfunc, $kern{$name};
-			}
-			elsif (!$quiet) {
-			        printf("\t%-35s ... ", $name);
-				print "ok\n";
-			}
-		}
-		else {
-			print "Cannot find kernel function $userfunc";
-			print " in file $prefix2/$file\n";
-		}
-	}
-	($count != 1) && ( $plural = 's' );
-	print "( Total: $count routine$plural checked in $file )\n" unless ($quiet);
-}
-
-# xfsprogs/{libxfs,libxlog}/* fs/xfs/*
-my @funclist = qw(
-	xfs_alloc.c  xfs_alloc_btree.c  xfs_attr.c  xfs_attr_leaf.c
-	xfs_bmap.c  xfs_bmap_btree.c  xfs_btree.c  xfs_da_btree.c
-	xfs_dir2.c  xfs_dir2_block.c  xfs_dir2_data.c xfs_dir2_leaf.c
-	xfs_dir2_node.c  xfs_dir2_sf.c xfs_ialloc.c  xfs_ialloc_btree.c
-	xfs_inode.c  xfs_mount.c  xfs_rtalloc.c xfs_trans.c
-);
-
-print "\n=== Checking libxfs code ===\n";
-foreach (@funclist) {
-	functiondiff $_, 'xfsprogs/libxfs', "$kworkarea";
-}
-print "\n=== Checking libxlog code ===\n";
-functiondiff 'xfs_log_recover.c', 'xfsprogs/libxlog', "$kworkarea";
