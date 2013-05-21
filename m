Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 899BE29E07
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 03:02:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 753158F8039
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 01:02:39 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7cfocipgT7UDe8Sm for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 01:02:36 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/11] xfs: rework remote attr CRCs
Date: Tue, 21 May 2013 18:02:08 +1000
Message-Id: <1369123330-9579-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1369123330-9579-1-git-send-email-david@fromorbit.com>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com

From: Dave Chinner <dchinner@redhat.com>

Note: this changes the on-disk remote attribute format. I assert
that this is OK to do as CRCs are marked experimental and the first
kernel it is included in has not yet reached release yet. Further,
the userspace utilities are still evolving and so anyone using this
stuff right now is a developer or tester using volatile filesystems
for testing this feature. Hence changing the format right now to
save longer term pain is the right thing to do.

The fundamental change is to move from a header per extent in the
attribute to a header per filesytem block in the attribute. This
means there are more header blocks and the parsing of the attribute
data is slightly more complex, but it has the advantage that we
always know the size of the attribute on disk based on the length of
the data it contains.

This is where the header-per-extent method has problems. We don't
know the size of the attribute on disk without first knowing how
many extents are used to hold it. And we can't tell from a
mapping lookup, either, because remote attributes can be allocated
contiguously with other attribute blocks and so there is no obvious
way of determining the actual size of the atribute on disk short of
walking and mapping buffers.

The problem with this approach is that if we map a buffer
incorrectly (e.g. we make the last buffer for the attribute data too
long), we then get buffer cache lookup failure when we map it
correctly. i.e. we get a size mismatch on lookup. This is not
necessarily fatal, but it's a cache coherency problem that can lead
to returning the wrong data to userspace or writing the wrong data
to disk. And debug kernels will assert fail if this occurs.

I found lots of niggly little problems trying to fix this issue on a
4k block size filesystem, finally getting it to pass with lots of
fixes. The thing is, 1024 byte filesystems still failed, and it was
getting really complex handling all the corner cases that were
showing up. And there were clearly more that I hadn't found yet.

It is complex, fragile code, and if we don't fix it now, it will be
complex, fragile code forever more.

Hence the simple fix is to add a header to each filesystem block.
This gives us the same relationship between the attribute data
length and the number of blocks on disk as we have without CRCs -
it's a linear mapping and doesn't require us to guess anything. It
is simple to implement, too - the remote block count calculated at
lookup time can be used by the remote attribute set/get/remove code
without modification for both CRC and non-CRC filesystems. The world
becomes sane again.

