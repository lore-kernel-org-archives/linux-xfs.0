Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C74C7F60
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 15:33:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C75B8F8040
	for <xfs@oss.sgi.com>; Tue, 17 Mar 2015 13:33:20 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id AZbk50PAoDBnBEYy for <xfs@oss.sgi.com>;
	Tue, 17 Mar 2015 13:33:18 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/13] xfs_db: nlink fields are valid for di_version == 3, too
Date: Tue, 17 Mar 2015 15:33:06 -0500
Message-Id: <1426624395-8258-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Printing inodes with di_version == 3 skips the nlink
fields, because they are only printed if di_version == 2.
This was intended to separate them from di_version == 1,
but it mistakenly excluded di_version == 3, which also contains
these fields.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 db/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
