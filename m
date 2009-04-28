Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3SGIju7111930 for <xfs@oss.sgi.com>; Tue, 28 Apr 2009 11:18:46 -0500
Received: from v007470.home.net.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 73D8E1456F9F
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2009 09:22:02 -0700 (PDT)
Received: from v007470.home.net.pl (v007470.home.net.pl [212.85.125.104]) by
	cuda.sgi.com with SMTP id n0d0qyTGSTkjeal7 for
	<xfs@oss.sgi.com>; Tue, 28 Apr 2009 09:22:02 -0700 (PDT)
From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: generating uevents by xfs
Date: Tue, 28 Apr 2009 18:18:31 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Yxy9JY+IVsuLkno"
Message-Id: <200904281818.32127.kb@sysmikro.com.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--Boundary-00=_Yxy9JY+IVsuLkno
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

once upon i was asked to think about such facility for notifying userspace 
when some mount point is nearly full at some level let's say e.g. 90% 
(threshold should be configurable).

here is a solution designed by me and i would like to see comments on this 
idea and solution.

i verified these patches with 2.6.27.19 (SuSE) but there are also patches for 
2.6.28.4 and 2.6.29.2 but i haven't given a try to latest two kernels.

to use it one may need to pick right *-1- patch and the *-2 patch.


Krzysztof Blaszkowski

--Boundary-00=_Yxy9JY+IVsuLkno
Content-Type: text/x-diff;
  charset="us-ascii";
  name="xfs-sysfs-1-26292.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs-sysfs-1-26292.diff"

diff --git a/xfs/Makefile b/xfs/Makefile
index c3dc491..b0a1330 100644
--- a/xfs/Makefile
+++ b/xfs/Makefile
@@ -88,7 +88,8 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_vnodeops.o \
 				   xfs_rw.o \
 				   xfs_dmops.o \
-				   xfs_qmops.o
+				   xfs_qmops.o \
+				   xfs_sysfs.o
 
 xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o \
 				   xfs_dir2_trace.o
diff --git a/xfs/linux-2.6/xfs_super.c b/xfs/linux-2.6/xfs_super.c
index 32ae502..99ac6ed 100644
--- a/xfs/linux-2.6/xfs_super.c
+++ b/xfs/linux-2.6/xfs_super.c
@@ -1082,6 +1082,9 @@ xfs_fs_put_super(
 	xfs_close_devices(mp);
 	xfs_qmops_put(mp);
 	xfs_dmops_put(mp);
+#ifdef CONFIG_SYSFS
+	xfs_event_release(mp);
+#endif
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1509,6 +1512,9 @@ xfs_fs_fill_super(
 
 	kfree(mtpt);
 
+#ifdef CONFIG_SYSFS
+	xfs_event_alloc(mp);
+#endif
 	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
 	return 0;
 
@@ -1873,6 +1879,10 @@ init_xfs_fs(void)
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
 		goto out_sysctl_unregister;
+
+#ifdef CONFIG_SYSFS
+	xfs_sysfs_init();
+#endif	
 	return 0;
 
  out_sysctl_unregister:
@@ -1906,6 +1916,9 @@ exit_xfs_fs(void)
 	xfs_free_trace_bufs();
 	xfs_destroy_zones();
 	ktrace_uninit();
+#ifdef CONFIG_SYSFS
+	xfs_sysfs_done();
+#endif	
 }
 
 module_init(init_xfs_fs);
diff --git a/xfs/xfs_mount.c b/xfs/xfs_mount.c
index 3530025..c19fc17 100644
--- a/xfs/xfs_mount.c
+++ b/xfs/xfs_mount.c
@@ -2413,3 +2413,25 @@ balance_counter:
 }
 
 #endif
