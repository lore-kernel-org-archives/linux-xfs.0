Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45C4C7F55
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:13:07 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:13:06 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 27/35] libxfs: add xfs_nameops for utf8 and utf8+casefold.
Message-ID: <20141003221306.GA1865@sgi.com>
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

[v2: updated to pass through sb_utf8version. -bpm]
---
 libxfs/xfs_utf8.c | 208 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 208 insertions(+)

diff --git a/libxfs/xfs_utf8.c b/libxfs/xfs_utf8.c
index ebfdaec..3be1fbb 100644
--- a/libxfs/xfs_utf8.c
+++ b/libxfs/xfs_utf8.c
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
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
