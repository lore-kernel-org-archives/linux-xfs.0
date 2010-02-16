Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8ja5V131998 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8142F1D3898
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YqMNTbmHek3HCPhy for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:54 -0800 (PST)
Message-Id: <20100216084650.910278747@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/10] quota: split do_quotactl
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=quotactl-cleanup
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
To: jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, swhiteho@redhat.com, xfs@oss.sgi.com

Split out a helper for each non-trivial command from do_quotactl.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/quota/quota.c
===================================================================
--- linux-2.6.orig/fs/quota/quota.c	2010-02-08 19:26:09.316003867 +0100
+++ linux-2.6/fs/quota/quota.c	2010-02-08 19:28:14.176005193 +0100
@@ -234,122 +234,164 @@ restart:
 	spin_unlock(&sb_lock);
 }
 
-/* Copy parameters and call proper function */
-static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
-		       void __user *addr)
+static int quota_quotaon(struct super_block *sb, int type, int cmd, qid_t id,
+		         void __user *addr)
 {
+	char *pathname;
 	int ret;
 
-	switch (cmd) {
-		case Q_QUOTAON: {
-			char *pathname;
+	pathname = getname(addr);
+	if (IS_ERR(pathname))
+		return PTR_ERR(pathname);
+	ret = sb->s_qcop->quota_on(sb, type, id, pathname, 0);
+	putname(pathname);
+	return ret;
+}
+
+static int quota_getfmt(struct super_block *sb, int type, void __user *addr)
+{
+	__u32 fmt;
+
+	down_read(&sb_dqopt(sb)->dqptr_sem);
+	if (!sb_has_quota_active(sb, type)) {
+		up_read(&sb_dqopt(sb)->dqptr_sem);
+		return -ESRCH;
+	}
+	fmt = sb_dqopt(sb)->info[type].dqi_format->qf_fmt_id;
+	up_read(&sb_dqopt(sb)->dqptr_sem);
+	if (copy_to_user(addr, &fmt, sizeof(fmt)))
+		return -EFAULT;
+	return 0;
+}
+
+static int quota_getinfo(struct super_block *sb, int type, void __user *addr)
+{
+	struct if_dqinfo info;
+	int ret;
+
+	ret = sb->s_qcop->get_info(sb, type, &info);
+	if (!ret && copy_to_user(addr, &info, sizeof(info)))
+		return -EFAULT;
+	return ret;
+}
+
+static int quota_setinfo(struct super_block *sb, int type, void __user *addr)
+{
+	struct if_dqinfo info;
+
+	if (copy_from_user(&info, addr, sizeof(info)))
+		return -EFAULT;
+	return sb->s_qcop->set_info(sb, type, &info);
+}
+
+static int quota_getquota(struct super_block *sb, int type, qid_t id,
+			  void __user *addr)
+{
+	struct if_dqblk idq;
+	int ret;
+
+	ret = sb->s_qcop->get_dqblk(sb, type, id, &idq);
+	if (ret)
+		return ret;
+	if (copy_to_user(addr, &idq, sizeof(idq)))
+		return -EFAULT;
+	return 0;
+}
+
+static int quota_setquota(struct super_block *sb, int type, qid_t id,
+			  void __user *addr)
+{
+	struct if_dqblk idq;
 
-			pathname = getname(addr);
-			if (IS_ERR(pathname))
-				return PTR_ERR(pathname);
-			ret = sb->s_qcop->quota_on(sb, type, id, pathname, 0);
-			putname(pathname);
-			return ret;
-		}
-		case Q_QUOTAOFF:
-			return sb->s_qcop->quota_off(sb, type, 0);
-
-		case Q_GETFMT: {
-			__u32 fmt;
-
-			down_read(&sb_dqopt(sb)->dqptr_sem);
-			if (!sb_has_quota_active(sb, type)) {
-				up_read(&sb_dqopt(sb)->dqptr_sem);
-				return -ESRCH;
-			}
-			fmt = sb_dqopt(sb)->info[type].dqi_format->qf_fmt_id;
-			up_read(&sb_dqopt(sb)->dqptr_sem);
-			if (copy_to_user(addr, &fmt, sizeof(fmt)))
-				return -EFAULT;
-			return 0;
-		}
-		case Q_GETINFO: {
-			struct if_dqinfo info;
-
-			ret = sb->s_qcop->get_info(sb, type, &info);
-			if (ret)
-				return ret;
-			if (copy_to_user(addr, &info, sizeof(info)))
-				return -EFAULT;
-			return 0;
-		}
-		case Q_SETINFO: {
-			struct if_dqinfo info;
-
-			if (copy_from_user(&info, addr, sizeof(info)))
-				return -EFAULT;
-			return sb->s_qcop->set_info(sb, type, &info);
-		}
-		case Q_GETQUOTA: {
-			struct if_dqblk idq;
-
-			ret = sb->s_qcop->get_dqblk(sb, type, id, &idq);
-			if (ret)
-				return ret;
-			if (copy_to_user(addr, &idq, sizeof(idq)))
-				return -EFAULT;
-			return 0;
-		}
-		case Q_SETQUOTA: {
-			struct if_dqblk idq;
-
-			if (copy_from_user(&idq, addr, sizeof(idq)))
-				return -EFAULT;
-			return sb->s_qcop->set_dqblk(sb, type, id, &idq);
-		}
-		case Q_SYNC:
-			if (sb)
-				sync_quota_sb(sb, type);
-			else
-				sync_dquots(type);
-			return 0;
-
-		case Q_XQUOTAON:
-		case Q_XQUOTAOFF:
-		case Q_XQUOTARM: {
-			__u32 flags;
-
-			if (copy_from_user(&flags, addr, sizeof(flags)))
-				return -EFAULT;
-			return sb->s_qcop->set_xstate(sb, flags, cmd);
-		}
-		case Q_XGETQSTAT: {
-			struct fs_quota_stat fqs;
+	if (copy_from_user(&idq, addr, sizeof(idq)))
+		return -EFAULT;
+	return sb->s_qcop->set_dqblk(sb, type, id, &idq);
+}
+
+static int quota_setxstate(struct super_block *sb, int cmd, void __user *addr)
+{
+	__u32 flags;
+
+	if (copy_from_user(&flags, addr, sizeof(flags)))
+		return -EFAULT;
+	return sb->s_qcop->set_xstate(sb, flags, cmd);
+}
+
+static int quota_getxstate(struct super_block *sb, void __user *addr)
+{
+	struct fs_quota_stat fqs;
+	int ret;
 		
-			if ((ret = sb->s_qcop->get_xstate(sb, &fqs)))
-				return ret;
-			if (copy_to_user(addr, &fqs, sizeof(fqs)))
-				return -EFAULT;
-			return 0;
-		}
-		case Q_XSETQLIM: {
-			struct fs_disk_quota fdq;
-
-			if (copy_from_user(&fdq, addr, sizeof(fdq)))
-				return -EFAULT;
-		       return sb->s_qcop->set_xquota(sb, type, id, &fdq);
-		}
-		case Q_XGETQUOTA: {
-			struct fs_disk_quota fdq;
-
-			ret = sb->s_qcop->get_xquota(sb, type, id, &fdq);
-			if (ret)
-				return ret;
-			if (copy_to_user(addr, &fdq, sizeof(fdq)))
-				return -EFAULT;
-			return 0;
-		}
-		case Q_XQUOTASYNC:
-			return sb->s_qcop->quota_sync(sb, type);
-		/* We never reach here unless validity check is broken */
-		default:
-			BUG();
+	ret = sb->s_qcop->get_xstate(sb, &fqs);
+	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
+		return -EFAULT;
+	return ret;
+}
+
+static int quota_setxquota(struct super_block *sb, int type, qid_t id,
+			   void __user *addr)
+{
+	struct fs_disk_quota fdq;
+
+	if (copy_from_user(&fdq, addr, sizeof(fdq)))
+		return -EFAULT;
+	return sb->s_qcop->set_xquota(sb, type, id, &fdq);
+}
+
+static int quota_getxquota(struct super_block *sb, int type, qid_t id,
+			   void __user *addr)
+{
+	struct fs_disk_quota fdq;
+	int ret;
+
+	ret = sb->s_qcop->get_xquota(sb, type, id, &fdq);
+	if (!ret && copy_to_user(addr, &fdq, sizeof(fdq)))
+		return -EFAULT;
+	return ret;
+}
+
+/* Copy parameters and call proper function */
+static int do_quotactl(struct super_block *sb, int type, int cmd, qid_t id,
+		       void __user *addr)
+{
+	switch (cmd) {
+	case Q_QUOTAON:
+		return quota_quotaon(sb, type, cmd, id, addr);
+	case Q_QUOTAOFF:
+		return sb->s_qcop->quota_off(sb, type, 0);
+	case Q_GETFMT:
+		return quota_getfmt(sb, type, addr);
+	case Q_GETINFO:
+		return quota_getinfo(sb, type, addr);
+	case Q_SETINFO:
+		return quota_setinfo(sb, type, addr);
+	case Q_GETQUOTA:
+		return quota_getquota(sb, type, id, addr);
+	case Q_SETQUOTA:
+		return quota_setquota(sb, type, id, addr);
+	case Q_SYNC:
+		if (sb)
+			sync_quota_sb(sb, type);
+		else
+			sync_dquots(type);
+		return 0;
+	case Q_XQUOTAON:
+	case Q_XQUOTAOFF:
+	case Q_XQUOTARM:
+		return quota_setxstate(sb, cmd, addr);
+	case Q_XGETQSTAT:
+		return quota_getxstate(sb, addr);
+	case Q_XSETQLIM:
+		return quota_setxquota(sb, type, id, addr);
+	case Q_XGETQUOTA:
+		return quota_getxquota(sb, type, id, addr);
+	case Q_XQUOTASYNC:
+		return sb->s_qcop->quota_sync(sb, type);
+	/* We never reach here unless validity check is broken */
+	default:
+		BUG();
 	}
+
 	return 0;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
