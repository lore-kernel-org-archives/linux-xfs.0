Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5F86F7F62
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 07:36:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C23A9AC00F
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 05:36:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KvWkY6PCQGSWJn9D for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 05:36:18 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UfUkj-0007Z6-84
	for xfs@oss.sgi.com; Thu, 23 May 2013 22:36:17 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UfUkZ-0001e1-4E
	for xfs@oss.sgi.com; Thu, 23 May 2013 22:36:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs_db: add CRC support for attribute fork structures.
Date: Thu, 23 May 2013 22:36:05 +1000
Message-Id: <1369312565-6266-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1369312565-6266-1-git-send-email-david@fromorbit.com>
References: <1369032783-24973-1-git-send-email-david@fromorbit.com>
	<1369312565-6266-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/attr.c  |  393 ++++++++++++++++++++++++++++++++++++------------------------
 db/attr.h  |    4 +
 db/field.c |   13 ++
 db/field.h |    8 ++
 db/type.c  |    4 +-
 db/type.h  |    2 +-
 6 files changed, 268 insertions(+), 156 deletions(-)

diff --git a/db/attr.c b/db/attr.c
index 05049ba..f74e4e2 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -148,84 +148,141 @@ const field_t	attr_node_hdr_flds[] = {
 	{ NULL }
 };
 
-/*ARGSUSED*/
 static int
 attr_leaf_entries_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_attr_leafblock_t	*block;
+	struct xfs_attr_leafblock *leaf = obj;
 
 	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC) 
+	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
 		return 0;
-	return be16_to_cpu(block->hdr.count);
+	return be16_to_cpu(leaf->hdr.count);
+}
+
+static int
+attr3_leaf_entries_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_attr3_leafblock *leaf = obj;
+
+	ASSERT(startoff == 0);
+	if (be16_to_cpu(leaf->hdr.info.hdr.magic) != XFS_ATTR_LEAF_MAGIC)
+		return 0;
+	return be16_to_cpu(leaf->hdr.count);
 }
 
-/*ARGSUSED*/
 static int
 attr_leaf_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_attr_leafblock_t	*block;
+	struct xfs_attr_leafblock *leaf = obj;
 
 	ASSERT(startoff == 0);
-	block = obj;
-	return be16_to_cpu(block->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC;
+	return be16_to_cpu(leaf->hdr.info.magic) == XFS_ATTR_LEAF_MAGIC;
 }
 
 static int
-attr_leaf_name_local_count(
+attr3_leaf_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_attr_leafblock_t	*block;
-	xfs_attr_leaf_entry_t	*e;
-	int			i;
-	int			off;
+	struct xfs_attr3_leafblock *leaf = obj;
 
-	ASSERT(bitoffs(startoff) == 0);
-	off = byteize(startoff);
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
+	ASSERT(startoff == 0);
+	return be16_to_cpu(leaf->hdr.info.hdr.magic) == XFS_ATTR3_LEAF_MAGIC;
+}
+
+typedef int (*attr_leaf_entry_walk_f)(struct xfs_attr_leafblock *,
+				      struct xfs_attr_leaf_entry *, int);
+static int
+attr_leaf_entry_walk(
+	void				*obj,
+	int				startoff,
+	attr_leaf_entry_walk_f		func)
+{
+	struct xfs_attr_leafblock	*leaf = obj;
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct xfs_attr_leaf_entry	*entries;
+	struct xfs_attr_leaf_entry	*e;
+	int				i;
+	int				off;
+
+	ASSERT(startoff == 0);
+	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC ||
+	    be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR3_LEAF_MAGIC)
 		return 0;
-	for (i = 0; i < be16_to_cpu(block->hdr.count); i++) {
-		e = &block->entries[i];
+
+	off = byteize(startoff);
+	xfs_attr3_leaf_hdr_from_disk(&leafhdr, leaf);
+	entries = xfs_attr3_leaf_entryp(leaf);
+
+	for (i = 0; i < leafhdr.count; i++) {
+		e = &entries[i];
 		if (be16_to_cpu(e->nameidx) == off)
-			return (e->flags & XFS_ATTR_LOCAL) != 0;
+			return func(leaf, e, i);
 	}
 	return 0;
 }
 
 static int
