Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Nov 2008 09:13:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA1GDII6028060
	for <xfs@oss.sgi.com>; Sat, 1 Nov 2008 09:13:18 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAE951315094
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 09:13:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id UhnnHjZWIzIkx6x6 for <xfs@oss.sgi.com>; Sat, 01 Nov 2008 09:13:19 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 20053AC3590
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 11:13:19 -0500 (CDT)
Message-ID: <490C801E.9070405@sandeen.net>
Date: Sat, 01 Nov 2008 11:13:18 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstest: confirm mkfs.gfs[2] in test 032
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

mkfs.gfs[2] asks for confirmation before mkfs'ing; without
this test 032 hangs when mkfs.gfs2 is present.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfstests/032
===================================================================
--- xfs-cmds.orig/xfstests/032
+++ xfs-cmds/xfstests/032
@@ -43,6 +43,8 @@ do
 	[ $fs = vfat ] && postargs=2000
 	# these folks prompt before writing
 	[ $fs = jfs ] && preop="echo Y |"
+	[ $fs = gfs ] && preop="echo y |"
+	[ $fs = gfs2 ] && preop="echo y |"
 	[ $fs = reiserfs ] && preop="echo y |" && preargs="-f"
 	# cramfs mkfs requires a directory argument
 	[ $fs = cramfs ] && preargs=/proc/fs/xfs
