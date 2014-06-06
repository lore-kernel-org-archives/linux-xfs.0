Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E262D7F5A
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 08:13:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B0FC6304053
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 06:13:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YjKQDvAri5zlDu8O for
	<xfs@oss.sgi.com>; Fri, 06 Jun 2014 06:13:36 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s56DDZ8c015581
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:36 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s56DDZRc019504
	for <xfs@oss.sgi.com>; Fri, 6 Jun 2014 09:13:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/6] xfs: add xfs_mount sysfs kobject
Date: Fri,  6 Jun 2014 09:13:31 -0400
Message-Id: <1402060414-22075-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
References: <1402060414-22075-1-git-send-email-bfoster@redhat.com>
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

Embed a base kobject into xfs_mount. This creates a kobject associated
with each XFS mount and a subdirectory in sysfs with the name of the
filesystem. The subdirectory lifecycle matches that of the mount. Also
add the new xfs_sysfs.[c,h] source files with some XFS sysfs
infrastructure to facilitate attribute creation.

Note that there are currently no attributes exported as part of the
xfs_mount kobject. It exists solely to serve as a per-mount container
for child objects.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/Makefile    |  1 +
 fs/xfs/xfs_mount.c | 15 ++++++++++++++-
 fs/xfs/xfs_mount.h |  2 ++
 fs/xfs/xfs_sysfs.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.h | 46 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 119 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_sysfs.c
 create mode 100644 fs/xfs/xfs_sysfs.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c21f435..d8da236 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -51,6 +51,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mru_cache.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
+				   xfs_sysfs.o \
 				   xfs_trans.o \
 				   xfs_xattr.o \
 				   kmem.o \
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8a41aba..656614b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -42,6 +42,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_dinode.h"
+#include "xfs_sysfs.h"
 
 
 #ifdef HAVE_PERCPU_SB
@@ -60,6 +61,8 @@ static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
 static uuid_t *xfs_uuid_table;
 
+extern struct kset *xfs_kset;
+
 /*
  * See if the UUID is unique among mounted XFS filesystems.
  * Mount fails if UUID is nil or a FS with the same UUID is already mounted.
@@ -731,10 +734,16 @@ xfs_mountfs(
 
 	xfs_set_maxicount(mp);
 
-	error = xfs_uuid_mount(mp);
+	mp->m_kobject.kset = xfs_kset;
+	error = xfs_sysfs_init(&mp->m_kobject, &xfs_mp_ktype,
+			&mp->m_kobject_complete, NULL, mp->m_fsname);
 	if (error)
 		goto out;
 
+	error = xfs_uuid_mount(mp);
+	if (error)
+		goto out_remove_sysfs;
+
 	/*
 	 * Set the minimum read and write sizes
 	 */
@@ -989,6 +998,8 @@ xfs_mountfs(
 	xfs_da_unmount(mp);
  out_remove_uuid:
 	xfs_uuid_unmount(mp);
+ out_remove_sysfs:
+	xfs_sysfs_del(&mp->m_kobject, &mp->m_kobject_complete);
  out:
 	return error;
 }
@@ -1071,6 +1082,8 @@ xfs_unmountfs(
 	xfs_errortag_clearall(mp, 0);
 #endif
 	xfs_free_perag(mp);
+
+	xfs_sysfs_del(&mp->m_kobject, &mp->m_kobject_complete);
 }
 
 int
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7295a0b..6d7e5d7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -166,6 +166,8 @@ typedef struct xfs_mount {
 						   on the next remount,rw */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
+	struct kobject		m_kobject;
+	struct completion	m_kobject_complete;
 
 	struct workqueue_struct	*m_data_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
new file mode 100644
index 0000000..41365fe
--- /dev/null
+++ b/fs/xfs/xfs_sysfs.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2014 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/sysfs.h>
+#include "xfs.h"
+#include "xfs_types.h"
+#include "xfs_sb.h"
+#include "xfs_trans_resv.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+
+struct xfs_sysfs_attr {
+	struct attribute attr;
+	ssize_t (*show)(char *buf, void *data);
+	ssize_t (*store)(const char *buf, size_t count, void *data);
+};
+
+#define XFS_SYSFS_ATTR_RW(name) \
+	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_RW(name)
+#define XFS_SYSFS_ATTR_RO(name) \
+	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_RO(name)
+
+#define ATTR_LIST(name) &xfs_sysfs_attr_##name.attr
+
+/*
+ * xfs_mount kobject. This currently has no attributes and thus no need for show
+ * and store helpers. The mp kobject serves as the per-mount parent object that
+ * is identified by the fsname under sysfs.
+ */
+
+STATIC void
+xfs_mp_release(struct kobject *kobj)
+{
+	struct xfs_mount *mp = container_of(kobj, struct xfs_mount, m_kobject);
+
+	complete(&mp->m_kobject_complete);
+}
+
+struct kobj_type xfs_mp_ktype = {
+	.release = xfs_mp_release,
+};
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
new file mode 100644
index 0000000..c885acf
--- /dev/null
+++ b/fs/xfs/xfs_sysfs.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (c) 2014 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef __XFS_SYSFS_H__
+#define __XFS_SYSFS_H__
+
+extern struct kobj_type xfs_mp_ktype;	/* xfs_mount */
+
+static inline int
+xfs_sysfs_init(
+	struct kobject		*kobj,
+	struct kobj_type	*ktype,
+	struct completion	*complete,
+	struct kobject		*parent,
+	const char		*name)
+{
+	init_completion(complete);
+	return kobject_init_and_add(kobj, ktype, parent, "%s", name);
+}
+
+static inline void
+xfs_sysfs_del(
+	struct kobject		*kobj,
+	struct completion	*complete)
+{
+	kobject_del(kobj);
+	kobject_put(kobj);
+	wait_for_completion(complete);
+}
+
+#endif	/* __XFS_SYSFS_H__ */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