+__attr_leaf_name_local_count(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	return (e->flags & XFS_ATTR_LOCAL) != 0;
+}
+
+static int
+attr_leaf_name_local_count(
+	void			*obj,
+	int			startoff)
+{
+	return attr_leaf_entry_walk(obj, startoff,
+				    __attr_leaf_name_local_count);
+}
+
+static int
+__attr_leaf_name_local_name_count(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	struct xfs_attr_leaf_name_local	*l;
+
+	if (!(e->flags & XFS_ATTR_LOCAL))
+		return 0;
+
+	l = xfs_attr3_leaf_name_local(leaf, i);
+	return l->namelen;
+}
+
+static int
 attr_leaf_name_local_name_count(
 	void				*obj,
 	int				startoff)
 {
-	xfs_attr_leafblock_t		*block;
-	xfs_attr_leaf_entry_t		*e;
-	int				i;
-	xfs_attr_leaf_name_local_t	*l;
-	int				off;
+	return attr_leaf_entry_walk(obj, startoff,
+				    __attr_leaf_name_local_name_count);
+}
 
-	ASSERT(bitoffs(startoff) == 0);
-	off = byteize(startoff);
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
+static int
+__attr_leaf_name_local_value_count(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	struct xfs_attr_leaf_name_local	*l;
+
+	if (!(e->flags & XFS_ATTR_LOCAL))
 		return 0;
-	for (i = 0; i < be16_to_cpu(block->hdr.count); i++) {
-		e = &block->entries[i];
-		if (be16_to_cpu(e->nameidx) == off) {
-			if (e->flags & XFS_ATTR_LOCAL) {
-				l = xfs_attr3_leaf_name_local(block, i);
-				return l->namelen;
-			} else
-				return 0;
-		}
-	}
-	return 0;
+
+	l = xfs_attr3_leaf_name_local(leaf, i);
+	return be16_to_cpu(l->valuelen);
 }
 
 static int
@@ -233,84 +290,66 @@ attr_leaf_name_local_value_count(
 	void				*obj,
 	int				startoff)
 {
-	xfs_attr_leafblock_t		*block;
-	xfs_attr_leaf_entry_t		*e;
-	int				i;
-	xfs_attr_leaf_name_local_t	*l;
-	int				off;
+	return attr_leaf_entry_walk(obj, startoff,
+				    __attr_leaf_name_local_value_count);
+}
 
-	ASSERT(bitoffs(startoff) == 0);
-	off = byteize(startoff);
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
-		return 0;
-	for (i = 0; i < be16_to_cpu(block->hdr.count); i++) {
-		e = &block->entries[i];
-		if (be16_to_cpu(e->nameidx) == off) {
-			if (e->flags & XFS_ATTR_LOCAL) {
-				l = xfs_attr3_leaf_name_local(block, i);
-				return be16_to_cpu(l->valuelen);
-			} else
-				return 0;
-		}
-	}
-	return 0;
+static int
+__attr_leaf_name_local_value_offset(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	struct xfs_attr_leaf_name_local	*l;
+	char				*vp;
+
+	l = xfs_attr3_leaf_name_local(leaf, i);
+	vp = (char *)&l->nameval[l->namelen];
+
+	return (int)bitize(vp - (char *)l);
 }
 
-/*ARGSUSED*/
 static int
 attr_leaf_name_local_value_offset(
 	void				*obj,
 	int				startoff,
 	int				idx)
 {
-	xfs_attr_leafblock_t		*block;
-	xfs_attr_leaf_name_local_t	*l;
-	char				*vp;
-	int				off;
-	xfs_attr_leaf_entry_t		*e;
-	int				i;
-
-	ASSERT(bitoffs(startoff) == 0);
-	off = byteize(startoff);
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
-		return 0;
-
-	for (i = 0; i < be16_to_cpu(block->hdr.count); i++) {
-		e = &block->entries[i];
-		if (be16_to_cpu(e->nameidx) == off)
-			break;
-	}
-	if (i >= be16_to_cpu(block->hdr.count)) 
-		return 0;
+	return attr_leaf_entry_walk(obj, startoff,
+				    __attr_leaf_name_local_value_offset);
+}
 
