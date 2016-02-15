Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4474D7CAB
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 281ED304051
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:19:05 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	lYEMwHqX8N422B40 for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:19:02 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MD-IF
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005GT-HR
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/14] xfs: introduce BMAPI_ZERO for allocating zeroed extents
Date: Mon, 15 Feb 2016 17:18:16 +1100
Message-Id: <1455517105-20033-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

Source kernel commit 3fbbbea34bac049c0b5938dc065f7d8ee1ef7e67

To enable DAX to do atomic allocation of zeroed extents, we need to
drive the block zeroing deep into the allocator. Because
xfs_bmapi_write() can return merged extents on allocation that were
only partially allocated (i.e. requested range spans allocated and
hole regions, allocation into the hole was contiguous), we cannot
zero the extent returned from xfs_bmapi_write() as that can
overwrite existing data with zeros.

Hence we have to drive the extent zeroing into the allocation code,
prior to where we merge the extents into the BMBT and return the
resultant map. This means we need to propagate this need down to
the xfs_alloc_vextent() and issue the block zeroing at this point.

While this functionality is being introduced for DAX, there is no
reason why it is specific to DAX - we can per-zero blocks during the
allocation transaction on any type of device. It's just slow (and
usually slower than unwritten allocation and conversion) on
traditional block devices so doesn't tend to get used. We can,
however, hook hardware zeroing optimisations via sb_issue_zeroout()
to this operation, so it may be useful in future and hence the
"allocate zeroed blocks" API needs to be implementation neutral.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/libxfs.h         |  1 -
 libxfs/libxfs_api_defs.h |  1 +
 libxfs/libxfs_io.h       |  2 ++
 libxfs/libxfs_priv.h     |  3 +++
 libxfs/rdwr.c            |  4 +++-
 libxfs/util.c            | 35 +++++++++++++++++++++++++++++++++++
 libxfs/xfs_alloc.c       | 10 +++++++++-
 libxfs/xfs_alloc.h       |  8 +++++---
 libxfs/xfs_bmap.c        | 35 +++++++++++++++++++++++++++++++++--
 libxfs/xfs_bmap.h        | 13 +++++++++++--
 10 files changed, 102 insertions(+), 10 deletions(-)

diff --git a/include/libxfs.h b/include/libxfs.h
index bd51df0..5e8f3d4 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -139,7 +139,6 @@ extern int	libxfs_init (libxfs_init_t *);
 extern void	libxfs_destroy (void);
 extern int	libxfs_device_to_fd (dev_t);
 extern dev_t	libxfs_device_open (char *, int, int, int);
-extern void	libxfs_device_zero(struct xfs_buftarg *, xfs_daddr_t, uint);
 extern void	libxfs_device_close (dev_t);
 extern int	libxfs_device_alignment (void);
 extern void	libxfs_report(FILE *);
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e9fd9c8..3a649e3 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -73,6 +73,7 @@
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_bmbt_get_all		libxfs_bmbt_get_all
 #define xfs_rtfree_extent		libxfs_rtfree_extent
+#define xfs_zero_extent			libxfs_zero_extent
 
 #define xfs_da_brelse			libxfs_da_brelse
 #define xfs_da_hashname			libxfs_da_hashname
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 86b18a0..29ab583 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -212,6 +212,8 @@ extern int	libxfs_writebufr(struct xfs_buf *);
 extern int	libxfs_readbufr(struct xfs_buftarg *, xfs_daddr_t, xfs_buf_t *, int, int);
 extern int	libxfs_readbufr_map(struct xfs_buftarg *, struct xfs_buf *, int);
 
+extern int	libxfs_device_zero(struct xfs_buftarg *, xfs_daddr_t, uint);
+
 extern int libxfs_bhash_size;
 
 #define LIBXFS_BREAD	0x1
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index e2884a2..2c5aba0 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -520,6 +520,9 @@ void xfs_verifier_error(struct xfs_buf *bp);
 /* xfs_rtalloc.c */
 int libxfs_rtfree_extent(struct xfs_trans *, xfs_rtblock_t, xfs_extlen_t);
 
