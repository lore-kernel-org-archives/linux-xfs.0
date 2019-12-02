Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55719C432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:36:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 289002084F
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:36:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z/xt9ZsM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbfLBRgY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:36:24 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbfLBRgY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 12:36:24 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HZFjV044383;
        Mon, 2 Dec 2019 17:36:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IKSMzWdkkcTWaGz4Hbx32SzjnW2YIUY9vthkVR663hU=;
 b=Z/xt9ZsMfZDzxASH1pqp7PkSG8uy6nnrgCZlHM2y+ENjWBNCd0Lg3ox7Ir/yOsPriqHx
 oSKQ4MYdTYnaoPkF5aXCaI+lxh7YDWG0kA+wjoNEM4IIkfICVk0ciD55O0ffAPcwqMTP
 T/jVA0On5HcXk3sOPJUOz1XkLH6mI0ygDJl2K2ECNrCUNF1+0HidCg0jTgpIG4N/79jB
 dks9t/DVcmoAVn2NMswRJT1fHzqMDo1WRqwbJVGVKdSWOBjO1/Z2zpPsBRnPUYV022Wn
 RxsJXlX6oEY/s+3dBDVlZ+kxyKZcPP2Tjyjf9sgBspQR+8YHRitLtf3DbVckDFfl2KAz 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wkfuu1qju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:36:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HYIUV190766;
        Mon, 2 Dec 2019 17:36:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2wn4qn2h13-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:36:21 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xB2HaKwb010748;
        Mon, 2 Dec 2019 17:36:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 09:36:20 -0800
Subject: [PATCH 3/4] xfs_repair: use xfs_ialloc_find_prealloc
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, alex@zadara.com
Date:   Mon, 02 Dec 2019 09:36:17 -0800
Message-ID: <157530817752.126767.11564594395654513843.stgit@magnolia>
In-Reply-To: <157530815855.126767.7523979488668040754.stgit@magnolia>
References: <157530815855.126767.7523979488668040754.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the open-coded first_prealloc_ino computation with a call to
xfs_ialloc_find_prealloc.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/globals.c    |    3 --
 repair/globals.h    |    3 --
 repair/xfs_repair.c |   70 +--------------------------------------------------
 3 files changed, 2 insertions(+), 74 deletions(-)


diff --git a/repair/globals.c b/repair/globals.c
index dcd79ea4..91cc49c6 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -74,9 +74,6 @@ int	lost_pquotino;
 
 xfs_agino_t	first_prealloc_ino;
 xfs_agino_t	last_prealloc_ino;
-xfs_agblock_t	bnobt_root;
-xfs_agblock_t	bcntbt_root;
-xfs_agblock_t	inobt_root;
 
 /* configuration vars -- fs geometry dependent */
 
diff --git a/repair/globals.h b/repair/globals.h
index 008bdd90..31dd760c 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -115,9 +115,6 @@ extern int		lost_pquotino;
 
 extern xfs_agino_t	first_prealloc_ino;
 extern xfs_agino_t	last_prealloc_ino;
-extern xfs_agblock_t	bnobt_root;
-extern xfs_agblock_t	bcntbt_root;
-extern xfs_agblock_t	inobt_root;
 
 /* configuration vars -- fs geometry dependent */
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9295673d..6798b88c 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -398,74 +398,8 @@ do_log(char const *msg, ...)
 static void
 calc_mkfs(xfs_mount_t *mp)
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
-
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
-
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
-	ASSERT(M_IGEO(mp)->ialloc_blks > 0);
-
-	if (M_IGEO(mp)->ialloc_blks > 1)
-		last_prealloc_ino = first_prealloc_ino + XFS_INODES_PER_CHUNK;
-	else
-		last_prealloc_ino = XFS_AGB_TO_AGINO(mp, fino_bno + 1);
+	libxfs_ialloc_find_prealloc(mp, &first_prealloc_ino,
+			&last_prealloc_ino);
 
 	/*
 	 * now the first 3 inodes in the system

