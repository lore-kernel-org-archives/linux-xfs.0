Return-Path: <SRS0=vNgo=5K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9DF9C54FD2
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 03:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABF2D20724
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Mar 2020 03:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="viigpSGJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgCYDYx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 23:24:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44440 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgCYDYx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Mar 2020 23:24:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P3Oq0Q065047
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nwTxRI2VD+10RI4rn2Tgsxx3kHanjQgX0qkDgF9gs6k=;
 b=viigpSGJJwttEOHS1RE3X6IVMiTWqYUgAvbHl/UWNUaP3s/5u0KWXYuHcI4HsT6edm1U
 v9+f56+D3orucPLcUFm1tdOSnvrKfpnMoElqtujnt0DzYeY1390KBUH3FZ43LSevvLl6
 daXpbRmCnBzwckSTZXpOFVDFCC89LignjZeQr/wLSK/SSzUSbN0A4mkRdpOlWhvTqxDV
 53WpJ1JSrBAEWvC9QTmO2vf+CY7pK0SkBo8mjoRiHOc0h2yjjQo5mO/dapoDLl5uIbk5
 uo4jGGrUJEphUI1JpBMtzuSlpqfZqTWy3/aecALeuH/7Xt5JtBkfx03ummO+3qsEaJzf ng== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yx8ac4j67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02P3MUtA135156
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2yxw4qkhsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02P3OoO8000656
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2020 03:24:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 24 Mar 2020 20:24:50 -0700
Subject: [PATCH 3/4] xfs: drop all altpath buffers at the end of the sibling
 check
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 24 Mar 2020 20:24:49 -0700
Message-ID: <158510668935.922633.2938909097570009707.stgit@magnolia>
In-Reply-To: <158510667039.922633.6138311243444001882.stgit@magnolia>
References: <158510667039.922633.6138311243444001882.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=3
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9570 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=3 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250028
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The dirattr btree checking code uses the altpath substructure of the
dirattr state structure to check the sibling pointers of dir/attr tree
blocks.  At the end of sibling checks, xfs_da3_path_shift could have
changed multiple levels of buffer pointers in the altpath structure.
Although we release the leaf level buffer, this isn't enough -- we also
need to release the node buffers that are unique to the altpath.

Not releasing all of the altpath buffers leaves them locked to the
transaction.  This is suboptimal because we should release resources
when we don't need them anymore.  Fix the function to loop all levels of
the altpath, and fix the return logic so that we always run the loop.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/dabtree.c |   42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 97a15b6f2865..9a2e27ac1300 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -219,19 +219,21 @@ xchk_da_btree_block_check_sibling(
 	int			direction,
 	xfs_dablk_t		sibling)
 {
+	struct xfs_da_state_path *path = &ds->state->path;
+	struct xfs_da_state_path *altpath = &ds->state->altpath;
 	int			retval;
+	int			plevel;
 	int			error;
 
-	memcpy(&ds->state->altpath, &ds->state->path,
-			sizeof(ds->state->altpath));
+	memcpy(altpath, path, sizeof(ds->state->altpath));
 
 	/*
 	 * If the pointer is null, we shouldn't be able to move the upper
 	 * level pointer anywhere.
 	 */
 	if (sibling == 0) {
-		error = xfs_da3_path_shift(ds->state, &ds->state->altpath,
-				direction, false, &retval);
+		error = xfs_da3_path_shift(ds->state, altpath, direction,
+				false, &retval);
 		if (error == 0 && retval == 0)
 			xchk_da_set_corrupt(ds, level);
 		error = 0;
@@ -239,27 +241,33 @@ xchk_da_btree_block_check_sibling(
 	}
 
 	/* Move the alternate cursor one block in the direction given. */
-	error = xfs_da3_path_shift(ds->state, &ds->state->altpath,
-			direction, false, &retval);
+	error = xfs_da3_path_shift(ds->state, altpath, direction, false,
+			&retval);
 	if (!xchk_da_process_error(ds, level, &error))
-		return error;
+		goto out;
 	if (retval) {
 		xchk_da_set_corrupt(ds, level);
-		return error;
+		goto out;
 	}
-	if (ds->state->altpath.blk[level].bp)
-		xchk_buffer_recheck(ds->sc,
-				ds->state->altpath.blk[level].bp);
+	if (altpath->blk[level].bp)
+		xchk_buffer_recheck(ds->sc, altpath->blk[level].bp);
 
 	/* Compare upper level pointer to sibling pointer. */
-	if (ds->state->altpath.blk[level].blkno != sibling)
+	if (altpath->blk[level].blkno != sibling)
 		xchk_da_set_corrupt(ds, level);
-	if (ds->state->altpath.blk[level].bp) {
-		xfs_trans_brelse(ds->dargs.trans,
-				ds->state->altpath.blk[level].bp);
-		ds->state->altpath.blk[level].bp = NULL;
-	}
+
 out:
+	/* Free all buffers in the altpath that aren't referenced from path. */
+	for (plevel = 0; plevel < altpath->active; plevel++) {
+		if (altpath->blk[plevel].bp == NULL ||
+		    (plevel < path->active &&
+		     altpath->blk[plevel].bp == path->blk[plevel].bp))
+			continue;
+
+		xfs_trans_brelse(ds->dargs.trans, altpath->blk[plevel].bp);
+		altpath->blk[plevel].bp = NULL;
+	}
+
 	return error;
 }
 

