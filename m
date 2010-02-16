Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1G8jcvZ132017 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 02:45:38 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 330411CD31F0
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:56 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id LuAjb0b8ebEl0SNd for
	<xfs@oss.sgi.com>; Tue, 16 Feb 2010 00:46:56 -0800 (PST)
Message-Id: <20100216084652.418098517@bombadil.infradead.org>
Date: Tue, 16 Feb 2010 03:44:54 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/10] quota: split out netlink notification support from
	quota.c
References: <20100216084446.377980079@bombadil.infradead.org>
Content-Disposition: inline; filename=split-netlink
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

Index: linux-2.6/fs/quota/Makefile
===================================================================
--- linux-2.6.orig/fs/quota/Makefile	2010-02-16 00:02:46.729003262 +0100
+++ linux-2.6/fs/quota/Makefile	2010-02-16 00:25:05.970004101 +0100
@@ -3,3 +3,4 @@ obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
 obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
 obj-$(CONFIG_QUOTA_TREE)	+= quota_tree.o
 obj-$(CONFIG_QUOTACTL)		+= quota.o
+obj-$(CONFIG_QUOTA_NETLINK_INTERFACE)	+= netlink.o
Index: linux-2.6/fs/quota/netlink.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/fs/quota/netlink.c	2010-02-16 00:25:05.970004101 +0100
@@ -0,0 +1,95 @@
+
+#include <linux/cred.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/quotaops.h>
+#include <linux/sched.h>
+#include <net/netlink.h>
+#include <net/genetlink.h>
+
+/* Netlink family structure for quota */
+static struct genl_family quota_genl_family = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = "VFS_DQUOT",
+	.version = 1,
+	.maxattr = QUOTA_NL_A_MAX,
+};
+
+/**
+ * quota_send_warning - Send warning to userspace about exceeded quota
+ * @type: The quota type: USRQQUOTA, GRPQUOTA,...
+ * @id: The user or group id of the quota that was exceeded
+ * @dev: The device on which the fs is mounted (sb->s_dev)
+ * @warntype: The type of the warning: QUOTA_NL_...
+ *
+ * This can be used by filesystems (including those which don't use
+ * dquot) to send a message to userspace relating to quota limits.
+ *
+ */
+
+void quota_send_warning(short type, unsigned int id, dev_t dev,
+			const char warntype)
+{
+	static atomic_t seq;
+	struct sk_buff *skb;
+	void *msg_head;
+	int ret;
+	int msg_size = 4 * nla_total_size(sizeof(u32)) +
+		       2 * nla_total_size(sizeof(u64));
+
+	/* We have to allocate using GFP_NOFS as we are called from a
+	 * filesystem performing write and thus further recursion into
+	 * the fs to free some data could cause deadlocks. */
+	skb = genlmsg_new(msg_size, GFP_NOFS);
+	if (!skb) {
+		printk(KERN_ERR
+		  "VFS: Not enough memory to send quota warning.\n");
+		return;
+	}
+	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
+			&quota_genl_family, 0, QUOTA_NL_C_WARNING);
+	if (!msg_head) {
+		printk(KERN_ERR
+		  "VFS: Cannot store netlink header in quota warning.\n");
+		goto err_out;
+	}
+	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, type);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, id);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MAJOR, MAJOR(dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR, MINOR(dev));
+	if (ret)
+		goto attr_err_out;
+	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current_uid());
+	if (ret)
+		goto attr_err_out;
+	genlmsg_end(skb, msg_head);
+
+	genlmsg_multicast(skb, 0, quota_genl_family.id, GFP_NOFS);
+	return;
+attr_err_out:
+	printk(KERN_ERR "VFS: Not enough space to compose quota message!\n");
+err_out:
+	kfree_skb(skb);
+}
+EXPORT_SYMBOL(quota_send_warning);
+
+static int __init quota_init(void)
+{
+	if (genl_register_family(&quota_genl_family) != 0)
+		printk(KERN_ERR
+		       "VFS: Failed to create quota netlink interface.\n");
+	return 0;
+};
+
+module_init(quota_init);
Index: linux-2.6/fs/quota/quota.c
===================================================================
--- linux-2.6.orig/fs/quota/quota.c	2010-02-16 00:24:58.589255532 +0100
+++ linux-2.6/fs/quota/quota.c	2010-02-16 00:25:05.979006127 +0100
@@ -19,8 +19,6 @@
 #include <linux/quotaops.h>
 #include <linux/types.h>
 #include <linux/writeback.h>
