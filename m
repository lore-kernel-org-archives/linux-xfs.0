Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD53C35674
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 118EE21741
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gaEpTxuX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgBWCGF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:05 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:45978 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgBWCGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:04 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N22V2d180074
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4uXZaTfC+xSruWapeRW85nuzhMnDHYmwymON1sltl7s=;
 b=gaEpTxuXH3ws5NYP6bJVBQu8DpfGXMfW4Oox2UYen6UUrk+BlxRhojLt+p/2vaneoW3h
 o5Lxq74NvHuh2CaCjQoY1g0RJAsrcJLu2p6R1cpX6dcd2geWD/8eTUos/4MRrlksRolP
 vzyhAJU0e+/5YULD2cHhvbgm2wqqp3R2JELjgmfzUKejkQSMG1WvgHKnDp0riZqg9din
 z91nMEJ9svyct3x0ElFL8oFjIn3ltsAezggwHQJi6cV3HP62PAcqg6vjr4xX4R5jPRVc
 OzAtFX4KmiqBoIhwDPsoB1F7cdiJMD/9CbDK3+ymfx3NEjmD4duis//jLzFLZd/55pVQ ew== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2yavxr9yyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1w54B146404
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ybdsd6q1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01N261kn004461
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:01 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 06/20] xfsprogs: Factor out new helper functions xfs_attr_rmtval_set
Date:   Sat, 22 Feb 2020 19:05:40 -0700
Message-Id: <20200223020554.1731-7-allison.henderson@oracle.com>
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

Break xfs_attr_rmtval_set into two helper functions xfs_attr_rmt_find_hole and
xfs_attr_rmtval_set_value. xfs_attr_rmtval_set rolls the transaction between the
helpers, but delayed operations cannot.  We will use the helpers later when
constructing new delayed attribute routines.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr_remote.c | 149 +++++++++++++++++++++++++++++------------------
 1 file changed, 92 insertions(+), 57 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 0cadc82..edd6e90 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -422,32 +422,23 @@ xfs_attr_rmtval_get(
 }
 
 /*
- * Write the value associated with an attribute into the out-of-line buffer
- * that we have defined for it.
+ * Find a "hole" in the attribute address space large enough for us to drop the
+ * new attribute's value into
  */
-int
-xfs_attr_rmtval_set(
+STATIC int
+xfs_attr_rmt_find_hole(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
-	struct xfs_bmbt_irec	map;
-	xfs_dablk_t		lblkno;
-	xfs_fileoff_t		lfileoff = 0;
-	uint8_t			*src = args->value;
-	int			blkcnt;
-	int			valuelen;
-	int			nmap;
 	int			error;
-	int			offset = 0;
-
-	trace_xfs_attr_rmtval_set(args);
+	int			blkcnt;
+	xfs_fileoff_t		lfileoff = 0;
 
 	/*
-	 * Find a "hole" in the attribute address space large enough for
-	 * us to drop the new attribute's value into. Because CRC enable
-	 * attributes have headers, we can't just do a straight byte to FSB
-	 * conversion and have to take the header space into account.
+	 * Because CRC enable attributes have headers, we can't just do a
+	 * straight byte to FSB conversion and have to take the header space
+	 * into account.
 	 */
 	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
 	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
@@ -455,48 +446,26 @@ xfs_attr_rmtval_set(
 	if (error)
 		return error;
 
-	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
+	args->rmtblkno = (xfs_dablk_t)lfileoff;
 	args->rmtblkcnt = blkcnt;
 
-	/*
-	 * Roll through the "value", allocating blocks on disk as required.
-	 */
-	while (blkcnt > 0) {
-		/*
-		 * Allocate a single extent, up to the size of the value.
-		 *
-		 * Note that we have to consider this a data allocation as we
-		 * write the remote attribute without logging the contents.
-		 * Hence we must ensure that we aren't using blocks that are on
-		 * the busy list so that we don't overwrite blocks which have
-		 * recently been freed but their transactions are not yet
-		 * committed to disk. If we overwrite the contents of a busy
-		 * extent and then crash then the block may not contain the
-		 * correct metadata after log recovery occurs.
-		 */
-		nmap = 1;
-		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
-				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
-				  &nmap);
-		if (error)
-			return error;
-		error = xfs_defer_finish(&args->trans);
-		if (error)
-			return error;
-
-		ASSERT(nmap == 1);
-		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
-		       (map.br_startblock != HOLESTARTBLOCK));
-		lblkno += map.br_blockcount;
-		blkcnt -= map.br_blockcount;
+	return 0;
+}
 
-		/*
-		 * Start the next trans in the chain.
-		 */
-		error = xfs_trans_roll_inode(&args->trans, dp);
-		if (error)
-			return error;
-	}
+STATIC int
+xfs_attr_rmtval_set_value(
+	struct xfs_da_args	*args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	uint8_t			*src = args->value;
+	int			blkcnt;
+	int			valuelen;
+	int			nmap;
+	int			error;
+	int			offset = 0;
 
 	/*
 	 * Roll through the "value", copying the attribute value to the
@@ -550,6 +519,72 @@ xfs_attr_rmtval_set(
 }
 
 /*
+ * Write the value associated with an attribute into the out-of-line buffer
+ * that we have defined for it.
+ */
+int
+xfs_attr_rmtval_set(
+	struct xfs_da_args	*args)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+	int			nmap;
+	int			error;
+
+	trace_xfs_attr_rmtval_set(args);
+
+	error = xfs_attr_rmt_find_hole(args);
+	if (error)
+		return error;
+
+	blkcnt = args->rmtblkcnt;
+	lblkno = (xfs_dablk_t)args->rmtblkno;
+	/*
+	 * Roll through the "value", allocating blocks on disk as required.
+	 */
+	while (blkcnt > 0) {
+		/*
+		 * Allocate a single extent, up to the size of the value.
+		 *
+		 * Note that we have to consider this a data allocation as we
+		 * write the remote attribute without logging the contents.
+		 * Hence we must ensure that we aren't using blocks that are on
+		 * the busy list so that we don't overwrite blocks which have
+		 * recently been freed but their transactions are not yet
+		 * committed to disk. If we overwrite the contents of a busy
+		 * extent and then crash then the block may not contain the
+		 * correct metadata after log recovery occurs.
+		 */
+		nmap = 1;
+		error = xfs_bmapi_write(args->trans, dp, (xfs_fileoff_t)lblkno,
+				  blkcnt, XFS_BMAPI_ATTRFORK, args->total, &map,
+				  &nmap);
+		if (error)
+			return error;
+		error = xfs_defer_finish(&args->trans);
+		if (error)
+			return error;
+
+		ASSERT(nmap == 1);
+		ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
+		       (map.br_startblock != HOLESTARTBLOCK));
+		lblkno += map.br_blockcount;
+		blkcnt -= map.br_blockcount;
+
+		/*
+		 * Start the next trans in the chain.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, dp);
+		if (error)
+			return error;
+	}
+
+	return xfs_attr_rmtval_set_value(args);
+}
+
+/*
  * Remove the value associated with an attribute by deleting the
  * out-of-line buffer that it is stored on.
  */
-- 
2.7.4

