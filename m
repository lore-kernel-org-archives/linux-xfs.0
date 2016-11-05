Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17633 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752905AbcKEATy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:19:54 -0400
Subject: [PATCH 07/41] xfs: getfsmap should fall back to rtbitmap when
 rtrmapbt not present
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:19:50 -0700
Message-ID: <147830519077.2155.542304717948562395.stgit@birch.djwong.org>
In-Reply-To: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
References: <147830514302.2155.3920703176812208304.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Use the realtime bitmap to return freespace information when the
rtrmapbt isn't present.  Note that the rtrmapbt fsmap implementation
will show up later with the rtrmapbt patchset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c   |  133 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h |    2 +
 2 files changed, 135 insertions(+)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 154894e..cd89aa3 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -40,6 +40,7 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
+#include "xfs_rtalloc.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 void
@@ -398,6 +399,29 @@ xfs_getfsmap_rtdev_helper(
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
@@ -496,6 +520,108 @@ xfs_getfsmap_logdev(
 	return xfs_getfsmap_rtdev_helper(&cur, &rmap, info);
 }
 
+/* Execute a getfsmap query against the realtime data device (rtbitmap). */
+STATIC int
+xfs_getfsmap_rtdev_rtbitmap(
+	struct xfs_trans		*tp,
+	struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_fsmap		*dkey_low;
+	struct xfs_fsmap		*dkey_high;
+	xfs_fsblock_t			start_fsb;
+	xfs_fsblock_t			end_fsb;
+	xfs_rtblock_t			rtstart;
+	xfs_rtblock_t			rtend;
+	xfs_rtblock_t			rem;
+	xfs_daddr_t			eofs;
+	int				is_free;
+	int				error = 0;
+
+	dkey_low = keys;
+	dkey_high = keys + 1;
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (dkey_low->fmr_physical >= eofs)
+		return 0;
+	if (dkey_high->fmr_physical >= eofs)
+		dkey_high->fmr_physical = eofs - 1;
+	start_fsb = XFS_BB_TO_FSBT(mp, dkey_low->fmr_physical);
+	end_fsb = XFS_BB_TO_FSB(mp, dkey_high->fmr_physical);
+
+	/* Set up search keys */
+	info->low.rm_startblock = start_fsb;
+	error = xfs_fsmap_owner_to_rmap(dkey_low, &info->low);
+	if (error)
+		return error;
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, dkey_low->fmr_offset);
+	info->low.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->low, dkey_low);
+
+	info->high.rm_startblock = end_fsb;
+	error = xfs_fsmap_owner_to_rmap(dkey_high, &info->high);
+	if (error)
+		return error;
+	info->high.rm_offset = XFS_BB_TO_FSBT(mp, dkey_high->fmr_offset);
+	info->high.rm_blockcount = 0;
+	xfs_getfsmap_set_irec_flags(&info->high, dkey_high);
+
+	info->missing_owner = FMR_OWN_UNKNOWN;
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
+		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
+				&is_free);
+		if (error)
+			goto out_unlock;
+
+		/* How long does the extent go for? */
+		error = xfs_rtfind_forw(mp, tp, rtstart,
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
@@ -741,6 +867,9 @@ xfs_getfsmap_is_valid_device(
 	if (mp->m_logdev_targp &&
 	    fm->fmr_device == new_encode_dev(mp->m_logdev_targp->bt_dev))
 		return true;
+	if (mp->m_rtdev_targp &&
+	    fm->fmr_device == new_encode_dev(mp->m_rtdev_targp->bt_dev))
+		return true;
 	return false;
 }
 
@@ -818,6 +947,10 @@ xfs_getfsmap(
 		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
 		handlers[1].fn = xfs_getfsmap_logdev;
 	}
+	if (mp->m_rtdev_targp) {
+		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
+		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+	}
 
 	xfs_sort(handlers, XFS_GETFSMAP_DEVS, sizeof(struct xfs_getfsmap_dev),
 			xfs_getfsmap_dev_compare);
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 355dd9e..f798a3e 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -126,6 +126,8 @@ int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
+# define xfs_rtcheck_range(...)                         (ENOSYS)
+# define xfs_rtfind_forw(...)                           (ENOSYS)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */

