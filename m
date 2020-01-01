Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3248DC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F21A4206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:03:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lKZgEAId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgAABDr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:03:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:48888 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgAABDr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:03:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010x76E083300
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=OzkyZe0DhfS0hR+xecShFlHa8DgxMJAIW8iYJHnz76Y=;
 b=lKZgEAId73ghsoek5aNd9b9Vrzlx5vnq5PmSukZoYBzgPx0bJ42m79LQa8nS23dpuBop
 Omf7znwHGjeaLYVFrbI7oR0N2Xo2q19qWJFjMcPWEPA+dZ+knVJ1T1yA4z/f3vHDtPId
 2MyaKixyVXHA0wRHhJYG1UWmtIXf2qOYU3HTyGcTB6zWEBeROrYTGVtro9x7tTv9TMgX
 fZ+zDWPOXVSTeL7VNP/wJ6U15s1tXq2FEgmG/GalSObW+iaTlvyE6Dl6SbGyUYQrMc19
 A9G6ubd+Xy0/NCFbxVuDMtXCwO2m+xBRujVfVldEKVgjt1Bc6qnu7zxSQz7/uJqQgwBu mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjxn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0010wSCZ026939
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x7medf84r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:03:45 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00113ikV004784
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:03:44 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:03:43 -0800
Subject: [PATCH 4/4] xfs: repair damaged symlinks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:03:41 -0800
Message-ID: <157784062176.1358827.7889539916240754250.stgit@magnolia>
In-Reply-To: <157784059646.1358827.16261069190736091900.stgit@magnolia>
References: <157784059646.1358827.16261069190736091900.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010007
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010007
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Repair inconsistent symbolic link data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile               |    1 
 fs/xfs/scrub/repair.h         |    2 
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/symlink.c        |    5 +
 fs/xfs/scrub/symlink_repair.c |  243 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_symlink.c          |  150 ++++++++++++++-----------
 fs/xfs/xfs_symlink.h          |    3 +
 7 files changed, 338 insertions(+), 68 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 933ba41396b0..f746ba679948 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -167,6 +167,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode_repair.o \
 				   refcount_repair.o \
 				   repair.o \
+				   symlink_repair.o \
 				   xfile.o \
 				   )
 endif
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 84ea16f410bb..4ff872b7b8cd 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -74,6 +74,7 @@ int xrep_refcountbt(struct xfs_scrub *sc);
 int xrep_inode(struct xfs_scrub *sc);
 int xrep_bmap_data(struct xfs_scrub *sc);
 int xrep_bmap_attr(struct xfs_scrub *sc);
