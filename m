Return-Path: <SRS0=QxtL=3Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03871C3524B
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5ADB214AF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Feb 2020 00:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gD1hKVA9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgBEArP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 19:47:15 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727647AbgBEArP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Feb 2020 19:47:15 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dMvv103195;
        Wed, 5 Feb 2020 00:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4DRjuQkjfasMFDnZPv7FsJi9/586E0SLABbkB6lT2C8=;
 b=gD1hKVA9ydAhzVIRCheO5M1SUHvs7UI7JZ8u4bw2BgzeKWbsG8z2rOAp1gIxyAPU2EHr
 INLSvvvdOojZ0tYRAwwiThfwSteACVAP+8YGGqvkJumbej211ZhJQ1bCkBtHR0F2Zhhe
 3g1AjQ2ymZIo3+SqIUUJIg8ZLkOY2mjnKZkv2/leeEJJkKT6uoVOyk1+HoYqJzGGpsLs
 Mp/8Gxm8bOvAmiggdiXMMpZzgbwA7jdtaiHgroGWazOzGvQUOVh2D1eC98uRhs1fhnUR
 ynFJeeut+wODOvb9H4QVNqmEacAW6fbXG7hB5Vwm6USCcGTXWUOnQ0XlAJQquKJJreQS mw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xykbp00n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0150dYxh149394;
        Wed, 5 Feb 2020 00:47:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2xykc007yu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Feb 2020 00:47:11 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0150lAHj011441;
        Wed, 5 Feb 2020 00:47:10 GMT
Received: from localhost (/10.159.250.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Feb 2020 16:47:10 -0800
Subject: [PATCH 5/7] xfs_repair: use libxfs function to calculate root inode
 location
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        alex@zadara.com
Date:   Tue, 04 Feb 2020 16:47:09 -0800
Message-ID: <158086362904.2079685.11538498774856180130.stgit@magnolia>
In-Reply-To: <158086359783.2079685.9581209719946834913.stgit@magnolia>
References: <158086359783.2079685.9581209719946834913.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002050001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9521 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002050001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use libxfs_ialloc_calc_rootino to compute the location of the root
inode, and improve the function comments while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/globals.c    |    5 ---
 repair/globals.h    |    5 ---
 repair/xfs_repair.c |   78 +++++++--------------------------------------------
 3 files changed, 11 insertions(+), 77 deletions(-)


diff --git a/repair/globals.c b/repair/globals.c
index 8a60e706..299bacd1 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -72,11 +72,6 @@ int	lost_uquotino;
 int	lost_gquotino;
 int	lost_pquotino;
 
-xfs_agino_t	first_prealloc_ino;
-xfs_agblock_t	bnobt_root;
-xfs_agblock_t	bcntbt_root;
-xfs_agblock_t	inobt_root;
-
 /* configuration vars -- fs geometry dependent */
 
 int		inodes_per_block;
diff --git a/repair/globals.h b/repair/globals.h
index 2ed5c894..953e3dfb 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -113,11 +113,6 @@ extern int		lost_uquotino;
 extern int		lost_gquotino;
 extern int		lost_pquotino;
 
-extern xfs_agino_t	first_prealloc_ino;
-extern xfs_agblock_t	bnobt_root;
-extern xfs_agblock_t	bcntbt_root;
-extern xfs_agblock_t	inobt_root;
-
 /* configuration vars -- fs geometry dependent */
 
 extern int		inodes_per_block;
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index f8005f8a..111306fe 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -426,79 +426,23 @@ _("would reset superblock %s inode pointer to %"PRIu64"\n"),
 	*ino = expected_ino;
 }
 
+/*
+ * Make sure that the first 3 inodes in the filesystem are the root directory,
+ * the realtime bitmap, and the realtime summary, in that order.
+ */
 static void
-calc_mkfs(xfs_mount_t *mp)
+calc_mkfs(
+	struct xfs_mount	*mp)
 {
-	xfs_agblock_t	fino_bno;
-	int		do_inoalign;
-
-	do_inoalign = M_IGEO(mp)->ialloc_align;
-
-	/*
-	 * Pre-calculate the geometry of ag 0. We know what it looks like
-	 * because we know what mkfs does: 2 allocation btree roots (by block
-	 * and by size), the inode allocation btree root, the free inode
-	 * allocation btree root (if enabled) and some number of blocks to
-	 * prefill the agfl.
-	 *
-	 * Because the current shape of the btrees may differ from the current
-	 * shape, we open code the mkfs freelist block count here. mkfs creates
-	 * single level trees, so the calculation is pertty straight forward for
-	 * the trees that use the AGFL.
-	 */
-	bnobt_root = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
-	bcntbt_root = bnobt_root + 1;
-	inobt_root = bnobt_root + 2;
-	fino_bno = inobt_root + (2 * min(2, mp->m_ag_maxlevels)) + 1;
-	if (xfs_sb_version_hasfinobt(&mp->m_sb))
-		fino_bno++;
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
-		fino_bno += min(2, mp->m_rmap_maxlevels); /* agfl blocks */
-		fino_bno++;
-	}
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
-		fino_bno++;
+	xfs_ino_t		rootino;
 
-	/*
-	 * If the log is allocated in the first allocation group we need to
-	 * add the number of blocks used by the log to the above calculation.
-	 *
-	 * This can happens with filesystems that only have a single
-	 * allocation group, or very odd geometries created by old mkfs
-	 * versions on very small filesystems.
-	 */
-	if (mp->m_sb.sb_logstart &&
-	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0) {
+	rootino = libxfs_ialloc_calc_rootino(mp, mp->m_sb.sb_unit);
 
-		/*
-		 * XXX(hch): verify that sb_logstart makes sense?
-		 */
-		 fino_bno += mp->m_sb.sb_logblocks;
-	}
-
-	/*
-	 * ditto the location of the first inode chunks in the fs ('/')
-	 */
-	if (xfs_sb_version_hasdalign(&mp->m_sb) && do_inoalign)  {
-		first_prealloc_ino = XFS_AGB_TO_AGINO(mp, roundup(fino_bno,
-					mp->m_sb.sb_unit));
-	} else if (xfs_sb_version_hasalign(&mp->m_sb) &&
-					mp->m_sb.sb_inoalignmt > 1)  {
-		first_prealloc_ino = XFS_AGB_TO_AGINO(mp,
-					roundup(fino_bno,
-						mp->m_sb.sb_inoalignmt));
-	} else  {
-		first_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno);
-	}
-
-	/*
-	 * now the first 3 inodes in the system
-	 */
-	validate_sb_ino(&mp->m_sb.sb_rootino, first_prealloc_ino,
+	validate_sb_ino(&mp->m_sb.sb_rootino, rootino,
 			_("root"));
-	validate_sb_ino(&mp->m_sb.sb_rbmino, first_prealloc_ino + 1,
+	validate_sb_ino(&mp->m_sb.sb_rbmino, rootino + 1,
 			_("realtime bitmap"));
-	validate_sb_ino(&mp->m_sb.sb_rsumino, first_prealloc_ino + 2,
+	validate_sb_ino(&mp->m_sb.sb_rsumino, rootino + 2,
 			_("realtime summary"));
 }
 