Because the copy-in and copy-out now need to iterate over each
filesystem block, I moved them into helper functions so we separate
the block mapping and buffer manupulations from the attribute data
and CRC header manipulations. The code becomes much clearer as a
result, and it is a lot easier to understand and debug. It also
appears to be much more robust - once it worked on 4k block size
filesystems, it has worked without failure on 1k block size
filesystems, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c   |   13 +-
 fs/xfs/xfs_attr_remote.c |  381 +++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_attr_remote.h |   10 ++
 fs/xfs/xfs_buf.c         |    1 +
 4 files changed, 247 insertions(+), 158 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 5b03d15..d788302 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -1412,7 +1412,7 @@ xfs_attr3_leaf_add_work(
 		name_rmt->valuelen = 0;
 		name_rmt->valueblk = 0;
 		args->rmtblkno = 1;
-		args->rmtblkcnt = XFS_B_TO_FSB(mp, args->valuelen);
+		args->rmtblkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	}
 	xfs_trans_log_buf(args->trans, bp,
 	     XFS_DA_LOGRANGE(leaf, xfs_attr3_leaf_name(leaf, args->index),
@@ -2354,8 +2354,9 @@ xfs_attr3_leaf_lookup_int(
 			args->index = probe;
 			args->valuelen = be32_to_cpu(name_rmt->valuelen);
 			args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
-			args->rmtblkcnt = XFS_B_TO_FSB(args->dp->i_mount,
-						       args->valuelen);
+			args->rmtblkcnt = xfs_attr3_rmt_blocks(
+							args->dp->i_mount,
+							args->valuelen);
 			return XFS_ERROR(EEXIST);
 		}
 	}
@@ -2406,7 +2407,8 @@ xfs_attr3_leaf_getvalue(
 		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
 		valuelen = be32_to_cpu(name_rmt->valuelen);
 		args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
-		args->rmtblkcnt = XFS_B_TO_FSB(args->dp->i_mount, valuelen);
+		args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
+						       valuelen);
 		if (args->flags & ATTR_KERNOVAL) {
 			args->valuelen = valuelen;
 			return 0;
@@ -2732,7 +2734,8 @@ xfs_attr3_leaf_list_int(
 				args.valuelen = valuelen;
 				args.value = kmem_alloc(valuelen, KM_SLEEP | KM_NOFS);
 				args.rmtblkno = be32_to_cpu(name_rmt->valueblk);
-				args.rmtblkcnt = XFS_B_TO_FSB(args.dp->i_mount, valuelen);
+				args.rmtblkcnt = xfs_attr3_rmt_blocks(
+							args.dp->i_mount, valuelen);
 				retval = xfs_attr_rmtval_get(&args);
 				if (retval)
 					return retval;
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index d8bcb2d..ef6b0c1 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -47,7 +47,7 @@
  * Each contiguous block has a header, so it is not just a simple attribute
  * length to FSB conversion.
  */
-static int
+int
 xfs_attr3_rmt_blocks(
 	struct xfs_mount *mp,
 	int		attrlen)
@@ -59,12 +59,43 @@ xfs_attr3_rmt_blocks(
 	return XFS_B_TO_FSB(mp, attrlen);
 }
 
+/*
+ * Checking of the remote attribute header is split into two parts. The verifier
+ * does CRC, location and bounds checking, the unpacking function checks the
+ * attribute parameters and owner.
+ */
+static bool
+xfs_attr3_rmt_hdr_ok(
+	struct xfs_mount	*mp,
+	void			*ptr,
+	xfs_ino_t		ino,
+	uint32_t		offset,
+	uint32_t		size,
+	xfs_daddr_t		bno)
+{
+	struct xfs_attr3_rmt_hdr *rmt = ptr;
+
+	if (bno != be64_to_cpu(rmt->rm_blkno))
+		return false;
+	if (offset != be32_to_cpu(rmt->rm_offset))
+		return false;
+	if (size != be32_to_cpu(rmt->rm_bytes))
+		return false;
+	if (ino != be64_to_cpu(rmt->rm_owner))
+		return false;
+
+	/* ok */
+	return true;
+}
+
 static bool
 xfs_attr3_rmt_verify(
-	struct xfs_buf		*bp)
+	struct xfs_mount	*mp,
+	void			*ptr,
+	int			fsbsize,
+	xfs_daddr_t		bno)
 {
-	struct xfs_mount	*mp = bp->b_target->bt_mount;
-	struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
+	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return false;
@@ -72,7 +103,9 @@ xfs_attr3_rmt_verify(
 		return false;
 	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_uuid))
 		return false;
-	if (bp->b_bn != be64_to_cpu(rmt->rm_blkno))
+	if (be64_to_cpu(rmt->rm_blkno) != bno)
+		return false;
+	if (be32_to_cpu(rmt->rm_bytes) > fsbsize - sizeof(*rmt))
 		return false;
 	if (be32_to_cpu(rmt->rm_offset) +
 				be32_to_cpu(rmt->rm_bytes) >= XATTR_SIZE_MAX)
@@ -88,17 +121,40 @@ xfs_attr3_rmt_read_verify(
 	struct xfs_buf	*bp)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
+	char		*ptr;
+	int		len;
+	bool		corrupt = false;
+	xfs_daddr_t	bno;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_verify_cksum(bp->b_addr, BBTOB(bp->b_length),
-			      XFS_ATTR3_RMT_CRC_OFF) ||
-	    !xfs_attr3_rmt_verify(bp)) {
+	ptr = bp->b_addr;
+	bno = bp->b_bn;
+	len = BBTOB(bp->b_length);
+	ASSERT(len >= XFS_LBSIZE(mp));
+
+	while (len > 0) {
+		if (!xfs_verify_cksum(ptr, XFS_LBSIZE(mp),
+				      XFS_ATTR3_RMT_CRC_OFF)) {
+			corrupt = true;
+			break;
+		}
+		if (!xfs_attr3_rmt_verify(mp, ptr, XFS_LBSIZE(mp), bno)) {
+			corrupt = true;
+			break;
+		}
+		len -= XFS_LBSIZE(mp);
+		ptr += XFS_LBSIZE(mp);
+		bno += mp->m_bsize;
+	}
+
+	if (corrupt) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, EFSCORRUPTED);
-	}
+	} else
+		ASSERT(len == 0);
 }
 
 static void
