Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82HhWAf033626 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:43:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EDDF15B1F79
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:44:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gtPnfZPFYPYSFkjM for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:44:09 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MitsN-0002nG-T1
	for xfs@oss.sgi.com; Wed, 02 Sep 2009 17:44:07 +0000
Date: Wed, 2 Sep 2009 13:44:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: xfsprogs: remove unused scripts
Message-ID: <20090902174407.GA9759@infradead.org>
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


xfs_check64.sh and xfs_ncheck64.sh are outdated copies of xfs_check.sh
and xfs_ncheck.sh which call a non-existant xfs_db64 binary.  They
are never installed or otherwise used, so remove them.   They are
probably a leftover from IRIX

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/db/Makefile
===================================================================
--- xfsprogs-dev.orig/db/Makefile	2009-09-02 14:35:19.413268749 -0300
+++ xfsprogs-dev/db/Makefile	2009-09-02 14:35:29.081614935 -0300
@@ -15,7 +15,6 @@ HFILES = addr.h agf.h agfl.h agi.h attr.
 	text.h type.h write.h attrset.h
 CFILES = $(HFILES:.h=.c)
 LSRCFILES = xfs_admin.sh xfs_check.sh xfs_ncheck.sh xfs_metadump.sh
-LSRCFILES += xfs_check64.sh xfs_ncheck64.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBUUID) $(LIBRT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG)
Index: xfsprogs-dev/db/xfs_check64.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_check64.sh	2009-09-02 14:35:39.477268924 -0300
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,36 +0,0 @@
-#!/bin/sh -f
-#
-# Copyright (c) 2000-2003 Silicon Graphics, Inc.  All Rights Reserved.
-#
-
-OPTS=" "
-DBOPTS=" "
-USAGE="Usage: xfs_check64 [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
-
-while getopts "b:fi:l:stvV" c
-do
-	case $c in
-	s)	OPTS=$OPTS"-s ";;
-	t)	OPTS=$OPTS"-t ";;
-	v)	OPTS=$OPTS"-v ";;
-	V)	OPTS=$OPTS"-V ";;
-	i)	OPTS=$OPTS"-i "$OPTARG" ";;
-	b)	OPTS=$OPTS"-b "$OPTARG" ";;
-	f)	DBOPTS=" -f";;
-	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
-	\?)	echo $USAGE 1>&2
-		exit 2
-		;;
-	esac
-done
-set -- extra $@
-shift $OPTIND
-case $# in
-	1)	xfs_db64$DBOPTS -F -i -p xfs_check64 -c "check$OPTS" $1
-		status=$?
-		;;
-	*)	echo $USAGE 1>&2
-		exit 2
-		;;
-esac
-exit $status
Index: xfsprogs-dev/db/xfs_ncheck64.sh
===================================================================
--- xfsprogs-dev.orig/db/xfs_ncheck64.sh	2009-09-02 14:35:33.717268763 -0300
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,34 +0,0 @@
-#!/bin/sh -f
-#
-# Copyright (c) 2000-2001 Silicon Graphics, Inc.  All Rights Reserved.
-#
-
-OPTS=" "
-DBOPTS=" "
-USAGE="usage: xfs_ncheck64 [-sfvV] [-l logdev] [-i ino]... special"
-
-while getopts "b:fi:l:svV" c
-do
-	case $c in
-	s)	OPTS=$OPTS"-s ";;
-	i)	OPTS=$OPTS"-i "$OPTARG" ";;
-	v)	OPTS=$OPTS"-v ";;
-	V)	OPTS=$OPTS"-V ";;
-	f)	DBOPTS=" -f";;
-	l)	DBOPTS=$DBOPTS" -l "$OPTARG" ";;
-	\?)	echo $USAGE 1>&2
-		exit 2
-		;;
-	esac
-done
-set -- extra $@
-shift $OPTIND
-case $# in
-	1)	xfs_db64$DBOPTS -r -p xfs_ncheck64 -c "blockget -ns" -c "ncheck$OPTS" $1
-		status=$?
-		;;
-	*)	echo $USAGE 1>&2
-		exit 2
-		;;
-esac
-exit $status

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
