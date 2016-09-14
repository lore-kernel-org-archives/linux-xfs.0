Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AEC87CA0
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 06:40:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2A15B8F8049
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2016 04:40:33 -0700 (PDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
	by cuda.sgi.com with ESMTP id PyLs9mr8dp6hjDMj (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Sep 2016 04:40:29 -0700 (PDT)
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] xfs_logprint: remove the printing of transaction type
Date: Wed, 14 Sep 2016 19:31:54 +0800
Message-ID: <1473852714-192623-1-git-send-email-houtao1@huawei.com>
In-Reply-To: <20160914053110.GM30497@dastard>
References: <20160914053110.GM30497@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

th_type in struct xfs_trans_header was used to store
the transaction type for xfs without delaylog feature.
Now delaylog is a built-in feature (commit 93b8a58 "xfs:
remove the deprecated nodelaylog option" v3.3-rc1), so
remove the printing of transaction type.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 logprint/log_misc.c        | 50 ++--------------------------------------------
 logprint/log_print_trans.c |  4 ++--
 logprint/logprint.h        |  2 --
 3 files changed, 4 insertions(+), 52 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 479fc14..e4af09b 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -28,52 +28,6 @@
 #define NO_ERROR	(0)
 
 static int logBBsize;
-char *trans_type[] = {
-	"",
-	"SETATTR",
-	"SETATTR_SIZE",
-	"INACTIVE",
-	"CREATE",
-	"CREATE_TRUNC",
-	"TRUNCATE_FILE",
-	"REMOVE",
-	"LINK",
-	"RENAME",
-	"MKDIR",
-	"RMDIR",
-	"SYMLINK",
-	"SET_DMATTRS",
-	"GROWFS",
-	"STRAT_WRITE",
-	"DIOSTRAT",
-	"WRITE_SYNC",
-	"WRITEID",
-	"ADDAFORK",
-	"ATTRINVAL",
-	"ATRUNCATE",
-	"ATTR_SET",
-	"ATTR_RM",
-	"ATTR_FLAG",
-	"CLEAR_AGI_BUCKET",
-	"QM_SBCHANGE",
-	"DUMMY1",
-	"DUMMY2",
-	"QM_QUOTAOFF",
-	"QM_DQALLOC",
-	"QM_SETQLIM",
-	"QM_DQCLUSTER",
-	"QM_QINOCREATE",
-	"QM_QUOTAOFF_END",
-	"SB_UNIT",
-	"FSYNC_TS",
-	"GROWFSRT_ALLOC",
-	"GROWFSRT_ZERO",
-	"GROWFSRT_FREE",
-	"SWAPEXT",
-	"SB_COUNT",
-	"CHECKPOINT",
-	"ICREATE",
-};
 
 typedef struct xlog_split_item {
 	struct xlog_split_item	*si_next;
@@ -233,8 +187,8 @@ xlog_print_trans_header(char **ptr, int len)
 	return 1;
     }
     h = (xfs_trans_header_t *)cptr;
-    printf(_("    type: %s       tid: %x       num_items: %d\n"),
-	   trans_type[h->th_type], h->th_tid, h->th_num_items);
+    printf(_("     tid: %x  num_items: %d\n"),
+	   h->th_tid, h->th_num_items);
     return 0;
 }	/* xlog_print_trans_header */
 
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 9bf2b37..0fecbce 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -24,8 +24,8 @@ void
 xlog_recover_print_trans_head(
 	xlog_recover_t	*tr)
 {
-	printf(_("TRANS: tid:0x%x  type:%s  #items:%d  trans:0x%x  q:0x%lx\n"),
-	       tr->r_log_tid, trans_type[tr->r_theader.th_type],
+	printf(_("TRANS: tid:0x%x  #items:%d  trans:0x%x  q:0x%lx\n"),
+	       tr->r_log_tid,
 	       tr->r_theader.th_num_items,
 	       tr->r_theader.th_tid, (long)&tr->r_itemq);
 }
diff --git a/logprint/logprint.h b/logprint/logprint.h
index 0c03c08..bdd0ee1 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -30,8 +30,6 @@ extern int	print_no_data;
 extern int	print_no_print;
 
 /* exports */
-extern char *trans_type[];
-
 extern void xlog_print_lseek(struct xlog *, int, xfs_daddr_t, int);
 
 extern void xfs_log_copy(struct xlog *, int, char *);
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
