Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21712C433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0CD920885
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 23:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aFkOwgyI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgFYX3o (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Jun 2020 19:29:44 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51262 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732193AbgFYX3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jun 2020 19:29:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSdfs012469
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=0UHR8B7wojq8tbdLBQudQTJczNrludIikF9ENq9RCW4=;
 b=aFkOwgyImRTHmPKdpwvrMjMwnIzBcIjRmu2WSIwtoHGlqGXVCEKAhTvb0VlIy8ckX6k8
 bRLD39w3Lz/Y+vOEk6cYl0zHzjQ+1lpREf7veUGjIAcfsoetZpQtvGMqKLyxBlQUOueQ
 Eb6GRrYHyp+AQ7NJkFjsPQZUzxwepAlVi0Tjaf2jqeH1cWtbdtXM2ddFyWWKzXrKTTuM
 qCWBVDLNit7kdkNzN0ycpKW3nYPfn50C9DAJtGkrF+zt7XH2ZBWyN7zJYYhJFeZCnHxJ
 vRZpCV8FegSJjTIz/zcY16tq2W73RLweO9mDzxc7Iy0KbbSYHPvKb7aONlr4nsI8TObf pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31uustu969-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PNSIhg110930
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:09 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31uur9r3re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:09 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PNT8Jj015791
        for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2020 23:29:08 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 23:29:08 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v10 26/26] xfsprogs: Rename __xfs_attr_rmtval_remove
Date:   Thu, 25 Jun 2020 16:28:48 -0700
Message-Id: <20200625232848.14465-27-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200625232848.14465-1-allison.henderson@oracle.com>
References: <20200625232848.14465-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9663 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
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
index 729a44e..9492a94 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -868,7 +868,7 @@ das_flip_flag:
 		return error;
 das_rm_lblk:
 	if (args->rmtblkno) {
-		error = __xfs_attr_rmtval_remove(dac);
+		error = xfs_attr_rmtval_remove(dac);
 		if (error == -EAGAIN)
 			dac->dela_state = XFS_DAS_RM_LBLK;
 		if (error)
@@ -1233,7 +1233,7 @@ das_flip_flag:
 
 das_rm_nblk:
 	if (args->rmtblkno) {
-		error = __xfs_attr_rmtval_remove(dac);
+		error = xfs_attr_rmtval_remove(dac);
 
 		if (error == -EAGAIN) {
 			dac->dela_state = XFS_DAS_RM_NBLK;
@@ -1392,7 +1392,7 @@ xfs_attr_node_remove_rmt (
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
index 124f7ce..ede5f27 100644
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

