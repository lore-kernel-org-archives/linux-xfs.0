Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48108 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727640AbeJELAN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:13 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 11/15] xfsprogs: include headers for extern variables
Date: Thu,  4 Oct 2018 23:03:12 -0500
Message-Id: <1538712196-13625-12-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Include headers which export functions so that they don't appear to be
static to the sparse checker.

Remove redundant extern declarations in c code which are no longer needed.

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 copy/xfs_copy.c           |  3 +--
 db/crc.c                  |  1 +
 db/fuzz.c                 |  1 +
 db/hash.c                 |  1 +
 db/logformat.c            |  1 +
 db/symlink.c              |  2 +-
 db/text.c                 |  1 +
 include/avl64.h           |  6 ++++++
 include/kmem.h            |  2 ++
 include/libxfs.h          |  2 --
 io/getrusage.c            |  1 +
 io/log_writes.c           |  1 +
 libfrog/crc32.c           |  1 +
 libfrog/linux.c           |  1 +
 libfrog/topology.c        |  1 +
 libxfs/init.c             |  9 ---------
 libxfs/init.h             | 11 +++++++++++
 libxfs/logitem.c          |  1 +
 libxfs/trans.c            |  1 +
 libxfs/util.c             |  1 +
 mdrestore/xfs_mdrestore.c |  3 +--
 repair/phase2.c           |  2 --
 repair/scan.h             |  1 +
 repair/xfs_repair.c       |  1 +
 scrub/xfs_scrub.c         |  1 +
 25 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 3f6535c..862573f 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs.h"
+#include "init.h"
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <pthread.h>
@@ -16,8 +17,6 @@
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (platform_uuid_compare((s),(d)) == 0)
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
-
 static char 		*logfile_name;
 static FILE		*logerr;
 static char		LOGFILE_NAME[] = "/var/tmp/xfs_copy.log.XXXXXX";
diff --git a/db/crc.c b/db/crc.c
index c4136a4..23702cc 100644
--- a/db/crc.c
+++ b/db/crc.c
@@ -17,6 +17,7 @@
 #include "output.h"
 #include "bit.h"
 #include "print.h"
+#include "crc.h"
 
 static int crc_f(int argc, char **argv);
 static void crc_help(void);
diff --git a/db/fuzz.c b/db/fuzz.c
index 5d5d54f..65157bd 100644
--- a/db/fuzz.c
+++ b/db/fuzz.c
@@ -21,6 +21,7 @@
 #include "print.h"
 #include "write.h"
 #include "malloc.h"
+#include "fuzz.h"
 
 static int	fuzz_f(int argc, char **argv);
 static void     fuzz_help(void);
diff --git a/db/hash.c b/db/hash.c
index bda3316..68c53e7 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -10,6 +10,7 @@
 #include "type.h"
 #include "io.h"
 #include "output.h"
+#include "hash.h"
 
 static int hash_f(int argc, char **argv);
 static void hash_help(void);
diff --git a/db/logformat.c b/db/logformat.c
index 42ce245..3374c29 100644
--- a/db/logformat.c
+++ b/db/logformat.c
@@ -9,6 +9,7 @@
 #include "init.h"
 #include "output.h"
 #include "libxlog.h"
+#include "logformat.h"
 
 #define MAX_LSUNIT	256 * 1024	/* max log buf. size */
 
diff --git a/db/symlink.c b/db/symlink.c
index ebf6637..752cae4 100644
--- a/db/symlink.c
+++ b/db/symlink.c
@@ -11,7 +11,7 @@
 #include "field.h"
 #include "bit.h"
 #include "init.h"
-
+#include "symlink.h"
 
 /*
  * XXX: no idea how to handle multiple contiguous block symlinks here.
diff --git a/db/text.c b/db/text.c
index 3a279d1..adf33a7 100644
--- a/db/text.c
+++ b/db/text.c
@@ -17,6 +17,7 @@
 #include "io.h"
 #include "output.h"
 #include "init.h"
+#include "text.h"
 
 static void     print_rawtext(void *data, int len);
 
diff --git a/include/avl64.h b/include/avl64.h
index 7a66883..4042f6c 100644
--- a/include/avl64.h
+++ b/include/avl64.h
@@ -69,6 +69,12 @@ avl64_insert_immediate(
 	avl64node_t *afterp,
 	avl64node_t *newnode);
 
+avl64node_t *
+avl64_firstino(avl64node_t *root);
+
+avl64node_t *
+avl64_lastino(avl64node_t *root);
+
 void
 avl64_init_tree(
 	avl64tree_desc_t  *tree,
diff --git a/include/kmem.h b/include/kmem.h
index 03475c6..ec19ee7 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -6,6 +6,8 @@
 #ifndef __KMEM_H__
 #define __KMEM_H__
 
+#include <stdlib.h>
+
 #define KM_SLEEP	0x0001u
 #define KM_NOSLEEP	0x0002u
 #define KM_NOFS		0x0004u
diff --git a/include/libxfs.h b/include/libxfs.h
index 2bdef70..a690008 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -133,8 +133,6 @@ extern dev_t	libxfs_device_open (char *, int, int, int);
 extern void	libxfs_device_close (dev_t);
 extern int	libxfs_device_alignment (void);
 extern void	libxfs_report(FILE *);
-extern void	platform_findsizes(char *path, int fd, long long *sz, int *bsz);
-extern int	platform_nproc(void);
 
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef char	*(libxfs_get_block_t)(char *, int, void *);
diff --git a/io/getrusage.c b/io/getrusage.c
index ba704b7..6962913 100644
--- a/io/getrusage.c
+++ b/io/getrusage.c
@@ -9,6 +9,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include "init.h"
+#include "io.h"
 
 static cmdinfo_t getrusage_cmd;
 
diff --git a/io/log_writes.c b/io/log_writes.c
index 114f818..9c2285f 100644
--- a/io/log_writes.c
+++ b/io/log_writes.c
@@ -8,6 +8,7 @@
 #include <libdevmapper.h>
 #include "command.h"
 #include "init.h"
+#include "io.h"
 
 static cmdinfo_t log_writes_cmd;
 
diff --git a/libfrog/crc32.c b/libfrog/crc32.c
index 1d52f68..e3f3fd1 100644
--- a/libfrog/crc32.c
+++ b/libfrog/crc32.c
@@ -33,6 +33,7 @@
 #include "xfs.h"
 #include "xfs_arch.h"
 #include "crc32defs.h"
+#include "crc32c.h"
 
 /* types specifc to this file */
 typedef __u8	u8;
