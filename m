Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D04AD7FBA
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 16:48:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6DA57AC007
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 14:48:19 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10]) by
	cuda.sgi.com with ESMTP id T4fUMHxoqibD23Lc (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 14:48:13 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] xfs: fix build without xfsstats
Date: Fri, 16 Oct 2015 23:47:37 +0200
Message-ID: <5578984.gxbqPUmtuT@wuerfel>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@redhat.com>, Bill O'Donnell <billodo@redhat.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org

A recent rework of the xfsstats interface introduced a compile error
for the procfs-disabled case:

fs/built-in.o: In function `xfs_free_ag_extent':
fs/xfs/libxfs/xfs_alloc.c:1725: undefined reference to `xfsstats'
fs/built-in.o: In function `xfs_alloc_ag_vextent':
fs/xfs/libxfs/xfs_alloc.c:645: undefined reference to `xfsstats'
fs/built-in.o: In function `xfs_attr_set':
fs/xfs/libxfs/xfs_attr.c:353: undefined reference to `xfsstats'
fs/built-in.o: In function `xfs_attr_remove':
fs/xfs/libxfs/xfs_attr.c:483: undefined reference to `xfsstats'
fs/built-in.o: In function `xfs_attr_get':
fs/xfs/libxfs/xfs_attr.c:131: undefined reference to `xfsstats'
fs/built-in.o:fs/xfs/libxfs/xfs_bmap.c:1461: more undefined references to `xfsstats' follow

This adds conditional compilation to each reference of the xfsstats
global variable to get it to link again.

An alternative approach would be to always build the statistics
implementation even when CONFIG_PROC_FS is disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 80529c45ab66 ("xfs: pass xfsstats structures to handlers and macros")
Fixes: ff6d6af2351c ("xfs: per-filesystem stats counter implementation")

---
Found with ARM randconfig builds. You seem to have intentionally
removed the XFS_STATS_INC etc macros and #ifdefs in ff6d6af2351c,
so I suspect this is not what you had in mind then, but it's not
clear what you want instead. Please regard this as a bug report
if it looks wrong to you ;-)

	Arnd

diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 483b0eff1988..f87ad9d12f4a 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -213,9 +213,12 @@ struct xfsstats {
 	__uint64_t		xs_read_bytes;
 };
 
+extern struct xstats xfsstats;
+
+#ifdef CONFIG_PROC_FS
+
 int xfs_stats_format(struct xfsstats __percpu *stats, char *buf);
 void xfs_stats_clearall(struct xfsstats __percpu *stats);
-extern struct xstats xfsstats;
 
 #define XFS_STATS_INC(mp, v)					\
 do {								\
@@ -235,14 +238,23 @@ do {									\
 	per_cpu_ptr(mp->m_stats.xs_stats, current_cpu())->v += (inc);	\
 } while (0)
 
-#if defined(CONFIG_PROC_FS)
-
 extern int xfs_init_procfs(void);
 extern void xfs_cleanup_procfs(void);
 
-
 #else	/* !CONFIG_PROC_FS */
 
+static inline int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
+{
+	return 0;
+}
+static inline void xfs_stats_clearall(struct xfsstats __percpu *stats)
+{
+}
+
+#define XFS_STATS_INC(mp, v)		do { } while (0)
+#define XFS_STATS_DEC(mp, v)		do { } while (0)
+#define XFS_STATS_ADD(mp, v, inc)	do { } while (0)
+
 static inline int xfs_init_procfs(void)
 {
 	return 0;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 368c55adee9d..58a372898857 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1475,10 +1475,12 @@ xfs_fs_fill_super(
 		goto out_destroy_workqueues;
 
 	/* Allocate stats memory before we do operations that might use it */
-	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
-	if (!mp->m_stats.xs_stats) {
-		error = PTR_ERR(mp->m_stats.xs_stats);
-		goto out_destroy_counters;
+	if (IS_ENABLED(CONFIG_PROC_FS)) {
+		mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
+		if (!mp->m_stats.xs_stats) {
+			error = PTR_ERR(mp->m_stats.xs_stats);
+			goto out_destroy_counters;
+		}
 	}
 
 	error = xfs_readsb(mp, flags);
@@ -1851,16 +1853,18 @@ init_xfs_fs(void)
 		goto out_sysctl_unregister;
 	}
 
-	xfsstats.xs_kobj.kobject.kset = xfs_kset;
+	if (IS_ENABLED(CONFIG_PROC_FS)) {
+		xfsstats.xs_kobj.kobject.kset = xfs_kset;
 
-	xfsstats.xs_stats = alloc_percpu(struct xfsstats);
-	if (!xfsstats.xs_stats) {
-		error = -ENOMEM;
-		goto out_kset_unregister;
+		xfsstats.xs_stats = alloc_percpu(struct xfsstats);
+		if (!xfsstats.xs_stats) {
+			error = -ENOMEM;
+			goto out_kset_unregister;
+		}
+		error = xfs_sysfs_init(&xfsstats.xs_kobj, &xfs_stats_ktype,
+				       NULL, "stats");
 	}
 
-	error = xfs_sysfs_init(&xfsstats.xs_kobj, &xfs_stats_ktype, NULL,
-			       "stats");
 	if (error)
 		goto out_free_stats;
 
@@ -1887,9 +1891,11 @@ init_xfs_fs(void)
 	xfs_sysfs_del(&xfs_dbg_kobj);
  out_remove_stats_kobj:
 #endif
-	xfs_sysfs_del(&xfsstats.xs_kobj);
+	if (IS_ENABLED(CONFIG_PROC_FS))
+		xfs_sysfs_del(&xfsstats.xs_kobj);
  out_free_stats:
-	free_percpu(xfsstats.xs_stats);
+	if (IS_ENABLED(CONFIG_PROC_FS))
+		free_percpu(xfsstats.xs_stats);
  out_kset_unregister:
 	kset_unregister(xfs_kset);
  out_sysctl_unregister:
@@ -1916,8 +1922,10 @@ exit_xfs_fs(void)
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
 #endif
-	xfs_sysfs_del(&xfsstats.xs_kobj);
-	free_percpu(xfsstats.xs_stats);
+	if (IS_ENABLED(CONFIG_PROC_FS)) {
+		xfs_sysfs_del(&xfsstats.xs_kobj);
+		free_percpu(xfsstats.xs_stats);
+	}
 	kset_unregister(xfs_kset);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
