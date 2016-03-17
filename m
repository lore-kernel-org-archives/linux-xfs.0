Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D75A87CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 09:30:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BFE7AC007
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FCv5MHBJLuUtIYos (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 07:30:40 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 8/9] xfs: thin block device reservation mechanism
Date: Thu, 17 Mar 2016 10:30:36 -0400
Message-Id: <1458225037-24155-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
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
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com

Add block device reservation infrastructure to XFS. This primarily
consists of wrappers around the associated block device functions. This
mechanism provides the ability to reserve, release and provision a set
of blocks in the underlying block device.

The mechanism enables the filesystem to adopt a block reservation model
with the underlying device. In turn, this allows the filesystem to
identify when the underlying device is out of space and propagate an
error (-ENOSPC) gracefully before the device itself must handle the
condition. The latter typically involves a read-only state transition
and thus requires administrator intervention to resolve.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/Makefile    |   1 +
 fs/xfs/xfs_mount.h |   5 +
 fs/xfs/xfs_thin.c  | 273 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_thin.h  |   9 ++
 fs/xfs/xfs_trace.h |  27 ++++++
 5 files changed, 315 insertions(+)
 create mode 100644 fs/xfs/xfs_thin.c
 create mode 100644 fs/xfs/xfs_thin.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index f646391..92ea714 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -88,6 +88,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_super.o \
 				   xfs_symlink.o \
 				   xfs_sysfs.o \
