Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B1D207F51
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 23:59:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9527A8F8039
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 21:59:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9lLblj5e4PQYwjc5 for
	<xfs@oss.sgi.com>; Thu, 08 May 2014 21:59:22 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s494xKNk030822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 9 May 2014 00:59:21 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s494xJB4027217
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 9 May 2014 00:59:20 -0400
Message-ID: <536C60AC.9080306@redhat.com>
Date: Thu, 08 May 2014 23:59:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: remove xfs_check
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This removes xfs_check and all references to it in
manpages.  The DIAGNOSTICS section from xfs_check(8)
has been moved to xfs_db(8).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

If you realllly don't want this in 3.2.0, so be it, but
here's the patch for whenever.  ;)

diff --git a/db/Makefile b/db/Makefile
index 9485b82..bae6154 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -14,7 +14,7 @@ HFILES = addr.h agf.h agfl.h agi.h attr.h attrshort.h bit.h block.h bmap.h \
 	io.h malloc.h metadump.h output.h print.h quit.h sb.h sig.h strvec.h \
 	text.h type.h write.h attrset.h symlink.h
 CFILES = $(HFILES:.h=.c)
-LSRCFILES = xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh
+LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
@@ -38,7 +38,6 @@ install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
 	$(INSTALL) -m 755 xfs_admin.sh $(PKG_SBIN_DIR)/xfs_admin
-	$(INSTALL) -m 755 xfs_check.sh $(PKG_SBIN_DIR)/xfs_check
 	$(INSTALL) -m 755 xfs_ncheck.sh $(PKG_SBIN_DIR)/xfs_ncheck
 	$(INSTALL) -m 755 xfs_metadump.sh $(PKG_SBIN_DIR)/xfs_metadump
 install-dev:
