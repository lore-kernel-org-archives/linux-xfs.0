Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878DEFC6199
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D23421848
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:28:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lfai67Ps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfKGB26 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:28:58 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37384 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728714AbfKGB25 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:28:57 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71Sucm180197
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=S1BlWNpXRKXUjkuQPkOfjJ+8855/BtXQdvdSZGzwIfo=;
 b=Lfai67PsdEOHLsm5SnivnD9BuuGM8lNOJPHzT7f3csmGBXnn33v0pARt1sBKtGHA6v6t
 hgKPXPDsm5pEwFBYtOAvOf0nn1gZ8iPYBVnVWdVH3GZMllfsmOH/RBffF1jY1vBqhnfk
 /42NenQ49wLlsFIzCiNcZWM5M5HR43BA1p8rv+St5EX8wbK5tv8FvUlIDuSuxwTkOsAh
 wybY8267acQ5B/468Wz3RViczwtOMlKMQTUSLJb8eNJYPNqjTHfUWEw7tOr/d6qEnWBS
 YL5qzBmKYRIPP3UyWtv7AHv4YoXs87ZnRgGhAMGklZ/Wt6h0+clEmiVhCIWHdccwXtDh 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w41w12puc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:56 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SqPV174272
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w41w8eumn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:28:54 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA71SmLt031921
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:28:48 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:28:47 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 11/17] xfs: Add xfs_attr3_leaf helper functions
Date:   Wed,  6 Nov 2019 18:27:55 -0700
Message-Id: <20191107012801.22863-12-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012801.22863-1-allison.henderson@oracle.com>
References: <20191107012801.22863-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070014
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
 fs/xfs/libxfs/xfs_attr_leaf.c | 94 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 +
 2 files changed, 96 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 42c037e..023c616 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2809,6 +2809,40 @@ xfs_attr3_leaf_clearflag(
 }
 
 /*
+ * Check if the INCOMPLETE flag on an entry in a leaf block is set.  This
+ * function can be used to check if xfs_attr3_leaf_setflag has already been
+ * called.  The INCOMPLETE flag is used during attr rename operations to mark
+ * entries that are being renamed. Since renames should be atomic, only one of
+ * them should appear as a completed attribute.
+ *
+ * isset is set to true if the flag is set or false otherwise
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
+	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp);
+	if (error)
+		return error;
+
+	leaf = bp->b_addr;
+	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
+
+	*isset = ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
+	xfs_trans_brelse(args->trans, bp);
+
+	return 0;
+}
+
+/*
  * Set the INCOMPLETE flag on an entry in a leaf block.
  */
 int
@@ -2972,3 +3006,63 @@ xfs_attr3_leaf_flipflags(
 
 	return error;
 }
+
+/*
+ * On a leaf entry, check to see if the INCOMPLETE flag is cleared
+ * in args->blkno/index and set in args->blkno2/index2.  Note that they could be
+ * in different blocks, or in the same block.  This function can be used to
+ * check if xfs_attr3_leaf_flipflags has already been called.  The INCOMPLETE
+ * flag is used during attr rename operations to mark entries that are being
+ * renamed. Since renames should be atomic, only one of them should appear as a
+ * completed attribute.
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
+	/*
+	 * Read the block containing the "old" attr
+	 */
+	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno,
+				    XFS_DABUF_MAP_NOMAPPING, &bp1);
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
+	xfs_trans_brelse(args->trans, bp1);
+	xfs_trans_brelse(args->trans, bp2);
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index e108b37..12283cf 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
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

