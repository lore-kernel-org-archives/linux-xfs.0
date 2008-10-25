Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 06:14:37 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9PDERh5022737
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:14:28 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E91912A7EAA
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:14:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id SknobNglz4EaEVxH for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 06:14:26 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 67289A9ABFF
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 08:14:26 -0500 (CDT)
Message-ID: <49031BB1.7080609@sandeen.net>
Date: Sat, 25 Oct 2008 08:14:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] clean up printk formats with DMAPI_DEBUG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Trivial cleanup of formats.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
@@ -2334,8 +2334,8 @@ xfs_dm_round_hole(
 			return -EINVAL; /* requested length is too small */
 	}
 #ifdef CONFIG_DMAPI_DEBUG
-	printk("xfs_dm_round_hole: off %lu, len %ld, align %lu, "
-	       "filesize %llu, roff %ld, rlen %ld\n",
+	printk("xfs_dm_round_hole: off %lld, len %llu, align %llu, "
+	       "filesize %lld, roff %lld, rlen %llu\n",
 	       offset, length, align, filesize, *roff, *rlen);
 #endif
 	return 0; /* hole geometry successfully rounded */
@@ -2467,7 +2467,7 @@ xfs_dm_punch_hole(
 	}
 
 #ifdef CONFIG_DMAPI_DEBUG
-	printk("xfs_dm_punch_hole: off %lu, len %ld, align %lu\n",
+	printk("xfs_dm_punch_hole: off %lld, len %llu, align %llu\n",
 		off, len, align);
 #endif
 
