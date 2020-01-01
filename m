Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D91C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:19:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F0C120718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:19:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WeQsCvlc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgAABTA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:19:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:53906 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABS7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:18:59 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FM4i094960
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=MiktMEMXhF2LjNJRaxER5qcI7BBMsv9nNTbLjhJtz5Q=;
 b=WeQsCvlcfxmYd0A8lbvFAu1l++6LNkNpIevdIaaiVqy3Xo0CipNukJPfYOt3PN9BOV1f
 ZB+J/LHd2AHtgAS3hIfSJw/b6scddVJrD+bi601+7ae01jgxoATK2huRN1hyCTV1MSku
 R0OtNY6DqKS541+Pb560oc3CHtXzma5ADgcRQW9v8Dsi/lQ8/C8zY3VuPFnXP7Nq9ILt
 hLkk9aoXbCiYFVR/yzFIHvdvLjPyOF3Vzi7nClHAGXw7so7iKSv8+3FNFlikt5wbSF8i
 3Qo3U6s5hY4sUempqnbcOcsGeYrPOB/0Ss2n0jTZflF0tSC7mkRpSNIAuuArbDkA5SiZ tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:18:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118wsU172122
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2x8gj91axm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011Gsw7012799
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:54 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:16:53 -0800
Subject: [PATCH 05/21] xfs: define the on-disk realtime rmap btree format
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:16:51 -0800
Message-ID: <157784141105.1368137.576790120006096466.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Start filling out the rtrmap btree implementation. Start with the
on-disk btree format; add everything needed to read, write and
manipulate rmap btree blocks. This prepares the way for connecting the
btree operations implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                  |    1 
 fs/xfs/libxfs/xfs_btree.c        |    1 
 fs/xfs/libxfs/xfs_btree.h        |    3 
 fs/xfs/libxfs/xfs_format.h       |   48 ++++++++
 fs/xfs/libxfs/xfs_rmap.c         |   23 +++-
 fs/xfs/libxfs/xfs_rtrmap_btree.c |  237 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |   53 ++++++++
 fs/xfs/libxfs/xfs_sb.c           |    6 +
 fs/xfs/libxfs/xfs_shared.h       |    1 
 fs/xfs/xfs_mount.c               |    2 
 fs/xfs/xfs_mount.h               |    3 
 fs/xfs/xfs_ondisk.h              |    2 
 12 files changed, 375 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrmap_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0460f96d282b..7c3e61cfc7e2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -46,6 +46,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
