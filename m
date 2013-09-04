Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 56C657F53
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:06:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CB7CCAC002
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:06:08 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qfOnSzPF5u7tX1Ay for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:06:07 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLD9-0007cn-HP
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLD9-0003rM-Gn
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/55] xfsprogs: teach logprint about icreate transaction
Date: Thu,  5 Sep 2013 08:05:07 +1000
Message-Id: <1378332359-14737-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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
 include/libxlog.h        |  1 +
 logprint/log_misc.c      | 36 ++++++++++++++++++++++++++++++++++++
 logprint/log_print_all.c | 21 +++++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/include/libxlog.h b/include/libxlog.h
index bd71bfe..ff711e9 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -51,6 +51,7 @@ struct xlog {
 #include <xfs/xfs_buf_item.h>
 #include <xfs/xfs_inode_item.h>
 #include <xfs/xfs_extfree_item.h>
+#include <xfs/xfs_icreate_item.h>
 
 typedef union {
 	xlog_rec_header_t       hic_header;
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index a369e72..623245e 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -70,6 +70,7 @@ char *trans_type[] = {
 	"SWAPEXT",
 	"SB_COUNT",
 	"CHECKPOINT",
+	"ICREATE",
 };
 
 typedef struct xlog_split_item {
@@ -792,6 +793,35 @@ xlog_print_trans_dquot(xfs_caddr_t *ptr, int len, int *i, int num_ops)
 }	/* xlog_print_trans_dquot */
 
 
+STATIC int
+xlog_print_trans_icreate(
+	xfs_caddr_t	*ptr,
+	int		len,
+	int		*i,
+	int		num_ops)
+{
+	struct xfs_icreate_log	icl_buf = {0};
+	struct xfs_icreate_log	*icl;
+
+	memmove(&icl_buf, *ptr, MIN(sizeof(struct xfs_icreate_log), len));
+	icl = &icl_buf;
+	(*i)++;
+	*ptr += len;
+
+	/* handle complete header only */
+	if (len != sizeof(struct xfs_icreate_log)) {
+		printf(_("ICR: split header, not printing\n"));
+		return 1; /* to skip leftover in next region */
+	}
+
+	printf(_("ICR:  #ag: %d  agbno: 0x%x  len: %d\n"
+		 "      cnt: %d  isize: %d    gen: 0x%x\n"),
+		be32_to_cpu(icl->icl_ag), be32_to_cpu(icl->icl_agbno),
+		be32_to_cpu(icl->icl_length), be32_to_cpu(icl->icl_count),
+		be32_to_cpu(icl->icl_isize), be32_to_cpu(icl->icl_gen));
+	return 0;
+}
+
 /******************************************************************************
  *
  *		Log print routines
@@ -974,6 +1004,12 @@ xlog_print_record(int			  fd,
 					&i, num_ops);
 			break;
 		    }
+		    case XFS_LI_ICREATE: {
+			skip = xlog_print_trans_icreate(&ptr,
+					be32_to_cpu(op_head->oh_len),
+					&i, num_ops);
+			break;
+		    }
 		    case XFS_LI_INODE: {
 			skip = xlog_print_trans_inode(&ptr,
 					be32_to_cpu(op_head->oh_len),
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 1194469..8b932d2 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -432,6 +432,21 @@ xlog_recover_print_efi(
 	free(f);
 }
 
+STATIC void
+xlog_recover_print_icreate(
+	struct xlog_recover_item	*item)
+{
+	struct xfs_icreate_log	*icl;
+
+	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
+
+	printf(_("	ICR:  #ag: %d  agbno: 0x%x  len: %d\n"
+		 "	      cnt: %d  isize: %d    gen: 0x%x\n"),
+		be32_to_cpu(icl->icl_ag), be32_to_cpu(icl->icl_agbno),
+		be32_to_cpu(icl->icl_length), be32_to_cpu(icl->icl_count),
+		be32_to_cpu(icl->icl_isize), be32_to_cpu(icl->icl_gen));
+}
+
 void
 xlog_recover_print_logitem(
 	xlog_recover_item_t	*item)
@@ -440,6 +455,9 @@ xlog_recover_print_logitem(
 	case XFS_LI_BUF:
 		xlog_recover_print_buffer(item);
 		break;
+	case XFS_LI_ICREATE:
+		xlog_recover_print_icreate(item);
+		break;
 	case XFS_LI_INODE:
 		xlog_recover_print_inode(item);
 		break;
@@ -471,6 +489,9 @@ xlog_recover_print_item(
 	case XFS_LI_BUF:
 		printf("BUF");
 		break;
+	case XFS_LI_ICREATE:
+		printf("ICR");
+		break;
 	case XFS_LI_INODE:
 		printf("INO");
 		break;
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
