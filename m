Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 923E729DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 10:03:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2692AC007
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 08:03:49 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id SPZqmb6Ju2f83kfp for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 08:03:47 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7E0DE63C59BC
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 10:03:47 -0500 (CDT)
Message-ID: <517945D3.4020701@sandeen.net>
Date: Thu, 25 Apr 2013 10:03:47 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/3 V2] xfsprogs: Fix manpages for missing or incorrect options
References: <5175BB8F.5090604@sandeen.net> <5175BC67.1000902@sandeen.net>
In-Reply-To: <5175BC67.1000902@sandeen.net>
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

Add valid options which aren't in manpages, and
remove invalid options which are in manpages:

* Document -V (show version and exit) for many manpages.
* Remove -? option from xfs_estimate.8
* Document -p passes, -d (debug) and -g (syslog) in xfs_fsr.8
* Document -n (O_NONBLOCK) in xfs_io.8
* Document -v (print overwrite) in xfs_logprint.8
* Document -m max_extents in xfs_metadump.8
* Document -p (preallocate) in xfs_mkfile.8

Signed-off-by: Eric Sandeeen <sandeen@redhat.com>
---

V2: move "-V" SYNOPSIS to their own line, move -V
documentation to end of option documentation list

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index f707881..04c19b4 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -40,6 +40,8 @@ mkfs.xfs \- construct an XFS filesystem
 .B \-K
 ]
 .I device
+.br
+.B mkfs.xfs \-V
 .SH DESCRIPTION
 .B mkfs.xfs
 constructs an XFS filesystem by writing on a special
@@ -728,6 +730,9 @@ creating the file system.
 .TP
 .B \-K
 Do not attempt to discard blocks at mkfs time.
+.TP
+.B \-V
+Prints the version number and exits.
 .SH SEE ALSO
 .BR xfs (5),
 .BR mkfs (8),
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 2de907b..b393d74 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -15,6 +15,8 @@ xfs_admin \- change parameters of an XFS filesystem
 .I uuid
 ]
 .I device
+.br
+.B xfs_admin \-V
 .SH DESCRIPTION
 .B xfs_admin
 uses the
@@ -97,6 +99,9 @@ The
 may also be
 .BR generate ,
 which will generate a new UUID for the filesystem.
+.TP
+.B \-V
+Prints the version number and exits.
 .PP
 The
 .BR mount (8)
diff --git a/man/man8/xfs_bmap.8 b/man/man8/xfs_bmap.8
index ccaa79b..e196559 100644
--- a/man/man8/xfs_bmap.8
+++ b/man/man8/xfs_bmap.8
@@ -10,6 +10,8 @@ xfs_bmap \- print block mapping for an XFS file
 .I num_extents
 ]
 .I file
+.br
+.B xfs_bmap \-V
 .SH DESCRIPTION
 .B xfs_bmap
 prints the map of disk blocks used by files in an XFS filesystem.
@@ -91,6 +93,9 @@ A second
 option will print out the
 .I flags
 legend.
+.TP
+.B \-V
+Prints the version number and exits.
 .SH SEE ALSO
 .BR xfs_fsr (8),
 .BR xfs (5).
diff --git a/man/man8/xfs_check.8 b/man/man8/xfs_check.8
index 1654532..23027ca 100644
--- a/man/man8/xfs_check.8
+++ b/man/man8/xfs_check.8
@@ -20,6 +20,8 @@ xfs_check \- check XFS filesystem consistency
 .I logdev
 ]
 .I device
+.br
+.B xfs_check \-V
 .SH DESCRIPTION
 .B xfs_check
 checks whether an XFS filesystem is consistent.
