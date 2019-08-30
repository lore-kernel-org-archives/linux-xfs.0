Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A260AC3A59F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63F1721874
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 00:30:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AhiH2azn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfH3Aab (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:30:31 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbfH3Aab (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 20:30:31 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U0T4oX120596;
        Fri, 30 Aug 2019 00:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ImZnysJ94ab5HaVdbmA+mF+yT+XBXRy1YwWOfXVPTns=;
 b=AhiH2aznRZb/od9RcR/dEi2Yri5vkdur9iO4pPfwgNZxebAtovsNYkjJguCSj/WylIOX
 BQ7Cv+40S9GtXsgUVt/G/AeG0XeUrPtBs11rKrg6A9v4qySJkGA5lfK6XDmSD2uxGjs+
 qS1j5XYk/K4xTM5VYNoa+NF8YVrS/yT+PaUHEw1YsjsjeuXdfebrpP1h2I0VqmWiYMwp
 9/G8lSvy40cvWubShqETeqRK3Nb0pJs8jiA0sn9xeIzj25MM1lM0QM8nQRmW7pkmStxg
 qJdc8++6zUJDr0O+mVZK+pMaHKlPwu7bxXNThhDy6/F+6EnMzMTYRqAp15+n51kUvO4Z 7g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2ups9k808x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 00:30:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7U0NgSV097672;
        Fri, 30 Aug 2019 00:30:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uphauf2v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 00:30:28 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7U0USwP007285;
        Fri, 30 Aug 2019 00:30:28 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 17:30:28 -0700
Date:   Thu, 29 Aug 2019 17:30:28 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: remove all *_ITER_CONTINUE values
Message-ID: <20190830003028.GV5354@magnolia>
References: <20190830002554.GT5354@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830002554.GT5354@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Iterator functions already use 0 to signal "continue iterating", so get
rid of the #defines and just do it directly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.h  |    1 -
 fs/xfs/libxfs/xfs_rmap.c   |    8 ++++----
 fs/xfs/libxfs/xfs_shared.h |    3 ---
 fs/xfs/xfs_fsmap.c         |    8 ++++----
 fs/xfs/xfs_iwalk.h         |    2 --
 5 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 326cf2a43f0d..ced1e65d1483 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -471,7 +471,6 @@ unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
  * used to stop iteration, because _query_range never generates that error
  * code on its own.
  */
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
index 742360d51378..37a795f03267 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -17,8 +17,6 @@
 /* Walk all inodes in the filesystem starting from @startino. */
 typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 			    xfs_ino_t ino, void *data);
-/* Return values for xfs_iwalk_fn. */
-#define XFS_IWALK_CONTINUE	(XFS_ITER_CONTINUE)
 
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		unsigned int flags, xfs_iwalk_fn iwalk_fn,
