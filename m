Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F3B917CA1
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 23:12:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B0FDAC002
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 21:12:25 -0700 (PDT)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
	by cuda.sgi.com with ESMTP id Cx7OujAMOzyiGL2T (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Sep 2016 21:12:20 -0700 (PDT)
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] xfs_logprint: fix the transcation type string for
	delaylog-enabled fs
Date: Fri, 9 Sep 2016 12:08:27 +0800
Message-ID: <1473394107-3399-1-git-send-email-houtao1@huawei.com>
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
To: xfs@oss.sgi.com

For delaylog-enabled fs, the only th_type is XFS_TRANS_CHECKPOINT,
but the value of XFS_TRANS_CHECKPOINT had been change from 42 to 40
by xfs commit 61e63ec (xfs: consolidate superblock logging functions),
so return trans_type[type] directly will be incorrect.
And there is no flag for delaylog testing, so the suboptimal solution
is to use super v5 flag instead. For pre-v5 fs used by kernel after
commit 61e63ec, the result of xlog_trans_type will still be incorrect.

before patch:
(1) v5 fs
TRAN:    type: SWAPEXT       tid: 321be024       num_items: 2
TRANS: tid:0x772d0805  type:SWAPEXT  #items:37  trans:0x772d0805  q:0x559104d71bc0

after patch:
(2) v5 fs
TRAN:    type: CHECKPOINT       tid: 321be024       num_items: 2
TRANS: tid:0x772d0805  type:SWAPEXT  #items:37  trans:0x772d0805  q:0x559104d71bc0

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/libxlog.h          |  5 ++---
 logprint/log_misc.c        | 34 ++++++++++++++++++++++++++++++----
 logprint/log_print_all.c   |  5 +++--
 logprint/log_print_trans.c |  9 ++++++---
 logprint/logprint.h        |  5 ++++-
 5 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/include/libxlog.h b/include/libxlog.h
index 0a11ec8..b0d2870 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -104,13 +104,12 @@ extern int	xlog_test_footer(struct xlog *log);
 extern int	xlog_recover(struct xlog *log, int readonly);
 extern void	xlog_recover_print_data(char *p, int len);
 extern void	xlog_recover_print_logitem(xlog_recover_item_t *item);
-extern void	xlog_recover_print_trans_head(xlog_recover_t *tr);
+extern void	xlog_recover_print_trans_head(xlog_recover_t *tr, int delaylog);
 extern int	xlog_print_find_oldest(struct xlog *log, xfs_daddr_t *last_blk);
 
 /* for transactional view */
-extern void	xlog_recover_print_trans_head(xlog_recover_t *tr);
 extern void	xlog_recover_print_trans(xlog_recover_t *trans,
-				struct list_head *itemq, int print);
+				struct list_head *itemq, int print, int delaylog);
 extern int	xlog_do_recovery_pass(struct xlog *log, xfs_daddr_t head_blk,
 				xfs_daddr_t tail_blk, int pass);
 extern int	xlog_recover_do_trans(struct xlog *log, xlog_recover_t *trans,
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 479fc14..066ac59 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -28,7 +28,7 @@
 #define NO_ERROR	(0)
 
 static int logBBsize;
-char *trans_type[] = {
+static char *trans_type[] = {
 	"",
 	"SETATTR",
 	"SETATTR_SIZE",
@@ -207,8 +207,30 @@ xlog_print_find_tid(xlog_tid_t tid, uint was_cont)
     return 1;
 }	/* xlog_print_find_tid */
 
+/*
+ * For delaylog-enabled fs, the only th_type is XFS_TRANS_CHECKPOINT,
+ * but the value of XFS_TRANS_CHECKPOINT had been change from 42 to 40
+ * by xfs commit 61e63ec (xfs: consolidate superblock logging functions),
+ * so return trans_type[type] directly will be incorrect.
+ *
+ * And there is no flag for delaylog testing, so the suboptimal solution
+ * is to use super v5 flag instead. For pre-v5 fs used by kernel after
+ * commit 61e63ec, the result of xlog_trans_type will still be incorrect.
+ */
+int
+xlog_delaylog_on(struct xfs_sb *sb)
+{
+	return (XFS_SB_VERSION_NUM(sb) == XFS_SB_VERSION_5);
+}
+
+const char *
+xlog_trans_type(uint type, int delaylog)
+{
+	return delaylog ? "CHECKPOINT" : trans_type[type];
+}
+
 int
-xlog_print_trans_header(char **ptr, int len)
+xlog_print_trans_header(char **ptr, int len, int delaylog)
 {
     xfs_trans_header_t  *h;
     char		*cptr = *ptr;
@@ -234,7 +256,8 @@ xlog_print_trans_header(char **ptr, int len)
     }
     h = (xfs_trans_header_t *)cptr;
     printf(_("    type: %s       tid: %x       num_items: %d\n"),
-	   trans_type[h->th_type], h->th_tid, h->th_num_items);
+			xlog_trans_type(h->th_type, delaylog),
+			h->th_tid, h->th_num_items);
     return 0;
 }	/* xlog_print_trans_header */
 