@@ -107,23 +163,39 @@ xfs_attr3_rmt_write_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
+	char		*ptr;
+	int		len;
+	xfs_daddr_t	bno;
 
 	/* no verification of non-crc buffers */
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return;
 
-	if (!xfs_attr3_rmt_verify(bp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
-		xfs_buf_ioerror(bp, EFSCORRUPTED);
-		return;
-	}
+	ptr = bp->b_addr;
+	bno = bp->b_bn;
+	len = BBTOB(bp->b_length);
+	ASSERT(len >= XFS_LBSIZE(mp));
+
+	while (len > 0) {
+		if (!xfs_attr3_rmt_verify(mp, ptr, XFS_LBSIZE(mp), bno)) {
+			XFS_CORRUPTION_ERROR(__func__,
+					    XFS_ERRLEVEL_LOW, mp, bp->b_addr);
+			xfs_buf_ioerror(bp, EFSCORRUPTED);
+			return;
+		}
+		if (bip) {
+			struct xfs_attr3_rmt_hdr *rmt;
 
-	if (bip) {
-		struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
-		rmt->rm_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+			rmt = (struct xfs_attr3_rmt_hdr *)ptr;
+			rmt->rm_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+		}
+		xfs_update_cksum(ptr, XFS_LBSIZE(mp), XFS_ATTR3_RMT_CRC_OFF);
+
+		len -= XFS_LBSIZE(mp);
+		ptr += XFS_LBSIZE(mp);
+		bno += mp->m_bsize;
 	}
-	xfs_update_cksum(bp->b_addr, BBTOB(bp->b_length),
-			 XFS_ATTR3_RMT_CRC_OFF);
+	ASSERT(len == 0);
 }
 
 const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
@@ -131,15 +203,16 @@ const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
 	.verify_write = xfs_attr3_rmt_write_verify,
 };
 