diff --git a/db/xfs_check.sh b/db/xfs_check.sh
deleted file mode 100755
index 553da63..0000000
--- a/db/xfs_check.sh
+++ /dev/null
@@ -1,42 +0,0 @@
-#!/bin/sh -f
-#
-# Copyright (c) 2000-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-
-OPTS=" "
-DBOPTS=" "
-USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
-
-echo "xfs_check is deprecated and scheduled for removal in June 2014."
-echo "Please use xfs_repair -n <dev> instead."
-
-while getopts "b:fi:l:stvV" c
-do
-	case $c in
-	s)	OPTS=$OPTS"-s ";;
-	t)	OPTS=$OPTS"-t ";;
-	v)	OPTS=$OPTS"-v ";;
-	i)	OPTS=$OPTS"-i "$OPTARG" ";;
-	b)	OPTS=$OPTS"-b "$OPTARG" ";;
-	f)	DBOPTS=$DBOPTS" -f";;
-	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
-	V)	xfs_db -p xfs_check -V
-		status=$?
-		exit $status
-		;;
-	\?)	echo $USAGE 1>&2
-		exit 2
-		;;
-	esac
-done
-set -- extra $@
-shift $OPTIND
-case $# in
-	1)	xfs_db$DBOPTS -F -i -p xfs_check -c "check$OPTS" $1
-		status=$?
-		;;
-	*)	echo $USAGE 1>&2
-		exit 2
-		;;
-esac
-exit $status
diff --git a/man/man8/xfs_check.8 b/man/man8/xfs_check.8
deleted file mode 100644
index 23027ca..0000000
--- a/man/man8/xfs_check.8
+++ /dev/null
@@ -1,203 +0,0 @@
-.TH xfs_check 8
-.SH NAME
-xfs_check \- check XFS filesystem consistency
-.SH SYNOPSIS
-.B xfs_check
-[
-.B \-i
-.I ino
-] ... [
-.B \-b
-.I bno
-] ... [
-.B \-f
-] [
-.B \-s
-] [
-.B \-v
-] [
-.B \-l
-.I logdev
-]
-.I device
-.br
-.B xfs_check \-V
-.SH DESCRIPTION
-.B xfs_check
-checks whether an XFS filesystem is consistent.
-It is normally run only when there is reason to believe that the
-filesystem has a consistency problem.
-The filesystem to be checked is specified by the
-.I device
-argument, which should be the disk or volume device for the filesystem.
-Filesystems stored in files can also be checked, using the
-.B \-f
-flag. The filesystem should normally be unmounted or read-only
-during the execution of
-.BR xfs_check .
-Otherwise, spurious problems are reported.
-.PP
-Note that
-.B xfs_check
-is deprecated and scheduled for removal in June 2014. Please use
-.BR xfs_repair " " \-n
-instead.
-.SH
-OPTIONS
-.TP
-.B \-f
-Specifies that the filesystem image to be processed is stored in a
-regular file at
-.I device
-(see the
-.BR mkfs.xfs "(8) " \-d
-.I file
-option). This might happen if an image copy
-of a filesystem has been made into an ordinary file.
-.TP
-.BI \-l " logdev"
-Specifies the device where the filesystem's external log resides.
-Only for those filesystems which use an external log. See the
-.BR mkfs.xfs "(8) " \-l
-option, and refer to
-.BR xfs (5)
-for a detailed description of the XFS log.
-.TP
-.B \-s
-Specifies that only serious errors should be reported.
-Serious errors are those that make it impossible to find major data
-structures in the filesystem. This option can be used to cut down the
-amount of output when there is a serious problem, when the output
-might make it difficult to see what the real problem is.
-.TP
-.B \-v
-Specifies verbose output; it is impossibly long for a
-reasonably-sized filesystem.
-This option is intended for internal use only.
-.TP
-.BI \-i " ino"
-Specifies verbose behavior for the specified inode
-.IR ino .
-For instance, it can be used to locate all the blocks
-associated with a given inode.
-.TP
-.BI \-b " bno"
-Specifies verbose behavior for the specific filesystem block at
-.IR bno .
-For instance, it can be used to determine what a specific block
-is used for. The block number is a "file system block number".
-Conversion between disk addresses (i.e. addresses reported by
-.BR xfs_bmap (8))
-and file system blocks may be accomplished using
-.BR xfs_db "(8)'s " convert
-command.
-.TP
-.B \-V
-Prints the version number and exits.
-.PP
-Any output that is produced when
-.B xfs_check
-is not run in verbose mode indicates that the filesystem has an
-inconsistency. The filesystem can be repaired using either
-.BR xfs_repair (8)
-to fix the filesystem in place, or by using
-.BR xfsdump (8)
-and
-.BR mkfs.xfs (8)
-to dump the filesystem, make a new filesystem, then use
-.BR xfsrestore (8)
-to restore the data onto the new filesystem.
-Note that xfsdump may fail on a corrupt filesystem.
-However, if the filesystem is mountable, xfsdump can
-be used to try and save important data before
-repairing the filesystem with xfs_repair.
-If the filesystem is not mountable though, xfs_repair is
-the only viable option.
-.SH DIAGNOSTICS
-If the filesystem is completely corrupt, a core dump might
-be produced instead of the message
-.RS
-.I device
-.B is not a valid filesystem
-.RE
-.PP
-If the filesystem is very large (has many files) then
-.B xfs_check
-might run out of memory. In this case the message
-.RS
-.B out of memory
-.RE
-is printed.
-.PP
-The following is a description of the most likely problems and the associated
-messages.
-Most of the diagnostics produced are only meaningful with an understanding
-of the structure of the filesystem.
-.TP
-.BI "agf_freeblks " n ", counted " m " in ag " a
-The freeblocks count in the allocation group header for allocation group
-.I a
-doesn't match the number of blocks counted free.
-.TP
-.BI "agf_longest " n ", counted " m " in ag " a
-The longest free extent in the allocation group header for allocation group
-.I a
-doesn't match the longest free extent found in the allocation group.
-.TP
-.BI "agi_count " n ", counted " m " in ag " a
-The allocated inode count in the allocation group header for allocation group
-.I a
-doesn't match the number of inodes counted in the allocation group.
-.TP
-.BI "agi_freecount " n ", counted " m " in ag " a
-The free inode count in the allocation group header for allocation group
-.I a
-doesn't match the number of inodes counted free in the allocation group.
-.TP
-.BI "block " a/b " expected inum 0 got " i
-The block number is specified as a pair
-(allocation group number, block in the allocation group).
-The block is used multiple times (shared), between multiple inodes.
-This message usually follows a message of the next type.
-.TP
-.BI "block " a/b " expected type unknown got " y
-The block is used multiple times (shared).
-.TP
-.BI "block " a/b " type unknown not expected
-The block is unaccounted for (not in the freelist and not in use).
-.TP
-.BI "link count mismatch for inode " nnn " (name " xxx "), nlink " m ", counted " n
-The inode has a bad link count (number of references in directories).
-.TP
-.BI "rtblock " b " expected inum 0 got " i
-The block is used multiple times (shared), between multiple inodes.
-This message usually follows a message of the next type.
-.TP
-.BI "rtblock " b " expected type unknown got " y
-The real-time block is used multiple times (shared).
-.TP
-.BI "rtblock " b " type unknown not expected
-The real-time block is unaccounted for (not in the freelist and not in use).
-.TP
-.BI "sb_fdblocks " n ", counted " m
-The number of free data blocks recorded
-in the superblock doesn't match the number counted free in the filesystem.
-.TP
-.BI "sb_frextents " n ", counted " m
-The number of free real-time extents recorded
-in the superblock doesn't match the number counted free in the filesystem.
-.TP
-.BI "sb_icount " n ", counted " m
-The number of allocated inodes recorded
-in the superblock doesn't match the number allocated in the filesystem.
-.TP
-.BI "sb_ifree " n ", counted " m
-The number of free inodes recorded
-in the superblock doesn't match the number free in the filesystem.
-.SH SEE ALSO
-.BR mkfs.xfs (8),
-.BR xfsdump (8),
-.BR xfsrestore (8),
-.BR xfs_ncheck (8),
-.BR xfs_repair (8),
-.BR xfs (5).
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 7a43a2c..4d8d4ff 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -38,8 +38,7 @@ commands may be run interactively (the default) or as arguments
 on the command line. Multiple
 .B \-c
 arguments may be given. The commands are run in the sequence given,
