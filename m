Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMF802A028973 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 09:08:00 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D49A717751A5
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 07:07:58 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 8fneQFijzSviIbcj for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2008 07:07:58 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 33479AC6268
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 09:07:27 -0600 (CST)
Message-ID: <494FAD2E.3070603@sandeen.net>
Date: Mon, 22 Dec 2008 09:07:26 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstest:  fix up test 080
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs-oss <xfs@oss.sgi.com>

080 seems to run fine on linux, un-comment the quiet var to
make the output match.  Added to auto group as well.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfstests/080
===================================================================
--- xfs-cmds.orig/xfstests/080
+++ xfs-cmds/xfstests/080
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
--- xfs-cmds.orig/xfstests/group
+++ xfs-cmds/xfstests/group
@@ -182,7 +182,7 @@ atime
 077 acl attr auto
 078 growfs auto
 079 acl attr ioctl metadata auto
-080 rw ioctl
+080 rw ioctl auto
 081 log logprint quota auto
 082 log logprint v2log auto
 083 rw auto


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
