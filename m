Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ACB8C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C77A2087C
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MoYPCdxx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgH0A3W (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:29:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54692 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgH0A3W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:29:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0SwaU022042
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=RU0DvOHtt2QHGqvoQFveACAXdiOPg5k6jJKTzrEfWsM=;
 b=MoYPCdxx8pN/Wm6gkrDdx+nUt9iPe8kj2lkoh8915dirMsF/B6THs8SmUITXEOyvIEZB
 FjBgkFMN8B18opMagX9hU5SFF6PWf0lz9I/6NbR/E5P1L0DxV4o82NYWOYPUGUQVWySO
 zlyIZWLThrJdLc1UTfZC2ij3ZfxqQvW+gHtYaX7SL/+rvHKwFjkrvHyd8S5mlBnGW8X5
 2mIFbDb7ZUiplQ6af6dq3gmWvF5MHN8ZtldGPmRqD1Cr9mdOm9bVsVt10Ix8GYK7uZOp
 IZb77HhssYaOdVdDqWqtaEe7TRiO8h5LKwYhuoraeAYOf49oJfEH08UhAMnaBFHX9OS1 +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 335gw859e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0BN5U038152
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 333r9mk54s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:20 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0TJo7016970
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:29:19 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:29:19 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 25/32] xfsprogs: Rename __xfs_attr_rmtval_remove
Date:   Wed, 26 Aug 2020 17:28:49 -0700
Message-Id: <20200827002856.1131-26-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827002856.1131-1-allison.henderson@oracle.com>
References: <20200827002856.1131-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=1 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 mlxscore=0 phishscore=0 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 spamscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c        | 6 +++---
 libxfs/xfs_attr_remote.c | 2 +-
 libxfs/xfs_attr_remote.h | 3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 5444fb7..c98ae9d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -880,7 +880,7 @@ das_flip_flag:
 		return error;
 das_rm_lblk:
 	if (args->rmtblkno) {
-		error = __xfs_attr_rmtval_remove(dac);
+		error = xfs_attr_rmtval_remove(dac);
 		if (error == -EAGAIN)
 			dac->dela_state = XFS_DAS_RM_LBLK;
 		if (error)
@@ -1245,7 +1245,7 @@ das_flip_flag:
 
 das_rm_nblk:
 	if (args->rmtblkno) {
-		error = __xfs_attr_rmtval_remove(dac);
+		error = xfs_attr_rmtval_remove(dac);
 
 		if (error == -EAGAIN) {
 			dac->dela_state = XFS_DAS_RM_NBLK;
@@ -1404,7 +1404,7 @@ xfs_attr_node_remove_rmt (
 	/*
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
-	error = __xfs_attr_rmtval_remove(dac);
+	error = xfs_attr_rmtval_remove(dac);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index e8221d9..aa4aed8a 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -738,7 +738,7 @@ xfs_attr_rmtval_invalidate(
  * transaction and re-call the function
  */
 int
-__xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 84e2700..6ae91af 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -10,11 +10,10 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
 
 int xfs_attr_rmtval_get(struct xfs_da_args *args);
 int xfs_attr_rmtval_set(struct xfs_da_args *args);
-int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
 int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
-int __xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
+int xfs_attr_rmtval_remove(struct xfs_delattr_context *dac);
 int xfs_attr_rmt_find_hole(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
 int xfs_attr_rmtval_set_blk(struct xfs_delattr_context *dac);
-- 
2.7.4

