Return-Path: <SRS0=jPpR=BA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6232EC433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FF0922B4E
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Jul 2020 00:16:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OdLPQuvT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgGUAQT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jul 2020 20:16:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728098AbgGUAQS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jul 2020 20:16:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L02coR102320
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4TmYFY+AiU2LxCiJfQlyPOeB4zJ8IjcqHif2q/ESs74=;
 b=OdLPQuvT4kkymQdPeP0W0xf0+Kq5Z1YSPMc6bvlajyivJwh8ieAMavPOHkk4kCVLGrLy
 s6Gi7biqTkVEwsCcqz4avzLGfm2PPRVVpVEhH2QA5M1gp1r4UsnN4Sj7qtFUi76c+XPp
 aPtekicJgZlh3sdOpqZshHH9y4wIHuHwObYPISyQqRN5dP1iQv+CDF60BbuVJQc3Dpyz
 fFkcZgNz+1Abn+eIs6cKAEolaOoAsXo7hTOuZFETMizqCAHNmQLzGDmgdVROo7lbzXVL
 kPGBAlddStxgwVEHLmlHYmg+suea+lu1NpaXuJSc2fmzlCEG3Gy4CCIOgBj1UeIv/7Ds tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32brgr9ymg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L0E6B1009204
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32dnafgn53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:16 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L0GFbi027079
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 00:16:15 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jul 2020 17:16:14 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 08/25] xfs: Factor out xfs_attr_rmtval_invalidate
Date:   Mon, 20 Jul 2020 17:15:49 -0700
Message-Id: <20200721001606.10781-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721001606.10781-1-allison.henderson@oracle.com>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 spamscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=1 adultscore=0 clxscore=1015 mlxlogscore=999
 priorityscore=1501 phishscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007200146
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Because new delayed attribute routines cannot roll transactions, we
carve off the parts of xfs_attr_rmtval_remove that we can use.  This
will help to reduce repetitive code later when we introduce delayed
attributes.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 26 +++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_attr_remote.h |  2 +-
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index f825eed..4d51969 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -634,15 +634,12 @@ xfs_attr_rmtval_set(
  * out-of-line buffer that it is stored on.
  */
 int
-xfs_attr_rmtval_remove(
+xfs_attr_rmtval_invalidate(
 	struct xfs_da_args	*args)
 {
 	xfs_dablk_t		lblkno;
 	int			blkcnt;
 	int			error;
-	int			done;
-
-	trace_xfs_attr_rmtval_remove(args);
 
 	/*
 	 * Roll through the "value", invalidating the attribute value's blocks.
@@ -670,13 +667,32 @@ xfs_attr_rmtval_remove(
 		lblkno += map.br_blockcount;
 		blkcnt -= map.br_blockcount;
 	}
+	return 0;
+}
 
+/*
+ * Remove the value associated with an attribute by deleting the
+ * out-of-line buffer that it is stored on.
+ */
+int
+xfs_attr_rmtval_remove(
+	struct xfs_da_args      *args)
+{
+	xfs_dablk_t		lblkno;
+	int			blkcnt;
+	int			error = 0;
+	int			done = 0;
+
+	trace_xfs_attr_rmtval_remove(args);
+
+	error = xfs_attr_rmtval_invalidate(args);
+	if (error)
+		return error;
 	/*
 	 * Keep de-allocating extents until the remote-value region is gone.
 	 */
 	lblkno = args->rmtblkno;
 	blkcnt = args->rmtblkcnt;
-	done = 0;
 	while (!done) {
 		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
 				    XFS_BMAPI_ATTRFORK, 1, &done);
diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
index e1144f2..3616e88 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.h
+++ b/fs/xfs/libxfs/xfs_attr_remote.h
@@ -13,5 +13,5 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
-
+int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

