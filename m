Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 21E777F37
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:03:58 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:03:57 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 13/16] xfs: implement demand load of utf8norm.ko
Message-ID: <20141003220357.GM1865@sgi.com>
References: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141003214758.GY1865@sgi.com>
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
Cc: olaf@sgi.com, xfs@oss.sgi.com

From: Ben Myers <bpm@sgi.com>

The utf8 normalization module is large and there is no need to have it
loaded unless an xfs filesystem with utf8 enabled has been mounted.
This loads utf8norm.ko at mount time for filesystems that need
it.

Signed-off-by: Ben Myers <bpm@sgi.com>

---
[v2: updated for utf8version_is_supported. --bpm]
[v3: removed CONFIG_XFS_UTF8_DEMAND_LOAD. --bpm]
---
 fs/xfs/libxfs/xfs_dir2.c |   9 +++++
 fs/xfs/libxfs/xfs_utf8.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_utf8.h |   3 ++
 fs/xfs/xfs_super.c       |   6 +++
 4 files changed, 118 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 9cfbd6b..844044b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -35,6 +35,9 @@
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_dinode.h"
+#ifdef CONFIG_XFS_UTF8
+#include "xfs_utf8.h"
+#endif
 
 struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
 
@@ -159,6 +162,12 @@ xfs_da_mount(
 
 	if (xfs_sb_version_hasutf8(&mp->m_sb)) {
 #ifdef CONFIG_XFS_UTF8
+		if (xfs_init_utf8_module(mp)) {
+			kmem_free(mp->m_dir_geo);
+			kmem_free(mp->m_attr_geo);
+			return -ENOSYS;
+		}
+
 		if (!xfs_utf8_version_ok(mp))
 			return -ENOSYS;
 
diff --git a/fs/xfs/libxfs/xfs_utf8.c b/fs/xfs/libxfs/xfs_utf8.c
index ede6228..09efcda 100644
--- a/fs/xfs/libxfs/xfs_utf8.c
+++ b/fs/xfs/libxfs/xfs_utf8.c
@@ -43,6 +43,106 @@
 #include "xfs_trace.h"
 #include "xfs_utf8.h"
 #include <linux/utf8norm.h>
+#include <linux/kmod.h>
+
+static DEFINE_SPINLOCK(utf8norm_lock);
+static int utf8norm_initialized;
+
+static int (*utf8version_is_supported_func)(unsigned int);
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
+	if (utf8version_is_supported_func)
+		symbol_put(utf8version_is_supported);
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
+	utf8version_is_supported_func = symbol_get(utf8version_is_supported);
+	if (!utf8version_is_supported_func)
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
+#define utf8version_is_supported (*utf8version_is_supported_func)
+#define utf8nfkdi (*utf8nfkdi_func)
+#define utf8nfkdicf (*utf8nfkdicf_func)
+#define utf8nlen (*utf8nlen_func)
+#define utf8ncursor (*utf8ncursor_func)
+#define utf8byte (*utf8byte_func)
 
 int
 xfs_utf8_version_ok(
diff --git a/fs/xfs/libxfs/xfs_utf8.h b/fs/xfs/libxfs/xfs_utf8.h
index 404db54..b79ce05 100644
--- a/fs/xfs/libxfs/xfs_utf8.h
+++ b/fs/xfs/libxfs/xfs_utf8.h
@@ -24,4 +24,7 @@ extern int xfs_utf8_version_ok(struct xfs_mount *);
 extern struct xfs_nameops xfs_utf8_nameops;
 extern struct xfs_nameops xfs_utf8_ci_nameops;
 
+extern int xfs_init_utf8_module(struct xfs_mount *);
+extern void xfs_put_utf8_module(void);
+
 #endif /* XFS_UTF8_H */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b194652..60a3ebc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -47,6 +47,9 @@
 #include "xfs_dinode.h"
 #include "xfs_filestream.h"
 #include "xfs_quota.h"
+#ifdef CONFIG_XFS_UTF8
+#include "xfs_utf8.h"
+#endif
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -1809,6 +1812,9 @@ exit_xfs_fs(void)
 	xfs_mru_cache_uninit();
 	xfs_destroy_workqueues();
 	xfs_destroy_zones();
+#ifdef CONFIG_XFS_UTF8
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
