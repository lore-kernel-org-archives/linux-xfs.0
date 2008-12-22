Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGihnQ006723 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2E9C3F8EB
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 57Gi4a2bgWyZuSSY for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:41 -0800 (PST)
Message-Id: <20081222164410.730134000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 17/20] xfstests: add more tests to the auto group
Content-Disposition: inline; filename=xfstests-more-auto-tests
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

make sure we run all tests than don't either take forever or currently fail
(or require a tape drive) to the auto group.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-cmds/xfstests/group
===================================================================
--- xfs-cmds.orig/xfstests/group	2008-12-22 14:19:47.561247633 +0100
+++ xfs-cmds/xfstests/group	2008-12-22 17:25:29.464372849 +0100
@@ -166,7 +166,7 @@ atime
 061 dump ioctl auto
 062 attr udf auto
 063 dump attr auto
-064 dump
+064 dump auto
 065 dump auto
 066 dump ioctl auto
 067 acl attr auto
@@ -187,9 +187,9 @@ atime
 082 log logprint v2log auto
 083 rw auto
 084 ioctl rw auto
-085 log
-086 log v2log
-087 log v2log
+085 log auto
+086 log v2log auto
+087 log v2log auto
 088 perms auto
 089 metadata auto
 090 rw auto
@@ -200,7 +200,7 @@ atime
 095 log v2log auto
 096 mkfs v2log auto
 097 udf auto
-098 udf
+098 udf auto
 099 udf auto
 100 udf auto
 101 udf
@@ -211,17 +211,17 @@ atime
 106 quota
 107 quota
 108 quota
-109 metadata
-110 repair
+109 metadata auto
+110 repair auto
 111 ioctl
 112 rw aio auto
-113 rw aio
+113 rw aio auto
 114 parent attr
 115 parent attr
-116 quota
+116 quota auto
 117 attr auto
-118 quota
-119 log v2log
+118 quota auto
+119 log v2log auto
 120 other auto
 121 log auto
 122 other auto
@@ -235,7 +235,7 @@ atime
 130 pattern auto
 131 perms auto
 132 pattern auto
-133 rw
+133 rw auto
 134 quota auto
 135 metadata auto
 136 attr2

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
