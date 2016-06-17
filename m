Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F73F7F28
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:30:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17CB7304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:21 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ANE8nEA52Fn2Pk4f (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:19 -0700 (PDT)
Subject: [PATCH 114/119] xfs: create sysfs hooks to scrub various files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:30:10 -0700
Message-ID: <146612700997.12839.14645543192839503554.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Create some sysfs files so that we can scrub various AG metadata
structures.  The interface will be as follows:

# cat /sys/fs/xfs/$dev/check/rmapbt
0:3
# echo 3 > /sys/fs/xfs/$dev/check/rmapbt
-bash: echo: write error: <some error code>

(or it'll just return 0 if the metadata is fine)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile          |    1 
 fs/xfs/xfs_mount.c       |    9 ++
 fs/xfs/xfs_mount.h       |    1 
 fs/xfs/xfs_scrub_sysfs.c |  214 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_scrub_sysfs.h |   26 ++++++
 5 files changed, 250 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_scrub_sysfs.c
 create mode 100644 fs/xfs/xfs_scrub_sysfs.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 8942390..7d93af2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -93,6 +93,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_reflink.o \
+				   xfs_scrub_sysfs.o \
 				   xfs_stats.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index e53853d..1f74f72 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -46,6 +46,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_reflink.h"
 #include "xfs_refcount_btree.h"
+#include "xfs_scrub_sysfs.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -705,10 +706,13 @@ xfs_mountfs(
 	if (error)
 		goto out_del_stats;
 
+	error = xfs_scrub_init(mp);
+	if (error)
+		goto out_remove_error_sysfs;
 
 	error = xfs_uuid_mount(mp);
 	if (error)
-		goto out_remove_error_sysfs;
+		goto out_remove_scrub;
 
 	/*
 	 * Set the minimum read and write sizes
@@ -993,6 +997,8 @@ xfs_mountfs(
 	xfs_da_unmount(mp);
  out_remove_uuid:
 	xfs_uuid_unmount(mp);
+ out_remove_scrub:
+	xfs_scrub_free(mp);
  out_remove_error_sysfs:
 	xfs_error_sysfs_del(mp);
  out_del_stats:
@@ -1093,6 +1099,7 @@ xfs_unmountfs(
 #endif
 	xfs_free_perag(mp);
 
+	xfs_scrub_free(mp);
 	xfs_error_sysfs_del(mp);
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
 	xfs_sysfs_del(&mp->m_kobj);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6b06d24..0e222d2 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -167,6 +167,7 @@ typedef struct xfs_mount {
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
+	struct xfs_kobj		m_scrub_kobj;
 	struct xstats		m_stats;	/* per-fs stats */
 
 	struct workqueue_struct *m_buf_workqueue;
diff --git a/fs/xfs/xfs_scrub_sysfs.c b/fs/xfs/xfs_scrub_sysfs.c
new file mode 100644
index 0000000..9942d55
--- /dev/null
+++ b/fs/xfs/xfs_scrub_sysfs.c
@@ -0,0 +1,214 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_refcount.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_sysfs.h"
+#include <linux/kernel.h>
+
+/* general scrub attributes */
+struct xfs_scrub_attr {
+	struct attribute attr;
+	bool (*is_visible)(struct xfs_mount *mp, struct xfs_scrub_attr *attr);
+	ssize_t (*show)(struct xfs_mount *mp, struct xfs_scrub_attr *attr,
+			char *buf);
+	ssize_t (*store)(struct xfs_mount *mp, struct xfs_scrub_attr *attr,
+			const char *buf, size_t count);
+};
+
+static inline struct xfs_scrub_attr *
+to_scrub_attr(struct attribute *attr)
+{
+	return container_of(attr, struct xfs_scrub_attr, attr);
+}
+
+static inline struct xfs_mount *to_mount(struct kobject	*kobj)
+{
+	struct xfs_kobj *k = container_of(kobj, struct xfs_kobj, kobject);
+
+	return container_of(k, struct xfs_mount, m_scrub_kobj);
+}
+
+STATIC ssize_t
+xfs_scrub_attr_show(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	char			*buf)
+{
+	struct xfs_scrub_attr	*sa = to_scrub_attr(attr);
+	struct xfs_mount	*mp = to_mount(kobject);
+
+	return sa->show ? sa->show(mp, sa, buf) : 0;
+}
+
+STATIC ssize_t
+xfs_scrub_attr_store(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	const char		*buf,
+	size_t			count)
+{
+	struct xfs_scrub_attr	*sa = to_scrub_attr(attr);
+	struct xfs_mount	*mp = to_mount(kobject);
+
+	return sa->store ? sa->store(mp, sa, buf, count) : 0;
+}
+
+STATIC umode_t
+xfs_scrub_attr_visible(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	int unused)
+{
+	struct xfs_scrub_attr	*sa = to_scrub_attr(attr);
+	struct xfs_mount	*mp = to_mount(kobject);
+
+	if (!sa->is_visible || sa->is_visible(mp, sa))
+		return attr->mode;
+	return 0;
+}
+
+static const struct sysfs_ops xfs_scrub_ops = {
+	.show = xfs_scrub_attr_show,
+	.store = xfs_scrub_attr_store,
+};
+
+static struct kobj_type xfs_scrub_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_scrub_ops,
+};
+
+/* per-AG scrub attributes */
+struct xfs_agdata_scrub_attr {
+	struct xfs_scrub_attr sa;
+	bool (*has_feature)(struct xfs_sb *);
+	int (*scrub)(struct xfs_mount *mp, xfs_agnumber_t agno);
+};
+
+static inline struct xfs_agdata_scrub_attr *
+to_agdata_scrub_attr(struct xfs_scrub_attr *sa)
+{
+	return container_of(sa, struct xfs_agdata_scrub_attr, sa);
+}
+
+STATIC bool
+xfs_agdata_scrub_visible(
+	struct xfs_mount		*mp,
+	struct xfs_scrub_attr		*sa)
+{
+	struct xfs_agdata_scrub_attr	*asa = to_agdata_scrub_attr(sa);
+
+	return (!asa->has_feature || asa->has_feature(&mp->m_sb));
+}
+
+STATIC ssize_t
+xfs_agdata_scrub_show(
+	struct xfs_mount		*mp,
+	struct xfs_scrub_attr		*sa,
+	char				*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0:%u\n", mp->m_sb.sb_agcount - 1);
+}
+
+STATIC ssize_t
+xfs_agdata_scrub_store(
+	struct xfs_mount		*mp,
+	struct xfs_scrub_attr		*sa,
+	const char			*buf,
+	size_t				count)
+{
+	unsigned long			val;
+	xfs_agnumber_t			agno;
+	struct xfs_agdata_scrub_attr	*asa = to_agdata_scrub_attr(sa);
+	int				error;
+
+	error = kstrtoul(buf, 0, &val);
+	if (error)
+		return error;
+	agno = val;
+	if (agno >= mp->m_sb.sb_agcount)
+		return -EINVAL;
+	error = asa->scrub(mp, agno);
+	if (error)
+		return error;
+	return count;
+}
+
+#define XFS_AGDATA_SCRUB_ATTR(_name, _fn)	     \
+static struct xfs_agdata_scrub_attr xfs_agdata_scrub_attr_##_name = {	     \
+	.sa = {								     \
+		.attr = {.name = __stringify(_name), .mode = 0600 },	     \
+		.is_visible = xfs_agdata_scrub_visible,			     \
+		.show = xfs_agdata_scrub_show,				     \
+		.store = xfs_agdata_scrub_store,			     \
+	},								     \
+	.has_feature = _fn,						     \
+	.scrub = xfs_##_name##_scrub,				     \
+}
+#define XFS_AGDATA_SCRUB_LIST(name)	&xfs_agdata_scrub_attr_##name.sa.attr
+
+static struct attribute *xfs_agdata_scrub_attrs[] = {
+	NULL,
+};
+
+static const struct attribute_group xfs_agdata_scrub_attr_group = {
+	.is_visible = xfs_scrub_attr_visible,
+	.attrs = xfs_agdata_scrub_attrs,
+};
+
+int
+xfs_scrub_init(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	error = xfs_sysfs_init(&mp->m_scrub_kobj, &xfs_scrub_ktype,
+			&mp->m_kobj, "check");
+	if (error)
+		return error;
+
+	error = sysfs_create_group(&mp->m_scrub_kobj.kobject,
+			&xfs_agdata_scrub_attr_group);
+	if (error)
+		goto err;
+	return error;
+err:
+	xfs_sysfs_del(&mp->m_scrub_kobj);
+	return error;
+}
+
+void
+xfs_scrub_free(
+	struct xfs_mount	*mp)
+{
+	sysfs_remove_group(&mp->m_scrub_kobj.kobject,
+			&xfs_agdata_scrub_attr_group);
+	xfs_sysfs_del(&mp->m_scrub_kobj);
+}
diff --git a/fs/xfs/xfs_scrub_sysfs.h b/fs/xfs/xfs_scrub_sysfs.h
new file mode 100644
index 0000000..d9a58f5
--- /dev/null
+++ b/fs/xfs/xfs_scrub_sysfs.h
@@ -0,0 +1,26 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_SCRUB_H
+#define __XFS_SCRUB_H
+
+int xfs_scrub_init(struct xfs_mount *mp);
+void xfs_scrub_free(struct xfs_mount *mp);
+
+#endif /* __XFS_SCRUB_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
