Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Sep 2008 20:06:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8A36ZdC004372
	for <xfs@oss.sgi.com>; Tue, 9 Sep 2008 20:06:35 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3AFA4247CD
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2008 20:08:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id CvtMxtlaG8PGcG5Y for <xfs@oss.sgi.com>; Tue, 09 Sep 2008 20:08:02 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 2443CA9ABC6
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2008 22:08:02 -0500 (CDT)
Message-ID: <48C73A13.2000100@sandeen.net>
Date: Tue, 09 Sep 2008 22:08:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsidbg: decode XFS_IFEXTIREC i_flag
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Tiny update to include new(ish) inode flag.
Adjust descriptive string as needed :)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c
@@ -3859,6 +3859,7 @@ xfs_xnode_fork(char *name, xfs_ifork_t *
 		"inline",	/* XFS_IFINLINE */
 		"extents",	/* XFS_IFEXTENTS */
 		"broot",	/* XFS_IFBROOT */
+		"extirec",	/* XFS_IFEXTIREC */
 		NULL
 	};
 	int *p;
