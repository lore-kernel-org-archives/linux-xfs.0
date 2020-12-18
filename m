Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B9DC2BBCF
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48EEA23A23
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Dec 2020 07:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgLRH2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:28:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56980 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732850AbgLRH2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Dec 2020 02:28:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7JpP2122087
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=A0uUNZRlbh7S/FaKkAp2OpNyCTtKQ6OviIlspknymRs=;
 b=ln3IVLRjog2fExlJTyFQyu6q2S/iu11enWCG3DNg6PNRuxGMerWeYkzcKdcRZXF4DG0B
 yv34sLUZjr5y9gXNmMgf5Oat99EuVf2s7K0O9U6RuvYLSt7Di6mpplb68myRdgltWurC
 hBz37ICmcvAjKP5TshbB+vGwGHXf+IxoPniE+rCmHAz+Hu8hchux/cTGlBv6S1/BsDpp
 UdhqokxbMRxe2OsLzCBK+rnzuPrJ0u19lJDdM5bEkJeHk/gClhBSSgamRSrq/K/j/r3I
 fADxRHnpNJlpoLqgNSdjIeuMajwRxnDxfK8QxjHVNwOcrQYL52XzFPNfgtML9EM0MQbF UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntmgy7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:28:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BI7LJVj119564
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35g3rft1uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:08 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BI7Q7FG002053
        for <linux-xfs@vger.kernel.org>; Fri, 18 Dec 2020 07:26:07 GMT
Received: from localhost.localdomain (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 23:26:07 -0800
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v14 07/14] xfsprogs: Rename __xfs_attr_rmtval_remove
Date:   Fri, 18 Dec 2020 00:25:48 -0700
Message-Id: <20201218072555.16694-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201218072555.16694-1-allison.henderson@oracle.com>
References: <20201218072555.16694-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012180052
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c        | 6 +++---
 libxfs/xfs_attr_remote.c | 2 +-
 libxfs/xfs_attr_remote.h | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index e15344d..d0c2364 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -895,7 +895,7 @@ das_flip_flag:
 	dac->dela_state = XFS_DAS_RM_LBLK;
 das_rm_lblk:
 	if (args->rmtblkno) {
-		error = __xfs_attr_rmtval_remove(dac);
+		error = xfs_attr_rmtval_remove(dac);
 		if (error == -EAGAIN)
 			trace_xfs_das_state_return(dac->dela_state);
 		if (error)
@@ -1263,7 +1263,7 @@ das_flip_flag:
 	dac->dela_state = XFS_DAS_RM_NBLK;
 das_rm_nblk:
 	if (args->rmtblkno) {
-		error = __xfs_attr_rmtval_remove(dac);
+		error = xfs_attr_rmtval_remove(dac);
 
 		if (error == -EAGAIN)
 			trace_xfs_das_state_return(dac->dela_state);
@@ -1410,7 +1410,7 @@ xfs_attr_node_remove_rmt (
 	/*
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
-	error = __xfs_attr_rmtval_remove(dac);
+	error = xfs_attr_rmtval_remove(dac);
 	if (error == -EAGAIN)
 		trace_xfs_das_state_return(dac->dela_state);
 	if (error)
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 543dd67..d08d8a4 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -736,7 +736,7 @@ xfs_attr_rmtval_invalidate(
  * transaction and re-call the function
  */
 int
-__xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 8ad68d5..6ae91af 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -13,7 +13,7 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
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

