Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F96FFC6194
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0EDB2077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:02:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sH9uQWrl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733054AbfKGDCr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:02:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57060 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDCr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:02:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72x78l039092
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IkmSM2Pw4ALD1wVDrYi7fD5sZHEFZEOGNbOe/VNUxdU=;
 b=sH9uQWrlC8OL1nfgt7Ue2jmK97JaojHLxQQvLF6clAcDV8ANyZFxyXvrYBHjzhs6oKdS
 0oOt/njTWe9cOhPpNIMH9dpyBD0ruHCBjClIC33A/nzkcQ6b1riQNRqO2e+etMRyzwYn
 LQDDInGREr8DOiqrSfoAbEoHA16WLLkmbYV4GOD5E/VNjSI/xJFnX24XjbPE/UjLWjuJ
 0P8GSahEHC5Pq6TREi5N0b4sQOJd2A4yogfWWNoRWcs1+UZ8aYeci5c0JsieKE1yF/Kh
 PXjtri/eJyiQszuKYCEUhCVYfRgurAkYQX3drhZepNAwDl+ou0iPuJHVKLG+Fk+F3X88 yA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w41w0u0hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wKXu052109
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w41wfsnyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA732iio028893
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:02:43 -0800
Subject: [PATCH 3/6] xfs: actually check xfs_btree_check_block return in
 xfs_btree_islastblock
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:02:42 -0800
Message-ID: <157309576284.46520.16933998796526579184.stgit@magnolia>
In-Reply-To: <157309573874.46520.18107298984141751739.stgit@magnolia>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
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
 fs/xfs/libxfs/xfs_alloc.c |    6 +++++-
 fs/xfs/libxfs/xfs_btree.c |   17 +++++++++++------
 fs/xfs/libxfs/xfs_btree.h |    5 +++--
 3 files changed, 19 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f7a4b54c5bc2..f609e1ab14d4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1479,6 +1479,7 @@ xfs_alloc_ag_vextent_near(
 	int			i;		/* result code, temporary */
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
+	bool			is_last;
 #ifdef DEBUG
 	/*
 	 * Randomly don't execute the first algorithm.
@@ -1532,7 +1533,10 @@ xfs_alloc_ag_vextent_near(
 	 * This is written as a while loop so we can break out of it,
 	 * but we never loop back to the top.
 	 */
-	while (xfs_btree_islastblock(acur.cnt, 0)) {
+	error = xfs_btree_islastblock(acur.cnt, 0, &is_last);
+	if (error)
+		goto out;
+	while (is_last) {
 #ifdef DEBUG
 		if (dofirst)
 			break;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 98843f1258b8..098abfb50252 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -719,20 +719,25 @@ xfs_btree_get_bufs(
 /*
  * Check for the cursor referring to the last block at the given level.
  */
-int					/* 1=is last block, 0=not last block */
+int
 xfs_btree_islastblock(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level)	/* level to check */
+	int			level,	/* level to check */
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
index 6670120cd690..ff54e6c18c44 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -320,10 +320,11 @@ xfs_btree_get_bufs(
 /*
  * Check for the cursor referring to the last block at the given level.
  */
-int					/* 1=is last block, 0=not last block */
+int
 xfs_btree_islastblock(
 	xfs_btree_cur_t		*cur,	/* btree cursor */
-	int			level);	/* level to check */
+	int			level,	/* level to check */
+	bool			*last);
 
 /*
  * Compute first and last byte offsets for the fields given.

