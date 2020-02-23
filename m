Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A60C35679
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40C5820702
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cp0dr7va"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgBWCGZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbgBWCGY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N25DrY010941
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=3+xYf5yFDi42RaeameOE6sdPruW4xGA8x47NmrV7qQo=;
 b=cp0dr7vanLVVWsXvki8xA37awXPjxZ44ztKxGcUiVWl/jUb12GoD1W/X3F3r7qiuFDzd
 KuqUcZQ/tQ2NaTUc6IQ3iz3nr/+9vQhwb5cSO0ol5ddiLJRApKVijAI3X4Ev/1BS86z4
 oJhe3LsQtHyNcbd8t3lEk5JXP89J8KhCcSJtUTgeA7BBt7lILvrVbWonVZhk2v5oXfWV
 tU5tCiMJuTsIS7Pv/klNaCqaU9M41ct3/SXKux7vqLEmyaAt1W3DUL3BmIqRWmcU5NRQ
 nin3b0L9ejxSVw57NAGmBUz5wm82z3sApT3ek/v41voVoG5jUFzn3MknSpLVrDAzYNtz Qg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yav8qa0t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1x3Oq055128
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2ybe38mevh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:23 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01N26NKI031488
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:23 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:23 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 16/19] xfs: Simplify xfs_attr_set_iter
Date:   Sat, 22 Feb 2020 19:06:08 -0700
Message-Id: <20200223020611.1802-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020611.1802-1-allison.henderson@oracle.com>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 impostorscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
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
 fs/xfs/libxfs/xfs_attr.c | 71 ++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 30a16fe..dd935ff 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -254,6 +254,19 @@ xfs_attr_try_sf_addname(
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
@@ -342,40 +355,40 @@ xfs_attr_set_iter(
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
+	if (!xfs_attr_fmt_needs_update(dp))
+		goto add_leaf;
 
-		/*
-		 * Try to add the attr to the attribute list in the inode.
-		 */
-		error = xfs_attr_try_sf_addname(dp, args);
+	/*
+	 * Try to add the attr to the attribute list in the inode.
+	 */
+	error = xfs_attr_try_sf_addname(dp, args);
 
-		/* Should only be 0, -EEXIST or ENOSPC */
-		if (error != -ENOSPC)
-			return error;
+	/* Should only be 0, -EEXIST or ENOSPC */
+	if (error != -ENOSPC)
+		return error;
 
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		error = xfs_attr_shortform_to_leaf(args, leaf_bp);
-		if (error)
-			return error;
+	/*
+	 * It won't fit in the shortform, transform to a leaf block.
+	 * GROT: another possible req'mt for a double-split btree op.
+	 */
+	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
+	if (error)
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

