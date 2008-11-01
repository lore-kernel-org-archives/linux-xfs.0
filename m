Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Nov 2008 12:19:22 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA1JJAva011746
	for <xfs@oss.sgi.com>; Sat, 1 Nov 2008 12:19:10 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0464B13158F8
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 12:19:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id pRg2CWj1VJYHnWej for <xfs@oss.sgi.com>; Sat, 01 Nov 2008 12:19:11 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 3F466AC3590
	for <xfs@oss.sgi.com>; Sat,  1 Nov 2008 14:19:11 -0500 (CDT)
Message-ID: <490CABAE.2070402@sandeen.net>
Date: Sat, 01 Nov 2008 14:19:10 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH v2] xfstest: confirm mkfs.gfs[2] in test 032
References: <490C801E.9070405@sandeen.net>
In-Reply-To: <490C801E.9070405@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

mkfs.gfs[2] asks for confirmation before mkfs'ing; without
this test 032 hangs when mkfs.gfs2 is present.

Also, mkfs.gfs needs a few more args to make it go.

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
+	[ $fs = gfs ] && preop="echo y |" && preargs="-p lock_nolock -j 1"
+	[ $fs = gfs2 ] && preop="echo y |"
 	[ $fs = reiserfs ] && preop="echo y |" && preargs="-f"
 	# cramfs mkfs requires a directory argument
 	[ $fs = cramfs ] && preargs=/proc/fs/xfs
