Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B6BA77F47
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:16:15 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:16:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 33/35] xfsprogs: add utf8 support to xfs_repair
Message-ID: <20141003221615.GG1865@sgi.com>
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

From: Mark Tinguely <tinguely@sgi.com>

Fix the duplicate filename detection to use the utf-8 normalization
routines.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Ben Myers <bpm@sgi.com>

[XXX use sb_utf8version on the global xfs_mount.
 TODO maybe add the xfs_mount to the args structure? --bpm]
---
 db/check.c        |  2 +-
 libxfs/xfs_utf8.c | 16 ++++++++--------
 repair/phase6.c   | 36 +++++++++++++++++++++++++-----------
 3 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/db/check.c b/db/check.c
index d317a71..9219cc8 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2324,7 +2324,7 @@ process_data_dir_v2(
 			(char *)dep - (char *)data);
 		dir_hash_add(mp->m_dirnameops->hashname(dep->name,
 					dep->namelen,
-					0 /* version for later */), addr);
+					mp->m_sb.sb_utf8version), addr);
 		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 		count++;
 		lastfree = 0;
diff --git a/libxfs/xfs_utf8.c b/libxfs/xfs_utf8.c
index f7042ef..e7a717e 100644
--- a/libxfs/xfs_utf8.c
+++ b/libxfs/xfs_utf8.c
@@ -106,8 +106,8 @@ xfs_utf8_normhash(
 	unsigned char	*norm;
 	ssize_t		normlen;
 	int		c;
-	unsigned int	sb_utf8version =
-		args->dp->i_mount->m_sb.sb_utf8version;
+	unsigned int	sb_utf8version = mp->m_sb.sb_utf8version;
+/* XXX		args->dp->i_mount->m_sb.sb_utf8version; */
 
 	/* Don't normalize system attribute names. */
 	if (args->flags & (ATTR_ROOT|ATTR_SECURE))
@@ -147,8 +147,8 @@ xfs_utf8_compname(
 	struct utf8cursor u8c;
 	const unsigned char *norm;
 	int		c;
-	unsigned int	sb_utf8version =
-		args->dp->i_mount->m_sb.sb_utf8version;
+	unsigned int	sb_utf8version = mp->m_sb.sb_utf8version;
+/* XXX		args->dp->i_mount->m_sb.sb_utf8version; */
 
 	ASSERT(args->norm || args->normlen == -1);
 
@@ -213,8 +213,8 @@ xfs_utf8_ci_normhash(
 	unsigned char	*norm;
 	ssize_t		normlen;
 	int		c;
-	unsigned int	sb_utf8version =
-		args->dp->i_mount->m_sb.sb_utf8version;
+	unsigned int	sb_utf8version = mp->m_sb.sb_utf8version;
+/* XXX		args->dp->i_mount->m_sb.sb_utf8version; */
 
 	/* Don't normalize system attribute names. */
 	if (args->flags & (ATTR_ROOT|ATTR_SECURE))
@@ -254,8 +254,8 @@ xfs_utf8_ci_compname(
 	struct utf8cursor u8c;
 	const unsigned char *norm;
 	int		c;
-	unsigned int	sb_utf8version =
-		args->dp->i_mount->m_sb.sb_utf8version;
+	unsigned int	sb_utf8version = mp->m_sb.sb_utf8version;
+/* XXX		args->dp->i_mount->m_sb.sb_utf8version; */
 
 	ASSERT(args->norm || args->normlen == -1);
 
diff --git a/repair/phase6.c b/repair/phase6.c
index c18ef69..eb3ea35 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -176,13 +176,15 @@ dir_hash_add(
 	unsigned char		*name,
 	__uint8_t		ftype)
 {
-	xfs_dahash_t		hash = 0;
 	int			byaddr;
 	int			byhash = 0;
 	dir_hash_ent_t		*p;
 	int			dup;
 	short			junk;
 	struct xfs_name		xname;
+	xfs_da_args_t		args;
+
+	memset(&args, 0, sizeof(xfs_da_args_t));
 
 	ASSERT(!hashtab->names_duped);
 
@@ -195,20 +197,30 @@ dir_hash_add(
 	dup = 0;
 
 	if (!junk) {
-		hash = mp->m_dirnameops->hashname(name, namelen,
-				0 /* version for later */);
-		byhash = DIR_HASH_FUNC(hashtab, hash);
+		int error;
+
+		args.name = name;
+		args.namelen = namelen;
+		args.inumber = inum;
+		args.whichfork = XFS_DATA_FORK;
+
+		error = mp->m_dirnameops->normhash(&args);
+		if (error)
+			do_error(_("normalize has failed %d)\n"), error);
+
+		byhash = DIR_HASH_FUNC(hashtab, args.hashval);
 
 		/*
 		 * search hash bucket for existing name.
 		 */
 		for (p = hashtab->byhash[byhash]; p; p = p->nextbyhash) {
-			if (p->hashval == hash && p->name.len == namelen) {
-				if (memcmp(p->name.name, name, namelen) == 0) {
-					dup = 1;
-					junk = 1;
-					break;
-				}
+			if (p->hashval == args.hashval &&
+			    mp->m_dirnameops->compname(&args, p->name.name,
+						       p->name.len) !=
+							 XFS_CMP_DIFFERENT) {
+				dup = 1;
+				junk = 1;
+				break;
 			}
 		}
 	}
@@ -227,7 +239,7 @@ dir_hash_add(
 	hashtab->last = p;
 
 	if (!(p->junkit = junk)) {
-		p->hashval = hash;
+		p->hashval = args.hashval;
 		p->nextbyhash = hashtab->byhash[byhash];
 		hashtab->byhash[byhash] = p;
 	}
@@ -236,6 +248,8 @@ dir_hash_add(
 	p->seen = 0;
 	p->name = xname;
 
+	if (args.norm)
+		kmem_free((void *) args.norm);
 	return !dup;
 }
 
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
