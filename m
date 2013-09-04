Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1879829E22
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:21:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 08B0F304039
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:21:40 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	MLOys14qKw09LNGQ for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:21:37 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLDA-0007dl-Fg
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLDA-0003v5-Dw
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 46/55] xfs: Add xfs_log_rlimit.c
Date: Thu,  5 Sep 2013 08:05:50 +1000
Message-Id: <1378332359-14737-47-git-send-email-david@fromorbit.com>
In-Reply-To: <1378332359-14737-1-git-send-email-david@fromorbit.com>
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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

From: Jie Liu <jeff.liu@oracle.com>

Add source files for xfs_log_rlimit.c The new file is used for log
size calculations and validation shared with userspace.

[dchinner: xfs_log_calc_max_attrsetm_res() does not modify the
tr_attrsetm reservation, just calculates the maximum. ]

[dchinner: rework loop in xfs_log_get_max_trans_res() ]

[dchinner: implement xfs_log_calc_unit_res() in util.c to give mkfs
a worse case calculation of the log size needed. ]

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_fs.h         |   4 +-
 include/xfs_log_format.h |  11 +++-
 libxfs/Makefile          |  15 ++++--
 libxfs/util.c            | 107 +++++++++++++++++++++++++++++++++++++
 libxfs/xfs.h             |   8 +++
 libxfs/xfs_log_rlimit.c  | 136 +++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/maxtrres.c          |  66 +++++++----------------
 mkfs/xfs_mkfs.c          | 105 ++++++++++++++++++++----------------
 mkfs/xfs_mkfs.h          |   6 +--
 9 files changed, 356 insertions(+), 102 deletions(-)
 create mode 100644 libxfs/xfs_log_rlimit.c

diff --git a/include/xfs_fs.h b/include/xfs_fs.h
index 74b24b2..53e33c2 100644
--- a/include/xfs_fs.h
+++ b/include/xfs_fs.h
@@ -240,7 +240,9 @@ typedef struct xfs_fsop_resblks {
 
 
 /*
- * Minimum and maximum sizes need for growth checks
+ * Minimum and maximum sizes need for growth checks.
+ *
+ * Block counts are in units of filesystem blocks, not basic blocks.
  */
 #define XFS_MIN_AG_BLOCKS	64
 #define XFS_MIN_LOG_BLOCKS	512ULL
diff --git a/include/xfs_log_format.h b/include/xfs_log_format.h
index f57975d..31e3a06 100644
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -18,6 +18,9 @@
 #ifndef	__XFS_LOG_FORMAT_H__
 #define __XFS_LOG_FORMAT_H__
 
+struct xfs_mount;
+struct xfs_trans_res;
+
 /*
  * On-disk Log Format definitions.
  *
@@ -49,6 +52,9 @@ typedef __uint32_t xlog_tid_t;
 
 #define XLOG_HEADER_SIZE	512
 
+/* Minimum number of transactions that must fit in the log (defined by mkfs) */
+#define XFS_MIN_LOG_FACTOR	3
+
 #define XLOG_REC_SHIFT(log) \
 	BTOBB(1 << (xfs_sb_version_haslogv2(&log->l_mp->m_sb) ? \
 	 XLOG_MAX_RECORD_BSHIFT : XLOG_BIG_RECORD_BSHIFT))
@@ -133,7 +139,6 @@ typedef struct xlog_op_header {
 	__u16	   oh_res2;	/* 32 bit align			:  2 b */
 } xlog_op_header_t;
 
-
 /* valid values for h_fmt */
 #define XLOG_FMT_UNKNOWN  0
 #define XLOG_FMT_LINUX_LE 1
@@ -840,4 +845,8 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
+int	xfs_log_calc_minimum_size(struct xfs_mount *);
+
+
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 5608020..f0cbae3 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -17,14 +17,23 @@ CFILES = cache.c \
 	xfs_alloc.c \
 	xfs_alloc_btree.c \
 	xfs_attr.c \
+	xfs_attr_leaf.c \
 	xfs_attr_remote.c \
+	xfs_bmap.c \
+	xfs_bmap_btree.c \
 	xfs_btree.c \
+	xfs_da_btree.c \
+	xfs_dir2.c \
+	xfs_dir2_block.c \
+	xfs_dir2_data.c \
+	xfs_dir2_leaf.c \
+	xfs_dir2_node.c \
+	xfs_dir2_sf.c \
 	xfs_ialloc.c \
 	xfs_inode_buf.c \
 	xfs_inode_fork.c \
-	xfs_ialloc_btree.c xfs_bmap_btree.c xfs_da_btree.c \
-	xfs_dir2.c xfs_dir2_leaf.c xfs_attr_leaf.c xfs_dir2_block.c \
-	xfs_dir2_node.c xfs_dir2_data.c xfs_dir2_sf.c xfs_bmap.c \
+	xfs_ialloc_btree.c \
+	xfs_log_rlimit.c \
 	xfs_rtalloc.c \
 	xfs_sb.c \
 	xfs_symlink_remote.c \
diff --git a/libxfs/util.c b/libxfs/util.c
index d7459e0..8109ab3 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -22,6 +22,113 @@
 #include <stdarg.h>
 
 /*
+ * Calculate the worst case log unit reservation for a given superblock
+ * configuration. Copied and munged from the kernel code, and assumes a
+ * worse case header usage (maximum log buffer sizes)
+ */
+int
+xfs_log_calc_unit_res(
+	struct xfs_mount	*mp,
+	int			unit_bytes)
+{
+	int			iclog_space;
+	int			iclog_header_size;
+	int			iclog_size;
+	uint			num_headers;
+
+	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
+		iclog_size = XLOG_MAX_RECORD_BSIZE;
+		iclog_header_size = BBTOB(iclog_size / XLOG_HEADER_CYCLE_SIZE);
+	} else {
+		iclog_size = XLOG_BIG_RECORD_BSIZE;
+		iclog_header_size = BBSIZE;
+	}
+
+	/*
+	 * Permanent reservations have up to 'cnt'-1 active log operations
+	 * in the log.  A unit in this case is the amount of space for one
+	 * of these log operations.  Normal reservations have a cnt of 1
+	 * and their unit amount is the total amount of space required.
+	 *
+	 * The following lines of code account for non-transaction data
+	 * which occupy space in the on-disk log.
+	 *
+	 * Normal form of a transaction is:
+	 * <oph><trans-hdr><start-oph><reg1-oph><reg1><reg2-oph>...<commit-oph>
+	 * and then there are LR hdrs, split-recs and roundoff at end of syncs.
+	 *
+	 * We need to account for all the leadup data and trailer data
+	 * around the transaction data.
+	 * And then we need to account for the worst case in terms of using
+	 * more space.
+	 * The worst case will happen if:
+	 * - the placement of the transaction happens to be such that the
+	 *   roundoff is at its maximum
+	 * - the transaction data is synced before the commit record is synced
+	 *   i.e. <transaction-data><roundoff> | <commit-rec><roundoff>
+	 *   Therefore the commit record is in its own Log Record.
+	 *   This can happen as the commit record is called with its
+	 *   own region to xlog_write().
+	 *   This then means that in the worst case, roundoff can happen for
+	 *   the commit-rec as well.
+	 *   The commit-rec is smaller than padding in this scenario and so it is
+	 *   not added separately.
+	 */
+
+	/* for trans header */
+	unit_bytes += sizeof(xlog_op_header_t);
+	unit_bytes += sizeof(xfs_trans_header_t);
+
+	/* for start-rec */
+	unit_bytes += sizeof(xlog_op_header_t);
+
+	/*
+	 * for LR headers - the space for data in an iclog is the size minus
+	 * the space used for the headers. If we use the iclog size, then we
+	 * undercalculate the number of headers required.
+	 *
+	 * Furthermore - the addition of op headers for split-recs might
+	 * increase the space required enough to require more log and op
+	 * headers, so take that into account too.
+	 *
+	 * IMPORTANT: This reservation makes the assumption that if this
+	 * transaction is the first in an iclog and hence has the LR headers
+	 * accounted to it, then the remaining space in the iclog is
+	 * exclusively for this transaction.  i.e. if the transaction is larger
+	 * than the iclog, it will be the only thing in that iclog.
+	 * Fundamentally, this means we must pass the entire log vector to
+	 * xlog_write to guarantee this.
+	 */
+	iclog_space = iclog_size - iclog_header_size;
+	num_headers = howmany(unit_bytes, iclog_space);
+
+	/* for split-recs - ophdrs added when data split over LRs */
+	unit_bytes += sizeof(xlog_op_header_t) * num_headers;
+
+	/* add extra header reservations if we overrun */
+	while (!num_headers ||
+	       howmany(unit_bytes, iclog_space) > num_headers) {
+		unit_bytes += sizeof(xlog_op_header_t);
+		num_headers++;
+	}
+	unit_bytes += iclog_header_size * num_headers;
+
+	/* for commit-rec LR header - note: padding will subsume the ophdr */
+	unit_bytes += iclog_header_size;
+
+	/* for roundoff padding for transaction data and one for commit record */
+	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1) {
+		/* log su roundoff */
+		unit_bytes += 2 * mp->m_sb.sb_logsunit;
+	} else {
+		/* BB roundoff */
+		unit_bytes += 2 * BBSIZE;
+        }
+
+	return unit_bytes;
+}
+
+/*
  * Change the requested timestamp in the given inode.
  *
  * This was once shared with the kernel, but has diverged to the point
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 0ab5f21..31acf1b 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -208,6 +208,14 @@ roundup_pow_of_two(uint v)
 	return 0;
 }
 
+static inline __uint64_t
+roundup_64(__uint64_t x, __uint32_t y)
+{
+	x += y - 1;
+	do_div(x, y);
+	return x * y;
+}
+
 /* buffer management */
 #define XFS_BUF_LOCK			0
 #define XFS_BUF_TRYLOCK			0
