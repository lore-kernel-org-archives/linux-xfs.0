Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9A3407F50
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 17:40:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 68382304053
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 15:40:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BP3GoehZU6T8N3Ld for <xfs@oss.sgi.com>;
	Mon, 22 Apr 2013 15:40:39 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 539D463BCC66
	for <xfs@oss.sgi.com>; Mon, 22 Apr 2013 17:40:39 -0500 (CDT)
Message-ID: <5175BC67.1000902@sandeen.net>
Date: Mon, 22 Apr 2013 17:40:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/3] xfsprogs: Fix manpages for missing or incorrect options
References: <5175BB8F.5090604@sandeen.net>
In-Reply-To: <5175BB8F.5090604@sandeen.net>
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

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 7f3a4b4..add48cb 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -38,6 +38,8 @@ mkfs.xfs \- construct an XFS filesystem
 .B \-N
 ] [
 .B \-K
+] [
+.B \-V
 ]
 .I device
 .SH DESCRIPTION
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
index 2de907b..4b476f5 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -4,7 +4,7 @@ xfs_admin \- change parameters of an XFS filesystem
 .SH SYNOPSIS
 .B xfs_admin
 [
-.B \-eflpu
+.B \-eflpuV
 ] [
 .BR "\-c 0" | 1
 ] [
@@ -97,6 +97,9 @@ The
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
index ccaa79b..7a1e948 100644
--- a/man/man8/xfs_bmap.8
+++ b/man/man8/xfs_bmap.8
@@ -4,7 +4,7 @@ xfs_bmap \- print block mapping for an XFS file
 .SH SYNOPSIS
 .B xfs_bmap
 [
-.B \-adlpv
+.B \-adlpvV
 ] [
 .B \-n
 .I num_extents
@@ -91,6 +91,9 @@ A second
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
index 1654532..6168f2e 100644
--- a/man/man8/xfs_check.8
+++ b/man/man8/xfs_check.8
@@ -16,6 +16,8 @@ xfs_check \- check XFS filesystem consistency
 ] [
 .B \-v
 ] [
+.B \-V
+] [
 .B \-l
 .I logdev
 ]
@@ -73,6 +75,9 @@ Specifies verbose output; it is impossibly long for a
 reasonably-sized filesystem.
 This option is intended for internal use only.
 .TP
+.B \-V
+Prints the version number and exits.
+.TP
 .BI \-i " ino"
 Specifies verbose behavior for the specified inode
 .IR ino .
diff --git a/man/man8/xfs_copy.8 b/man/man8/xfs_copy.8
index 3028db8..35edace 100644
--- a/man/man8/xfs_copy.8
+++ b/man/man8/xfs_copy.8
@@ -4,7 +4,7 @@ xfs_copy \- copy the contents of an XFS filesystem
 .SH SYNOPSIS
 .B xfs_copy
 [
-.B \-bd
+.B \-bdV
 ] [
 .B \-L
 .I log
@@ -81,6 +81,9 @@ The buffered option can be used to ensure direct IO is not attempted
 to any of the target files. This is useful when the filesystem holding
 the target file does not support direct IO.
 .TP
+.B \-V
+Prints the version number and exits.
+.TP
 .BI \-L " log"
 Specifies the location of the
 .I log
diff --git a/man/man8/xfs_estimate.8 b/man/man8/xfs_estimate.8
index bb458ec..ca86d46 100644
--- a/man/man8/xfs_estimate.8
+++ b/man/man8/xfs_estimate.8
@@ -3,7 +3,7 @@
 xfs_estimate \- estimate the space that an XFS filesystem will take
 .SH SYNOPSIS
 .nf
-\f3xfs_estimate\f1 [ \f3\-h?\f1 ] [ \f3\-b\f1 blocksize ] [ \f3\-i\f1 logsize ]
+\f3xfs_estimate\f1 [ \f3\-h\f1 ] [ \f3\-b\f1 blocksize ] [ \f3\-i\f1 logsize ]
 		   [ \f3\-e\f1 logsize ] [ \f3\-v\f1 ] directory ...
 .fi
 .SH DESCRIPTION
@@ -51,9 +51,6 @@ Display more information, formatted.
 .B \-h
 Display usage message.
 .TP
-.B \-?
-Display usage message.
-.TP
 \f3\-i, \-e\f1 \f2logsize\f1
 Use
 .I logsize
diff --git a/man/man8/xfs_freeze.8 b/man/man8/xfs_freeze.8
index 97c7911..d36eb60 100644
--- a/man/man8/xfs_freeze.8
+++ b/man/man8/xfs_freeze.8
@@ -2,9 +2,14 @@
 .SH NAME
 xfs_freeze \- suspend access to an XFS filesystem
 .SH SYNOPSIS
-.B xfs_freeze \-f
+.B xfs_freeze
+[
+.B \-V
+] [
+.B \-f
 |
 .B \-u
+]
 .I mount-point
 .fi
 .SH DESCRIPTION
@@ -26,6 +31,10 @@ The filesystem must be mounted to be frozen (see
 .BR mount (8)).
 .PP
 The
+.B \-V
+flag prints the version number and exits.
+.PP
+The
 .B \-f
 flag requests the specified XFS filesystem to be
 frozen from new modifications.
@@ -48,7 +57,9 @@ operations to continue.
 Any filesystem modifications that were blocked by the freeze are
 unblocked and allowed to complete.
 .PP
-One of
+Unless
+.B \-V
+is specified, one of
 .B \-f
 or
 .B \-u
diff --git a/man/man8/xfs_fsr.8 b/man/man8/xfs_fsr.8
index bf5e942..f365274 100644
--- a/man/man8/xfs_fsr.8
+++ b/man/man8/xfs_fsr.8
@@ -3,9 +3,9 @@
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
 .fi
 .SH DESCRIPTION
@@ -35,7 +35,11 @@ The default is to use
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
@@ -47,6 +51,12 @@ to store the state of where reorganization left off.
 Verbose.
 Print cryptic information about
 each file being reorganized.
+.TP
+.B \-d
+Debug.  Print even more cryptic information.
+.TP
+.B \-g
+Print to syslog (default if stdout not a tty).
 .PP
 When invoked with no arguments
 .I xfs_fsr
diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
index b55438b..f7a82e9 100644
--- a/man/man8/xfs_growfs.8
+++ b/man/man8/xfs_growfs.8
@@ -39,6 +39,8 @@ xfs_growfs, xfs_info \- expand an XFS filesystem
 .br
 .B xfs_info
 [
+.B \-V
+] [
 .B \-t
 .I mtab
 ]
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 33a5944..0d572c7 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -4,7 +4,7 @@ xfs_io \- debug the I/O path of an XFS filesystem
 .SH SYNOPSIS
 .B xfs_io
 [
-.B \-adfmrRstx
+.B \-adfmrRstxV
 ] [
 .B \-c
 .I cmd
@@ -52,6 +52,9 @@ is immutable or append-only.
 .B \-x
 Expert mode. Dangerous commands are only available in this mode.
 These commands also tend to require additional privileges.
+.TP
+.B \-V
+Prints the version number and exits.
 .PP
 The other
 .BR open (2)
@@ -111,6 +114,9 @@ opens for synchronous I/O (O_SYNC).
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
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 9672713..b2c718a 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -6,6 +6,10 @@ xfs_metadump \- copy XFS filesystem metadata to a file
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
@@ -94,6 +98,11 @@ For filesystems which use an external log, this specifies the device where the
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
diff --git a/man/man8/xfs_mkfile.8 b/man/man8/xfs_mkfile.8
index 96f443f..1d2c501 100644
--- a/man/man8/xfs_mkfile.8
+++ b/man/man8/xfs_mkfile.8
@@ -7,6 +7,10 @@ xfs_mkfile \- create an XFS file
 .B \-v
 ] [
 .B \-n
+] [
+.B \-p
+] [
+.B \-V
 ]
 .I size\c
 .RB [ k | b | m | g ]
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
index 408919d..dfaed6a 100644
--- a/man/man8/xfs_ncheck.8
+++ b/man/man8/xfs_ncheck.8
@@ -11,6 +11,8 @@ xfs_ncheck \- generate pathnames from i-numbers for XFS
 ] [
 .B \-s
 ] [
+.B \-V
+] [
 .B \-l
 .I logdev
 ]
@@ -53,6 +55,9 @@ for a detailed description of the XFS log.
 Limits the report to special files and files with setuserid mode.
 This option may be used to detect violations of security policy.
 .TP
+.B \-V
+Prints the version number and exits.
+.TP
 .BI \-i " ino"
 Limits the report to only those files whose inode numbers follow.
 May be given multiple times to select multiple inode numbers.
diff --git a/man/man8/xfs_rtcp.8 b/man/man8/xfs_rtcp.8
index be81cb3..22ba12d 100644
--- a/man/man8/xfs_rtcp.8
+++ b/man/man8/xfs_rtcp.8
@@ -8,6 +8,8 @@ xfs_rtcp \- XFS realtime copy command
 .I extsize
 ] [
 .B -p
+] [
+.B -V
 ]
 .IR source " ... " target
 .SH DESCRIPTION
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
