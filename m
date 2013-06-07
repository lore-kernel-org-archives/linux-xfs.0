Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B98527F80
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 07:25:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 98614304077
	for <xfs@oss.sgi.com>; Fri,  7 Jun 2013 05:25:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6gPP8dlnZlm2ns3r for <xfs@oss.sgi.com>;
	Fri, 07 Jun 2013 05:25:27 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkvjG-0005TP-Np
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:14 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkvjG-00031g-KK
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 22:25:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/12] xfs: rework remote attr CRCs
Date: Fri,  7 Jun 2013 22:25:00 +1000
Message-Id: <1370607901-11538-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1370607901-11538-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370607901-11538-1-git-send-email-david@fromorbit.com>
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
 fsr/xfs_fsr.c             |    1 -
 include/libxfs.h          |    1 +
 include/libxlog.h         |    1 -
 include/xfs_attr_remote.h |   10 ++
 libxfs/xfs_attr_leaf.c    |   10 +-
 libxfs/xfs_attr_remote.c  |  387 ++++++++++++++++++++++++++-------------------
 6 files changed, 245 insertions(+), 165 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 66a3570..7e518c1 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -77,7 +77,6 @@ static __int64_t	minimumfree = 2048;
 #define	V_ALL		2
 #define BUFFER_SIZE	(1<<16)
 #define BUFFER_MAX	(1<<24)
-#define min(x, y) ((x) < (y) ? (x) : (y))
 
 static time_t howlong = 7200;		/* default seconds of reorganizing */
 static char *leftofffile = _PATH_FSRLAST; /* where we left off last */
diff --git a/include/libxfs.h b/include/libxfs.h
index 4bb4ad4..f11ad52 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -71,6 +71,7 @@
 #define __round_mask(x, y) ((__typeof__(x))((y)-1))
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
+#define min(a,b)	((a) < (b) ? (a) : (b))
 
 /*
  * Argument structure for libxfs_init().
diff --git a/include/libxlog.h b/include/libxlog.h
index b101a6e..bd71bfe 100644
--- a/include/libxlog.h
+++ b/include/libxlog.h
@@ -74,7 +74,6 @@ typedef union {
 #define XFS_CORRUPTION_ERROR(e,l,mp,m)	((void) 0)
 #define XFS_MOUNT_WAS_CLEAN		0x1
 #define unlikely(x)			(x)
-#define min(a,b)			((a) < (b) ? (a) : (b))
 
 #define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
 #define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
diff --git a/include/xfs_attr_remote.h b/include/xfs_attr_remote.h
index 28f6f10..d087305 100644
--- a/include/xfs_attr_remote.h
+++ b/include/xfs_attr_remote.h
@@ -26,6 +26,14 @@
 
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
@@ -45,6 +53,8 @@ struct xfs_attr3_rmt_hdr {
 
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
 
+int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
+
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 2aac9d9..4e2951b 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1202,7 +1202,7 @@ xfs_attr3_leaf_add_work(
 		name_rmt->valuelen = 0;
 		name_rmt->valueblk = 0;
 		args->rmtblkno = 1;
-		args->rmtblkcnt = XFS_B_TO_FSB(mp, args->valuelen);
+		args->rmtblkcnt = xfs_attr3_rmt_blocks(mp, args->valuelen);
 	}
 	xfs_trans_log_buf(args->trans, bp,
 	     XFS_DA_LOGRANGE(leaf, xfs_attr3_leaf_name(leaf, args->index),
@@ -2144,8 +2144,9 @@ xfs_attr3_leaf_lookup_int(
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
@@ -2196,7 +2197,8 @@ xfs_attr3_leaf_getvalue(
 		ASSERT(memcmp(args->name, name_rmt->name, args->namelen) == 0);
 		valuelen = be32_to_cpu(name_rmt->valuelen);
 		args->rmtblkno = be32_to_cpu(name_rmt->valueblk);
-		args->rmtblkcnt = XFS_B_TO_FSB(args->dp->i_mount, valuelen);
+		args->rmtblkcnt = xfs_attr3_rmt_blocks(args->dp->i_mount,
+						       valuelen);
 		if (args->flags & ATTR_KERNOVAL) {
 			args->valuelen = valuelen;
 			return 0;
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 1424878..0b2ca8c 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -24,7 +24,7 @@
  * Each contiguous block has a header, so it is not just a simple attribute
  * length to FSB conversion.
  */
-static int
+int
 xfs_attr3_rmt_blocks(
 	struct xfs_mount *mp,
 	int		attrlen)
@@ -36,12 +36,43 @@ xfs_attr3_rmt_blocks(
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
@@ -49,7 +80,9 @@ xfs_attr3_rmt_verify(
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
@@ -65,17 +98,40 @@ xfs_attr3_rmt_read_verify(
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
@@ -84,23 +140,39 @@ xfs_attr3_rmt_write_verify(
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
@@ -108,15 +180,16 @@ const struct xfs_buf_ops xfs_attr3_rmt_buf_ops = {
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
@@ -126,36 +199,107 @@ xfs_attr3_rmt_hdr_set(
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
+		byte_cnt = min(*valuelen, byte_cnt);
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
@@ -169,13 +313,12 @@ xfs_attr_rmtval_get(
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
 
@@ -185,7 +328,6 @@ xfs_attr_rmtval_get(
 
 	while (valuelen > 0) {
 		nmap = ATTR_RMTVALUE_MAPSIZE;
-		blkcnt = xfs_attr3_rmt_blocks(mp, valuelen);
 		error = xfs_bmapi_read(args->dp, (xfs_fileoff_t)lblkno,
 				       blkcnt, map, &nmap,
 				       XFS_BMAPI_ATTRFORK);
@@ -194,45 +336,29 @@ xfs_attr_rmtval_get(
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
@@ -250,17 +376,13 @@ xfs_attr_rmtval_set(
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
@@ -269,21 +391,14 @@ xfs_attr_rmtval_set(
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
 
@@ -326,31 +441,6 @@ xfs_attr_rmtval_set(
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
@@ -367,17 +457,15 @@ xfs_attr_rmtval_set(
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
@@ -397,28 +485,16 @@ xfs_attr_rmtval_set(
 			return ENOMEM;
 		bp->b_ops = &xfs_attr3_rmt_buf_ops;
 
-		buf = bp->b_addr;
-		byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, BBTOB(bp->b_length));
-		byte_cnt = min_t(int, valuelen, byte_cnt);
-		hdr_size = xfs_attr3_rmt_hdr_set(mp, dp->i_ino, offset,
-					     byte_cnt, bp);
-		ASSERT(hdr_size + byte_cnt <= BBTOB(bp->b_length));
-
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
@@ -431,32 +507,28 @@ xfs_attr_rmtval_set(
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
-	 * Note that args->rmtblkcnt is the minimum number of data blocks we'll
-	 * see for a CRC enabled remote attribute. Each extent will have a
-	 * header, and so we may have more blocks than we realise here.  If we
-	 * fail to map the blocks correctly, we'll have problems with the buffer
-	 * lookups.
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
@@ -483,21 +555,19 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
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
@@ -530,4 +600,3 @@ xfs_attr_rmtval_remove(xfs_da_args_t *args)
 	}
 	return(0);
 }
-
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
