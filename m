Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85296C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58CD7206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j7pjnEKe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgAABPr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:15:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55446 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:15:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011FHi7092633
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=xc910/eAIofoIfFeMb5BlKHx0pzwOgvmMsdzIa2cxgg=;
 b=j7pjnEKeu+AbiI44G7SD8dUyapcE7fa+gMaJIYKh8fQKfoKPaVeTcRFbSmn1ebUgxTR3
 uLQ2jgAMVx97vj8rfFCbDgUebCBIgy67wECYzMyrxwngeaTKojSbio/eoBysi1q71zg1
 TvoDpTydTxNWSnRDH3h9Tn0fqalft4sI7RWZW1z0gd9wnlP0yiUE9I9akLqB0HivjuJ8
 xcKDzAlJveVEIya+wm+TBbWClvErMCZDuksEYpCrqkywyEHSI24V6dg+AMUwxMizok9h
 vgtKd5L/g27lZBhhx0cJAsXlB1/HP7Go2pfocG8jszlNVQkF5WeIFpGFzIlAjx1oXtdF XA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2x5y0pjy28-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001190KB012541
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2x8guef7gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:15:44 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011Fhlq001296
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:15:44 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:15:43 -0800
Subject: [PATCH 08/13] xfs: convert metadata inode lookup keys to use paths
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:15:41 -0800
Message-ID: <157784134126.1366873.9292484440702167558.stgit@magnolia>
In-Reply-To: <157784129036.1366873.17175097590750371047.stgit@magnolia>
References: <157784129036.1366873.17175097590750371047.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=951
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert the magic metadata inode lookup keys to use actual strings
for paths.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_imeta.c |   48 ++++++++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_imeta.h |   17 ++++++++++++++--
 2 files changed, 41 insertions(+), 24 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index aadba5786d1c..ca62ef6255eb 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -47,26 +47,17 @@
  */
 
 /* Static metadata inode paths */
-
-const struct xfs_imeta_path XFS_IMETA_RTBITMAP = {
-	.bogus = 0,
-};
-
-const struct xfs_imeta_path XFS_IMETA_RTSUMMARY = {
-	.bogus = 1,
-};
-
-const struct xfs_imeta_path XFS_IMETA_USRQUOTA = {
-	.bogus = 2,
-};
-
-const struct xfs_imeta_path XFS_IMETA_GRPQUOTA = {
-	.bogus = 3,
-};
-
-const struct xfs_imeta_path XFS_IMETA_PRJQUOTA = {
-	.bogus = 4,
-};
+static const char *rtbitmap_path[]	= {"realtime", "0.bitmap"};
+static const char *rtsummary_path[]	= {"realtime", "0.summary"};
+static const char *usrquota_path[]	= {"quota", "user"};
+static const char *grpquota_path[]	= {"quota", "group"};
+static const char *prjquota_path[]	= {"quota", "project"};
+
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTBITMAP,	rtbitmap_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTSUMMARY,	rtsummary_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_USRQUOTA,	usrquota_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_GRPQUOTA,	grpquota_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_PRJQUOTA,	prjquota_path);
 
 /* Are these two paths equal? */
 STATIC bool
@@ -74,7 +65,20 @@ xfs_imeta_path_compare(
 	const struct xfs_imeta_path	*a,
 	const struct xfs_imeta_path	*b)
 {
-	return a == b;
+	unsigned int			i;
+
+	if (a == b)
+		return true;
+
+	if (a->im_depth != b->im_depth)
+		return false;
+
+	for (i = 0; i < a->im_depth; i++)
+		if (a->im_path[i] != b->im_path[i] &&
+		    strcmp(a->im_path[i], b->im_path[i]))
+			return false;
+
+	return true;
 }
 
 /* Is this path ok? */
@@ -82,7 +86,7 @@ static inline bool
 xfs_imeta_path_check(
 	const struct xfs_imeta_path	*path)
 {
-	return true;
+	return path->im_depth <= XFS_IMETA_MAX_DEPTH;
 }
 
 /* Functions for storing and retrieving superblock inode values. */
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 5321dba38bbe..6caf5b16f8d7 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -6,10 +6,23 @@
 #ifndef __XFS_IMETA_H__
 #define __XFS_IMETA_H__
 
+/* How deep can we nest metadata dirs? */
+#define XFS_IMETA_MAX_DEPTH	64
+
+/* Form an imeta path from a simple array of strings. */
+#define XFS_IMETA_DEFINE_PATH(name, path) \
+const struct xfs_imeta_path name = { \
+	.im_path = (path), \
+	.im_depth = ARRAY_SIZE(path), \
+}
+
 /* Key for looking up metadata inodes. */
 struct xfs_imeta_path {
-	/* Temporary: integer to keep the static imeta definitions unique */
-	int		bogus;
+	/* Array of string pointers. */
+	const char	**im_path;
+
+	/* Number of strings in path. */
+	unsigned int	im_depth;
 };
 
 /* Cleanup widget for metadata inode creation and deletion. */

