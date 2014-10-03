Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA7317F37
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:01:21 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:01:18 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 11/16] xfs: add xfs_nameops for utf8 and utf8+casefold.
Message-ID: <20141003220118.GJ1865@sgi.com>
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

From: Olaf Weber <olaf@sgi.com>

The xfs_utf8_nameops use the nfkdi normalization when comparing filenames,
and are installed if the utf8bit is set in the super block.

The xfs_utf8_ci_nameops use the nfkdicf normalization when comparing
filenames, and are installed if both the utf8bit and the borgbit are set
in the superblock.

Normalized filenames are not stored on disk. Normalization will fail if a
filename is not valid UTF-8, in which case the filename is treated as an
opaque blob.

Signed-off-by: Olaf Weber <olaf@sgi.com>

---
[v2: updated to use utf8norm.ko module;
     compiled conditionally on CONFIG_XFS_UTF8=y;
     utf8version is now a function;
     move xfs_utf8.[ch] into libxfs. --bpm]
[v3: pass utf8version from the superblock through xfs_nameops
     instead of the max version of the normalization module. --bpm]
---
 fs/xfs/Kconfig           |   9 ++
 fs/xfs/Makefile          |   2 +
 fs/xfs/libxfs/xfs_dir2.c |   4 +-
 fs/xfs/libxfs/xfs_utf8.c | 208 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_utf8.h |   3 +
 fs/xfs/xfs_iops.c        |   2 +-
 6 files changed, 225 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 5d47b4d..1e8a463 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -95,3 +95,12 @@ config XFS_DEBUG
 	  not useful unless you are debugging a particular problem.
 
 	  Say N unless you are an XFS developer, or you play one on TV.
+
+config XFS_UTF8
+	bool "XFS UTF-8 support"
+	depends on XFS_FS
+	select CONFIG_UTF8_NORMALIZATION
+	help
+	  Say Y here to enable utf8 normalization support in XFS.  You
+	  will be able to mount and use filesystems created with the
+	  utf8 mkfs.xfs option.
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d617999..192aaca 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -114,6 +114,8 @@ xfs-$(CONFIG_XFS_QUOTA)		+= xfs_dquot.o \
 				   xfs_qm.o \
 				   xfs_quotaops.o
 
