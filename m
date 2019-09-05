Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C969AC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17EDE20692
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:51:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O/B9sAnI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfIEWvK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:51:10 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46300 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfIEWvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:51:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85Mn2vc106366
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:51:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=lDyjioxqXEZ+ZKVeAR1gBCazZkWfEf54cA+eCM7kw8E=;
 b=O/B9sAnI5LL32FFgzjE8kntpRj1ltgdvlnUerc0VCNSK8siLYY45/L/p+3tx67qKPCgz
 N5uPaGxWjmAP1Q9FnnAmbhlk9jjlshHmym7B6lnH0hSApIDTiBKdSgqKuboMwPAopgZm
 vaqQQydQ5OllrIXN5ydq7yXPccyamyMUIvufRzBwjvsWsnuFwx1KA70DICIn2JBqdTaz
 9eKxXbYwHgA8L1fpYukmIXjop8DQZsd5mzolxAqizttVFzfS38SzG7FurTi4VgLY/3aO
 eDVt3XpLFbBEr9+tf6VpOGHdR2h4tCQtwjnK88QN66v4g8Q3UB8zFdXgATYAFL1licOz hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2uubg780ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:51:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85Mn22H187729
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:51:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2uthq28hwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:51:07 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85Mp7c6020769
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:51:07 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:45 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 07/19] xfs: Factor out xfs_attr_leaf_addname helper
Date:   Thu,  5 Sep 2019 15:18:25 -0700
Message-Id: <20190905221837.17388-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221837.17388-1-allison.henderson@oracle.com>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050212
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050212
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor out new helper function xfs_attr_leaf_try_add.
Because new delayed attribute routines cannot roll
transactions, we carve off the parts of
xfs_attr_leaf_addname that we can use.  This will help
to reduce repetitive code later when we introduce
delayed attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7a6dd37..f27e2c6 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -593,19 +593,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
  * External routines when attribute list is one block
  *========================================================================*/
 
-/*
- * Add a name to the leaf attribute list structure
- *
- * This leaf block cannot have a "remote" value, we only call this routine
- * if bmap_one_block() says there is only one block (ie: no remote blks).
- */
 STATIC int
-xfs_attr_leaf_addname(
-	struct xfs_da_args	*args)
+xfs_attr_leaf_try_add(
+	struct xfs_da_args	*args,
+	struct xfs_buf		*bp)
 {
-	struct xfs_buf		*bp;
-	int			retval, error, forkoff;
-	struct xfs_inode	*dp = args->dp;
+	int			retval, error;
 
 	trace_xfs_attr_leaf_addname(args);
 
@@ -650,13 +643,35 @@ xfs_attr_leaf_addname(
 	retval = xfs_attr3_leaf_add(bp, args);
 	if (retval == -ENOSPC) {
 		/*
-		 * Promote the attribute list to the Btree format, then
-		 * Commit that transaction so that the node_addname() call
-		 * can manage its own transactions.
+		 * Promote the attribute list to the Btree format.
 		 */
 		error = xfs_attr3_leaf_to_node(args);
 		if (error)
 			return error;
+	}
+	return retval;
+}
+
+
+/*
+ * Add a name to the leaf attribute list structure
+ *
+ * This leaf block cannot have a "remote" value, we only call this routine
+ * if bmap_one_block() says there is only one block (ie: no remote blks).
+ */
+STATIC int
+xfs_attr_leaf_addname(struct xfs_da_args	*args)
+{
+	int			retval, error, forkoff;
+	struct xfs_buf		*bp = NULL;
+	struct xfs_inode	*dp = args->dp;
+
+	retval = xfs_attr_leaf_try_add(args, bp);
+	if (retval == -ENOSPC) {
+		/*
+		 * Commit that transaction so that the node_addname() call
+		 * can manage its own transactions.
+		 */
 		error = xfs_defer_finish(&args->trans);
 		if (error)
 			return error;
-- 
2.7.4

