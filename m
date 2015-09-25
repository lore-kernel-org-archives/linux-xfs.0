Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC23E7F37
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 18:23:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 59120AC00B
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 16:23:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id w1B2RI1XCCCUFRcQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Sep 2015 16:23:14 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 864FFC0B1B33
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 23:23:13 +0000 (UTC)
Received: from localhost.localdomain.com (vpn-55-243.rdu2.redhat.com
	[10.10.55.243])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8PNNBp1021662
	for <xfs@oss.sgi.com>; Fri, 25 Sep 2015 19:23:12 -0400
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH 1/7] xfs: create global stats and stats_clear in sysfs
Date: Fri, 25 Sep 2015 18:22:54 -0500
Message-Id: <1443223380-18870-2-git-send-email-billodo@redhat.com>
In-Reply-To: <1443223380-18870-1-git-send-email-billodo@redhat.com>
References: <1443223380-18870-1-git-send-email-billodo@redhat.com>
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

Currently, xfs global stats are in procfs. This patch introduces
(replicates) the global stats in sysfs. Additionally a stats_clear file
is introduced in sysfs.

Signed-off-by: Bill O'Donnell <billodo@redhat.com>
---
 fs/xfs/xfs_stats.c  | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_stats.h  |  2 ++
 fs/xfs/xfs_super.c  | 20 +++++++++----
 fs/xfs/xfs_sysctl.c | 15 ++--------
 fs/xfs/xfs_sysfs.c  | 75 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.h  |  1 +
 6 files changed, 179 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index f224038..6008e25 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -29,6 +29,89 @@ static int counter_val(int idx)
 	return val;
 }
 