+				   xfs_rtrmap_btree.o \
 				   xfs_refcount.o \
 				   xfs_refcount_btree.o \
 				   xfs_sb.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 7d1420f46d89..4d081a9bb8fe 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1269,6 +1269,7 @@ xfs_btree_set_refs(
 		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
 		break;
 	case XFS_BTNUM_RMAP:
+	case XFS_BTNUM_RTRMAP:
 		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
 		break;
 	case XFS_BTNUM_REFC:
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 285deb916157..9b245f6228c7 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -38,6 +38,8 @@ union xfs_btree_key {
 	struct xfs_rmap_key		rmap;
 	struct xfs_rmap_key		__rmap_bigkey[2];
 	struct xfs_refcount_key		refc;
+	struct xfs_rtrmap_key		rtrmap;
+	struct xfs_rtrmap_key		__rtrmap_bigkey[2];
 };
 
 union xfs_btree_rec {
@@ -47,6 +49,7 @@ union xfs_btree_rec {
 	struct xfs_inobt_rec		inobt;
 	struct xfs_rmap_rec		rmap;
 	struct xfs_refcount_rec		refc;
+	struct xfs_rtrmap_rec		rtrmap;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d54bae61cf5e..779b178815dd 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1615,6 +1615,54 @@ typedef __be32 xfs_rmap_ptr_t;
  */
 #define	XFS_RTRMAP_CRC_MAGIC	0x4d415052	/* 'MAPR' */
 
+/*
+ * Data record structure
+ */
+struct xfs_rtrmap_rec {
+	__be64		rm_startblock;	/* extent start block */
+	__be64		rm_blockcount;	/* extent length */
+	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
+};
+
+/* rm_offset has the same values as the regular rmapbt. */
+#define XFS_RTRMAP_OFF_ATTR_FORK	XFS_RMAP_OFF_ATTR_FORK
+#define XFS_RTRMAP_OFF_BMBT_BLOCK	XFS_RMAP_OFF_BMBT_BLOCK
+#define XFS_RTRMAP_OFF_UNWRITTEN	XFS_RMAP_OFF_UNWRITTEN
+
+#define XFS_RTRMAP_LEN_MAX		((uint64_t)~0U)
+#define XFS_RTRMAP_OFF_FLAGS		XFS_RMAP_OFF_FLAGS
+#define XFS_RTRMAP_OFF_MASK		XFS_RMAP_OFF_MASK
+
+#define XFS_RTRMAP_OFF			XFS_RMAP_OFF
+
+#define XFS_RTRMAP_IS_BMBT_BLOCK(off)	XFS_RMAP_IS_BMBT_BLOCK
+#define XFS_RTRMAP_IS_ATTR_FORK(off)	XFS_RMAP_IS_ATTR_FORK
+#define XFS_RTRMAP_IS_UNWRITTEN(len)	XFS_RMAP_IS_UNWRITTEN
+
+#define RTRMAPBT_STARTBLOCK_BITLEN	64
+#define RTRMAPBT_BLOCKCOUNT_BITLEN	64
+#define RTRMAPBT_OWNER_BITLEN		RMAPBT_OWNER_BITLEN
+#define RTRMAPBT_ATTRFLAG_BITLEN	RMAPBT_ATTRFLAG_BITLEN
+#define RTRMAPBT_BMBTFLAG_BITLEN	RMAPBT_BMBTFLAG_BITLEN
+#define RTRMAPBT_EXNTFLAG_BITLEN	RMAPBT_EXNTFLAG_BITLEN
+#define RTRMAPBT_UNUSED_OFFSET_BITLEN	RMAPBT_UNUSED_OFFSET_BITLEN
+#define RTRMAPBT_OFFSET_BITLEN		RMAPBT_OFFSET_BITLEN
+
+/*
+ * Key structure
+ *
+ * We don't use the length for lookups
+ */
+struct xfs_rtrmap_key {
+	__be64		rm_startblock;	/* extent start block */
+	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
+} __packed;
+
+/* btree pointer type */
+typedef __be64 xfs_rtrmap_ptr_t;
+
 /*
  * Reference Count Btree format definitions
  *
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 8f81151a063e..03b2169d5ecf 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -208,23 +208,36 @@ xfs_rmap_get_rec(
 	int			*stat)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_private.a.agno;
+	xfs_agnumber_t		agno;
 	union xfs_btree_rec	*rec;
 	int			error;
 
-	if (cur->bc_btnum != XFS_BTNUM_RMAP)
-		goto out_bad_rec;
-
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || !*stat)
 		return error;
 
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP)
+		agno = -1;
+	else
+		agno = cur->bc_private.a.agno;
+
 	if (xfs_rmap_btrec_to_irec(cur, rec, irec))
 		goto out_bad_rec;
 
 	if (irec->rm_blockcount == 0)
 		goto out_bad_rec;
-	if (irec->rm_startblock <= XFS_AGFL_BLOCK(mp)) {
+	if (cur->bc_btnum == XFS_BTNUM_RTRMAP) {
+		if (!xfs_verify_rtbno(mp, irec->rm_startblock))
+			goto out_bad_rec;
+		if (irec->rm_startblock >
+				irec->rm_startblock + irec->rm_blockcount)
+			goto out_bad_rec;
+		if (!xfs_verify_rtbno(mp,
+				irec->rm_startblock + irec->rm_blockcount - 1))
+			goto out_bad_rec;
+		if (XFS_RMAP_NON_INODE_OWNER(irec->rm_owner))
+			goto out_bad_rec;
+	} else if (irec->rm_startblock <= XFS_AGFL_BLOCK(mp)) {
 		if (irec->rm_owner != XFS_RMAP_OWN_FS)
 			goto out_bad_rec;
 		if (irec->rm_blockcount != XFS_AGFL_BLOCK(mp) + 1)
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
new file mode 100644
index 000000000000..38147bd10a3d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -0,0 +1,237 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
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
+#include "xfs_defer.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_alloc.h"
+#include "xfs_btree.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_error.h"
+#include "xfs_extent_busy.h"
+#include "xfs_ag_resv.h"
+
+/*
+ * Realtime Reverse map btree.
+ *
+ * This is a per-ag tree used to track the owner(s) of a given extent
+ * in the realtime device.  See the comments in xfs_rmap_btree.c for
+ * more information.
+ *
+ * This tree is basically the same as the regular rmap btree except that
+ * it doesn't live in free space, and the startblock and blockcount
+ * fields have been widened to 64 bits.
+ */
+
+static struct xfs_btree_cur *
+xfs_rtrmapbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	struct xfs_btree_cur	*new;
+
+	new = xfs_rtrmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.b.ip);
+
+	/* Copy the flags values since init cursor doesn't get them. */
+	new->bc_private.b.flags = cur->bc_private.b.flags;
+
+	return new;
+}
+
+static xfs_failaddr_t
+xfs_rtrmapbt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_failaddr_t		fa;
+	int			level;
+
+	if (block->bb_magic != cpu_to_be32(XFS_RTRMAP_CRC_MAGIC))
+		return __this_address;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return __this_address;
+	fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (fa)
+		return fa;
+	level = be16_to_cpu(block->bb_level);
+	if (level > mp->m_rtrmap_maxlevels)
+		return __this_address;
+
+	return xfs_btree_lblock_verify(bp, mp->m_rtrmap_mxr[level != 0]);
+}
+
+static void
+xfs_rtrmapbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	if (!xfs_btree_lblock_verify_crc(bp))
+		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
+	else {
+		fa = xfs_rtrmapbt_verify(bp);
+		if (fa)
+			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+	}
+
+	if (bp->b_error)
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+}
+
+static void
+xfs_rtrmapbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	xfs_failaddr_t	fa;
+
+	fa = xfs_rtrmapbt_verify(bp);
+	if (fa) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+	xfs_btree_lblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_rtrmapbt_buf_ops = {
+	.name			= "xfs_rtrmapbt",
+	.verify_read		= xfs_rtrmapbt_read_verify,
+	.verify_write		= xfs_rtrmapbt_write_verify,
+	.verify_struct		= xfs_rtrmapbt_verify,
+};
+
+static const struct xfs_btree_ops xfs_rtrmapbt_ops = {
+	.rec_len		= sizeof(struct xfs_rtrmap_rec),
+	.key_len		= 2 * sizeof(struct xfs_rtrmap_key),
+
+	.dup_cursor		= xfs_rtrmapbt_dup_cursor,
+	.buf_ops		= &xfs_rtrmapbt_buf_ops,
+};
+
+/* Initialize a new rt rmap btree cursor. */
+static struct xfs_btree_cur *
+xfs_rtrmapbt_init_common(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = XFS_BTNUM_RTRMAP;
+	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE |
+			XFS_BTREE_CRC_BLOCKS | XFS_BTREE_IROOT_RECORDS |
+			XFS_BTREE_OVERLAPPING;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
+
+	cur->bc_private.b.ip = ip;
+	cur->bc_private.b.allocated = 0;
+	cur->bc_private.b.flags = 0;
+	cur->bc_ops = &xfs_rtrmapbt_ops;
+
+	return cur;
+}
+
+/* Allocate a new rt rmap btree cursor. */
+struct xfs_btree_cur *
+xfs_rtrmapbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+
+	cur = xfs_rtrmapbt_init_common(mp, tp, ip);
+	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
+	cur->bc_private.b.forksize = XFS_IFORK_SIZE(ip, XFS_DATA_FORK);
+	cur->bc_private.b.whichfork = XFS_DATA_FORK;
+	return cur;
+}
+
+/* Create a new rt reverse mapping btree cursor with a fake root for staging. */
+struct xfs_btree_cur *
+xfs_rtrmapbt_stage_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xbtree_ifakeroot	*ifake)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = xfs_rtrmapbt_init_common(mp, tp, ip);
+	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_private.b.forksize = ifake->if_fork_size;
+	cur->bc_private.b.whichfork = -1;
+	xfs_btree_stage_ifakeroot(cur, ifake, NULL);
+	return cur;
+}
+
+/*
+ * Install a new rt reverse mapping btree root.  Caller is responsible for
+ * invalidating and freeing the old btree blocks.
+ */
+void
+xfs_rtrmapbt_commit_staged_btree(
+	struct xfs_btree_cur	*cur)
+{
+	struct xbtree_ifakeroot	*ifake = cur->bc_private.b.ifake;
+	struct xfs_ifork	*ifp;
+	int			flags = XFS_ILOG_CORE | XFS_ILOG_DBROOT;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
+
+	ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, XFS_DATA_FORK);
+	xfs_ifork_reset(ifp);
+	memcpy(ifp, ifake->if_fork, sizeof(struct xfs_ifork));
+
+	XFS_IFORK_FMT_SET(cur->bc_private.b.ip, XFS_DATA_FORK,
+			ifake->if_format);
+	xfs_trans_log_inode(cur->bc_tp, cur->bc_private.b.ip, flags);
+	xfs_btree_commit_ifakeroot(cur, XFS_DATA_FORK, &xfs_rtrmapbt_ops);
+}
+
+/*
+ * Calculate number of records in an rmap btree block.
+ */
+int
+xfs_rtrmapbt_maxrecs(
+	int			blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_RTRMAP_BLOCK_LEN;
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rtrmap_rec);
+	return blocklen /
+		(2 * sizeof(struct xfs_rtrmap_key) + sizeof(xfs_rtrmap_ptr_t));
+}
+
+/* Compute the maximum height of an rmap btree. */
+void
+xfs_rtrmapbt_compute_maxlevels(
+	struct xfs_mount		*mp)
+{
+	mp->m_rtrmap_maxlevels = xfs_btree_compute_maxlevels(mp->m_rtrmap_mnr,
+			mp->m_sb.sb_rblocks);
+	ASSERT(mp->m_rtrmap_maxlevels <= XFS_BTREE_MAXLEVELS);
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
new file mode 100644
index 000000000000..9d1c80ee6bb8
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_RTRMAP_BTREE_H__
+#define	__XFS_RTRMAP_BTREE_H__
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+struct xbtree_ifakeroot;
+
+/* rmaps only exist on crc enabled filesystems */
+#define XFS_RTRMAP_BLOCK_LEN	XFS_BTREE_LBLOCK_CRC_LEN
+
+/*
+ * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+#define XFS_RTRMAP_REC_ADDR(block, index) \
+	((struct xfs_rtrmap_rec *) \
+		((char *)(block) + XFS_RTRMAP_BLOCK_LEN + \
+		 (((index) - 1) * sizeof(struct xfs_rtrmap_rec))))
+
+#define XFS_RTRMAP_KEY_ADDR(block, index) \
+	((struct xfs_rtrmap_key *) \
+		((char *)(block) + XFS_RTRMAP_BLOCK_LEN + \
+		 ((index) - 1) * 2 * sizeof(struct xfs_rtrmap_key)))
+
+#define XFS_RTRMAP_HIGH_KEY_ADDR(block, index) \
+	((struct xfs_rtrmap_key *) \
+		((char *)(block) + XFS_RTRMAP_BLOCK_LEN + \
+		 sizeof(struct xfs_rtrmap_key) + \
+		 ((index) - 1) * 2 * sizeof(struct xfs_rtrmap_key)))
+
+#define XFS_RTRMAP_PTR_ADDR(block, index, maxrecs) \
+	((xfs_rtrmap_ptr_t *) \
+		((char *)(block) + XFS_RTRMAP_BLOCK_LEN + \
+		 (maxrecs) * 2 * sizeof(struct xfs_rtrmap_key) + \
+		 ((index) - 1) * sizeof(xfs_rtrmap_ptr_t)))
+
+struct xfs_btree_cur *xfs_rtrmapbt_init_cursor(struct xfs_mount *mp,
+				struct xfs_trans *tp, struct xfs_inode *ip);
+struct xfs_btree_cur *xfs_rtrmapbt_stage_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfs_inode *ip,
+		struct xbtree_ifakeroot *ifake);
+void xfs_rtrmapbt_commit_staged_btree(struct xfs_btree_cur *cur);
+int xfs_rtrmapbt_maxrecs(int blocklen, bool leaf);
+void xfs_rtrmapbt_compute_maxlevels(struct xfs_mount *mp);
+
+#endif	/* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 26bf1d4087fb..c2823ccba56d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -25,6 +25,7 @@
 #include "xfs_refcount_btree.h"
 #include "xfs_da_format.h"
 #include "xfs_health.h"
+#include "xfs_rtrmap_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -859,6 +860,11 @@ xfs_sb_mount_common(
 	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
 	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
 
+	mp->m_rtrmap_mxr[0] = xfs_rtrmapbt_maxrecs(sbp->sb_blocksize, true);
+	mp->m_rtrmap_mxr[1] = xfs_rtrmapbt_maxrecs(sbp->sb_blocksize, false);
+	mp->m_rtrmap_mnr[0] = mp->m_rtrmap_mxr[0] / 2;
+	mp->m_rtrmap_mnr[1] = mp->m_rtrmap_mxr[1] / 2;
+
 	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(sbp->sb_blocksize, true);
 	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(sbp->sb_blocksize, false);
 	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index cd6a0d68a75f..0b123f12015d 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -28,6 +28,7 @@ extern const struct xfs_buf_ops xfs_agfl_buf_ops;
 extern const struct xfs_buf_ops xfs_bnobt_buf_ops;
 extern const struct xfs_buf_ops xfs_cntbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rtrmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 42de4a398823..e097cece492f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -33,6 +33,7 @@
 #include "xfs_health.h"
 #include "xfs_trace.h"
 #include "xfs_imeta.h"
+#include "xfs_rtrmap_btree.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
@@ -750,6 +751,7 @@ xfs_mountfs(
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
 	xfs_ialloc_setup_geometry(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_rtrmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	/*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ea1d57df895d..2879031027c5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -137,11 +137,14 @@ typedef struct xfs_mount {
 	uint			m_bmap_dmnr[2];	/* min bmap btree records */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_rtrmap_mxr[2]; /* max rtrmap btree records */
+	uint			m_rtrmap_mnr[2]; /* min rtrmap btree records */
 	uint			m_refc_mxr[2];	/* max refc btree records */
 	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
+	uint			m_rtrmap_maxlevels; /* max rtrmap btree level */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 940522f78a37..909dc682a3b9 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -63,6 +63,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
 	XFS_CHECK_STRUCT_SIZE(union xfs_timestamp,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_key,		24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtrmap_rec,		32);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);

