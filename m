Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A211C4725A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07B962074A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dfEEMcq/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgD3WrL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgD3WrK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhJQL063530
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=qS/huGSEeO0peQve8+GwCsv19WKf/nAFb30FHyNGCRo=;
 b=dfEEMcq/0buAjwUAnmvq3yonrrylBdko4vc0K67eh8o7KboUT2hL+ubS6Qi7EUXYGtJH
 vXdaMAn/y5PKF9qKsRuc9i8kqnAG5tlAVaL3dB2ZytbuV2sdRF1MYadnsgSyWiLZ4BXC
 YNOTc3jGBF4kCPXvHOjvVme1Hse1nKOXlhC0Bbrr+nDuKv4ZCubaFurnKdUV4libr0z3
 hX4oWV3zxDeaHZq/BI27TWqYNc5DohWcsP8BaOeQXBD/JpUlJcCAuSHzWam2msPEj6Fn
 I4Q/4/rBcQeJTnGkhsb8TmCL7GOrAOj+HV5r8acKHhoB6WZorDuW6dCKD6ymq/8AUE08 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30r7f8027w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgR19015834
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30r7f298fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMl8ft031992
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:08 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:08 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 12/43] xfsprogs: factor out a xfs_attr_match helper
Date:   Thu, 30 Apr 2020 15:46:29 -0700
Message-Id: <20200430224700.4183-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Factor out a helper that compares an on-disk attr vs the name, length and
flags specified in struct xfs_da_args.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr_leaf.c | 80 +++++++++++++++++++-------------------------------
 1 file changed, 30 insertions(+), 50 deletions(-)

diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index fb07d1d..86e3135 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -442,14 +442,21 @@ xfs_attr3_leaf_read(
  * Namespace helper routines
  *========================================================================*/
 
-/*
- * If namespace bits don't match return 0.
- * If all match then return 1.
- */
-STATIC int
-xfs_attr_namesp_match(int arg_flags, int ondisk_flags)
+static bool
+xfs_attr_match(
+	struct xfs_da_args	*args,
+	uint8_t			namelen,
+	unsigned char		*name,
+	int			flags)
 {
-	return XFS_ATTR_NSP_ONDISK(ondisk_flags) == XFS_ATTR_NSP_ARGS_TO_ONDISK(arg_flags);
+	if (args->namelen != namelen)
+		return false;
+	if (memcmp(args->name, name, namelen) != 0)
+		return false;
+	if (XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags) !=
+	    XFS_ATTR_NSP_ONDISK(flags))
+		return false;
+	return true;
 }
 
 static int
@@ -675,15 +682,8 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-#ifdef DEBUG
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		ASSERT(0);
-#endif
+		ASSERT(!xfs_attr_match(args, sfe->namelen, sfe->nameval,
+			sfe->flags));
 	}
 
 	offset = (char *)sfe - (char *)sf;
@@ -746,13 +746,9 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
 					base += size, i++) {
 		size = XFS_ATTR_SF_ENTSIZE(sfe);
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		break;
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			break;
 	}
 	if (i == end)
 		return -ENOATTR;
@@ -813,13 +809,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		return -EEXIST;
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			return -EEXIST;
 	}
 	return -ENOATTR;
 }
@@ -844,14 +836,10 @@ xfs_attr_shortform_getvalue(
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = XFS_ATTR_SF_NEXTENTRY(sfe), i++) {
-		if (sfe->namelen != args->namelen)
-			continue;
-		if (memcmp(args->name, sfe->nameval, args->namelen) != 0)
-			continue;
-		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
-			continue;
-		return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
-						sfe->valuelen);
+		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
+				sfe->flags))
+			return xfs_attr_copy_value(args,
+				&sfe->nameval[args->namelen], sfe->valuelen);
 	}
 	return -ENOATTR;
 }
@@ -2406,23 +2394,15 @@ xfs_attr3_leaf_lookup_int(
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			name_loc = xfs_attr3_leaf_name_local(leaf, probe);
-			if (name_loc->namelen != args->namelen)
-				continue;
-			if (memcmp(args->name, name_loc->nameval,
-							args->namelen) != 0)
-				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
+			if (!xfs_attr_match(args, name_loc->namelen,
+					name_loc->nameval, entry->flags))
 				continue;
 			args->index = probe;
 			return -EEXIST;
 		} else {
 			name_rmt = xfs_attr3_leaf_name_remote(leaf, probe);
-			if (name_rmt->namelen != args->namelen)
-				continue;
-			if (memcmp(args->name, name_rmt->name,
-							args->namelen) != 0)
-				continue;
-			if (!xfs_attr_namesp_match(args->flags, entry->flags))
+			if (!xfs_attr_match(args, name_rmt->namelen,
+					name_rmt->name, entry->flags))
 				continue;
 			args->index = probe;
 			args->rmtvaluelen = be32_to_cpu(name_rmt->valuelen);
-- 
2.7.4