+				   xfs_thin.o \
 				   xfs_trans.o \
 				   xfs_xattr.o \
 				   kmem.o \
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b570984..3696700 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -147,6 +147,11 @@ typedef struct xfs_mount {
 	 * to various other kinds of pain inflicted on the pNFS server.
 	 */
 	__uint32_t		m_generation;
+
+	bool			m_thin_reserve;
+	struct mutex		m_thin_res_lock;
+	uint32_t		m_thin_sectpb;
+	sector_t		m_thin_res;
 } xfs_mount_t;
 
 /*
diff --git a/fs/xfs/xfs_thin.c b/fs/xfs/xfs_thin.c
new file mode 100644
index 0000000..ce6f373
--- /dev/null
+++ b/fs/xfs/xfs_thin.c
@@ -0,0 +1,273 @@
+/*
+ * Copyright (c) 2016 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_inode.h"
+#include "xfs_dir2.h"
+#include "xfs_ialloc.h"
+#include "xfs_alloc.h"
+#include "xfs_rtalloc.h"
+#include "xfs_bmap.h"
+#include "xfs_trans.h"
+#include "xfs_trans_priv.h"
+#include "xfs_log.h"
+#include "xfs_error.h"
+#include "xfs_quota.h"
+#include "xfs_fsops.h"
+#include "xfs_trace.h"
+#include "xfs_icache.h"
+#include "xfs_sysfs.h"
+/* XXX: above copied from xfs_mount.c */
+#include "xfs_thin.h"
+
+/*
+ * Notes/Issues:
+ *
+ * - Reservation support depends on the '-o discard' mount option so freed
+ *   extents are returned to the pool.
+ * - The absolute reservation value API is potentially racy. We can cover our
+ *   own reservations/provisions with a mutex, but a delta reservation API might
+ *   be better.
+ * - Local reservation accounting is not necessarily correct/accurate.
+ *   Reservation leakage has been reproduced, particularly in ENOSPC conditions.
+ *   The discard mechanism to return blocks to dm-thin has not been totally
+ *   reliable either, which means filling, removing and filling an fs causes
+ *   some space to be lost. This can be worked around with fstrim for the time
+ *   being.
+ * - The locking in xfs_mod_fdblocks() is not quite correct/safe. Sleeping from
+ *   invalid context BUG()'s are expected. Needs to be reworked.
+ * - Worst case reservation means each XFS filesystem block is considered a new
+ *   dm block allocation. This translates to a significant amount of space given
+ *   larger dm block sizes. For example, 4k XFS blocks to 64k dm blocks means
+ *   we'll hit ENOSPC sooner and more frequently than typically expected.
+ * - The above also means large fallocate requests are problematic. Need to find
+ *   a workaround for this. Perhaps a reduced reservation is safe for known
+ *   contiguous extents? E.g., xfs_bmapi_write() w/ nimaps = 1;
+ * - The xfs_mod_fdblocks() implementation means the XFS reserve pool blocks are
+ *   also reserved from the thin pool. XFS defaults to 8192 reserve pool blocks
+ *   in most cases, which translates to 512MB of reserved space. This can be
+ *   tuned with: 'xfs_io -xc "resblks <blks>" <mnt>'. Note that insufficient
+ *   reserves will result in errors in unexpected areas of code (e.g., page
+ *   discards on writeback, inode unlinked list removal failures, etc.).
+ * - The existing xfs_reserve_blocks() implementation is flaky and does not
+ *   correctly reserve in the event of xfs_mod_fdblocks() failure. This will
+ *   likely require some fixes independent of this feature. It also may depend
+ *   on some kind of (currently undefined) "query available reservation" or
+ *   "perform partial reservation" API to support partial XFS reserved blocks
+ *   allocation.
+ */
+
+/*
+ * Convert an fsb count to a sector reservation.
+ */
+static inline sector_t
+XFS_FSB_TO_SECT(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsb)
+{
+	sector_t		bb;
+
+	bb = fsb * mp->m_thin_sectpb;
+	return bb;
+}
+
+/*
+ * Reserve blocks from the underlying block device.
+ */
+int
+xfs_thin_reserve(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsb)
+{
+	int			error;
+	sector_t		bb;
+
+	bb = XFS_FSB_TO_SECT(mp, fsb);
+
+	mutex_lock(&mp->m_thin_res_lock);
+
+	error = blk_reserve_space(mp->m_ddev_targp->bt_bdev,
+				  mp->m_thin_res + bb);
+	if (error) {
+		if (error == -ENOSPC)
+			trace_xfs_thin_reserve_enospc(mp, mp->m_thin_res, bb);
+		goto out;
+	}
+
+	trace_xfs_thin_reserve(mp, mp->m_thin_res, bb);
+	mp->m_thin_res += bb;
+
+out:
+	mutex_unlock(&mp->m_thin_res_lock);
+	return error;
+}
+
+static int
+__xfs_thin_unreserve(
+	struct xfs_mount	*mp,
+	sector_t		bb)
+{
+	int			error;
+
+	if (bb > mp->m_thin_res) {
+		WARN(1, "unres (%lu) exceeds current res (%lu)", bb,
+			mp->m_thin_res);
+		bb = mp->m_thin_res;
+	}
+
+	error = blk_reserve_space(mp->m_ddev_targp->bt_bdev,
+				  mp->m_thin_res - bb);
+	if (error)
+		return error;;
+
+	trace_xfs_thin_unreserve(mp, mp->m_thin_res, bb);
+	mp->m_thin_res -= bb;
+
+	return error;
+}
+
+/*
+ * Release a reservation back to the block device.
+ */
+int
+xfs_thin_unreserve(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		fsb)
+{
+	int			error;
+	sector_t		bb;
+
+	bb = XFS_FSB_TO_SECT(mp, fsb);
+
+	mutex_lock(&mp->m_thin_res_lock);
+	error = __xfs_thin_unreserve(mp, bb);
+	mutex_unlock(&mp->m_thin_res_lock);
+
+	return error;
+}
+
+/*
+ * Given a recently allocated extent, ask the block device to provision the
+ * underlying space.
+ */
+int
+xfs_thin_provision(
+	struct xfs_mount	*mp,
+	xfs_fsblock_t		offset,
+	xfs_fsblock_t		len)
+{
+	sector_t		bbres;
+	sector_t		bbstart, bblen;
+	int			count;
+	int			error;
+
+	bbstart = XFS_FSB_TO_DADDR(mp, offset);
+	bbstart = round_down(bbstart, mp->m_thin_sectpb);
+	bblen = XFS_FSB_TO_BB(mp, len);
+	bblen = round_up(bblen, mp->m_thin_sectpb);
+
+	bbres = XFS_FSB_TO_SECT(mp, len);
+
+	mutex_lock(&mp->m_thin_res_lock);
+
+	WARN_ON(bblen > mp->m_thin_res);
+
+	/*
+	 * XXX: alloc count here is kind of a hack. Need to find a local
+	 * mechanism. Pass res to blk_provision_space?
+	 */
+	count = blk_provision_space(mp->m_ddev_targp->bt_bdev, bbstart, bblen);
+	if (count < 0) {
+		error = count;
+		goto out;
+	}
+
+	trace_xfs_thin_provision(mp, count, bbres);
+
+	/*
+	 * Update the local reservation based on the blocks that were actually
+	 * allocated and release the rest of the unused reservation.
+	 */
+	mp->m_thin_res -= count;
+	bbres -= count;
+	error = __xfs_thin_unreserve(mp, bbres);
+out:
+	mutex_unlock(&mp->m_thin_res_lock);
+	return error;
+}
+
+int
+xfs_thin_init(
+	struct xfs_mount	*mp)
+{
+	sector_t		res1 = 0, res2 = 0;
+	int			error = 0;
+	unsigned int		io_opt;
+
+	mp->m_thin_reserve = false;
+
+	if (!(mp->m_flags & XFS_MOUNT_DISCARD))
+		goto out;
+
+	mutex_init(&mp->m_thin_res_lock);
+
+	/* use optimal I/O size as dm-thin block size */
+	io_opt = bdev_io_opt(mp->m_super->s_bdev);
+	if ((io_opt % BBSIZE) || (io_opt < mp->m_sb.sb_blocksize))
+		goto out;
+	mp->m_thin_sectpb = io_opt / BBSIZE;
+
+	/*
+	 * Run some test calls to determine whether the block device has
+	 * support. Note: res is in 512b sector units.
+	 */
+	error = xfs_thin_reserve(mp, 1);
+	if (error)
+		goto out;
+
+	error = blk_get_reserved_space(mp->m_ddev_targp->bt_bdev, &res1);
+	if (error)
+		goto out;
+
+	error = xfs_thin_unreserve(mp, 1);
+	if (error)
+		goto out;
+
+	error = blk_get_reserved_space(mp->m_ddev_targp->bt_bdev, &res2);
+	if (error)
+		goto out;
+
+	ASSERT(res1 >= 1 && res2 == 0);
+	mp->m_thin_reserve = true;
+out:
+	xfs_notice(mp, "Thin pool reservation %s", mp->m_thin_reserve ?
+							"enabled" : "disabled");
+	if (mp->m_thin_reserve)
+		xfs_notice(mp, "Thin reserve blocksize: %u sectors",
+			   mp->m_thin_sectpb);
+	return 0;
+}
diff --git a/fs/xfs/xfs_thin.h b/fs/xfs/xfs_thin.h
new file mode 100644
index 0000000..ce5a019
--- /dev/null
+++ b/fs/xfs/xfs_thin.h
@@ -0,0 +1,9 @@
+#ifndef __XFS_THIN_H__
+#define __XFS_THIN_H__
+
+int xfs_thin_init(struct xfs_mount *);
+int xfs_thin_reserve(struct xfs_mount *, xfs_fsblock_t);
+int xfs_thin_unreserve(struct xfs_mount *, xfs_fsblock_t);
+int xfs_thin_provision(struct xfs_mount *, xfs_fsblock_t, xfs_fsblock_t);
+
+#endif	/* __XFS_THIN_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 391d797..01b0702 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2185,6 +2185,33 @@ DEFINE_DISCARD_EVENT(xfs_discard_toosmall);
 DEFINE_DISCARD_EVENT(xfs_discard_exclude);
 DEFINE_DISCARD_EVENT(xfs_discard_busy);
 
+DECLARE_EVENT_CLASS(xfs_thin_class,
+	TP_PROTO(struct xfs_mount *mp, sector_t total, sector_t res),
+	TP_ARGS(mp, total, res),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(sector_t, total)
+		__field(sector_t, res)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->total = total;
+		__entry->res = res;
+	),
+	TP_printk("dev %d:%d total %lu res %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->total,
+		  __entry->res)
+)
+
+#define DEFINE_THIN_EVENT(name) \
+DEFINE_EVENT(xfs_thin_class, name, \
+	TP_PROTO(struct xfs_mount *mp, sector_t total, sector_t res), \
+	TP_ARGS(mp, total, res))
+DEFINE_THIN_EVENT(xfs_thin_reserve);
+DEFINE_THIN_EVENT(xfs_thin_reserve_enospc);
+DEFINE_THIN_EVENT(xfs_thin_unreserve);
+DEFINE_THIN_EVENT(xfs_thin_provision);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
