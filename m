Return-Path: <SRS0=IYU2=A5=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85F56C433E4
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 667652083E
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Jul 2020 04:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qNwu5ZMU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgGREd4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Jul 2020 00:33:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:59536 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgGREdz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Jul 2020 00:33:55 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4Xt3D052582
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Q+KkLHzOQ9ZI2yAe1NyYt3D/QjTqiCxny0IUQn6DIVY=;
 b=qNwu5ZMURekD/BPT6gfc9TgViNENqLYHGdbryl62718OlDzS22VnH4UfBwKzBWHMq5f8
 qiN8OzDzMPozQyrl8pEbQjE7QZnJtZvlp2VYg3PHqrRLvaQLwQNhJ/s7MGrO6N8Qv0oI
 gBOQ56ldgn6SxhRhB9mZYFuTJco6Y5l/U1+ZmWUQNj2bP3m+dnReEZYO5xXL62oy2swc
 VLqHRIacoMC4bCwnuYmFUWxGXjcoOu8P6m7mACrBYDQkVHDN3lALWng9SNBzg/WaRY7Q
 VG3Gq8ng5AoXxcMkpiIlzScrfGk+Him9lkgL/4YqNjte6Ii9p/j+9dk2Zhg9aSzggU06 lw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 32bpkarbj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06I4XmAQ169379
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32brw1w79r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:54 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06I4XrPi003377
        for <linux-xfs@vger.kernel.org>; Sat, 18 Jul 2020 04:33:53 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 17 Jul 2020 21:33:53 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v11 09/26] xfsprogs: Factor out xfs_attr_rmtval_invalidate
Date:   Fri, 17 Jul 2020 21:33:25 -0700
Message-Id: <20200718043342.6432-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200718043342.6432-1-allison.henderson@oracle.com>
References: <20200718043342.6432-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=1 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007180030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9685 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007180030
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