+int xfs_stats_format(char *buf)
+{
+	int		i, j;
+	int		len = 0;
+	__uint64_t	xs_xstrat_bytes = 0;
+	__uint64_t	xs_write_bytes = 0;
+	__uint64_t	xs_read_bytes = 0;
+
+	static const struct xstats_entry {
+		char	*desc;
+		int	endpoint;
+	} xstats[] = {
+		{ "extent_alloc",	XFSSTAT_END_EXTENT_ALLOC	},
+		{ "abt",		XFSSTAT_END_ALLOC_BTREE		},
+		{ "blk_map",		XFSSTAT_END_BLOCK_MAPPING	},
+		{ "bmbt",		XFSSTAT_END_BLOCK_MAP_BTREE	},
+		{ "dir",		XFSSTAT_END_DIRECTORY_OPS	},
+		{ "trans",		XFSSTAT_END_TRANSACTIONS	},
+		{ "ig",			XFSSTAT_END_INODE_OPS		},
+		{ "log",		XFSSTAT_END_LOG_OPS		},
+		{ "push_ail",		XFSSTAT_END_TAIL_PUSHING	},
+		{ "xstrat",		XFSSTAT_END_WRITE_CONVERT	},
+		{ "rw",			XFSSTAT_END_READ_WRITE_OPS	},
+		{ "attr",		XFSSTAT_END_ATTRIBUTE_OPS	},
+		{ "icluster",		XFSSTAT_END_INODE_CLUSTER	},
+		{ "vnodes",		XFSSTAT_END_VNODE_OPS		},
+		{ "buf",		XFSSTAT_END_BUF			},
+		{ "abtb2",		XFSSTAT_END_ABTB_V2		},
+		{ "abtc2",		XFSSTAT_END_ABTC_V2		},
+		{ "bmbt2",		XFSSTAT_END_BMBT_V2		},
+		{ "ibt2",		XFSSTAT_END_IBT_V2		},
+		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
+		/* we print both series of quota information together */
+		{ "qm",			XFSSTAT_END_QM			},
+	};
+
+	/* Loop over all stats groups */
+
+	for (i = j = 0; i < ARRAY_SIZE(xstats); i++) {
+		len += snprintf(buf + len, PATH_MAX - len, "%s",
+				xstats[i].desc);
+		/* inner loop does each group */
+		for (; j < xstats[i].endpoint; j++)
+			len += snprintf(buf + len, PATH_MAX - len, " %u",
+					counter_val(j));
+		len += snprintf(buf + len, PATH_MAX - len, "\n");
+	}
+	/* extra precision counters */
+	for_each_possible_cpu(i) {
+		xs_xstrat_bytes += per_cpu(xfsstats, i).xs_xstrat_bytes;
+		xs_write_bytes += per_cpu(xfsstats, i).xs_write_bytes;
+		xs_read_bytes += per_cpu(xfsstats, i).xs_read_bytes;
+	}
+
+	len += snprintf(buf+len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
+			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
+	len += snprintf(buf+len, PATH_MAX-len, "debug %u\n",
+#if defined(DEBUG)
+		1);
+#else
+		0);
+#endif
+
+return len;
+}
+
+void xfs_stats_clearall(void)
+{
+	int		c;
+	__uint32_t	vn_active;
+
+	xfs_notice(NULL, "Clearing xfsstats");
+	for_each_possible_cpu(c) {
+		preempt_disable();
+		/* save vn_active, it's a universal truth! */
+		vn_active = per_cpu(xfsstats, c).vn_active;
+		memset(&per_cpu(xfsstats, c), 0,
+		       sizeof(struct xfsstats));
+		per_cpu(xfsstats, c).vn_active = vn_active;
+		preempt_enable();
+	}
+}
+
 static int xfs_stat_proc_show(struct seq_file *m, void *v)
 {
 	int		i, j;
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index c8f238b..18807b5 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -18,6 +18,8 @@
 #ifndef __XFS_STATS_H__
 #define __XFS_STATS_H__
 
+int xfs_stats_format(char *buf);
+void xfs_stats_clearall(void);
 
 #if defined(CONFIG_PROC_FS) && !defined(XFS_STATS_OFF)
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 904f637..0dfc53b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -61,6 +61,7 @@ static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
 
 static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
+static struct xfs_kobj xfs_stats_kobj;	/* global stats sysfs attrs */
 #ifdef DEBUG
 static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #endif
@@ -1838,19 +1839,25 @@ init_xfs_fs(void)
 	xfs_kset = kset_create_and_add("xfs", NULL, fs_kobj);
 	if (!xfs_kset) {
 		error = -ENOMEM;
-		goto out_sysctl_unregister;;
+		goto out_sysctl_unregister;
 	}
 
+	xfs_stats_kobj.kobject.kset = xfs_kset;
+	error = xfs_sysfs_init(&xfs_stats_kobj, &xfs_stats_ktype, NULL,
+			       "stats");
+	if (error)
+		goto out_kset_unregister;
+
 #ifdef DEBUG
 	xfs_dbg_kobj.kobject.kset = xfs_kset;
 	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
 	if (error)
-		goto out_kset_unregister;
+		goto out_remove_stats_kobj;
 #endif
 
 	error = xfs_qm_init();
 	if (error)
-		goto out_remove_kobj;
+		goto out_remove_dbg_kobj;
 
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
@@ -1859,11 +1866,13 @@ init_xfs_fs(void)
 
  out_qm_exit:
 	xfs_qm_exit();
- out_remove_kobj:
+ out_remove_dbg_kobj:
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
- out_kset_unregister:
+ out_remove_stats_kobj:
 #endif
+	xfs_sysfs_del(&xfs_stats_kobj);
+ out_kset_unregister:
 	kset_unregister(xfs_kset);
  out_sysctl_unregister:
 	xfs_sysctl_unregister();
@@ -1889,6 +1898,7 @@ exit_xfs_fs(void)
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
 #endif
+	xfs_sysfs_del(&xfs_stats_kobj);
 	kset_unregister(xfs_kset);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index a0c8067..5defabb 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -19,6 +19,7 @@
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
 #include "xfs_error.h"
+#include "xfs_stats.h"
 
 static struct ctl_table_header *xfs_table_header;
 
@@ -31,22 +32,12 @@ xfs_stats_clear_proc_handler(
 	size_t			*lenp,
 	loff_t			*ppos)
 {
-	int		c, ret, *valp = ctl->data;
-	__uint32_t	vn_active;
+	int		ret, *valp = ctl->data;
 
 	ret = proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
 
 	if (!ret && write && *valp) {
-		xfs_notice(NULL, "Clearing xfsstats");
-		for_each_possible_cpu(c) {
-			preempt_disable();
-			/* save vn_active, it's a universal truth! */
-			vn_active = per_cpu(xfsstats, c).vn_active;
-			memset(&per_cpu(xfsstats, c), 0,
-			       sizeof(struct xfsstats));
-			per_cpu(xfsstats, c).vn_active = vn_active;
-			preempt_enable();
-		}
+		xfs_stats_clearall();
 		xfs_stats_clear = 0;
 	}
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index aa03670..a094e20 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -21,6 +21,7 @@
 #include "xfs_log_format.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
+#include "xfs_stats.h"
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
@@ -38,6 +39,8 @@ to_attr(struct attribute *attr)
 	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_RW(name)
 #define XFS_SYSFS_ATTR_RO(name) \
 	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_RO(name)
+#define XFS_SYSFS_ATTR_WO(name) \
+	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_WO(name)
 
 #define ATTR_LIST(name) &xfs_sysfs_attr_##name.attr
 
@@ -125,6 +128,78 @@ struct kobj_type xfs_dbg_ktype = {
 
 #endif /* DEBUG */
 
+
+/* stats */
+
+STATIC ssize_t
+stats_show(
+	char	*buf,
+	void	*data)
+{
+	return xfs_stats_format(buf);
+}
+XFS_SYSFS_ATTR_RO(stats);
+
+STATIC ssize_t
+stats_clear_store(
+	const char	*buf,
+	size_t		count,
+	void		*data)
+{
+	int		ret;
+	int		val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val != 1)
+		return -EINVAL;
+	xfs_stats_clearall();
+	return count;
+}
+XFS_SYSFS_ATTR_WO(stats_clear);
+
+static struct attribute *xfs_stats_attrs[] = {
+	ATTR_LIST(stats),
+	ATTR_LIST(stats_clear),
+	NULL,
+};
+
+STATIC ssize_t
+xfs_stats_show(
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
+xfs_stats_store(
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
+static struct sysfs_ops xfs_stats_ops = {
+	.show = xfs_stats_show,
+	.store = xfs_stats_store,
+};
+
+struct kobj_type xfs_stats_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_stats_ops,
+	.default_attrs = xfs_stats_attrs,
+};
+
 /* xlog */
 
 STATIC ssize_t
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 240eee3..be692e5 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -22,6 +22,7 @@
 extern struct kobj_type xfs_mp_ktype;	/* xfs_mount */
 extern struct kobj_type xfs_dbg_ktype;	/* debug */
 extern struct kobj_type xfs_log_ktype;	/* xlog */
+extern struct kobj_type xfs_stats_ktype;	/* stats */
 
 static inline struct xfs_kobj *
 to_kobj(struct kobject *kobject)
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