-	l = xfs_attr3_leaf_name_local(block, i);
-	vp = (char *)&l->nameval[l->namelen];
-	return (int)bitize(vp - (char *)l);
+static int
+__attr_leaf_name_remote_count(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	return (e->flags & XFS_ATTR_LOCAL) == 0;
 }
 
 static int
 attr_leaf_name_remote_count(
-	void			*obj,
-	int			startoff)
+	void				*obj,
+	int				startoff)
 {
-	xfs_attr_leafblock_t	*block;
-	xfs_attr_leaf_entry_t	*e;
-	int			i;
-	int			off;
+	return attr_leaf_entry_walk(obj, startoff,
+				    __attr_leaf_name_remote_count);
+}
 
-	ASSERT(bitoffs(startoff) == 0);
-	off = byteize(startoff);
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
+static int
+__attr_leaf_name_remote_name_count(
+	struct xfs_attr_leafblock	*leaf,
+	struct xfs_attr_leaf_entry      *e,
+	int				i)
+{
+	struct xfs_attr_leaf_name_remote *r;
+
+	if (e->flags & XFS_ATTR_LOCAL)
 		return 0;
-	for (i = 0; i < be16_to_cpu(block->hdr.count); i++) {
-		e = &block->entries[i];
-		if (be16_to_cpu(e->nameidx) == off)
-			return (e->flags & XFS_ATTR_LOCAL) == 0;
-	}
-	return 0;
+
+	r = xfs_attr3_leaf_name_remote(leaf, i);
+	return r->namelen;
 }
 
 static int
@@ -318,117 +357,125 @@ attr_leaf_name_remote_name_count(
 	void				*obj,
 	int				startoff)
 {
-	xfs_attr_leafblock_t		*block;
-	xfs_attr_leaf_entry_t		*e;
-	int				i;
-	int				off;
-	xfs_attr_leaf_name_remote_t	*r;
-
-	ASSERT(bitoffs(startoff) == 0);
-	off = byteize(startoff);
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
-		return 0;
-	for (i = 0; i < be16_to_cpu(block->hdr.count); i++) {
-		e = &block->entries[i];
-		if (be16_to_cpu(e->nameidx) == off) {
-			if (!(e->flags & XFS_ATTR_LOCAL)) {
-				r = xfs_attr3_leaf_name_remote(block, i);
-				return r->namelen;
-			} else
-				return 0;
-		}
-	}
-	return 0;
+	return attr_leaf_entry_walk(obj, startoff,
+				    __attr_leaf_name_remote_name_count);
 }
 
-/*ARGSUSED*/
 int
 attr_leaf_name_size(
 	void				*obj,
 	int				startoff,
 	int				idx)
 {
-	xfs_attr_leafblock_t		*block;
-	xfs_attr_leaf_entry_t		*e;
-	xfs_attr_leaf_name_local_t	*l;
-	xfs_attr_leaf_name_remote_t	*r;
+	struct xfs_attr_leafblock	*leaf = obj;
+	struct xfs_attr_leaf_entry	*e;
+	struct xfs_attr_leaf_name_local	*l;
+	struct xfs_attr_leaf_name_remote *r;
 
 	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
+	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC ||
+	    be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR3_LEAF_MAGIC)
 		return 0;
-	e = &block->entries[idx];
+	e = &xfs_attr3_leaf_entryp(leaf)[idx];
 	if (e->flags & XFS_ATTR_LOCAL) {
-		l = xfs_attr3_leaf_name_local(block, idx);
+		l = xfs_attr3_leaf_name_local(leaf, idx);
 		return (int)bitize(xfs_attr_leaf_entsize_local(l->namelen,
 					be16_to_cpu(l->valuelen)));
 	} else {
-		r = xfs_attr3_leaf_name_remote(block, idx);
+		r = xfs_attr3_leaf_name_remote(leaf, idx);
 		return (int)bitize(xfs_attr_leaf_entsize_remote(r->namelen));
 	}
 }
 
