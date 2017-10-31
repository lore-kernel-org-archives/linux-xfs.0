Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45889 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752473AbdJaWze (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 18:55:34 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9VMtXFT029429
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2017 22:55:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9VMtXlS026331
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2017 22:55:33 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v9VMtXx0005855
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2017 22:55:33 GMT
Date: Tue, 31 Oct 2017 15:55:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: scrub extended attribute leaf space
Message-ID: <20171031225532.GD4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

As we walk the attribute btree, explicitly check the structure of the
attribute leaves to make sure the pointers make sense and the freemap is
sensible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c    |  233 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/dabtree.c |    4 +
 fs/xfs/scrub/dabtree.h |    3 -
 fs/xfs/scrub/dir.c     |    2 
 4 files changed, 218 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index a70cd9b..5d624ca 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -50,8 +50,17 @@ xfs_scrub_setup_xattr(
 	struct xfs_scrub_context	*sc,
 	struct xfs_inode		*ip)
 {
-	/* Allocate the buffer without the inode lock held. */
-	sc->buf = kmem_zalloc_large(XATTR_SIZE_MAX, KM_SLEEP);
+	size_t				sz;
+
+	/*
+	 * Allocate the buffer without the inode lock held.  We need enough
+	 * space to read every xattr value in the file and enough space to
+	 * hold three copies of the xattr free space bitmap.  (Not both at
+	 * the same time.)
+	 */
+	sz = max_t(size_t, XATTR_SIZE_MAX, 3 * sizeof(long) *
+			BITS_TO_LONGS(sc->mp->m_attr_geo->blksize));
+	sc->buf = kmem_zalloc_large(sz, KM_SLEEP);
 	if (!sc->buf)
 		return -ENOMEM;
 
@@ -122,6 +131,197 @@ xfs_scrub_xattr_listent(
 	return;
 }
 
+/*
+ * Mark a range [start, start+len) in this map.  Returns true if the
+ * region was free, and false if there's a conflict or a problem.
+ *
+ * Within a char, the lowest bit of the char represents the byte with
+ * the smallest address
+ */
+STATIC bool
+xfs_scrub_xattr_set_map(
+	struct xfs_scrub_context	*sc,
+	unsigned long			*map,
+	unsigned int			start,
+	unsigned int			len)
+{
+	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
+	bool				ret = true;
+
+	if (start >= mapsize)
+		return false;
+	if (start + len > mapsize) {
+		len = mapsize - start;
+		ret = false;
+	}
+
+	ret &= find_next_bit(map, mapsize, start) >= (start + len);
+	bitmap_set(map, start, len);
+
+	return ret;
+}
+
+/*
+ * Check the leaf freemap from the usage bitmap.  Returns false if the
+ * attr freemap has problems or points to used space.
+ */
+STATIC bool
+xfs_scrub_xattr_check_freemap(
+	struct xfs_scrub_context	*sc,
+	unsigned long			*map,
+	struct xfs_attr3_icleaf_hdr	*leafhdr)
+{
+	unsigned long			*freemap;
+	unsigned long			*dstmap;
+	unsigned int			mapsize = sc->mp->m_attr_geo->blksize;
+	int				i;
+
+	/* Construct bitmap of freemap contents. */
+	freemap = (unsigned long *)sc->buf + BITS_TO_LONGS(mapsize);
+	bitmap_zero(freemap, mapsize);
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		if (!xfs_scrub_xattr_set_map(sc, freemap,
+				leafhdr->freemap[i].base,
+				leafhdr->freemap[i].size))
+			return false;
+	}
+
+	/* Look for bits that are set in freemap and are marked in use. */
+	dstmap = freemap + BITS_TO_LONGS(mapsize);
+	return bitmap_and(dstmap, freemap, map, mapsize) == 0;
+}
+
+/* Scrub an attribute leaf. */
+STATIC int
+xfs_scrub_xattr_block(
+	struct xfs_scrub_da_btree	*ds,
+	int				level)
+{
+	struct xfs_attr3_icleaf_hdr	leafhdr;
+	struct xfs_mount		*mp = ds->state->mp;
+	struct xfs_da_state_blk		*blk = &ds->state->path.blk[level];
+	struct xfs_buf			*bp = blk->bp;
+	xfs_dablk_t			*last_checked = ds->private;
+	struct xfs_attr_leafblock	*leaf = bp->b_addr;
+	struct xfs_attr_leaf_entry	*ent;
+	struct xfs_attr_leaf_entry	*entries;
+	struct xfs_attr_leaf_name_local	*lentry;
+	struct xfs_attr_leaf_name_remote	*rentry;
+	unsigned long			*usedmap = ds->sc->buf;
+	char				*name_end;
+	char				*buf_end;
+	__u32				last_hashval = 0;
+	unsigned int			usedbytes = 0;
+	unsigned int			nameidx;
+	unsigned int			hdrsize;
+	unsigned int			namesize;
+	int				i;
+
+	if (*last_checked == blk->blkno)
+		return 0;
+	*last_checked = blk->blkno;
+	bitmap_zero(usedmap, mp->m_attr_geo->blksize);
+
+	/* Check all the padding. */
+	if (xfs_sb_version_hascrc(&ds->sc->mp->m_sb)) {
+		struct xfs_attr3_leafblock	*leaf = bp->b_addr;
+
+		if (leaf->hdr.pad1 != 0 ||
+		    leaf->hdr.pad2 != cpu_to_be32(0) ||
+		    leaf->hdr.info.hdr.pad != cpu_to_be16(0))
+			xfs_scrub_da_set_corrupt(ds, level);
+	} else {
+		if (leaf->hdr.pad1 != 0 ||
+		    leaf->hdr.info.pad != cpu_to_be16(0))
+			xfs_scrub_da_set_corrupt(ds, level);
+	}
+
+	/* Check the leaf header */
+	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
+
+	if (leafhdr.usedbytes > mp->m_attr_geo->blksize)
+		xfs_scrub_da_set_corrupt(ds, level);
+	if (leafhdr.firstused > mp->m_attr_geo->blksize)
+		xfs_scrub_da_set_corrupt(ds, level);
+	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
+	if (leafhdr.firstused < hdrsize)
+		xfs_scrub_da_set_corrupt(ds, level);
+
+	if (!xfs_scrub_xattr_set_map(ds->sc, usedmap, 0, hdrsize)) {
+		xfs_scrub_da_set_corrupt(ds, level);
+		goto out;
+	}
+
+	entries = xfs_attr3_leaf_entryp(leaf);
+	if ((char *)&entries[leafhdr.count] > (char *)leaf + leafhdr.firstused)
+		xfs_scrub_da_set_corrupt(ds, level);
+
+	/* Check the entries' relations to each other */
+	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
+	for (i = 0, ent = entries; i < leafhdr.count; ent++, i++) {
+		if (!xfs_scrub_xattr_set_map(ds->sc, usedmap,
+				(char *)ent - (char *)leaf,
+				sizeof(xfs_attr_leaf_entry_t))) {
+			xfs_scrub_da_set_corrupt(ds, level);
+			goto out;
+		}
+
+		if (ent->pad2 != cpu_to_be32(0))
+			xfs_scrub_da_set_corrupt(ds, level);
+
+		if (be32_to_cpu(ent->hashval) < last_hashval)
+			xfs_scrub_da_set_corrupt(ds, level);
+		last_hashval = be32_to_cpu(ent->hashval);
+
+		nameidx = be16_to_cpu(ent->nameidx);
+		if (nameidx < hdrsize ||
+		    nameidx < leafhdr.firstused ||
+		    nameidx >= mp->m_attr_geo->blksize) {
+			xfs_scrub_da_set_corrupt(ds, level);
+			goto out;
+		}
+
+		if (ent->flags & XFS_ATTR_LOCAL) {
+			lentry = xfs_attr3_leaf_name_local(leaf, i);
+			if (lentry->namelen <= 0)
+				xfs_scrub_da_set_corrupt(ds, level);
+			name_end = (char *)lentry->nameval + lentry->namelen +
+					be16_to_cpu(lentry->valuelen);
+			if (name_end > buf_end)
+				xfs_scrub_da_set_corrupt(ds, level);
+			namesize = xfs_attr_leaf_entsize_local(
+					lentry->namelen,
+					be16_to_cpu(lentry->valuelen));
+		} else {
+			rentry = xfs_attr3_leaf_name_remote(leaf, i);
+			if (rentry->namelen <= 0)
+				xfs_scrub_da_set_corrupt(ds, level);
+			name_end = (char *)rentry->name + rentry->namelen;
+			if (name_end > buf_end)
+				xfs_scrub_da_set_corrupt(ds, level);
+			namesize = xfs_attr_leaf_entsize_remote(
+						rentry->namelen);
+			if (rentry->valueblk == cpu_to_be32(0))
+				xfs_scrub_da_set_corrupt(ds, level);
+		}
+		usedbytes += namesize;
+		if (!xfs_scrub_xattr_set_map(ds->sc, usedmap, nameidx,
+				namesize)) {
+			xfs_scrub_da_set_corrupt(ds, level);
+			goto out;
+		}
+	}
+
+	if (!xfs_scrub_xattr_check_freemap(ds->sc, usedmap, &leafhdr))
+		xfs_scrub_da_set_corrupt(ds, level);
+
+	if (leafhdr.usedbytes != usedbytes)
+		xfs_scrub_da_set_corrupt(ds, level);
+
+out:
+	return 0;
+}
+
 /* Scrub a attribute btree record. */
 STATIC int
 xfs_scrub_xattr_rec(
@@ -144,6 +344,13 @@ xfs_scrub_xattr_rec(
 
 	blk = &ds->state->path.blk[level];
 
+	/* Check the whole block, if necessary. */
+	error = xfs_scrub_xattr_block(ds, level);
+	if (error)
+		goto out;
+	if (ds->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out;
+
 	/* Check the hash of the entry. */
 	error = xfs_scrub_da_btree_hash(ds, level, &ent->hashval);
 	if (error)
@@ -158,24 +365,6 @@ xfs_scrub_xattr_rec(
 		goto out;
 	}
 
-	/* Check all the padding. */
-	if (xfs_sb_version_hascrc(&ds->sc->mp->m_sb)) {
-		struct xfs_attr3_leafblock	*leaf = bp->b_addr;
-
-		if (leaf->hdr.pad1 != 0 ||
-		    leaf->hdr.pad2 != cpu_to_be32(0) ||
-		    leaf->hdr.info.hdr.pad != cpu_to_be16(0))
-			xfs_scrub_da_set_corrupt(ds, level);
-	} else {
-		struct xfs_attr_leafblock	*leaf = bp->b_addr;
-
-		if (leaf->hdr.pad1 != 0 ||
-		    leaf->hdr.info.pad != cpu_to_be16(0))
-			xfs_scrub_da_set_corrupt(ds, level);
-	}
-	if (ent->pad2 != 0)
-		xfs_scrub_da_set_corrupt(ds, level);
-
 	/* Retrieve the entry and check it. */
 	hash = be32_to_cpu(ent->hashval);
 	badflags = ~(XFS_ATTR_LOCAL | XFS_ATTR_ROOT | XFS_ATTR_SECURE |
@@ -213,6 +402,7 @@ xfs_scrub_xattr(
 {
 	struct xfs_scrub_xattr		sx = { 0 };
 	struct attrlist_cursor_kern	cursor = { 0 };
+	xfs_dablk_t			last_checked = -1U;
 	int				error = 0;
 
 	if (!xfs_inode_hasattr(sc->ip))
@@ -220,7 +410,8 @@ xfs_scrub_xattr(
 
 	memset(&sx, 0, sizeof(sx));
 	/* Check attribute tree structure */
-	error = xfs_scrub_da_btree(sc, XFS_ATTR_FORK, xfs_scrub_xattr_rec);
+	error = xfs_scrub_da_btree(sc, XFS_ATTR_FORK, xfs_scrub_xattr_rec,
+			&last_checked);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 4a93cf1..c21c528 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -467,7 +467,8 @@ int
 xfs_scrub_da_btree(
 	struct xfs_scrub_context	*sc,
 	int				whichfork,
-	xfs_scrub_da_btree_rec_fn	scrub_fn)
+	xfs_scrub_da_btree_rec_fn	scrub_fn,
+	void				*private)
 {
 	struct xfs_scrub_da_btree	ds = {};
 	struct xfs_mount		*mp = sc->mp;
@@ -492,6 +493,7 @@ xfs_scrub_da_btree(
 	ds.state->args = &ds.dargs;
 	ds.state->mp = mp;
 	ds.sc = sc;
+	ds.private = private;
 	if (whichfork == XFS_ATTR_FORK) {
 		ds.dargs.geo = mp->m_attr_geo;
 		ds.lowest = 0;
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index 2a766de1f..d31468d 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -28,6 +28,7 @@ struct xfs_scrub_da_btree {
 	int				maxrecs[XFS_DA_NODE_MAXDEPTH];
 	struct xfs_da_state		*state;
 	struct xfs_scrub_context	*sc;
+	void				*private;
 
 	/*
 	 * Lowest and highest directory block address in which we expect
@@ -53,6 +54,6 @@ void xfs_scrub_da_set_corrupt(struct xfs_scrub_da_btree *ds, int level);
 int xfs_scrub_da_btree_hash(struct xfs_scrub_da_btree *ds, int level,
 			    __be32 *hashp);
 int xfs_scrub_da_btree(struct xfs_scrub_context *sc, int whichfork,
-		       xfs_scrub_da_btree_rec_fn scrub_fn);
+		       xfs_scrub_da_btree_rec_fn scrub_fn, void *private);
 
 #endif /* __XFS_SCRUB_DABTREE_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 169fb10..c61362f 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -770,7 +770,7 @@ xfs_scrub_directory(
 	}
 
 	/* Check directory tree structure */
-	error = xfs_scrub_da_btree(sc, XFS_DATA_FORK, xfs_scrub_dir_rec);
+	error = xfs_scrub_da_btree(sc, XFS_DATA_FORK, xfs_scrub_dir_rec, NULL);
 	if (error)
 		return error;
 
