Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 390977F3F
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 13:12:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B32F4AC001
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 11:12:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GrdlxanxFsOGNaMl for
	<xfs@oss.sgi.com>; Fri, 16 May 2014 11:12:48 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4GICmi5014312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 16 May 2014 14:12:48 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s4GIClZb019678
	for <xfs@oss.sgi.com>; Fri, 16 May 2014 14:12:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 1/2] xfs: add basic per-mount sysfs attribute support
Date: Fri, 16 May 2014 14:12:45 -0400
Message-Id: <1400263966-35541-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
References: <1400263966-35541-1-git-send-email-bfoster@redhat.com>
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

Initialize/destroy a kset on module init/fini for XFS. The XFS attribute
directory is represented as /sys/fs/xfs. Create a subdirectory per-mount
based on the system device name.

Also add some basic macros to aid in the addition of sysfs attributes.
This code is modeled after the equivalent mechanism for ext4.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_mount.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h |  2 ++
 fs/xfs/xfs_super.c | 12 ++++++++-
 3 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 944f3d9..9ed9dd0 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -60,6 +60,9 @@ static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
 static uuid_t *xfs_uuid_table;
 
+extern struct kset *xfs_kset;
+static struct kobj_type xfs_ktype;
+
 /*
  * See if the UUID is unique among mounted XFS filesystems.
  * Mount fails if UUID is nil or a FS with the same UUID is already mounted.
@@ -955,6 +958,13 @@ xfs_mountfs(
 	"Unable to allocate reserve blocks. Continuing without reserve pool.");
 	}
 
+	mp->m_kobject.kset = xfs_kset;
+	init_completion(&mp->m_kobject_complete);
+	error = kobject_init_and_add(&mp->m_kobject, &xfs_ktype, NULL,
+				     "%s", mp->m_fsname);
+	if (error)
+		goto out_rtunmount;
+
 	return 0;
 
  out_rtunmount:
@@ -986,6 +996,10 @@ xfs_unmountfs(
 	__uint64_t		resblks;
 	int			error;
 
+	kobject_del(&mp->m_kobject);
+	kobject_put(&mp->m_kobject);
+	wait_for_completion(&mp->m_kobject_complete);
+
 	cancel_delayed_work_sync(&mp->m_eofblocks_work);
 
 	xfs_qm_unmount_quotas(mp);
@@ -2007,3 +2021,68 @@ balance_counter:
 }
 
 #endif
+
+/* sysfs support */
+
+struct xfs_sysfs_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct xfs_mount *mp, char *buf);
+	ssize_t (*store)(struct xfs_mount *mp, const char *buf, size_t count);
+};
+
+#define XFS_SYSFS_ATTR_RW(name) \
+	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_RW(name)
+#define XFS_SYSFS_ATTR_RO(name) \
+	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_RO(name)
+
+#define ATTR_LIST(name) &xfs_sysfs_attr_##name.attr
+
+static struct attribute *xfs_sysfs_attrs[] = {
+	NULL,
+};
+
+STATIC ssize_t
+xfs_sysfs_show(
+	struct kobject *kobj,
+	struct attribute *attr,
+	char *buf)
+{
+	struct xfs_mount *mp = container_of(kobj, struct xfs_mount, m_kobject);
+	struct xfs_sysfs_attr *xfs_attr = container_of(attr,
+		struct xfs_sysfs_attr, attr);
+
+	return xfs_attr->show ? xfs_attr->show(mp, buf) : 0;
+}
+
+STATIC ssize_t
+xfs_sysfs_store(
+	struct kobject *kobj,
+	struct attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	struct xfs_mount *mp = container_of(kobj, struct xfs_mount, m_kobject);
+	struct xfs_sysfs_attr *xfs_attr = container_of(attr,
+		struct xfs_sysfs_attr, attr);
+
+	return xfs_attr->store ? xfs_attr->store(mp, buf, count) : 0;
+}
+
+static struct sysfs_ops xfs_sysfs_ops = {
+	.show = xfs_sysfs_show,
+	.store = xfs_sysfs_store,
+};
+
+STATIC void
+xfs_kobj_release(struct kobject *kobj)
+{
+	struct xfs_mount *mp = container_of(kobj, struct xfs_mount, m_kobject);
+
+	complete(&mp->m_kobject_complete);
+}
+
+static struct kobj_type xfs_ktype = {
+	.release = xfs_kobj_release,
+	.sysfs_ops = &xfs_sysfs_ops,
+	.default_attrs = xfs_sysfs_attrs,
+};
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a466c5e..b7f1cfb 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -172,6 +172,8 @@ typedef struct xfs_mount {
 						   on the next remount,rw */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
+	struct kobject		m_kobject;
+	struct completion	m_kobject_complete;
 
 	struct workqueue_struct	*m_data_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8f0333b..1766214 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -61,6 +61,7 @@
 static const struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
+struct kset *xfs_kset;
 
 #define MNTOPT_LOGBUFS	"logbufs"	/* number of XFS log buffers */
 #define MNTOPT_LOGBSIZE	"logbsize"	/* size of XFS log buffers */
@@ -1761,9 +1762,15 @@ init_xfs_fs(void)
 	if (error)
 		goto out_cleanup_procfs;
 
+	xfs_kset = kset_create_and_add("xfs", NULL, fs_kobj);
+	if (!xfs_kset) {
+		error = -ENOMEM;
+		goto out_sysctl_unregister;;
+	}
+
 	error = xfs_qm_init();
 	if (error)
-		goto out_sysctl_unregister;
+		goto out_kset_unregister;
 
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
@@ -1772,6 +1779,8 @@ init_xfs_fs(void)
 
  out_qm_exit:
 	xfs_qm_exit();
+ out_kset_unregister:
+	kset_unregister(xfs_kset);
  out_sysctl_unregister:
 	xfs_sysctl_unregister();
  out_cleanup_procfs:
@@ -1793,6 +1802,7 @@ exit_xfs_fs(void)
 {
 	xfs_qm_exit();
 	unregister_filesystem(&xfs_fs_type);
+	kset_unregister(xfs_kset);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
 	xfs_buf_terminate();
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
