Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A28FC6196
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C5FE21D79
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:30:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rR61URmO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbfKGBaA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:30:00 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43048 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732849AbfKGB35 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:29:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SxiE169998
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=PXUp+ANr+lG/jRqLhfjrGLV1WobWnOiY3LFvcXMKgro=;
 b=rR61URmOYoMMkh4JIDeXc/wE9lKtQqVYi+04O6teYw8IGR2iT7maHuU3Bumr17XbSzMg
 YW0msFDTM5GNNTA1KswYvaCS+rTE4/ML/YAtnP+J7oVIFQrUxWeTF+I84UDm/Owv4G5r
 ZVrQMxyYj6cY7PgfXpuNGaZ77ozoL/Z6SPgNaMfazvc5Cnc6R0VgfctBNbG3QCGeo+ch
 xiQR3jxVrCJPSAiZNMpbc701+B5bB+xW9y1sHCBmRFJHkjYcnddJe5Y7XtPYLFfJ1oyZ
 fat8N4aEyesXYtld0wrSvesionuhqMk15A4ftcA8yvShTidXIWuovEgvii+V/Gir8dEp vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w41w0tq1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71Sk1W088146
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w41wfefbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:55 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71Tsi8011848
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:54 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:29:54 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 14/17] xfsprogs: Add delay context to xfs_da_args
Date:   Wed,  6 Nov 2019 18:29:42 -0700
Message-Id: <20191107012945.22941-15-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012945.22941-1-allison.henderson@oracle.com>
References: <20191107012945.22941-1-allison.henderson@oracle.com>
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

This patch adds a new struct xfs_delay_context, which we
will use to keep track of the current state of a delayed
attribute operation.

The new enum is used to track various operations that
are in progress so that we know not to repeat them, and
resume where we left off before EAGAIN was returned to
cycle out the transaction.  Other members take the place
of local variables that need to retain their values
across multiple function recalls.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_da_btree.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index eb3eb95..f5efb6d 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -42,6 +42,33 @@ enum xfs_dacmp {
 	XFS_CMP_CASE		/* names are same but differ in case */
 };
 
+enum xfs_attr_state {
+	XFS_DC_INIT		= 1, /* Init delay info */
+	XFS_DC_SF_TO_LEAF	= 2, /* Converted short form to leaf */
+	XFS_DC_FOUND_LBLK	= 3, /* We found leaf blk for attr */
+	XFS_DC_LEAF_TO_NODE	= 4, /* Converted leaf to node */
+	XFS_DC_FOUND_NBLK	= 5, /* We found node blk for attr */
+	XFS_DC_ALLOC_LEAF	= 6, /* We are allocating leaf blocks */
+	XFS_DC_ALLOC_NODE	= 7, /* We are allocating node blocks */
+	XFS_DC_RM_INVALIDATE	= 8, /* We are invalidating blocks */
+	XFS_DC_RM_SHRINK	= 9, /* We are shrinking the tree */
+	XFS_DC_RM_NODE_BLKS	= 10,/* We are removing node blocks */
+};
+
+/*
+ * Context used for keeping track of delayed attribute operations
+ */
+struct xfs_delay_context {
+	enum xfs_attr_state	dc_state;
+	struct xfs_buf		*leaf_bp;
+	struct xfs_bmbt_irec	map;
+	xfs_dablk_t		lblkno;
+	xfs_fileoff_t		lfileoff;
+	int			blkcnt;
+	struct xfs_da_state	*da_state;
+	struct xfs_da_state_blk *blk;
+};
+
 /*
  * Structure to ease passing around component names.
  */
@@ -69,6 +96,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	int		op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	struct xfs_delay_context  dc;	/* context used for delay attr ops */
 } xfs_da_args_t;
 
 /*
-- 
2.7.4

