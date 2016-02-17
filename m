Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B44A17CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83CA98F8035
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:18 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	CZvLGTsnwjQuAJ7I for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:10 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004ls-MK
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00013o-LU
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/15] xfs: wire up Q_XGETNEXTQUOTA / get_nextdqblk
Date: Wed, 17 Feb 2016 18:20:38 +1100
Message-Id: <1455693652-3899-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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

From: Eric Sandeen <sandeen@sandeen.net>

Source kernel commit 296c24e26ee3af2dbfecb482e6bc9560bd34c455

Add code to allow the Q_XGETNEXTQUOTA quotactl to quickly find
all active quotas by examining the quota inode, and skipping
over unallocated or uninitialized regions.

Userspace can then use this interface rather than i.e. a
getpwent() loop when asked to report all active quotas.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_quota_defs.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index f51078f..8eed512 100644
--- a/libxfs/xfs_quota_defs.h
+++ b/libxfs/xfs_quota_defs.h
@@ -37,7 +37,7 @@ typedef __uint16_t	xfs_qwarncnt_t;
 #define XFS_DQ_PROJ		0x0002		/* project quota */
 #define XFS_DQ_GROUP		0x0004		/* a group quota */
 #define XFS_DQ_DIRTY		0x0008		/* dquot is dirty */
-#define XFS_DQ_FREEING		0x0010		/* dquot is beeing torn down */
+#define XFS_DQ_FREEING		0x0010		/* dquot is being torn down */
 
 #define XFS_DQ_ALLTYPES		(XFS_DQ_USER|XFS_DQ_PROJ|XFS_DQ_GROUP)
 
@@ -116,6 +116,7 @@ typedef __uint16_t	xfs_qwarncnt_t;
 #define XFS_QMOPT_DQREPAIR	0x0001000 /* repair dquot if damaged */
 #define XFS_QMOPT_GQUOTA	0x0002000 /* group dquot requested */
 #define XFS_QMOPT_ENOSPC	0x0004000 /* enospc instead of edquot (prj) */
+#define XFS_QMOPT_DQNEXT	0x0008000 /* return next dquot >= this ID */
 
 /*
  * flags to xfs_trans_mod_dquot to indicate which field needs to be
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
