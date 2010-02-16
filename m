Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jcmq132016 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38B5813ACA25
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yLdDaW3TpyyzBXxw for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:55 -0800 (PST)
Message-Id: <20100216084652.729908437@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 09/10] quota: split out compat_sys_quotactl support from
	quota.c
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=split-compat
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

Instead of adding ifdefs just split it into a new file.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/quota/Kconfig
===================================================================
--- linux-2.6.orig/fs/quota/Kconfig	2010-02-11 16:54:42.891004202 +0100
+++ linux-2.6/fs/quota/Kconfig	2010-02-16 00:25:09.291253507 +0100
@@ -59,3 +59,8 @@ config QUOTACTL
 	bool
 	depends on XFS_QUOTA || QUOTA
 	default y
+
+config QUOTACTL_COMPAT
+	bool
+	depends on QUOTACTL && COMPAT_FOR_U64_ALIGNMENT
+	default y
Index: linux-2.6/fs/quota/Makefile
===================================================================
--- linux-2.6.orig/fs/quota/Makefile	2010-02-16 00:25:05.970004101 +0100
+++ linux-2.6/fs/quota/Makefile	2010-02-16 00:25:09.292297927 +0100
@@ -3,4 +3,5 @@ obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
 obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
 obj-$(CONFIG_QUOTA_TREE)	+= quota_tree.o
 obj-$(CONFIG_QUOTACTL)		+= quota.o
+obj-$(CONFIG_QUOTACTL_COMPAT)	+= compat.o
 obj-$(CONFIG_QUOTA_NETLINK_INTERFACE)	+= netlink.o
