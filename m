Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82Hl5fC033823 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:47:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC3F641E203
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:48:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id B6Cfn3wiTbClRBks for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:48:02 -0700 (PDT)
Date: Wed, 2 Sep 2009 13:44:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfsprogs: fix the -V option for various shell scripts
Message-ID: <20090902174451.GB9759@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>

For most of the shellscripts wrapping xfs_db or xfs_growfs the -V option
is not implemented correctly.  If we just add -V to the options for the
underlying binaries we will never actually call it because the mandatory
device / mount point argument is missing.  Instead just call the underlying
command with -V directly and exit early.  This is what xfs_bmap.sh,
xfs_mkfile and xfs_metadump.sh are already doing.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Michael Monnerie <michael.monnerie@is.it-management.at>

Index: xfsprogs-dev/db/xfs_admin.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_admin.sh	2009-09-02 14:36:22.045272960 -0300
+++ xfsprogs-dev/db/xfs_admin.sh	2009-09-02 14:38:28.497305969 -0300
@@ -19,7 +19,10 @@ do
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
-	V)	DB_OPTS=$DB_OPTS" -V";;
+	V)	xfs_db -p xfs_admin -V
+		status=$?
+		exit $status
+		;;
 	\?)	echo $USAGE 1>&2
 		exit 2
 		;;
Index: xfsprogs-dev/db/xfs_check.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_check.sh	2009-09-02 14:36:22.069271261 -0300
+++ xfsprogs-dev/db/xfs_check.sh	2009-09-02 14:38:28.501271696 -0300
@@ -13,11 +13,14 @@ do
 	s)	OPTS=$OPTS"-s ";;
 	t)	OPTS=$OPTS"-t ";;
 	v)	OPTS=$OPTS"-v ";;
-	V)	OPTS=$OPTS"-V ";;
 	i)	OPTS=$OPTS"-i "$OPTARG" ";;
 	b)	OPTS=$OPTS"-b "$OPTARG" ";;
 	f)	DBOPTS=$DBOPTS" -f";;
 	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
+	V)	xfs_db -p xfs_check -V
+		status=$?
+		exit $status
+		;;
 	\?)	echo $USAGE 1>&2
 		exit 2
 		;;
Index: xfsprogs-dev/db/xfs_ncheck.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_ncheck.sh	2009-09-02 14:36:22.089271988 -0300
+++ xfsprogs-dev/db/xfs_ncheck.sh	2009-09-02 14:38:28.501271696 -0300
@@ -14,9 +14,12 @@ do
 	s)	OPTS=$OPTS"-s ";;
 	i)	OPTS=$OPTS"-i "$OPTARG" ";;
 	v)	OPTS=$OPTS"-v ";;
-	V)	OPTS=$OPTS"-V ";;
 	f)	DBOPTS=$DBOPTS" -f";;
 	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
+	V)	xfs_db -p xfs_ncheck -V
+		status=$?
+		exit $status
+		;;
 	\?)	echo $USAGE 1>&2
 		exit 2
 		;;
Index: xfsprogs-dev/growfs/xfs_info.sh
===================================================================
--- xfsprogs-dev.orig/growfs/xfs_info.sh	2009-09-02 14:36:22.101270370 -0300
+++ xfsprogs-dev/growfs/xfs_info.sh	2009-09-02 14:38:28.505312364 -0300
@@ -10,7 +10,10 @@ while getopts "t:V" c
 do
 	case $c in
 	t)	OPTS="-t $OPTARG" ;;
-	V)	OPTS="-V $OPTARG" ;;
+	V)	xfs_growfs -p xfs_info -V
+		status=$?
+		exit $status
+		;;
 	*)	echo $USAGE 1>&2
 		exit 2
 		;;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
