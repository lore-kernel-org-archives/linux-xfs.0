Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5816729E06
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 08:29:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A9AA304043
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:29:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cleKFu2O7Dy3IqrR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 06:29:32 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 22326C00B8F3
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 14:29:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-22.bos.redhat.com [10.18.41.22])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u1TETVO3001949
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 09:29:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 1/3] xfs: debug mode forced buffered write failure
Date: Mon, 29 Feb 2016 09:29:28 -0500
Message-Id: <1456756170-51248-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
References: <1456756170-51248-1-git-send-email-bfoster@redhat.com>
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

Add a DEBUG mode-only sysfs knob to enable forced buffered write
failure. An additional side effect of this mode is brute force killing
of delayed allocation blocks in the range of the write. The latter is
the prime motiviation behind this patch, as userspace test
infrastructure requires a reliable mechanism to create and split
delalloc extents without causing extent conversion.

Certain fallocate operations (i.e., zero range) were used for this in
the past, but the implementations have changed such that delalloc
extents are flushed and converted to real blocks, rendering the test
useless.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c  |  9 ++++++-
 fs/xfs/xfs_mount.h |  9 +++++++
 fs/xfs/xfs_sysfs.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 85 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 7a467b3..39968f1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1473,6 +1473,7 @@ xfs_vm_write_failed(
 	loff_t			from = pos & (PAGE_CACHE_SIZE - 1);
 	loff_t			to = from + len;
 	struct buffer_head	*bh, *head;
+	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
 
 	/*
 	 * The request pos offset might be 32 or 64 bit, this is all fine
@@ -1514,7 +1515,8 @@ xfs_vm_write_failed(
 		if (!buffer_delay(bh) && !buffer_unwritten(bh))
 			continue;
 
-		if (!buffer_new(bh) && block_offset < i_size_read(inode))
+		if (!mp->m_fail_writes && !buffer_new(bh) &&
+		    block_offset < i_size_read(inode))
 			continue;
 
 		if (buffer_delay(bh))
@@ -1554,6 +1556,7 @@ xfs_vm_write_begin(
 	pgoff_t			index = pos >> PAGE_CACHE_SHIFT;
 	struct page		*page;
 	int			status;
+	struct xfs_mount	*mp = XFS_I(mapping->host)->i_mount;
 
 	ASSERT(len <= PAGE_CACHE_SIZE);
 
@@ -1562,6 +1565,8 @@ xfs_vm_write_begin(
 		return -ENOMEM;
 
 	status = __block_write_begin(page, pos, len, xfs_get_blocks);
+	if (mp->m_fail_writes)
+		status = -EIO;
 	if (unlikely(status)) {
 		struct inode	*inode = mapping->host;
 		size_t		isize = i_size_read(inode);
@@ -1574,6 +1579,8 @@ xfs_vm_write_begin(
 		 * allocated in this write, not blocks that were previously
 		 * written successfully.
 		 */
+		if (mp->m_fail_writes)
+			isize = 0;
 		if (pos + len > isize) {
 			ssize_t start = max_t(ssize_t, pos, isize);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a4e03ab..083a32a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -147,6 +147,15 @@ typedef struct xfs_mount {
 	 * to various other kinds of pain inflicted on the pNFS server.
 	 */
 	__uint32_t		m_generation;
+
+	/*
+	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
+	 * block killing in the event of failed writes. When enabled, all
+	 * buffered writes are forced to fail. All delalloc blocks in the range
+	 * of the write (including pre-existing delalloc blocks!) are tossed as
+	 * part of the write failure error handling sequence.
+	 */
+	bool			m_fail_writes;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 641d625..5f2d28d 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -22,6 +22,9 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_stats.h"
+#include "libxfs/xfs_trans_resv.h"
+#include "libxfs/xfs_format.h"
+#include "xfs_mount.h"
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
@@ -45,16 +48,6 @@ to_attr(struct attribute *attr)
 
 #define ATTR_LIST(name) &xfs_sysfs_attr_##name.attr
 
-/*
- * xfs_mount kobject. This currently has no attributes and thus no need for show
- * and store helpers. The mp kobject serves as the per-mount parent object that
- * is identified by the fsname under sysfs.
- */
-
-struct kobj_type xfs_mp_ktype = {
-	.release = xfs_sysfs_release,
-};
-
 STATIC ssize_t
 xfs_sysfs_object_show(
 	struct kobject		*kobject,
@@ -83,6 +76,71 @@ static const struct sysfs_ops xfs_sysfs_ops = {
 	.store = xfs_sysfs_object_store,
 };
 
+/*
+ * xfs_mount kobject. The mp kobject also serves as the per-mount parent object
+ * that is identified by the fsname under sysfs.
+ */
+
+static inline struct xfs_mount *
+to_mp(struct kobject *kobject)
+{
+	struct xfs_kobj *kobj = to_kobj(kobject);
+
+	return container_of(kobj, struct xfs_mount, m_kobj);
+}
+
+#ifdef DEBUG
+
+STATIC ssize_t
+fail_writes_store(
+	struct kobject		*kobject,
+	const char		*buf,
+	size_t			count)
+{
+	struct xfs_mount	*mp = to_mp(kobject);
+	int			ret;
+	int			val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val == 1)
+		mp->m_fail_writes = true;
+	else if (val == 0)
+		mp->m_fail_writes = false;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+STATIC ssize_t
+fail_writes_show(
+	struct kobject		*kobject,
+	char			*buf)
+{
+	struct xfs_mount	*mp = to_mp(kobject);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_fail_writes ? 1 : 0);
+}
+XFS_SYSFS_ATTR_RW(fail_writes);
+
+#endif /* DEBUG */
+
+static struct attribute *xfs_mp_attrs[] = {
+#ifdef DEBUG
+	ATTR_LIST(fail_writes),
+#endif
+	NULL,
+};
+
+struct kobj_type xfs_mp_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_sysfs_ops,
+	.default_attrs = xfs_mp_attrs,
+};
+
 #ifdef DEBUG
 /* debug */
 
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
