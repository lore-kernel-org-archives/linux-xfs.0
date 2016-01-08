Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D071F7F37
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 10:57:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9778E304039
	for <xfs@oss.sgi.com>; Fri,  8 Jan 2016 08:57:10 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fhWQzblWLx9Pc4rA for <xfs@oss.sgi.com>;
	Fri, 08 Jan 2016 08:57:08 -0800 (PST)
Subject: [PATCH 1/4] quota: add new quotactl Q_XGETQUOTA2
References: <568FEA2C.6080708@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <568FEA63.5020604@sandeen.net>
Date: Fri, 8 Jan 2016 10:57:07 -0600
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

Q_XGETQUOTA2 is exactly like Q_XGETQUOTA, except that it will
return quota information for the id equal to or greater than
the id requested.  In other words, if the specified id has
no quota, the command will return quota information for the
next higher id which does have a quota set.  If no higher id
has an active quota, -ESRCH is returned.

This allows filesystems to do efficient iteration in kernelspace,
much like extN filesystems do in userspace when asked to report
all active quotas.

Today, filesystems such as XFS require getpwent-style iterations,
and for systems which have i.e. LDAP backends, this can be very
slow, or even impossible, if iteration is not allowed in the
configuration.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/quota/quota.c               |   30 ++++++++++++++++++++++++++++++
 include/linux/quota.h          |    2 ++
 include/uapi/linux/dqblk_xfs.h |    1 +
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 3746367..441a4e6 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -33,6 +33,7 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 	/* allow to query information for dquots we "own" */
 	case Q_GETQUOTA:
 	case Q_XGETQUOTA:
+	case Q_XGETQUOTA2:
 		if ((type == USRQUOTA && uid_eq(current_euid(), make_kuid(current_user_ns(), id))) ||
 		    (type == GRPQUOTA && in_egroup_p(make_kgid(current_user_ns(), id))))
 			break;
@@ -625,6 +626,32 @@ static int quota_getxquota(struct super_block *sb, int type, qid_t id,
 	return ret;
 }
 
+/*
+ * Return quota for next active quota >= this id, if any exists,
+ * otherwise return -ESRCH.
+ */
+static int quota_getxquota2(struct super_block *sb, int type, qid_t id,
+			    void __user *addr)
+{
+	struct fs_disk_quota fdq;
+	struct qc_dqblk qdq;
+	struct kqid qid;
+	int ret;
+
+	if (!sb->s_qcop->get_dqblk2)
+		return -ENOSYS;
+	qid = make_kqid(current_user_ns(), type, id);
+	if (!qid_valid(qid))
+		return -EINVAL;
+	ret = sb->s_qcop->get_dqblk2(sb, qid, &id, &qdq);
+	if (ret)
+		return ret;
+	copy_to_xfs_dqblk(&fdq, &qdq, type, id);
+	if (copy_to_user(addr, &fdq, sizeof(fdq)))
+		return -EFAULT;
+	return ret;
+}
+
 static int quota_rmxquota(struct super_block *sb, void __user *addr)
 {
 	__u32 flags;
@@ -690,6 +717,8 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 		return quota_setxquota(sb, type, id, addr);
 	case Q_XGETQUOTA:
 		return quota_getxquota(sb, type, id, addr);
+	case Q_XGETQUOTA2:
+		return quota_getxquota2(sb, type, id, addr);
 	case Q_XQUOTASYNC:
 		if (sb->s_flags & MS_RDONLY)
 			return -EROFS;
@@ -712,6 +741,7 @@ static int quotactl_cmd_write(int cmd)
 	case Q_XGETQSTAT:
 	case Q_XGETQSTATV:
 	case Q_XGETQUOTA:
+	case Q_XGETQUOTA2:
 	case Q_XQUOTASYNC:
 		return 0;
 	}
diff --git a/include/linux/quota.h b/include/linux/quota.h
index b2505ac..49e4f7c 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -425,6 +425,8 @@ struct quotactl_ops {
 	int (*quota_sync)(struct super_block *, int);
 	int (*set_info)(struct super_block *, int, struct qc_info *);
 	int (*get_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
+	int (*get_dqblk2)(struct super_block *, struct kqid, qid_t *,
+			  struct qc_dqblk *);
 	int (*set_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
 	int (*get_state)(struct super_block *, struct qc_state *);
 	int (*rm_xquota)(struct super_block *, unsigned int);
diff --git a/include/uapi/linux/dqblk_xfs.h b/include/uapi/linux/dqblk_xfs.h
index dcd75cc..62441da 100644
--- a/include/uapi/linux/dqblk_xfs.h
+++ b/include/uapi/linux/dqblk_xfs.h
@@ -39,6 +39,7 @@
 #define Q_XQUOTARM	XQM_CMD(6)	/* free disk space used by dquots */
 #define Q_XQUOTASYNC	XQM_CMD(7)	/* delalloc flush, updates dquots */
 #define Q_XGETQSTATV	XQM_CMD(8)	/* newer version of get quota */
+#define Q_XGETQUOTA2	XQM_CMD(9)	/* get disk limits and usage >= ID */
 
 /*
  * fs_disk_quota structure:
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
