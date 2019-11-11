Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CDCC17443
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEB002080F
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ie+WnWyB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfKKBSz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 20:18:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:59400 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbfKKBSz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 20:18:55 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1IfUS103186;
        Mon, 11 Nov 2019 01:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=g68DiiaT8O1lk4xUYpV3oDNMtp6Zx6+SjwS6WBflA5Q=;
 b=ie+WnWyBqtBBhhu28/CORuDZ10xNoMYvspQFGsk00414BVtBHz3nftTjbA1JDHKMeYJH
 2bCWH1twSwW0OK6bY5lr/k+9ZeoHBfmKVCpEH4iv84yEC6JPCLgcxdEsyFBXkWxuFt5G
 ADl7vsMNc+BcwpzlQO3Y343WrcXMuRmFLXuLwTAEnq4SLgO6metxL94ozKBozRu8x5AU
 H4n4K7tvFIEC1AZG8SZliH8QqCLzSo0izDXao53rNAZRSHQu/Iq2tfXLPmB4mDnrkDI3
 kN1nGihcWRDi1zA0LNu3kGAdcDe6n1l3zAT7iEyn//MoN4yOcD9x9JyMqHCDUV+hXUC5 kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w5ndpv4k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1IdKV014910;
        Mon, 11 Nov 2019 01:18:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w66wjehmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:40 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAB1IMGe017557;
        Mon, 11 Nov 2019 01:18:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Nov 2019 17:18:22 -0800
Subject: [PATCH 1/3] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Sun, 10 Nov 2019 17:18:21 -0800
Message-ID: <157343510150.1948946.270237649955385275.stgit@magnolia>
In-Reply-To: <157343509505.1948946.5379830250503479422.stgit@magnolia>
References: <157343509505.1948946.5379830250503479422.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Coverity points out that xfs_btree_islastblock doesn't check the return
value of xfs_btree_check_block.  Since the question "Does the cursor
point to the last block in this level?" only makes sense if the caller
previously performed a lookup or seek operation, the block should
already have been checked.

Therefore, check the return value in an ASSERT and turn the whole thing
into a static inline predicate.

Coverity-id: 114069
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   19 -------------------
 fs/xfs/libxfs/xfs_btree.h |   25 +++++++++++++++++--------
 2 files changed, 17 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index feab5b307c45..3d48878ab298 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -714,25 +714,6 @@ xfs_btree_get_bufs(
 	return xfs_trans_get_buf(tp, mp->m_ddev_targp, d, mp->m_bsize, 0);
 }
 
-/*
- * Check for the cursor referring to the last block at the given level.
- */
-int					/* 1=is last block, 0=not last block */
-xfs_btree_islastblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level)	/* level to check */
-{
-	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
-
-	block = xfs_btree_get_block(cur, level, &bp);
-	xfs_btree_check_block(cur, block, level, bp);
-	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
-	else
-		return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
-}
-
 /*
  * Change the cursor to point to the first record at the given level.
  * Other levels are unaffected.
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 6670120cd690..fb9b2121c628 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -317,14 +317,6 @@ xfs_btree_get_bufs(
 	xfs_agnumber_t		agno,	/* allocation group number */
 	xfs_agblock_t		agbno);	/* allocation group block number */
 
-/*
- * Check for the cursor referring to the last block at the given level.
- */
-int					/* 1=is last block, 0=not last block */
-xfs_btree_islastblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level);	/* level to check */
-
 /*
  * Compute first and last byte offsets for the fields given.
  * Interprets the offsets table, which contains struct field offsets.
@@ -524,4 +516,21 @@ int xfs_btree_has_record(struct xfs_btree_cur *cur, union xfs_btree_irec *low,
 		union xfs_btree_irec *high, bool *exists);
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
 
+/* Does this cursor point to the last block in the given level? */
+static inline bool
+xfs_btree_islastblock(
+	xfs_btree_cur_t		*cur,
+	int			level)
+{
+	struct xfs_btree_block	*block;
+	struct xfs_buf		*bp;
+
+	block = xfs_btree_get_block(cur, level, &bp);
+	ASSERT(block && xfs_btree_check_block(cur, block, level, bp) == 0);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
+	return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
+}
+
 #endif	/* __XFS_BTREE_H__ */