+xfs-$(CONFIG_XFS_UTF8)		+= libxfs/xfs_utf8.o
+
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= xfs_rtalloc.o
 
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 2c89211..9cfbd6b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -165,9 +165,9 @@ xfs_da_mount(
 		/* XXX these are replaced in the next patch need
 		   to do some kind of reordering here */
 		if (xfs_sb_version_hasasciici(&mp->m_sb))
-			mp->m_dirnameops = &xfs_ascii_ci_nameops;
+			mp->m_dirnameops = &xfs_utf8_ci_nameops;
 		else
-			mp->m_dirnameops = &xfs_default_nameops;
+			mp->m_dirnameops = &xfs_utf8_nameops;
 #else
 		xfs_warn(mp,
 "Recompile XFS with CONFIG_XFS_UTF8 to mount this filesystem");
diff --git a/fs/xfs/libxfs/xfs_utf8.c b/fs/xfs/libxfs/xfs_utf8.c
index 7e63111..1e75299 100644
--- a/fs/xfs/libxfs/xfs_utf8.c
+++ b/fs/xfs/libxfs/xfs_utf8.c
@@ -68,3 +68,211 @@ xfs_utf8_version_ok(
 
 	return 0;
 }
+
+/*
+ * xfs nameops using nfkdi
+ */
+
+static xfs_dahash_t
+xfs_utf8_hashname(
+	const unsigned char *name,
+	int len,
+	unsigned int sb_utf8version)
+{
+	utf8data_t	nfkdi;
+	struct utf8cursor u8c;
+	xfs_dahash_t	hash;
+	int		val;
+
+	nfkdi = utf8nfkdi(sb_utf8version);
+	hash = 0;
+	if (utf8ncursor(&u8c, nfkdi, name, len) < 0)
+		goto blob;
+	while ((val = utf8byte(&u8c)) > 0)
+		hash = val ^ rol32(hash, 7);
+	/* In case of error treat the name as a binary blob. */
+	if (val == 0)
+		return hash;
+blob:
+	return xfs_da_hashname(name, len);
+}
+
+static int
+xfs_utf8_normhash(
+	struct xfs_da_args *args)
+{
+	utf8data_t	nfkdi;
+	struct utf8cursor u8c;
+	unsigned char	*norm;
+	ssize_t		normlen;
+	int		c;
+	unsigned int	sb_utf8version =
+		args->dp->i_mount->m_sb.sb_utf8version;
+
+	nfkdi = utf8nfkdi(sb_utf8version);
+	/* Failure to normalize is treated as a blob. */
+	if ((normlen = utf8nlen(nfkdi, args->name, args->namelen)) < 0)
+		goto blob;
+	if (utf8ncursor(&u8c, nfkdi, args->name, args->namelen) < 0)
+		goto blob;
+	if (!(norm = kmem_alloc(normlen + 1, KM_NOFS|KM_MAYFAIL)))
+		return -ENOMEM;
+	args->norm = norm;
+	args->normlen = normlen;
+	while ((c = utf8byte(&u8c)) > 0)
+		*norm++ = c;
+	if (c == 0) {
+		*norm = '\0';
+		args->hashval = xfs_da_hashname(args->norm, args->normlen);
+		return 0;
+	}
+	kmem_free(args->norm);
+blob:
+	args->norm = NULL;
+	args->normlen = -1;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return 0;
+}
+
+static enum xfs_dacmp
+xfs_utf8_compname(
+	struct xfs_da_args *args,
+	const unsigned char *name,
+	int		len)
+{
+	utf8data_t	nfkdi;
+	struct utf8cursor u8c;
+	const unsigned char *norm;
+	int		c;
+	unsigned int	sb_utf8version =
+		args->dp->i_mount->m_sb.sb_utf8version;
+
+	ASSERT(args->norm || args->normlen == -1);
+
+	/* Check for an exact match first. */
+	if (args->namelen == len && memcmp(args->name, name, len) == 0)
+		return XFS_CMP_EXACT;
+	/* xfs_utf8_normhash() set args->normlen to -1 for a blob */
+	if (args->normlen < 0)
+		return XFS_CMP_DIFFERENT;
+	nfkdi = utf8nfkdi(sb_utf8version);
+	if (utf8ncursor(&u8c, nfkdi, name, len) < 0)
+		return XFS_CMP_DIFFERENT;
+	norm = args->norm;
+	while ((c = utf8byte(&u8c)) > 0)
+		if (c != *norm++)
+			return XFS_CMP_DIFFERENT;
+	if (c < 0 || *norm != '\0')
+		return XFS_CMP_DIFFERENT;
+	return XFS_CMP_MATCH;
+}
+
+struct xfs_nameops xfs_utf8_nameops = {
+	.hashname = xfs_utf8_hashname,
+	.normhash = xfs_utf8_normhash,
+	.compname = xfs_utf8_compname,
+};
+
+/*
+ * xfs nameops using nfkdicf
+ */
+
+static xfs_dahash_t
+xfs_utf8_ci_hashname(
+	const unsigned char *name,
+	int len,
+	unsigned int sb_utf8version)
+{
+	utf8data_t	nfkdicf;
+	struct utf8cursor u8c;
+	xfs_dahash_t	hash;
+	int		val;
+
+	nfkdicf = utf8nfkdicf(sb_utf8version);
+	hash = 0;
+	if (utf8ncursor(&u8c, nfkdicf, name, len) < 0)
+		goto blob;
+	while ((val = utf8byte(&u8c)) > 0)
+		hash = val ^ rol32(hash, 7);
+	/* In case of error treat the name as a binary blob. */
+	if (val == 0)
+		return hash;
+blob:
+	return xfs_da_hashname(name, len);
+}
+
+static int
+xfs_utf8_ci_normhash(
+	struct xfs_da_args *args)
+{
+	utf8data_t	nfkdicf;
+	struct utf8cursor u8c;
+	unsigned char	*norm;
+	ssize_t		normlen;
+	int		c;
+	unsigned int	sb_utf8version =
+		args->dp->i_mount->m_sb.sb_utf8version;
+
+	nfkdicf = utf8nfkdicf(sb_utf8version);
+	/* Failure to normalize is treated as a blob. */
+	if ((normlen = utf8nlen(nfkdicf, args->name, args->namelen)) < 0)
+		goto blob;
+	if (utf8ncursor(&u8c, nfkdicf, args->name, args->namelen) < 0)
+		goto blob;
+	if (!(norm = kmem_alloc(normlen + 1, KM_NOFS|KM_MAYFAIL)))
+		return -ENOMEM;
+	args->norm = norm;
+	args->normlen = normlen;
+	while ((c = utf8byte(&u8c)) > 0)
+		*norm++ = c;
+	if (c == 0) {
+		*norm = '\0';
+		args->hashval = xfs_da_hashname(args->norm, args->normlen);
+		return 0;
+	}
+	kmem_free(args->norm);
+blob:
+	args->norm = NULL;
+	args->normlen = -1;
+	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	return 0;
+}
+
+static enum xfs_dacmp
+xfs_utf8_ci_compname(
+	struct xfs_da_args *args,
+	const unsigned char *name,
+	int		len)
+{
+	utf8data_t	nfkdicf;
+	struct utf8cursor u8c;
+	const unsigned char *norm;
+	int		c;
+	unsigned int	sb_utf8version =
+		args->dp->i_mount->m_sb.sb_utf8version;
+
+	ASSERT(args->norm || args->normlen == -1);
+
+	/* Check for an exact match first. */
+	if (args->namelen == len && memcmp(args->name, name, len) == 0)
+		return XFS_CMP_EXACT;
+	/* xfs_utf8_ci_normhash() set args->normlen to -1 for a blob */
+	if (args->normlen < 0)
+		return XFS_CMP_DIFFERENT;
+	nfkdicf = utf8nfkdicf(sb_utf8version);
+	if (utf8ncursor(&u8c, nfkdicf, name, len) < 0)
+		return XFS_CMP_DIFFERENT;
+	norm = args->norm;
+	while ((c = utf8byte(&u8c)) > 0)
+		if (c != *norm++)
+			return XFS_CMP_DIFFERENT;
+	if (c < 0 || *norm != '\0')
+		return XFS_CMP_DIFFERENT;
+	return XFS_CMP_MATCH;
+}
+
+struct xfs_nameops xfs_utf8_ci_nameops = {
+	.hashname = xfs_utf8_ci_hashname,
+	.normhash = xfs_utf8_ci_normhash,
+	.compname = xfs_utf8_ci_compname,
+};
diff --git a/fs/xfs/libxfs/xfs_utf8.h b/fs/xfs/libxfs/xfs_utf8.h
index 8a700de..404db54 100644
--- a/fs/xfs/libxfs/xfs_utf8.h
+++ b/fs/xfs/libxfs/xfs_utf8.h
@@ -21,4 +21,7 @@
 
 extern int xfs_utf8_version_ok(struct xfs_mount *);
 
+extern struct xfs_nameops xfs_utf8_nameops;
+extern struct xfs_nameops xfs_utf8_ci_nameops;
+
 #endif /* XFS_UTF8_H */
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index cea3d64..fbfb1bb 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1257,7 +1257,7 @@ xfs_setup_inode(
 		break;
 	case S_IFDIR:
 		lockdep_set_class(&ip->i_lock.mr_lock, &xfs_dir_ilock_class);
-		if (xfs_sb_version_hasasciici(&XFS_M(inode->i_sb)->m_sb))
+		if (xfs_sb_version_hasci(&XFS_M(inode->i_sb)->m_sb))
 			inode->i_op = &xfs_dir_ci_inode_operations;
 		else
 			inode->i_op = &xfs_dir_inode_operations;
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