-static int
+STATIC int
 xfs_attr3_rmt_hdr_set(
 	struct xfs_mount	*mp,
+	void			*ptr,
 	xfs_ino_t		ino,
 	uint32_t		offset,
 	uint32_t		size,
-	struct xfs_buf		*bp)
+	xfs_daddr_t		bno)
 {
-	struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
+	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
 	if (!xfs_sb_version_hascrc(&mp->m_sb))
 		return 0;
@@ -149,36 +222,107 @@ xfs_attr3_rmt_hdr_set(
 	rmt->rm_bytes = cpu_to_be32(size);
 	uuid_copy(&rmt->rm_uuid, &mp->m_sb.sb_uuid);
 	rmt->rm_owner = cpu_to_be64(ino);
-	rmt->rm_blkno = cpu_to_be64(bp->b_bn);
-	bp->b_ops = &xfs_attr3_rmt_buf_ops;
+	rmt->rm_blkno = cpu_to_be64(bno);
 
 	return sizeof(struct xfs_attr3_rmt_hdr);
 }
 
 /*
- * Checking of the remote attribute header is split into two parts. the verifier
- * does CRC, location and bounds checking, the unpacking function checks the
- * attribute parameters and owner.
+ * Helper functions to copy attribute data in and out of the one disk extents
  */
-static bool
-xfs_attr3_rmt_hdr_ok(
-	struct xfs_mount	*mp,
-	xfs_ino_t		ino,
-	uint32_t		offset,
-	uint32_t		size,
-	struct xfs_buf		*bp)
+STATIC int
+xfs_attr_rmtval_copyout(
+	struct xfs_mount *mp,
+	struct xfs_buf	*bp,
+	xfs_ino_t	ino,
+	int		*offset,
+	int		*valuelen,
+	char		**dst)
 {
-	struct xfs_attr3_rmt_hdr *rmt = bp->b_addr;
+	char		*src = bp->b_addr;
+	xfs_daddr_t	bno = bp->b_bn;
+	int		len = BBTOB(bp->b_length);
 
-	if (offset != be32_to_cpu(rmt->rm_offset))
-		return false;
-	if (size != be32_to_cpu(rmt->rm_bytes))
-		return false;
-	if (ino != be64_to_cpu(rmt->rm_owner))
-		return false;
+	ASSERT(len >= XFS_LBSIZE(mp));
 
-	/* ok */
-	return true;
+	while (len > 0 && *valuelen > 0) {
+		int hdr_size = 0;
+		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, XFS_LBSIZE(mp));
+
+		byte_cnt = min_t(int, *valuelen, byte_cnt);
+
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			if (!xfs_attr3_rmt_hdr_ok(mp, src, ino, *offset,
+						  byte_cnt, bno)) {
+				xfs_alert(mp,
+"remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
+					bno, *offset, byte_cnt, ino);
+				return EFSCORRUPTED;
+			}
+			hdr_size = sizeof(struct xfs_attr3_rmt_hdr);
+		}
+
+		memcpy(*dst, src + hdr_size, byte_cnt);
+
+		/* roll buffer forwards */
+		len -= XFS_LBSIZE(mp);
+		src += XFS_LBSIZE(mp);
+		bno += mp->m_bsize;
+
+		/* roll attribute data forwards */
+		*valuelen -= byte_cnt;
+		*dst += byte_cnt;
+		*offset += byte_cnt;
+	}
+	return 0;
+}
+
+STATIC void
+xfs_attr_rmtval_copyin(
+	struct xfs_mount *mp,
+	struct xfs_buf	*bp,
+	xfs_ino_t	ino,
+	int		*offset,
+	int		*valuelen,
+	char		**src)
+{
+	char		*dst = bp->b_addr;
+	xfs_daddr_t	bno = bp->b_bn;
+	int		len = BBTOB(bp->b_length);
+
+	ASSERT(len >= XFS_LBSIZE(mp));
+
+	while (len > 0 && *valuelen > 0) {
+		int hdr_size;
+		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, XFS_LBSIZE(mp));
+
+		byte_cnt = min(*valuelen, byte_cnt);
+		hdr_size = xfs_attr3_rmt_hdr_set(mp, dst, ino, *offset,
+						 byte_cnt, bno);
+
+		memcpy(dst + hdr_size, *src, byte_cnt);
+
+		/*
+		 * If this is the last block, zero the remainder of it.
+		 * Check that we are actually the last block, too.
+		 */
+		if (byte_cnt + hdr_size < XFS_LBSIZE(mp)) {
+			ASSERT(*valuelen - byte_cnt == 0);
+			ASSERT(len == XFS_LBSIZE(mp));
+			memset(dst + hdr_size + byte_cnt, 0,
+					XFS_LBSIZE(mp) - hdr_size - byte_cnt);
+		}
+
+		/* roll buffer forwards */
+		len -= XFS_LBSIZE(mp);
+		dst += XFS_LBSIZE(mp);
+		bno += mp->m_bsize;
+
+		/* roll attribute data forwards */
+		*valuelen -= byte_cnt;
+		*src += byte_cnt;
+		*offset += byte_cnt;
+	}
 }
 
 /*
@@ -192,13 +336,12 @@ xfs_attr_rmtval_get(
 	struct xfs_bmbt_irec	map[ATTR_RMTVALUE_MAPSIZE];
 	struct xfs_mount	*mp = args->dp->i_mount;
 	struct xfs_buf		*bp;
-	xfs_daddr_t		dblkno;
 	xfs_dablk_t		lblkno = args->rmtblkno;
-	void			*dst = args->value;
+	char			*dst = args->value;
 	int			valuelen = args->valuelen;
 	int			nmap;
 	int			error;
-	int			blkcnt;
+	int			blkcnt = args->rmtblkcnt;
 	int			i;
 	int			offset = 0;
 
@@ -208,7 +351,6 @@ xfs_attr_rmtval_get(
 
 	while (valuelen > 0) {
 		nmap = ATTR_RMTVALUE_MAPSIZE;
-		blkcnt = xfs_attr3_rmt_blocks(mp, valuelen);
 		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
 				       blkcnt, map, &nmap,
 				       XFS_BMAPI_ATTRFORK);
@@ -217,45 +359,29 @@ xfs_attr_rmtval_get(
 		ASSERT(nmap >= 1);
 
 		for (i = 0; (i < nmap) && (valuelen > 0); i++) {
-			int	byte_cnt;
-			char	*src;
+			xfs_daddr_t	dblkno;
+			int		dblkcnt;
 
 			ASSERT((map[i].br_startblock != DELAYSTARTBLOCK) &&
 			       (map[i].br_startblock != HOLESTARTBLOCK));
 			dblkno = XFS_FSB_TO_DADDR(mp, map[i].br_startblock);
-			blkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
+			dblkcnt = XFS_FSB_TO_BB(mp, map[i].br_blockcount);
 			error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
-						   dblkno, blkcnt, 0, &bp,
+						   dblkno, dblkcnt, 0, &bp,
 						   &xfs_attr3_rmt_buf_ops);
 			if (error)
 				return error;
 
-			byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, BBTOB(bp->b_length));
-			byte_cnt = min_t(int, valuelen, byte_cnt);
-
-			src = bp->b_addr;
-			if (xfs_sb_version_hascrc(&mp->m_sb)) {
-				if (!xfs_attr3_rmt_hdr_ok(mp, args->dp->i_ino,
-							offset, byte_cnt, bp)) {
-					xfs_alert(mp,
-"remote attribute header does not match required off/len/owner (0x%x/Ox%x,0x%llx)",
-						offset, byte_cnt, args->dp->i_ino);
-					xfs_buf_relse(bp);
-					return EFSCORRUPTED;
-
-				}
-
-				src += sizeof(struct xfs_attr3_rmt_hdr);
-			}
-
-			memcpy(dst, src, byte_cnt);
+			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
+							&offset, &valuelen,
+							&dst);
 			xfs_buf_relse(bp);
+			if (error)
+				return error;
 
-			offset += byte_cnt;
-			dst += byte_cnt;
-			valuelen -= byte_cnt;
-
+			/* roll attribute extent map forwards */
 			lblkno += map[i].br_blockcount;