-#include <net/netlink.h>
-#include <net/genetlink.h>
 
 static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 				     qid_t id)
@@ -458,94 +456,3 @@ asmlinkage long sys32_quotactl(unsigned 
 	return ret;
 }
 #endif
-
-
-#ifdef CONFIG_QUOTA_NETLINK_INTERFACE
-
-/* Netlink family structure for quota */
-static struct genl_family quota_genl_family = {
-	.id = GENL_ID_GENERATE,
-	.hdrsize = 0,
-	.name = "VFS_DQUOT",
-	.version = 1,
-	.maxattr = QUOTA_NL_A_MAX,
-};
-
-/**
- * quota_send_warning - Send warning to userspace about exceeded quota
- * @type: The quota type: USRQQUOTA, GRPQUOTA,...
- * @id: The user or group id of the quota that was exceeded
- * @dev: The device on which the fs is mounted (sb->s_dev)
- * @warntype: The type of the warning: QUOTA_NL_...
- *
- * This can be used by filesystems (including those which don't use
- * dquot) to send a message to userspace relating to quota limits.
- *
- */
-
-void quota_send_warning(short type, unsigned int id, dev_t dev,
-			const char warntype)
-{
-	static atomic_t seq;
-	struct sk_buff *skb;
-	void *msg_head;
-	int ret;
-	int msg_size = 4 * nla_total_size(sizeof(u32)) +
-		       2 * nla_total_size(sizeof(u64));
-
-	/* We have to allocate using GFP_NOFS as we are called from a
-	 * filesystem performing write and thus further recursion into
-	 * the fs to free some data could cause deadlocks. */
-	skb = genlmsg_new(msg_size, GFP_NOFS);
-	if (!skb) {
-		printk(KERN_ERR
-		  "VFS: Not enough memory to send quota warning.\n");
-		return;
-	}
-	msg_head = genlmsg_put(skb, 0, atomic_add_return(1, &seq),
-			&quota_genl_family, 0, QUOTA_NL_C_WARNING);
-	if (!msg_head) {
-		printk(KERN_ERR
-		  "VFS: Cannot store netlink header in quota warning.\n");
-		goto err_out;
-	}
-	ret = nla_put_u32(skb, QUOTA_NL_A_QTYPE, type);
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_EXCESS_ID, id);
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u32(skb, QUOTA_NL_A_WARNING, warntype);
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MAJOR, MAJOR(dev));
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u32(skb, QUOTA_NL_A_DEV_MINOR, MINOR(dev));
-	if (ret)
-		goto attr_err_out;
-	ret = nla_put_u64(skb, QUOTA_NL_A_CAUSED_ID, current_uid());
-	if (ret)
-		goto attr_err_out;
-	genlmsg_end(skb, msg_head);
-
-	genlmsg_multicast(skb, 0, quota_genl_family.id, GFP_NOFS);
-	return;
-attr_err_out:
-	printk(KERN_ERR "VFS: Not enough space to compose quota message!\n");
-err_out:
-	kfree_skb(skb);
-}
-EXPORT_SYMBOL(quota_send_warning);
-
-static int __init quota_init(void)
-{
-	if (genl_register_family(&quota_genl_family) != 0)
-		printk(KERN_ERR
-		       "VFS: Failed to create quota netlink interface.\n");
-	return 0;
-};
-
-module_init(quota_init);
-#endif
-

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
