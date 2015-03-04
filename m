Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 087F77F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 15:00:53 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0E52FAC011
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 13:00:51 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id s0nL6u81SS20XBgr for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 13:00:48 -0800 (PST)
Message-ID: <54F7727F.8090808@sandeen.net>
Date: Wed, 04 Mar 2015 15:00:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/4] xfs_db: show nlink fields for di_version == 3, too
References: <54F77199.8030708@redhat.com>
In-Reply-To: <54F77199.8030708@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Printing inodes with di_version == 3 skips the nlink
fields, because they are only printed if di_version == 2.
This was intended to separate them from di_version == 1,
but it mistakenly excluded di_version == 3, which also contains
these fields.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Not sure; is >= 2 ok, or should it be == 2 || == 3?
Choose your poison, I guess.

diff --git a/db/inode.c b/db/inode.c
index 982acb7..c26e1a0 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -369,7 +369,7 @@ inode_core_nlinkv2_count(
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
 	dic = obj;
-	return dic->di_version == 2;
+	return dic->di_version >= 2;
 }
 
 static int
@@ -382,7 +382,7 @@ inode_core_onlink_count(
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
 	dic = obj;
-	return dic->di_version == 2;
+	return dic->di_version >= 2;
 }
 
 static int
@@ -395,7 +395,7 @@ inode_core_projid_count(
 	ASSERT(startoff == 0);
 	ASSERT(obj == iocur_top->data);
 	dic = obj;
-	return dic->di_version == 2;
+	return dic->di_version >= 2;
 }
 
 static int


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