+			blkcnt -= map[i].br_blockcount;
 		}
 	}
 	ASSERT(valuelen == 0);
@@ -273,17 +399,13 @@ xfs_attr_rmtval_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_bmbt_irec	map;
-	struct xfs_buf		*bp;
-	xfs_daddr_t		dblkno;
 	xfs_dablk_t		lblkno;
 	xfs_fileoff_t		lfileoff = 0;
-	void			*src = args->value;
+	char			*src = args->value;
 	int			blkcnt;
 	int			valuelen;
 	int			nmap;
 	int			error;
-	int			hdrcnt = 0;
-	bool			crcs = xfs_sb_version_hascrc(&mp->m_sb);
 	int			offset = 0;
 
 	trace_xfs_attr_rmtval_set(args);
@@ -292,21 +414,14 @@ xfs_attr_rmtval_set(
 	 * Find a "hole" in the attribute address space large enough for
 	 * us to drop the new attribute's value into. Because CRC enable
 	 * attributes have headers, we can't just do a straight byte to FSB
-	 * conversion. We calculate the worst case block count in this case
-	 * and we may not need that many, so we have to handle this when
-	 * allocating the blocks below. 
+	 * conversion and have to take the header space into account.
 	 */
 	blkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
-
 	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
 						   XFS_ATTR_FORK);
 	if (error)
 		return error;
 