+int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
+                        xfs_off_t count_fsb);
+
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
 
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 2e298c2..3522c26 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -67,7 +67,8 @@
 
 #define IO_BCOMPARE_CHECK
 
-void
+/* XXX: (dgc) Propagate errors, only exit if fail-on-error flag set */
+int
 libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 {
 	xfs_off_t	start_offset, end_offset, offset;
@@ -109,6 +110,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 		offset += bytes;
 	}
 	free(z);
+	return 0;
 }
 
 static void unmount_record(void *p)
diff --git a/libxfs/util.c b/libxfs/util.c
index 90031fd..ee4bf3c 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -17,6 +17,7 @@
  */
 
 #include "libxfs_priv.h"
+#include "libxfs_io.h"
 #include "init.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -33,6 +34,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
+#include "xfs_bit.h"
 
 /*
  * Calculate the worst case log unit reservation for a given superblock
@@ -770,3 +772,36 @@ xfs_log_check_lsn(
 
 	return true;
 }
+
+static struct xfs_buftarg *
+xfs_find_bdev_for_inode(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		return mp->m_rtdev_targp;
+	return mp->m_ddev_targp;
+}
+
+static xfs_daddr_t
+xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
+{
+	if (XFS_IS_REALTIME_INODE(ip))
+		 return XFS_FSB_TO_BB(ip->i_mount, fsb);
+	return XFS_FSB_TO_DADDR(ip->i_mount, (fsb));
+}
+
+
+int
+libxfs_zero_extent(
+	struct xfs_inode *ip,
+	xfs_fsblock_t	start_fsb,
+	xfs_off_t	count_fsb)
+{
+	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
+	ssize_t		size = XFS_FSB_TO_BB(ip->i_mount, count_fsb);
+
+	return libxfs_device_zero(xfs_find_bdev_for_inode(ip), sector, size);
+}
+
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 12d59df..af40270 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2508,7 +2508,7 @@ xfs_alloc_vextent(
 		 * Try near allocation first, then anywhere-in-ag after
 		 * the first a.g. fails.
 		 */
