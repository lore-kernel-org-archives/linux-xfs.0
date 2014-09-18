Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EF6417F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 15:18:43 -0500 (CDT)
Date: Thu, 18 Sep 2014 15:18:43 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 10/10] xfs: implement demand load of utf8norm.ko
Message-ID: <20140918201843.GM4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918195650.GI19952@sgi.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

From: Ben Myers <bpm@sgi.com>

The utf8 normalization module is large and there is no need to have it
loaded unless an xfs filesystem with utf8 enabled has been mounted.
This loads utf8norm.ko at mount time for filesystems that need
it.  This is optional on CONFIG_XFS_UTF8_DEMAND_LOAD.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/Kconfig           |  10 +++++
 fs/xfs/libxfs/xfs_dir2.c |   9 ++++
 fs/xfs/libxfs/xfs_utf8.c | 104 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_utf8.h |   5 +++
 fs/xfs/xfs_super.c       |   6 +++
 5 files changed, 134 insertions(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index a847857..69efd85c 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -103,3 +103,13 @@ config XFS_UTF8
 	  Say Y here to enable utf8 normalization support in XFS.  You
 	  will be able to mount and use filesystems created with the
 	  utf8 mkfs.xfs option.
+
+config XFS_UTF8_DEMAND_LOAD
+	bool "XFS loads UTF-8 normalization module on demand"
+	depends on XFS_FS
+	depends on XFS_UTF8
+	help
+	  Say Y here to enable on demand loading of the utf8
+	  normalization module.  This enables the large nomalization
+	  module to remain unloaded until a filesystem with utf8 support
+	  is mounted.
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index e28736b..436738d 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -35,7 +35,9 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_dinode.h"
+#ifdef CONFIG_XFS_UTF8
 #include "xfs_utf8.h"
+#endif
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
@@ -159,6 +161,13 @@ xfs_da_mount(
 
 	if (xfs_sb_version_hasutf8(&mp->m_sb)) {
 #ifdef CONFIG_XFS_UTF8
+#ifdef CONFIG_XFS_UTF8_DEMAND_LOAD
+		if (xfs_init_utf8_module(mp)) {
+			kmem_free(mp->m_dir_geo);
+			kmem_free(mp->m_attr_geo);
+			return -ENOSYS;
+		}
+#endif /* CONFIG_XFS_UTF8_DEMAND_LOAD */
 		if (xfs_sb_version_hasasciici(&mp->m_sb))
 			mp->m_dirnameops = &xfs_utf8_ci_nameops;
 		else
diff --git a/fs/xfs/libxfs/xfs_utf8.c b/fs/xfs/libxfs/xfs_utf8.c
index 75f2b3a..71978c8 100644
--- a/fs/xfs/libxfs/xfs_utf8.c
+++ b/fs/xfs/libxfs/xfs_utf8.c
@@ -44,6 +44,110 @@
 #include "xfs_utf8.h"
 #include <utf8norm/utf8norm.h>
 
+#ifdef CONFIG_XFS_UTF8_DEMAND_LOAD
+#include <linux/kmod.h>
+
+static DEFINE_SPINLOCK(utf8norm_lock);
+static int utf8norm_initialized;
+
+static const unsigned int (*utf8version_func)(void);
+static utf8data_t (*utf8nfkdi_func)(unsigned int);
+static utf8data_t (*utf8nfkdicf_func)(unsigned int);
+static ssize_t (*utf8nlen_func)(utf8data_t, const char *, size_t);
+static int (*utf8ncursor_func)(struct utf8cursor *, utf8data_t,
+		const char *, size_t);
+static int (*utf8byte_func)(struct utf8cursor *);
+
+static void
+xfs_put_utf8_module_locked(void)
+{
+	if (utf8version_func)
+		symbol_put(utf8version);
+
+	if (utf8nfkdi_func)
+		symbol_put(utf8nfkdi);
+
+	if (utf8nfkdicf_func)
+		symbol_put(utf8nfkdicf);
+
+	if (utf8nlen_func)
+		symbol_put(utf8nlen);
+
+	if (utf8ncursor_func)
+		symbol_put(utf8ncursor);
+
+	if (utf8byte_func)
+		symbol_put(utf8byte);
+}
+
+void
+xfs_put_utf8_module(void)
+{
+	spin_lock(&utf8norm_lock);
+	if (!utf8norm_initialized) {
+		spin_unlock(&utf8norm_lock);
+		return;
+	}
+	xfs_put_utf8_module_locked();
+	spin_unlock(&utf8norm_lock);
+}
+
+int
+xfs_init_utf8_module(struct xfs_mount	*mp)
+{
+	request_module("utf8norm");
+
+	spin_lock(&utf8norm_lock);
+	if (utf8norm_initialized) {
+		spin_unlock(&utf8norm_lock);
+		return 0;
+	}
+
+	utf8version_func = symbol_get(utf8version);
+	if (!utf8version_func)
+		goto error;
+
+	utf8nfkdi_func = symbol_get(utf8nfkdi);
+	if (!utf8nfkdi_func)
+		goto error;
+
+	utf8nfkdicf_func = symbol_get(utf8nfkdicf);
+	if (!utf8nfkdicf_func)
+		goto error;
+
+	utf8nlen_func = symbol_get(utf8nlen);
+	if (!utf8nlen_func) 
+		goto error;
+
+	utf8ncursor_func = symbol_get(utf8ncursor);
+	if (!utf8ncursor_func)
+		goto error;
+
+	utf8byte_func = symbol_get(utf8byte);
+	if (!utf8byte_func)
+		goto error;
+
+	utf8norm_initialized = 1;	
+	spin_unlock(&utf8norm_lock);
+	return 0;
+error:
+	xfs_put_utf8_module_locked();
+	spin_unlock(&utf8norm_lock);
+	xfs_warn(mp,
+		"Failed to load utf8norm.ko which is required to "
+		"mount a filesystem with utf8 support.");
+	return -ENOSYS;
+}
+
+#define utf8version (*utf8version_func)
+#define utf8nfkdi (*utf8nfkdi_func)
+#define utf8nfkdicf (*utf8nfkdicf_func)
+#define utf8nlen (*utf8nlen_func)
+#define utf8ncursor (*utf8ncursor_func)
+#define utf8byte (*utf8byte_func)
+
+#endif /* CONFIG_XFS_UTF8_DEMAND_LOAD */
+
 /*
  * xfs nameops using nfkdi
  */
diff --git a/fs/xfs/libxfs/xfs_utf8.h b/fs/xfs/libxfs/xfs_utf8.h
index 97b6a91..9d1125a 100644
--- a/fs/xfs/libxfs/xfs_utf8.h
+++ b/fs/xfs/libxfs/xfs_utf8.h
@@ -22,4 +22,9 @@
 extern struct xfs_nameops xfs_utf8_nameops;
 extern struct xfs_nameops xfs_utf8_ci_nameops;
 
+#ifdef CONFIG_XFS_UTF8_DEMAND_LOAD
+extern int xfs_init_utf8_module(struct xfs_mount *);
+extern void xfs_put_utf8_module(void);
+#endif
+
 #endif /* XFS_UTF8_H */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b194652..050a949 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -47,6 +47,9 @@
 #include "xfs_dinode.h"
 #include "xfs_filestream.h"
 #include "xfs_quota.h"
+#ifdef CONFIG_XFS_UTF8_DEMAND_LOAD
+#include "xfs_utf8.h"
+#endif
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1809,6 +1812,9 @@ exit_xfs_fs(void)
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
 	xfs_destroy_zones();
+#ifdef CONFIG_XFS_UTF8_DEMAND_LOAD
+	xfs_put_utf8_module();
+#endif
 }
 
 module_init(init_xfs_fs);
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
