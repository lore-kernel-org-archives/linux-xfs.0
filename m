Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6877A7F37
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 14:34:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3AFDC8F8054
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 12:34:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tb5ZOCUNzMWKY6uK for <xfs@oss.sgi.com>;
	Wed, 09 Sep 2015 12:34:16 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 05/13] xfs_repair: fix use-after-free in verify_final_dir2_path
Date: Wed,  9 Sep 2015 14:34:03 -0500
Message-Id: <1441827251-13128-6-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
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

Way back in 2002, commit 948ce18 fixed a potential use-after-free
in verify_final_da_path, but the same fix was not applied to
verify_final_dir2_path; apply it now.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 repair/dir2.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index 44367c6..898b27e 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -330,6 +330,7 @@ verify_final_dir2_path(xfs_mount_t	*mp,
 		const int		p_level)
 {
 	xfs_da_intnode_t	*node;
+	xfs_dahash_t		hashval;
 	int			bad = 0;
 	int			entry;
 	int			this_level = p_level + 1;
@@ -409,6 +410,12 @@ _("would correct bad hashval in non-leaf dir block\n"
 	}
 
 	/*
+	 * Note: squirrel hashval away _before_ releasing the
+	 * buffer, preventing a use-after-free problem.
+	 */
+	hashval = be32_to_cpu(btree[entry].hashval);
+
+	/*
 	 * release/write buffer
 	 */
 	ASSERT(cursor->level[this_level].dirty == 0 ||
@@ -430,7 +437,7 @@ _("would correct bad hashval in non-leaf dir block\n"
 	 * set hashvalue to correctl reflect the now-validated
 	 * last entry in this block and continue upwards validation
 	 */
-	cursor->level[this_level].hashval = be32_to_cpu(btree[entry].hashval);
+	cursor->level[this_level].hashval = hashval;
 
 	return(verify_final_dir2_path(mp, cursor, this_level));
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