-	/* Start with the attribute data. We'll allocate the rest afterwards. */
-	if (crcs)
-		blkcnt = XFS_B_TO_FSB(mp, args->valuelen);
-
 	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
 	args->rmtblkcnt = blkcnt;
 
@@ -349,31 +464,6 @@ xfs_attr_rmtval_set(
 		       (map.br_startblock != HOLESTARTBLOCK));
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
-		hdrcnt++;
-
-		/*
-		 * If we have enough blocks for the attribute data, calculate
-		 * how many extra blocks we need for headers. We might run
-		 * through this multiple times in the case that the additional
-		 * headers in the blocks needed for the data fragments spills
-		 * into requiring more blocks. e.g. for 512 byte blocks, we'll
-		 * spill for another block every 9 headers we require in this
-		 * loop.
-		 *
-		 * Note that this can result in contiguous allocation of blocks,
-		 * so we don't use all the space we allocate for headers as we
-		 * have one less header for each contiguous allocation that
-		 * occurs in the map/write loop below.
-		 */
-		if (crcs && blkcnt == 0) {
-			int total_len;
-
-			total_len = args->valuelen +
-				    hdrcnt * sizeof(struct xfs_attr3_rmt_hdr);
-			blkcnt = XFS_B_TO_FSB(mp, total_len);
-			blkcnt -= args->rmtblkcnt;
-			args->rmtblkcnt += blkcnt;
-		}
 
 		/*
 		 * Start the next trans in the chain.
@@ -390,17 +480,15 @@ xfs_attr_rmtval_set(
 	 * the INCOMPLETE flag.
 	 */
 	lblkno = args->rmtblkno;
-	valuelen = args->valuelen;
 	blkcnt = args->rmtblkcnt;
