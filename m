Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B7187F60
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 17:25:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 146E6AC001
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:25:33 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id Jo9Ca4OkR6Cpt03i (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 15:25:32 -0700 (PDT)
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Jun 2013 16:25:31 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 975DC1FF001B
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:20:12 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5RMPS7g358652 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:28 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5RMPSsG018696
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:28 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v10 05/11] xfs: Do some whitespace cleanup in the data
	structure xfs_quotainfo
Date: Thu, 27 Jun 2013 17:25:08 -0500
Message-Id: <1372371914-11370-6-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
References: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

In preparation for combined pquota/gquota support, do some
whitespace cleanups.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_qm.h |   50 +++++++++++++++++++++++++-------------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 978bbb1..d6d71f0 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -42,31 +42,31 @@ extern struct kmem_zone	*xfs_qm_dqtrxzone;
  * The mount structure keeps a pointer to this.
  */
 typedef struct xfs_quotainfo {
-	struct radix_tree_root qi_uquota_tree;
-	struct radix_tree_root qi_gquota_tree;
-	struct mutex qi_tree_lock;
-	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
-	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
-	struct list_head qi_lru_list;
-	struct mutex	 qi_lru_lock;
-	int		 qi_lru_count;
-	int		 qi_dquots;
-	time_t		 qi_btimelimit;	 /* limit for blks timer */
-	time_t		 qi_itimelimit;	 /* limit for inodes timer */
-	time_t		 qi_rtbtimelimit;/* limit for rt blks timer */
-	xfs_qwarncnt_t	 qi_bwarnlimit;	 /* limit for blks warnings */
-	xfs_qwarncnt_t	 qi_iwarnlimit;	 /* limit for inodes warnings */
-	xfs_qwarncnt_t	 qi_rtbwarnlimit;/* limit for rt blks warnings */
-	struct mutex	 qi_quotaofflock;/* to serialize quotaoff */
-	xfs_filblks_t	 qi_dqchunklen;	 /* # BBs in a chunk of dqs */
-	uint		 qi_dqperchunk;	 /* # ondisk dqs in above chunk */
-	xfs_qcnt_t	 qi_bhardlimit;	 /* default data blk hard limit */
-	xfs_qcnt_t	 qi_bsoftlimit;	 /* default data blk soft limit */
-	xfs_qcnt_t	 qi_ihardlimit;	 /* default inode count hard limit */
-	xfs_qcnt_t	 qi_isoftlimit;	 /* default inode count soft limit */
-	xfs_qcnt_t	 qi_rtbhardlimit;/* default realtime blk hard limit */
-	xfs_qcnt_t	 qi_rtbsoftlimit;/* default realtime blk soft limit */
-	struct shrinker  qi_shrinker;
+	struct radix_tree_root	qi_uquota_tree;
+	struct radix_tree_root	qi_gquota_tree;
+	struct mutex		qi_tree_lock;
+	struct xfs_inode	*qi_uquotaip;
+	struct xfs_inode	*qi_gquotaip;
+	struct list_head	qi_lru_list;
+	struct mutex		qi_lru_lock;
+	int			qi_lru_count;
+	int			qi_dquots;
+	time_t			qi_btimelimit;
+	time_t			qi_itimelimit;
+	time_t			qi_rtbtimelimit;
+	xfs_qwarncnt_t		qi_bwarnlimit;
+	xfs_qwarncnt_t		qi_iwarnlimit;
+	xfs_qwarncnt_t		qi_rtbwarnlimit;
+	struct mutex		qi_quotaofflock;/* to serialize quotaoff */
+	xfs_filblks_t		qi_dqchunklen;	/* #BBs in a chunk of dqs */
+	uint			qi_dqperchunk;	/* #ondisk dqs in above chunk */
+	xfs_qcnt_t		qi_bhardlimit;
+	xfs_qcnt_t		qi_bsoftlimit;
+	xfs_qcnt_t		qi_ihardlimit;
+	xfs_qcnt_t		qi_isoftlimit;
+	xfs_qcnt_t		qi_rtbhardlimit;
+	xfs_qcnt_t		qi_rtbsoftlimit;
+	struct shrinker		qi_shrinker;
 } xfs_quotainfo_t;
 
 static inline struct radix_tree_root *
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
