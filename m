Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7132CC6369E
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 19:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CDE32225E
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 19:17:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gsqs4JIk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbgKNTRA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 14 Nov 2020 14:17:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60038 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgKNTRA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Nov 2020 14:17:00 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJE8CZ051388;
        Sat, 14 Nov 2020 19:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=gWHIWltZfdyknjvjREM34lW5x+ecb05toEmFj5/42u8=;
 b=gsqs4JIkOMNbJtzwA2oeFWY+gzxF9g0AqfxWEkU210LuMK2jVqlry55FvrlHyCrAypk3
 CzzEx4mp2hT2iJ8iPqB9d+3yvcoL+AB90LKTD6KlyZeDpTXIoPN4x6ZWOfHD7JdQBzht
 KSVXyWdtFrfBs1r9eVWr8KpDQKBleQzeJAtErqfJW+WPM0zihJX0UufIG9qqw7pKq/2O
 FGd0sNOc1Ycjx5bbk0yXtshAUrzXKk2zazmyBmJh+SKD+V1yx7pk7EwBOhesz3jLLnis
 DGn5qqcLSqtVgN5GME+xzBJiT89S1FS7HCNiJ0ZiaZ0VJxDo6IItWRWM4hLc5aBz2ixs Rg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34t76kh5ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 19:16:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AEJ6LZY117082;
        Sat, 14 Nov 2020 19:14:48 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34t4bt2x5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 19:14:48 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AEJElo7008567;
        Sat, 14 Nov 2020 19:14:47 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 14 Nov 2020 11:14:47 -0800
Date:   Sat, 14 Nov 2020 11:14:46 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH] xfs: ensure inobt record walks always make forward progress
Message-ID: <20201114191446.GR9695@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011140127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9805 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011140128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The aim of the inode btree record iterator function is to call a
callback on every record in the btree.  To avoid having to tear down and
recreate the inode btree cursor around every callback, it caches a
certain number of records in a memory buffer.  After each batch of
callback invocations, we have to perform a btree lookup to find the
next record after where we left off.

However, if the keys of the inode btree are corrupt, the lookup might
put us in the wrong part of the inode btree, causing the walk function
to loop forever.  Therefore, we add extra cursor tracking to make sure
that we never go backwards neither when performing the lookup nor when
jumping to the next inobt record.  This also fixes an off by one error
where upon resume the lookup should have been for the inode /after/ the
point at which we stopped.

Found by fuzzing xfs/460 with keys[2].startino = ones causing bulkstat
and quotacheck to hang.

Fixes: a211432c27ff ("xfs: create simplified inode walk function")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |   26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 233dcc8784db..889ed867670c 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -55,6 +55,9 @@ struct xfs_iwalk_ag {
 	/* Where do we start the traversal? */
 	xfs_ino_t			startino;
 
+	/* What was the last inode number we saw when iterating the inobt? */
+	xfs_ino_t			lastino;
+
 	/* Array of inobt records we cache. */
 	struct xfs_inobt_rec_incore	*recs;
 
@@ -214,6 +217,8 @@ xfs_iwalk_ag_recs(
 				return error;
 		}
 	}
+	iwag->lastino = XFS_AGINO_TO_INO(mp, agno,
+				irec->ir_startino + XFS_INODES_PER_CHUNK - 1);
 
 	return 0;
 }
@@ -347,15 +352,17 @@ xfs_iwalk_run_callbacks(
 	struct xfs_mount		*mp = iwag->mp;
 	struct xfs_trans		*tp = iwag->tp;
 	struct xfs_inobt_rec_incore	*irec;
-	xfs_agino_t			restart;
+	xfs_agino_t			next_agino;
 	int				error;
 
+	next_agino = XFS_INO_TO_AGINO(mp, iwag->lastino) + 1;
+
 	ASSERT(iwag->nr_recs > 0);
 
 	/* Delete cursor but remember the last record we cached... */
 	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
 	irec = &iwag->recs[iwag->nr_recs - 1];
-	restart = irec->ir_startino + XFS_INODES_PER_CHUNK - 1;
+	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
 
 	error = xfs_iwalk_ag_recs(iwag);
 	if (error)
@@ -372,7 +379,7 @@ xfs_iwalk_run_callbacks(
 	if (error)
 		return error;
 
-	return xfs_inobt_lookup(*curpp, restart, XFS_LOOKUP_GE, has_more);
+	return xfs_inobt_lookup(*curpp, next_agino, XFS_LOOKUP_GE, has_more);
 }
 
 /* Walk all inodes in a single AG, from @iwag->startino to the end of the AG. */
@@ -396,6 +403,7 @@ xfs_iwalk_ag(
 
 	while (!error && has_more) {
 		struct xfs_inobt_rec_incore	*irec;
+		xfs_ino_t			rec_fsino;
 
 		cond_resched();
 		if (xfs_pwork_want_abort(&iwag->pwork))
@@ -407,6 +415,15 @@ xfs_iwalk_ag(
 		if (error || !has_more)
 			break;
 
+		/* Make sure that we always move forward. */
+		rec_fsino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino);
+		if (iwag->lastino != NULLFSINO &&
+		    XFS_IS_CORRUPT(mp, iwag->lastino >= rec_fsino)) {
+			error = -EFSCORRUPTED;
+			goto out;
+		}
+		iwag->lastino = rec_fsino + XFS_INODES_PER_CHUNK - 1;
+
 		/* No allocated inodes in this chunk; skip it. */
 		if (iwag->skip_empty && irec->ir_freecount == irec->ir_count) {
 			error = xfs_btree_increment(cur, 0, &has_more);
@@ -535,6 +552,7 @@ xfs_iwalk(
 		.trim_start	= 1,
 		.skip_empty	= 1,
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
+		.lastino	= NULLFSINO,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
@@ -623,6 +641,7 @@ xfs_iwalk_threaded(
 		iwag->data = data;
 		iwag->startino = startino;
 		iwag->sz_recs = xfs_iwalk_prefetch(inode_records);
+		iwag->lastino = NULLFSINO;
 		xfs_pwork_queue(&pctl, &iwag->pwork);
 		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
 		if (flags & XFS_INOBT_WALK_SAME_AG)
@@ -696,6 +715,7 @@ xfs_inobt_walk(
 		.startino	= startino,
 		.sz_recs	= xfs_inobt_walk_prefetch(inobt_records),
 		.pwork		= XFS_PWORK_SINGLE_THREADED,
+		.lastino	= NULLFSINO,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
