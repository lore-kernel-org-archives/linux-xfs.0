Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FFF17F54
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 06:39:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6E83F304051
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 04:39:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UOI5lJuWbuodj6I9 for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 04:39:42 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UX8uJ-0005sQ-0b
	for xfs@oss.sgi.com; Tue, 30 Apr 2013 21:39:39 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UX8uI-0004lZ-Tg
	for xfs@oss.sgi.com; Tue, 30 Apr 2013 21:39:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: fix da node magic number mismatches
Date: Tue, 30 Apr 2013 21:39:36 +1000
Message-Id: <1367321976-18268-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1367321976-18268-1-git-send-email-david@fromorbit.com>
References: <1367321976-18268-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_da_btree.c    |    2 +-
 fs/xfs/xfs_log_recover.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_da_btree.c b/fs/xfs/xfs_da_btree.c
index 56814e3..9b26a99 100644
--- a/fs/xfs/xfs_da_btree.c
+++ b/fs/xfs/xfs_da_btree.c
@@ -310,8 +310,8 @@ xfs_da3_node_read(
 		int			type;
 
 		switch (be16_to_cpu(info->magic)) {
-		case XFS_DA3_NODE_MAGIC:
 		case XFS_DA_NODE_MAGIC:
+		case XFS_DA3_NODE_MAGIC:
 			type = XFS_BLFT_DA_NODE_BUF;
 			break;
 		case XFS_ATTR_LEAF_MAGIC:
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ecaa4d4..93f03ec 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2039,7 +2039,7 @@ xlog_recovery_validate_buf_type(
 	case XFS_BLFT_ATTR_RMT_BUF:
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			break;
-		if (magicda != XFS_ATTR3_RMT_MAGIC) {
+		if (magic32 != XFS_ATTR3_RMT_MAGIC) {
 			xfs_warn(mp, "Bad attr remote magic!");
 			ASSERT(0);
 			break;
@@ -2135,7 +2135,6 @@ xlog_recover_do_reg_buffer(
 	ASSERT(i == item->ri_total);
 
 	xlog_recovery_validate_buf_type(mp, bp, buf_f);
-
 }
 
 /*
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