@@ -89,6 +91,9 @@ Conversion between disk addresses (i.e. addresses reported by
 and file system blocks may be accomplished using
 .BR xfs_db "(8)'s " convert
 command.
+.TP
+.B \-V
+Prints the version number and exits.
 .PP
 Any output that is produced when
 .B xfs_check
diff --git a/man/man8/xfs_copy.8 b/man/man8/xfs_copy.8
index 3028db8..1eaf85d 100644
--- a/man/man8/xfs_copy.8
+++ b/man/man8/xfs_copy.8
@@ -13,6 +13,8 @@ xfs_copy \- copy the contents of an XFS filesystem
 [
 .I target2
 \&... ]
+.br
+.B xfs_copy \-V
 .SH DESCRIPTION
 .B xfs_copy
 copies an XFS filesystem to one or more targets in parallel (see
@@ -87,6 +89,9 @@ Specifies the location of the
 if the default location of
 .I /var/tmp/xfs_copy.log.XXXXXX
 is not desired.
+.TP
+.B \-V
+Prints the version number and exits.
 .SH DIAGNOSTICS
 .B xfs_copy
 reports errors to both
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 0558671..7a43a2c 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -103,7 +103,7 @@ and
 commands.
 .TP
 .B \-V
-Prints out the current version number and exits.
+Prints the version number and exits.
 .SH CONCEPTS
 .B xfs_db
 commands can be broken up into two classes. Most commands are for
diff --git a/man/man8/xfs_estimate.8 b/man/man8/xfs_estimate.8
index bb458ec..2594eb8 100644
--- a/man/man8/xfs_estimate.8
+++ b/man/man8/xfs_estimate.8
@@ -3,8 +3,10 @@
 xfs_estimate \- estimate the space that an XFS filesystem will take
 .SH SYNOPSIS
 .nf
-\f3xfs_estimate\f1 [ \f3\-h?\f1 ] [ \f3\-b\f1 blocksize ] [ \f3\-i\f1 logsize ]
+\f3xfs_estimate\f1 [ \f3\-h\f1 ] [ \f3\-b\f1 blocksize ] [ \f3\-i\f1 logsize ]
 		   [ \f3\-e\f1 logsize ] [ \f3\-v\f1 ] directory ...
+.br
+.B xfs_estimate \-V
 .fi
 .SH DESCRIPTION
 For each \f2directory\f1 argument,
@@ -51,9 +53,6 @@ Display more information, formatted.
 .B \-h
 Display usage message.
 .TP
-.B \-?
-Display usage message.
-.TP
 \f3\-i, \-e\f1 \f2logsize\f1
 Use
 .I logsize
@@ -77,6 +76,9 @@ For example,
 .IP
 requests an estimate of the space required by the directory / on an
 XFS filesystem using an internal log of 1 megabyte.
+.TP
+.B \-V
+Print the version number and exits.
 .SH EXAMPLES
 .nf
 .sp 8v
diff --git a/man/man8/xfs_freeze.8 b/man/man8/xfs_freeze.8
index 97c7911..c581ad7 100644
--- a/man/man8/xfs_freeze.8
+++ b/man/man8/xfs_freeze.8
@@ -2,10 +2,15 @@
 .SH NAME
 xfs_freeze \- suspend access to an XFS filesystem
 .SH SYNOPSIS
-.B xfs_freeze \-f
+.B xfs_freeze
+[
+.B \-f
 |
 .B \-u
+]
 .I mount-point
+.br
+.B xfs_freeze \-V
 .fi
 .SH DESCRIPTION
 .B xfs_freeze
@@ -25,6 +30,7 @@ is mounted.
 The filesystem must be mounted to be frozen (see
 .BR mount (8)).
 .PP
+.PP
 The
 .B \-f
 flag requests the specified XFS filesystem to be
@@ -48,7 +54,13 @@ operations to continue.
 Any filesystem modifications that were blocked by the freeze are
 unblocked and allowed to complete.
 .PP
-One of
+The
+.B \-V
+flag prints the version number and exits.
+.PP
+Unless
+.B \-V
+is specified, one of
 .B \-f
 or
 .B \-u
diff --git a/man/man8/xfs_fsr.8 b/man/man8/xfs_fsr.8
index bf5e942..0a162b6 100644
--- a/man/man8/xfs_fsr.8
+++ b/man/man8/xfs_fsr.8
@@ -3,10 +3,12 @@
 xfs_fsr \- filesystem reorganizer for XFS
 .SH SYNOPSIS
 .nf
-\f3xfs_fsr\f1 [\f3\-v\f1] \c
-[\f3\-t\f1 seconds] [\f3\-f\f1 leftoff] [\f3\-m\f1 mtab]
-\f3xfs_fsr\f1 [\f3\-v\f1] \c
+\f3xfs_fsr\f1 [\f3\-vdg\f1] \c
+[\f3\-t\f1 seconds] [\f3\-p\f1 passes] [\f3\-f\f1 leftoff] [\f3\-m\f1 mtab]
+\f3xfs_fsr\f1 [\f3\-vdg\f1] \c
 [xfsdev | file] ...
+.br
+.B xfs_fsr \-V
 .fi
 .SH DESCRIPTION
 .I xfs_fsr
@@ -35,7 +37,11 @@ The default is to use
 .TP
 .BI \-t " seconds"
 How long to reorganize.
-The default is 7200 (2 hours).
+The default is 7200 seconds (2 hours).
+.TP
+.BI \-p " passes"
+Number of passes before terminating global re-org.
+The default is 10 passes.
 .TP
 .BI \-f " leftoff"
 Use this file instead of
@@ -47,6 +53,16 @@ to store the state of where reorganization left off.
 Verbose.
 Print cryptic information about
 each file being reorganized.
+.TP
+.B \-d
+Debug.  Print even more cryptic information.
+.TP
+.B \-g
+Print to syslog (default if stdout not a tty).
+.TP
+.B \-V
+Prints the version number and exits.
+
 .PP
 When invoked with no arguments
 .I xfs_fsr
diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
index b55438b..e23d30e 100644
--- a/man/man8/xfs_growfs.8
+++ b/man/man8/xfs_growfs.8
@@ -15,7 +15,7 @@ xfs_growfs, xfs_info \- expand an XFS filesystem
 .SH SYNOPSIS
 .B xfs_growfs
 [
-.B \-dilnrxV
+.B \-dilnrx
 ] [
 .B \-D
 .I size
@@ -37,12 +37,17 @@ xfs_growfs, xfs_info \- expand an XFS filesystem
 ]
 .I mount-point
 .br
+.B xfs_growfs \-V
+.PP
+.br
 .B xfs_info
 [
 .B \-t
 .I mtab
 ]
 .I mount-point
+.br
+.B xfs_info \-V
 .SH DESCRIPTION
 .B xfs_growfs
 expands an existing XFS filesystem (see
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 33a5944..5e3535b 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -13,6 +13,8 @@ xfs_io \- debug the I/O path of an XFS filesystem
 .I prog
 ]
 .I file
+.br
+.B xfs_io \-V
 .SH DESCRIPTION
 .B xfs_io
 is a debugging tool like
@@ -52,6 +54,9 @@ is immutable or append-only.
 .B \-x
 Expert mode. Dangerous commands are only available in this mode.
 These commands also tend to require additional privileges.
+.TP
+.B \-V
+Prints the version number and exits.
 .PP
 The other
 .BR open (2)
@@ -111,6 +116,9 @@ opens for synchronous I/O (O_SYNC).
 .B \-t
 truncates on open (O_TRUNC).
 .TP
+.B \-n
+opens in non-blocking mode if possible (O_NONBLOCK).
+.TP
 .B \-R
 marks the file as a realtime XFS file after
 opening it, if it is not already marked as such.
diff --git a/man/man8/xfs_logprint.8 b/man/man8/xfs_logprint.8
index c1a8077..16e881e 100644
--- a/man/man8/xfs_logprint.8
+++ b/man/man8/xfs_logprint.8
@@ -97,6 +97,12 @@ Override any notion of where to start printing.
 .TP
 .B \-t
 Print out the transactional view.
+.TP
+.B \-v
+Print "overwrite" data.
+.TP
+.B \-V
+Prints the version number and exits.
 .SH SEE ALSO
 .BR mkfs.xfs (8),
 .BR mount (8).
diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index 7b9ba89..51297c4 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -8,6 +8,8 @@ xfs_mdrestore \- restores an XFS metadump image to a filesystem image
 ]
 .I source
 .I target
+.br
+.B xfs_mdrestore \-V
 .SH DESCRIPTION
 .B xfs_mdrestore
 is a debugging tool that restores a metadata image generated by
@@ -36,6 +38,9 @@ can be destroyed.
 .TP
 .B \-g
 Shows restore progress on stdout.
+.TP
+.B \-V
+Prints the version number and exits.
 .SH DIAGNOSTICS
 .B xfs_mdrestore
 returns an exit code of 0 if all the metadata is successfully restored or
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 9672713..26cea97 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -6,11 +6,17 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 [
 .B \-efgow
 ] [
+.B \-m
+.I max_extents
+]
+] [
 .B \-l
 .I logdev
 ]
 .I source
 .I target