+	valuelen = args->valuelen;
 	while (valuelen > 0) {
-		int	byte_cnt;
-		int	hdr_size;
-		int	dblkcnt;
-		char	*buf;
+		struct xfs_buf	*bp;
+		xfs_daddr_t	dblkno;
+		int		dblkcnt;
+
+		ASSERT(blkcnt > 0);
 
-		/*
-		 * Try to remember where we decided to put the value.
-		 */
 		xfs_bmap_init(args->flist, args->firstblock);
 		nmap = 1;
 		error = xfs_bmapi_read(dp, (xfs_fileoff_t)lblkno,
@@ -419,29 +507,17 @@ xfs_attr_rmtval_set(
 		if (!bp)
 			return ENOMEM;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
-		buf = bp->b_addr;
-
-		byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, BBTOB(bp->b_length));
-		byte_cnt = min_t(int, valuelen, byte_cnt);
-		hdr_size = xfs_attr3_rmt_hdr_set(mp, dp->i_ino, offset,
-					     byte_cnt, bp);
-		ASSERT(hdr_size + byte_cnt <= BBTOB(bp->b_length));
 
-		memcpy(buf + hdr_size, src, byte_cnt);
-
-		if (byte_cnt + hdr_size < BBTOB(bp->b_length))
-			xfs_buf_zero(bp, byte_cnt + hdr_size,
-				     BBTOB(bp->b_length) - byte_cnt - hdr_size);
+		xfs_attr_rmtval_copyin(mp, bp, args->dp->i_ino, &offset,
+				       &valuelen, &src);
 
 		error = xfs_bwrite(bp);	/* GROT: NOTE: synchronous write */
 		xfs_buf_relse(bp);
 		if (error)
 			return error;
 
-		src += byte_cnt;
-		valuelen -= byte_cnt;
-		offset += byte_cnt;
 
+		/* roll attribute extent map forwards */
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
 	}
@@ -454,19 +530,17 @@ xfs_attr_rmtval_set(
  * out-of-line buffer that it is stored on.
  */
 int
-xfs_attr_rmtval_remove(xfs_da_args_t *args)
+xfs_attr_rmtval_remove(
+	struct xfs_da_args	*args)
 {
-	xfs_mount_t *mp;
-	xfs_bmbt_irec_t map;
-	xfs_buf_t *bp;
-	xfs_daddr_t dblkno;
-	xfs_dablk_t lblkno;
-	int valuelen, blkcnt, nmap, error, done, committed;
+	struct xfs_mount	*mp = args->dp->i_mount;
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+	int			error;
+	int			done;
 
 	trace_xfs_attr_rmtval_remove(args);
 
-	mp = args->dp->i_mount;
-
 	/*
 	 * Roll through the "value", invalidating the attribute value's blocks.
 	 * Note that args->rmtblkcnt is the minimum number of data blocks we'll
@@ -476,10 +550,13 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 	 * lookups.
 	 */
 	lblkno = args->rmtblkno;
-	valuelen = args->valuelen;
-	blkcnt = xfs_attr3_rmt_blocks(mp, valuelen);
-	while (valuelen > 0) {
-		int dblkcnt;
+	blkcnt = args->rmtblkcnt;
+	while (blkcnt > 0) {
+		struct xfs_bmbt_irec	map;
+		struct xfs_buf		*bp;
+		xfs_daddr_t		dblkno;
+		int			dblkcnt;
+		int			nmap;
 
 		/*
 		 * Try to remember where we decided to put the value.
@@ -506,21 +583,19 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 			bp = NULL;
 		}
 
-		valuelen -= XFS_ATTR3_RMT_BUF_SPACE(mp,
-					XFS_FSB_TO_B(mp, map.br_blockcount));
-
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
-		blkcnt = max(blkcnt, xfs_attr3_rmt_blocks(mp, valuelen));
 	}
 
 	/*
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
-	blkcnt = lblkno - args->rmtblkno;
 	lblkno = args->rmtblkno;
+	blkcnt = args->rmtblkcnt;
 	done = 0;
 	while (!done) {
+		int committed;
+
 		xfs_bmap_init(args->flist, args->firstblock);
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK | XFS_BMAPI_METADATA,
diff --git a/fs/xfs/xfs_attr_remote.h b/fs/xfs/xfs_attr_remote.h
index c7cca60..92a8fd7 100644
--- a/fs/xfs/xfs_attr_remote.h
+++ b/fs/xfs/xfs_attr_remote.h
@@ -20,6 +20,14 @@
 
 #define XFS_ATTR3_RMT_MAGIC	0x5841524d	/* XARM */
 
+/*
+ * There is one of these headers per filesystem block in a remote attribute.
+ * This is done to ensure there is a 1:1 mapping between the attribute value
+ * length and the number of blocks needed to store the attribute. This makes the
+ * verification of a buffer a little more complex, but greatly simplifies the
+ * allocation, reading and writing of these attributes as we don't have to guess
+ * the number of blocks needed to store the attribute data.
+ */
 struct xfs_attr3_rmt_hdr {
 	__be32	rm_magic;
 	__be32	rm_offset;
@@ -39,6 +47,8 @@ struct xfs_attr3_rmt_hdr {
 
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
 
+int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
+
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0d25542..1b2472a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -513,6 +513,7 @@ _xfs_buf_find(
 		xfs_alert(btp->bt_mount,
 			  "%s: Block out of range: block 0x%llx, EOFS 0x%llx ",
 			  __func__, blkno, eofs);
+		WARN_ON(1);
 		return NULL;
 	}
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
