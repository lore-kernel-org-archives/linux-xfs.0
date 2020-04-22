Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDFAFC2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1365206D5
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 02:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Kr5GtNxa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgDVCJF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Apr 2020 22:09:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgDVCJF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Apr 2020 22:09:05 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M28St0170954
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:09:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/MaZfaJ3MrvQ5XgbtALEqgVGQAFjOKhoni6F3kLbsFM=;
 b=Kr5GtNxaxFXkg2gYIzGq0Wg4sirUsKWKXpyffjReZp9QDRKvOqgzfvrQ4lYvpIZR8SUR
 80agnpzkIpe6xmXY58HbTZoZLpkKGSPCYUgnvJgooCKQCr9sc2iuzFukzGO8jmVUH7/u
 vvcVQvpfne+Qq90nRT/EZjjOpCmKOYjGDrH7SUehtMh/EEIPlGWXwhFJWb0BASbDtAD1
 s35ZnoIlgo2cWvQJ4zQdJYv9Wz9XRYnfNkfIE9R0twy3Ry74jByA384/JwKJAZoMHJA8
 4kUB6Qipm0miUQk33xr+veUP5gYd61BdPpK8vfQr41OOLGwsTs75tV4QZ03GQ7lZs7vD Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30grpgmhrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:09:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M23TBA179062
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30gb91fpc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:02 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03M271mT014983
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 02:07:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 19:07:01 -0700
Subject: [PATCH 09/19] xfs: refactor log recovery icreate item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 21 Apr 2020 19:07:00 -0700
Message-ID: <158752122050.2140829.10077536743035207298.stgit@magnolia>
In-Reply-To: <158752116283.2140829.12265815455525398097.stgit@magnolia>
References: <158752116283.2140829.12265815455525398097.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=1 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=1 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220015
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the log icreate item pass2 commit code into the per-item source code
files and use the dispatch function to call it.  We do these one at a
time because there's a lot of code to move.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icreate_item.c |  132 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c  |  126 -------------------------------------------
 2 files changed, 132 insertions(+), 126 deletions(-)


diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 0a1ed4dc1c3d..15415421ea81 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -6,13 +6,19 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_icreate_item.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_ialloc.h"
+#include "xfs_trace.h"
 
 kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
 
@@ -110,6 +116,132 @@ xfs_icreate_log(
 	set_bit(XFS_LI_DIRTY, &icp->ic_item.li_flags);
 }
 
