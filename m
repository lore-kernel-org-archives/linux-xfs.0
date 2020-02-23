Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201B1C3567D
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB2AA2071E
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ar4CQPVH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgBWCGH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:07 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgBWCGG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N22YSs180202
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=zdn0LOG4SWHO/VCZNY4VpXVEEHQxS8mFBUrEXZRbHKA=;
 b=Ar4CQPVHnO2bGNaRD3pyT6va7b21+oadiQhSjVZSRRh8y3jx0lqcPn55pE3LSDl7+raN
 J7tGUCIW0MktezVLzrAt5B6blgAQpCpYInlERwmTxfebeHRqdWuNqT8jiNvCcdbZ6qNe
 vX39WqWGov5wDl1dRn7WAxxFq8/5svXIo02v8xR2qkyk/ZX8HmGTSqPyVi3uIuC5uu6m
 yTLb3IxZgUW0BGkVSGMoC1l5ho2kgyVyLZnWmJf9oA/VMiCizpLJAOCfTIK/ApF7u62o
 eNawifaC754nvpkv6TuvV0avu8yoa5RkdQ4hivkFvFE0ozHfOwA8qLTu5+ON4eekdFUv xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxr9yyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1w2hW146339
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2ybdsd6q44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01N264e2028915
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:04 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:04 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 17/20] xfsprogs: Simplify xfs_attr_set_iter
Date:   Sat, 22 Feb 2020 19:05:51 -0700
Message-Id: <20200223020554.1731-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=1 spamscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=1 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Delayed attribute mechanics make frequent use of goto statements.  We can use this
to further simplify xfs_attr_set_iter.  Because states tend to fall between if
conditions, we can invert the if logic and jump to the goto. This helps to reduce
indentation and simplify things.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 72 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index e71099c..0635d8b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -253,6 +253,19 @@ xfs_attr_try_sf_addname(
 }
 
 /*
+ * Check to see if the attr should be upgraded from non-existent or shortform to
+ * single-leaf-block attribute list.
+ */
+static inline bool
+xfs_attr_fmt_needs_update(
+	struct xfs_inode    *dp)
+{
+	return dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
+	      (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	      dp->i_d.di_anextents == 0);
+}
+
+/*
  * Set the attribute specified in @args.
  */
 int
@@ -341,39 +354,40 @@ xfs_attr_set_iter(
 	}
 
 	/*
-	 * If the attribute list is non-existent or a shortform list,
-	 * upgrade it to a single-leaf-block attribute list.
+	 * If the attribute list is already in leaf format, jump straight to
+	 * leaf handling.  Otherwise, try to add the attribute to the shortform
+	 * list; if there's no room then convert the list to leaf format and try
+	 * again.
 	 */
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
-		/*
-		 * Try to add the attr to the attribute list in the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, args);
+	if (!xfs_attr_fmt_needs_update(dp))
+		goto add_leaf;
 
-		/* Should only be 0, -EEXIST or ENOSPC */
-		if (error != -ENOSPC)
-			return error;
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_try_sf_addname(dp, args);
 
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
-		if (error)
-			return error;
+	/* Should only be 0, -EEXIST or ENOSPC */
+	if (error != -ENOSPC)
+		return error;
 
-		/*
-		 * Prevent the leaf buffer from being unlocked so that a
-		 * concurrent AIL push cannot grab the half-baked leaf
-		 * buffer and run into problems with the write verifier.
-		 */
-		xfs_trans_bhold(args->trans, *leaf_bp);
-		args->dac.flags |= XFS_DAC_FINISH_TRANS;
-		args->dac.dela_state = XFS_DAS_ADD_LEAF;
-		return -EAGAIN;
-	}
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.
+	 * GROT: another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	if (error)
+		return error;
+
+	/*
+	 * Prevent the leaf buffer from being unlocked so that a
+	 * concurrent AIL push cannot grab the half-baked leaf
+	 * buffer and run into problems with the write verifier.
+	 */
+	xfs_trans_bhold(args->trans, *leaf_bp);
+	args->dac.flags |= XFS_DAC_FINISH_TRANS;
+	args->dac.dela_state = XFS_DAS_ADD_LEAF;
+	return -EAGAIN;
 
 add_leaf:
 
-- 
2.7.4