diff --git a/libfrog/linux.c b/libfrog/linux.c
index fc9f3ac..baf75ab 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -10,6 +10,7 @@
 #include <sys/sysinfo.h>
 
 #include "libxfs_priv.h"
+#include "init.h"
 #include "xfs_fs.h"
 
 extern char *progname;
diff --git a/libfrog/topology.c b/libfrog/topology.c
index cac164f..2453b84 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -10,6 +10,7 @@
 #  include <blkid/blkid.h>
 #endif /* ENABLE_BLKID */
 #include "xfs_multidisk.h"
+#include "init.h"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
diff --git a/libxfs/init.c b/libxfs/init.c
index 10dcbf3..80fbe6a 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -363,15 +363,6 @@ done:
 static int
 manage_zones(int release)
 {
-	extern kmem_zone_t	*xfs_buf_zone;
-	extern kmem_zone_t	*xfs_ili_zone;
-	extern kmem_zone_t	*xfs_inode_zone;
-	extern kmem_zone_t	*xfs_ifork_zone;
-	extern kmem_zone_t	*xfs_buf_item_zone;
-	extern kmem_zone_t	*xfs_da_state_zone;
-	extern kmem_zone_t	*xfs_btree_cur_zone;
-	extern kmem_zone_t	*xfs_bmap_free_item_zone;
-	extern kmem_zone_t	*xfs_trans_zone;
 	extern void		xfs_dir_startup();
 
 	if (release) {	/* free zone allocation */
diff --git a/libxfs/init.h b/libxfs/init.h
index e0b5091..227c768 100644
--- a/libxfs/init.h
+++ b/libxfs/init.h
@@ -6,7 +6,10 @@
 #ifndef LIBXFS_INIT_H
 #define LIBXFS_INIT_H
 
+#include "kmem.h"
+
 struct stat;
+extern int use_xfs_buf_lock;
 
 extern int platform_check_ismounted (char *path, char *block,
 					struct stat *sptr, int verbose);
@@ -19,5 +22,13 @@ extern char *platform_findblockpath (char *path);
 extern int platform_direct_blockdev (void);
 extern int platform_align_blockdev (void);
 extern unsigned long platform_physmem(void);	/* in kilobytes */
+extern void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
+extern int platform_nproc(void);
+
+extern kmem_zone_t *xfs_buf_item_zone;
+extern kmem_zone_t *xfs_ili_zone;
+extern kmem_zone_t *xfs_buf_zone;
+extern kmem_zone_t *xfs_inode_zone;
+extern kmem_zone_t *xfs_trans_zone;
 
 #endif	/* LIBXFS_INIT_H */
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 4da9bc1..e850680 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -15,6 +15,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_inode.h"
 #include "xfs_trans.h"
+#include "init.h"
 
 kmem_zone_t	*xfs_buf_item_zone;
 kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 46ff8b4..eb1e390 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_sb.h"
 #include "xfs_defer.h"
+#include "init.h"
 
 static void xfs_trans_free_items(struct xfs_trans *tp);
 STATIC struct xfs_trans *xfs_trans_dup(struct xfs_trans *tp);
diff --git a/libxfs/util.c b/libxfs/util.c
index 9932186..0a9a08e 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs_priv.h"
+#include "libxfs.h"
 #include "libxfs_io.h"
 #include "init.h"
 #include "xfs_fs.h"
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 3375e08..b48c5d4 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -5,6 +5,7 @@
  */
 
 #include "libxfs.h"
+#include "init.h"
 #include "xfs_metadump.h"
 
 char 		*progname;
@@ -183,8 +184,6 @@ usage(void)
 	exit(1);
 }
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
-
 int
 main(
 	int 		argc,
diff --git a/repair/phase2.c b/repair/phase2.c
index b92ceb8..4bd6c63 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -15,8 +15,6 @@
 #include "progress.h"
 #include "scan.h"
 
-void	set_mp(xfs_mount_t *mpp);
-
 /* workaround craziness in the xlog routines */
 int xlog_recover_do_trans(struct xlog *log, xlog_recover_t *t, int p)
 {
diff --git a/repair/scan.h b/repair/scan.h
index aa7c38d..cf4d563 100644
--- a/repair/scan.h
+++ b/repair/scan.h
@@ -58,4 +58,5 @@ scan_ags(
 	struct xfs_mount	*mp,
 	int			scan_threads);
 
+extern void set_mp(xfs_mount_t *mpp);
 #endif /* _XR_SCAN_H */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 41ab301..b73e611 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -22,6 +22,7 @@
 #include "dinode.h"
 #include "slab.h"
 #include "rmap.h"
+#include "init.h"
 
 /*
  * option tables for getsubopt calls
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 076a86a..c611f1f 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -10,6 +10,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <sys/statvfs.h>
+#include "libxfs.h"
 #include "platform_defs.h"
 #include "input.h"
 #include "path.h"
-- 
1.8.3.1
