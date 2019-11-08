Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BCBDFA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D1182087E
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 07:07:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JOpesC0D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfKHHHI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 02:07:08 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41790 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbfKHHHI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 02:07:08 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873oqh055317
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:07:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=t92JkwexzfJ6CeuUhAi5Dobv7Q6G4f2Xouhgn7uUu88=;
 b=JOpesC0DwhKuJ5JKN8laMHOGASchbAjlxCjfLojYPHzE+6VrbH4z1MhA4koycg4LHdwv
 50eBdeYxQ8E9dkMdEu22AyZL7FRd2GHKOOo7rcwOodh3sicBalahba1Z7grCb3jeCRVL
 YdL95XRms1Kf34Vk4G/saSfqJhnUoDVQCvWq695D26cMIXkhyVjjosM4rHCKQKA0iSJ2
 NAnxZwZwhQXZpouonhyciJXy3B0+XFrRAWJw8wZvJ1/GiAD9xgwGJUqHvSoCBvxbNleK
 /2U3FwzdqrYblpbBgKh5cxgPEyw/tVcWL5wf+n2TkZ00p0n3JbIcRTgPxnIsMPkOMc0o IQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w13bt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:07:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA873Xpw061282
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:05:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w41wbxemu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Nov 2019 07:05:06 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA87555j020013
        for <linux-xfs@vger.kernel.org>; Fri, 8 Nov 2019 07:05:05 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 23:05:05 -0800
Subject: [PATCH 3/3] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 07 Nov 2019 23:05:04 -0800
Message-ID: <157319670439.834585.6578359830660435523.stgit@magnolia>
In-Reply-To: <157319668531.834585.6920821852974178.stgit@magnolia>
References: <157319668531.834585.6920821852974178.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080069
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Coverity points out that xfs_btree_islastblock calls
xfs_btree_check_block, but doesn't act on an error return.  This
predicate has no answer if the btree is corrupt, so tweak the helper to
be able to return errors, and then modify the one call site.

Coverity-id: 114069
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    7 ++++++-
 fs/xfs/libxfs/xfs_btree.c |   19 ++++++++++++-------
 fs/xfs/libxfs/xfs_btree.h |    7 ++++---
 3 files changed, 22 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 3a724d80783a..65d870189548 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1560,6 +1560,7 @@ xfs_alloc_ag_vextent_near(
 	int			i;		/* result code, temporary */
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
+	bool			is_last;
 
 	/* handle uninitialized agbno range so caller doesn't have to */
 	if (!args->min_agbno && !args->max_agbno)
@@ -1603,7 +1604,11 @@ xfs_alloc_ag_vextent_near(
 	 * block, then we just examine all the entries in that block
 	 * that are big enough, and pick the best one.
 	 */
-	if (xfs_btree_islastblock(acur.cnt, 0)) {
+	error = xfs_btree_islastblock(acur.cnt, 0, &is_last);
+	if (error)
+		goto out;
+
+	if (is_last) {
 		bool		allocated = false;
 
 		error = xfs_alloc_ag_vextent_lastblock(args, &acur, &bno, &len,
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 8ad153bc4dea..37b4fa93085c 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -719,20 +719,25 @@ xfs_btree_get_bufs(
 /*
  * Check for the cursor referring to the last block at the given level.
  */
-int					/* 1=is last block, 0=not last block */
+int
 xfs_btree_islastblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level)	/* level to check */
+	xfs_btree_cur_t		*cur,
+	int			level,
+	bool			*last)
 {
 	struct xfs_btree_block	*block;	/* generic btree block pointer */
-	xfs_buf_t		*bp;	/* buffer containing block */
+	struct xfs_buf		*bp;	/* buffer containing block */
+	int			error;
 
 	block = xfs_btree_get_block(cur, level, &bp);
-	xfs_btree_check_block(cur, block, level, bp);
+	error = xfs_btree_check_block(cur, block, level, bp);
+	if (error)
+		return error;
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
-		return block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
+		*last = block->bb_u.l.bb_rightsib == cpu_to_be64(NULLFSBLOCK);
 	else
-		return block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
+		*last = block->bb_u.s.bb_rightsib == cpu_to_be32(NULLAGBLOCK);
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 6670120cd690..c63da9dd05cc 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -320,10 +320,11 @@ xfs_btree_get_bufs(
 /*
  * Check for the cursor referring to the last block at the given level.
  */
-int					/* 1=is last block, 0=not last block */
+int
 xfs_btree_islastblock(
-	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level);	/* level to check */
+	xfs_btree_cur_t		*cur,
+	int			level,
+	bool			*last);
 
 /*
  * Compute first and last byte offsets for the fields given.

