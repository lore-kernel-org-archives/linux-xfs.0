Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46650 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCqk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:46:40 -0400
Subject: [PATCH 8/9] xfs_info: call xfs_db for offline filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:46:21 -0700
Message-ID: <152401958146.13048.3834702512829151272.stgit@magnolia>
In-Reply-To: <152401952391.13048.15040850425873030425.stgit@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If the online filesystem geometry query doesn't work, try using xfs_db
to see if we can grab the information offline.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/xfs_growfs.8 |   47 +-----------------------
 man/man8/xfs_info.8   |   95 +++++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/xfs_info.sh  |   12 +++++-
 3 files changed, 106 insertions(+), 48 deletions(-)
 create mode 100644 man/man8/xfs_info.8


diff --git a/man/man8/xfs_growfs.8 b/man/man8/xfs_growfs.8
index e23d30e..7e6a387 100644
--- a/man/man8/xfs_growfs.8
+++ b/man/man8/xfs_growfs.8
@@ -11,7 +11,7 @@
 
 .TH xfs_growfs 8
 .SH NAME
-xfs_growfs, xfs_info \- expand an XFS filesystem
+xfs_growfs \- expand an XFS filesystem
 .SH SYNOPSIS
 .B xfs_growfs
 [
@@ -38,16 +38,6 @@ xfs_growfs, xfs_info \- expand an XFS filesystem
 .I mount-point
 .br
 .B xfs_growfs \-V
-.PP
-.br
-.B xfs_info
-[
-.B \-t
-.I mtab
-]
-.I mount-point
-.br
-.B xfs_info \-V
 .SH DESCRIPTION
 .B xfs_growfs
 expands an existing XFS filesystem (see
@@ -59,13 +49,6 @@ is mounted. The filesystem must be mounted to be grown (see
 .BR mount (8)).
 The existing contents of the filesystem are undisturbed, and the added space
 becomes available for additional file storage.
-.PP
-.B xfs_info
-is equivalent to invoking
-.B xfs_growfs
-with the
-.B \-n
-option (see discussion below).
 .SH OPTIONS
 .TP
 .BI "\-d | \-D " size
@@ -169,35 +152,9 @@ reside. In order to grow a filesystem, it is necessary to provide added
 space for it to occupy. Therefore there must be at least one spare new
 disk partition available. Adding the space is often done through the use
 of a logical volume manager.
-.SH "EXAMPLES"
-
-Understanding xfs_info output.
-.PP
-Suppose one has the following "xfs_info /dev/sda" output:
-.PP
-.RS 2
-.Vb
-\&meta-data=/dev/sda      isize=256    agcount=32, agsize=16777184 blks
-\&         =              sectsz=512   attr=2
-\&data     =              bsize=4096   blocks=536869888, imaxpct=5
-\&         =              sunit=32     swidth=128 blks
-\&naming   =version 2     bsize=4096
-\&log      =internal      bsize=4096   blocks=32768, version=2
-\&         =              sectsz=512   sunit=32 blks, lazy-count=1
-\&realtime =none          extsz=524288 blocks=0, rtextents=0
-.Ve
-.RE
-.PP
-
-Here, the data section of the output indicates "bsize=4096",
-meaning the data block size for this filesystem is 4096 bytes.
-This section also shows "sunit=32 swidth=128 blks", which means
-the stripe unit is 32*4096 bytes = 128 kibibytes and the stripe
-width is 128*4096 bytes = 512 kibibytes.
-A single stripe of this filesystem therefore consists
-of four stripe units (128 blocks / 32 blocks per unit).
 .SH SEE ALSO
 .BR mkfs.xfs (8),
+.BR xfs_info (8),
 .BR md (4),
 .BR lvm (8),
 .BR mount (8).
diff --git a/man/man8/xfs_info.8 b/man/man8/xfs_info.8
new file mode 100644
index 0000000..c4c470d
--- /dev/null
+++ b/man/man8/xfs_info.8
@@ -0,0 +1,95 @@
+.\" Verbatim blocks taken from openssl req manpage content
+.de Vb \" Begin verbatim text
+.ft CW
+.nf
+.ne \\$1
+..
+.de Ve \" End verbatim text
+.ft R
+.fi
+..
+
+.TH xfs_info 8
+.SH NAME
+xfs_info, \- display XFS filesystem geometry information
+.SH SYNOPSIS
+.B xfs_info
+[
+.B \-t
+.I mtab
+]
+[
+.I mount-point
+|
+.I block-device
+|
+.I file-image
+]
+.br
+.B xfs_info \-V
+.SH DESCRIPTION
+.B xfs_info
+displays geometry information about an existing XFS filesystem.
+The
+.I mount-point
+argument is the pathname of a directory where the filesystem
+is mounted.
+The
+.I block-device
+or
+.I file-image
+contain a raw XFS filesystem.
+The existing contents of the filesystem are undisturbed.
+.SH OPTIONS
+.TP
+.B \-t
+Specifies an alternate mount table file (default is
+.I /proc/mounts
+if it exists, else
+.IR /etc/mtab ).
+This is used when working with filesystems mounted without writing to
+.I /etc/mtab
+file - refer to
+.BR mount (8)
+for further details.
+This option has no effect with the
+.IR block-device " or " file-image
+parameters.
+.TP
+.B \-V
+Prints the version number and exits. The
+.I mount-point
+argument is not required with
+.BR \-V .
+.SH "EXAMPLES"
+
+Understanding xfs_info output.
+.PP
+Suppose one has the following "xfs_info /dev/sda" output:
+.PP
+.RS 2
+.Vb
+\&meta-data=/dev/sda      isize=256    agcount=32, agsize=16777184 blks
+\&         =              sectsz=512   attr=2
+\&data     =              bsize=4096   blocks=536869888, imaxpct=5
+\&         =              sunit=32     swidth=128 blks
+\&naming   =version 2     bsize=4096
+\&log      =internal log  bsize=4096   blocks=32768, version=2
+\&         =              sectsz=512   sunit=32 blks, lazy-count=1
+\&realtime =none          extsz=524288 blocks=0, rtextents=0
+.Ve
+.RE
+.PP
+
+Here, the data section of the output indicates "bsize=4096",
+meaning the data block size for this filesystem is 4096 bytes.
+This section also shows "sunit=32 swidth=128 blks", which means
+the stripe unit is 32*4096 bytes = 128 kibibytes and the stripe
+width is 128*4096 bytes = 512 kibibytes.
+A single stripe of this filesystem therefore consists
+of four stripe units (128 blocks / 32 blocks per unit).
+.SH SEE ALSO
+.BR mkfs.xfs (8),
+.BR md (4),
+.BR lvm (8),
+.BR mount (8).
diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
index 5df0a26..2e17fd9 100755
--- a/spaceman/xfs_info.sh
+++ b/spaceman/xfs_info.sh
@@ -4,7 +4,7 @@
 #
 
 OPTS=""
-USAGE="Usage: xfs_info [-V] [-t mtab] mountpoint"
+USAGE="Usage: xfs_info [-V] [-t mtab] [mountpoint|device|file]"
 
 while getopts "t:V" c
 do
@@ -22,8 +22,14 @@ done
 set -- extra "$@"
 shift $OPTIND
 case $# in
-	1)	xfs_spaceman -p xfs_info -c "info" $OPTS "$1"
-		status=$?
+	1)
+		if [ -b "$1" ] || [ -f "$1" ]; then
+			xfs_db -p xfs_info -c "info" $OPTS "$1"
+			status=$?
+		else
+			xfs_spaceman -p xfs_info -c "info" $OPTS "$1"
+			status=$?
+		fi
 		;;
 	*)	echo $USAGE 1>&2
 		exit 2