diff --git a/libxfs/xfs_log_rlimit.c b/libxfs/xfs_log_rlimit.c
new file mode 100644
index 0000000..f52beed
--- /dev/null
+++ b/libxfs/xfs_log_rlimit.c
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2013 Jie Liu.
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
+#include <xfs.h>
+
+/*
+ * Calculate the maximum length in bytes that would be required for a local
+ * attribute value as large attributes out of line are not logged.
+ */
+STATIC int
+xfs_log_calc_max_attrsetm_res(
+	struct xfs_mount	*mp)
+{
+	int			size;
+	int			nblks;
+
+	size = xfs_attr_leaf_entsize_local_max(mp->m_sb.sb_blocksize) -
+	       MAXNAMELEN - 1;
+	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
+	nblks += XFS_B_TO_FSB(mp, size);
+	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
+
+	return  M_RES(mp)->tr_attrsetm.tr_logres +
+		M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
+}
+
+/*
+ * Iterate over the log space reservation table to figure out and return
+ * the maximum one in terms of the pre-calculated values which were done
+ * at mount time.
+ */
+STATIC void
+xfs_log_get_max_trans_res(
+	struct xfs_mount	*mp,
+	struct xfs_trans_res	*max_resp)
+{
+	struct xfs_trans_res	*resp;
+	struct xfs_trans_res	*end_resp;
+	int			log_space = 0;
+	int			attr_space;
+
+	attr_space = xfs_log_calc_max_attrsetm_res(mp);
+
+	resp = (struct xfs_trans_res *)M_RES(mp);
+	end_resp = (struct xfs_trans_res *)(M_RES(mp) + 1);
+	for (; resp < end_resp; resp++) {
+		int		tmp = resp->tr_logcount > 1 ?
+				      resp->tr_logres * resp->tr_logcount :
+				      resp->tr_logres;
+		if (log_space < tmp) {
+			log_space = tmp;
+			*max_resp = *resp;		/* struct copy */
+		}
+	}
+
+	if (attr_space > log_space) {
+		*max_resp = M_RES(mp)->tr_attrsetm;	/* struct copy */
+		max_resp->tr_logres = attr_space;
+	}
+}
+
+/*
+ * Calculate the minimum valid log size for the given superblock configuration.
+ * Used to calculate the minimum log size at mkfs time, and to determine if
+ * the log is large enough or not at mount time. Returns the minimum size in
+ * filesystem block size units.
+ */
+int
+xfs_log_calc_minimum_size(
+	struct xfs_mount	*mp)
+{
+	struct xfs_trans_res	tres = {0};
+	int			max_logres;
+	int			min_logblks = 0;
+	int			lsunit = 0;
+
+	xfs_log_get_max_trans_res(mp, &tres);
+
+	max_logres = xfs_log_calc_unit_res(mp, tres.tr_logres);
+	if (tres.tr_logcount > 1)
+		max_logres *= tres.tr_logcount;
+
+	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
+		lsunit = BTOBB(mp->m_sb.sb_logsunit);
+
+	/*
+	 * Two factors should be taken into account for calculating the minimum
+	 * log space.
+	 * 1) The fundamental limitation is that no single transaction can be
+	 *    larger than half size of the log.
+	 *
+	 *    From mkfs.xfs, this is considered by the XFS_MIN_LOG_FACTOR
+	 *    define, which is set to 3. That means we can definitely fit
+	 *    maximally sized 2 transactions in the log. We'll use this same
+	 *    value here.
+	 *
+	 * 2) If the lsunit option is specified, a transaction requires 2 LSU
+	 *    for the reservation because there are two log writes that can
+	 *    require padding - the transaction data and the commit record which
+	 *    are written separately and both can require padding to the LSU.
+	 *    Consider that we can have an active CIL reservation holding 2*LSU,
+	 *    but the CIL is not over a push threshold, in this case, if we
+	 *    don't have enough log space for at one new transaction, which
+	 *    includes another 2*LSU in the reservation, we will run into dead
+	 *    loop situation in log space grant procedure. i.e.
+	 *    xlog_grant_head_wait().
+	 *
+	 *    Hence the log size needs to be able to contain two maximally sized
+	 *    and padded transactions, which is (2 * (2 * LSU + maxlres)).
+	 *
+	 * Also, the log size should be a multiple of the log stripe unit, round
+	 * it up to lsunit boundary if lsunit is specified.
+	 */
+	if (lsunit) {
+		min_logblks = roundup_64(BTOBB(max_logres), lsunit) +
+			      2 * lsunit;
+	} else
+		min_logblks = BTOBB(max_logres) + 2 * BBSIZE;
+	min_logblks *= XFS_MIN_LOG_FACTOR;
+
+	return XFS_BB_TO_FSB(mp, min_logblks);
+}
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index 59cdcfd..feeab9c 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -27,46 +27,6 @@
 #include <xfs/libxfs.h>
 #include "xfs_mkfs.h"
 