+int xrep_symlink(struct xfs_scrub *sc);
 
 struct xrep_newbt_resv {
 	/* Link to list of extents that we've reserved. */
@@ -175,6 +176,7 @@ xrep_reset_perag_resv(
 #define xrep_inode			xrep_notsupported
 #define xrep_bmap_data			xrep_notsupported
 #define xrep_bmap_attr			xrep_notsupported
+#define xrep_symlink			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f5b6184f609b..ff06bc5031ae 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -297,7 +297,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_symlink,
 		.scrub	= xchk_symlink,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_symlink,
 	},
 	[XFS_SCRUB_TYPE_PARENT] = {	/* parent pointers */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 5641ae512c9e..1709c2d90752 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -21,12 +21,15 @@ xchk_setup_symlink(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*ip)
 {
+	uint			resblks;
+
 	/* Allocate the buffer without the inode lock held. */
 	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, 0);
 	if (!sc->buf)
 		return -ENOMEM;
 
-	return xchk_setup_inode_contents(sc, ip, 0);
+	resblks = xfs_symlink_blocks(sc->mp, XFS_SYMLINK_MAXLEN);
+	return xchk_setup_inode_contents(sc, ip, resblks);
 }
 
 /* Symbolic links. */
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
new file mode 100644
index 000000000000..8adb3e34d1c1
--- /dev/null
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_symlink.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+
+/*
+ * Symbolic Link Repair
+ * ====================
+ *
+ * There's not much we can do to repair symbolic links -- we truncate them to
+ * the first NULL byte and reinitialize the target.  Zero-length symlinks are
+ * turned into links to the current dir.
+ */
+
+/* Try to salvage the pathname from rmt blocks. */
+STATIC int
+xrep_symlink_salvage_remote(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_inode	*ip = sc->ip;
+	struct xfs_buf		*bp;
+	char			*target_buf = sc->buf;
+	xfs_failaddr_t		fa;
+	xfs_filblks_t		fsblocks;
+	xfs_daddr_t		d;
+	loff_t			len;
+	loff_t			offset;
+	unsigned int		byte_cnt;
+	bool			magic_ok;
+	bool			hdr_ok;
+	int			n;
+	int			nmaps = XFS_SYMLINK_MAPS;
+	int			error;
+
+	/* We'll only read until the buffer is full. */
+	len = max_t(loff_t, ip->i_d.di_size, XFS_SYMLINK_MAXLEN);
+	fsblocks = xfs_symlink_blocks(sc->mp, len);
+	error = xfs_bmapi_read(ip, 0, fsblocks, mval, &nmaps, 0);
+	if (error)
+		return error;
+
+	offset = 0;
+	for (n = 0; n < nmaps; n++) {
+		struct xfs_dsymlink_hdr	*dsl;
+
+		d = XFS_FSB_TO_DADDR(sc->mp, mval[n].br_startblock);
+
+		/* Read the rmt block.  We'll run the verifiers manually. */
+		error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
+				d, XFS_FSB_TO_BB(sc->mp, mval[n].br_blockcount),
+				0, &bp, NULL);
+		if (error)
+			return error;
+		bp->b_ops = &xfs_symlink_buf_ops;
+
+		/* How many bytes do we expect to get out of this buffer? */
+		byte_cnt = XFS_FSB_TO_B(sc->mp, mval[n].br_blockcount);
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(sc->mp, byte_cnt);
+		byte_cnt = min_t(unsigned int, byte_cnt, len);
+
+		/*
+		 * See if the verifiers accept this block.  We're willing to
+		 * salvage if the if the offset/byte/ino are ok and either the
+		 * verifier passed or the magic is ok.  Anything else and we
+		 * stop dead in our tracks.
+		 */
+		fa = bp->b_ops->verify_struct(bp);
+		dsl = bp->b_addr;
+		magic_ok = dsl->sl_magic == cpu_to_be32(XFS_SYMLINK_MAGIC);
+		hdr_ok = xfs_symlink_hdr_ok(ip->i_ino, offset, byte_cnt, bp);
+		if (!hdr_ok || (fa != NULL && !magic_ok))
+			break;
+
+		memcpy(target_buf + offset, dsl + 1, byte_cnt);
+
+		len -= byte_cnt;
+		offset += byte_cnt;
+	}
+
+	/* Ensure we have a zero at the end, and /some/ contents. */
+	if (offset == 0)
+		sprintf(target_buf, ".");
+	else
+		target_buf[offset] = 0;
+	return 0;
+}
+
+/*
+ * Try to salvage an inline symlink's contents.  Empty symlinks become a link
+ * to the current directory.
+ */
+STATIC void
+xrep_symlink_salvage_inline(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_inode	*ip = sc->ip;
+	struct xfs_ifork	*ifp;
+
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	if (ifp->if_u1.if_data)
+		strncpy(sc->buf, ifp->if_u1.if_data, XFS_IFORK_DSIZE(ip));
+	if (strlen(sc->buf) == 0)
+		sprintf(sc->buf, ".");
+}
+
+/* Reset an inline symlink to its fresh configuration. */
+STATIC void
+xrep_symlink_truncate_inline(
+	struct xfs_inode	*ip)
+{
+	xfs_idestroy_fork(ip, XFS_DATA_FORK);
+	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+	ip->i_d.di_nextents = 0;
+	memset(&ip->i_df, 0, sizeof(struct xfs_ifork));
+	ip->i_df.if_flags |= XFS_IFEXTENTS;
+}
+
+/*
+ * Salvage an inline symlink's contents and reset data fork.
+ * Returns with the inode joined to the transaction.
+ */
+STATIC int
+xrep_symlink_inline(
+	struct xfs_scrub	*sc)
+{
+	/* Salvage whatever link target information we can find. */
+	xrep_symlink_salvage_inline(sc);
+
+	/* Truncate the symlink. */
+	xrep_symlink_truncate_inline(sc->ip);
+
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	return 0;
+}
+
+/*
+ * Salvage an inline symlink's contents and reset data fork.
+ * Returns with the inode joined to the transaction.
+ */
+STATIC int
+xrep_symlink_remote(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	/* Salvage whatever link target information we can find. */
+	error = xrep_symlink_salvage_remote(sc);
+	if (error)
+		return error;
+
+	/* Truncate the symlink. */
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	return xfs_itruncate_extents(&sc->tp, sc->ip, XFS_DATA_FORK, 0);
+}
+
+/*
+ * Reinitialize a link target.  Caller must ensure the inode is joined to
+ * the transaction.
+ */
+STATIC int
+xrep_symlink_reinitialize(
+	struct xfs_scrub	*sc)
+{
+	xfs_fsblock_t		fs_blocks;
+	unsigned int		target_len;
+	uint			resblks;
+	int			error;
+
+	/* How many blocks do we need? */
+	target_len = strlen(sc->buf);
+	ASSERT(target_len != 0);
+	if (target_len == 0 || target_len > XFS_SYMLINK_MAXLEN)
+		return -EFSCORRUPTED;
+
+	/* Set up to reinitialize the target. */
+	fs_blocks = xfs_symlink_blocks(sc->mp, target_len);
+	resblks = XFS_SYMLINK_SPACE_RES(sc->mp, target_len, fs_blocks);
+	error = xfs_trans_reserve_quota_nblks(sc->tp, sc->ip, resblks, 0,
+			XFS_QMOPT_RES_REGBLKS);
+
+	/* Try to write the new target back out. */
+	error = xfs_symlink_write_target(sc->tp, sc->ip, sc->buf, target_len,
+			fs_blocks, resblks);
+	if (error)
+		return error;
+
+	/* Finish up any block mapping activities. */
+	return xfs_defer_finish(&sc->tp);
+}
+
+/* Repair a symbolic link. */
+int
+xrep_symlink(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_ifork	*ifp;
+	int			error;
+
+	error = xfs_qm_dqattach_locked(sc->ip, false);
+	if (error)
+		return error;
+
+	/* Salvage whatever we can of the target. */
+	*((char *)sc->buf) = 0;
+	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
+	if (ifp->if_flags & XFS_IFINLINE)
+		error = xrep_symlink_inline(sc);
+	else
+		error = xrep_symlink_remote(sc);
+	if (error)
+		return error;
+
+	/* Now reset the target. */
+	return xrep_symlink_reinitialize(sc);
+}
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a25502bc2071..bedd9a8be75f 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -142,6 +142,86 @@ xfs_readlink(
 	return error;
 }
 