Index: linux-2.6/fs/quota/compat.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/quota/compat.c	2010-02-16 00:25:09.301004031 +0100
@@ -0,0 +1,118 @@
+
+#include <linux/syscalls.h>
+#include <linux/compat.h>
+#include <linux/quotaops.h>
+
+/*
+ * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
+ * and is necessary due to alignment problems.
+ */
+struct compat_if_dqblk {
+	compat_u64 dqb_bhardlimit;
+	compat_u64 dqb_bsoftlimit;
+	compat_u64 dqb_curspace;
+	compat_u64 dqb_ihardlimit;
+	compat_u64 dqb_isoftlimit;
+	compat_u64 dqb_curinodes;
+	compat_u64 dqb_btime;
+	compat_u64 dqb_itime;
+	compat_uint_t dqb_valid;
+};
+
+/* XFS structures */
+struct compat_fs_qfilestat {
+	compat_u64 dqb_bhardlimit;
+	compat_u64 qfs_nblks;
+	compat_uint_t qfs_nextents;
+};
+
+struct compat_fs_quota_stat {
+	__s8		qs_version;
+	__u16		qs_flags;
+	__s8		qs_pad;
+	struct compat_fs_qfilestat	qs_uquota;
+	struct compat_fs_qfilestat	qs_gquota;
+	compat_uint_t	qs_incoredqs;
+	compat_int_t	qs_btimelimit;
+	compat_int_t	qs_itimelimit;
+	compat_int_t	qs_rtbtimelimit;
+	__u16		qs_bwarnlimit;
+	__u16		qs_iwarnlimit;
+};
+
+asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
+						qid_t id, void __user *addr)
+{
+	unsigned int cmds;
+	struct if_dqblk __user *dqblk;
+	struct compat_if_dqblk __user *compat_dqblk;
+	struct fs_quota_stat __user *fsqstat;
+	struct compat_fs_quota_stat __user *compat_fsqstat;
+	compat_uint_t data;
+	u16 xdata;
+	long ret;
+
+	cmds = cmd >> SUBCMDSHIFT;
+
+	switch (cmds) {
+	case Q_GETQUOTA:
+		dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
+		compat_dqblk = addr;
+		ret = sys_quotactl(cmd, special, id, dqblk);
+		if (ret)
+			break;
+		if (copy_in_user(compat_dqblk, dqblk, sizeof(*compat_dqblk)) ||
+			get_user(data, &dqblk->dqb_valid) ||
+			put_user(data, &compat_dqblk->dqb_valid))
+			ret = -EFAULT;
+		break;
+	case Q_SETQUOTA:
+		dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
+		compat_dqblk = addr;
+		ret = -EFAULT;
+		if (copy_in_user(dqblk, compat_dqblk, sizeof(*compat_dqblk)) ||
+			get_user(data, &compat_dqblk->dqb_valid) ||
+			put_user(data, &dqblk->dqb_valid))
+			break;
+		ret = sys_quotactl(cmd, special, id, dqblk);
+		break;
+	case Q_XGETQSTAT:
+		fsqstat = compat_alloc_user_space(sizeof(struct fs_quota_stat));
+		compat_fsqstat = addr;
+		ret = sys_quotactl(cmd, special, id, fsqstat);
+		if (ret)
+			break;
+		ret = -EFAULT;
+		/* Copying qs_version, qs_flags, qs_pad */
+		if (copy_in_user(compat_fsqstat, fsqstat,
+			offsetof(struct compat_fs_quota_stat, qs_uquota)))
+			break;
+		/* Copying qs_uquota */
+		if (copy_in_user(&compat_fsqstat->qs_uquota,
+			&fsqstat->qs_uquota,
+			sizeof(compat_fsqstat->qs_uquota)) ||
+			get_user(data, &fsqstat->qs_uquota.qfs_nextents) ||
+			put_user(data, &compat_fsqstat->qs_uquota.qfs_nextents))
+			break;
+		/* Copying qs_gquota */
+		if (copy_in_user(&compat_fsqstat->qs_gquota,
+			&fsqstat->qs_gquota,
+			sizeof(compat_fsqstat->qs_gquota)) ||
+			get_user(data, &fsqstat->qs_gquota.qfs_nextents) ||
+			put_user(data, &compat_fsqstat->qs_gquota.qfs_nextents))
+			break;
+		/* Copying the rest */
+		if (copy_in_user(&compat_fsqstat->qs_incoredqs,
+			&fsqstat->qs_incoredqs,
+			sizeof(struct compat_fs_quota_stat) -
+			offsetof(struct compat_fs_quota_stat, qs_incoredqs)) ||
+			get_user(xdata, &fsqstat->qs_iwarnlimit) ||
+			put_user(xdata, &compat_fsqstat->qs_iwarnlimit))
+			break;
+		ret = 0;
+		break;
+	default:
+		ret = sys_quotactl(cmd, special, id, addr);
+	}
+	return ret;
+}
Index: linux-2.6/fs/quota/quota.c
===================================================================
--- linux-2.6.orig/fs/quota/quota.c	2010-02-16 00:25:05.979006127 +0100
+++ linux-2.6/fs/quota/quota.c	2010-02-16 00:25:09.312256301 +0100
@@ -10,7 +10,6 @@
 #include <linux/slab.h>
 #include <asm/current.h>
 #include <asm/uaccess.h>
-#include <linux/compat.h>
 #include <linux/kernel.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
@@ -340,119 +339,3 @@ SYSCALL_DEFINE4(quotactl, unsigned int, 
 	drop_super(sb);
 	return ret;
 }