+/*
+ * This routine is called when an inode create format structure is found in a
+ * committed transaction in the log.  It's purpose is to initialise the inodes
+ * being allocated on disk. This requires us to get inode cluster buffers that
+ * match the range to be initialised, stamped with inode templates and written
+ * by delayed write so that subsequent modifications will hit the cached buffer
+ * and only need writing out at the end of recovery.
+ */
+STATIC int
+xlog_recover_do_icreate_pass2(
+	struct xlog		*log,
+	struct list_head	*buffer_list,
+	struct xlog_recover_item *item,
+	xfs_lsn_t		current_lsn)
+{
+	struct xfs_mount	*mp = log->l_mp;
+	struct xfs_icreate_log	*icl;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	unsigned int		count;
+	unsigned int		isize;
+	xfs_agblock_t		length;
+	int			bb_per_cluster;
+	int			cancel_count;
+	int			nbufs;
+	int			i;
+
+	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
+	if (icl->icl_type != XFS_LI_ICREATE) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad type");
+		return -EINVAL;
+	}
+
+	if (icl->icl_size != 1) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad icl size");
+		return -EINVAL;
+	}
+
+	agno = be32_to_cpu(icl->icl_ag);
+	if (agno >= mp->m_sb.sb_agcount) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agno");
+		return -EINVAL;
+	}
+	agbno = be32_to_cpu(icl->icl_agbno);
+	if (!agbno || agbno == NULLAGBLOCK || agbno >= mp->m_sb.sb_agblocks) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agbno");
+		return -EINVAL;
+	}
+	isize = be32_to_cpu(icl->icl_isize);
+	if (isize != mp->m_sb.sb_inodesize) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad isize");
+		return -EINVAL;
+	}
+	count = be32_to_cpu(icl->icl_count);
+	if (!count) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count");
+		return -EINVAL;
+	}
+	length = be32_to_cpu(icl->icl_length);
+	if (!length || length >= mp->m_sb.sb_agblocks) {
+		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad length");
+		return -EINVAL;
+	}
+
+	/*
+	 * The inode chunk is either full or sparse and we only support
+	 * m_ino_geo.ialloc_min_blks sized sparse allocations at this time.
+	 */
+	if (length != igeo->ialloc_blks &&
+	    length != igeo->ialloc_min_blks) {
+		xfs_warn(log->l_mp,
+			 "%s: unsupported chunk length", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	/* verify inode count is consistent with extent length */
+	if ((count >> mp->m_sb.sb_inopblog) != length) {
+		xfs_warn(log->l_mp,
+			 "%s: inconsistent inode count and chunk length",
+			 __FUNCTION__);
+		return -EINVAL;
+	}
+
+	/*
+	 * The icreate transaction can cover multiple cluster buffers and these
+	 * buffers could have been freed and reused. Check the individual
+	 * buffers for cancellation so we don't overwrite anything written after
+	 * a cancellation.
+	 */
+	bb_per_cluster = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
+	nbufs = length / igeo->blocks_per_cluster;
+	for (i = 0, cancel_count = 0; i < nbufs; i++) {
+		xfs_daddr_t	daddr;
+
+		daddr = XFS_AGB_TO_DADDR(mp, agno,
+				agbno + i * igeo->blocks_per_cluster);
+		if (xlog_check_buffer_cancelled(log, daddr, bb_per_cluster, 0))
+			cancel_count++;
+	}
+
+	/*
+	 * We currently only use icreate for a single allocation at a time. This
+	 * means we should expect either all or none of the buffers to be
+	 * cancelled. Be conservative and skip replay if at least one buffer is
+	 * cancelled, but warn the user that something is awry if the buffers
+	 * are not consistent.
+	 *
+	 * XXX: This must be refined to only skip cancelled clusters once we use
+	 * icreate for multiple chunk allocations.
+	 */
+	ASSERT(!cancel_count || cancel_count == nbufs);
+	if (cancel_count) {
+		if (cancel_count != nbufs)
+			xfs_warn(mp,
+	"WARNING: partial inode chunk cancellation, skipped icreate.");
+		trace_xfs_log_recover_icreate_cancel(log, icl);
+		return 0;
+	}
+
+	trace_xfs_log_recover_icreate_recover(log, icl);
+	return xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno,
+				     length, be32_to_cpu(icl->icl_gen));
+}
+
 const struct xlog_recover_item_type xlog_icreate_item_type = {
 	.reorder		= XLOG_REORDER_BUFFER_LIST,
+	.commit_pass2_fn	= xlog_recover_do_icreate_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5b3c5df22e88..18b797ca4a6c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2445,130 +2445,6 @@ xlog_recover_bud_pass2(
 	return 0;
 }
 
-/*
- * This routine is called when an inode create format structure is found in a
- * committed transaction in the log.  It's purpose is to initialise the inodes
- * being allocated on disk. This requires us to get inode cluster buffers that
- * match the range to be initialised, stamped with inode templates and written
- * by delayed write so that subsequent modifications will hit the cached buffer
- * and only need writing out at the end of recovery.
- */
-STATIC int
-xlog_recover_do_icreate_pass2(
-	struct xlog		*log,
-	struct list_head	*buffer_list,
-	xlog_recover_item_t	*item)
-{
-	struct xfs_mount	*mp = log->l_mp;
-	struct xfs_icreate_log	*icl;
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	xfs_agnumber_t		agno;
-	xfs_agblock_t		agbno;
-	unsigned int		count;
-	unsigned int		isize;
-	xfs_agblock_t		length;
-	int			bb_per_cluster;
-	int			cancel_count;
-	int			nbufs;
-	int			i;
-
-	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
-	if (icl->icl_type != XFS_LI_ICREATE) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad type");
-		return -EINVAL;
-	}
-
-	if (icl->icl_size != 1) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad icl size");
-		return -EINVAL;
-	}
-
-	agno = be32_to_cpu(icl->icl_ag);
-	if (agno >= mp->m_sb.sb_agcount) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agno");
-		return -EINVAL;
-	}
-	agbno = be32_to_cpu(icl->icl_agbno);
-	if (!agbno || agbno == NULLAGBLOCK || agbno >= mp->m_sb.sb_agblocks) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad agbno");
-		return -EINVAL;
-	}
-	isize = be32_to_cpu(icl->icl_isize);
-	if (isize != mp->m_sb.sb_inodesize) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad isize");
-		return -EINVAL;
-	}
-	count = be32_to_cpu(icl->icl_count);
-	if (!count) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count");
-		return -EINVAL;
-	}
-	length = be32_to_cpu(icl->icl_length);
-	if (!length || length >= mp->m_sb.sb_agblocks) {
-		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad length");
-		return -EINVAL;
-	}
-
-	/*
-	 * The inode chunk is either full or sparse and we only support
-	 * m_ino_geo.ialloc_min_blks sized sparse allocations at this time.
-	 */
-	if (length != igeo->ialloc_blks &&
-	    length != igeo->ialloc_min_blks) {
-		xfs_warn(log->l_mp,
-			 "%s: unsupported chunk length", __FUNCTION__);
-		return -EINVAL;
-	}
-
-	/* verify inode count is consistent with extent length */
-	if ((count >> mp->m_sb.sb_inopblog) != length) {
-		xfs_warn(log->l_mp,
-			 "%s: inconsistent inode count and chunk length",
-			 __FUNCTION__);
-		return -EINVAL;
-	}
-
-	/*
-	 * The icreate transaction can cover multiple cluster buffers and these
-	 * buffers could have been freed and reused. Check the individual
-	 * buffers for cancellation so we don't overwrite anything written after
-	 * a cancellation.
-	 */
-	bb_per_cluster = XFS_FSB_TO_BB(mp, igeo->blocks_per_cluster);
-	nbufs = length / igeo->blocks_per_cluster;
-	for (i = 0, cancel_count = 0; i < nbufs; i++) {
-		xfs_daddr_t	daddr;
-
-		daddr = XFS_AGB_TO_DADDR(mp, agno,
-				agbno + i * igeo->blocks_per_cluster);
-		if (xlog_check_buffer_cancelled(log, daddr, bb_per_cluster, 0))
-			cancel_count++;
-	}
-
-	/*
-	 * We currently only use icreate for a single allocation at a time. This
-	 * means we should expect either all or none of the buffers to be
-	 * cancelled. Be conservative and skip replay if at least one buffer is
-	 * cancelled, but warn the user that something is awry if the buffers
-	 * are not consistent.
-	 *
-	 * XXX: This must be refined to only skip cancelled clusters once we use
-	 * icreate for multiple chunk allocations.
-	 */
-	ASSERT(!cancel_count || cancel_count == nbufs);
-	if (cancel_count) {
-		if (cancel_count != nbufs)
-			xfs_warn(mp,
-	"WARNING: partial inode chunk cancellation, skipped icreate.");
-		trace_xfs_log_recover_icreate_cancel(log, icl);
-		return 0;
-	}
-
-	trace_xfs_log_recover_icreate_recover(log, icl);
-	return xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno,
-				     length, be32_to_cpu(icl->icl_gen));
-}
-
 STATIC int
 xlog_recover_commit_pass1(
 	struct xlog			*log,
@@ -2631,8 +2507,6 @@ xlog_recover_commit_pass2(
 				trans->r_lsn);
 
 	switch (ITEM_TYPE(item)) {
-	case XFS_LI_ICREATE:
-		return xlog_recover_do_icreate_pass2(log, buffer_list, item);
 	case XFS_LI_QUOTAOFF:
 		/* nothing to do in pass2 */
 		return 0;