-		if ((args->userdata  == XFS_ALLOC_INITIAL_USER_DATA) &&
+		if ((args->userdata & XFS_ALLOC_INITIAL_USER_DATA) &&
 		    (mp->m_flags & XFS_MOUNT_32BITINODES)) {
 			args->fsbno = XFS_AGB_TO_FSB(mp,
 					((mp->m_agfrotor / rotorstep) %
@@ -2639,6 +2639,14 @@ xfs_alloc_vextent(
 		XFS_AG_CHECK_DADDR(mp, XFS_FSB_TO_DADDR(mp, args->fsbno),
 			args->len);
 #endif
+
+		/* Zero the extent if we were asked to do so */
+		if (args->userdata & XFS_ALLOC_USERDATA_ZERO) {
+			error = xfs_zero_extent(args->ip, args->fsbno, args->len);
+			if (error)
+				goto error0;
+		}
+
 	}
 	xfs_perag_put(args->pag);
 	return 0;
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 071b28b..135eb3d 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -101,6 +101,7 @@ typedef struct xfs_alloc_arg {
 	struct xfs_mount *mp;		/* file system mount point */
 	struct xfs_buf	*agbp;		/* buffer for a.g. freelist header */
 	struct xfs_perag *pag;		/* per-ag struct for this agno */
+	struct xfs_inode *ip;		/* for userdata zeroing method */
 	xfs_fsblock_t	fsbno;		/* file system block number */
 	xfs_agnumber_t	agno;		/* allocation group number */
 	xfs_agblock_t	agbno;		/* allocation group-relative block # */
@@ -120,15 +121,16 @@ typedef struct xfs_alloc_arg {
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
 	char		isfl;		/* set if is freelist blocks - !acctg */
-	char		userdata;	/* set if this is user data */
+	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
 } xfs_alloc_arg_t;
 
 /*
  * Defines for userdata
  */
-#define XFS_ALLOC_USERDATA		1	/* allocation is for user data*/
-#define XFS_ALLOC_INITIAL_USER_DATA	2	/* special case start of file */
+#define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
+#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
+#define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
 
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_mount *mp,
 		struct xfs_perag *pag, xfs_extlen_t need);
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 8e19b50..a38549c 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3795,8 +3795,13 @@ xfs_bmap_btalloc(
 	args.wasdel = ap->wasdel;
 	args.isfl = 0;
 	args.userdata = ap->userdata;
-	if ((error = xfs_alloc_vextent(&args)))
+	if (ap->userdata & XFS_ALLOC_USERDATA_ZERO)
+		args.ip = ap->ip;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
 		return error;
+
 	if (tryagain && args.fsbno == NULLFSBLOCK) {
 		/*
 		 * Exact allocation failed. Now try with alignment
@@ -4295,11 +4300,14 @@ xfs_bmapi_allocate(
 
 	/*
 	 * Indicate if this is the first user data in the file, or just any
-	 * user data.
+	 * user data. And if it is userdata, indicate whether it needs to
+	 * be initialised to zero during allocation.
 	 */
 	if (!(bma->flags & XFS_BMAPI_METADATA)) {
 		bma->userdata = (bma->offset == 0) ?
 			XFS_ALLOC_INITIAL_USER_DATA : XFS_ALLOC_USERDATA;
+		if (bma->flags & XFS_BMAPI_ZERO)
+			bma->userdata |= XFS_ALLOC_USERDATA_ZERO;
 	}
 
 	bma->minlen = (bma->flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
@@ -4414,6 +4422,17 @@ xfs_bmapi_convert_unwritten(
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
 
+	/*
+	 * Before insertion into the bmbt, zero the range being converted
+	 * if required.
+	 */
+	if (flags & XFS_BMAPI_ZERO) {
+		error = xfs_zero_extent(bma->ip, mval->br_startblock,
+					mval->br_blockcount);
+		if (error)
+			return error;
+	}
+
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
 			&bma->cur, mval, bma->firstblock, bma->flist,
 			&tmp_logflags);
@@ -4507,6 +4526,18 @@ xfs_bmapi_write(
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
+	/* zeroing is for currently only for data extents, not metadata */
+	ASSERT((flags & (XFS_BMAPI_METADATA | XFS_BMAPI_ZERO)) !=
+			(XFS_BMAPI_METADATA | XFS_BMAPI_ZERO));
+	/*
+	 * we can allocate unwritten extents or pre-zero allocated blocks,
+	 * but it makes no sense to do both at once. This would result in
+	 * zeroing the unwritten extent twice, but it still being an
+	 * unwritten extent....
+	 */
+	ASSERT((flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO)) !=
+			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
+
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
 	     XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE),
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index d3daf6d..baec27d 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -52,9 +52,9 @@ struct xfs_bmalloca {
 	xfs_extlen_t		minleft; /* amount must be left after alloc */
 	bool			eof;	/* set if allocating past last extent */
 	bool			wasdel;	/* replacing a delayed allocation */
-	bool			userdata;/* set if is user data */
 	bool			aeof;	/* allocated space at eof */
 	bool			conv;	/* overwriting unwritten extents */
+	char			userdata;/* userdata mask */
 	int			flags;
 };
 
@@ -109,6 +109,14 @@ typedef	struct xfs_bmap_free
  */
 #define XFS_BMAPI_CONVERT	0x040
 
+/*
+ * allocate zeroed extents - this requires all newly allocated user data extents
+ * to be initialised to zero. It will be ignored if XFS_BMAPI_METADATA is set.
+ * Use in conjunction with XFS_BMAPI_CONVERT to convert unwritten extents found
+ * during the allocation range to zeroed written extents.
+ */
+#define XFS_BMAPI_ZERO		0x080
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -116,7 +124,8 @@ typedef	struct xfs_bmap_free
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
-	{ XFS_BMAPI_CONVERT,	"CONVERT" }
+	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
+	{ XFS_BMAPI_ZERO,	"ZERO" }
 
 
 static inline int xfs_bmapi_aflag(int w)
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