-
-#if defined(CONFIG_COMPAT_FOR_U64_ALIGNMENT)
-/*
- * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
- * and is necessary due to alignment problems.
- */
-struct compat_if_dqblk {
-	compat_u64 dqb_bhardlimit;
-	compat_u64 dqb_bsoftlimit;
-	compat_u64 dqb_curspace;
-	compat_u64 dqb_ihardlimit;
-	compat_u64 dqb_isoftlimit;
-	compat_u64 dqb_curinodes;
-	compat_u64 dqb_btime;
-	compat_u64 dqb_itime;
-	compat_uint_t dqb_valid;
-};
-
-/* XFS structures */
-struct compat_fs_qfilestat {
-	compat_u64 dqb_bhardlimit;
-	compat_u64 qfs_nblks;
-	compat_uint_t qfs_nextents;
-};
-
-struct compat_fs_quota_stat {
-	__s8		qs_version;
-	__u16		qs_flags;
-	__s8		qs_pad;
-	struct compat_fs_qfilestat	qs_uquota;
-	struct compat_fs_qfilestat	qs_gquota;
-	compat_uint_t	qs_incoredqs;
-	compat_int_t	qs_btimelimit;
-	compat_int_t	qs_itimelimit;
-	compat_int_t	qs_rtbtimelimit;
-	__u16		qs_bwarnlimit;
-	__u16		qs_iwarnlimit;
-};
-
-asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
-						qid_t id, void __user *addr)
-{
-	unsigned int cmds;
-	struct if_dqblk __user *dqblk;
-	struct compat_if_dqblk __user *compat_dqblk;
-	struct fs_quota_stat __user *fsqstat;
-	struct compat_fs_quota_stat __user *compat_fsqstat;
-	compat_uint_t data;
-	u16 xdata;
-	long ret;
-
-	cmds = cmd >> SUBCMDSHIFT;
-
-	switch (cmds) {
-	case Q_GETQUOTA:
-		dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
-		compat_dqblk = addr;
-		ret = sys_quotactl(cmd, special, id, dqblk);
-		if (ret)
-			break;
-		if (copy_in_user(compat_dqblk, dqblk, sizeof(*compat_dqblk)) ||
-			get_user(data, &dqblk->dqb_valid) ||
-			put_user(data, &compat_dqblk->dqb_valid))
-			ret = -EFAULT;
-		break;
-	case Q_SETQUOTA:
-		dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
-		compat_dqblk = addr;
-		ret = -EFAULT;
-		if (copy_in_user(dqblk, compat_dqblk, sizeof(*compat_dqblk)) ||
-			get_user(data, &compat_dqblk->dqb_valid) ||
-			put_user(data, &dqblk->dqb_valid))
-			break;
-		ret = sys_quotactl(cmd, special, id, dqblk);
-		break;
-	case Q_XGETQSTAT:
-		fsqstat = compat_alloc_user_space(sizeof(struct fs_quota_stat));
-		compat_fsqstat = addr;
-		ret = sys_quotactl(cmd, special, id, fsqstat);
-		if (ret)
-			break;
-		ret = -EFAULT;
-		/* Copying qs_version, qs_flags, qs_pad */
-		if (copy_in_user(compat_fsqstat, fsqstat,
-			offsetof(struct compat_fs_quota_stat, qs_uquota)))
-			break;
-		/* Copying qs_uquota */
-		if (copy_in_user(&compat_fsqstat->qs_uquota,
-			&fsqstat->qs_uquota,
-			sizeof(compat_fsqstat->qs_uquota)) ||
-			get_user(data, &fsqstat->qs_uquota.qfs_nextents) ||
-			put_user(data, &compat_fsqstat->qs_uquota.qfs_nextents))
-			break;
-		/* Copying qs_gquota */
-		if (copy_in_user(&compat_fsqstat->qs_gquota,
-			&fsqstat->qs_gquota,
-			sizeof(compat_fsqstat->qs_gquota)) ||
-			get_user(data, &fsqstat->qs_gquota.qfs_nextents) ||
-			put_user(data, &compat_fsqstat->qs_gquota.qfs_nextents))
-			break;
-		/* Copying the rest */
-		if (copy_in_user(&compat_fsqstat->qs_incoredqs,
-			&fsqstat->qs_incoredqs,
-			sizeof(struct compat_fs_quota_stat) -
-			offsetof(struct compat_fs_quota_stat, qs_incoredqs)) ||
-			get_user(xdata, &fsqstat->qs_iwarnlimit) ||
-			put_user(xdata, &compat_fsqstat->qs_iwarnlimit))
-			break;
-		ret = 0;
-		break;
-	default:
-		ret = sys_quotactl(cmd, special, id, addr);
-	}
-	return ret;
-}
-#endif

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
