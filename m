Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF286C2BB54
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3FC32078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XhYCaGVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgDCWKQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45534 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728382AbgDCWKQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9jX8082648
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Q+KkLHzOQ9ZI2yAe1NyYt3D/QjTqiCxny0IUQn6DIVY=;
 b=XhYCaGVS5vCtXcl4Pmj9XeITMA5hqd7HopmDCbUDjbI7xvD+BIfeYVnrgRTm+tWVXZEY
 e4uXxwKGhzzpG9zC5VrDP3gmYHi6di75unSOb1QnWeuuas8+gy1fbiRgnFGGZ3RVhgQn
 P0a71T0Tgyzfe1fJeLq6dB8ZtGbUvhltRpRDT2Mu7ZSb9MJE4XmV8qZy6GEI8l/9Z0Ld
 kyXRUhyk9d9nMf6dBIQKZ5aPIugIqW6huacNKDK2nFFO2wjL7+z0PRqDeXTkC4SndabD
 PW0omlgI5X/ky3lXpWNR8dfYoMpTKoZ81puwd/IagvfwoT7xwXTLBH7pdLJImwwrpY1Y rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 303cevkdhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7KtW167903
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 304sju4cd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:13 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 033MAD5m015995
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:13 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:13 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 27/39] xfsprogs: Factor out xfs_attr_rmtval_invalidate
Date:   Fri,  3 Apr 2020 15:09:46 -0700
Message-Id: <20200403220958.4944-28-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=1 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
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
 libxfs/xfs_attr_remote.c | 26 +++++++++++++++++++++-----
 libxfs/xfs_attr_remote.h |  2 +-
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 6267cd6..e09c1b6 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -633,15 +633,12 @@ xfs_attr_rmtval_set(
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
@@ -669,13 +666,32 @@ xfs_attr_rmtval_remove(
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
diff --git a/libxfs/xfs_attr_remote.h b/libxfs/xfs_attr_remote.h
index 6fb4572..eff5f95 100644
--- a/libxfs/xfs_attr_remote.h
+++ b/libxfs/xfs_attr_remote.h
@@ -13,5 +13,5 @@ int xfs_attr_rmtval_set(struct xfs_da_args *args);
 int xfs_attr_rmtval_remove(struct xfs_da_args *args);
 int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
 		xfs_buf_flags_t incore_flags);
-
+int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
 #endif /* __XFS_ATTR_REMOTE_H__ */
-- 
2.7.4