-then the program exits. This is the mechanism used to implement
-.BR xfs_check (8).
+then the program exits.
 .TP
 .B \-f
 Specifies that the filesystem image to be processed is stored in a
@@ -56,14 +55,11 @@ an ordinary file with
 .B \-F
 Specifies that we want to continue even if the superblock magic is not
 correct.  For use in
-.BR xfs_check
-and
 .BR xfs_metadump .
 .TP
 .B \-i
 Allows execution on a mounted filesystem, provided it is mounted read-only.
-Useful for shell scripts such as
-.BR xfs_check (8),
+Useful for shell scripts
 which must only operate on filesystems in a guaranteed consistent state
 (either unmounted or mounted read-only). These semantics are slightly
 different to that of the
@@ -204,9 +200,7 @@ command can be given, presumably with different arguments than the previous one.
 Get block usage and check filesystem consistency.
 The information is saved for use by a subsequent
 .BR blockuse ", " ncheck ", or " blocktrash
-command. See
-.BR xfs_check (8)
-for more information.
+command.
 .RS 1.0i
 .TP 0.4i
 .B \-b
@@ -244,7 +238,7 @@ Trashing occurs to randomly selected bits in the chosen blocks.
 This command is available only in debugging versions of
 .BR xfs_db .
 It is useful for testing
-.BR xfs_repair "(8) and " xfs_check (8).
+.BR xfs_repair "(8).
 .RS 1.0i
 .TP 0.4i
 .BR \-0 " | " -1 " | " -2 " | " -3
@@ -1856,12 +1850,60 @@ and printable ASCII chars.
 Many messages can come from the
 .B check
 .RB ( blockget )
-command; these are documented in
-.BR xfs_check (8).
+command.
+If the filesystem is completely corrupt, a core dump might
+be produced instead of the message
+.RS
+.I device
+.B is not a valid filesystem
+.RE
+.PP
+If the filesystem is very large (has many files) then
+.B check
+might run out of memory. In this case the message
+.RS
+.B out of memory
+.RE
+is printed.
+.PP
+The following is a description of the most likely problems and the associated
+messages.
+Most of the diagnostics produced are only meaningful with an understanding
+of the structure of the filesystem.
+.TP
+.BI "agf_freeblks " n ", counted " m " in ag " a
+The freeblocks count in the allocation group header for allocation group
+.I a
+doesn't match the number of blocks counted free.
+.TP
+.BI "agf_longest " n ", counted " m " in ag " a
+The longest free extent in the allocation group header for allocation group
+.I a
+doesn't match the longest free extent found in the allocation group.
+.TP
+.BI "agi_count " n ", counted " m " in ag " a
+The allocated inode count in the allocation group header for allocation group
+.I a
+doesn't match the number of inodes counted in the allocation group.
+.TP
+.BI "agi_freecount " n ", counted " m " in ag " a
+The free inode count in the allocation group header for allocation group
+.I a
+doesn't match the number of inodes counted free in the allocation group.
+.TP
+.BI "block " a/b " expected inum 0 got " i
+The block number is specified as a pair
+(allocation group number, block in the allocation group).
+The block is used multiple times (shared), between multiple inodes.
+This message usually follows a message of the next type.
+.TP
+.BI "block " a/b " expected type unknown got " y
+The block is used multiple times (shared).
+.TP
+.BI "block " a/b " type unknown not expected
 .SH SEE ALSO
 .BR mkfs.xfs (8),
 .BR xfs_admin (8),
-.BR xfs_check (8),
 .BR xfs_copy (8),
 .BR xfs_logprint (8),
 .BR xfs_metadump (8),
diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 51297c4..0957d81 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -48,7 +48,6 @@ returns an exit code of 0 if all the metadata is successfully restored or
 .SH SEE ALSO
 .BR xfs_metadump (8),
 .BR xfs_repair (8),
-.BR xfs_check (8),
 .BR xfs (5)
 .SH BUGS
 Email bug reports to
diff --git a/man/man8/xfs_ncheck.8 b/man/man8/xfs_ncheck.8
index 4099772..5ae72b2 100644
--- a/man/man8/xfs_ncheck.8
+++ b/man/man8/xfs_ncheck.8
@@ -63,13 +63,12 @@ May be given multiple times to select multiple inode numbers.
 Prints the version number and exits.
 .PP
 If the filesystem is seriously corrupted, or very busy and looks
-like it is corrupt, a message of the form that would be generated by
-.BR xfs_check (8)
-may appear.
+like it is corrupt, a message of the form that would be generated by the
+.BR xfs_db (8)
+"check" command may appear.
 .PP
 .B xfs_ncheck
 is only useful with XFS filesystems.
 .SH SEE ALSO
 .BR mkfs.xfs (8),
-.BR xfs_check (8),
 .BR xfs (5).
diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index b7c2d8c..0394c50 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -548,6 +548,5 @@ fixed and/or improved.
 .BR mkfs.xfs (8),
 .BR umount (8),
 .BR xfs_admin (8),
-.BR xfs_check (8),
 .BR xfs_metadump (8),
 .BR xfs (5).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
