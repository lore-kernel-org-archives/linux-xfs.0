Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Apr 2008 08:12:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m34FBrCk020499
	for <xfs@oss.sgi.com>; Fri, 4 Apr 2008 08:11:53 -0700
Received: from mail.pawisda.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CBC191D4DC
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2008 08:12:28 -0700 (PDT)
Received: from mail.pawisda.de (mail.pawisda.de [213.157.4.156]) by cuda.sgi.com with ESMTP id 4ZICKuWoPATOTajX for <xfs@oss.sgi.com>; Fri, 04 Apr 2008 08:12:28 -0700 (PDT)
Received: from localhost (localhost.intra.frontsite.de [127.0.0.1])
	by mail.pawisda.de (Postfix) with ESMTP id 67A35124D9
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2008 17:12:28 +0200 (CEST)
Received: from mail.pawisda.de ([127.0.0.1])
 by localhost (ndb [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 04290-05 for <xfs@oss.sgi.com>; Fri,  4 Apr 2008 17:12:23 +0200 (CEST)
Received: from [192.168.51.2] (lw-pc002.intra.frontsite.de [192.168.51.2])
	by mail.pawisda.de (Postfix) with ESMTP id F2F7BF160
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2008 17:12:22 +0200 (CEST)
Subject: [PATCH] fix comments related to xfs_write_file
From: Ruben Porras <ruben.porras@linworks.de>
Content-Type: multipart/mixed; boundary="=-QNR/w8iiZ5KYQLytZkEk"
Date: Fri, 04 Apr 2008 17:12:21 +0200
Message-Id: <1207321941.1043.14.camel@lw-pc002.intra.pawisda.de>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--=-QNR/w8iiZ5KYQLytZkEk
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

The function xfs_write_file does no longer exists, i think that the
first comment doesn't even make sense, and that the second one is
correct writing xfs_write instead of xfs_write_file.

--=-QNR/w8iiZ5KYQLytZkEk
Content-Disposition: attachment; filename=xfs_write_file.patch
Content-Type: text/x-patch; name=xfs_write_file.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: fs/xfs/xfs_inode.c
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_inode.c,v
retrieving revision 1.495
diff -u -r1.495 xfs_inode.c
--- fs/xfs/xfs_inode.c	22 Feb 2008 03:05:49 -0000	1.495
+++ fs/xfs/xfs_inode.c	4 Apr 2008 14:55:46 -0000
@@ -1799,11 +1799,6 @@
 	ASSERT(ismrlocked(&(ip->i_iolock), MR_UPDATE) != 0);
 	ASSERT(new_size > ip->i_size);
 
-	/*
-	 * Zero any pages that may have been created by
-	 * xfs_write_file() beyond the end of the file
-	 * and any blocks between the old and new file sizes.
-	 */
 	return xfs_zero_eof(ip, new_size, ip->i_size);
 }
 
Index: fs/xfs/xfs_rw.c
===================================================================
RCS file: /cvs/linux-2.6-xfs/fs/xfs/xfs_rw.c,v
retrieving revision 1.399
diff -u -r1.399 xfs_rw.c
--- fs/xfs/xfs_rw.c	24 Aug 2007 16:13:42 -0000	1.399
+++ fs/xfs/xfs_rw.c	4 Apr 2008 14:55:47 -0000
@@ -1,3 +1,4 @@
+
 /*
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
@@ -114,7 +115,7 @@
 		 * the fact that buffered writes lock out direct I/O
 		 * writes - the direct I/O write could have extended
 		 * the size nontransactionally, then finished before
-		 * we started.  xfs_write_file will think that the file
+		 * we started.  xfs_write will think that the file
 		 * didn't grow but the update isn't safe unless the
 		 * size change is logged.
 		 *

--=-QNR/w8iiZ5KYQLytZkEk--