+
+
+__uint64_t xfs_icsb_get_fdblocks_lazy(xfs_mount_t *mp)
+{
+        __uint64_t fdblocks = 0;
+#ifdef HAVE_PERCPU_SB
+        xfs_icsb_cnts_t *cntp;
+        int i;
+
+        for_each_online_cpu(i) {
+                cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
+                fdblocks += cntp->icsb_fdblocks;
+        }
+
+        if (xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
+                fdblocks = mp->m_sb.sb_fdblocks;
+#else
+        fdblocks = mp->m_sb.sb_fdblocks;
+#endif
+        return fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+}
+
diff --git a/xfs/xfs_mount.h b/xfs/xfs_mount.h
index f5e9937..45ef4cb 100644
--- a/xfs/xfs_mount.h
+++ b/xfs/xfs_mount.h
@@ -329,6 +329,9 @@ typedef struct xfs_mount {
 	wait_queue_head_t	m_wait_single_sync_task;
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
+#ifdef CONFIG_SYSFS
+	void *event_onlow;
+#endif
 } xfs_mount_t;
 
 /*
@@ -528,6 +531,13 @@ extern void	xfs_qmops_put(struct xfs_mount *);
 
 extern struct xfs_dmops xfs_dmcore_xfs;
 
+#ifdef CONFIG_SYSFS
+extern void xfs_sysfs_init(void);
+extern void xfs_sysfs_done(void);
+extern int xfs_event_alloc(struct xfs_mount *mnt);
+extern int xfs_event_release(struct xfs_mount *mnt);
+#endif
+
 #endif	/* __KERNEL__ */
 
 extern void	xfs_mod_sb(struct xfs_trans *, __int64_t);

--Boundary-00=_Yxy9JY+IVsuLkno
Content-Type: text/x-diff;
  charset="us-ascii";
  name="xfs-sysfs-1-26284.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs-sysfs-1-26284.diff"

diff --git a/xfs/Makefile b/xfs/Makefile
index 737c9a4..1df5f4e 100644
--- a/xfs/Makefile
+++ b/xfs/Makefile
@@ -89,7 +89,8 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_vnodeops.o \
 				   xfs_rw.o \
 				   xfs_dmops.o \
-				   xfs_qmops.o
+				   xfs_qmops.o \
+				   xfs_sysfs.o
 
 xfs-$(CONFIG_XFS_TRACE)		+= xfs_dir2_trace.o
 
diff --git a/xfs/linux-2.6/xfs_super.c b/xfs/linux-2.6/xfs_super.c
index 37ebe36..7cc0b6b 100644
--- a/xfs/linux-2.6/xfs_super.c
+++ b/xfs/linux-2.6/xfs_super.c
@@ -1152,6 +1152,9 @@ xfs_fs_put_super(
 	xfs_close_devices(mp);
 	xfs_qmops_put(mp);
 	xfs_dmops_put(mp);
+#ifdef CONFIG_SYSFS
+	xfs_event_release(mp);
+#endif
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1783,6 +1786,9 @@ xfs_fs_fill_super(
 	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
 
 	kfree(args);
+#ifdef CONFIG_SYSFS
+	xfs_event_alloc(mp);
+#endif
 	return 0;
 
  out_filestream_unmount:
@@ -2142,6 +2148,10 @@ init_xfs_fs(void)
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
 		goto out_sysctl_unregister;
+
+#ifdef CONFIG_SYSFS
+	xfs_sysfs_init();
+#endif	
 	return 0;
 
  out_sysctl_unregister:
@@ -2175,6 +2185,9 @@ exit_xfs_fs(void)
 	xfs_free_trace_bufs();
 	xfs_destroy_zones();
 	ktrace_uninit();
+#ifdef CONFIG_SYSFS
+	xfs_sysfs_done();
+#endif	
 }
 
 module_init(init_xfs_fs);
diff --git a/xfs/xfs_mount.c b/xfs/xfs_mount.c
index 15f5dd2..47e8202 100644
--- a/xfs/xfs_mount.c
+++ b/xfs/xfs_mount.c
@@ -2442,3 +2442,25 @@ balance_counter:
 }
 
 #endif
+
+
+__uint64_t xfs_icsb_get_fdblocks_lazy(xfs_mount_t *mp)
+{
+        __uint64_t fdblocks = 0;
+#ifdef HAVE_PERCPU_SB
+        xfs_icsb_cnts_t *cntp;
+        int i;
+
+        for_each_online_cpu(i) {
+                cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
+                fdblocks += cntp->icsb_fdblocks;
+        }
+
+        if (xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
+                fdblocks = mp->m_sb.sb_fdblocks;
+#else
+        fdblocks = mp->m_sb.sb_fdblocks;
+#endif
+        return fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+}
+
diff --git a/xfs/xfs_mount.h b/xfs/xfs_mount.h
index f3c1024..9a98c44 100644
--- a/xfs/xfs_mount.h
+++ b/xfs/xfs_mount.h
@@ -341,6 +341,9 @@ typedef struct xfs_mount {
 	spinlock_t		m_sync_lock;	/* work item list lock */
 	int			m_sync_seq;	/* sync thread generation no. */
 	wait_queue_head_t	m_wait_single_sync_task;
+#ifdef CONFIG_SYSFS
+	void *event_onlow;
+#endif
 } xfs_mount_t;
 
 /*
@@ -539,6 +542,13 @@ extern void	xfs_qmops_put(struct xfs_mou
 
 extern struct xfs_dmops xfs_dmcore_xfs;
 
+#ifdef CONFIG_SYSFS
+extern void xfs_sysfs_init(void);
+extern void xfs_sysfs_done(void);
+extern int xfs_event_alloc(struct xfs_mount *mnt);
+extern int xfs_event_release(struct xfs_mount *mnt);
+#endif
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_MOUNT_H__ */

--Boundary-00=_Yxy9JY+IVsuLkno
Content-Type: text/x-diff;
  charset="us-ascii";
  name="xfs-sysfs-1-262719.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs-sysfs-1-262719.diff"

diff --git a/xfs/Makefile b/xfs/Makefile
index ba17121..904372b 100644
--- a/xfs/Makefile
+++ b/xfs/Makefile
@@ -91,7 +91,8 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_vnodeops.o \
 				   xfs_rw.o \
 				   xfs_dmops.o \
-				   xfs_qmops.o
+				   xfs_qmops.o \
+				   xfs_sysfs.o
 
 xfs-$(CONFIG_XFS_TRACE)		+= xfs_dir2_trace.o
 
diff --git a/xfs/linux-2.6/xfs_super.c b/xfs/linux-2.6/xfs_super.c
index 9eaddb4..57f2558 100644
--- a/xfs/linux-2.6/xfs_super.c
+++ b/xfs/linux-2.6/xfs_super.c
@@ -1152,6 +1152,9 @@ xfs_fs_put_super(
 	xfs_close_devices(mp);
 	xfs_qmops_put(mp);
 	xfs_dmops_put(mp);
+#ifdef CONFIG_SYSFS
+	xfs_event_release(mp);
+#endif
 	xfs_free_fsname(mp);
 	kfree(mp);
 }
@@ -1783,6 +1786,9 @@ xfs_fs_fill_super(
 	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
 
 	kfree(args);
+#ifdef CONFIG_SYSFS
+	xfs_event_alloc(mp);
+#endif
 	return 0;
 
  out_filestream_unmount:
@@ -2151,6 +2157,10 @@ init_xfs_fs(void)
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
 		goto out_sysctl_unregister;
+
+#ifdef CONFIG_SYSFS
+	xfs_sysfs_init();
+#endif	
 	return 0;
 
  out_sysctl_unregister:
@@ -2184,6 +2194,9 @@ exit_xfs_fs(void)
 	xfs_free_trace_bufs();
 	xfs_destroy_zones();
 	ktrace_uninit();
+#ifdef CONFIG_SYSFS
+	xfs_sysfs_done();
+#endif	
 }
 
 module_init(init_xfs_fs);
diff --git a/xfs/xfs_mount.c b/xfs/xfs_mount.c
index a4503f5..2854b00 100644
--- a/xfs/xfs_mount.c
+++ b/xfs/xfs_mount.c
@@ -2441,3 +2441,25 @@ balance_counter:
 }
 
 #endif
+
+
+__uint64_t xfs_icsb_get_fdblocks_lazy(xfs_mount_t *mp)
+{
+        __uint64_t fdblocks = 0;
+#ifdef HAVE_PERCPU_SB
+        xfs_icsb_cnts_t *cntp;
+        int i;
+
+        for_each_online_cpu(i) {
+                cntp = (xfs_icsb_cnts_t *)per_cpu_ptr(mp->m_sb_cnts, i);
+                fdblocks += cntp->icsb_fdblocks;
+        }
+
+        if (xfs_icsb_counter_disabled(mp, XFS_SBS_FDBLOCKS))
+                fdblocks = mp->m_sb.sb_fdblocks;
+#else
+        fdblocks = mp->m_sb.sb_fdblocks;
+#endif
+        return fdblocks - XFS_ALLOC_SET_ASIDE(mp);
+}
+
diff --git a/xfs/xfs_mount.h b/xfs/xfs_mount.h
index b6b8be8..a7c17fe 100644
--- a/xfs/xfs_mount.h
+++ b/xfs/xfs_mount.h
@@ -342,6 +342,9 @@ typedef struct xfs_mount {
 	int			m_sync_seq;	/* sync thread generation no. */
 	wait_queue_head_t	m_wait_single_sync_task;
 	struct vfsmount         *m_vfsmount;
+#ifdef CONFIG_SYSFS
+	void *event_onlow;
+#endif
 } xfs_mount_t;
 
 /*
@@ -540,6 +543,13 @@ extern void	xfs_qmops_put(struct xfs_mount *);
 
 extern struct xfs_dmops xfs_dmcore_xfs;
 
+#ifdef CONFIG_SYSFS
+extern void xfs_sysfs_init(void);
+extern void xfs_sysfs_done(void);
+extern int xfs_event_alloc(struct xfs_mount *mnt);
+extern int xfs_event_release(struct xfs_mount *mnt);
+#endif
+
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_MOUNT_H__ */

--Boundary-00=_Yxy9JY+IVsuLkno
Content-Type: text/x-diff;
  charset="us-ascii";
  name="xfs-sysfs-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="xfs-sysfs-2.diff"

diff --git a/xfs/xfs_sysfs.c b/xfs/xfs_sysfs.c
new file mode 100644
index 0000000..cbb0ed2
--- /dev/null
+++ b/xfs/xfs_sysfs.c
@@ -0,0 +1,339 @@
+/*
+ * A sysfs interface for triggering events like "Nearly Out Of Space"
+ * Krzysztof Blaszkowski <kb@sysmikro.com.pl> 2009
+ *
+ *
+ * each mounted block device will be associted with a directory under
+ *   /sys/fs/xfs-oos/ where there is a file "trigger" which sets
+ * a free space trigger point and if crossed over then there will be raised
+ * an uevent like this:
+ *   UEVENT[1240929288.150050] change   /fs/xfs-oos/dm-18 (xfs-oos)
+ *   ACTION=change
+ *   DEVPATH=/fs/xfs-oos/dm-18
+ *   SUBSYSTEM=xfs-oos
+ *   XFSDEV=dm-18
+ *   XFSLEFT=191111168
+ *
+ * syntax:
+ * echo "1G" > /sys/fs/xfs-oos/ the_block_device_name /trigger
+ * echo "400M" > /sys/fs/xfs-oos/ some_other_bdev /trigger
+ * echo "20000000" > /sys/fs/xfs-oos/ yet_another_bdev /trigger
+ *
+ * the module polls each mount point every fixed time (5 sec)
+ * and if necessary raises events. it utilizes hysteresis loop of 1/8 
+ * of trigger value to avoid sending excessive events on small change.
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
+
+#ifdef CONFIG_SYSFS
+
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/timer.h>
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_dir2.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+
+
+static struct xfs_event_ctrl {
+	struct kset *kset;
+	struct timer_list poll;
+	int poll_interval;
+	spinlock_t kset_lock;
+	/* because kset is acessed in different contextes then 
+	 kobject locking (kset->lock) is not appropriate this time */
+} xfs_event_ctrl;
+
+
+
+struct xfs_event_s {
+	struct kobject kobj;
+	__uint64_t trigger;
+	__uint64_t left_bytes;
+	struct xfs_mount *mp;
+	int triggered:1;
+	int fire_event:1;
+};
+
+struct xfs_event_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct xfs_event_s *, struct xfs_event_attribute *, char *);
+	ssize_t (*store)(struct xfs_event_s *, struct xfs_event_attribute *, const char *, ssize_t);
+};
+
+
+static ssize_t xfs_event_kobj_attr_show(struct kobject *_kobj,
+			     struct attribute *a,
+			     char *buf)
+{
+	struct xfs_event_attribute *attribute = container_of(a, struct xfs_event_attribute, attr);
+	struct xfs_event_s *event = container_of(_kobj, struct xfs_event_s, kobj);
+
+	if (!attribute->show)
+		return -EIO;
+
+	return attribute->show(event, attribute, buf);
+}
+
+static ssize_t xfs_event_kobj_attr_store(struct kobject *_kobj,
+			      struct attribute *a,
+			      const char *buf, size_t len)
+{
+	struct xfs_event_attribute *attribute = container_of(a, struct xfs_event_attribute, attr);
+	struct xfs_event_s *event = container_of(_kobj, struct xfs_event_s, kobj);
+
+	if (!attribute->store)
+		return -EIO;
+
+	return attribute->store(event, attribute, buf, len);
+}
+
+static void xfs_event_kobj_release(struct kobject *_kobj)
+{
+	struct xfs_event_s *event = container_of(_kobj, struct xfs_event_s, kobj);
+	kfree(event);
+}
+
+
+static const struct sysfs_ops xfs_event_sysfs_ops = {
+	.show = xfs_event_kobj_attr_show,
+	.store = xfs_event_kobj_attr_store,
+};
+
+static const struct attribute *xfs_events_attrs[];
+static const struct kobj_type xfs_event_ktype = {
+	.sysfs_ops = (void *)&xfs_event_sysfs_ops,
+	.release = xfs_event_kobj_release,
+	.default_attrs = (void *)xfs_events_attrs,
+};
+
+
+
+
+
+static ssize_t xfs_trigger_get(struct xfs_event_s *event,
+				struct xfs_event_attribute *obj_attr,
+				char *buf)
+{
+	__uint64_t bs = event->mp->m_sb.sb_blocksize;
+	
+	return sprintf(buf, "%lld %lld %c", event->trigger * bs, event->left_bytes, event->triggered ? '1' : '0');
+}
+
+static ssize_t xfs_trigger_set(struct xfs_event_s *event,
+				struct xfs_event_attribute *obj_attr,
+				const char *buf, ssize_t count)
+{
+	int rc;
+	char unit;
+	
+	spin_lock_bh(&xfs_event_ctrl.kset_lock);
+	rc = sscanf(buf, "%lld%c", &event->trigger, &unit);
+	if (rc == 2) {
+		switch(unit) {
+			case 'T':
+			case 't':
+				event->trigger <<= 10;
+			case 'G':
+			case 'g':
+				event->trigger <<= 10;
+			case 'M':
+			case 'm':
+				event->trigger <<= 20;
+		}
+	}
+	event->trigger /= event->mp->m_sb.sb_blocksize;
+	spin_unlock_bh(&xfs_event_ctrl.kset_lock);
+	return count;
+}
+
+
+static const struct xfs_event_attribute xfs_event_trigger = 
+	__ATTR(trigger, S_IFREG | S_IRUGO | S_IWUSR,
+	xfs_trigger_get,
+	xfs_trigger_set);
+
+static const struct attribute *xfs_events_attrs[] = {
+	&xfs_event_trigger.attr,
+	NULL
+}; 
+
+
+extern __uint64_t xfs_icsb_get_fdblocks_lazy(xfs_mount_t *mp);
+
+static void xfs_event_fdblocks_poll(unsigned long arg)
+{
+	struct xfs_event_ctrl *ctrl = (struct xfs_event_ctrl *)arg;
+	struct kset *kset = ctrl->kset;
+	struct kobject *k, *tmp;
+	
+	struct list_head events_to_fire;
+	
+	INIT_LIST_HEAD(&events_to_fire);
+	mod_timer(&ctrl->poll, jiffies + ctrl->poll_interval);
+	spin_lock_bh(&ctrl->kset_lock);
+	/* no need to use kset->lock */
+	list_for_each_entry_safe(k, tmp, &kset->list, entry) {
+		struct xfs_event_s *event = container_of(k, struct xfs_event_s, kobj);
+		__uint64_t space_left = xfs_icsb_get_fdblocks_lazy(event->mp);
+
+		if (space_left < event->trigger && !event->triggered) {
+			event->triggered = 1;
+			kobject_get(&event->kobj);
+			event->left_bytes = space_left * event->mp->m_sb.sb_blocksize;
+			list_del(&event->kobj.entry);
+			list_add(&event->kobj.entry, &events_to_fire);
+		}
+
+		if (space_left > (event->trigger + (event->trigger >> 3)) 
+			&& event->triggered) {
+			event->triggered = 0;
+		}
+	
+	}
+	spin_unlock_bh(&ctrl->kset_lock);
+	
+	if (!list_empty(&events_to_fire)) {
+		char buffer[256];
+		char *envp[3];
+	
+		envp[0] = buffer;
+		envp[2] = NULL;
+		list_for_each_entry(k, &events_to_fire, entry) {
+			struct xfs_event_s *event = container_of(k, struct xfs_event_s, kobj);
+			
+			envp[1] = envp[0] + snprintf(envp[0], 250, "XFSDEV=%s", k->name) + 1;
+			snprintf(envp[1], 250 - (envp[1] - envp[0]), "XFSLEFT=%lld", event->left_bytes);
+
+//			printk("%s:%d firing [%s] [%s] [%s]\n", __FUNCTION__, __LINE__, k->name, envp[0], envp[1]);
+			kobject_uevent_env(k, KOBJ_CHANGE, envp);
+		}
+
+		spin_lock_bh(&ctrl->kset_lock);
+		list_for_each_entry_safe(k, tmp, &events_to_fire, entry) {
+			struct xfs_event_s *event = container_of(k, struct xfs_event_s, kobj);
+
+			list_del(&event->kobj.entry);
+			list_add(&event->kobj.entry, &kset->list);
+			kobject_put(&event->kobj);
+		}
+		spin_unlock_bh(&ctrl->kset_lock);
+	}
+}
+
+
+/* api */
+
+void xfs_sysfs_init(void)
+{
+	memset(&xfs_event_ctrl, 0, sizeof(struct xfs_event_ctrl));
+
+	xfs_event_ctrl.poll_interval = HZ * 5;
+	xfs_event_ctrl.kset = kset_create_and_add("xfs-oos", NULL, fs_kobj);
+	spin_lock_init(&xfs_event_ctrl.kset_lock);
+	if (!xfs_event_ctrl.kset) {
+		cmn_err(CE_ALERT, "kset_create failed");
+		return;
+	}
+}
+
+void xfs_sysfs_done(void)
+{
+	if (xfs_event_ctrl.kset) {
+		BUG_ON(!list_empty(&xfs_event_ctrl.kset->list));
+		kset_unregister(xfs_event_ctrl.kset);
+		xfs_event_ctrl.kset = NULL;
+	}
+}
+
+/* stuff for xfs_fs_fill_super, xfs_fs_put_super */
+
+int xfs_event_alloc(struct xfs_mount *mnt)
+{
+	struct xfs_event_s * ev;
+	int rc = -1;
+	int empty;
+	
+	if (!xfs_event_ctrl.kset)
+		return rc;
+
+	ev = kzalloc(sizeof(struct xfs_event_s), GFP_KERNEL);
+
+	spin_lock_bh(&xfs_event_ctrl.kset_lock);
+	empty = list_empty(&xfs_event_ctrl.kset->list);
+	
+	if (ev) {
+		ev->kobj.kset = xfs_event_ctrl.kset;
+		ev->mp = mnt;
+		
+		rc = kobject_init_and_add(&ev->kobj, (void *)&xfs_event_ktype, NULL, "%s", mnt->m_fsname);
+		if (!rc) {
+			mnt->event_onlow = ev;
+			kobject_uevent(&ev->kobj, KOBJ_ADD);
+		} else {
+			kobject_put(&ev->kobj); // ev will be freed too.
+		}
+	}
+	spin_unlock_bh(&xfs_event_ctrl.kset_lock);
+	
+	if (empty) {
+		init_timer(&xfs_event_ctrl.poll);
+		xfs_event_ctrl.poll.function = xfs_event_fdblocks_poll;
+		xfs_event_ctrl.poll.data = (unsigned long)&xfs_event_ctrl;
+		xfs_event_ctrl.poll.expires = jiffies + xfs_event_ctrl.poll_interval;
+		add_timer(&xfs_event_ctrl.poll);
+	}
+
+	return rc;
+}
+
+int xfs_event_release(struct xfs_mount *mnt)
+{
+	struct xfs_event_s * ev = (struct xfs_event_s *)mnt->event_onlow;
+	int empty;
+
+	if (!xfs_event_ctrl.kset)
+		return -1;
+
+	spin_lock_bh(&xfs_event_ctrl.kset_lock);
+	if (ev)
+		kobject_put(&ev->kobj);
+
+	empty = list_empty(&xfs_event_ctrl.kset->list);
+	spin_unlock_bh(&xfs_event_ctrl.kset_lock);
+
+	if (empty) {
+		del_timer_sync(&xfs_event_ctrl.poll);
+	}
+	
+	return 0;
+}
+
+#endif
+

--Boundary-00=_Yxy9JY+IVsuLkno
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--Boundary-00=_Yxy9JY+IVsuLkno--
