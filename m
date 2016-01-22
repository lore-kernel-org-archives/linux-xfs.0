Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 65AA87F37
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 12:25:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3FA1AC004
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 10:25:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0KWHorNNMWsSUnko for <xfs@oss.sgi.com>;
	Fri, 22 Jan 2016 10:25:39 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/7] quota: add new quotactl Q_GETNEXTQUOTA
Date: Fri, 22 Jan 2016 12:25:32 -0600
Message-Id: <1453487136-12681-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
References: <1453487136-12681-1-git-send-email-sandeen@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: jack@suse.cz

Q_GETNEXTQUOTA is exactly like Q_GETQUOTA, except that it
will return quota information for the id equal to or greater
than the id requested.  In other words, if the requested id has
no quota, the command will return quota information for the
next higher id which does have a quota set.  If no higher id
has an active quota, -ESRCH is returned.

This allows filesystems to do efficient iteration in kernelspace,
much like extN filesystems do in userspace when asked to report
all active quotas.

This does require a new data structure for userspace, as the
current structure does not include an ID for the returned quota
information.

Today, Ext4 with a hidden quota inode requires getpwent-style
iterations, and for systems which have i.e. LDAP backends,
this can be very slow, or even impossible if iteration is not
allowed in the configuration.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/quota/quota.c           |   30 ++++++++++++++++++++++++++++++
 include/uapi/linux/quota.h |   14 ++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 0a6dd71..ffa4e0b 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -222,6 +222,34 @@ static int quota_getquota(struct super_block *sb, int type, qid_t id,
 	return 0;
 }
 
+/*
+ * Return quota for next active quota >= this id, if any exists,
+ * otherwise return -ESRCH via ->get_nextdqblk
+ */
+static int quota_getnextquota(struct super_block *sb, int type, qid_t id,
+			  void __user *addr)
+{
+	struct kqid qid;
+	struct qc_dqblk fdq;
+	struct if_nextdqblk idq;
+	int ret;
+
+	if (!sb->s_qcop->get_nextdqblk)
+		return -ENOSYS;
+	qid = make_kqid(current_user_ns(), type, id);
+	if (!qid_valid(qid))
+		return -EINVAL;
+	ret = sb->s_qcop->get_nextdqblk(sb, &qid, &fdq);
+	if (ret)
+		return ret;
+	/* struct if_nextdqblk is a superset of struct if_dqblk */
+	copy_to_if_dqblk((struct if_dqblk *)&idq, &fdq);
+	idq.dqb_id = from_kqid(current_user_ns(), qid);
+	if (copy_to_user(addr, &idq, sizeof(idq)))
+		return -EFAULT;
+	return 0;
+}
+
 static void copy_from_if_dqblk(struct qc_dqblk *dst, struct if_dqblk *src)
 {
 	dst->d_spc_hardlimit = qbtos(src->dqb_bhardlimit);
@@ -698,6 +726,8 @@ static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
 		return quota_setinfo(sb, type, addr);
 	case Q_GETQUOTA:
 		return quota_getquota(sb, type, id, addr);
+	case Q_GETNEXTQUOTA:
+		return quota_getnextquota(sb, type, id, addr);
 	case Q_SETQUOTA:
 		return quota_setquota(sb, type, id, addr);
 	case Q_SYNC:
diff --git a/include/uapi/linux/quota.h b/include/uapi/linux/quota.h
index 9c95b2c..38baddb 100644
--- a/include/uapi/linux/quota.h
+++ b/include/uapi/linux/quota.h
@@ -71,6 +71,7 @@
 #define Q_SETINFO  0x800006	/* set information about quota files */
 #define Q_GETQUOTA 0x800007	/* get user quota structure */
 #define Q_SETQUOTA 0x800008	/* set user quota structure */
+#define Q_GETNEXTQUOTA 0x800009	/* get disk limits and usage >= ID */
 
 /* Quota format type IDs */
 #define	QFMT_VFS_OLD 1
@@ -119,6 +120,19 @@ struct if_dqblk {
 	__u32 dqb_valid;
 };
 
+struct if_nextdqblk {
+	__u64 dqb_bhardlimit;
+	__u64 dqb_bsoftlimit;
+	__u64 dqb_curspace;
+	__u64 dqb_ihardlimit;
+	__u64 dqb_isoftlimit;
+	__u64 dqb_curinodes;
+	__u64 dqb_btime;
+	__u64 dqb_itime;
+	__u32 dqb_valid;
+	__u32 dqb_id;
+};
+
 /*
  * Structure used for setting quota information about file via quotactl
  * Following flags are used to specify which fields are valid
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
