Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DFC27F51
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 11:56:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 50701304059
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 09:56:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vXOjPBsJCqHTU147 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Aug 2014 09:55:57 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7KGtvip017588
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 12:55:57 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s7KGtu6p012344
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2014 12:55:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/2] xfs: add debug sysfs attribute set
Date: Wed, 20 Aug 2014 12:55:54 -0400
Message-Id: <1408553755-10255-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1408553755-10255-1-git-send-email-bfoster@redhat.com>
References: <1408553755-10255-1-git-send-email-bfoster@redhat.com>
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

Create a top-level debug directory for global debug sysfs attributes.
This directory is added and removed on XFS module initialization and
removal respectively. It typically resides at /sys/fs/xfs/debug. It is
located at the top level of the xfs sysfs hierarchy as attributes might
define global behavior or behavior that must be configured before an xfs
mount is available (e.g., log recovery behavior).

Define the global debug kobject that represents the debug sysfs
directory and add generic attribute show/store helpers to support future
attributes. No debug attributes are exported as of yet.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c | 15 +++++++++++++--
 fs/xfs/xfs_sysfs.c | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.h |  1 +
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b194652..9b5eb02 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -47,6 +47,7 @@
 #include "xfs_dinode.h"
 #include "xfs_filestream.h"
 #include "xfs_quota.h"
+#include "xfs_sysfs.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -61,7 +62,9 @@
 static const struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
-struct kset *xfs_kset;
+
+struct kset *xfs_kset;			/* top-level xfs sysfs dir */
+static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 
 #define MNTOPT_LOGBUFS	"logbufs"	/* number of XFS log buffers */
 #define MNTOPT_LOGBSIZE	"logbsize"	/* size of XFS log buffers */
@@ -1768,10 +1771,15 @@ init_xfs_fs(void)
 		goto out_sysctl_unregister;;
 	}
 
-	error = xfs_qm_init();
+	xfs_dbg_kobj.kobject.kset = xfs_kset;
+	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
 	if (error)
 		goto out_kset_unregister;
 
+	error = xfs_qm_init();
+	if (error)
+		goto out_remove_kobj;
+
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
 		goto out_qm_exit;
@@ -1779,6 +1787,8 @@ init_xfs_fs(void)
 
  out_qm_exit:
 	xfs_qm_exit();
+ out_remove_kobj:
+	xfs_sysfs_del(&xfs_dbg_kobj);
  out_kset_unregister:
 	kset_unregister(xfs_kset);
  out_sysctl_unregister:
@@ -1802,6 +1812,7 @@ exit_xfs_fs(void)
 {
 	xfs_qm_exit();
 	unregister_filesystem(&xfs_fs_type);
+	xfs_sysfs_del(&xfs_dbg_kobj);
 	kset_unregister(xfs_kset);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 9835139..dd31511 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -51,6 +51,46 @@ struct kobj_type xfs_mp_ktype = {
 	.release = xfs_sysfs_release,
 };
 
+/* debug */
+
+static struct attribute *xfs_dbg_attrs[] = {
+	NULL,
+};
+
+STATIC ssize_t
+xfs_dbg_show(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	char			*buf)
+{
+	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
+
+	return xfs_attr->show ? xfs_attr->show(buf, NULL) : 0;
+}
+
+STATIC ssize_t
+xfs_dbg_store(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	const char		*buf,
+	size_t			count)
+{
+	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
+
+	return xfs_attr->store ? xfs_attr->store(buf, count, NULL) : 0;
+}
+
+static struct sysfs_ops xfs_dbg_ops = {
+	.show = xfs_dbg_show,
+	.store = xfs_dbg_store,
+};
+
+struct kobj_type xfs_dbg_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_dbg_ops,
+	.default_attrs = xfs_dbg_attrs,
+};
+
 /* xlog */
 
 STATIC ssize_t
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 54a2091..240eee3 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -20,6 +20,7 @@
 #define __XFS_SYSFS_H__
 
 extern struct kobj_type xfs_mp_ktype;	/* xfs_mount */
+extern struct kobj_type xfs_dbg_ktype;	/* debug */
 extern struct kobj_type xfs_log_ktype;	/* xlog */
 
 static inline struct xfs_kobj *
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
