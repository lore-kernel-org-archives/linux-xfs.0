Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9259C7F3F
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 17:11:10 -0500 (CDT)
Date: Fri, 3 Oct 2014 17:11:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 24/35] libxfs: change interface of xfs_nameops.hashname
Message-ID: <20141003221110.GX1865@sgi.com>
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

With the introduction of the xfs_nameops.normhash callout, all uses of the
hashname callout now occur in places where an xfs_name structure must be
explicitly created just to match the parameter passing convention of this
callout. Change the arguments to a const unsigned char * and int instead.

Signed-off-by: Olaf Weber <olaf@sgi.com>

[v2: pass a 3rd argument for sb_utf8version to hashname.  --bpm]
---
 db/check.c              |  7 +++----
 include/xfs_da_btree.h  |  3 ++-
 libxfs/xfs_da_btree.c   | 18 ++++++++++--------
 libxfs/xfs_dir2.c       | 11 +++++++----
 libxfs/xfs_dir2_block.c |  7 +++----
 libxfs/xfs_dir2_data.c  |  7 +++----
 repair/phase6.c         |  3 ++-
 7 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/db/check.c b/db/check.c
index 4fd9fd0..d317a71 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2212,7 +2212,6 @@ process_data_dir_v2(
 	int			stale = 0;
 	int			tag_err;
 	__be16			*tagp;
-	struct xfs_name		xname;
 
 	data = iocur_top->data;
 	block = iocur_top->data;
@@ -2323,9 +2322,9 @@ process_data_dir_v2(
 		tag_err += be16_to_cpu(*tagp) != (char *)dep - (char *)data;
 		addr = xfs_dir2_db_off_to_dataptr(mp, db,
 			(char *)dep - (char *)data);
-		xname.name = dep->name;
-		xname.len = dep->namelen;
-		dir_hash_add(mp->m_dirnameops->hashname(&xname), addr);
+		dir_hash_add(mp->m_dirnameops->hashname(dep->name,
+					dep->namelen,
+					0 /* version for later */), addr);
 		ptr += xfs_dir3_data_entsize(mp, dep->namelen);
 		count++;
 		lastfree = 0;
diff --git a/include/xfs_da_btree.h b/include/xfs_da_btree.h
index f532d63..33efd3e 100644
--- a/include/xfs_da_btree.h
+++ b/include/xfs_da_btree.h
@@ -132,7 +132,8 @@ typedef struct xfs_da_state {
  * Name ops for directory and/or attr name operations
  */
 struct xfs_nameops {
-	xfs_dahash_t	(*hashname)(struct xfs_name *);
+	xfs_dahash_t	(*hashname)(const unsigned char *, int,
+					unsigned int);
 	int		(*normhash)(struct xfs_da_args *);
 	enum xfs_dacmp	(*compname)(struct xfs_da_args *,
 					const unsigned char *, int);
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index eb97317..c9784bd 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -1983,6 +1983,15 @@ xfs_da_hashname(const __uint8_t *name, int namelen)
 	}
 }
 
+xfs_dahash_t
+xfs_da_hashname_op(
+	const __uint8_t		*name,
+	int 			namelen,
+	unsigned int 		unused)
+{
+	return xfs_da_hashname(name, namelen);
+}
+
 enum xfs_dacmp
 xfs_da_compname(
 	struct xfs_da_args *args,
@@ -1993,13 +2002,6 @@ xfs_da_compname(
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
@@ -2009,7 +2011,7 @@ xfs_da_normhash(
 }
 
 const struct xfs_nameops xfs_default_nameops = {
-	.hashname	= xfs_default_hashname,
+	.hashname	= xfs_da_hashname_op,
 	.normhash	= xfs_da_normhash,
 	.compname	= xfs_da_compname
 };
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index e52d082..191925d 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -43,13 +43,15 @@ const unsigned char xfs_mode_to_ftype[S_IFMT >> S_SHIFT] = {
  */
 STATIC xfs_dahash_t
 xfs_ascii_ci_hashname(
-	struct xfs_name	*name)
+	const unsigned char *name,
+	int len,
+	unsigned int unused)
 {
 	xfs_dahash_t	hash;
 	int		i;
 
-	for (i = 0, hash = 0; i < name->len; i++)
-		hash = tolower(name->name[i]) ^ rol32(hash, 7);
+	for (i = 0, hash = 0; i < len; i++)
+		hash = tolower(name[i]) ^ rol32(hash, 7);
 
 	return hash;
 }
@@ -475,7 +477,8 @@ xfs_dir_canenter(
 	args.name = name->name;
 	args.namelen = name->len;
 	args.filetype = name->type;
-	args.hashval = dp->i_mount->m_dirnameops->hashname(name);
+	args.hashval = dp->i_mount->m_dirnameops->hashname(name->name,
+			name->len, 0 /* version for later */);
 	args.dp = dp;
 	args.whichfork = XFS_DATA_FORK;
 	args.trans = tp;
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 2880431..c26308e 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -1047,7 +1047,6 @@ xfs_dir2_sf_to_block(
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform header  */
 	__be16			*tagp;		/* end of data entry */
 	xfs_trans_t		*tp;		/* transaction pointer */
-	struct xfs_name		name;
 	struct xfs_ifork	*ifp;
 
 	trace_xfs_dir2_sf_to_block(args);
@@ -1205,10 +1204,10 @@ xfs_dir2_sf_to_block(
 		tagp = xfs_dir3_data_entry_tag_p(mp, dep);
 		*tagp = cpu_to_be16((char *)dep - (char *)hdr);
 		xfs_dir2_data_log_entry(tp, bp, dep);
-		name.name = sfep->name;
-		name.len = sfep->namelen;
 		blp[2 + i].hashval = cpu_to_be32(mp->m_dirnameops->
-							hashname(&name));
+					hashname(sfep->name,
+						 sfep->namelen,
+						 0 /* version for later */));
 		blp[2 + i].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 						 (char *)dep - (char *)hdr));
 		offset = (int)((char *)(tagp + 1) - (char *)hdr);
diff --git a/libxfs/xfs_dir2_data.c b/libxfs/xfs_dir2_data.c
index dc9df4d..ada4d1d 100644
--- a/libxfs/xfs_dir2_data.c
+++ b/libxfs/xfs_dir2_data.c
@@ -46,7 +46,6 @@ __xfs_dir3_data_check(
 	xfs_mount_t		*mp;		/* filesystem mount point */
 	char			*p;		/* current data position */
 	int			stale;		/* count of stale leaves */
-	struct xfs_name		name;
 
 	mp = bp->b_target->bt_mount;
 	hdr = bp->b_addr;
@@ -142,9 +141,9 @@ __xfs_dir3_data_check(
 			addr = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
 				(xfs_dir2_data_aoff_t)
 				((char *)dep - (char *)hdr));
-			name.name = dep->name;
-			name.len = dep->namelen;
-			hash = mp->m_dirnameops->hashname(&name);
+			hash = mp->m_dirnameops->hashname(dep->name,
+					dep->namelen,
+					0 /* version for later */);
 			for (i = 0; i < be32_to_cpu(btp->count); i++) {
 				if (be32_to_cpu(lep[i].address) == addr &&
 				    be32_to_cpu(lep[i].hashval) == hash)
diff --git a/repair/phase6.c b/repair/phase6.c
index f13069f..c18ef69 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -195,7 +195,8 @@ dir_hash_add(
 	dup = 0;
 
 	if (!junk) {
-		hash = mp->m_dirnameops->hashname(&xname);
+		hash = mp->m_dirnameops->hashname(name, namelen,
+				0 /* version for later */);
 		byhash = DIR_HASH_FUNC(hashtab, hash);
 
 		/*
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
