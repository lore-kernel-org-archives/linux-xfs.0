Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGihYA006724 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:43 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 171A53F8EF
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ATiPGJHLysvwvF8a for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:41 -0800 (PST)
Message-Id: <20081222164411.065734000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:49 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 18/20] 080 seems to run fine on linux,
	un-comment the quiet var to make the output match. Added to auto
	group as well.
Content-Disposition: inline; filename=xfstests-fix-and-enable-080
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
Cc: Eric Sandeen <sandeen@sandeen.net>

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfstests/080
===================================================================
--- xfs-cmds.orig/xfstests/080	2008-12-22 14:19:47.585247967 +0100
+++ xfs-cmds/xfstests/080	2008-12-22 17:26:25.692247678 +0100
@@ -33,14 +33,13 @@ _supported_fs xfs
 
 # Apparently should be able to work on IRIX,
 # but not at the moment.
-# It does not work on Linux due to some locking issues...
-_supported_os IRIX
+_supported_os IRIX Linux
 
 [ $HOSTOS == IRIX ] && _notrun "Not working on IRIX yet"
 
 _setup_testdir
 
-#quiet=-q
+quiet=-q
 clean=-c
 
 export here
Index: xfs-cmds/xfstests/group
===================================================================
--- xfs-cmds.orig/xfstests/group	2008-12-22 17:25:29.464372849 +0100
+++ xfs-cmds/xfstests/group	2008-12-22 17:26:25.692247678 +0100
@@ -182,7 +182,7 @@ atime
 077 acl attr auto
 078 growfs auto
 079 acl attr ioctl metadata auto
-080 rw ioctl
+080 rw ioctl auto
 081 log logprint quota auto
 082 log logprint v2log auto
 083 rw auto

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
