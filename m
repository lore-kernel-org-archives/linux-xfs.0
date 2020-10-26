Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47949C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10687206FB
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GQi7sYNA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407277AbgJZXi5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57446 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407243AbgJZXi5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOYRr164646;
        Mon, 26 Oct 2020 23:37:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=KohxyGNpGIf15wU0bwz0IhsENY/DAXMiVmFvWUVCHaM=;
 b=GQi7sYNAu1EjKblPUuBNIMAG4Hq5TxVDI5Dr7TcZJConaXkSqNLTd8tEG4aDDysfZgcu
 wCacrC+XHykUYBrdeSHTfncG54R2WCCGZ2f3ODooTMjIhfx3yOwLiHt0noyWX4SpCwq5
 DqQBky3j0qZQI/hdBQIdo9zsXHhJ3Kwjg44nuvWgwd3UnycrLprWftysSNhuaai86KRH
 qzzDf3mpvug+SxWitKOAYI2sQTrnkM72VrBozD7oWF9ZPdIbcJRau6AiRh7szZMkT7bR
 SiuflY18R7r/d5cEZNWF8DheZHP+jHKJYWgbJPMPtPeiEflu25+iU9wf1foDqwQWgMEl VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm3vuwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:37:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxqI110514;
        Mon, 26 Oct 2020 23:37:49 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 34cx5wftju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:37:49 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNbnrL013763;
        Mon, 26 Oct 2020 23:37:49 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:37:49 -0700
Subject: [PATCH 08/21] xfs: fix some comments
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Kaixu Xia <kaixuxia@tencent.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:37:48 -0700
Message-ID: <160375546810.882906.11162309682890581251.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Source kernel commit: a647d109e08ac0961ca0fd511b013d962d256987

Fix the comments to help people understand the code.

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
[darrick: fix the indenting problems too]
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_da_format.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index b40a4e80f5ee..0af44c4e4fdf 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -15,8 +15,8 @@
  */
 #define XFS_DA_NODE_MAGIC	0xfebe	/* magic number: non-leaf blocks */
 #define XFS_ATTR_LEAF_MAGIC	0xfbee	/* magic number: attribute leaf blks */
-#define	XFS_DIR2_LEAF1_MAGIC	0xd2f1	/* magic number: v2 dirlf single blks */
-#define	XFS_DIR2_LEAFN_MAGIC	0xd2ff	/* magic number: v2 dirlf multi blks */
+#define XFS_DIR2_LEAF1_MAGIC	0xd2f1	/* magic number: v2 dirlf single blks */
+#define XFS_DIR2_LEAFN_MAGIC	0xd2ff	/* magic number: v2 dirlf multi blks */
 
 typedef struct xfs_da_blkinfo {
 	__be32		forw;			/* previous block in list */
@@ -35,8 +35,8 @@ typedef struct xfs_da_blkinfo {
  */
 #define XFS_DA3_NODE_MAGIC	0x3ebe	/* magic number: non-leaf blocks */
 #define XFS_ATTR3_LEAF_MAGIC	0x3bee	/* magic number: attribute leaf blks */
-#define	XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v2 dirlf single blks */
-#define	XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v2 dirlf multi blks */
+#define XFS_DIR3_LEAF1_MAGIC	0x3df1	/* magic number: v3 dirlf single blks */
+#define XFS_DIR3_LEAFN_MAGIC	0x3dff	/* magic number: v3 dirlf multi blks */
 
 struct xfs_da3_blkinfo {
 	/*
@@ -61,7 +61,7 @@ struct xfs_da3_blkinfo {
  * Since we have duplicate keys, use a binary search but always follow
  * all match in the block, not just the first match found.
  */
-#define	XFS_DA_NODE_MAXDEPTH	5	/* max depth of Btree */
+#define XFS_DA_NODE_MAXDEPTH	5	/* max depth of Btree */
 
 typedef struct xfs_da_node_hdr {
 	struct xfs_da_blkinfo	info;	/* block type, links, etc. */

