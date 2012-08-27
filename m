Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7RJo1m3237168 for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 14:50:02 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UxtPqrcXa6iB2M0x for
	<xfs@oss.sgi.com>; Mon, 27 Aug 2012 12:50:52 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7RJop7M002574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
Received: from bfoster.bfoster ([10.16.225.83])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q7RJopl2020958
	for <xfs@oss.sgi.com>; Mon, 27 Aug 2012 15:50:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 3/4] xfs: add FREE_EOFBLOCKS ioctl
Date: Mon, 27 Aug 2012 15:51:50 -0400
Message-Id: <1346097111-4476-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
References: <1346097111-4476-1-git-send-email-bfoster@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The XFS_IOC_FREE_EOFBLOCKS ioctl allows users to invoke an EOFBLOCKS
scan. The xfs_eofblocks structure is defined to support the command
parameters (quota type/id and minimum file size).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_fs.h       |   10 ++++++++++
 fs/xfs/xfs_ioctl.c    |   25 +++++++++++++++++++++++++
 fs/xfs/xfs_quota.h    |    1 +
 fs/xfs/xfs_quotaops.c |    2 +-
 4 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index c13fed8..6f93db9 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -339,6 +339,15 @@ typedef struct xfs_error_injection {
 
 
 /*
+ * Speculative preallocation trimming.
+ */
+typedef struct xfs_eofblocks {
+	__u32		id;		/* quota id */
+	__u32		qtype;		/* quota type */
+	__u64		min_file_size;	/* minimum file size */
+} xfs_eofblocks_t;
+
+/*
  * The user-level Handle Request interface structure.
  */
 typedef struct xfs_fsop_handlereq {
@@ -456,6 +465,7 @@ typedef struct xfs_handle {
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
+#define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_eofblocks)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0e0232c..b91cbcd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1602,6 +1602,31 @@ xfs_file_ioctl(
 		error = xfs_errortag_clearall(mp, 1);
 		return -error;
 
+	case XFS_IOC_FREE_EOFBLOCKS: {
+		struct xfs_eofblocks eofb;
+		int qtype;
+
+		if (copy_from_user(&eofb, arg, sizeof(eofb)))
+			return -XFS_ERROR(EFAULT);
+
+		qtype = xfs_quota_type(eofb.qtype);
+
+		/*
+		 * TODO: The filtering code currently uses the id in the inode.
+		 * Therefore, I don't think it really matters whether the
+		 * particular quota type is enabled (and the dquot is attached).
+		 *
+		 * Alternatively, we could filter by dquot type. This would
+		 * mean we might have to make sure dquot's are attached during
+		 * the scan and that the particular quota type is enabled. I'm
+		 * not sure that this buys us anything.
+		 */
+
+		/* TODO: might want to just use the eofb structure here */
+		error = xfs_inodes_free_eofblocks(mp, qtype, eofb.id, eofb.min_file_size, EOFBLOCKS_WAIT);
+		return -error;
+	}
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index b50ec5b..3ec6224 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -379,6 +379,7 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 extern int xfs_qm_dqcheck(struct xfs_mount *, xfs_disk_dquot_t *,
 				xfs_dqid_t, uint, uint, char *);
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
+int xfs_quota_type(int);
 
 #endif	/* __KERNEL__ */
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index fed504f..fe15aa7 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -28,7 +28,7 @@
 #include <linux/quota.h>
 
 
-STATIC int
+int
 xfs_quota_type(int type)
 {
 	switch (type) {
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
