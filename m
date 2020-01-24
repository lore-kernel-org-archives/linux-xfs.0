Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26E0C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EB352071E
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L4MvfqCe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729648AbgAXAR6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:17:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56060 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729616AbgAXAR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:17:58 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O08mQ7002813;
        Fri, 24 Jan 2020 00:17:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=DfLzYe+ZJg79fUZjeJz8m53/FM9GM9N88IGyETV2wrM=;
 b=L4MvfqCeV3YJfRCKNGO1l2xfbHBuW4ZFIPM/etG89r3hLXuimW0FeP/3DwFGh7XqBO6b
 S/TG3a97StryuZG7AOsU40lxEiOEaFVYsRRYQ1tbduRmInx3WouA4yyEdKRhtJRuUED9
 ljQIm64Spa8r1qQMixUs32ocmlRvX//JquaU/q8faHShAsGyuqu9lY658nHDBrdILlPQ
 AemlPd9+cYnr0HvCwZwg3rlihsgUtomR7NLyk3mHsMZRfjuRoFxMZNyBXyL1kampy535
 LiSnWnYhFZj3Gc0mfoxwR19CFTdrIbqc3a0jk+cyX7TB5b3ay/BLKu9ZjO9Monc5wnbg Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xktnrnn3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0E4Nw110958;
        Fri, 24 Jan 2020 00:17:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2xqmwb1kkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:54 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00O0HrQ8031171;
        Fri, 24 Jan 2020 00:17:53 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:17:53 -0800
Subject: [PATCH 4/6] xfs_repair: use libxfs function to calculate root inode
 location
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Thu, 23 Jan 2020 16:17:51 -0800
Message-ID: <157982507143.2765631.5497851947437763176.stgit@magnolia>
In-Reply-To: <157982504556.2765631.630298760136626647.stgit@magnolia>
References: <157982504556.2765631.630298760136626647.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use libxfs_ialloc_calc_rootino to compute the location of the root
inode, and improve the function comments while we're at it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
index 94673750..53b04dae 100644
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
-	ensure_fixed_ino(&mp->m_sb.sb_rootino, first_prealloc_ino,
+	ensure_fixed_ino(&mp->m_sb.sb_rootino, rootino,
 			_("root"));
-	ensure_fixed_ino(&mp->m_sb.sb_rbmino, first_prealloc_ino + 1,
+	ensure_fixed_ino(&mp->m_sb.sb_rbmino, rootino + 1,
 			_("realtime bitmap"));
-	ensure_fixed_ino(&mp->m_sb.sb_rsumino, first_prealloc_ino + 2,
+	ensure_fixed_ino(&mp->m_sb.sb_rsumino, rootino + 2,
 			_("realtime summary"));
 }
 

