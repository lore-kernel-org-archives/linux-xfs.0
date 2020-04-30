Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70FAEC47254
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A014207DD
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cWQ1xADX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgD3Wwl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:52:41 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34496 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgD3Wwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:52:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMlXOq066938
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:52:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=XC/GdtIqkurGe0JLUk0M6SkoYOfdSSyW8MSVV7dm+B4=;
 b=cWQ1xADXO6g26CxIhkz+fBycxGkOwdquxDqJexJZgTuRDMBfuLtwSsMKB4ojuMKXxQ4u
 fOE6QL0XpanvIC+BHhBidKnjsBKuEgj/IPb2CbTnwZw1YwAuxcs4yZMpPbAci5QhKIj7
 YzfD8/u20sKCBU3psY14j9ZB1D8uXWEJpaSpgIpEj8ozNnW1s9mCTbRFbQXwdjoAKeUX
 T1ea53LDB9weBGq41yPKMjiCHsFpb6JLmQ9SSdPIwVVvUPkOOWfqnmcTHxkuoZo+B1YS
 pTwd9Z861S0g8A3MBogU0ysRvbPN7GV4du858dEMLM3D3zSizc+KUEH/Go39OT29bQcm +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30r7f802rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:52:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhPuP181233
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30r7fesaut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:39 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UModU1011580
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:50:39 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:50:38 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 24/24] xfs: Rename __xfs_attr_rmtval_remove
Date:   Thu, 30 Apr 2020 15:50:16 -0700
Message-Id: <20200430225016.4287-25-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430225016.4287-1-allison.henderson@oracle.com>
References: <20200430225016.4287-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=927 phishscore=0 suspectscore=1 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=986
 spamscore=0 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=1 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that xfs_attr_rmtval_remove is gone, rename __xfs_attr_rmtval_remove
to xfs_attr_rmtval_remove

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c        | 7 +++----
 fs/xfs/libxfs/xfs_attr_remote.c | 2 +-
 fs/xfs/libxfs/xfs_attr_remote.h | 3 +--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0751231..d76a970 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -874,7 +874,7 @@ xfs_attr_leaf_addname(
 		return error;
 das_rm_lblk:
 	if (args->rmtblkno) {
-		error = __xfs_attr_rmtval_remove(dac);
+		error = xfs_attr_rmtval_remove(dac);
 
 		if (error == -EAGAIN) {
 			dac->dela_state = XFS_DAS_RM_LBLK;
@@ -1244,8 +1244,7 @@ xfs_attr_node_addname(
 
 das_rm_nblk:
 	if (args->rmtblkno) {
-		error = __xfs_attr_rmtval_remove(dac);
-
+		error = xfs_attr_rmtval_remove(dac);
 		if (error == -EAGAIN) {
 			dac->dela_state = XFS_DAS_RM_NBLK;
 			return -EAGAIN;
@@ -1409,7 +1408,7 @@ xfs_attr_node_removename_rmt (
 	/*
 	 * May return -EAGAIN to request that the caller recall this function
 	 */
-	error = __xfs_attr_rmtval_remove(dac);
+	error = xfs_attr_rmtval_remove(dac);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index 7a342f1..21c7aa9 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -740,7 +740,7 @@ xfs_attr_rmtval_invalidate(
  * transaction and recall the function
  */
 int
-__xfs_attr_rmtval_remove(
+xfs_attr_rmtval_remove(
 	struct xfs_delattr_context	*dac)
 {
 	struct xfs_da_args		*args = dac->da_args;
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index 51a1c91..09fda56 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
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

