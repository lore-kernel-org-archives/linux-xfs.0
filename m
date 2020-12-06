Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A382EC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A0AD23120
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgLFXLr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:11:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43432 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgLFXLq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:11:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NB5bW189070
        for <linux-xfs@vger.kernel.org>; Sun, 6 Dec 2020 23:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=v4R6BiCVCbOxiYLN4AI8rQNMRBZI9geFI1L2pd2d72E=;
 b=LLP5kc660e0VPiEcCbmGzWcFteESnV7ikH2UrsslAsaw3qlC7F9AMv1nQ3eyZSBSKIzS
 U1JrLlv5WVu/2n2r1zW2vSLw3kq0i46DzaFFrl77oE18SSrPQNlRyohPGEpaEkvl0o8g
 FN00FFwFTY8OfeyhHBhSCbrxLL1tnX6THZpNYca69D8MXflkBiy3TZs6A9PAb4T9vkQ+
 iveUPcbydbVrkCGHaXRRMi5sFtBQSfj79vj3e57e4y3yzL4kiOJzLT/Jr+0BbwI9Lz+s
 6cg9bFP+1UdSKHoxCGarFuzRfOogOTzZdtsezUzYQr6DzPd5gWyqjIV0MrDSJ/cQ+Cy+ KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3581mqjvjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 23:11:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NAXLY138386
        for <linux-xfs@vger.kernel.org>; Sun, 6 Dec 2020 23:11:05 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 358kyq6s7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 23:11:05 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B6NB4ZW031631
        for <linux-xfs@vger.kernel.org>; Sun, 6 Dec 2020 23:11:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:11:04 -0800
Subject: [PATCH 2/4] xfs: refactor realtime volume extent validation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 06 Dec 2020 15:11:03 -0800
Message-ID: <160729626316.1608297.11622795343009336589.stgit@magnolia>
In-Reply-To: <160729625074.1608297.13414859761208067117.stgit@magnolia>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=1 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the open-coded validation of realtime device extents into a
single helper.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c  |   13 +++----------
 fs/xfs/libxfs/xfs_types.c |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_types.h |    2 ++
 fs/xfs/scrub/bmap.c       |    8 +-------
 fs/xfs/scrub/rtbitmap.c   |    4 +---
 5 files changed, 23 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7f1b6ad570a9..7bcf498ef6b2 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6226,20 +6226,13 @@ xfs_bmap_validate_extent(
 	struct xfs_bmbt_irec	*irec)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fsblock_t		endfsb;
-	bool			isrt;
 
-	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
-		return __this_address;
 	if (irec->br_startoff + irec->br_blockcount <= irec->br_startoff)
 		return __this_address;
 
-	isrt = XFS_IS_REALTIME_INODE(ip);
-	endfsb = irec->br_startblock + irec->br_blockcount - 1;
-	if (isrt && whichfork == XFS_DATA_FORK) {
-		if (!xfs_verify_rtbno(mp, irec->br_startblock))
-			return __this_address;
-		if (!xfs_verify_rtbno(mp, endfsb))
+	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK) {
+		if (!xfs_verify_rtext(mp, irec->br_startblock,
+					  irec->br_blockcount))
 			return __this_address;
 	} else {
 		if (!xfs_verify_fsbext(mp, irec->br_startblock,
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index b74866dbea94..7b310eb296b7 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -198,6 +198,22 @@ xfs_verify_rtbno(
 	return rtbno < mp->m_sb.sb_rblocks;
 }
 
+/* Verify that a realtime device extent is fully contained inside the volume. */
+bool
+xfs_verify_rtext(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno,
+	xfs_rtblock_t		len)
+{
+	if (rtbno + len <= rtbno)
+		return false;
+
+	if (!xfs_verify_rtbno(mp, rtbno))
+		return false;
+
+	return xfs_verify_rtbno(mp, rtbno + len - 1);
+}
+
 /* Calculate the range of valid icount values. */
 void
 xfs_icount_range(
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 7feaaac25b3d..18e83ce46568 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -197,6 +197,8 @@ bool xfs_verify_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_internal_inum(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_dir_ino(struct xfs_mount *mp, xfs_ino_t ino);
 bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+bool xfs_verify_rtext(struct xfs_mount *mp, xfs_rtblock_t rtbno,
+		xfs_rtblock_t len);
 bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
 bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
 void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 3e2ba7875059..cce8ac7d3973 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -319,7 +319,6 @@ xchk_bmap_iextent(
 	struct xfs_bmbt_irec	*irec)
 {
 	struct xfs_mount	*mp = info->sc->mp;
-	xfs_filblks_t		end;
 	int			error = 0;
 
 	/*
@@ -349,13 +348,8 @@ xchk_bmap_iextent(
 	if (irec->br_blockcount > MAXEXTLEN)
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
-	if (irec->br_startblock + irec->br_blockcount <= irec->br_startblock)
-		xchk_fblock_set_corrupt(info->sc, info->whichfork,
-				irec->br_startoff);
-	end = irec->br_startblock + irec->br_blockcount - 1;
 	if (info->is_rt &&
-	    (!xfs_verify_rtbno(mp, irec->br_startblock) ||
-	     !xfs_verify_rtbno(mp, end)))
+	    !xfs_verify_rtext(mp, irec->br_startblock, irec->br_blockcount))
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 	if (!info->is_rt &&
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 76e4ffe0315b..d409ca592178 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -52,9 +52,7 @@ xchk_rtbitmap_rec(
 	startblock = rec->ar_startext * tp->t_mountp->m_sb.sb_rextsize;
 	blockcount = rec->ar_extcount * tp->t_mountp->m_sb.sb_rextsize;
 
-	if (startblock + blockcount <= startblock ||
-	    !xfs_verify_rtbno(sc->mp, startblock) ||
-	    !xfs_verify_rtbno(sc->mp, startblock + blockcount - 1))
+	if (!xfs_verify_rtext(sc->mp, startblock, blockcount))
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	return 0;
 }

