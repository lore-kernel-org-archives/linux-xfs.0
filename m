Return-Path: <SRS0=+s6N=D6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AF3C56201
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE05A2223F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Oct 2020 06:33:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GBvbn7lw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372801AbgJWGdV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:33:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37772 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S372794AbgJWGdV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Oct 2020 02:33:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6PgUB007908
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ewEZH27/H6DlCNeF1T35uLCSvIUuybdgdhBiWv9YSpU=;
 b=GBvbn7lwcZ5s9O6pPpJkYMXPmVandn2jr0Eag+sHL+sPdnZXgLP5kHr/1vua2aWr35eN
 2hTp3+Pjl3PKoaEEDLqjkw9oeWj4ypJ10/zqR/m+eYM36czQeGsM60l2NjRbNmPSuDwu
 L8iuZmwJD1ZiVdyoNPIm/C7q+Bl2cQezlT6TYBtqVyDOB9mK7pcE/BKya1shpDaMsBLp
 +Sp5WiWIIldMJUQsPIXOUwo+PBNBqXHZtu7TbKexGS/7buwEzAN1jbCjFy6Xult9u5uS
 2OuPQs2ebSeciE0KCbOxgcoAdpMtUUY8GY7qmGgCdU0KrtACjitLvnNc5YDQMbg9hAcw Kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 347p4b9du7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09N6P6G0178426
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 348aj0n97e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:19 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09N6XIMJ008354
        for <linux-xfs@vger.kernel.org>; Fri, 23 Oct 2020 06:33:18 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Oct 2020 23:33:18 -0700
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v13 06/14] xfsprogs: Rename __xfs_attr_rmtval_remove
Date:   Thu, 22 Oct 2020 23:32:58 -0700
Message-Id: <20201023063306.7441-7-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201023063306.7441-1-allison.henderson@oracle.com>
References: <20201023063306.7441-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9782 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010230045
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Collins <allison.henderson@oracle.com>

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_attr.c        | 7 +++----
 libxfs/xfs_attr_remote.c | 2 +-
 libxfs/xfs_attr_remote.h | 3 +--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 1cd3ae3..0cee4b17 100644
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
@@ -1234,8 +1234,7 @@ das_flip_flag:
 
 das_rm_nblk:
 	if (args->rmtblkno) {
-		error = __xfs_attr_rmtval_remove(dac);
-
+		error = xfs_attr_rmtval_remove(dac);
 		if (error == -EAGAIN) {
 			dac->dela_state = XFS_DAS_RM_NBLK;
 			return -EAGAIN;
@@ -1389,7 +1388,7 @@ xfs_attr_node_remove_rmt (
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