+.br
+.B xfs_metadump \-V
 .SH DESCRIPTION
 .B xfs_metadump
 is a debugging tool that copies the metadata from an XFS filesystem to a file.
@@ -94,12 +100,20 @@ For filesystems which use an external log, this specifies the device where the
 external log resides. The external log is not copied, only internal logs are
 copied.
 .TP
+.B \-m
+Set the maximum size of an allowed metadata extent.  Extremely large metadata
+extents are likely to be corrupt, and will be skipped if they exceed
+this value.  The default size is 1000 blocks.
+.TP
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
 .B \-w
 Prints warnings of inconsistent metadata encountered to stderr. Bad metadata
 is still copied.
+.TP
+.B \-V
+Prints the version number and exits.
 .SH DIAGNOSTICS
 .B xfs_metadump
 returns an exit code of 0 if all readable metadata is successfully copied or
diff --git a/man/man8/xfs_mkfile.8 b/man/man8/xfs_mkfile.8
index 96f443f..abaa4e6 100644
--- a/man/man8/xfs_mkfile.8
+++ b/man/man8/xfs_mkfile.8
@@ -7,10 +7,14 @@ xfs_mkfile \- create an XFS file
 .B \-v
 ] [
 .B \-n
+] [
+.B \-p
 ]
 .I size\c
 .RB [ k | b | m | g ]
 .IR filename " ..."
