Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 92F227F53
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 03:56:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7B4A68F804C
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 01:56:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pcO9yLd06b4axRiM for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 01:56:24 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wk8VV-0000Ja-Vf
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:18 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wk8VV-0001kr-Ud
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/9] xfs: fix wrong errno from xfs_initxattrs
Date: Tue, 13 May 2014 18:56:09 +1000
Message-Id: <1399971373-6242-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-1-git-send-email-david@fromorbit.com>
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 301ecbf..adfb18e 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -72,8 +72,8 @@ xfs_initxattrs(
 	int			error = 0;
 
 	for (xattr = xattr_array; xattr->name != NULL; xattr++) {
-		error = xfs_attr_set(ip, xattr->name, xattr->value,
-				     xattr->value_len, ATTR_SECURE);
+		error = -xfs_attr_set(ip, xattr->name, xattr->value,
+				      xattr->value_len, ATTR_SECURE);
 		if (error < 0)
 			break;
 	}
@@ -93,8 +93,8 @@ xfs_init_security(
 	struct inode	*dir,
 	const struct qstr *qstr)
 {
-	return security_inode_init_security(inode, dir, qstr,
-					    &xfs_initxattrs, NULL);
+	return -security_inode_init_security(inode, dir, qstr,
+					     &xfs_initxattrs, NULL);
 }
 
 static void
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
