Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC767C0030D
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5BFD2082C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y+clV//p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391120AbfIEWTQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33298 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391175AbfIEWTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ7sW078079
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=JgeD706XlKfcYp3CXrJKux6J/UfjZb6X5EsWv93MEso=;
 b=Y+clV//puOCsH1+ohhWcepEkQndZ71a6JvNH2oVeGj12O36toxuJ4w//WZmGIoaa52/S
 gxoaJRsk0M5sLV64cYFzeaUF0VTewltIBU4tZXDfAO0PgSD+TYXxkJGFBfT9k7A7QPz9
 O10DaMzXgLjKfWrWLGAbSDqGZHId+r30ikmSoxMaI/DnFQXGdywBKQpmRzSsYQ1lIWqj
 96Af0FguIDU/5VUe2dKP2MBj2orwcH3yxl2CrsnJW86SzUsj89ys/BdB54+gx9IdQeo5
 c9C0l0FEA0actDSiFcy5LkmrB9/9mZje7J8mRJttm3BxMveZxn7lvhP/X1PoY+KFCmTg cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uuaqj02nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ5iw076683
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2utvr4a0yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:07 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x85MJ3se032558
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:03 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:02 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 10/21] xfsprogs: Add xfs_attr3_leaf helper functions
Date:   Thu,  5 Sep 2019 15:18:44 -0700
Message-Id: <20190905221855.17555-11-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

And new helper functions xfs_attr3_leaf_flag_is_set and
xfs_attr3_leaf_flagsflipped.  These routines check to see
if xfs_attr3_leaf_setflag or xfs_attr3_leaf_flipflags have
already been run.  We will need this later for delayed
attributes since routines may be recalled several times
when -EAGAIN is returned.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr_leaf.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_attr_leaf.h |  2 ++
 2 files changed, 86 insertions(+)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 5131355..b540ba9 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2731,6 +2731,36 @@ xfs_attr3_leaf_clearflag(
 }
 
 /*
+ * Check if the INCOMPLETE flag on an entry in a leaf block is set.
+ */
+int
+xfs_attr3_leaf_flag_is_set(
+	struct xfs_da_args		*args,
+	bool				*isset)
+{
+	struct xfs_attr_leafblock	*leaf;
+	struct xfs_attr_leaf_entry	*entry;
+	struct xfs_buf			*bp;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
+
+	trace_xfs_attr_leaf_setflag(args);
+
+	/*
+	 * Set up the operation.
+	 */
+	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp);
+	if (error)
+		return error;
+
+	leaf = bp->b_addr;
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
+
+	*isset = ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
+	return 0;
+}
+
+/*
  * Set the INCOMPLETE flag on an entry in a leaf block.
  */
 int
@@ -2892,3 +2922,57 @@ xfs_attr3_leaf_flipflags(
 
 	return error;
 }
+
+/*
+ * On a leaf entry, check to see if the INCOMPLETE flag is cleared
+ * in args->blkno/index and set in args->blkno2/index2.
+ * Note that they could be in different blocks, or in the same block.
+ *
+ * isflipped is set to true if flags are flipped or false otherwise
+ */
+int
+xfs_attr3_leaf_flagsflipped(
+	struct xfs_da_args		*args,
+	bool				*isflipped)
+{
+	struct xfs_attr_leafblock	*leaf1;
+	struct xfs_attr_leafblock	*leaf2;
+	struct xfs_attr_leaf_entry	*entry1;
+	struct xfs_attr_leaf_entry	*entry2;
+	struct xfs_buf			*bp1;
+	struct xfs_buf			*bp2;
+	struct xfs_inode		*dp = args->dp;
+	int				error = 0;
+
+	trace_xfs_attr_leaf_flipflags(args);
+
+	/*
+	 * Read the block containing the "old" attr
+	 */
+	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp1);
+	if (error)
+		return error;
+
+	/*
+	 * Read the block containing the "new" attr, if it is different
+	 */
+	if (args->blkno2 != args->blkno) {
+		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
+					   -1, &bp2);
+		if (error)
+			return error;
+	} else {
+		bp2 = bp1;
+	}
+
+	leaf1 = bp1->b_addr;
+	entry1 = &xfs_attr3_leaf_entryp(leaf1)[args->index];
+
+	leaf2 = bp2->b_addr;
+	entry2 = &xfs_attr3_leaf_entryp(leaf2)[args->index2];
+
+	*isflipped = (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&
+		      (entry2->flags & XFS_ATTR_INCOMPLETE));
+
+	return 0;
+}
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 58e9327..d82229b 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -57,7 +57,9 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
 				   struct xfs_da_args *args, int forkoff);
 int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
 int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flag_is_set(struct xfs_da_args *args, bool *isset);
 int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
+int	xfs_attr3_leaf_flagsflipped(struct xfs_da_args *args, bool *isflipped);
 
 /*
  * Routines used for growing the Btree.
-- 
2.7.4

