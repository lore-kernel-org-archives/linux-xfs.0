Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7776B7F5D
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 11:48:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E971BAC005
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 09:48:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id va7HlAGStrA1hxwb for
	<xfs@oss.sgi.com>; Thu, 12 Dec 2013 09:48:32 -0800 (PST)
Message-ID: <52A9F6CF.1070300@redhat.com>
Date: Thu, 12 Dec 2013 11:47:59 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_metadump: Make -F (force) optional
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
To: xfs-oss <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>

If we do something crazy like:

# xfs_metadump /root/anaconda.cfg outfile

xfs_metadump will pass "-F" to xfs_db to carry on even in the face
of bad superblock magic. [1]  Depending on what we gave as an input
file, we may very well fail quite badly:

> xfs_metadump: /root/anaconda.cfg is not a valid XFS filesystem (unexpected SB magic number 0x230a2320)
> Floating point exception

I don't think it's possible to harden every path through libxfs for
non-xfs filesystems as input.  (Even if it's possible, I don't think it's
worth the effort).

So I propose making the "-F" optional; by default, xfs_metadump will
say no, this has bad magic, I'm stopping.  If the admin really wants to
try to proceed, suggest that they can use "-F" and they can keep all the
broken pieces.

[1] behavior added in 7f98455 xfs_db: exit on invalid magic number

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/db/init.c b/db/init.c
index 8f86f45..e7f536a 100644
--- a/db/init.c
+++ b/db/init.c
@@ -140,8 +140,10 @@ init(
 	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
 		fprintf(stderr, _("%s: %s is not a valid XFS filesystem (unexpected SB magic number 0x%08x)\n"),
 			progname, fsdevice, sbp->sb_magicnum);
-		if (!force)
+		if (!force) {
+			fprintf(stderr, _("Use -F to force a read attempt.\n"));
 			exit(EXIT_FAILURE);
+		}
 	}
 
 	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 28b04b8..7ce7a6d 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -5,7 +5,7 @@
 
 OPTS=" "
 DBOPTS=" "
-USAGE="Usage: xfs_metadump [-efogwV] [-m max_extents] [-l logdev] source target"
+USAGE="Usage: xfs_metadump [-efFogwV] [-m max_extents] [-l logdev] source target"
 
 while getopts "efgl:m:owV" c
 do
@@ -17,6 +17,7 @@ do
 	w)	OPTS=$OPTS"-w ";;
 	f)	DBOPTS=$DBOPTS" -f";;
 	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
+	F)	DBOPTS=$DBOPTS" -F";;
 	V)	xfs_db -p xfs_metadump -V
 		status=$?
 		exit $status
@@ -29,7 +30,7 @@ done
 set -- extra $@
 shift $OPTIND
 case $# in
-	2)	xfs_db$DBOPTS -F -i -p xfs_metadump -c "metadump$OPTS $2" $1
+	2)	xfs_db$DBOPTS -i -p xfs_metadump -c "metadump$OPTS $2" $1
 		status=$?
 		;;
 	*)	echo $USAGE 1>&2
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 4fa1b1c..077fff5 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -4,7 +4,7 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 .SH SYNOPSIS
 .B xfs_metadump
 [
-.B \-efgow
+.B \-efFgow
 ] [
 .B \-m
 .I max_extents
@@ -86,6 +86,11 @@ file option). This can also happen if an image copy of a filesystem has
 been made into an ordinary file with
 .BR xfs_copy (8).
 .TP
+.B \-F
+Specifies that we want to continue even if the superblock magic is not correct.
+If the source is truly not an XFS filesystem, the resulting image will be useless,
+and xfs_metadump may crash.
+.TP
 .B \-g
 Shows dump progress. This is sent to stdout if the
 .I target


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
