Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DC127EE6
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:40:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8936DAC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:44 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ek8dygB2eG9isWQY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:42 -0700 (PDT)
Subject: [PATCH 04/25] xfs: getfsmap should fall back to rtbitmap when
	rtrmapbt not present
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:40:38 -0700
Message-ID: <147216843818.3108.1654337677671309494.stgit@birch.djwong.org>
In-Reply-To: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
References: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |  126 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index eb54884..1c5ce01 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -40,6 +40,7 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
+#include "xfs_rtalloc.h"
 
 /* getfsmap query state */
 struct xfs_getfsmap_info {
@@ -315,6 +316,29 @@ xfs_getfsmap_rtdev_helper(
 	return xfs_getfsmap_helper(mp, info, rec, rec_daddr);
 }
 
+/* Transform a rtbitmap "record" into a fsmap */
+STATIC int
+xfs_getfsmap_rtdev_rtbitmap_helper(
+	struct xfs_mount		*mp,
+	xfs_rtblock_t			start,
+	xfs_rtblock_t			end,
+	void				*priv)
+{
+	struct xfs_getfsmap_info	*info = priv;
+	struct xfs_rmap_irec		irec;
+	xfs_daddr_t			rec_daddr;
+
+	rec_daddr = XFS_FSB_TO_BB(mp, start);
+
+	irec.rm_startblock = start;
+	irec.rm_blockcount = end - start + 1;
+	irec.rm_owner = XFS_RMAP_OWN_NULL;	/* "free" */
+	irec.rm_offset = 0;
+	irec.rm_flags = 0;
+
+	return xfs_getfsmap_helper(mp, info, &irec, rec_daddr);
+}
+
 /* Transform a bnobt irec into a fsmap */
 STATIC int
 xfs_getfsmap_datadev_bnobt_helper(
@@ -407,6 +431,103 @@ xfs_getfsmap_logdev(
 	return xfs_getfsmap_rtdev_helper(&cur, &rmap, info);
 }
 
+/* Execute a getfsmap query against the realtime data device (rtbitmap). */
+STATIC int
+xfs_getfsmap_rtdev_rtbitmap(
+	struct xfs_mount		*mp,
+	struct getfsmap			*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct getfsmap			*lowkey;
+	struct getfsmap			*highkey;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	xfs_rtblock_t			rtstart;
+	xfs_rtblock_t			rtend;
+	xfs_rtblock_t			rem;
+	xfs_daddr_t			eofs;
+	int				is_free;
+	int				error = 0;
+
+	lowkey = keys;
+	highkey = keys + 1;
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (lowkey->fmv_block >= eofs)
+		return 0;
+	if (highkey->fmv_block >= eofs)
+		highkey->fmv_block = eofs - 1;
+	start_fsb = XFS_BB_TO_FSBT(mp, lowkey->fmv_block);
+	end_fsb = XFS_BB_TO_FSB(mp, highkey->fmv_block);
+
+	/* Set up search keys */
+	info->low.rm_startblock = start_fsb;
+	info->low.rm_owner = lowkey->fmv_owner;
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, lowkey->fmv_offset);
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, lowkey);
+
+	info->high.rm_startblock = end_fsb;
+	info->high.rm_owner = highkey->fmv_owner;
+	info->high.rm_offset = XFS_BB_TO_FSBT(mp, highkey->fmv_offset);
+	info->high.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->high, highkey);
+
+	info->missing_owner = FMV_OWN_UNKNOWN;
+
+	trace_xfs_fsmap_low_key(mp, info->dev, info->agno,
+			info->low.rm_startblock,
+			info->low.rm_blockcount,
+			info->low.rm_owner,
+			info->low.rm_offset);
+
+	trace_xfs_fsmap_high_key(mp, info->dev, info->agno,
+			info->high.rm_startblock,
+			info->high.rm_blockcount,
+			info->high.rm_owner,
+			info->high.rm_offset);
+
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+
+	/* Iterate the bitmap, looking for discrepancies. */
+	rtstart = 0;
+	rem = mp->m_sb.sb_rblocks;
+	while (rem) {
+		/* Is the first block free? */
+		error = xfs_rtcheck_range(mp, NULL, rtstart, 1, 1, &rtend,
+				&is_free);
+		if (error)
+			goto out_unlock;
+
+		/* How long does the extent go for? */
+		error = xfs_rtfind_forw(mp, NULL, rtstart,
+				mp->m_sb.sb_rblocks - 1, &rtend);
+		if (error)
+			goto out_unlock;
+
+		if (is_free) {
+			error = xfs_getfsmap_rtdev_rtbitmap_helper(mp,
+					rtstart, rtend, info);
+			if (error)
+				goto out_unlock;
+		}
+
+		rem -= rtend - rtstart + 1;
+		rtstart = rtend + 1;
+	}
+
+out_unlock:
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+
+	/* Report any free space at the end of the rtdev */
+	info->last = true;
+	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, end_fsb, 0, info);
+	if (error)
+		goto err;
+
+err:
+	return error;
+}
+
 /* Execute a getfsmap query against the regular data device. */
 STATIC int
 xfs_getfsmap_datadev(
@@ -699,6 +820,11 @@ xfs_getfsmap(
 		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
 		handlers[1].fn = xfs_getfsmap_logdev;
 	}
+	if (mp->m_rtdev_targp) {
+		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
+		if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+			handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+	}
 
 	xfs_sort(handlers, XFS_GETFSMAP_DEVS, sizeof(struct xfs_getfsmap_dev),
 			xfs_getfsmap_dev_compare);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
