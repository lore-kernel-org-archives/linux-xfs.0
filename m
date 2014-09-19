Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C9A97F3F
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 15:44:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 681D88F8040
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 13:44:34 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id IdTu9y7QS4jGL2di for <xfs@oss.sgi.com>;
	Fri, 19 Sep 2014 13:44:33 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 37A06654E2BE
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 15:44:33 -0500 (CDT)
Message-ID: <541C95B1.9020807@sandeen.net>
Date: Fri, 19 Sep 2014 15:44:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] libxfs: use structure initializers for cache_operations
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

This makes it a lot easier for cscope etc.

Surely all modern compilers can cope?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 9ee89d3..80de6fa 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1088,12 +1088,12 @@ libxfs_bcache_overflowed(void)
 }
 
 struct cache_operations libxfs_bcache_operations = {
-	/* .hash */	libxfs_bhash,
-	/* .alloc */	libxfs_balloc,
-	/* .flush */	libxfs_bflush,
-	/* .relse */	libxfs_brelse,
-	/* .compare */	libxfs_bcompare,
-	/* .bulkrelse */libxfs_bulkrelse
+	.hash		= libxfs_bhash,
+	.alloc		= libxfs_balloc,
+	.flush		= libxfs_bflush,
+	.relse		= libxfs_brelse,
+	.compare	= libxfs_bcompare,
+	.bulkrelse	= libxfs_bulkrelse
 };
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
