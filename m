Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91978C83006
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0FA2076A
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 02:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F3TSurbd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgD2Cqj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 22:46:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49596 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726498AbgD2Cqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 22:46:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2j6kH074138
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=piQmsGvkk8kC/ztgGGeR9eFm6iBNuA9XNjZ0sufaR+o=;
 b=F3TSurbdLb0Z+ZmL6q6qupl1bKgciVx6OSXVDMzy6vj/mAYduw9PqMmCieVfzuVOmMyA
 dYmpRfXqyNWUXkTltNv3EqefRktuc6TfCXcXH7NajG5v6B896G5cU6QLsqksgLuOPjzP
 OBgdJ1wmKD9hV3mpQcbGUybSdASVitKw8eXS0JIoAUuSkoc4lkWeURYgPCN2Mckx7Cr8
 NBgiXP/7ZZal8JCfhqLrOdCtpOyndQcIGEmnfEMlkr9lk3QaTwnyRHwHnNhF2OD2/Elo
 Msbbh3tqc5GNOySkUrsajez6Td02/ZLuYg9mNk8DK2yrnt4OfVgXq/Tdu7itNauFij7C Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30nucg39rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03T2h28i075624
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:35 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30my0f8gny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:35 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03T2kYmJ004213
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 02:46:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 28 Apr 2020 19:46:34 -0700
Subject: [PATCH 3/5] xfs: use atomic extent swapping to repair rt metadata
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Apr 2020 19:46:33 -0700
Message-ID: <158812839291.169849.5779915521845398306.stgit@magnolia>
In-Reply-To: <158812837421.169849.625434931406278072.stgit@magnolia>
References: <158812837421.169849.625434931406278072.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=1 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9605 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=1 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290020
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When repairing realtime volume metadata online, stage the new directory
contents in a temporary file and use the atomic extent swapping
mechanism to commit the results in bulk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/repair.c           |   34 ++++++++++++++++++++--------
 fs/xfs/scrub/rtbitmap.c         |   12 ++++++++++
 fs/xfs/scrub/rtbitmap_repair.c  |   48 +++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/rtsummary.c        |   12 ++++++++++
 fs/xfs/scrub/rtsummary_repair.c |   46 ++++++++++++++++++++++++++++++++++++-
 5 files changed, 137 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 0ec483d511cd..5b876b02b9f4 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1636,13 +1636,13 @@ xrep_fallocate(
 	xfs_filblks_t		len)
 {
 	struct xfs_bmbt_irec	map;
+	struct xfs_inode	*ip = sc->tempip;
 	xfs_fileoff_t		end = off + len;
 	int			nmaps;
 	int			error = 0;
 
-	error = xrep_ino_dqattach(sc);
-	if (error)
-		return error;
+	ASSERT(sc->tempip != NULL);
+	ASSERT(!XFS_NOT_DQATTACHED(sc->mp, ip));
 
 	while (off < len) {
 		/*
@@ -1650,7 +1650,7 @@ xrep_fallocate(
 		 * in ok shape.
 		 */
 		nmaps = 1;
-		error = xfs_bmapi_read(sc->ip, off, end - off, &map, &nmaps,
+		error = xfs_bmapi_read(ip, off, end - off, &map, &nmaps,
 				XFS_DATA_FORK);
 		if (error)
 			break;
@@ -1672,15 +1672,21 @@ xrep_fallocate(
 		 * allocated to it.
 		 */
 		nmaps = 1;
-		error = xfs_bmapi_write(sc->tp, sc->ip, off, end - off,
+		error = xfs_bmapi_write(sc->tp, ip, off, end - off,
 				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO, 0, &map,
 				&nmaps);
 		if (error)
 			break;
 
-		error = xfs_trans_roll_inode(&sc->tp, sc->ip);
+		/*
+		 * Roll the transaction with the inode we're fixing and the
+		 * temp inode, so that neither can pin the log.
+		 */
+		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+		error = xfs_trans_roll_inode(&sc->tp, ip);
 		if (error)
 			break;
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
 		off += map.br_startblock;
 	}
 
@@ -1701,6 +1707,7 @@ xrep_set_file_contents(
 {
 	struct list_head	buffers_list;
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->tempip;
 	struct xfs_buf		*bp;
 	xfs_rtblock_t		off = 0;
 	loff_t			pos = 0;
@@ -1744,12 +1751,19 @@ xrep_set_file_contents(
 	}
 
 	/* Set the new inode size, if needed. */
-	if (sc->ip->i_d.di_size != isize) {
-		sc->ip->i_d.di_size = isize;
-		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	if (ip->i_d.di_size != isize) {
+		ip->i_d.di_size = isize;
+		xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
 	}
 
-	return xfs_trans_roll_inode(&sc->tp, sc->ip);
+	/*
+	 * Roll transaction, being careful to keep the tempfile and the
+	 * metadata inode joined.
+	 */
+	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	error = xfs_trans_roll_inode(&sc->tp, ip);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	return error;
 out:
 	xfs_buf_delwri_cancel(&buffers_list);
 	return error;
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 8488d137bf92..c3396d9ead49 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -20,6 +20,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
+#include "scrub/repair.h"
 
 /* Set us up with the realtime metadata locked. */
 int
@@ -29,6 +30,17 @@ xchk_setup_rt(
 {
 	int			error;
 
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		if (!xfs_sb_version_hasatomicswap(&sc->mp->m_sb))
+			return -EOPNOTSUPP;
+
+		error = xrep_create_tempfile(sc, S_IFREG);
+		if (error)
+			return error;
+	}
+#endif
+
 	error = xchk_setup_fs(sc, ip);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index 229dd23d9d3e..d812efe8dd2a 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -18,6 +18,7 @@
 #include "xfs_bmap.h"
 #include "xfs_rmap.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_swapext.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -207,7 +208,29 @@ xrep_rtbitmap_get_buf(
 	xfs_fileoff_t		off,
 	struct xfs_buf		**bpp)
 {
-	return xfs_rtbuf_get(sc->mp, sc->tp, off, 0, bpp);
+	struct xfs_bmbt_irec	map;
+	struct xfs_buf		*bp;
+	struct xfs_mount	*mp = sc->mp;
+	int			nmap = 1;
+	int			error;
+
+	error = xfs_bmapi_read(sc->tempip, off, 1, &map, &nmap,
+			XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	if (nmap == 0 || !xfs_bmap_is_real_extent(&map))
+		return -EFSCORRUPTED;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, map.br_startblock),
+			mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+	if (error)
+		return error;
+
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTBITMAP_BUF);
+	*bpp = bp;
+	return 0;
 }
 
 /* Repair the realtime bitmap. */
@@ -221,8 +244,12 @@ xrep_rtbitmap(
 	xfs_fileoff_t		bmp_bytes;
 	int			error;
 
-	/* We require the realtime rmapbt to rebuild anything. */
-	if (!xfs_sb_version_hasrtrmapbt(&sc->mp->m_sb))
+	/*
+	 * We require the realtime rmapbt and atomic file updates to rebuild
+	 * anything.
+	 */
+	if (!xfs_sb_version_hasrtrmapbt(&sc->mp->m_sb) ||
+	    !xfs_sb_version_hasatomicswap(&sc->mp->m_sb))
 		return -EOPNOTSUPP;
 
 	bmp_bytes = XFS_FSB_TO_B(sc->mp, sc->mp->m_sb.sb_rbmblocks);
@@ -240,8 +267,17 @@ xrep_rtbitmap(
 	if (error)
 		goto out;
 
+	/*
+	 * Trylock the temporary file.  We had better be the only ones holding
+	 * onto this inode...
+	 */
+	if (!xfs_ilock_nowait(sc->tempip, XFS_ILOCK_EXCL))
+		return -EAGAIN;
+	sc->temp_ilock_flags = XFS_ILOCK_EXCL;
+
 	/* Make sure we have space allocated for the entire bitmap file. */
 	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
 	error = xrep_fallocate(sc, 0, sc->mp->m_sb.sb_rbmblocks);
 	if (error)
 		goto out;
@@ -249,6 +285,12 @@ xrep_rtbitmap(
 	/* Copy the bitmap file that we generated. */
 	error = xrep_set_file_contents(sc, xrep_rtbitmap_get_buf, rb.bmpfile,
 			bmp_bytes);
+	if (error)
+		goto out;
+
+	/* Now swap the extents. */
+	error = xfs_swapext_atomic(&sc->tp, sc->ip, sc->tempip, XFS_DATA_FORK,
+			0, 0, sc->mp->m_sb.sb_rbmblocks, 0);
 out:
 	fput(rb.bmpfile);
 	return error;
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index e2b4638fa7cc..ccb220c184f1 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -20,6 +20,7 @@
 #include "scrub/common.h"
 #include "scrub/trace.h"
 #include "scrub/xfile.h"
+#include "scrub/repair.h"
 
 /*
  * Realtime Summary
@@ -61,6 +62,17 @@ xchk_setup_rtsummary(
 	struct xfs_mount	*mp = sc->mp;
 	int			error;
 
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		if (!xfs_sb_version_hasatomicswap(&sc->mp->m_sb))
+			return -EOPNOTSUPP;
+
+		error = xrep_create_tempfile(sc, S_IFREG);
+		if (error)
+			return error;
+	}
+#endif
+
 	error = xchk_setup_fs(sc, ip);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index 78814b6a9c71..9c1fd759b730 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
+#include "xfs_swapext.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -28,7 +29,29 @@ xrep_rtsum_get_buf(
 	xfs_fileoff_t		off,
 	struct xfs_buf		**bpp)
 {
-	return xfs_rtbuf_get(sc->mp, sc->tp, off, 1, bpp);
+	struct xfs_bmbt_irec	map;
+	struct xfs_buf		*bp;
+	struct xfs_mount	*mp = sc->mp;
+	int			nmap = 1;
+	int			error;
+
+	error = xfs_bmapi_read(sc->tempip, off, 1, &map, &nmap,
+			XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	if (nmap == 0 || !xfs_bmap_is_real_extent(&map))
+		return -EFSCORRUPTED;
+
+	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
+			XFS_FSB_TO_DADDR(mp, map.br_startblock),
+			mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+	if (error)
+		return error;
+
+	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTSUMMARY_BUF);
+	*bpp = bp;
+	return 0;
 }
 
 /* Repair the realtime summary. */
@@ -38,18 +61,37 @@ xrep_rtsummary(
 {
 	int			error;
 
+	/* We require atomic file swap to be able to fix rt summaries. */
+	if (!xfs_sb_version_hasatomicswap(&sc->mp->m_sb))
+		return -EOPNOTSUPP;
+
 	/* Make sure any problems with the fork are fixed. */
 	error = xrep_metadata_inode_forks(sc);
 	if (error)
 		return error;
 
+	/*
+	 * Trylock the temporary file.  We had better be the only ones holding
+	 * onto this inode...
+	 */
+	if (!xfs_ilock_nowait(sc->tempip, XFS_ILOCK_EXCL))
+		return -EAGAIN;
+	sc->temp_ilock_flags = XFS_ILOCK_EXCL;
+
 	/* Make sure we have space allocated for the entire summary file. */
 	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
 	error = xrep_fallocate(sc, 0, XFS_B_TO_FSB(sc->mp, sc->mp->m_rsumsize));
 	if (error)
 		return error;
 
 	/* Copy the rtsummary file that we generated. */
-	return xrep_set_file_contents(sc, xrep_rtsum_get_buf, sc->xfile,
+	error = xrep_set_file_contents(sc, xrep_rtsum_get_buf, sc->xfile,
 			sc->mp->m_rsumsize);
+	if (error)
+		return error;
+
+	/* Now swap the extents. */
+	return xfs_swapext_atomic(&sc->tp, sc->ip, sc->tempip, XFS_DATA_FORK,
+			0, 0, XFS_B_TO_FSB(sc->mp, sc->mp->m_rsumsize), 0);
 }