@@ -825,6 +848,7 @@ xlog_print_record(
     char		*buf, *ptr;
     int			read_len, skip, lost_context = 0;
     int			ret, n, i, j, k;
+    int         delaylog;
 
     if (print_no_print)
 	    return NO_ERROR;
@@ -917,6 +941,7 @@ xlog_print_record(
     }
 
     ptr = buf;
+    delaylog = xlog_delaylog_on(&log->l_mp->m_sb);
     for (i=0; i<num_ops; i++) {
 	int continued;
 
@@ -955,7 +980,8 @@ xlog_print_record(
 	if (be32_to_cpu(op_head->oh_len) != 0) {
 	    if (*(uint *)ptr == XFS_TRANS_HEADER_MAGIC) {
 		skip = xlog_print_trans_header(&ptr,
-					be32_to_cpu(op_head->oh_len));
+					be32_to_cpu(op_head->oh_len),
+					delaylog);
 	    } else {
 		switch (*(unsigned short *)ptr) {
 		    case XFS_LI_BUF: {
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 0fe354b..ddc5475 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -482,7 +482,8 @@ void
 xlog_recover_print_trans(
 	xlog_recover_t		*trans,
 	struct list_head	*itemq,
-	int			print)
+	int			print,
+	int delaylog)
 {
 	xlog_recover_item_t	*item;
 
@@ -490,7 +491,7 @@ xlog_recover_print_trans(
 		return;
 
 	print_xlog_record_line();
-	xlog_recover_print_trans_head(trans);
+	xlog_recover_print_trans_head(trans, delaylog);
 	list_for_each_entry(item, itemq, ri_list)
 		xlog_recover_print_item(item);
 }
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 9bf2b37..cf653ad 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -22,10 +22,12 @@
 
 void
 xlog_recover_print_trans_head(
-	xlog_recover_t	*tr)
+	xlog_recover_t	*tr,
+	int delaylog)
 {
 	printf(_("TRANS: tid:0x%x  type:%s  #items:%d  trans:0x%x  q:0x%lx\n"),
-	       tr->r_log_tid, trans_type[tr->r_theader.th_type],
+	       tr->r_log_tid,
+		   xlog_trans_type(tr->r_theader.th_type, delaylog),
 	       tr->r_theader.th_num_items,
 	       tr->r_theader.th_tid, (long)&tr->r_itemq);
 }
@@ -36,7 +38,8 @@ xlog_recover_do_trans(
 	xlog_recover_t	*trans,
 	int		pass)
 {
-	xlog_recover_print_trans(trans, &trans->r_itemq, 3);
+	xlog_recover_print_trans(trans, &trans->r_itemq, 3,
+							 xlog_delaylog_on(&log->l_mp->m_sb));
 	return 0;
 }
 
diff --git a/logprint/logprint.h b/logprint/logprint.h
index 0c03c08..95d13d5 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -18,6 +18,8 @@
 #ifndef LOGPRINT_H
 #define LOGPRINT_H
 
+struct xfs_sb;
+
 /* command line flags */
 extern int	print_data;
 extern int	print_only_data;
@@ -30,7 +32,8 @@ extern int	print_no_data;
 extern int	print_no_print;
 
 /* exports */
-extern char *trans_type[];
+extern int xlog_delaylog_on(struct xfs_sb *sb);
+extern const char *xlog_trans_type(uint type, int delaylog);
 
 extern void xlog_print_lseek(struct xlog *, int, xfs_daddr_t, int);
 
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
