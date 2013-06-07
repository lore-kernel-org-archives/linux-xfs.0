Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C97A7F5D
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EBB4D8F8059
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	hYX3q0RKsr5RupCN for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:26 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVb-0003uG-UU
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:23 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVb-0001Js-RE
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/48] libxfs: change quota buffer formats
Date: Fri,  7 Jun 2013 10:25:29 +1000
Message-Id: <1370564771-4929-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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
 include/xfs_quota.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/xfs_quota.h b/include/xfs_quota.h
index b50ec5b..c61e31c 100644
--- a/include/xfs_quota.h
+++ b/include/xfs_quota.h
@@ -77,7 +77,14 @@ typedef struct	xfs_disk_dquot {
  */
 typedef struct xfs_dqblk {
 	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
-	char		  dd_fill[32];	/* filling for posterity */
+	char		  dd_fill[4];	/* filling for posterity */
+
+	/*
+	 * These two are only present on filesystems with the CRC bits set.
+	 */
+	__be32		  dd_crc;	/* checksum */
+	__be64		  dd_lsn;	/* last modification in log */
+	uuid_t		  dd_uuid;	/* location information */
 } xfs_dqblk_t;
 
 /*
@@ -380,5 +387,7 @@ extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
 				xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
+extern const struct xfs_buf_ops xfs_dquot_buf_ops;
+
 #endif	/* __KERNEL__ */
 #endif	/* __XFS_QUOTA_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
