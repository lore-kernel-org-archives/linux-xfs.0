Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C394C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 161312081A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EeELMq58"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725275AbgFYXbV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:31:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52384 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFYXbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:31:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSJ0x012386
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:31:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=OPp3RBxrrzGf2jdzc30YG/U+R2IJ1/OkeUxnTjQ8ovQ=;
 b=EeELMq589aX6JUkqa482KH0/i/9+5wjEagIRTd5EWjJA8wNaz4cMoe3TggmtHE38C2c3
 xJtXECigK1J5k4XjiIvOD0DKnmhjNaMnLrdT5CGixKvuyul2VYsG9UTmQStqKg4WP883
 Y/k3Bv7ZZVGXkjvWpB0iVuX2igIs2WKiiFGkcykIQ3nbTo/OXvmoATdq4kAMiVWJLR22
 zJFgdZpXYcDl9/jZSQK2D3phrIxb6FyBizo/40Idv9/7SRZBM/TB5u8fRqLjo2RrUz/S
 eA2OFt0cALJw7cM1JEguYj1hl8VDp/ePjLswl0/So5DPAwTTNijqGsV/ag/OHYaGRPez fA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31uustu9aq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:31:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIu6117327
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31uuram0yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:03 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05PNT2fV016776
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:03 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:02 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 12/26] xfsprogs: Pull up xfs_attr_rmtval_invalidate
Date:   Thu, 25 Jun 2020 16:28:34 -0700
Message-Id: <20200625232848.14465-13-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=1 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch pulls xfs_attr_rmtval_invalidate out of
xfs_attr_rmtval_remove and into the calling functions.  Eventually
__xfs_attr_rmtval_remove will replace xfs_attr_rmtval_remove when we
introduce delayed attributes.  These functions are exepcted to return
-EAGAIN when they need a new transaction.  Because the invalidate does
not need a new transaction, we need to separate it from the rest of the
function that does.  This will enable __xfs_attr_rmtval_remove to
smoothly replace xfs_attr_rmtval_remove later.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c        | 12 ++++++++++++
 libxfs/xfs_attr_remote.c |  3 ---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 07ef88e..5580d61 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -670,6 +670,10 @@ xfs_attr_leaf_addname(
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				return error;
+
 			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
@@ -1028,6 +1032,10 @@ restart:
 		args->rmtblkcnt = args->rmtblkcnt2;
 		args->rmtvaluelen = args->rmtvaluelen2;
 		if (args->rmtblkno) {
+			error = xfs_attr_rmtval_invalidate(args);
+			if (error)
+				return error;
+
 			error = xfs_attr_rmtval_remove(args);
 			if (error)
 				return error;
@@ -1153,6 +1161,10 @@ xfs_attr_node_removename(
 		if (error)
 			goto out;
 
+		error = xfs_attr_rmtval_invalidate(args);
+		if (error)
+			return error;
+
 		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			goto out;
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 52e5574..07b7193 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -684,9 +684,6 @@ xfs_attr_rmtval_remove(
 
 	trace_xfs_attr_rmtval_remove(args);
 
-	error = xfs_attr_rmtval_invalidate(args);
-	if (error)
-		return error;
 	/*
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
-- 
2.7.4

