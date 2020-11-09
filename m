Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4D6C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4FD42068D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VqaOQOMi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgKISRw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:17:52 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55738 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKISRw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:17:52 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IA3HT120680;
        Mon, 9 Nov 2020 18:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=P7XTAh2fuW8EdqtGCFmvDwZ2pJApiQp0oZCH6AFD5HA=;
 b=VqaOQOMijkpTzKe6IExpKJ6Qg6d2UxpQBPyGxCxHz2m6/GO9Y9hiF/AVmUh0W7AUFiWB
 Cuq63mq9BacJoDSwQTdYTdyF4xdcx1TAjtPNkMo1mXyuSbffYrVRIcm7A70SVuA3QGZy
 HhMlmFxJOo4BpvhC2dq+C6NVpkHm12GbJA2/S/++bnEZhGRzOWC3Q6bYTbavpFs45+1y
 xq9kCQ9Kw8l2JdhAXjhkcnptAz/MldugHeZdLpkS+dTFAN6vXX1YQAPkx1X57aGZ+Ooe
 gc8EfFVpBGyrTKwJQdKvdso7yznIXaSOJslbCzeCNLsvQOGkcEo4h/vtwrhoLcqYZ2gu 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34nh3aqna6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:17:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IB2A9136975;
        Mon, 9 Nov 2020 18:17:47 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34p5bqv1t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:17:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A9IHk4i019887;
        Mon, 9 Nov 2020 18:17:46 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:17:46 -0800
Subject: [PATCH 2/4] xfs: fix the minrecs logic when dealing with inode root
 child blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 09 Nov 2020 10:17:45 -0800
Message-ID: <160494586556.772802.12631379595730474933.stgit@magnolia>
In-Reply-To: <160494585293.772802.13326482733013279072.stgit@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=1
 mlxlogscore=999 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The comment and logic in xchk_btree_check_minrecs for dealing with
inode-rooted btrees isn't quite correct.  While the direct children of
the inode root are allowed to have fewer records than what would
normally be allowed for a regular ondisk btree block, this is only true
if there is only one child block and the number of records don't fit in
the inode root.

Fixes: 08a3a692ef58 ("xfs: btree scrub should check minrecs")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/btree.c |   45 +++++++++++++++++++++++++++------------------
 1 file changed, 27 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index f52a7b8256f9..debf392e0515 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -452,32 +452,41 @@ xchk_btree_check_minrecs(
 	int			level,
 	struct xfs_btree_block	*block)
 {
-	unsigned int		numrecs;
-	int			ok_level;
-
-	numrecs = be16_to_cpu(block->bb_numrecs);
+	struct xfs_btree_cur	*cur = bs->cur;
+	unsigned int		root_level = cur->bc_nlevels - 1;
+	unsigned int		numrecs = be16_to_cpu(block->bb_numrecs);
 
 	/* More records than minrecs means the block is ok. */
-	if (numrecs >= bs->cur->bc_ops->get_minrecs(bs->cur, level))
+	if (numrecs >= cur->bc_ops->get_minrecs(cur, level))
 		return;
 
 	/*
-	 * Certain btree blocks /can/ have fewer than minrecs records.  Any
-	 * level greater than or equal to the level of the highest dedicated
-	 * btree block are allowed to violate this constraint.
-	 *
-	 * For a btree rooted in a block, the btree root can have fewer than
-	 * minrecs records.  If the btree is rooted in an inode and does not
-	 * store records in the root, the direct children of the root and the
-	 * root itself can have fewer than minrecs records.
+	 * For btrees rooted in the inode, it's possible that the root block
+	 * contents spilled into a regular ondisk block because there wasn't
+	 * enough space in the inode root.  The number of records in that
+	 * child block might be less than the standard minrecs, but that's ok
+	 * provided that there's only one direct child of the root.
 	 */
-	ok_level = bs->cur->bc_nlevels - 1;
-	if (bs->cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
-		ok_level--;
-	if (level >= ok_level)
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == cur->bc_nlevels - 2) {
+		struct xfs_btree_block	*root_block;
+		struct xfs_buf		*root_bp;
+		int			root_maxrecs;
+
+		root_block = xfs_btree_get_block(cur, root_level, &root_bp);
+		root_maxrecs = cur->bc_ops->get_dmaxrecs(cur, root_level);
+		if (be16_to_cpu(root_block->bb_numrecs) != 1 ||
+		    numrecs <= root_maxrecs)
+			xchk_btree_set_corrupt(bs->sc, cur, level);
 		return;
+	}
 
-	xchk_btree_set_corrupt(bs->sc, bs->cur, level);
+	/*
+	 * Otherwise, only the root level is allowed to have fewer than minrecs
+	 * records or keyptrs.
+	 */
+	if (level < root_level)
+		xchk_btree_set_corrupt(bs->sc, cur, level);
 }
 
 /*

