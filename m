Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77985C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47389207FA
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:47:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k1GyEDJ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfKHHrc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:47:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44570 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfKHHrc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:47:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA87jwOT103800;
        Fri, 8 Nov 2019 07:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=NPwQBJFoQZEQUQ5+eyFNXQ6FgwU7PWENSm2ytoBPLc0=;
 b=k1GyEDJ3RPTlJhSDvJsXbjWbOjxs8dGV/D7RucXfGv/xb74oCfrd/Eqe2/Vt4iWEOhBs
 2T2zTrvyGpKi0EhQLpUgMA0ypFabpL3p7puhppogI6ztKNrphL/7+NjBJIS//DzaisV4
 5apoNx/z6dZQNHSneWwOnzhqjY+jxbyaMwAUj2bLxKt6TGxf5hB1+a3MvEUELalqLbxy
 b0rzjW8POGyFg87zZdfp65aZDoWCG5FgmVEd0737XVbU7ADcF0VeW5xEDlM8dz7+ZWD7
 6r/2aGMEPql6I+NI3cG1ZLwwDvbQwxatMUMVe4OlUsoSZa6LsEHCeE02cUQBZCtNDLNP rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2w41w1bk4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:47:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA87jYxh174256;
        Fri, 8 Nov 2019 07:47:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2w50m4f03p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 07:47:26 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA87lPmk012183;
        Fri, 8 Nov 2019 07:47:25 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:47:25 -0800
Date:   Thu, 7 Nov 2019 23:47:24 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
Message-ID: <20191108074724.GR6219@magnolia>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
 <157319670439.834585.6578359830660435523.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157319670439.834585.6578359830660435523.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080076
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
index 8ad153bc4dea..897dfb9e4682 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -716,25 +716,6 @@ xfs_btree_get_bufs(
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
