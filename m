Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6KJ6aMx102949 for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 14:06:36 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8210D13BA3E8
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 12:07:17 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 6RYqptCcsgurNACM for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2009 12:07:17 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6KJ7H4s006453
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 15:07:17 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6KJ7Gvm000554
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 15:07:16 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6KJ7F09021190
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2009 15:07:15 -0400
Message-ID: <4A64C063.2070807@sandeen.net>
Date: Mon, 20 Jul 2009 14:07:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_metadump: Allow operation on frozen filesystems
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

The xfs_metadump manpage says that it works on a frozen filesystem,
but in reality it does not, and fails because the fs still looks
mounted & writable.

I don't think we have a way to test for frozen (!) so add a -F 
option which essentially overrides the xfs_db "-i" option with
a later "-r" which is more forgiving.

Document this, and a few other missing bits in the manpage.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

iff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 28b04b8..ef51678 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -5,9 +5,9 @@
 
 OPTS=" "
 DBOPTS=" "
-USAGE="Usage: xfs_metadump [-efogwV] [-m max_extents] [-l logdev] source target"
+USAGE="Usage: xfs_metadump [-efogwFV] [-m max_extent] [-l logdev] source target"
 
-while getopts "efgl:m:owV" c
+while getopts "efgl:m:owFV" c
 do
 	case $c in
 	e)	OPTS=$OPTS"-e ";;
@@ -17,6 +17,7 @@ do
 	w)	OPTS=$OPTS"-w ";;
 	f)	DBOPTS=$DBOPTS" -f";;
 	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
+	F)	DBOPTS=$DBOPTS" -r";;
 	V)	xfs_db -p xfs_metadump -V
 		status=$?
 		exit $status
@@ -29,7 +30,7 @@ done
 set -- extra $@
 shift $OPTIND
 case $# in
-	2)	xfs_db$DBOPTS -F -i -p xfs_metadump -c "metadump$OPTS $2" $1
+	2)	xfs_db -F -i $DBOPTS -p xfs_metadump -c "metadump$OPTS $2" $1
 		status=$?
 		;;
 	*)	echo $USAGE 1>&2
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index f0ff1ae..1f74dd4 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -4,11 +4,15 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 .SH SYNOPSIS
 .B xfs_metadump
 [
-.B \-efgow
+.B \-efgowFV
 ] [
 .B \-l
 .I logdev
 ]
+] [
+.B \-m
+.I max_extent
+]
 .I source
 .I target
 .SH DESCRIPTION
@@ -28,7 +32,10 @@ redirected to another program such as a compression application.
 .B xfs_metadump
 should only be used to copy unmounted filesystems, read-only mounted
 filesystems, or frozen filesystems (see
-.BR xfs_freeze (8)).
+.BR xfs_freeze (8)
+and the
+.B \-F
+option below).
 Otherwise, the generated dump could be inconsistent or corrupt.
 .PP
 .B xfs_metadump
@@ -94,12 +101,28 @@ For filesystems which use an external log, this specifies the device where the
 external log resides. The external log is not copied, only internal logs are
 copied.
 .TP
+.BI \-m " max_extent"
+Specify the maximum size of a metadata extent to process, in filesystem blocks.
+Anything larger than this will be considered corrupt metadata, and skipped.
+The default is 1000 blocks.
+.TP
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
 .B \-w
 Prints warnings of inconsistant metadata encountered to stderr. Bad metadata
 is still copied.
+.TP
+.B \-F
+Allows a metadump of a filesystem frozen with
+.BR xfs_freeze (8).
+This overrides the normal tests that the fileystem is either unmounted
+or readonly; because there is no way to test for a frozen filesystem,
+this option must be manually specified.  Specifying this option on a 
+writable, non-frozen filesystem will likely result in a corrupted dump image.
+.TP
+.B \-V
+Prints out the current version number and exits.
 .SH DIAGNOSTICS
 .B xfs_metadump
 returns an exit code of 0 if all readable metadata is succesfully copied or

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