-/*ARGSUSED*/
 static int
 attr_leaf_nvlist_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_attr_leafblock_t	*block;
+	struct xfs_attr_leafblock *leaf = obj;
+
+	ASSERT(startoff == 0);
+	if (be16_to_cpu(leaf->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
+		return 0;
+	return be16_to_cpu(leaf->hdr.count);
+}
+
+static int
+attr3_leaf_nvlist_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_attr3_leafblock *leaf = obj;
 
 	ASSERT(startoff == 0);
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_ATTR_LEAF_MAGIC)
+	if (be16_to_cpu(leaf->hdr.info.hdr.magic) != XFS_ATTR3_LEAF_MAGIC)
 		return 0;
-	return be16_to_cpu(block->hdr.count);
+	return be16_to_cpu(leaf->hdr.count);
 }
 
-/*ARGSUSED*/
 static int
 attr_leaf_nvlist_offset(
 	void			*obj,
 	int			startoff,
 	int			idx)
 {
-	xfs_attr_leafblock_t	*block;
-	xfs_attr_leaf_entry_t	*e;
+	struct xfs_attr_leafblock *leaf = obj;
+	struct xfs_attr_leaf_entry *e;
 
 	ASSERT(startoff == 0);
-	block = obj;
-	e = &block->entries[idx];
+	e = &xfs_attr3_leaf_entryp(leaf)[idx];
 	return bitize(be16_to_cpu(e->nameidx));
 }
 
-/*ARGSUSED*/
 static int
 attr_node_btree_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_da_intnode_t	*block;
+	struct xfs_da_intnode	*node = obj;
 
 	ASSERT(startoff == 0);		/* this is a base structure */
-	block = obj;
-	if (be16_to_cpu(block->hdr.info.magic) != XFS_DA_NODE_MAGIC)
+	if (be16_to_cpu(node->hdr.info.magic) != XFS_DA_NODE_MAGIC)
+		return 0;
+	return be16_to_cpu(node->hdr.__count);
+}
+
+static int
+attr3_node_btree_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_da3_intnode	*node = obj;
+
+	ASSERT(startoff == 0);
+	if (be16_to_cpu(node->hdr.info.hdr.magic) != XFS_DA3_NODE_MAGIC)
 		return 0;
-	return be16_to_cpu(block->hdr.__count);
+	return be16_to_cpu(node->hdr.__count);
 }
 
-/*ARGSUSED*/
+
 static int
 attr_node_hdr_count(
 	void			*obj,
 	int			startoff)
 {
-	xfs_da_intnode_t	*block;
+	struct xfs_da_intnode	*node = obj;
+
+	ASSERT(startoff == 0);
+	return be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC;
+}
+
+static int
+attr3_node_hdr_count(
+	void			*obj,
+	int			startoff)
+{
+	struct xfs_da3_intnode	*node = obj;
 
 	ASSERT(startoff == 0);
-	block = obj;
-	return be16_to_cpu(block->hdr.info.magic) == XFS_DA_NODE_MAGIC;
+	return be16_to_cpu(node->hdr.info.hdr.magic) == XFS_DA3_NODE_MAGIC;
 }
 
