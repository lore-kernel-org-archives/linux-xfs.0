Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049FEFA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC2692087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:05:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ADKu9aiw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfKHHFC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:05:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39804 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHHFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:05:02 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873bFP042277
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=qkZxUvmJTSQOWwOcGDYYyAG9EYHlM9KDVYdZjO/V3hg=;
 b=ADKu9aiwsBz6MNZtdLHHfQcF9s8+Dz9fPX4ViMZw3OJIqUxEpCXtWLfxSeccq4N7mFdj
 rRiRL1sY87uBbjqgLqeY18Hlm96y2326byu3nZ+6z9ionDMqW21sDYPNZSpRSJDVldXl
 ptGXU78p+gnsOhuJ9Rbdq314BI+2RRzEaJhhm1geMMHaXgV9Y2a/gFQdClvMjwmK3iuc
 SrU3iJfylGkNAZyZTRHRJJfhUh3+e2XQQNpSPxsTlc0ACJqea5jZR38oWpkxU1i8dI0l
 AJe3e/hK0LNL4ABbUIp5tlxSDOwZ8U3mAyu62GZSrWVTR7lGAvR0bmOLRjsCfPOww63J dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2w41w13cb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:05:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873u13182888
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:04:59 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wh0h4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:04:59 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA874xV2018097
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:04:59 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 Nov 2019 07:04:59 +0000
Subject: [PATCH 2/3] xfs: clean up weird while loop in
 xfs_alloc_ag_vextent_near
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 07 Nov 2019 23:04:58 -0800
Message-ID: <157319669798.834585.10287243947050889974.stgit@magnolia>
In-Reply-To: <157319668531.834585.6920821852974178.stgit@magnolia>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the weird while loop out of existence.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |  119 +++++++++++++++++++++++++--------------------
 1 file changed, 66 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 60ca09bedc23..3a724d80783a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1486,6 +1486,65 @@ xfs_alloc_ag_vextent_locality(
 	return 0;
 }
 
+/* Check the last block of the cnt btree for allocations. */
+static int
+xfs_alloc_ag_vextent_lastblock(
+	struct xfs_alloc_arg	*args,
+	struct xfs_alloc_cur	*acur,
+	xfs_agblock_t		*bno,
+	xfs_extlen_t		*len,
+	bool			*allocated)
+{
+	int			error;
+	int			i;
+
+#ifdef DEBUG
+	/* Randomly don't execute the first algorithm. */
+	if (prandom_u32() & 1)
+		return 0;
+#endif
+
+	/*
+	 * Start from the entry that lookup found, sequence through all larger
+	 * free blocks.  If we're actually pointing at a record smaller than
+	 * maxlen, go to the start of this block, and skip all those smaller
+	 * than minlen.
+	 */
+	if (len || args->alignment > 1) {
+		acur->cnt->bc_ptrs[0] = 1;
+		do {
+			error = xfs_alloc_get_rec(acur->cnt, bno, len, &i);
+			if (error)
+				return error;
+			if (XFS_IS_CORRUPT(args->mp, i != 1))
+				return -EFSCORRUPTED;
+			if (*len >= args->minlen)
+				break;
+			error = xfs_btree_increment(acur->cnt, 0, &i);
+			if (error)
+				return error;
+		} while (i);
+		ASSERT(*len >= args->minlen);
+		if (!i)
+			return 0;
+	}
+
+	error = xfs_alloc_walk_iter(args, acur, acur->cnt, true, false, -1, &i);
+	if (error)
+		return error;
+
+	/*
+	 * It didn't work.  We COULD be in a case where there's a good record
+	 * somewhere, so try again.
+	 */
+	if (acur->len == 0)
+		return 0;
+
+	trace_xfs_alloc_near_first(args);
+	*allocated = true;
+	return 0;
+}
+
 /*
  * Allocate a variable extent near bno in the allocation group agno.
  * Extent's length (returned in len) will be between minlen and maxlen,
@@ -1501,14 +1560,6 @@ xfs_alloc_ag_vextent_near(
 	int			i;		/* result code, temporary */
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
-#ifdef DEBUG
-	/*
-	 * Randomly don't execute the first algorithm.
-	 */
-	int		dofirst;	/* set to do first algorithm */
-
-	dofirst = prandom_u32() & 1;
-#endif
 
 	/* handle uninitialized agbno range so caller doesn't have to */
 	if (!args->min_agbno && !args->max_agbno)
@@ -1551,54 +1602,16 @@ xfs_alloc_ag_vextent_near(
 	 * near the right edge of the tree.  If it's in the last btree leaf
 	 * block, then we just examine all the entries in that block
 	 * that are big enough, and pick the best one.
-	 * This is written as a while loop so we can break out of it,
-	 * but we never loop back to the top.
 	 */
-	while (xfs_btree_islastblock(acur.cnt, 0)) {
-#ifdef DEBUG
-		if (dofirst)
-			break;
-#endif
-		/*
-		 * Start from the entry that lookup found, sequence through
-		 * all larger free blocks.  If we're actually pointing at a
-		 * record smaller than maxlen, go to the start of this block,
-		 * and skip all those smaller than minlen.
-		 */
-		if (len || args->alignment > 1) {
-			acur.cnt->bc_ptrs[0] = 1;
-			do {
-				error = xfs_alloc_get_rec(acur.cnt, &bno, &len,
-						&i);
-				if (error)
-					goto out;
-				if (XFS_IS_CORRUPT(args->mp, i != 1))
-					goto out;
-				if (len >= args->minlen)
-					break;
-				error = xfs_btree_increment(acur.cnt, 0, &i);
-				if (error)
-					goto out;
-			} while (i);
-			ASSERT(len >= args->minlen);
-			if (!i)
-				break;
-		}
+	if (xfs_btree_islastblock(acur.cnt, 0)) {
+		bool		allocated = false;
 
-		error = xfs_alloc_walk_iter(args, &acur, acur.cnt, true, false,
-					    -1, &i);
+		error = xfs_alloc_ag_vextent_lastblock(args, &acur, &bno, &len,
+				&allocated);
 		if (error)
 			goto out;
-
-		/*
-		 * It didn't work.  We COULD be in a case where
-		 * there's a good record somewhere, so try again.
-		 */
-		if (acur.len == 0)
-			break;
-
-		trace_xfs_alloc_near_first(args);
-		goto alloc;
+		if (allocated)
+			goto alloc_finish;
 	}
 
 	/*
@@ -1624,7 +1637,7 @@ xfs_alloc_ag_vextent_near(
 		goto out;
 	}
 
-alloc:
+alloc_finish:
 	/* fix up btrees on a successful allocation */
 	error = xfs_alloc_cur_finish(args, &acur);
 