+.br
+.B xfs_mkfile \-V
 .SH DESCRIPTION
 .B xfs_mkfile
 creates one or more files. The file is padded with zeroes by default.
@@ -30,3 +34,10 @@ Verbose. Report the names and sizes of created files.
 .B \-n
 No bytes. Create a holey file - that is, do not write out any data, just
 seek to end of file and write a block.
+.TP
+.B \-p
+Preallocate.  The file is preallocated, then overwritten with zeroes,
+then truncated to the desired size.
+.TP
+.B \-V
+Prints the version number and exits.
diff --git a/man/man8/xfs_ncheck.8 b/man/man8/xfs_ncheck.8
index 408919d..4099772 100644
--- a/man/man8/xfs_ncheck.8
+++ b/man/man8/xfs_ncheck.8
@@ -15,6 +15,8 @@ xfs_ncheck \- generate pathnames from i-numbers for XFS
 .I logdev
 ]
 .I device
+.br
+.B xfs_ncheck \-V
 .SH DESCRIPTION
 .B xfs_ncheck
 with no
@@ -56,6 +58,9 @@ This option may be used to detect violations of security policy.
 .BI \-i " ino"
 Limits the report to only those files whose inode numbers follow.
 May be given multiple times to select multiple inode numbers.
+.TP
+.B \-V
+Prints the version number and exits.
 .PP
 If the filesystem is seriously corrupted, or very busy and looks
 like it is corrupt, a message of the form that would be generated by
diff --git a/man/man8/xfs_quota.8 b/man/man8/xfs_quota.8
index 9327feb..8cc8ab7 100644
--- a/man/man8/xfs_quota.8
+++ b/man/man8/xfs_quota.8
@@ -16,6 +16,8 @@ xfs_quota \- manage use of quota on XFS filesystems
 .I project
 ] ... [
 .IR path " ... ]"
+.br
+.B xfs_quota \-V
 .SH DESCRIPTION
 .B xfs_quota
 is a utility for reporting and editing various aspects of filesystem quota.
@@ -50,6 +52,9 @@ which restricts the output of the individual
 commands to the set of projects specified. Multiple
 .B \-d
 arguments may be given.
+.TP
+.B \-V
+Prints the version number and exits.
 .PP
 The optional
 .I path
diff --git a/man/man8/xfs_repair.8 b/man/man8/xfs_repair.8
index 7b296ba..96adb29 100644
--- a/man/man8/xfs_repair.8
+++ b/man/man8/xfs_repair.8
@@ -173,7 +173,7 @@ to repair an XFS filesystem mounted read only. This is typically done
 on a root filesystem from single user mode, immediately followed by a reboot.
 .TP
 .B \-V
-Prints out the current version number and exits.
+Prints the version number and exits.
 .SS Checks Performed
 Inconsistencies corrected include the following:
 .IP 1.
diff --git a/man/man8/xfs_rtcp.8 b/man/man8/xfs_rtcp.8
index be81cb3..40e9097 100644
--- a/man/man8/xfs_rtcp.8
+++ b/man/man8/xfs_rtcp.8
@@ -10,6 +10,8 @@ xfs_rtcp \- XFS realtime copy command
 .B -p
 ]
 .IR source " ... " target
+.br
+.B xfs_rtcp \-V
 .SH DESCRIPTION
 .B xfs_rtcp
 copies a file to the realtime partition on an XFS filesystem.
@@ -35,6 +37,9 @@ will pad the destination file to a size which is an even multiple
 of the filesystem block size.
 This is necessary since the realtime file is created using
 direct I/O and the minimum I/O is the filesystem block size.
+.TP
+.B \-V
+Prints the version number and exits.
 .SH SEE ALSO
 .BR xfs (5),
 .BR mkfs.xfs (8),


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
