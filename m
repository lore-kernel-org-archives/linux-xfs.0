Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 869217CAD
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 693C3304043
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:19:01 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	3CjzVUF4JifRDABo for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:18:59 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MM-MM
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005HD-Ld
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/14] xfs: Validate the length of on-disk ACLs
Date: Mon, 15 Feb 2016 17:18:25 +1100
Message-Id: <1455517105-20033-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

Source kernel commit 86a21c79745ca97676cbd47f8608839382cc0448

In xfs_acl_from_disk, instead of trusting that xfs_acl.acl_cnt is correct,
make sure that the length of the attributes is correct as well.  Also, turn
the aclp parameter into a const pointer.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_format.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7eae0a5..f89b6e0 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1502,9 +1502,13 @@ struct xfs_acl {
 						sizeof(struct xfs_acl_entry) \
 		: 25)
 
-#define XFS_ACL_MAX_SIZE(mp) \
+#define XFS_ACL_SIZE(cnt) \
 	(sizeof(struct xfs_acl) + \
-		sizeof(struct xfs_acl_entry) * XFS_ACL_MAX_ENTRIES((mp)))
+		sizeof(struct xfs_acl_entry) * cnt)
+
+#define XFS_ACL_MAX_SIZE(mp) \
+	XFS_ACL_SIZE(XFS_ACL_MAX_ENTRIES((mp)))
+
 
 /* On-disk XFS extended attribute names */
 #define SGI_ACL_FILE		"SGI_ACL_FILE"
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
