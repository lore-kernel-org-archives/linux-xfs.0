Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8409D7F50
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 03:56:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 633558F8035
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 01:56:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TY1LidxFHPKRKZpn for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 01:56:21 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Wk8VV-0000Jb-W8
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:18 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1Wk8VV-0001kw-VK
	for xfs@oss.sgi.com; Tue, 13 May 2014 18:56:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/9] xfs: fix wrong err sign on xfs_set_acl()
Date: Tue, 13 May 2014 18:56:10 +1000
Message-Id: <1399971373-6242-7-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_iops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index adfb18e..36d6303 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -173,12 +173,12 @@ xfs_generic_create(
 
 #ifdef CONFIG_XFS_POSIX_ACL
 	if (default_acl) {
-		error = xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
+		error = -xfs_set_acl(inode, default_acl, ACL_TYPE_DEFAULT);
 		if (error)
 			goto out_cleanup_inode;
 	}
 	if (acl) {
-		error = xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
+		error = -xfs_set_acl(inode, acl, ACL_TYPE_ACCESS);
 		if (error)
 			goto out_cleanup_inode;
 	}
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