+/* Write the symlink target into the inode. */
+int
+xfs_symlink_write_target(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	const char		*target_path,
+	int			pathlen,
+	xfs_fsblock_t		fs_blocks,
+	uint			resblks)
+{
+	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
+	struct xfs_mount	*mp = tp->t_mountp;
+	const char		*cur_chunk;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		d;
+	int			byte_cnt;
+	int			nmaps;
+	int			offset;
+	int			n;
+	int			error;
+
+	/*
+	 * If the symlink will fit into the inode, write it inline.
+	 */
+	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
+		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
+
+		ip->i_d.di_size = pathlen;
+		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
+
+		return 0;
+	}
+
+	/* Write target to remote blocks. */
+	nmaps = XFS_SYMLINK_MAPS;
+	error = xfs_bmapi_write(tp, ip, 0, fs_blocks, XFS_BMAPI_METADATA,
+			resblks, mval, &nmaps);
+	if (error)
+		return error;
+
+	if (resblks)
+		resblks -= fs_blocks;
+	ip->i_d.di_size = pathlen;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	cur_chunk = target_path;
+	offset = 0;
+	for (n = 0; n < nmaps; n++) {
+		char	*buf;
+
+		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
+		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
+		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
+				BTOBB(byte_cnt), 0);
+		if (!bp)
+			return -ENOMEM;
+		bp->b_ops = &xfs_symlink_buf_ops;
+
+		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
+		byte_cnt = min(byte_cnt, pathlen);
+
+		buf = bp->b_addr;
+		buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset,
+					   byte_cnt, bp);
+
+		memcpy(buf, cur_chunk, byte_cnt);
+
+		cur_chunk += byte_cnt;
+		pathlen -= byte_cnt;
+		offset += byte_cnt;
+
+		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
+		xfs_trans_log_buf(tp, bp, 0, (buf + byte_cnt - 1) -
+						(char *)bp->b_addr);
+	}
+	ASSERT(pathlen == 0);
+	return 0;
+}
+
 int
 xfs_symlink(
 	struct xfs_inode	*dp,
@@ -156,15 +236,7 @@ xfs_symlink(
 	int			error = 0;
 	int			pathlen;
 	bool                    unlock_dp_on_error = false;
-	xfs_fileoff_t		first_fsb;
 	xfs_filblks_t		fs_blocks;
-	int			nmaps;
-	struct xfs_bmbt_irec	mval[XFS_SYMLINK_MAPS];
-	xfs_daddr_t		d;
-	const char		*cur_chunk;
-	int			byte_cnt;
-	int			n;
-	xfs_buf_t		*bp;
 	prid_t			prid;
 	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*gdqp = NULL;
@@ -258,65 +330,11 @@ xfs_symlink(
 
 	if (resblks)
 		resblks -= XFS_IALLOC_SPACE_RES(mp);
-	/*
-	 * If the symlink will fit into the inode, write it inline.
-	 */
-	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
-		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
-
-		ip->i_d.di_size = pathlen;
-		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
-	} else {
-		int	offset;
-
-		first_fsb = 0;
-		nmaps = XFS_SYMLINK_MAPS;
-
-		error = xfs_bmapi_write(tp, ip, first_fsb, fs_blocks,
-				  XFS_BMAPI_METADATA, resblks, mval, &nmaps);
-		if (error)
-			goto out_trans_cancel;
-
-		if (resblks)
-			resblks -= fs_blocks;
-		ip->i_d.di_size = pathlen;
-		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-		cur_chunk = target_path;
-		offset = 0;
-		for (n = 0; n < nmaps; n++) {
-			char	*buf;
-
-			d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
-			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
-			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
-					       BTOBB(byte_cnt), 0);
-			if (!bp) {
-				error = -ENOMEM;
-				goto out_trans_cancel;
-			}
-			bp->b_ops = &xfs_symlink_buf_ops;
-
-			byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
-			byte_cnt = min(byte_cnt, pathlen);
-
-			buf = bp->b_addr;
-			buf += xfs_symlink_hdr_set(mp, ip->i_ino, offset,
-						   byte_cnt, bp);
-
-			memcpy(buf, cur_chunk, byte_cnt);
 
-			cur_chunk += byte_cnt;
-			pathlen -= byte_cnt;
-			offset += byte_cnt;
-
-			xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SYMLINK_BUF);
-			xfs_trans_log_buf(tp, bp, 0, (buf + byte_cnt - 1) -
-							(char *)bp->b_addr);
-		}
-		ASSERT(pathlen == 0);
-	}
+	error = xfs_symlink_write_target(tp, ip, target_path, pathlen,
+			fs_blocks, resblks);
+	if (error)
+		goto out_trans_cancel;
 
 	/*
 	 * Create the directory entry for the symlink.
diff --git a/fs/xfs/xfs_symlink.h b/fs/xfs/xfs_symlink.h
index b1fa091427e6..51f1b53d3f79 100644
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -12,5 +12,8 @@ int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
 int xfs_readlink_bmap_ilocked(struct xfs_inode *ip, char *link);
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_inactive_symlink(struct xfs_inode *ip);
+int xfs_symlink_write_target(struct xfs_trans *tp, struct xfs_inode *ip,
+		const char *target_path, int pathlen, xfs_fsblock_t fs_blocks,
+		uint resblks);
 
 #endif /* __XFS_SYMLINK_H */