-static void
-max_attrsetm_trans_res_adjust(
-	xfs_mount_t			*mp)
-{
-	int				local;
-	int				size;
-	int				nblks;
-	int				res;
-
-	/*
-	 * Determine space the maximal sized attribute will use,
-	 * to calculate the largest reservation size needed.
-	 */
-	size = libxfs_attr_leaf_newentsize(MAXNAMELEN, 64 * 1024,
-						mp->m_sb.sb_blocksize, &local);
-	ASSERT(!local);
-	nblks = XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK);
-	nblks += XFS_B_TO_FSB(mp, size);
-	nblks += XFS_NEXTENTADD_SPACE_RES(mp, size, XFS_ATTR_FORK);
-	res = M_RES(mp)->tr_attrsetm.tr_logres +
-	      M_RES(mp)->tr_attrsetrt.tr_logres * nblks;
-	M_RES(mp)->tr_attrsetm.tr_logres = res;
-}
-
-static int
-max_trans_res_by_mount(
-	struct xfs_mount	*mp)
-{
-	struct xfs_trans_resv	*tr = &mp->m_resv;
-	struct xfs_trans_res	*p;
-	struct xfs_trans_res	rval = {0};
-
-	for (p = (struct xfs_trans_res *)tr;
-	     p < (struct xfs_trans_res *)(tr + 1); p++) {
-		if (p->tr_logres > rval.tr_logres)
-			rval = *p;
-	}
-	return rval.tr_logres;
-}
-
 int
 max_trans_res(
 	int		crcs_enabled,
@@ -74,11 +34,13 @@ max_trans_res(
 	int		sectorlog,
 	int		blocklog,
 	int		inodelog,
-	int		dirblocklog)
+	int		dirblocklog,
+	int		logversion,
+	int		log_sunit)
 {
 	xfs_sb_t	*sbp;
 	xfs_mount_t	mount;
-	int		maxres, maxfsb;
+	int		maxfsb;
 
 	memset(&mount, 0, sizeof(mount));
 	sbp = &mount.m_sb;
@@ -93,19 +55,27 @@ max_trans_res(
 	sbp->sb_inodesize = 1 << inodelog;
 	sbp->sb_inopblock = 1 << (blocklog - inodelog);
 	sbp->sb_dirblklog = dirblocklog - blocklog;
+
+	if (log_sunit > 0) {
+		log_sunit <<= blocklog;
+		logversion = 2;
+	} else
+		log_sunit = 1;
+	sbp->sb_logsunit = log_sunit;
+
 	sbp->sb_versionnum =
 			(crcs_enabled ? XFS_SB_VERSION_5 : XFS_SB_VERSION_4) |
-			(dirversion == 2 ? XFS_SB_VERSION_DIRV2BIT : 0);
+			(dirversion == 2 ? XFS_SB_VERSION_DIRV2BIT : 0) |
+			(logversion > 1 ? XFS_SB_VERSION_LOGV2BIT : 0);
 
 	libxfs_mount(&mount, sbp, 0,0,0,0);
-	max_attrsetm_trans_res_adjust(&mount);
-	maxres = max_trans_res_by_mount(&mount);
-	maxfsb = XFS_B_TO_FSB(&mount, maxres);
+	maxfsb = xfs_log_calc_minimum_size(&mount);
 	libxfs_umount(&mount);
 
 #if 0
-	printf("#define\tMAXTRRES_S%d_B%d_I%d_D%d_V%d\t%lld\n",
-		sectorlog, blocklog, inodelog, dirblocklog, dirversion, maxfsb);
+	printf("#define\tMAXTRRES_S%d_B%d_I%d_D%d_V%d_LSU%d\t%d\n",
+		sectorlog, blocklog, inodelog, dirblocklog, dirversion,
+		log_sunit, maxfsb);
 #endif
 
 	return maxfsb;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6e243ab..896351b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -922,7 +922,6 @@ main(
 	int			lssflag;
 	int			lsu;
 	int			lsunit;
-	int			max_tr_res;
 	int			min_logblocks;
 	xfs_mount_t		*mp;
 	xfs_mount_t		mbuf;
@@ -2111,50 +2110,6 @@ reported by the device (%u).\n"),
 			sectorsize, xi.rtbsize);
 	}
 
-	max_tr_res = max_trans_res(crcs_enabled, dirversion,
-				   sectorlog, blocklog, inodelog, dirblocklog);
-	ASSERT(max_tr_res);
-	min_logblocks = max_tr_res * XFS_MIN_LOG_FACTOR;
-	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
-	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
-		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
-	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
-		fprintf(stderr,
-_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
-			logsize, (long long)DTOBT(xi.logBBsize));
-		usage();
-	} else if (!logsize && xi.logBBsize > 0) {
-		logblocks = DTOBT(xi.logBBsize);
-	} else if (logsize && !xi.logdev && !loginternal) {
-		fprintf(stderr,
-			_("size specified for non-existent log subvolume\n"));
-		usage();
-	} else if (loginternal && logsize && logblocks >= dblocks) {
-		fprintf(stderr, _("size %lld too large for internal log\n"),
-			(long long)logblocks);
-		usage();
-	} else if (!loginternal && !xi.logdev) {
-		logblocks = 0;
-	} else if (loginternal && !logsize) {
-		/*
-		 * With a 2GB max log size, default to maximum size
-		 * at 4TB. This keeps the same ratio from the older
-		 * max log size of 128M at 256GB fs size. IOWs,
-		 * the ratio of fs size to log size is 2048:1.
-		 */
-		logblocks = (dblocks << blocklog) / 2048;
-		logblocks = logblocks >> blocklog;
-		logblocks = MAX(min_logblocks, logblocks);
-		logblocks = MAX(logblocks,
-				MAX(XFS_DFL_LOG_SIZE,
-					max_tr_res * XFS_DFL_LOG_FACTOR));
-		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
-		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
-			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
-		}
-	}
-	validate_log_size(logblocks, blocklog, min_logblocks);
-
 	if (rtsize && xi.rtsize > 0 && rtblocks > DTOBT(xi.rtsize)) {
 		fprintf(stderr,
 			_("size %s specified for rt subvolume is too large, "
@@ -2363,6 +2318,60 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		fprintf(stderr, _("log stripe unit adjusted to 32KiB\n"));
 	}
 
+	min_logblocks = max_trans_res(crcs_enabled, dirversion,
+				   sectorlog, blocklog, inodelog, dirblocklog,
+				   logversion, lsunit);
+	ASSERT(min_logblocks);
+	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
+	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
+		min_logblocks = MAX(min_logblocks, XFS_MIN_LOG_BYTES>>blocklog);
+	if (logsize && xi.logBBsize > 0 && logblocks > DTOBT(xi.logBBsize)) {
+		fprintf(stderr,
+_("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
+			logsize, (long long)DTOBT(xi.logBBsize));
+		usage();
+	} else if (!logsize && xi.logBBsize > 0) {
+		logblocks = DTOBT(xi.logBBsize);
+	} else if (logsize && !xi.logdev && !loginternal) {
+		fprintf(stderr,
+			_("size specified for non-existent log subvolume\n"));
+		usage();
+	} else if (loginternal && logsize && logblocks >= dblocks) {
+		fprintf(stderr, _("size %lld too large for internal log\n"),
+			(long long)logblocks);
+		usage();
+	} else if (!loginternal && !xi.logdev) {
+		logblocks = 0;
+	} else if (loginternal && !logsize) {
+		/*
+		 * With a 2GB max log size, default to maximum size
+		 * at 4TB. This keeps the same ratio from the older
+		 * max log size of 128M at 256GB fs size. IOWs,
+		 * the ratio of fs size to log size is 2048:1.
+		 */
+		logblocks = (dblocks << blocklog) / 2048;
+		logblocks = logblocks >> blocklog;
+		logblocks = MAX(min_logblocks, logblocks);
+
+		/*
+		 * If the default log size doesn't fit in the AG size, use the
+		 * minimum log size instead. This ensures small filesystems
+		 * don't use excessive amounts of space for the log.
+		 */
+		if (min_logblocks * XFS_DFL_LOG_FACTOR >= agsize) {
+			logblocks = min_logblocks;
+		} else {
+			logblocks = MAX(logblocks,
+				MAX(XFS_DFL_LOG_SIZE,
+					min_logblocks * XFS_DFL_LOG_FACTOR));
+		}
+		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
+		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
+			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
+		}
+	}
+	validate_log_size(logblocks, blocklog, min_logblocks);
+
 	protostring = setup_proto(protofile);
 	bsize = 1 << (blocklog - BBSHIFT);
 	mp = &mbuf;
@@ -2371,6 +2380,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	sbp->sb_blocklog = (__uint8_t)blocklog;
 	sbp->sb_sectlog = (__uint8_t)sectorlog;
 	sbp->sb_agblklog = (__uint8_t)libxfs_log2_roundup((unsigned int)agsize);
+	sbp->sb_agblocks = (xfs_agblock_t)agsize;
 	mp->m_blkbb_log = sbp->sb_blocklog - BBSHIFT;
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 
@@ -2382,6 +2392,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		if (!logsize) {
 			logblocks = MIN(logblocks,
 					XFS_ALLOC_AG_MAX_USABLE(mp));
+
+			/* revalidate the log size is valid if we changed it */
+			validate_log_size(logblocks, blocklog, min_logblocks);
 		}
 		if (logblocks > agsize - XFS_PREALLOC_BLOCKS(mp)) {
 			fprintf(stderr,
@@ -2389,6 +2402,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				(long long)logblocks);
 			usage();
 		}
+
 		if (laflag) {
 			if (logagno >= agcount) {
 				fprintf(stderr,
@@ -2457,7 +2471,6 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	sbp->sb_logstart = logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
 	sbp->sb_rextsize = rtextblocks;
-	sbp->sb_agblocks = (xfs_agblock_t)agsize;
 	sbp->sb_agcount = (xfs_agnumber_t)agcount;
 	sbp->sb_rbmblocks = nbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)logblocks;
diff --git a/mkfs/xfs_mkfs.h b/mkfs/xfs_mkfs.h
index d10e444..1393feb 100644
--- a/mkfs/xfs_mkfs.h
+++ b/mkfs/xfs_mkfs.h
@@ -54,8 +54,7 @@
 #define	XFS_MIN_REC_DIRSIZE	12		/* 4096 byte dirblocks (V2) */
 #define	XFS_DFL_DIR_VERSION	2		/* default directory version */
 #define	XFS_DFL_LOG_SIZE	1000		/* default log size, blocks */
-#define	XFS_MIN_LOG_FACTOR	3		/* min log size factor */
-#define	XFS_DFL_LOG_FACTOR	16		/* default log size, factor */
+#define	XFS_DFL_LOG_FACTOR	5		/* default log size, factor */
 						/* with max trans reservation */
 #define XFS_MAX_INODE_SIG_BITS	32		/* most significant bits in an
 						 * inode number that we'll
@@ -82,6 +81,7 @@ extern void res_failed (int err);
 
 /* maxtrres.c */
 extern int max_trans_res (int crcs_enabled, int dirversion,
-		int sectorlog, int blocklog, int inodelog, int dirblocklog);
+		int sectorlog, int blocklog, int inodelog, int dirblocklog,
+		int logversion, int log_sunit);
 
 #endif	/* __XFS_MKFS_H__ */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
