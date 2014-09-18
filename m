Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0BBC87F37
	for <xfs@oss.sgi.com>; Thu, 18 Sep 2014 15:10:41 -0500 (CDT)
Date: Thu, 18 Sep 2014 15:10:40 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 04/10] xfs: change interface of xfs_nameops.normhash
Message-ID: <20140918201040.GF4482@sgi.com>
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

From: Olaf Weber <olaf@sgi.com>

With the introduction of the xfs_nameops.normhash callout, all uses of the
hashname callout now occur in places where an xfs_name structure must be
explicitly created just to match the parameter passing convention of this
callout. Change the arguments to a const unsigned char * and int instead.

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
 fs/xfs/libxfs/xfs_da_btree.c   | 9 +--------
 fs/xfs/libxfs/xfs_da_btree.h   | 2 +-
 fs/xfs/libxfs/xfs_dir2.c       | 7 ++++---
 fs/xfs/libxfs/xfs_dir2_block.c | 2 +-
 fs/xfs/libxfs/xfs_dir2_data.c  | 3 ++-
 5 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 07a3acf..a0608ca 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1983,13 +1983,6 @@ xfs_da_compname(
 					XFS_CMP_EXACT : XFS_CMP_DIFFERENT;
 }
 
-static xfs_dahash_t
-xfs_default_hashname(
-	struct xfs_name	*name)
-{
-	return xfs_da_hashname(name->name, name->len);
-}
-
 STATIC int
 xfs_da_normhash(
 	struct xfs_da_args *args)
@@ -1999,7 +1992,7 @@ xfs_da_normhash(
 }
 
 const struct xfs_nameops xfs_default_nameops = {
-	.hashname	= xfs_default_hashname,
+	.hashname	= xfs_da_hashname,
 	.normhash	= xfs_da_normhash,
 	.compname	= xfs_da_compname
 };
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 6cdafee..4d6b36f 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -151,7 +151,7 @@ typedef struct xfs_da_state {
  * Name ops for directory and/or attr name operations
  */
 struct xfs_nameops {
-	xfs_dahash_t	(*hashname)(struct xfs_name *);
+	xfs_dahash_t	(*hashname)(const unsigned char *, int);
 	int		(*normhash)(struct xfs_da_args *);
 	enum xfs_dacmp	(*compname)(struct xfs_da_args *,
 					const unsigned char *, int);
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 55733a6..84e5ca9 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -45,13 +45,14 @@ struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
  */
 STATIC xfs_dahash_t
 xfs_ascii_ci_hashname(
-	struct xfs_name	*name)
+	const unsigned char *name,
+	int len)
 {
 	xfs_dahash_t	hash;
 	int		i;
 
-	for (i = 0, hash = 0; i < name->len; i++)
-		hash = tolower(name->name[i]) ^ rol32(hash, 7);
+	for (i = 0, hash = 0; i < len; i++)
+		hash = tolower(name[i]) ^ rol32(hash, 7);
 
 	return hash;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 990bf0c..f93c141 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1231,7 +1231,7 @@ xfs_dir2_sf_to_block(
 		name.name = sfep->name;
 		name.len = sfep->namelen;
 		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
-							hashname(&name));
+					hashname(sfep->name, sfep->namelen));
 		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(
 						 (char *)dep - (char *)hdr));
 		offset = (int)((char *)(tagp + 1) - (char *)hdr);
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index fdd803f..28c35cf 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -179,7 +179,8 @@ __xfs_dir3_data_check(
 						((char *)dep - (char *)hdr));
 			name.name = dep->name;
 			name.len = dep->namelen;
-			hash = mp->m_dirnameops->hashname(&name);
+			hash = mp->m_dirnameops->hashname(dep->name,
+					dep->namelen);
 			for (i = 0; i < be32_to_cpu(btp->count); i++) {
 				if (be32_to_cpu(lep[i].address) == addr &&
 				    be32_to_cpu(lep[i].hashval) == hash)
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
