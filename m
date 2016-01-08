Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BFA787F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 12:36:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E8E8AC002
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 10:36:31 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id D318jZhCLT7eL0BW for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2016 10:36:28 -0800 (PST)
Subject: [PATCH] linux-quota: wire Q_XGETQUOTA2 into generic repquota
References: <568FEA2C.6080708@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <569001AB.5040604@sandeen.net>
Date: Fri, 8 Jan 2016 12:36:27 -0600
MIME-Version: 1.0
In-Reply-To: <568FEA2C.6080708@redhat.com>
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
To: fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.cz>

Here's a patch to hook Q_XGETQUOTA2 into the generic quota
tools repquota command.

Rather than looping over getpwent(), it increments the id sent
into the quotactl until it gets back ESRCH.

If Q_XGETQUOTA2 doesn't exist it falls back to the old method.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/dqblk_xfs.h b/dqblk_xfs.h
index 415e646..6c7693d 100644
--- a/dqblk_xfs.h
+++ b/dqblk_xfs.h
@@ -10,6 +10,7 @@
 #define Q_XFS_QUOTAON	Q_XQUOTAON
 #define Q_XFS_QUOTAOFF	Q_XQUOTAOFF
 #define Q_XFS_GETQUOTA	Q_XGETQUOTA
+#define Q_XFS_GETQUOTA2	Q_XGETQUOTA2
 #define Q_XFS_SETQLIM	Q_XSETQLIM
 #define Q_XFS_GETQSTAT	Q_XGETQSTAT
 #define Q_XFS_QUOTARM	Q_XQUOTARM
diff --git a/quotaio_generic.c b/quotaio_generic.c
index 5001a56..ad84cc0 100644
--- a/quotaio_generic.c
+++ b/quotaio_generic.c
@@ -161,3 +161,52 @@ int generic_scan_dquots(struct quota_handle *h,
 	free(dquot);
 	return ret;
 }
+
+/* Generic quota scanning using Q_XGETQUOTA2... */
+int generic_scan_dquots2(struct quota_handle *h,
+			int (*process_dquot)(struct dquot *dquot, char *dqname),
+			int (*get_dquot)(struct dquot *dquot))
+{
+	struct dquot *dquot = get_empty_dquot();
+	char namebuf[MAXNAMELEN];
+	int ret = 0;
+
+	dquot->dq_id = 0;
+	dquot->dq_h = h;
+	if (h->qh_type == USRQUOTA) {
+		while (1) {
+			ret = scan_one_dquot(dquot, get_dquot);
+			if (ret < 0) {
+				if (errno == ESRCH)
+					ret =0;
+				break;
+			}
+			if (ret > 0)
+				continue;
+			id2name(dquot->dq_id, dquot->dq_h->qh_type, namebuf);
+			ret = process_dquot(dquot, namebuf);
+			if (ret < 0)
+				break;
+			dquot->dq_id++;
+		}
+	} else if (h->qh_type == GRPQUOTA) {
+		while (1) {
+			ret = scan_one_dquot(dquot, get_dquot);
+			if (ret < 0) {
+				if (errno == ESRCH)
+					ret =0;
+				break;
+			}
+			if (ret > 0)
+				continue;
+			id2name(dquot->dq_id, dquot->dq_h->qh_type, namebuf);
+			ret = process_dquot(dquot, namebuf);
+			if (ret < 0)
+				break;
+			dquot->dq_id++;
+		}
+	}
+	free(dquot);
+	return ret;
+}
+
diff --git a/quotaio_generic.h b/quotaio_generic.h
index 5edc11c..099a6b1 100644
--- a/quotaio_generic.h
+++ b/quotaio_generic.h
@@ -26,5 +26,9 @@ int vfs_set_dquot(struct dquot *dquot, int flags);
 int generic_scan_dquots(struct quota_handle *h,
 			int (*process_dquot)(struct dquot *dquot, char *dqname),
 			int (*get_dquot)(struct dquot *dquot));
+/* Generic routine for scanning dquots when kernel can do the scanning */
+int generic_scan_dquots2(struct quota_handle *h,
+			int (*process_dquot)(struct dquot *dquot, char *dqname),
+			int (*get_dquot)(struct dquot *dquot));
 
 #endif
diff --git a/quotaio_xfs.c b/quotaio_xfs.c
index 903c03e..a3f516b 100644
--- a/quotaio_xfs.c
+++ b/quotaio_xfs.c
@@ -192,14 +192,42 @@ static int xfs_get_dquot(struct dquot *dq)
 }
 
 /*
+ *	xfs_scan_dquots helper - processes a single dquot with Q_XGETQUOTA2
+ */
+static int xfs_get_dquot2(struct dquot *dq)
+{
+	struct xfs_kern_dqblk d;
+	int qcmd = QCMD(Q_XFS_GETQUOTA2, dq->dq_h->qh_type);
+	int ret;
+
+	memset(&d, 0, sizeof(d));
+	ret = quotactl(qcmd, dq->dq_h->qh_quotadev, dq->dq_id, (void *)&d);
+	if (ret < 0) {
+		if (errno == ENOENT)
+			return 0;
+		return -1;
+	}
+	dq->dq_id = d.d_id;
+	xfs_kern2utildqblk(&dq->dq_dqb, &d);
+	return 0;
+}
+
+/*
  *	Scan all known dquots and call callback on each
  */
 static int xfs_scan_dquots(struct quota_handle *h, int (*process_dquot) (struct dquot *dquot, char *dqname))
 {
+	int ret;
+
 	if (!XFS_USRQUOTA(h) && !XFS_GRPQUOTA(h))
 		return 0;
 
-	return generic_scan_dquots(h, process_dquot, xfs_get_dquot);
+	ret = generic_scan_dquots2(h, process_dquot, xfs_get_dquot2);
+
+	if (ret)
+		ret = generic_scan_dquots(h, process_dquot, xfs_get_dquot);
+
+	return ret;
 }
 
 /*
diff --git a/quotaio_xfs.h b/quotaio_xfs.h
index 54725b0..eabee3e 100644
--- a/quotaio_xfs.h
+++ b/quotaio_xfs.h
@@ -46,6 +46,7 @@
 #define Q_XSETQLIM   XQM_CMD(0x4)	/* set disk limits only */
 #define Q_XGETQSTAT  XQM_CMD(0x5)	/* returns fs_quota_stat_t struct */
 #define Q_XQUOTARM   XQM_CMD(0x6)	/* free quota files' space */
+#define Q_XGETQUOTA2 XQM_CMD(0x9)	/* get disk limits and usage >= ID */
 
 /*
  * fs_disk_quota structure:

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
