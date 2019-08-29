Return-Path: <SRS0=CuST=WZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55462C3A59F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D48A2073F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Aug 2019 16:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GV+ccKXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfH2QYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 12:24:00 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfH2QYA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 12:24:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TGNxNh055016
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=JRLykziNx07hgDeG7LCXgM5K2KPnf4G2WGyY+jiUjJE=;
 b=GV+ccKXup38ldDGBDfe7UsULhprwXDRosTIPJ/94uQwv2hmXG8Fq7JwdhY8VP3vbTO5/
 G8MtKz5Mq+TkSnbbC1GKJXtwkMvRap6j5EmOm8xNUuhn7OwxeHTyyMHShwEXBymb2mes
 M1nSxb9jsZ3rnbJvXAmqYApO2XE/UYv5ABWy7QLPY4bYFfn0DiCBxbLO1QscSyVYg7Iw
 /cBOgcul+38zK4TecVKZDCfQ2IVfVIMaTtQIAcrjaf0vgc9qUR5jCXhuWNyYNZZ4A6cc
 5pKzM9iwwFdDd/ydcd9CugXr9tpJtfweBbBpwL2cSv2Y6F8NiMz8+zbUHlXbmWP3q2bL DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uphyc03cs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:23:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TGMox2090252
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:23:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uphau27md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:23:57 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TGN3s5028605
        for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2019 16:23:04 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 09:23:03 -0700
Date:   Thu, 29 Aug 2019 09:23:02 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 2/2] xfs: remove all *_ITER_CONTINUE values
Message-ID: <20190829162302.GC5360@magnolia>
References: <20190829162122.GH5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829162122.GH5354@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Iterator functions already use 0 to signal "continue iterating", so get
rid of the #defines and just do it directly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.h  |    2 --
 fs/xfs/libxfs/xfs_rmap.c   |    8 ++++----
 fs/xfs/libxfs/xfs_shared.h |    3 ---
 fs/xfs/xfs_fsmap.c         |    8 ++++----
 fs/xfs/xfs_iwalk.h         |    2 --
 5 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 0099053d2a18..bb2092e340df 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -464,8 +464,6 @@ xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
 unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
 
-/* return codes */
-#define XFS_BTREE_QUERY_RANGE_CONTINUE	(XFS_ITER_CONTINUE) /* keep iterating */
 typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
 		union xfs_btree_rec *rec, void *priv);
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 09644ff2c345..38e9414878b3 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -253,11 +253,11 @@ xfs_rmap_find_left_neighbor_helper(
 			rec->rm_flags);
 
 	if (rec->rm_owner != info->high.rm_owner)
-		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+		return 0;
 	if (!XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
 	    !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK) &&
 	    rec->rm_offset + rec->rm_blockcount - 1 != info->high.rm_offset)
-		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+		return 0;
 
 	*info->irec = *rec;
 	*info->stat = 1;
@@ -329,12 +329,12 @@ xfs_rmap_lookup_le_range_helper(
 			rec->rm_flags);
 
 	if (rec->rm_owner != info->high.rm_owner)
-		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+		return 0;
 	if (!XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
 	    !(rec->rm_flags & XFS_RMAP_BMBT_BLOCK) &&
 	    (rec->rm_offset > info->high.rm_offset ||
 	     rec->rm_offset + rec->rm_blockcount <= info->high.rm_offset))
-		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+		return 0;
 
 	*info->irec = *rec;
 	*info->stat = 1;
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 2bc31c5a0d49..c45acbd3add9 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -177,7 +177,4 @@ struct xfs_ino_geometry {
 	unsigned int	agino_log;	/* #bits for agino in inum */
 };
 
-/* Keep iterating the data structure. */
-#define XFS_ITER_CONTINUE	(0)
-
 #endif /* __XFS_SHARED_H__ */
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 8ab4ab56fa89..d082143feb5a 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -250,7 +250,7 @@ xfs_getfsmap_helper(
 		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
 		if (info->next_daddr < rec_daddr)
 			info->next_daddr = rec_daddr;
-		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+		return 0;
 	}
 
 	/* Are we just counting mappings? */
@@ -259,14 +259,14 @@ xfs_getfsmap_helper(
 			info->head->fmh_entries++;
 
 		if (info->last)
-			return XFS_BTREE_QUERY_RANGE_CONTINUE;
+			return 0;
 
 		info->head->fmh_entries++;
 
 		rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
 		if (info->next_daddr < rec_daddr)
 			info->next_daddr = rec_daddr;
-		return XFS_BTREE_QUERY_RANGE_CONTINUE;
+		return 0;
 	}
 
 	/*
@@ -328,7 +328,7 @@ xfs_getfsmap_helper(
 	rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
 	if (info->next_daddr < rec_daddr)
 		info->next_daddr = rec_daddr;
-	return XFS_BTREE_QUERY_RANGE_CONTINUE;
+	return 0;
 }
 
 /* Transform a rmapbt irec into a fsmap */
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 12dbb3ee1c17..ee2d30ca3226 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -9,8 +9,6 @@
 /* Walk all inodes in the filesystem starting from @startino. */
 typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 			    xfs_ino_t ino, void *data);
-/* Return values for xfs_iwalk_fn. */
-#define XFS_IWALK_CONTINUE	(XFS_ITER_CONTINUE)
 
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		unsigned int flags, xfs_iwalk_fn iwalk_fn,