-/*ARGSUSED*/
 int
 attr_size(
 	void	*obj,
@@ -437,3 +484,41 @@ attr_size(
 {
 	return bitize(mp->m_sb.sb_blocksize);
 }
+
+/*
+ * CRC enabled attribute block field definitions
+ */
+const field_t	attr3_hfld[] = {
+	{ "", FLDT_ATTR3, OI(0), C1, 0, TYP_NONE },
+	{ NULL }
+};
+
+#define	L3OFF(f)	bitize(offsetof(struct xfs_attr3_leafblock, f))
+#define	N3OFF(f)	bitize(offsetof(struct xfs_da3_intnode, f))
+const field_t	attr3_flds[] = {
+	{ "hdr", FLDT_ATTR3_LEAF_HDR, OI(L3OFF(hdr)), attr3_leaf_hdr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "hdr", FLDT_DA3_NODE_HDR, OI(N3OFF(hdr)), attr3_node_hdr_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "entries", FLDT_ATTR_LEAF_ENTRY, OI(L3OFF(entries)),
+	  attr3_leaf_entries_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
+	{ "btree", FLDT_ATTR_NODE_ENTRY, OI(N3OFF(__btree)),
+	  attr3_node_btree_count, FLD_ARRAY|FLD_COUNT, TYP_NONE },
+	{ "nvlist", FLDT_ATTR_LEAF_NAME, attr_leaf_nvlist_offset,
+	  attr3_leaf_nvlist_count, FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ NULL }
+};
+
+#define	LH3OFF(f)	bitize(offsetof(struct xfs_attr3_leaf_hdr, f))
+const field_t	attr3_leaf_hdr_flds[] = {
+	{ "info", FLDT_DA3_BLKINFO, OI(LH3OFF(info)), C1, 0, TYP_NONE },
+	{ "count", FLDT_UINT16D, OI(LH3OFF(count)), C1, 0, TYP_NONE },
+	{ "usedbytes", FLDT_UINT16D, OI(LH3OFF(usedbytes)), C1, 0, TYP_NONE },
+	{ "firstused", FLDT_UINT16D, OI(LH3OFF(firstused)), C1, 0, TYP_NONE },
+	{ "holes", FLDT_UINT8D, OI(LH3OFF(holes)), C1, 0, TYP_NONE },
+	{ "pad1", FLDT_UINT8X, OI(LH3OFF(pad1)), C1, FLD_SKIPALL, TYP_NONE },
+	{ "freemap", FLDT_ATTR_LEAF_MAP, OI(LH3OFF(freemap)),
+	  CI(XFS_ATTR_LEAF_MAPSIZE), FLD_ARRAY, TYP_NONE },
+	{ NULL }
+};
+
diff --git a/db/attr.h b/db/attr.h
index f659ac2..4a84b70 100644
--- a/db/attr.h
+++ b/db/attr.h
@@ -26,5 +26,9 @@ extern const field_t	attr_leaf_name_flds[];
 extern const field_t	attr_node_entry_flds[];
 extern const field_t	attr_node_hdr_flds[];
 
+extern const field_t	attr3_flds[];
+extern const field_t	attr3_leaf_hdr_flds[];
+extern const field_t	attr3_node_hdr_flds[];
+
 extern int	attr_leaf_name_size(void *obj, int startoff, int idx);
 extern int	attr_size(void *obj, int startoff, int idx);
diff --git a/db/field.c b/db/field.c
index cb15318..6a7a0e2 100644
--- a/db/field.c
+++ b/db/field.c
@@ -56,6 +56,8 @@ const ftattr_t	ftattrtab[] = {
 	  FTARG_SKIPNULL, fa_agino, NULL },
 	{ FLDT_AGNUMBER, "agnumber", fp_num, "%u", SI(bitsz(xfs_agnumber_t)),
 	  FTARG_DONULL, NULL, NULL },
+
+/* attr fields */
 	{ FLDT_ATTR, "attr", NULL, (char *)attr_flds, attr_size, FTARG_SIZE,
 	  NULL, attr_flds },
 	{ FLDT_ATTR_BLKINFO, "attr_blkinfo", NULL, (char *)attr_blkinfo_flds,
@@ -84,6 +86,17 @@ const ftattr_t	ftattrtab[] = {
 	  fa_attrblock, NULL },
 	{ FLDT_ATTRSHORT, "attrshort", NULL, (char *)attr_shortform_flds,
 	  attrshort_size, FTARG_SIZE, NULL, attr_shortform_flds },
+
+/* attr3 specific fields */
+	{ FLDT_ATTR3, "attr", NULL, (char *)attr3_flds, attr_size, FTARG_SIZE,
+	  NULL, attr3_flds },
+	{ FLDT_ATTR3_LEAF_HDR, "attr_leaf_hdr", NULL,
+	  (char *)attr3_leaf_hdr_flds, SI(bitsz(struct xfs_attr3_leaf_hdr)),
+	  0, NULL, attr3_leaf_hdr_flds },
+	{ FLDT_ATTR3_NODE_HDR, "attr_node_hdr", NULL,
+	  (char *)da3_node_hdr_flds, SI(bitsz(struct xfs_da3_node_hdr)),
+	  0, NULL, da3_node_hdr_flds },
+
 	{ FLDT_BMAPBTA, "bmapbta", NULL, (char *)bmapbta_flds, btblock_size,
 	  FTARG_SIZE, NULL, bmapbta_flds },
 	{ FLDT_BMAPBTA_CRC, "bmapbta", NULL, (char *)bmapbta_crc_flds,
diff --git a/db/field.h b/db/field.h
index 5671571..9a12f1c 100644
--- a/db/field.h
+++ b/db/field.h
@@ -27,6 +27,8 @@ typedef enum fldt	{
 	FLDT_AGINO,
 	FLDT_AGINONN,
 	FLDT_AGNUMBER,
+
+	/* attr fields */
 	FLDT_ATTR,
 	FLDT_ATTR_BLKINFO,
 	FLDT_ATTR_LEAF_ENTRY,
@@ -39,6 +41,12 @@ typedef enum fldt	{
 	FLDT_ATTR_SF_HDR,
 	FLDT_ATTRBLOCK,
 	FLDT_ATTRSHORT,
+
+	/* attr 3 specific fields */
+	FLDT_ATTR3,
+	FLDT_ATTR3_LEAF_HDR,
+	FLDT_ATTR3_NODE_HDR,
+
 	FLDT_BMAPBTA,
 	FLDT_BMAPBTA_CRC,
 	FLDT_BMAPBTAKEY,
diff --git a/db/type.c b/db/type.c
index 0c64422..692ad73 100644
--- a/db/type.c
+++ b/db/type.c
@@ -53,6 +53,7 @@ static const typ_t	__typtab[] = {
 	{ TYP_AGFL, "agfl", handle_struct, agfl_hfld },
 	{ TYP_AGI, "agi", handle_struct, agi_hfld },
 	{ TYP_ATTR, "attr", handle_struct, attr_hfld },
+	{ TYP_ATTR3, NULL, NULL, NULL },
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_hfld },
 	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_hfld },
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_hfld },
@@ -77,7 +78,8 @@ static const typ_t	__typtab_crc[] = {
 	{ TYP_AGF, "agf", handle_struct, agf_hfld },
 	{ TYP_AGFL, "agfl", handle_struct, agfl_crc_hfld },
 	{ TYP_AGI, "agi", handle_struct, agi_hfld },
-	{ TYP_ATTR, "attr", handle_struct, attr_hfld },
+	{ TYP_ATTR, NULL, NULL, NULL },
+	{ TYP_ATTR3, "attr3", handle_struct, attr_hfld },
 	{ TYP_BMAPBTA, "bmapbta", handle_struct, bmapbta_crc_hfld },
 	{ TYP_BMAPBTD, "bmapbtd", handle_struct, bmapbtd_crc_hfld },
 	{ TYP_BNOBT, "bnobt", handle_struct, bnobt_crc_hfld },
diff --git a/db/type.h b/db/type.h
index 8fd8dc3..10946ad 100644
--- a/db/type.h
+++ b/db/type.h
@@ -23,7 +23,7 @@ struct field;
 
 typedef enum typnm
 {
-	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_BMAPBTA,
+	TYP_AGF, TYP_AGFL, TYP_AGI, TYP_ATTR, TYP_ATTR3, TYP_BMAPBTA,
 	TYP_BMAPBTD, TYP_BNOBT, TYP_CNTBT, TYP_DATA,
 	TYP_DIR2, TYP_DIR3, TYP_DQBLK, TYP_INOBT, TYP_INODATA, TYP_INODE,
 	TYP_LOG, TYP_RTBITMAP, TYP_RTSUMMARY, TYP_SB, TYP_SYMLINK,
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
